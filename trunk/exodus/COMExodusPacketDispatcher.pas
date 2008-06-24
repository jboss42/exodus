unit COMExodusPacketDispatcher;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Signals, Unicode, XMLTag, XMLStream,
    ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusPacketDispatcher = class(TAutoObject, IExodusPacketDispatcher)
  private
    _listenersByXPath: TWidestringList;
  protected
    procedure InitializeStreamListener();
    procedure UninitializeStreamListener();

    procedure PacketControlCallback(direction: TPacketDirection;
                                    const inPacket: TXMLTag;
                                    var outPacket: TXMLTag;
                                    var allow: WordBool);
  public
    procedure RegisterPacketControlListener(const xpath: WideString;
      const listener: IExodusPacketControlListener); safecall;
    procedure UnregisterPacketControlListener(const xpath: WideString;
      const listener: IExodusPacketControlListener); safecall;
  end;

implementation

uses Session, Classes, SysUtils, ComServ;

type
    TPacketListener = class
    private
        _xp: TXPLite;
        _xpStr: widestring;
        _listeners: TInterfaceList;
        _listUpdated: boolean;
        _currentList: TInterfaceList;
        
        function GetListeners(): TInterfaceList;
    public
        constructor Create(xpStr: widestring);
        destructor Destroy(); override;

        function IsMatch(tag: TXMLtag): boolean;

        procedure AddListener(listener: IExodusPacketControlListener);
        procedure RemoveListener(listener: IExodusPacketControlListener);

        property Listeners: TInterfaceList read GetListeners;
    end;

constructor TPacketListener.Create(xpStr: widestring);
begin
    _xpStr := Trim(xpStr);
    _xp.Parse(xpStr);

    _listeners := TInterfaceList.create();
    _currentList := TInterfaceList.create();
    _listUpdated := false;
end;

destructor TPacketListener.Destroy();
begin
    _xp.free();
    _listeners.Free();
    _currentList.Free();
end;

function TPacketListener.GetListeners(): TInterfaceList;
var
    i: integer;
begin
    //update current list if needed
    if (_listUpdated) then
    begin
        _currentList.Clear();
        for i := 0 to _listeners.Count - 1 do
            _currentList.Add(_listeners[i]);
        _listUpdated := false;
    end;
    Result := _currentList;
end;

function TPacketListener.IsMatch(tag: TXMLtag): boolean;
begin
    Result :=  (_listeners.count > 0) and ((_xpStr = '') or _xp.Compare(tag));
end;

procedure TPacketListener.AddListener(listener: IExodusPacketControlListener);
begin
    _listeners.Add(listener);
    _listUpdated := true;
end;

procedure TPacketListener.RemoveListener(listener: IExodusPacketControlListener);
begin
    _listeners.remove(listener);
    _listUpdated := true;
end;


procedure TExodusPacketDispatcher.InitializeStreamListener();
begin
    if (_listenersByXPath.Count = 1) then
    begin
        Session.MainSession.Stream.RegisterPacketControlCallback(PacketControlCallback);
    end;
end;

procedure TExodusPacketDispatcher.UninitializeStreamListener();
begin
    if (_listenersByXPath.Count = 0) then
    begin
        Session.MainSession.Stream.UnregisterPacketControlCallback(PacketControlCallback);
    end;
end;

procedure TExodusPacketDispatcher.RegisterPacketControlListener(
  const xpath: WideString; const listener: IExodusPacketControlListener);
var
    idx : integer;
    tpl: TPacketListener;
begin
    if (_listenersByXPath = nil) then
        _listenersByXPath := TWidestringList.create();
    idx := _listenersByXPath.IndexOf(xpath);
    if (idx <> -1) then
        tpl := TPacketListener(_listenersByXPath.objects[idx])
    else begin 
        tpl := TPacketListener.Create(xpath);
        _listenersByXPath.AddObject(xpath, tpl);
    end;
    tpl.AddListener(listener);
    InitializeStreamListener();
end;

procedure TExodusPacketDispatcher.UnregisterPacketControlListener(
  const xpath: WideString; const listener: IExodusPacketControlListener);
var
    idx : integer;
    tpl: TPacketListener;
begin
    if (_listenersByXPath = nil) then
        _listenersByXPath := TWidestringList.create();

    idx := _listenersByXPath.IndexOf(xpath);
    if (idx <> -1) then
    begin
        tpl := TPacketListener(_listenersByXPath.objects[idx]);
        tpl.RemoveListener(listener);        
    end;
end;

procedure TExodusPacketDispatcher.PacketControlCallback(direction: TPacketDirection;
                                                        const inPacket: TXMLTag;
                                                        var outPacket: TXMLTag;
                                                        var allow: WordBool);
var
    i, j: integer;
    inXML, modXML : IExodusEventXML;
    l: TPacketListener;
    ListenerList: TInterfaceList;
    setMod: boolean;
begin
    outPacket := nil;
    Allow := true;
    setMod := false;

    inXML := CoExodusEventXML.Create() as IExodusEventXML;
    inXML.SetTag(Integer(inPacket)); //copies packet, inXML owns its copy

    modXML := CoExodusEventXML.Create() as IExodusEventXML;

    try
        //walk xpath list and fire listeners until not allowed or done
        for i := 0 to _listenersByXPath.Count - 1 do
        begin
            l :=  TPacketListener(_listenersByXPath.Objects[i]);

            if l.IsMatch(TXMLtag(Pointer(inXML.GetTag()))) then
            begin
                ListenerList := TPacketListener(_listenersByXPath.Objects[i]).Listeners;
                for j := 0 to ListenerList.Count - 1 do
                begin
                    if (direction = pdInbound) then
                        IExodusPacketControlListener(ListenerList[j]).OnPacketReceived(l._xpStr, InXML, modXML, allow)
                    else
                        IExodusPacketControlListener(ListenerList[j]).OnPacketSent(l._xpStr, inXML, modXML, allow);

                    if (not allow) then exit;

                    if (modXML.GetTag <> 0) then
                    begin
                        setMod := true;
                        inXML.SetTag(modXML.GetTag);  //set makes a copy
                        modXML.SetTag(0); //nil
                        //check to see if changed tag still matches xpath
                        if (not l.IsMatch(TXMLtag(Pointer(inXML.GetTag())))) then break;
                    end;
                end;
            end;
        end;

        if (setMod) then
            outPacket := TXMLtag.create(TXMLtag(Pointer(inXML.GetTag())));
    finally
        inXML := nil;
        modXML := nil;
    end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusPacketDispatcher, Class_ExodusPacketDispatcher,
    ciMultiInstance, tmApartment);
end.
