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
    _mid: String;

    // menus
    _menu_search: Widestring;

    // db stuff
    _db: TSQLiteDatabase;

    procedure _convertLogs0();
    function _createInfoTable(): string;

  public
    procedure logMessage(log: TXMLTag);
    procedure showLog(jid: Widestring);
    procedure clearLog(jid: Widestring);
    procedure purgeLogs();
  end;

const
    // Original schema
    F0_UJID = 0;
    F0_JID = 1;
    F0_DATE = 2;
    F0_TIME = 3;
    F0_THREAD = 4;
    F0_SUBJECT = 5;
    F0_NICK = 6;
    F0_BODY = 7;
    F0_TYPE = 8;
    F0_OUT = 9;

    // Current ver 1 schema
    F1_UJID = 0;
    F1_MID = 1;
    F1_JID = 2;
    F1_DATE = 3;
    F1_TIME = 4;
    F1_THREAD = 5;
    F1_SUBJECT = 6;
    F1_NICK = 7;
    F1_BODY = 8;
    F1_TYPE = 9;
    F1_OUT = 10;

implementation

uses
    Viewer, XMLUtils, SQLUtils, Controls, Forms,   
    SysUtils, Dialogs, JabberUtils, JabberID, ComServ;

const
    SCHEMA_VER = 1;

{---------------------------------------}
function TSQLLogger._createInfoTable(): string;
var
    mid, cmd, sql: string;
begin
    // Create the info table..
    sql := 'CREATE TABLE jlog_info (machine_id text, version text);';
    _db.ExecSQL(sql);

    // Use a GUID for this machine
    mid := CreateClassID();
    sql := 'INSERT INTO jlog_info VALUES ("%s", %d);';
    cmd := Format(sql, [mid, SCHEMA_VER]);
    _db.ExecSQL(cmd);

    Result := mid;
end;

{-------------- -------------------------}
procedure TSQLLogger.Startup(const ExodusController: IExodusController);
var
    ver: integer;
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
    end
    else
        _path := ExtractFileDir(_fn);

    // If the dir doesn't exist, try to create it.
    if (DirectoryExists(_path) = false) then begin
        CreateDir(_path);
    end;

    // otherwise, error
    if (DirectoryExists(_path) = false) then begin
        MessageDlgW('Could not locale the log path: ' + _path,
            mtError, [mbOK], 0);
        exit;
    end;


    _db := TSQLiteDatabase.Create(_fn);
    if (_db = nil) then begin
        // uh oh..
        MessageDlgW('Could not locate or create the log database: ' + _fn,
            mtError, [mbOK], 0);
        exit;
    end;

    // cache our current username@server
    _cur_user := _exodus.Username + '@' + _exodus.Server;

    // check for original logs table
    tmp := _db.getTable('SELECT name from sqlite_master where name="jlog_info";');
    if (tmp.RowCount = 0) then begin
        tmp.Free();
        _mid := _createInfoTable();

        // Create the table..
        sql := 'CREATE TABLE jlogs (';
        sql := sql + 'user_jid text, ';
        sql := sql + 'machine_id text, ';
        sql := sql + 'jid text, ';
        sql := sql + 'date integer, ';
        sql := sql + 'time float, ';
        sql := sql + 'thread text, ';
        sql := sql + 'subject text, ';
        sql := sql + 'nick text, ';
        sql := sql + 'body text, ';
        sql := sql + 'type text, ';
        sql := sql + 'outbound boolean);';
        _db.ExecSQL(sql);

        tmp := _db.getTable('SELECT name from sqlite_master where name="jlogs";');
        if (tmp.RowCount = 0) then begin
            MessageDlgW('SQL Logging plugin was unable to initialize the database.',
                mtError, [mbOK], 0);
            tmp.Free();
            _db.Free();
            _db := nil;
            exit;
        end;
        tmp.Free();

        // Create the indices
        _db.ExecSQL('CREATE INDEX jlogs_1 on jlogs(jid);');
        _db.ExecSQL('CREATE INDEX jlogs_2 on jlogs(jid, time);');
        _db.ExecSQL('CREATE INDEX jlogs_3 on jlogs(jid, time, thread);');

        // Check for the old-school logs table
        tmp := _db.getTable('SELECT name from sqlite_master where name="logs";');
        if (tmp.RowCount > 0) then
            _convertLogs0();
        tmp.Free();
    end
    else begin
        // TODO: convert old db's
        tmp := _db.GetTable('SELECT version, machine_id FROM jlog_info;');
        ver := SafeInt(tmp.Fields[0]);
        _mid := tmp.Fields[1];
        if (ver < SCHEMA_VER) then begin
            MessageDlgW('SCHEMA VERSION is incorrect!', mtError, [mbOK], 0);
            _db.Free();
            _db := nil;
            exit;
        end;
        tmp.Free();
    end;

    // Register for packets
    _logger := _exodus.RegisterCallback('/log/logger', Self);
    _show := _exodus.RegisterCallback('/log/show', Self);
    _clear := _exodus.RegisterCallback('/log/clear', Self);
    _purge := _exodus.RegisterCallback('/log/purge', Self);
    _sess := _exodus.RegisterCallback('/session', Self);

    // Register menu items
    _menu_search := _exodus.addPluginMenu('Search Logs');
