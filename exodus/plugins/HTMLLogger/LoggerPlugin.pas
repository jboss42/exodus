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
    Exodus_TLB, ComObj, ActiveX, ExHTMLLogger_TLB, StdVcl;

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

    // callbacks
    _logger: integer;
    _show: integer;
    _purge: integer;
    _clear: integer;

    _path: Widestring;
    _roster: boolean;
    _rooms: boolean;
    _timestamp: boolean;
    _format: Widestring;
    _bg: TColor;
    _me: TColor;
    _other: TColor;
    _font_name: Widestring;
    _font_size: Widestring;

    function _getMsgHTML(Msg: TJabberMessage): string;
    procedure _logMessage(log: TXMLTag);
    procedure _showLog(jid: Widestring);
    procedure _clearLog(jid: Widestring);

  public
    procedure purgeLogs();
    property ExodusController: IExodusController read _exodus;

  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Prefs,
    JabberUtils, XMLUtils, Windows, IdGlobal, StrUtils, 
    Controls, ShellAPI, Dialogs, SysUtils, Classes, JabberID, ComServ;

const
    sNoHistory = 'There is no history file for this contact.';
    sBadLogDir = 'The log directory you specified is invalid. Configure the HTML Logging plugin correctly.';
    sHistoryDeleted = 'History deleted.';
    sHistoryError = 'Could not delete history file.';
    sHistoryNone = 'No history file for this user.';
    sConfirmClearLog = 'Do you really want to clear the log for %s?';
    sConfirmClearAllLogs = 'Are you sure you want to delete all of your message and room logs?';
    sFilesDeleted = 'HTML log files deleted.';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure THTMLLogger.Startup(const ExodusController: IExodusController);
begin
    _exodus := ExodusController;
    _parser := TXMLTagParser.Create();

    // get some configs
    _path := _exodus.getPrefAsString('log_path');
    _roster := _exodus.getPrefAsBool('log_roster');
    _rooms := _exodus.getPrefAsBool('log_rooms');

    _timestamp := _exodus.getPrefAsBool('timestamp');
    _format := _exodus.getPrefAsString('timestamp_format');
    _bg := TColor(_exodus.getPrefAsInt('color_bg'));
    _me := TColor(_exodus.getPrefAsInt('color_me'));
    _other := TColor(_exodus.getPrefAsInt('color_other'));
    _font_name := _exodus.getPrefAsString('font_name');
    _font_size := _exodus.getPrefAsString('font_size');

    // Register for packets
    _logger := _exodus.RegisterCallback('/log/logger', Self);
    _show := _exodus.RegisterCallback('/log/show', Self);
    _clear := _exodus.RegisterCallback('/log/clear', Self);
    _purge := _exodus.RegisterCallback('/log/purge', Self);
end;

{---------------------------------------}
procedure THTMLLogger.Shutdown;
begin
    _exodus.UnRegisterCallback(_logger);
    _exodus.UnRegisterCallback(_show);
    _exodus.UnRegisterCallback(_clear);
    _exodus.UnRegisterCallback(_purge);

    _parser.Free();
end;

{---------------------------------------}
function THTMLLogger._getMsgHTML(Msg: TJabberMessage): string;
var
    html, txt: Widestring;
    ret, color, time, bg, font: string;
    cr_pos: integer;
