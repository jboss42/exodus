unit COMChatController;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ExodusPlugin_TLB, 
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
    procedure setChatSession(chat_session: TChatController);
    procedure fireMsgKeyPress(Key: Char);

  private
    _chat: TChatController;
    _plugs: TList;

  end;

implementation

uses ComServ;

procedure TExodusChat.setChatSession(chat_session: TChatController);
begin
    _chat := chat_session;
end;

procedure TExodusChat.fireMsgKeyPress(Key: Char);
begin

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
begin

end;

function TExodusChat.RegisterPlugin(var Plugin: OleVariant): Integer;
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusChat, Class_ExodusChat,
    ciMultiInstance, tmApartment);
end.
