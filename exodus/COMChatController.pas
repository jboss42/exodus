unit COMChatController;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ExodusPlugins_TLB, 
    Session, ChatController, ChatWin, Chat,
    Classes, ComObj, ActiveX, Register_TLB, StdVcl;

type
  TExodusChat = class(TAutoObject, IExodusChat)
  protected
    function Get_jid: WideString; safecall;
    function AddContextMenu(const Caption: WideString): WideString; safecall;
    function Get_MsgOutText: WideString; safecall;
    function UnRegister(ID: Integer): WordBool; safecall;
    function RegisterPlugin(var Plugin: OleVariant): Integer; safecall;
    { Protected declarations }

  public
    constructor Create();
    destructor Destroy(); override;

    procedure setChatSession(chat_session: TChatController);
    procedure fireMsgKeyPress(Key: Char);
    procedure fireBeforeMsg(var body: Widestring);
    procedure fireAfterMsg(var body: WideString; var xml: Widestring);

  private
    _chat: TChatController;
    _plugs: TList;

  end;

  TChatPlugin = class
    com: IExodusChatPlugin;
    end;


implementation

uses ComServ;

constructor TExodusChat.Create();
begin
    inherited Create();
    _plugs := TList.Create();
end;

destructor TExodusChat.Destroy();
var
    i: integer;
begin
    for i := 0 to _plugs.Count - 1 do begin
        // todo: send chat plugins a shutdown signal
        TChatPlugin(_plugs[i]).Free();
        end;
    _plugs.Clear();
    _plugs.Free();

    inherited Destroy();
end;


procedure TExodusChat.setChatSession(chat_session: TChatController);
begin
    _chat := chat_session;
end;

procedure TExodusChat.fireMsgKeyPress(Key: Char);
var
    i: integer;
begin
    for i := 0 to _plugs.count - 1 do
        TChatPlugin(_plugs[i]).com.onKeyPress(Key);
end;

procedure TExodusChat.fireBeforeMsg(var body: Widestring);
var
    i: integer;
begin
    for i := 0 to _plugs.Count - 1 do
        TChatPlugin(_plugs[i]).com.onBeforeMessage(body);
end;

procedure TExodusChat.fireAfterMsg(var body: WideString; var xml: Widestring);
var
    i: integer;
begin
    for i := 0 to _plugs.Count - 1 do
        TChatPlugin(_plugs[i]).com.onAfterMessage(body, xml);
end;

function TExodusChat.Get_jid: WideString;
begin
    Result := _chat.JID;
end;

function TExodusChat.AddContextMenu(const Caption: WideString): WideString;
begin
    // todo: plugins
    // add a menu to the window
    // return an "ID" for this menu/window combo
end;

function TExodusChat.Get_MsgOutText: WideString;
begin
    Result := TfrmChat(_chat.window).MsgOut.Text;
end;

function TExodusChat.UnRegister(ID: Integer): WordBool;
var
    cp: TChatPlugin;
begin
    if ((id >= 0) and (id < _plugs.count)) then begin
        cp := TChatPlugin(_plugs[id]);
        cp.Free();
        _plugs.Delete(id);
        Result := true;
        end
    else
        Result := false;
end;

function TExodusChat.RegisterPlugin(var Plugin: OleVariant): Integer;
var
    p: IExodusChatPlugin;
    cp: TChatPlugin;
begin
    cp := TChatPlugin.Create;
    p := IUnknown(Plugin) as IExodusChatPlugin;
    cp.com := p;
    Result := _plugs.Add(cp);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusChat, Class_ExodusChat,
    ciMultiInstance, tmApartment);
end.
