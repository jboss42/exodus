unit COMChatController;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Session, ChatController, ChatWin, Chat, 
    ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusChat = class(TAutoObject, IExodusChat)
  protected
    function Get_jid: WideString; safecall;
    function AddContextMenu(const Caption: WideString): WideString; safecall;
    function Get_MsgOutText: WideString; safecall;
    { Protected declarations }

  public
    procedure setChatSession(chat_session: TChatController);

  private
    _chat: TChatController;
  end;

implementation

uses ComServ;

procedure TExodusChat.setChatSession(chat_session: TChatController);
begin
    _chat := chat_session;
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

initialization
  TAutoObjectFactory.Create(ComServer, TExodusChat, Class_ExodusChat,
    ciMultiInstance, tmApartment);
end.