end;

{---------------------------------------}
procedure TSQLLogger._convertLogs0();
var
    di, i: integer;
    ti: double;
    cmd, sql: string;
    logs: TSQLiteTable;
begin
    logs := _db.GetTable('SELECT * FROM logs;');

    sql := 'INSERT INTO jlogs VALUES ("%s", "%s", "%s", %d, %8.6f, "%s", "%s", "%s", "%s", "%s", "%s");';
    for i := 0 to logs.RowCount - 1 do begin
        di := Trunc(StrToDate(logs.Fields[F0_DATE]));
        ti := double(StrToTime(logs.Fields[F0_TIME]));
        cmd := Format(sql, [_cur_user, _mid, logs.Fields[F0_JID], di, ti,
            logs.Fields[F0_THREAD], logs.Fields[F0_SUBJECT],
            logs.Fields[F0_NICK], logs.Fields[F0_BODY], logs.Fields[F0_TYPE],
            logs.Fields[F0_OUT]]);
        _db.ExecSQL(cmd);
        logs.Next();
    end;
    logs.Free();
end;

{---------------------------------------}
procedure TSQLLogger.Shutdown;
begin

    // unreg menu items
    _exodus.removePluginMenu(_menu_search);

    // unreg callbacks
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
var
    h: integer;
    f: TfrmView;
begin
    if (id = _menu_search) then begin
        h := _exodus.CreateDockableWindow('Search Logs');
        f := TfrmView.Create(nil);
        f.ParentWindow := h;
        f.Align := alClient;
        f.BorderStyle := bsNone;

        f.db := _db;
        f.ShowSearch();
        f.Show();
    end;
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
    di: integer;
    ti: double;

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
    mtype := log.getAttribute('type');

    subject := str2sql(UTF8Encode(log.GetBasicText('subject')));
    nick := str2sql(UTF8Encode(log.getAttribute('nick')));
    body := str2sql(UTF8Encode(log.GetBasicText('body')));

    if (outb) then outstr := 'TRUE' else outstr := 'FALSE';

    ts := Now();
    d := log.QueryXPTag('/logger/x[@xmlns="jabber:x:delay"]');
    if (d <> nil) then begin
        if (d.Data <> '') then
            ts := JabberToDateTime(d.Data);
    end;

    cmd := 'INSERT INTO jlogs VALUES ("%s", "%s", "%s", %d, %8.6f, "%s", "%s", "%s", "%s", "%s", "%s");';
    di := Trunc(ts);
    ti := Frac(double(ts));
    sql := Format(cmd, [user_jid, _mid, jid, di, ti, thread, subject, nick, body, mtype, outstr]);
    _db.ExecSQL(sql);
end;

{---------------------------------------}
procedure TSQLLogger.showLog(jid: Widestring);
var
    h: integer;
    f: TfrmView;
begin
    h := _exodus.CreateDockableWindow('SQL Log Viewer');

    f := TfrmView.Create(nil);
    f.ParentWindow := h;

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
