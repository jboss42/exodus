unit COMChatController;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ExodusCOM_TLB, 
    Session, ChatController, ChatWin, Chat, Room, Unicode,
    Windows, Classes, ComObj, ActiveX, StdVcl;

type
  TExodusChat = class(TAutoObject, IExodusChat)
  protected
    function Get_jid: WideString; safecall;
    function AddContextMenu(const Caption: WideString): WideString; safecall;
    function Get_MsgOutText: WideString; safecall;
    function UnRegister(ID: Integer): WordBool; safecall;
    function RegisterPlugin(const Plugin: IExodusChatPlugin): Integer;
      safecall;
    function getMagicInt(Part: ChatParts): Integer; safecall;
    procedure RemoveContextMenu(const ID: WideString); safecall;
    procedure AddMsgOut(const Value: WideString); safecall;
    { Protected declarations }

  public
    constructor Create();
    destructor Destroy(); override;

    procedure setRoom(room: TfrmRoom);
    procedure setChatSession(chat_session: TChatController);
    procedure fireMsgKeyPress(Key: Char);
    procedure fireBeforeMsg(var body: Widestring);
    function  fireAfterMsg(var body: WideString): Widestring;
    procedure fireRecvMsg(body, xml: Widestring);
    procedure fireMenuClick(Sender: TObject);
    procedure fireNewWindow(new_hwnd: HWND);
    procedure fireClose();

  private
    _room: TfrmRoom;
    _chat: TChatController;
    _plugs: TList;
    _menu_items: TWidestringlist;

  end;

  TChatPlugin = class
    com: IExodusChatPlugin;
end;


implementation

uses ComServ, Menus, SysUtils;

{---------------------------------------}
constructor TExodusChat.Create();
begin
    inherited Create();
    _plugs := TList.Create();
    _menu_items := TWidestringlist.Create();
end;

{---------------------------------------}
destructor TExodusChat.Destroy();
var
    i: integer;
begin
    // free all of our plugin menu items
    for i := 0 to _menu_items.Count - 1 do
        TMenuItem(_menu_items.Objects[i]).Free();

    _menu_items.Clear();
    _menu_items.Free();

    // free all of our plugin proxies
    for i := _plugs.Count - 1 downto 0 do begin
        TChatPlugin(_plugs[i]).com.onClose();
        //TChatPlugin(_plugs[i]).Free();
    end;

    _plugs.Clear();
    _plugs.Free();

    inherited Destroy();
end;

{---------------------------------------}
procedure TExodusChat.setChatSession(chat_session: TChatController);
begin
    _room := nil;
    _chat := chat_session;
end;

{---------------------------------------}
procedure TExodusChat.setRoom(room: TfrmRoom);
begin
  _chat := nil;
  _room := room;
end;

{---------------------------------------}
procedure TExodusChat.fireMsgKeyPress(Key: Char);
var
    i: integer;
begin
    for i := 0 to _plugs.count - 1 do
        TChatPlugin(_plugs[i]).com.onKeyPress(Key);
end;

{---------------------------------------}
procedure TExodusChat.fireBeforeMsg(var body: Widestring);
var
    i: integer;
begin
    for i := 0 to _plugs.Count - 1 do
        TChatPlugin(_plugs[i]).com.onBeforeMessage(body);
end;

{---------------------------------------}
function TExodusChat.fireAfterMsg(var body: WideString): Widestring;
var
    i: integer;
    buff: Widestring;
begin
    buff := '';
    for i := 0 to _plugs.Count - 1 do
        buff := buff + TChatPlugin(_plugs[i]).com.onAfterMessage(body);
    Result := buff;
end;

{---------------------------------------}
procedure TExodusChat.fireRecvMsg(body, xml: Widestring);
var
    i: integer;
begin
    for i := 0 to _plugs.Count - 1 do
        TChatPlugin(_plugs[i]).com.onRecvMessage(body, xml);
end;

{---------------------------------------}
procedure TExodusChat.fireNewWindow(new_hwnd: HWND);
var
    i: integer;
begin
    for i := 0 to _plugs.Count - 1 do
        TChatPlugin(_plugs[i]).com.OnNewWindow(new_hwnd);
