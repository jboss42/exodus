unit SQLPlugin;
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
    XMLParser, XMLTag, JabberMsg, SQLiteTable,
    ExodusCOM_TLB, ComObj, ActiveX, ExSQLLogger_TLB, StdVcl;

type
  TSQLLogger = class(TAutoObject, IExodusPlugin)
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
    _sess: integer;

    // prefs
    _path: Widestring;
    _fn: Widestring;
    _cur_user: Widestring;

    // db stuff
    _db: TSQLiteDatabase;

  public
    procedure logMessage(log: TXMLTag);
    procedure showLog(jid: Widestring);
    procedure clearLog(jid: Widestring);
    procedure purgeLogs();
  end;

implementation

uses
    Viewer, 
    SysUtils, Dialogs, JabberUtils, JabberID, ComServ;

{---------------------------------------}
procedure TSQLLogger.Startup(const ExodusController: IExodusController);
var
    sql: string;
    tmp: TSQLiteTable;
begin
    _exodus := ExodusController;
    _parser := TXMLTagParser.Create();
    _db := nil;

    // Prefs
    _fn := _exodus.getPrefAsString('log_sql_filename');

    if (_fn = '') then begin
        _path := _exodus.getPrefAsString('log_path');
        _fn := _path + '\exodus-logs.db';
        _exodus.setPrefAsString('log_sql_filename', _fn);
    end;

    _db := TSQLiteDatabase.Create(_fn);
    if (_db = nil) then begin
        // uh oh..
        MessageDlgW('Could not locate or create the log database: ' + _fn,
            mtError, [mbOK], 0);
        exit;
    end;

    tmp := _db.getTable('SELECT name from sqlite_master where name="logs";');
    if (tmp.RowCount = 0) then begin
        // Create the table..
        sql := 'CREATE TABLE logs (';
        sql := sql + 'user_jid text, ';
        sql := sql + 'jid text, ';
        sql := sql + 'date text, ';
        sql := sql + 'time text, ';
        sql := sql + 'thread text, ';
        sql := sql + 'subject text, ';
        sql := sql + 'nick text, ';
        sql := sql + 'body text, ';
        sql := sql + 'type text, ';
        sql := sql + 'outbound boolean);';
        _db.ExecSQL(sql);

        tmp := _db.getTable('SELECT name from sqlite_master where name="logs";');
        if (tmp.RowCount = 0) then begin
            MessageDlgW('SQL Logging plugin was unable to initialize the database.',
                mtError, [mbOK], 0);
            _db.Free();
            _db := nil;
        end;

        // Create the indices
        _db.ExecSQL('CREATE INDEX logs_1 on logs(jid);');
        _db.ExecSQL('CREATE INDEX logs_2 on logs(jid, time);');
        _db.ExecSQL('CREATE INDEX logs_3 on logs(jid, time, thread);');
    end;

    // Register for packets
    _logger := _exodus.RegisterCallback('/log/logger', Self);
    _show := _exodus.RegisterCallback('/log/show', Self);
    _clear := _exodus.RegisterCallback('/log/clear', Self);
    _purge := _exodus.RegisterCallback('/log/purge', Self);
    _sess := _exodus.RegisterCallback('/session', Self);

    // cache our current username@server
    _cur_user := _exodus.Username + '@' + _exodus.Server;
end;

{---------------------------------------}
procedure TSQLLogger.Shutdown;
begin
    _exodus.UnRegisterCallback(_logger);
    _exodus.UnRegisterCallback(_show);
    _exodus.UnRegisterCallback(_clear);
    _exodus.UnRegisterCallback(_purge);
    _exodus.UnRegisterCallback(_sess);

    _parser.Free();
end;

{---------------------------------------}
procedure TSQLLogger.Process(const xpath, event, xml: WideString);
var
    x: TXMLTag;
begin

    // grab our new username
    if (event = '/session/connected') then begin
        _cur_user := _exodus.Username + '@' + _exodus.Server;
        exit;
    end;

    _parser.ParseString(xml, '');
    if (_parser.Count = 0) then exit;

    x := _parser.popTag();

    if (x.Name = 'logger') then
        logMessage(x)
    else if (x.Name = 'show') then
        showLog(x.getAttribute('jid'))
    else if (x.Name = 'clear') then
        clearLog(x.getAttribute('jid'))
    else if (x.Name = 'purge') then
        purgeLogs();
end;

{---------------------------------------}
function TSQLLogger.NewIM(const jid: WideString; var Body,
  Subject: WideString; const XTags: WideString): WideString;
begin

end;

{---------------------------------------}
procedure TSQLLogger.Configure;
begin

end;

{---------------------------------------}
procedure TSQLLogger.MenuClick(const ID: WideString);
begin

end;

{---------------------------------------}
procedure TSQLLogger.MsgMenuClick(const ID, jid: WideString; var Body,
  Subject: WideString);
begin

end;

{---------------------------------------}
procedure TSQLLogger.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin

end;

{---------------------------------------}
procedure TSQLLogger.NewOutgoingIM(const jid: WideString;
  const InstantMsg: IExodusChat);
begin

end;

{---------------------------------------}
procedure TSQLLogger.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin

end;

{---------------------------------------}
procedure TSQLLogger.logMessage(log: TXMLTag);
var
    d: TXMLTag;
    cmd: String;
    sql: String;
    fromjid: TJabberID;
    tojid: TJabberID;
    outb: boolean;
    ts: TDatetime;

    // db fields
    user_jid: string;
    jid: string;
    thread: string;
    subject: string;
    nick: string;
    body: string;
    mtype: string;
    dstr: string;
    tstr: string;
    outstr: string;
begin
    outb := (log.getAttribute('dir') = 'out');

    fromjid := TJabberID.Create(log.getAttribute('from'));
    tojid := TJabberID.Create(log.getAttribute('to'));

    user_jid := UTF8Encode(_cur_user);
    if (outb) then
        jid := UTF8Encode(tojid.jid)
    else
        jid := UTF8Encode(fromjid.jid);

    thread := UTF8Encode(log.GetBasicText('thread'));
    subject := UTF8Encode(log.GetBasicText('subject'));
    nick := UTF8Encode(log.getAttribute('nick'));
    body := UTF8Encode(log.GetBasicText('body'));
    mtype := log.getAttribute('type');

    if (outb) then outstr := 'TRUE' else outstr := 'FALSE';

    ts := Now();
    d := log.QueryXPTag('/logger/x[@xmlns="jabber:x:delay"]');
    if (d <> nil) then begin
        if (d.Data <> '') then
            ts := JabberToDateTime(d.Data);
    end;

    dstr := DateToStr(ts);
    tstr := TimeToStr(ts);

    cmd := 'INSERT INTO logs VALUES("%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s");';
    sql := Format(cmd, [user_jid, jid, dstr, tstr, thread, subject, nick, body, mtype, outstr]);

    _db.ExecSQL(sql);
end;

{---------------------------------------}
procedure TSQLLogger.showLog(jid: Widestring);
var
    f: TfrmView;
begin
    f := TfrmView.Create(nil);
    f.db := _db;
    f.ShowJid(jid);
    f.Show();
end;

{---------------------------------------}
procedure TSQLLogger.clearLog(jid: Widestring);
begin
    //
end;

{---------------------------------------}
procedure TSQLLogger.purgeLogs();
begin
    //
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSQLLogger, Class_SQLLogger,
    ciMultiInstance, tmApartment);
end.
