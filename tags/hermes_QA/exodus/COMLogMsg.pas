unit COMLogMsg;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  XMLTag, JabberMsg, ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusLogMsg = class(TAutoObject, IExodusLogMsg)
  private
    _body: Widestring;
    _dir: Widestring;
    _from: Widestring;
    _to: Widestring;
    _id: Widestring;
    _type: Widestring;
    _nick: Widestring;
    _subject: Widestring;
    _thread: Widestring;
    _delay: Widestring;
    _xml: Widestring;

  public
    constructor Create(msg: TJabberMessage);

  protected
    function Get_Body: WideString; safecall;
    function Get_Direction: WideString; safecall;
    function Get_FromJid: WideString; safecall;
    function Get_ID: WideString; safecall;
    function Get_MsgType: WideString; safecall;
    function Get_Nick: WideString; safecall;
    function Get_Subject: WideString; safecall;
    function Get_Thread: WideString; safecall;
    function Get_Timestamp: WideString; safecall;
    function Get_ToJid: WideString; safecall;
    function Get_XML: WideString; safecall;

  end;

implementation

uses
    XMLUtils, ComServ;

constructor TExodusLogMsg.Create(msg: TJabberMessage);
begin
    if (msg.isMe) then
        _dir := 'out'
    else
        _dir := 'in';

    _nick := msg.Nick;
    _id := msg.id;
    _type := msg.MsgType;
    _from := msg.FromJid;
    _to := msg.ToJid;
    _body := msg.Body;
    _thread := msg.Thread;
    _subject := msg.Subject;
    _delay := DateTimeToJabber(msg.Time);
    _xml := msg.tag.xml();
end;

function TExodusLogMsg.Get_Body: WideString;
begin
    Result := _body;
end;

function TExodusLogMsg.Get_Direction: WideString;
begin
    Result := _dir;
end;

function TExodusLogMsg.Get_FromJid: WideString;
begin
    Result := _from;
end;

function TExodusLogMsg.Get_ID: WideString;
begin
    Result := _id;
end;

function TExodusLogMsg.Get_MsgType: WideString;
begin
    Result := _type;
end;

function TExodusLogMsg.Get_Nick: WideString;
begin
    Result := _nick;
end;

function TExodusLogMsg.Get_Subject: WideString;
begin
    Result := _subject;
end;

function TExodusLogMsg.Get_Thread: WideString;
begin
    Result := _thread;
end;

function TExodusLogMsg.Get_Timestamp: WideString;
begin
    Result := _delay;
end;

function TExodusLogMsg.Get_ToJid: WideString;
begin
    Result := _to;
end;

function TExodusLogMsg.Get_XML: WideString;
begin
    Result := _xml;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusLogMsg, Class_ExodusLogMsg,
    ciMultiInstance, tmApartment);
end.
