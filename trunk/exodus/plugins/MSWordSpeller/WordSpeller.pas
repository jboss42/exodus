unit WordSpeller;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ExodusCOM_TLB, Word2000,
    ChatSpeller, 
    ComObj, ActiveX, ExodusWordSpeller_TLB, StdVcl;

type
  TWordSpeller = class(TAutoObject, IWordSpeller)
  protected
    procedure NewChat(const JID: WideString; Chat: OleVariant); safecall;
    procedure NewRoom(const JID: WideString; Chat: OleVariant); safecall;
    procedure Process(const xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(Exodus: OleVariant); safecall;
    { Protected declarations }
  private
    _exodus: IExodusController;
    _word: TWordApplication;
  end;

implementation

uses ComServ;

procedure TWordSpeller.Startup(Exodus: OleVariant);
begin
    // exodus is starting up...
    _exodus := IUnknown(Exodus) as IExodusController;

    // init the word instance for the plugin
    _word := TWordApplication.Create(nil);
    _word.CheckSpelling('hello');
end;

procedure TWordSpeller.Shutdown;
begin
    // exodus is shutting down... do cleanup
end;

procedure TWordSpeller.NewChat(const JID: WideString; Chat: OleVariant);
var
    chat_com: IExodusChat;
begin
    // a new chat window is firing up
    chat_com := IUnknown(Chat) as IExodusChat;
    TChatSpeller.Create(_word, chat_com);
end;

procedure TWordSpeller.NewRoom(const JID: WideString; Chat: OleVariant);
begin
    // a new TC Room is firing up
end;

procedure TWordSpeller.Process(const xml: WideString);
begin
    // we are getting some kind of Packet from a callback
end;

initialization
  TAutoObjectFactory.Create(ComServer, TWordSpeller, Class_WordSpeller,
    ciMultiInstance, tmApartment);
end.
