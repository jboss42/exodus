unit SIGQuickChatPlugin;
{
    Copyright © 2006 Susquehanna International Group, LLP.
    Author: Dave Siracusa
}

{$WARN SYMBOL_PLATFORM OFF}
{$DEFINE REQUEST_DISCO_IN_ORDER_TO_OBTAIN_JUD TRUE}
{$DEFINE FILTER}
interface

uses
    Exodus_TLB, XMLParser, SysUtils,
    DB, DBTables, DBClient, ActiveFormImpl, Controller, Options,
    Classes, ComObj, ActiveX, SIGQuickChat_TLB, StdVcl, XMLTag, Unicode, Windows, JclStrings;

const
    DEBUGLEVEL:       Integer = 1;

    SHOWEXCEPTIONS:   Boolean = true;

    REQUESTINGID1 = 'qc_1';
    REQUESTINGID2 = 'qc_2';

{$IFDEF OTHER_LISTENERS}
    EVENTDATA1    = '/packet';
    EVENTDATA2    = '/presence';
    EVENTDATA3    = '/data';
    EVENTDATA4    = '/roster';
    EVENTDATA5    = '/chat';
{$ENDIF}

    EVENTDATA6    = '/session';
    EVENTDATA7    = '/packet/iq/query/exodus/field';
    EVENTDATA8    = '/packet/iq/query[@xmlns="jabber:iq:search"]';
    EVENTDATA9    = '/packet/iq/query[@xmlns="http://jabber.org/protocol/disco#items"]/item';
    EVENTDATA10   = '/packet/iq/query[@xmlns="http://jabber.org/protocol/disco#info"]';

    SQUICKCHAT    = '/packet/iq/query/exodus/field';
    SSEARCH       = '/packet/iq/query[@xmlns="jabber:iq:search"]';
    SDISCOITEMS   = '/packet/iq/query[@xmlns="http://jabber.org/protocol/disco#items"]/item';
    SDISCOINFO    = '/packet/iq/query[@xmlns="http://jabber.org/protocol/disco#info"]';

    SSESSION      = '/session';
    SCONNECTED    = '/session/authenticated';
    SDISCONNECTED = '/session/disconnected';
    SENTITYINFO   = '/session/entity/info';

    QUICKCHAT     = 'Quick Chat';
    QCLASTNAMEPRE = 'QCLastNameField-';

    NUMQC = 15;