begin
    // replace CR's w/ <br> tags
    txt := HTML_EscapeChars(Msg.Body, false, true);
    repeat
        cr_pos := Pos(#13#10, txt);
        if cr_pos > 0 then begin
            Delete(txt, cr_pos, 2);
            Insert('<br />', txt, cr_pos);
        end;
    until (cr_pos <= 0);

    // Get our window bg color in there
    bg := 'background-color: ' + ColorToHTML(_bg) + ';';

    //font-family: Arial Black; font-size: 10pt
    font := 'font-family: ' + _font_name + '; ' +
            'font-size: ' + _font_size + 'pt;';

    // this is the output buffer
    html := '';

    // Make sure we do something with the subject..
    if (Msg.Subject <> '') then begin
        html := html + '<div style="' + bg + font + '">' + Msg.Nick +
            ' set the subject to: ' + Msg.Subject + '</div>'#13#10;
    end;

    // timestamp if we're supposed to..
    if (_timestamp) then
        time := '<span style="color: gray;">[' +
                FormatDateTime(_format, Msg.Time) +
                ']</span>'
    else
        time := '';

    if Msg.Action then begin
        html := html + '<div style="' + bg + font + '">' + time +
                '<span style="color: purple;">* ' + Msg.Nick + ' ' + txt + '</span></div>';
    end
    else begin
        if Msg.isMe then
            color := ColorToHTML(_me)
        else
            color := ColorToHTML(_other);

        if (Msg.Nick <> '') then
            html := html + '<div style="' + bg + font + '">' +
                time + '<span style="color: ' + color + ';">&lt;' +
                Msg.Nick + '&gt;</span> ' + txt + '</div>'
        else
            html := html + '<div style="' + bg + font + '">' +
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
var
    p: TfrmPrefs;
begin
    p := TfrmPrefs.Create(nil);
    p.Logger := Self;
    p.txtLogPath.Text := _path;
    p.chkLogRooms.Checked := _rooms;
    p.chkLogRoster.Checked := _roster;

    if (p.ShowModal() = mrOK) then begin
        _path := p.txtLogPath.Text;
        _rooms := p.chkLogRooms.Checked;
        _roster := p.chkLogRoster.Checked;

        _exodus.setPrefAsString('log_path', _path);
        _exodus.setPrefAsBool('log_rooms', _rooms);
        _exodus.setPrefAsBool('log_roster', _roster);
    end;

    p.Free();    
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
    x: TXMLTag;
begin
    _parser.ParseString(xml, '');
    if (_parser.Count = 0) then exit;

    x := _parser.popTag();

    if (x.Name = 'logger') then
        _logMessage(x)
    else if (x.Name = 'show') then
        _showLog(x.getAttribute('jid'))
    else if (x.Name = 'clear') then
        _clearLog(x.getAttribute('jid'))
    else if (x.Name = 'purge') then
        purgeLogs();

end;

{---------------------------------------}
procedure THTMLLogger._logMessage(log: TXMLTag);
var
    d: TXMLTag;
    buff: string;
    rjid, fn: Widestring;
    header: boolean;
    j: TJabberID;
    ndate: TDateTime;
    fs: TFileStream;
    msg: TJabberMessage;
    ritem: IExodusRosterItem;
begin
    msg := TJabberMessage.Create();
    msg.ToJID := log.getAttribute('to');
    msg.FromJid := log.getAttribute('from');

    if (log.getAttribute('dir') = 'out') then begin
        msg.isMe := true;
        rjid := Msg.ToJid;
    end
    else begin
        msg.isMe := false;
        rjid := Msg.FromJid;
    end;

    // check the roster for the rjid, and bail if we aren't logging non-roster folk
    if (_roster) then begin
        ritem := _exodus.Roster.find(rjid);
        if (ritem = nil) then begin
            msg.Free();
            exit;
        end;
    end;

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
            msg.Free();
            MessageDlg(sBadLogDir, mtError, [mbOK], 0);
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
            msg.Free();
            exit;
        end;
    end;

    if (header) then begin
        buff := '<p><font size=+1><b>New Conversation at: ' +
            DateTimeToStr(Now) + '</b></font><br />';
        fs.Write(Pointer(buff)^, Length(buff));
    end;

    buff := _getMsgHTML(Msg);
    fs.Write(Pointer(buff)^, Length(buff));
    fs.Free();
    j.Free();
    Msg.Free();
end;

{---------------------------------------}
procedure THTMLLogger._showLog(jid: Widestring);
var
    fn: string;
begin
    // Show the log, or ask the user to turn on logging
    fn := _path + '\' + MungeName(jid) + '.html';
    if (not FileExists(fn)) then begin
        MessageDlgW('There is no history for this contact.', mtError, [mbOK], 0, 'HTML Logger Plugin');
        exit;
    end;

    ShellExecute(0, 'open', PChar(fn), '', '', SW_NORMAL);
end;

{---------------------------------------}
procedure THTMLLogger._clearLog(jid: Widestring);
var
    fn: string;
begin
    if (MessageDlgW(WideFormat(sConfirmClearLog, [jid]),
        mtConfirmation, [mbOK,mbCancel], 0) = mrCancel) then
        exit;

    fn := _path;
    if (Copy(fn, length(fn), 1) <> '\') then
        fn := fn + '\';

    // Munge the filename
    fn := fn + MungeName(jid) + '.html';
    if FileExists(fn) then begin
        if (DeleteFile(PChar(fn))) then
            MessageDlgW(sHistoryDeleted, mtInformation, [mbOK], 0)
        else
            MessageDlgW(sHistoryError, mtError, [mbCancel], 0);
    end
    else
        MessageDlgW(sHistoryNone, mtWarning, [mbOK,mbCancel], 0);
end;

{---------------------------------------}
procedure THTMLLogger.purgeLogs();
var
    cmd, fn: string;
begin
    if (MessageDlgW(sConfirmClearAllLogs,
        mtConfirmation, [mbOK,mbCancel], 0) = mrCancel) then exit;

    fn := _path;
    if (AnsiRightStr(fn, 1) <> '\') then
        fn := fn + '\';

    // just shell exec a delete command.. easiest way to handle this
    cmd := 'del "' + fn + '*.html"';
    ShellExecute(0, PChar(cmd), nil, nil, nil, SW_HIDE);

    MessageDlgW(sFilesDeleted, mtInformation, [mbOK], 0);
end;

initialization
  TAutoObjectFactory.Create(ComServer, THTMLLogger, Class_HTMLLogger,
    ciMultiInstance, tmApartment);
end.
