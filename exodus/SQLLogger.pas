unit SQLLogger;
{
    Copyright 2008, Estate of Peter Millard

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
    COMExodusDataStore,
    JabberMsg;

type
    TSQLLogger = class(TObject{, IExodusSearchHandler})
        private

            // Variables

            // Methods
            procedure _CreateLoggerTable();

            // IExodusSearchHandler Interface

        protected
            // Variables

            // Methods

        public
            // Variables

            // Methods
            constructor Create();

            procedure LogMsg(msg: TJabberMessage);

            // Properties
    end;

const
    MESSAGES_TABLE = 'messages';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ExSession,
    JabberID,
    sysUtils,
    XMLUtils,
    SQLUtils;

{---------------------------------------}
constructor TSQLLogger.Create;
begin
    if (DataStore = nil) then exit;

    _CreateLoggerTable();
end;

{---------------------------------------}
procedure TSQLLogger._CreateLoggerTable();
var
    sql: string;
begin
    // No need to create if it already exists
    if (DataStore.CheckForTableExistence(MESSAGES_TABLE)) then exit;

    // Create the table..
    sql := 'CREATE TABLE ' +  MESSAGES_TABLE + ' (';
    sql := sql + 'msgid INTEGER PRIMARY KEY AUTOINCREMENT, '; // Auto increment
    sql := sql + 'user_jid TEXT, '; // My JID
    sql := sql + 'jid TEXT, '; // Other JID
    sql := sql + 'date INTEGER, ';
    sql := sql + 'time FLOAT, ';
    sql := sql + 'thread TEXT, ';
    sql := sql + 'subject TEXT, ';
    sql := sql + 'nick TEXT, ';
    sql := sql + 'body TEXT, ';
    sql := sql + 'type TEXT, ';
    sql := sql + 'outbound BOOLEAN, ';
//    sql := sql + 'priority INTEGER, '; //???dda
    sql := sql + 'xml TEXT);';

    try
        DataStore.ExecSQL(sql);
        DataStore.ExecSQL('CREATE INDEX ' + MESSAGES_TABLE + '_idx1 on ' + MESSAGES_TABLE + '(jid);');
        DataStore.ExecSQL('CREATE INDEX ' + MESSAGES_TABLE + '_idx2 on ' + MESSAGES_TABLE + '(jid, time);');
        DataStore.ExecSQL('CREATE INDEX ' + MESSAGES_TABLE + '_idx3 on ' + MESSAGES_TABLE + '(jid, time, thread);');
    except
    end;
end;

{---------------------------------------}
procedure TSQLLogger.LogMsg(msg: TJabberMessage);
var
    sql: string;
    cmd: string;

    di: integer;
    ti: double;
    fromjid: TJabberID;
    tojid: TJabberID;
    outb: boolean;
    ts: TDatetime;
    user_jid: string;
    jid: string;
    thread: string;
    subject: string;
    nick: string;
    body: string;
    mtype: string;
    outstr: string;
    xml: string;
    priority: integer;
begin
    if (DataStore = nil) then exit;

    outb := (msg.isMe);

    fromjid := TJabberID.Create(msg.FromJID);
    tojid := TJabberID.Create(msg.ToJID);

    if (outb) then begin
        jid := UTF8Encode(tojid.jid);
        user_jid := UTF8Encode(fromjid.jid);
        outstr := 'TRUE';
    end
    else begin
        jid := UTF8Encode(fromjid.jid);
        user_jid := UTF8Encode(tojid.jid);
        outstr := 'FALSE';
    end;

    thread := UTF8Encode(msg.Thread);
    mtype := msg.MsgType;

    subject := str2sql(UTF8Encode(msg.Subject));
    nick := str2sql(UTF8Encode(msg.nick));
    body := str2sql(UTF8Encode(msg.Body));
    xml := str2sql(UTF8Encode(XML_EscapeChars(msg.Tag.XML)));

    case (msg.Priority) of
        high: priority := 0;
        medium: priority := 1;
        low: priority := 2;
        else priority := 3;
    end;

    ts := msg.Time;

    cmd := 'INSERT INTO ' +
           MESSAGES_TABLE + ' ' +
           '(user_jid, jid, date, time, thread, subject, nick, body, type, outbound, xml) ' +
           'VALUES (''%s'', ''%s'', %d, %8.6f, ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'');';
//    cmd := 'INSERT INTO ' +
//           MESSAGES_TABLE + ' ' +
//           '(user_jid, jid, date, time, thread, subject, nick, body, type, outbound, priority, xml) ' +
//           'VALUES (''%s'', ''%s'', %d, %8.6f, ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', %d, ''%s'');';  //???dda

    di := Trunc(ts);
    ti := Frac(double(ts));
    sql := Format(cmd, [user_jid, jid, di, ti, thread, subject, nick, body, mtype, outstr, xml]);
//    sql := Format(cmd, [user_jid, jid, di, ti, thread, subject, nick, body, mtype, outstr, priority, xml]); //???dda

    try
        DataStore.ExecSQL(sql);
    except
    end;

    fromjid.Free();
    tojid.Free();
end;





end.
