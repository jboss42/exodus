unit JabberMsg;
{
    Copyright 2001, Peter Millard

    This file is part of Exodus.

    Exodus is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Exodus is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Exodus; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

interface

uses
    AddressList,
    XmlTag,
    SysUtils;
type

    TJabberMessage = class
    private
        _toJID    : WideString;
        _fromJID  : WideString;
        _subject  : WideString;
        _thread   : WideString;
        _body     : WideString;
        _msg_type : WideString;
        _id       : WideString;
        _action   : boolean;
        _nick     : WideString;
        _isme     : boolean;
        _time     : TDateTime;
        _isxdata  : boolean;
        _highlight: boolean;
        _tag      : TXMLTag;
        _xml      : Widestring;
        _composing: boolean;
        _addresses: TJabberAddressList; // use optional (for JEP-33 support)
        
        procedure SetSubject(const Value: WideString);
        procedure SetBody(const Value: WideString);
        procedure SetThread(const Value: WideString);
        procedure SetMsgType(const Value: WideString);

        function GetTag: TXMLTag;
    protected
    public
        // I use cBody to distinguish between the create's body varialbe and the classes.
        constructor Create; overload;
        constructor Create(mTag: TXMLTag); overload;
        constructor Create(cToJID, cMsgType, cBody, cSubject : WideString); overload;
        destructor Destroy; override;

        // Use of this method optional for JEP-33 support
        procedure AddRecipient(jid: WideString; addrType: WideString = 'to');        
        property Tag: TXMLTag read GetTag;

        property ToJID : WideString read _toJID write _toJID;
        property FromJID: WideString read _fromJID write _fromJID;

        property Subject : WideString read _subject write SetSubject;
        property Thread : WideString read _thread write SetThread;
        property Body : WideString read _body write SetBody;
        property MsgType : WideString read _msg_type write SetMsgType;
        property ID : WideString  read _id write _id;
        property Action: boolean read _action;
        property Nick: WideString read _nick write _nick;
        property isMe: boolean read _isme write _isme;
        property Time: TDateTime read _time write _time;
        property isXdata: boolean read _isxdata;
        property highlight: boolean read _highlight write _highlight;
        property XML: Widestring read _xml write _xml;
        property Composing: boolean read _composing write _composing;
  end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    JabberConst, XMLUtils;

{ TJabberMessage }

constructor TJabberMessage.Create;
begin
    inherited;

    _toJID := '';
    _fromJID := '';
    _subject := '';
    _thread := '';
    _body := '';
    _msg_type := 'normal';
    _id := '';
    _action := false;
    _nick := '';
    _isme := false;
    _time := Now();
    _highlight := false;
    _tag := nil;
    _addresses := TJabberAddressList.Create();
end;

{---------------------------------------}
constructor TJabberMessage.Create(mTag: TXMLTag);
var
    t: TXMLTag;
    tmps: Widestring;
begin
    // create a msg object based on the msg tag
    Create();

    _tag := TXMLTag.Create(mTag);
    with _tag do begin
        _id := GetAttribute('id');
        _toJID := GetAttribute('to');
        _fromJID := GetAttribute('from');
        _nick := '';
        MsgType := GetAttribute('type');
        t := GetFirstTag('body');
        if t <> nil then begin
            _body := t.Data;
            // check for actions
            if (WideLowercase(Copy(_body, 1, 4)) = '/me ') then begin
                _action := true;
                Delete(_body, 1, 4);
            end;
        end;

        _isxdata := (mtag.QueryXPTag(XP_MSGXDATA) <> nil);

        t := GetFirstTag('subject');
        if t <> nil then _subject := t.Data;

        t := GetFirstTag('thread');
        if t <> nil then _thread := t.Data;

        t := QueryXPTag(XP_MSGDELAY);
        if (t = nil) then
            _time := Now()
        else begin
            // we have a delay tag
            tmps := t.getAttribute('stamp');
            if (tmps <> '') then
                _time := JabberToDateTime(t.getAttribute('stamp'))
            else
                _time := Now();
        end;

        //Check for composing event
        t := QueryXPTag(XP_MSGCOMPOSING);
        if (t <> nil) then
          _composing := true;

        t := GetFirstTag('addresses');
        if (t <> nil) then begin
            _addresses.Free();
            _addresses := TJabberAddressList.Create(t);
        end;
    end;
end;

{---------------------------------------}
constructor TJabberMessage.Create(cToJID, cMsgType, cBody, cSubject : WideString);
begin
    //initialize variables for now
    Create();

    _toJID := cToJid;
    _thread := '';
    _nick := '';
    _action := false;
    _time := Now();
    setSubject(cSubject);
    setBody(cBody);
    setMsgType(cMsgType);
end;

{---------------------------------------}
destructor TJabberMessage.Destroy;
begin
    if (_tag <> nil) then
        _tag.Free();
    if (_addresses <> nil) then begin
        _addresses.Clear();
        _addresses.Free();
    end;        
    inherited destroy;
end;

{---------------------------------------}
function TJabberMessage.GetTag: TXMLTag;
var
    raw_body: WideString;
    mtag: TXMLTag;
begin
    // I made the _tag form allocate the same way, so that we can always free
    // or not. /hildjj
    if (_tag <> nil) then begin
        result := TXMLTag.Create(_tag);
        exit;
    end;

    // build a tag based on this
    Result := TXMLTag.Create;

    with Result do begin
        Name := 'message';
        setAttribute('to', _toJID);
        // prevent sending from='' 
        if (Length(_fromJID) > 0) then
            setattribute('from', _fromJID);
        setAttribute('id', _id);
        if (_msg_type <> 'normal') then
            setAttribute('type', _msg_type);
        ClearTags;
        // next statement for JEP 33 compliance
        if (_addresses.Count >0) then
            AddTag(_addresses.GetTag());
        if _thread <> '' then
            AddBasicTag('thread', _thread);
        if _subject <> '' then
            AddBasicTag('subject', _subject);

        raw_body := _body;
        if _action then raw_body := '/me ' + raw_body;

        AddBasicTag('body', raw_body);

        if (_composing) then begin
          //Add composing event
          mtag := Result.AddTag('x');
          mtag.setAttribute('xmlns', XMLNS_XEVENT);
          mtag.AddTag('composing');
        end;

        if (_xml <> '') then
          addInsertedXML(_xml);
    end;

    _tag := TXMLTag.Create(result);
end;

{---------------------------------------}
procedure TJabberMessage.SetBody(const Value: WideString);
begin
    if _body <> Value then
        _body := Value;

    // Check for actions
    if (Pos ('/me ', _body) = 1) then begin
        _action := true;
        Delete(_body, 1, 4);
    end
    else
        _action := false;

end;

{---------------------------------------}
procedure TJabberMessage.SetMsgType(const Value: WideString);
begin
    if _msg_type <> Value then
        _msg_type := Value;

    if _msg_type = '' then
        _msg_type := 'normal';
end;

{---------------------------------------}
procedure TJabberMessage.SetSubject(const Value: WideString);
begin
    if _subject <> Value then
        _subject := Value;
end;

{---------------------------------------}
procedure TJabberMessage.SetThread(const Value: WideString);
begin
    if _thread <> Value then
        _thread := Value;
end;

{---------------------------------------}
procedure TJabberMessage.AddRecipient(jid: WideString; addrType: WideString = 'to');
begin
    _addresses.AddAddress(jid, addrType);
end;

end.
