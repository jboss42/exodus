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
    Classes, COMExodusDataStore, COMExodusDataTable,
    Exodus_TLB, JabberMsg;

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

            // Methods
            procedure _ProcessResultTable(table: IExodusDataTable);
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
    sysUtils, XMLTag, XMLParser,
    XMLUtils;


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

    _ProcessResultTable(_DataStore.GetTable(_SQLStatement));
end;

{---------------------------------------}
procedure TSQLSearchThread._ProcessResultTable(table: IExodusDataTable);
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
    xml_col = 11;
var
    tag: TXMLTag;
    i: integer;
    tmp: widestring;
    parser: TXMLTagParser;
begin
    if (table = nil) then exit;

    try
        parser := TXMLTagParser.Create();

        table.FirstRow();
        for i := 0 to table.RowCount - 1 do begin
            tmp := table.GetField(xml_col);
            if (tmp <> '') then begin
                // if we have the tag stored, try and recreate
                // jabber message using stored tag
                tmp := XML_UnEscapeChars(tmp);
                parser.ParseString(tmp, '');
                tag := parser.popTag();
                _msg := TJabberMessage.Create(tag);
                tag.Free();
            end
            else begin
                // No tag stored
                _msg := TJabberMessage.Create();

                if (table.GetField(outbound_col) = 'TRUE') then begin
                    _msg.ToJID := table.GetField(jid_col);
                    _msg.FromJID := table.GetField(user_jid_col);
                    if (_msg.FromJID <> '') then begin
                        _msg.isMe := true;
                    end;
                end
                else begin
                    _msg.ToJID := table.GetField(user_jid_col);
                    _msg.FromJID := table.GetField(jid_col);
                end;
                _msg.Subject := table.GetField(subject_col);
                _msg.Thread := table.GetField(thread_col);
                _msg.Body := table.GetField(body_col);
                _msg.MsgType := table.GetField(type_col);
                //_msg.ID
                //_msg.Action
                _msg.Nick := table.GetField(nick_col);
                //_msg.Time :=
                //_msg.isXdata
                //_msg.highlight
                //_msg.Tag
                //_msg.XML := table.GetField(xml_col);
                //_msg.com
                //_msg.Priority
            end;

            Synchronize(Self._OnResult);  // blocks here
            _msg.Free();
            _msg := nil;

            if (i < table.RowCount - 1) then begin
                table.NextRow();
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


end.
