unit LoggerPlugin;

{
    Copyright 2004, Peter Millard

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

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    XMLParser, XMLTag, JabberMsg, Graphics,
    ExodusCOM_TLB, ComObj, ActiveX, ExHTMLLogger_TLB, StdVcl;

type
  THTMLLogger = class(TAutoObject, IExodusPlugin)
  protected
    function NewIM(const jid: WideString; var Body, Subject: WideString;
      const XTags: WideString): WideString; safecall;
    procedure Configure; safecall;
    procedure MenuClick(const ID: WideString); safecall;
    procedure MsgMenuClick(const ID, jid: WideString; var Body,
      Subject: WideString); safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat);
      safecall;
    procedure NewOutgoingIM(const jid: WideString;
      const InstantMsg: IExodusChat); safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat);
      safecall;
    procedure Process(const xpath, event, xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(const ExodusController: IExodusController); safecall;

  private
    _exodus: IExodusController;
    _parser: TXMLTagParser;
    _cb: integer;
    _path: Widestring;
    _timestamp: boolean;
    _format: Widestring;
    _bg: TColor;
    _me: TColor;
    _other: TColor;
    _font_name: Widestring;
    _font_size: Widestring;

    function GetMsgHTML(Msg: TJabberMessage): string;
    function ColorToHTML(Color: TColor): string;


  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    XMLUtils, Windows, IdGlobal,
    Dialogs, SysUtils, Classes, JabberID, ComServ;
{---------------------------------------}
function JabberToDateTime(datestr: string): TDateTime;
var
    rdate: TDateTime;
    ys, ms, ds, ts: string;
    yw, mw, dw: Word;
begin
    // translate date from 20000110T19:54:00 to proper format..
    ys := Copy(Datestr, 1, 4);
    ms := Copy(Datestr, 5, 2);
    ds := Copy(Datestr, 7, 2);
    ts := Copy(Datestr, 10, 8);

    yw := StrToInt(ys);
    mw := StrToInt(ms);
    dw := StrToInt(ds);

    if (TryEncodeDate(yw, mw, dw, rdate)) then begin
        rdate := rdate + StrToTime(ts);
        Result := rdate - TimeZoneBias();
    end
    else
        Result := Now;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure THTMLLogger.Startup(const ExodusController: IExodusController);
begin
    _exodus := ExodusController;
    _parser := TXMLTagParser.Create();

    // get some configs
    _path := _exodus.getPrefAsString('log_path');
    _timestamp := _exodus.getPrefAsBool('timestamp');
    _format := _exodus.getPrefAsString('timestamp_format');
    _bg := TColor(_exodus.getPrefAsInt('color_bg'));
    _me := TColor(_exodus.getPrefAsInt('color_me'));
    _other := TColor(_exodus.getPrefAsInt('color_other'));
    _font_name := _exodus.getPrefAsString('font_name');
    _font_size := _exodus.getPrefAsString('font_size');

    // Register for packets
    _cb := _exodus.RegisterCallback('/log/logger', Self);
end;

{---------------------------------------}
procedure THTMLLogger.Shutdown;
begin
    _exodus.UnRegisterCallback(_cb);
    _parser.Free();
end;

{---------------------------------------}
function THTMLLogger.ColorToHTML(Color: TColor): string;
var
    rgb: longint;
begin
    rgb := ColorToRGB(Color);
    result := Format( '#%.2x%.2x%.2x', [ GetRValue(rgb),
                GetGValue(rgb), GetBValue(rgb)]);
end;

{---------------------------------------}
function THTMLLogger.GetMsgHTML(Msg: TJabberMessage): string;
var
    html, txt: Widestring;
    ret, color, time, bg, font: string;
    cr_pos: integer;
begin
    // replace CR's w/ <br> tags
    txt := HTML_EscapeChars(Msg.Body, false);
    repeat
        cr_pos := Pos(#13#10, txt);
        if cr_pos > 0 then begin
            Delete(txt, cr_pos, 2);
            Insert('<br />', txt, cr_pos);
        end;
    until (cr_pos <= 0);

    if (_timestamp) then
        time := '<span style="color: gray;">[' +
                FormatDateTime(_format, Msg.Time) +
                ']</span>'
    else
        time := '';
    bg := 'background-color: ' + ColorToHTML(_bg) + ';';

    //font-family: Arial Black; font-size: 10pt
    font := 'font-family: ' + _font_name + '; ' +
            'font-size: ' + _font_size + 'pt;';
    if Msg.Action then
        html := '<div style="' + bg + font + '">' + time +
                '<span style="color: purple;">* ' + Msg.Nick + ' ' + txt + '</span></div>'
    else begin
        if Msg.isMe then
            color := ColorToHTML(_me)
        else
            color := ColorToHTML(_other);

        if (Msg.Nick <> '') then
            html := '<div style="' + bg + font + '">' +
                time + '<span style="color: ' + color + ';">&lt;' +
                Msg.Nick + '&gt;</span> ' + txt + '</div>'
        else
            html := '<div style="' + bg + font + '">' +
                time + '<span style="color: green;">' +
                txt + '</span></div>';
    end;

    ret := UTF8Encode(html);
    Result := ret;
end;


{---------------------------------------}
function THTMLLogger.NewIM(const jid: WideString; var Body,
  Subject: WideString; const XTags: WideString): WideString;
begin

end;

{---------------------------------------}
procedure THTMLLogger.Configure;
begin

end;

{---------------------------------------}
procedure THTMLLogger.MenuClick(const ID: WideString);
begin

end;

{---------------------------------------}
procedure THTMLLogger.MsgMenuClick(const ID, jid: WideString; var Body,
  Subject: WideString);
begin

end;

{---------------------------------------}
procedure THTMLLogger.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin

end;

{---------------------------------------}
procedure THTMLLogger.NewOutgoingIM(const jid: WideString;
  const InstantMsg: IExodusChat);
begin

end;

{---------------------------------------}
procedure THTMLLogger.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin

end;

{---------------------------------------}
procedure THTMLLogger.Process(const xpath, event, xml: WideString);
var
    d, log: TXMLTag;
    buff: string;
    fn: Widestring;
    header: boolean;
    j: TJabberID;
    ndate: TDateTime;
    fs: TFileStream;
    msg: TJabberMessage;
begin
    // parse the log msg
    _parser.ParseString(xml, '');
    if (_parser.Count = 0) then exit;
    log := _parser.popTag();

    msg := TJabberMessage.Create();
    msg.ToJID := log.getAttribute('to');
    msg.FromJid := log.getAttribute('from');
    if (log.getAttribute('dir') = 'out') then
        msg.isMe := true
    else
        msg.isMe := false;
    msg.Nick := log.getAttribute('nick');
    msg.id := log.getAttribute('id');
    msg.MsgType := log.getAttribute('type');
    msg.Body := log.GetBasicText('body');
    msg.thread := log.GetBasicText('thread');
    msg.subject := log.GetBasicText('subject');

    d := log.QueryXPTag('/logger/x[@xmlns="jabber:x:delay"]');
    if (d <> nil) then begin
        if (d.Data <> '') then
            msg.Time := JabberToDateTime(d.Data);
    end;

    // prepare to log
    fn := _path;

    if (msg.isMe) then
        j := TJabberID.Create(msg.ToJid)
    else
        j := TJabberID.Create(msg.FromJid);


    if (Copy(fn, length(fn), 1) <> '\') then
        fn := fn + '\';

    if (not DirectoryExists(fn)) then begin
        // mkdir
        if CreateDir(fn) = false then begin
            // XXX:
            MessageDlg('Bad logging directory specified. Reconfigure plugin.',
                mtError, [mbOK], 0);
            exit;
        end;
    end;

    // Munge the filename
    fn := fn + MungeName(j.jid) + '.html';

    try
        if (FileExists(fn)) then begin
            fs := TFileStream.Create(fn, fmOpenReadWrite, fmShareDenyNone);
            ndate := FileDateToDateTime(FileGetDate(fs.Handle));
            header := (abs(Now - nDate) > 0.04);
            fs.Seek(0, soFromEnd);
        end
        else begin
            fs := TFileStream.Create(fn, fmCreate, fmShareDenyNone);

            // put some UTF-8 header fu in here
            buff := '<html><head>';
            buff := buff + '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
            buff := buff + '</head>';
            fs.Write(Pointer(buff)^, Length(buff));

            // Make sure to put a new conversation header
            header := true;
        end;
    except
        on e: Exception do begin
            MessageDlg('Could not open log file: ' + fn, mtError, [mbOK], 0);
            exit;
        end;
    end;

    if (header) then begin
        buff := '<p><font size=+1><b>New Conversation at: ' +
            DateTimeToStr(Now) + '</b></font><br />';
        fs.Write(Pointer(buff)^, Length(buff));
    end;

    buff := GetMsgHTML(Msg);
    fs.Write(Pointer(buff)^, Length(buff));
    fs.Free();

    j.Free();
end;

initialization
  TAutoObjectFactory.Create(ComServer, THTMLLogger, Class_HTMLLogger,
    ciMultiInstance, tmApartment);
end.