end;

{---------------------------------------}
procedure TExodusChat.fireClose();
var
    i: integer;
begin
    for i := _plugs.Count - 1 downto 0 do
        TChatPlugin(_plugs[i]).com.onClose();
end;

{---------------------------------------}
procedure TExodusChat.fireMenuClick(Sender: TObject);
var
    i, idx: integer;
begin
    idx := _menu_items.IndexOfObject(Sender);
    if (idx >= 0) then begin
        for i := 0 to _plugs.Count - 1 do
            TChatPlugin(_plugs[i]).com.onMenu(_menu_items[idx]);
    end;
end;

{---------------------------------------}
function TExodusChat.Get_jid: WideString;
begin
    if (_chat <> nil) then Result := _chat.JID
    else Result := _room.getJid;
end;

{---------------------------------------}
function TExodusChat.AddContextMenu(const Caption: WideString): WideString;
var
    id: Widestring;
    mi: TMenuItem;
begin
    // add a new TMenuItem to the Plugins menu
    if (_room <> nil) then begin
        mi := TMenuItem.Create(_room);
        mi.OnClick := _room.pluginMenuClick;
        mi.Caption := caption;
        _room.popRoom.Items.Add(mi);
    end
    else begin
        mi := TMenuItem.Create(TfrmChat(_chat.window));
        mi.OnClick := TfrmChat(_chat.window).pluginMenuClick;
        mi.Caption := caption;
        TfrmChat(_chat.window).popContact.Items.Add(mi);
    end;

    id := 'plugin_' + IntToStr(_menu_items.Count);
    _menu_items.AddObject(id, mi);
    Result := id;
end;

{---------------------------------------}
function TExodusChat.Get_MsgOutText: WideString;
begin
    if (_chat <> nil) then
        Result := TfrmChat(_chat.window).MsgOut.Text
    else
        Result := _room.MsgOut.Text;
end;

{---------------------------------------}
function TExodusChat.UnRegister(ID: Integer): WordBool;
var
    cp: TChatPlugin;
begin
    if ((id >= 0) and (id < _plugs.count)) then begin
        cp := TChatPlugin(_plugs[id]);
        _plugs.Delete(id);
        cp.Free();
        Result := true;
    end
    else
        Result := false;
end;

{---------------------------------------}
function TExodusChat.RegisterPlugin(
  const Plugin: IExodusChatPlugin): Integer;
var
    cp: TChatPlugin;
begin
    cp := TChatPlugin.Create;
    cp.com := Plugin;
    Plugin._AddRef();
    Result := _plugs.Add(cp);
end;

{---------------------------------------}
function TExodusChat.getMagicInt(Part: ChatParts): Integer;
var
    p: Pointer;
begin
    case Part of
    HWND_MsgInput: begin
        if (_chat <> nil) then
            Result := TfrmChat(_chat.window).MsgOut.Handle
        else
            Result := _room.MsgOut.Handle;
    end;
    HWND_MsgOutput: begin
        if (_chat <> nil) then
            Result := TfrmChat(_chat.window).MsgList.Handle
        else
            Result := _room.MsgOut.Handle;
    end;
    Ptr_MsgInput: begin
        if (_chat <> nil) then
            p := @(TfrmChat(_chat.window).MsgOut)
        else
            p := @(_room.MsgOut);
        Result := integer(p);
    end;
    Ptr_MsgOutput: begin
        if (_chat <> nil) then
            p := @(TfrmChat(_chat.window).MsgList)
        else
            p := @(_room.MsgList);
        Result := integer(p);
    end
    else
        Result := -1;
    end;
end;

{---------------------------------------}
procedure TExodusChat.RemoveContextMenu(const ID: WideString);
begin
    // remove this menu item.
end;

{---------------------------------------}
procedure TExodusChat.AddMsgOut(const Value: WideString);
begin
    // add something to the RichEdit control
    if (_chat <> nil) then
        TfrmChat(_chat.window).MsgList.WideLines.Add(Value)
    else
        _room.MsgList.WideLines.Add(Value);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusChat, Class_ExodusChat,
    ciMultiInstance, tmApartment);
end.