type
   TJID = class(TObject)
    public
         constructor  Create(); overload;
         constructor  Create(jid: WideString; name: WideString); overload;
         function     Same(ojid: TJID): Bool;

         procedure    Copy(ojid: TJID);
         procedure    Clear();
         function     Clone(): TJID;
         function     IsEmpty(): Bool;

         function     GetName(): String;
         procedure    SetName(name: string);
         function     GetJid(): String;
         procedure    SetJid(jid: string);
         Property     Name : string read GetName write SetName;
         Property     Jid : string  read GetJid write SetJid;
    private
        _jid:         Widestring;
        _name:        Widestring;
    end;
  TSIGQuickChatPlugin = class(TAutoObject, IExodusPlugin, IExodusMenuListener,  IController)
  protected
    function  NewIM(const jid: WideString; var Body, Subject: WideString; const XTags: WideString): WideString; safecall;
    procedure Configure; safecall;
    procedure MenuClick(const ID: WideString); safecall;
    procedure MsgMenuClick(const ID, jid: WideString; var Body, Subject: WideString); safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat); safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat); safecall;
    procedure Process(const xpath, event, xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(const ExodusController: IExodusController); safecall;
    procedure NewOutgoingIM(const jid: WideString; const InstantMsg: IExodusChat); safecall;

    procedure OnMenuItemClick(const menuID : WideString; const xml : WideString); safecall;

  private
    _searchField:     WideString;
    _judFields:       TWideStringList;
    _exodus:          IExodusController;
    _loaded:          boolean;
    _connected:       boolean;

{$IFDEF OTHER_LISTENERS}
    _event1:          integer;
    _event2:          integer;
    _event3:          integer;
    _event4:          integer;
    _event5:          integer;
{$ENDIF}

    _event6:          integer;
    _event7:          integer;
    _event8:          integer;
    _event9:          integer;
    _event10:         integer;

    _qclist:          array[0..NUMQC] of TJID;
    _qcDataSet:       TClientDataSet;
    _sjid:            string;
    _menu_id:         WideString;

    // Todo: I pull back the active form via sington (global), another way to do it
    //       would be to implement a GetControl therby pulling back the control (COM).
    function  GetActiveForm(): ActiveFormImpl.TActiveFormX;

    procedure RequestQuickChatListFromServer();
    procedure SaveQuickChatListOnServer();
    procedure UpdateRecentQCList(ojid: TJID);
    procedure Connected();
    procedure Disconnected();
    procedure EnableControl();
    procedure DisableControl();
    procedure PopulateControlWithQuickChat();

    procedure RequestSearchJid();
    procedure RequestJudFields();
    procedure RequestSearch(searchString: String);
    procedure RequestDiscoInfo(jid: widestring);
    function  OrdinalPosOfLast():Integer;

    function  JIDFromName(searchString: string): string;
    procedure UpdateRoster();

    property  ActiveForm: ActiveFormImpl.TActiveFormX read GetActiveForm;

    procedure ProcessSearch(const tag:TXMLTag);
    procedure ProcessSearchList(const tag:TXMLTag);
    procedure ProcessSearchFields(const tag:TXMLTag);
    procedure ProcessQuickChatList(const tag:TXMLTag);
    procedure ProcessDiscoItems(const tag:TXMLTag);
    procedure ProcessDiscoInfo(const tag:TXMLTag);
    procedure ProcessEntityInfo(const tag:TXMLTag);

    procedure InitSearchField();
    function  InvokeOptionsMenu(): WideString;

 published
    procedure Search(searchString: string);
    procedure PopulateControlWithSearchResults();
    procedure Selected(selectString: String);
    procedure ExodusDebug(level: Integer; msg: String);
    procedure RestoreQuickChatList();
    procedure ClearQuickChat();

  end;

{---------------------------------------}
{---------------------------------------}
procedure Debug(enabled: boolean; const S: String);

{---------------------------------------}
var
    _MustBeReLoaded: Boolean;

implementation
uses
    Controls, ComServ, Dialogs;

{---------------------------------------}
{---------------------------------------}
// Global Routines
function SearchAndReplace(sSrc, sLookFor, sReplaceWith : string) : string;
var
   nPos, nLenLookFor : integer;
begin
   nPos := Pos(sLookFor, sSrc) ;
   nLenLookFor := Length(sLookFor) ;
   while (nPos > 0) do begin
     Delete(sSrc, nPos, nLenLookFor) ;
     Insert(sReplaceWith, sSrc, nPos) ;
     nPos := Pos(sLookFor, sSrc) ;
   end;
   Result := sSrc;
end;

function CharToWide(const S: String; CodePage: Word): WideString;
var
  L: Integer;
begin
  if S='' then
    Result:= ''
  else
    begin
      L:= MultiByteToWideChar(CodePage, 0, PChar(@S[1]), -1, nil, 0);
      SetLength(Result, L-1);
      MultiByteToWideChar(CodePage, 0, PChar(@S[1]), -1, PWideChar(@Result[1]), L-1);
   end;
end;

function WideToChar(const WS: WideString; CodePage: Word): String;
var
  L: Integer;
begin
  if WS='' then
    Result:= ''
  else
    begin
      L:= WideCharToMultiByte(CodePage, 0, @WS[1], -1, nil, 0, nil, nil);
      SetLength(Result, L-1);
      WideCharToMultiByte(CodePage, 0, @WS[1], -1, @Result[1], L-1, nil, nil);
    end;
end;

procedure Debug(enabled: boolean; const S: String);
var msg :string;
begin
  if enabled then begin
    msg := Format('TSIGQuickChatPlugin - %s', [S]);
    OutputDebugString(PAnsiChar(msg));
  end;
end;

{---------------------------------------}
{---------------------------------------}
// Helper class
constructor TJID.Create();
begin
   inherited Create();
   self._jid := '';
   self._name:= '';
end;

constructor TJID.Create(jid: WideString; name: WideString);
begin
   inherited Create();
   self._jid := jid;
   self._name:= name;
end;

function TJID.IsEmpty(): Bool;
begin
   if ((self._jid = '') AND (self._name = '')) then
     Result := true
   else
     Result := false;
end;

procedure TJID.Copy(ojid: TJID);
begin
   self._jid := ojid.jid;
   self._name:= ojid.name;
end;

procedure TJID.Clear();
begin
   self._jid := '';
   self._name:= '';
end;

function TJID.Clone(): TJID;
begin
    result := TJID.Create(self.Jid, self.Name);
end;

function TJID.Same(ojid: TJID): Bool;
begin
   if ((self._jid = ojid.Jid) AND (self._name = ojid.Name) ) then
      Result := true
   else
      Result := false;
end;

function TJID.GetName(): String;
begin
    Result := self._name;
end;

procedure TJID.SetName(name: string);
begin
   self._name := name;
end;

function TJID.GetJid(): String;
begin
    Result := self._jid;
end;

procedure TJID.SetJid(jid: string) ;
begin
   self._jid := jid;
end;

{---------------------------------------}
{---------------------------------------}
procedure TSIGQuickChatPlugin.ExodusDebug(level: Integer; msg: String);
begin
  if (_exodus <> nil) then
    if (level <= DEBUGLEVEL) then begin
      _exodus.Debug(Format('QC(%d) %s', [level, msg]));
      Debug(true, msg);
    end;
end;
{---------------------------------------}
function TSIGQuickChatPlugin.NewIM(const jid: WideString; var Body,
  Subject: WideString; const XTags: WideString): WideString;
begin
  ExodusDebug(3, 'NewIM');
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.Configure;
begin
  ExodusDebug(3, 'Configure');
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.MenuClick(const ID: WideString);
begin
  ExodusDebug(3, 'MenuClick');
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.MsgMenuClick(const ID, jid: WideString; var Body,
  Subject: WideString);
begin
  ExodusDebug(3, 'MsgMenuClick');
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin
  ExodusDebug(3, 'NewChat');
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin
  ExodusDebug(3, 'NewRoom');
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.NewOutgoingIM(const jid: WideString;
  const InstantMsg: IExodusChat);
begin
  ExodusDebug(3, 'NewOutgoingIM');
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.OnMenuItemClick(const menuID : WideString; const xml : WideString);
begin
  ExodusDebug(3, 'OnMenuItemClick');
  if (menuID = _menu_id) AND _connected then begin
    InvokeOptionsMenu();
  end;
end;

{---------------------------------------}
// Find JID from name
function TSIGQuickChatPlugin.JIDFromName(searchString: string): string;
var
  name: String;
  i: Integer;
begin
  ExodusDebug(1, 'JIDFromName');
  
  if not _qcDataSet.IsEmpty then begin
    _qcDataSet.First;
    while not _qcDataSet.EOF do begin
      name := _qcDataSet.FieldByName('Name').AsString;
      if (searchString = name) then begin
        Result:= _qcDataSet.FieldByName('Jid').AsString;
        exit;
      end;
      _qcDataSet.Next;
    end;
  end;
  for i := 0 to NUMQC-1 do begin
    if (_qclist[i].IsEmpty() = false) then begin
      if (searchString = _qclist[i].Name) then begin
        Result:= _qclist[i].Jid;
        exit;
      end;
    end;
  end;
  Result := '';
end;

{---------------------------------------}
function TSIGQuickChatPlugin.InvokeOptionsMenu():WideString;
var
  form: TOptions;
  iResult: Integer;
begin
  ExodusDebug(3, 'InvokeOptionsMenu');
  Result := _searchField;
  form:= TOptions.Create(nil);
  form.Plugin := self;
  form.Fields := _judFields;
  if _searchField='' then
    form.Field := 'last'
  else
    form.Field := _searchField;

  iResult :=  form.ShowModal();
  if (mrOK=iResult) then begin
    _searchField := form.Field;
    ExodusDebug(1, Format('TOptions.ShowModal, Field;%s', [form.Field]));
    _exodus.SetPrefAsString(QCLASTNAMEPRE + _exodus.Server, form.Field);
    Result := form.Field;
  end;
end;

{---------------------------------------}
// Issue a search on the server
procedure TSIGQuickChatPlugin.Search(searchString: String);
begin
  ExodusDebug(1, Format('Search jud=%s', [_sjid]));
  
  if ActiveForm = nil then exit;

  if WideCompareText(_sjid, Widestring(''))=0 then begin
    ExodusDebug(1, 'Search _sjid is blank');
    RequestSearchJid();
    exit;
  end;

  ExodusDebug(1, Format('Search %s', [searchString]));
  ActiveForm.PreSearch();
  RequestSearch(searchString);
end;

{---------------------------------------}
// Newly found contacts need a subscription
procedure TSIGQuickChatPlugin.UpdateRoster();
var
    i, j: Integer;
    jid, name: widestring;
    subscribed: boolean;
begin
  ExodusDebug(1, 'UpdateRoster');

  for i := 0 to NUMQC-1 do begin
    if (_qclist[i].IsEmpty() = false) then begin
      jid := _qclist[i].Jid;
      name := _qclist[i].Name;

      if (_exodus.IsSubscribed(jid)=false) then  begin
        ExodusDebug(1, Format('Subscribe %s', [jid]));
        _exodus.Roster.Subscribe(jid, name, '', true);

        // Wait a spell for subscription to be processed.
        // If this doesn't work I need to wait asynchronously for
        for j := 0 to 50 do begin
          subscribed := _exodus.isSubscribed(jid);
          if subscribed = true then
            exit;
        end;
      end
    end;
  end;

end;

{---------------------------------------}
// They selected a contact in the combobox
procedure TSIGQuickChatPlugin.Selected(selectString: String);
var
  ojid: TJID;
  jid: String;
begin
  ExodusDebug(1, 'Selected');

  jid := JIDFromName(selectString);
  if (jid = '') then begin
    PopulateControlWithQuickChat();
    exit;
  end;

  ojid := TJID.Create(jid, selectString);
  UpdateRecentQCList(ojid);
  UpdateRoster();
  SaveQuickChatListOnServer();
  ExodusDebug(1, Format('StartChat(%s)', [selectString]));

  _exodus.StartChat(jid, '', selectString);

  PopulateControlWithQuickChat();
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.RestoreQuickChatList();
begin
  ExodusDebug(1, 'RestoreQuickChatList');
  
  PopulateControlWithQuickChat();
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.ProcessSearch(const tag:TXMLTag);
var
  items: TXMLTagList;
begin
  items := tag.QueryXPTags('/iq/query/item');
  if ((items = nil) or (items.Count = 0)) then
    items := tag.QueryXPTags('//x[@xmlns="jabber:x:data"]/item');

  ExodusDebug(1, 'ProcessSearch');

  if items.Count > 0 then
    ProcessSearchList(tag)
  else
    ProcessSearchFields(tag);

  items.Free();
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.ProcessSearchFields(const tag:TXMLTag);
var
  i: integer;
  cols: TXMLTagList;
  cur: TXMLTag;
begin
  cur := tag.QueryXPTag('/iq/query');
  cols := cur.ChildTags();

  ExodusDebug(1, Format('ProcessSearchFields count:%d', [cols.Count]));

  _judFields.Clear();
  for i := 0 to cols.count -1  do begin
    if (WideCompareText(cols[i].Name, 'instructions')<>0) then begin
       ExodusDebug(1, Format('ProcessSearchFields, name=%s', [cols[i].Name]));
       _judFields.Add(cols[i].Name);
    end;
  end;
  cols.Free();

  InitSearchField();
end;

{---------------------------------------}
function TSIGQuickChatPlugin.OrdinalPosOfLast():Integer;
var i: Integer;
begin
    for i := 0 to _judFields.Count-1 do begin
      if (WideCompareText(_judFields[i], _searchField)=0) then begin
        result := i;
        exit;
      end;
    end;
    Result := -1;
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.ProcessSearchList(const tag:TXMLTag);
var
  i, lastpos: integer;
  items, cols: TXMLTagList;
  cur: TXMLTag;
  jid, name, last: Widestring;
begin
  items := tag.QueryXPTags('/iq/query/item');
  if ((items = nil) or (items.Count = 0)) then
    items := tag.QueryXPTags('//x[@xmlns="jabber:x:data"]/item');

  lastpos :=  OrdinalPosOfLast();
  ExodusDebug(1, Format('ProcessSearchList count:%d, OrdinalPosOfLast:%d', [items.Count, lastpos]));

  if ((items <> nil) And (items.Count > 0)) then begin
    _qcDataSet.EmptyDataSet;
    for i := 0 to items.count - 1 do begin
      cur := items[i];
      jid := cur.GetAttribute('jid');

      cols := cur.ChildTags();
      { // DGS
      <item jid="paul.gwin@sig.com">
        <name>Gwin, Paul</name>
        <last>Gwin</last>
        <first>Paul</first>
        <email>Paul.Gwin@msx.bala.susq.com</email>
        <OrgUnit>Infrastructure Services</OrgUnit>
      </item>
      }
      if (cols.count > 0) then  begin
        // Strong assumption first field is 0 - hope this is correct?
        name :=  SearchAndReplace(cols[0].Data, ',', '');
        _qcDataSet.Append;
        _qcDataSet.FieldByName('Name').AsString := name;

        if lastpos >= 0 then
          _qcDataSet.FieldByName('Last').AsString := cols[lastpos].Data;

        _qcDataSet.FieldByName('Jid').AsString := jid;

        ExodusDebug(2, Format('ProcessSearchList record:%s, %s', [name, jid]));

        _qcDataSet.Post;
        _qcDataSet.IndexFieldNames := 'Name';
      end;
    end;
    items.Free();
    PopulateControlWithSearchResults();
  end;
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.ProcessQuickChatList(const tag:TXMLTag);
var
  i: integer;
  items, cols: TXMLTagList;
  cur: TXMLTag;
  jid, name: Widestring;
begin
  items := tag.QueryXPTags('/iq/query/exodus/field');

  ExodusDebug(1, Format('ProcessQuickChatList count:%d', [items.Count]));

  if (items.Count > 0) then begin
    for i := 0 to items.count - 1 do begin
      cur := items[i];
      jid := cur.GetAttribute('jid');
      cols := cur.ChildTags();
      name := cols[0].Data;
      if (cols.count > 0) then  begin
        _qclist[i].Jid := jid;
        _qclist[i].Name := name;
      end;
    end;
    items.Free();
    PopulateControlWithQuickChat();
  end;
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.ProcessDiscoItems(const tag:TXMLTag);
var
  i: integer;
  items: TXMLTagList;
  cur: TXMLTag;
  jid, id: Widestring;
begin
  // Handle our own disco request
  id := tag.GetAttribute('id');

  ExodusDebug(1, Format('ProcessDiscoItems id:%s', [id]));

  if (WideCompareText(id, REQUESTINGID1)=0) then begin
    cur := tag.QueryXPTag('/iq/query');
    items := cur.QueryTags('item');

    ExodusDebug(1, Format('ProcessDiscoItems count:%s', [items.Count]));

    if (items.Count > 0) then begin
      for i := 0 to items.count - 1 do begin
        cur := items[i];
        jid := cur.GetAttribute('jid');
        RequestDiscoInfo(jid);
      end;
      items.Free();
    end;
  end;
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.ProcessDiscoInfo(const tag:TXMLTag);
var
  jid, id: Widestring;
  feature, identity: TXMLTag;
begin
  // Pickup jud jid via query packets
  id := tag.GetAttribute('id');

  ExodusDebug(1, Format('ProcessDiscoInfo id:%s', [id]));

  identity := tag.QueryXPTag('/iq/query/identity[@category="directory"');
  feature := tag.QueryXPTag('/iq/query/feature[@var="jabber:iq:search"]');

  if (identity<>nil) and (feature<>nil) then begin
    jid := tag.GetAttribute('from');
    if (Length(jid)>0) then begin
      _sjid := jid;
      RequestJudFields();
      ExodusDebug(1, Format('Process-disco#info, jid=%s', [jid]));
    end;
  end;
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.ProcessEntityInfo(const tag:TXMLTag);
var
  feature, identity: TXMLTag;
  jid: Widestring;
begin
  ExodusDebug(1, 'ProcessEntityInfo');

  identity := tag.QueryXPTag('/iq/query/identity[@category="directory"');
  feature := tag.QueryXPTag('/iq/query/feature[@var="jabber:iq:search"]');

  if (identity<>nil) and (feature<>nil) then begin
    jid := tag.GetAttribute('from');
    if (Length(jid)>0) then begin
       _sjid := jid;
       RequestJudFields();
       ExodusDebug(1, Format('Process-entity-disco %s', [jid]));
    end;
  end;
end;

{---------------------------------------}
// We process session messages and packets for quickchat
procedure TSIGQuickChatPlugin.Process(const xpath, event, xml: WideString);
var
  parser: TXMLTagParser;
  tag: TXMLTag;
begin
//Debug(false, Format('---Process - [%s], [%s], [%s]', [WideToChar(xpath, CP_ACP), WideToChar(event, CP_ACP), WideToChar(xml, CP_ACP)]));

  try
    parser := TXMLTagParser.Create();
    parser.ParseString(xml, '');
    tag := parser.popTag();

    if WideCompareText(xpath, Widestring(SSESSION))=0 then begin
      // Connected
      if WideCompareText(event, Widestring(SCONNECTED))=0 then begin
        Connected();
      end;

      // Disconnected
      if WideCompareText(event, Widestring(SDISCONNECTED))=0 then begin
        Disconnected();
      end;

      // Pickup jud jid via entity packets
      if WideCompareText(event, Widestring(SENTITYINFO))=0 then begin
        ProcessEntityInfo(tag);
      end;

      if (tag<>nil) then tag.Free;
      if (parser<>nil) then parser.Free;
      exit;
    end;

    if event = 'xml' then begin
      if (WideCompareText(xpath, SQUICKCHAT)=0) then begin
        ProcessQuickChatList(tag);
      end

      else if (WideCompareText(xpath, SDISCOITEMS)=0) then begin
        ProcessDiscoItems(tag);
      end

      else if (WideCompareText(xpath, SDISCOINFO)=0) then begin
        ProcessDiscoInfo(tag);
      end

      else if (WideCompareText(xpath, SSEARCH)=0) then begin
//      ExodusDebug(false, Format('---Process - [%s], [%s], [%s]', [WideToChar(xpath, CP_ACP), WideToChar(event, CP_ACP), WideToChar(xml, CP_ACP)]));
        ProcessSearch(tag);
      end;
    end;

    if (tag<>nil) then tag.Free;
    if (parser<>nil) then parser.Free;

  except
    on E: Exception do
    begin
      Debug (SHOWEXCEPTIONS
            ,Format('Exception in Process, Exception:%s, ExceptionAddr:%x'
                    ,[E.Message, Integer(ExceptAddr)]
                    )
            );
    end;
  end;
end;

{---------------------------------------}
// Request jud jid.
procedure TSIGQuickChatPlugin.RequestSearchJid();
var
  iq, query: TXMLTag;
begin
  ExodusDebug(1, 'RequestSearchJid');

{$IFDEF REQUEST_DISCO_IN_ORDER_TO_OBTAIN_JUD}
  iq := TXMLTag.Create('iq');

  iq.setAttribute('type', 'get');
  iq.setAttribute('id', REQUESTINGID1);

  iq.setAttribute('to', _exodus.Server);

  query := iq.AddTag('query');
  query.setAttribute('xmlns', 'http://jabber.org/protocol/disco#items');

  _exodus.Send(iq.xml);

  iq.Free();
{$ELSE}
  _sjid := 'jud' + _exodus.Server;
{$ENDIF}
end;

{---------------------------------------}
// Request Info about disco'd item
// SENT: <iq id="jcl_13" to="jud.sig.com" type="get"><query xmlns="jabber:iq:search"/></iq>
// RECV: <iq from='jud.sig.com' id='jcl_13' to='david.siracusa@sig.com/Home' type='result'>
//     <query xmlns='jabber:iq:search'>
//      <name/>
//      <last/>
//      <first/>
//      <email/>
//      <OrgUnit/>
//      <instructions>Fill in the search fields.</instructions>
//     </query>
//  </iq>
procedure TSIGQuickChatPlugin.RequestJudFields();
var
  iq, query: TXMLTag;
begin
  ExodusDebug(1, 'RequestJudFields');

  iq := TXMLTag.Create('iq');

  iq.setAttribute('type', 'get');
  iq.setAttribute('to', _sjid);

  query := iq.AddTag('query');
  query.setAttribute('xmlns', 'jabber:iq:search');

  _exodus.Send(iq.xml);

  iq.Free();
end;

{---------------------------------------}
// Request Info about disco'd item
//<iq id="jcl_10" to="jud.sig.com" type="get">
//<query xmlns="http://jabber.org/protocol/disco#info"/></iq>
procedure TSIGQuickChatPlugin.RequestDiscoInfo(jid: widestring);
var
  iq, query: TXMLTag;
begin
  ExodusDebug(1, Format('RequestDiscoInfo from: %s', [jid]));

  iq := TXMLTag.Create('iq');

  iq.setAttribute('type', 'get');
  iq.setAttribute('id', REQUESTINGID2);

  iq.setAttribute('to', jid);

  query := iq.AddTag('query');
  query.setAttribute('xmlns', 'http://jabber.org/protocol/disco#info');

  _exodus.Send(iq.xml);

  iq.Free();
end;

{---------------------------------------}
procedure TSIGQuickChatPlugin.InitSearchField();
var
  i, index: Integer;
  pref, field: WideString;
begin
  // Pull from preferences, will vary by server
  pref := _exodus.GetPrefAsString(QCLASTNAMEPRE + _exodus.Server);

  ExodusDebug(1, Format('InitSearchField (enter): Count: %d, pref: %s', [_judFields.Count, pref]));

  // Previously saved?  Check if it's still in the schema.
  if (length(pref) > 0) then begin
    ExodusDebug(1, Format('InitSearchField: Pref: %s', [WideToChar(pref, CP_ACP)]));
    for i := 0 to _judFields.Count-1 do begin
      field := WideUpperCase(_judFields[i]);
      if (WideCompareText(field, pref)=0) then begin
        // It's in the schema
        ExodusDebug(1, Format('InitSearchField: pref matched: %s', [WideToChar(pref, CP_ACP)]));
        _searchField := pref;
        exit
      end;
    end;
  end;

  // See if I can find something based on (last); i.e. last, or lastname, last, ...
  for i := 0 to _judFields.Count-1 do begin
    field := WideUpperCase(_judFields[i]);
    index := Pos(field, WideString('LAST'));
    ExodusDebug(1, Format('InitSearchField: Evaluate: %s, Index:%d', [WideToChar(field, CP_ACP), index]));
    if (index > 0) then begin
      _searchField := _judFields[i];
      ExodusDebug(1, Format('InitSearchField: %s', [_searchField]));
      break;
    end;
  end;

  _exodus.SetPrefAsString(QCLASTNAMEPRE + _exodus.Server, _searchField);
end;

{---------------------------------------}
// Search JUD
{
<iq id="jcl_19" to="jud.sig.com" type="get">
	<query xmlns="jabber:iq:search"/>
</iq>
<iq from='jud.sig.com' id='jcl_19' to='david.siracusa@sig.com/Home' type='result'>
	<query xmlns='jabber:iq:search'>
		<name/>
		<last/>
		<first/>
		<email/>
		<OrgUnit/>
		<instructions>Fill in the search fields.</instructions>
	</query>
</iq>
}
procedure TSIGQuickChatPlugin.RequestSearch(searchString: String);
var
  iq, query: TXMLTag;
  searchField: WideString;
begin
  ExodusDebug(1, Format('RequestSearch %s', [_sjid]));

  iq := TXMLTag.Create('iq');

  iq.setAttribute('type', 'set');

  iq.setAttribute('to', _sjid);

  query := iq.AddTag('query');
  query.setAttribute('xmlns', 'jabber:iq:search');

  if _searchField='' then
    InvokeOptionsMenu();

  query.AddBasicTag(_searchField, searchString);

  _exodus.Send(iq.xml);

  iq.Free();
end;

{---------------------------------------}
// Plugin is starting
procedure TSIGQuickChatPlugin.Startup(const ExodusController: IExodusController);
var
  i: Integer;
begin
  try
    ExodusDebug(1, Format('Startup %x', [Integer(Self)]));

    if _MustBeReLoaded then begin
        MessageBoxA(HWND(nil), PChar('You must restart Exodus in order to enable the SIGQuickChat plugin'), PChar(QUICKCHAT), MB_OK OR MB_ICONINFORMATION);
        exit;
    end;

    _MustBeReLoaded := true;

    if (_loaded) then exit;

    _exodus := ExodusController;

    _exodus.Toolbar.AddControl('{88E6C2AB-1781-41E5-8C97-D5FA27471403}');

{$IFDEF OTHER_LISTENERS}
    _event1 := _exodus.RegisterCallback(EVENTDATA1, Self);
    _event2 := _exodus.RegisterCallback(EVENTDATA2, Self);
    _event3 := _exodus.RegisterCallback(EVENTDATA3, Self);
    _event4 := _exodus.RegisterCallback(EVENTDATA4, Self);
    _event5 := _exodus.RegisterCallback(EVENTDATA5, Self);
{$ENDIF}
    _event6 := _exodus.RegisterCallback(EVENTDATA6, Self);
    _event7 := _exodus.RegisterCallback(EVENTDATA7, Self);
    _event8 := _exodus.RegisterCallback(EVENTDATA8, Self);
    _event9 := _exodus.RegisterCallback(EVENTDATA9, Self);
    _event10 := _exodus.RegisterCallback(EVENTDATA10, Self);

    _qcDataSet := TClientDataSet.Create(nil);
    _qcDataSet.FieldDefs.Add('Name', ftString, 30, True);
    _qcDataSet.FieldDefs.Add('Last', ftString, 30, True);
    _qcDataSet.FieldDefs.Add('Jid', ftString, 50, True);
    _qcDataSet.CreateDataSet;

    for i := 0 to NUMQC-1 do begin
      _qclist[i] := TJID.Create();
    end;

    _judFields := TWideStringList.Create();

    _menu_id := _exodus.addPluginMenu('QuickChat Options...', Self);

    _loaded := true;
    _connected := false;
    _searchField := '';

  except
    on E: Exception do
    begin
      Debug (SHOWEXCEPTIONS
            ,Format('Exception in Startup, Exception:%s, ExceptionAddr:%x'
                    ,[E.Message, Integer(ExceptAddr)]
                    )
            );
    end;
  end;
end;

{---------------------------------------}
// Plugin is being shutdown
procedure TSIGQuickChatPlugin.Shutdown;
begin
  ExodusDebug(1, Format('Shutdown %x', [Integer(Self)]));
  if (_loaded) then begin

    if ActiveForm = nil then exit;

    ActiveForm.Visible := false;

    _exodus.UnRegisterCallback(_event6);
    _exodus.UnRegisterCallback(_event7);
    _exodus.UnRegisterCallback(_event8);
    _exodus.UnRegisterCallback(_event9);
    _exodus.UnRegisterCallback(_event10);

    _exodus.removePluginMenu(_menu_id);

    _judFields.Free();

    _loaded := false;
    _connected := false;
  end;
end;

{---------------------------------------}
function TSIGQuickChatPlugin.GetActiveForm(): ActiveFormImpl.TActiveFormX;
var
  ActiveFormX: ActiveFormImpl.TActiveFormX;
begin
  ActiveFormX := GetActiveFormX(Self);
  Result := ActiveFormX;
end;

{---------------------------------------}
// Restore QuickChat list from server
{
---- Send -----
<iq id="jcl_8" type="get">
  <query xmlns="jabber:iq:private">
    <exodus xmlns="exodus:qc"/>
  </query>
</iq>

---- Receive ----
<iq fro m='david.siracusa@sig.com/Office' id='jcl_8' type='result'>
  <query xmlns='jabber:iq:private'>
    <exodus xmlns='exodus:qc'>
      <field jid='paul.clegg@sig.com'><name>Clegg Paul</name></field>
    </exodus>
  </query>
</iq>
}
procedure TSIGQuickChatPlugin.RequestQuickChatListFromServer();
var
  iq, query, s: TXMLTag;
begin
  ExodusDebug(1, 'RequestQuickChatListFromServer');
  iq := TXMLTag.Create('iq');

  iq.setAttribute('type', 'get');

  query := iq.AddTag('query');
  query.setAttribute('xmlns', 'jabber:iq:private');

  s := query.AddTag('exodus');
  s.setAttribute('xmlns', 'exodus:qc');

  _exodus.Send(iq.xml);

  iq.Free();
end;

{---------------------------------------}
// Purge QuickChat
procedure TSIGQuickChatPlugin.ClearQuickChat();
var
    i: integer;
begin
  ExodusDebug(1, 'ClearQuickChat');
  for i := 0 to NUMQC-1 do begin
    _qclist[i].Clear();
  end;
  SaveQuickChatListOnServer();
  PopulateControlWithQuickChat();
end;

 {---------------------------------------}
 // Save QuickChat list on the server
procedure TSIGQuickChatPlugin.SaveQuickChatListOnServer();
var
  iq, query, field, exodus: TXMLTag;
  i: integer;
begin
  try
    ExodusDebug(1, 'SaveQuickChatListOnServer');

    iq := TXMLTag.Create('iq');

    iq.setAttribute('type', 'set');

    query := iq.AddTag('query');
    query.setAttribute('xmlns', 'jabber:iq:private');

    exodus := query.AddTag('exodus');
    exodus.setAttribute('xmlns', 'exodus:qc');

    for i := 0 to NUMQC-1 do begin
      if (_qclist[i].IsEmpty() = false) then begin
        field := exodus.AddTag('field');
        field.setAttribute('jid', _qclist[i].Jid);
        field.AddBasicTag('name', _qclist[i].Name);
      end;
    end;
    _exodus.Send(iq.xml);
    iq.Free();
  except
    on E: Exception do
    begin
      Debug (SHOWEXCEPTIONS
            ,Format('Exception in SaveQuickChatListOnServer, Exception:%s, ExceptionAddr:%x'
                    ,[E.Message, Integer(ExceptAddr)]
                    )
            );
    end;
  end;
end;

{---------------------------------------}
// Prepare the control
procedure TSIGQuickChatPlugin.EnableControl();
begin
  try
    ExodusDebug(1, 'EnableControl');

    if ActiveForm = nil then exit;

    ActiveForm.Controller := Self;
    ActiveForm.Enabled := true;
    RequestQuickChatListFromServer();
//  raise Exception.Create('Test');
  except
    on E: Exception do
    begin
      Debug (SHOWEXCEPTIONS
            ,Format('Exception in EnableControl, Exception:%s, ExceptionAddr:%x'
                    ,[E.Message, Integer(ExceptAddr)]
                    )
            );
    end;
  end;
end;

{---------------------------------------}
// Shutdown the control
procedure TSIGQuickChatPlugin.DisableControl();
begin
  try
    ExodusDebug(1, 'DisableControl');

    if ActiveForm <> nil then begin
      ActiveForm.Clear(true);
      ActiveForm.Enabled := false;
    end;
  except
    on E: Exception do
    begin
      Debug (SHOWEXCEPTIONS
            ,Format('Exception in DisableControl, Exception:%s, ExceptionAddr:%x'
                    ,[E.Message, Integer(ExceptAddr)]
                    )
            );
    end;
  end;
end;

{---------------------------------------}
// Fill the combobox
procedure TSIGQuickChatPlugin.PopulateControlWithQuickChat();
var
  i, Count: Integer;
begin
  try
    if ActiveForm = nil then exit;

    Count := 0;
    ActiveForm.Clear(true);
    for i := 0 to NUMQC-1 do begin
      if (_qclist[i].IsEmpty() = false) then begin
        ActiveForm.AddItem (_qclist[i].Name
                            ,TJID.Create(_qclist[i].Jid, _qclist[i].Name)
                            );
        Count := Count + 1;
      end;
    end;
    ActiveForm.ClearSearchField('PopulateControlWithQuickChat');
    ExodusDebug(1, Format('PopulateControlWithQuickChat items added:%d', [Count]));
  except
    on E: Exception do
    begin
      ExodusDebug (0
                  ,Format('Exception in PopulateControlWithQuickChat, Exception:%s, ExceptionAddr:%x'
                  ,[E.Message, Integer(ExceptAddr)]
                  )
            );
    end;
  end;
end;

{---------------------------------------}
// Fill the combobox with results of the search
procedure TSIGQuickChatPlugin.PopulateControlWithSearchResults();
var Last: String;
    Count, Added: Integer;
    Add: Boolean;
begin
  try
    ExodusDebug(1, Format('PopulateControlWithSearchResults Records:%d, ActiveForm.LastSearch:%s', [_qcDataSet.RecordCount, ActiveForm.LastSearch]));

    if ActiveForm = nil then exit;

    Added := 0;
    Count := 0;
    ActiveForm.Clear(false);

    if not _qcDataSet.IsEmpty then begin
      _qcDataSet.First;
      while not _qcDataSet.EOF do begin
{$IFDEF FILTER}
        Last := _qcDataSet.FieldByName('Last').AsString;
        Last := LeftStr(Last, Length(ActiveForm.LastSearch));
        if CompareText(Last, ActiveForm.LastSearch)=0 then begin
{$ENDIF}
          ActiveForm.AddItem  (_qcDataSet.FieldByName('Name').AsString
                              ,TJID.Create(_qcDataSet.FieldByName('Jid').AsString, _qcDataSet.FieldByName('Name').AsString)
                              );
          Added := Added + 1;
          ExodusDebug(2, Format('PopulateControlWithSearchResults added record(%d) Name:%s, Last:%s', [Count, _qcDataSet.FieldByName('Name').AsString, _qcDataSet.FieldByName('Last').AsString]));
{$IFDEF FILTER}
        end
        else begin
          ExodusDebug(2, Format('PopulateControlWithSearchResults skipped record(%d) Name:%s, Last:%s', [Count, _qcDataSet.FieldByName('Name').AsString, _qcDataSet.FieldByName('Last').AsString]));
        end;
        Count := Count + 1;
{$ENDIF}
        _qcDataSet.Next;
      end;
    end;

    ExodusDebug(1, Format('PopulateControlWithSearchResults items added:%d', [Added]));

    ActiveForm.PostSearch();
  except
    on E: Exception do
    begin
      ExodusDebug (0
                  ,Format('Exception in PopulateControlWithSearchResults, Exception:%s, ExceptionAddr:%x'
                  ,[E.Message, Integer(ExceptAddr)]
                  )
            );
    end;
  end;
end;

{---------------------------------------}
// User is connected
procedure TSIGQuickChatPlugin.Connected();
begin
  try
    ExodusDebug(1, 'Connected');

    _connected := true;
    EnableControl();
  except
    on E: Exception do
    begin
      ExodusDebug (0
                  ,Format('Exception in Connected, Exception:%s, ExceptionAddr:%x'
                  ,[E.Message, Integer(ExceptAddr)]
                  )
            );
    end;
  end;
end;

{---------------------------------------}
// User discoconnected
procedure TSIGQuickChatPlugin.Disconnected();
var
  i: Integer;
begin
  try
    ExodusDebug(1, 'Disconnected');

    _connected := false;
    for i := 0 to NUMQC-1 do
      _qclist[i].Clear;

    DisableControl();
  except
    on E: Exception do
    begin
      ExodusDebug (0
                  ,Format('Exception in Disconnected, Exception:%s, ExceptionAddr:%x'
                  ,[E.Message, Integer(ExceptAddr)]
                  )
            );
    end;
  end;
end;

{---------------------------------------}
// New contact
procedure TSIGQuickChatPlugin.UpdateRecentQCList(ojid: TJID);
var i, x: Integer;
begin
  ExodusDebug(1, 'PopulateControlWithSearchResults');

  // Todo: I wish I had a Delphi stack...
  // First in list nothing to do
  if (_qclist[0].Same(ojid) = true) then exit;

  //  Get rid of dups
  for i := 0 to NUMQC-1 do begin
    if (_qclist[i].Same(ojid) = true) then begin
       _qclist[i].Name := '';
       _qclist[i].Jid := '';
    end;
  end;

  // Shift blanks
  for i := 1 to NUMQC-1 do begin
    if (_qclist[i].IsEmpty()) then begin
       for x := i to NUMQC-1 do begin
          if (_qclist[x].IsEmpty() = false) then begin
              _qclist[i].Copy(_qclist[x]);
              _qclist[x].Clear();
              break;
          end;
       end;
    end;
  end;

  // Shift to the right
  for i := NUMQC-2 downto 0 do begin
    _qclist[i+1].Copy(_qclist[i]);
  end;

  // Replace first
  _qclist[0].Free();
  _qclist[0] := ojid.Clone();

  SaveQuickChatListOnServer();
end;

initialization
  _MustBeReLoaded := false;
  TAutoObjectFactory.Create  (ComServer
                             ,TSIGQuickChatPlugin
                             ,Class_SIGQuickChatPlugin
                             ,ciMultiInstance
                             ,tmApartment
                             );
end.


