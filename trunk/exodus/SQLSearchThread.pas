unit SQLSearchThread;
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
    Classes,
    COMExodusDataStore,
    COMExodusDataTable,
    Exodus_TLB,
    JabberMsg;

type
    TSQLThreadResult = procedure(SearchID: widestring; msg: TJabberMessage) of object;
    TSQLSearchThread = class(TThread)
        private
            // Variables
            _DataStore: TExodusDataStore;
            _SQLStatement: Widestring;
            _msg: TJabberMessage;
            _SearchID: Widestring;
            _callback: TSQLThreadResult;
            _callbackSet: boolean;
            _table: IExodusDataTable;

            // Methods
            procedure _ProcessResultTable();
            procedure _OnResult();

        protected
            // Variables

            // Methods
        public
            // Variables

            // Methods
            constructor Create();

            procedure Execute; override;
            procedure SetCallback(callback: TSQLThreadResult);
            procedure SetTable(table: IExodusDataTable);

            // Properties
            property DataStore: TExodusDataStore write _DataStore;
            property SQLStatement: Widestring write _SQLStatement;
            property msg: TJabberMessage read _msg;
            property SearchID: Widestring read _SearchID write _SearchID;
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    sysUtils,
    XMLTag,
    XMLParser,
    XMLUtils,
    ComObj;


{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure SQLSearchThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TSQLSearchThread }

{---------------------------------------}
constructor TSQLSearchThread.Create();
begin
    inherited Create(true);
    _DataStore := nil;
    _SQLStatement := '';
    _msg := nil;
    _callback := nil;
    _callbackSet := false;
    Self.FreeOnTerminate := true;
end;

{---------------------------------------}
procedure TSQLSearchThread.Execute;
begin
    if (_DataStore = nil) then exit;
    if (_SQLStatement = '') then exit;

    if (_table <> nil) then begin
        _DataStore.GetTable(_SQLStatement, _table);
        _ProcessResultTable();
    end;

    _table := nil;
end;

{---------------------------------------}
procedure TSQLSearchThread._ProcessResultTable();
const
    msgid_col = 0;
    user_jid_col = 1;
    jid_col = 2;
    date_col = 3;
    time_col = 4;
    thread_col = 5;
    subject_col = 6;
    nick_col = 7;
    body_col = 8;
    type_col = 9;
    outbound_col = 10;
    priority_col = 11;
    xml_col = 12;
var
    tag: TXMLTag;
    i: integer;
    tmp: widestring;
    parser: TXMLTagParser;
begin
    if (_table = nil) then exit;

    try
        parser := TXMLTagParser.Create();

        _table.FirstRow();
        for i := 0 to _table.RowCount - 1 do begin
            tmp := _table.GetField(xml_col);
            if (tmp <> '') then begin
                // if we have the tag stored, try and recreate
                // jabber message using stored tag
                tmp := XML_UnEscapeChars(tmp);
                parser.ParseString(tmp, '');
                tag := parser.popTag();
                _msg := TJabberMessage.Create(tag);

                // Override the TJabberMessage timestamp
                // as it puts a Now() timestamp on when it
                // doesn't find the MSGDELAY tag.  As we
                // are pulling the original XML, it probably
                // didn't have this tag when we stored it.
                _msg.Time := _table.GetFieldAsInt(date_col) +
                             _table.GetFieldAsDouble(time_col);
                tag.Free();
            end
            else begin
                // No tag stored
                _msg := TJabberMessage.Create();

                if (_table.GetField(outbound_col) = 'TRUE') then begin
                    _msg.ToJID := _table.GetField(jid_col);
                    _msg.FromJID := _table.GetField(user_jid_col);
                    if (_msg.FromJID <> '') then begin
                        _msg.isMe := true;
                    end;
                end
                else begin
                    _msg.ToJID := _table.GetField(user_jid_col);
                    _msg.FromJID := _table.GetField(jid_col);
                end;
                _msg.Subject := _table.GetField(subject_col);
                _msg.Thread := _table.GetField(thread_col);
                _msg.Body := _table.GetField(body_col);
                _msg.MsgType := _table.GetField(type_col);
                _msg.Nick := _table.GetField(nick_col);
                _msg.Time := _table.GetFieldAsInt(date_col) +
                             _table.GetFieldAsDouble(time_col);
                //_msg.XML := table.GetField(xml_col); // The xml part of a JabberMsg is not the xml that was parsed to create the object.
                case _table.GetFieldAsInt(priority_col) of
                    0: _msg.Priority := high;
                    1: _msg.Priority := medium;
                    2: _msg.Priority := low;
                    else begin
                        _msg.Priority := none;
                    end;    
                end;
            end;

            Synchronize(Self._OnResult);  // blocks here
            _msg.Free();
            _msg := nil;

            if (i < _table.RowCount - 1) then begin
                _table.NextRow();
            end;
        end;

        Synchronize(Self._OnResult); // Send nil as end of result set.

        parser.Free();
    except
    end;
end;

{---------------------------------------}
procedure TSQLSearchThread._OnResult();
begin
    if (not _callbackSet) then exit;

    _callback(_SearchID, _msg);
end;

{---------------------------------------}
procedure TSQLSearchThread.SetCallback(callback: TSQLThreadResult);
begin
    _callbackSet := true;
    _callback := callback;
end;

{---------------------------------------}
procedure TSQLSearchThread.SetTable(table: IExodusDataTable);
begin
    if (table = nil) then exit;

    _table := table;
end;



end.
