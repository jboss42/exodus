unit COMChatController;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Session, ChatController, ChatWin, Chat,
    Classes, ComObj, ActiveX, ExodusCOM_TLB, StdVcl;

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
    { Protected declarations }

  public
    constructor Create();
    destructor Destroy(); override;

    procedure setChatSession(chat_session: TChatController);
    procedure fireMsgKeyPress(Key: Char);
    procedure fireBeforeMsg(var body: Widestring);
    function  fireAfterMsg(var body: WideString): Widestring;
    procedure fireRecvMsg(body, xml: Widestring);
    procedure fireClose();

  private
    _chat: TChatController;
    _plugs: TList;

  end;

  TChatPlugin = class
    com: IExodusChatPlugin;
end;


implementation

uses ComServ;

{---------------------------------------}
constructor TExodusChat.Create();
begin
    inherited Create();
    _plugs := TList.Create();
end;

{---------------------------------------}
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

{---------------------------------------}
procedure TExodusChat.setChatSession(chat_session: TChatController);
begin
    _chat := chat_session;
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
procedure TExodusChat.fireClose();
var
    i: integer;
begin
    for i := _plugs.Count - 1 downto 0 do
        TChatPlugin(_plugs[i]).com.onClose();
end;

{---------------------------------------}
function TExodusChat.Get_jid: WideString;
begin
    Result := _chat.JID;
end;

{---------------------------------------}
function TExodusChat.AddContextMenu(const Caption: WideString): WideString;
begin
    // todo: plugins
    // add a menu to the window
    // return an "ID" for this menu/window combo
end;

{---------------------------------------}
function TExodusChat.Get_MsgOutText: WideString;
begin
    Result := TfrmChat(_chat.window).MsgOut.Text;
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
        Result := TfrmChat(_chat.window).MsgOut.Handle;
    end;
    HWND_MsgOutput: begin
        Result := TfrmChat(_chat.window).MsgList.Handle;
    end;
    Ptr_MsgInput: begin
        p := @(TfrmChat(_chat.window).MsgOut);
        Result := integer(p);
    end;
    Ptr_MsgOutput: begin
        p := @(TfrmChat(_chat.window).MsgList);
        Result := integer(p);
    end
    else
        Result := -1;
end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusChat, Class_ExodusChat,
    ciMultiInstance, tmApartment);
end.
