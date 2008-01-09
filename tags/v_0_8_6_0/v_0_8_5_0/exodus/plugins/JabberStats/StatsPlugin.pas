unit StatsPlugin;

{
    Copyright 2003, Peter Millard

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
    XMLParser, XMLTag, 
    ExodusCOM_TLB, ComObj, ActiveX, ExJabberStats_TLB, StdVcl;

type
  TStatsPlugin = class(TAutoObject, IExodusPlugin)
  protected
    procedure Configure; safecall;
    procedure menuClick(const ID: WideString); safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat);
      safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat);
      safecall;
    procedure Process(const xpath, event, xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(const ExodusController: IExodusController); safecall;
    function NewIM(const jid: WideString; var Body, Subject: WideString;
      const XTags: WideString): WideString; safecall;
    procedure MsgMenuClick(const ID, jid: WideString; var Body,
      Subject: WideString); safecall;
    procedure NewOutgoingIM(const jid: WideString;
      const InstantMsg: IExodusChat); safecall;
    { Protected declarations }
  private
    _parser: TXMLTagParser;
    _exodus: ExodusController;
    _stat_file: TextFile;
    _filename: string;
    _cb: integer;
  end;

implementation

uses
    ComServ, Config, Controls, Dialogs, SysUtils;

procedure TStatsPlugin.Configure;
var
    fConfig: TfrmConfig;
begin
    fConfig := TfrmConfig.Create(nil);
    fConfig.txtFilename.Text := _filename;

    if (fConfig.ShowModal() = mrOK) then begin
        _filename := fConfig.txtFilename.Text;
        _exodus.setPrefAsString('stats_filename', _filename);
    end;

    fConfig.Free();
end;

procedure TStatsPlugin.menuClick(const ID: WideString);
begin

end;

procedure TStatsPlugin.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin

end;

procedure TStatsPlugin.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin

end;

procedure TStatsPlugin.Process(const xpath, event, xml: WideString);
var
    from, t, ns, dt, size, op: Widestring;
    tag: TXMLTag;
begin
    // we are getting a packet
    _parser.ParseString(xml, '');
    if (_parser.Count = 0) then exit;

    tag := _parser.popTag();
    // from, packet-type, date/time, size
    from := tag.getAttribute('from');
    if (from = '') then from := '-server-';
    t := tag.Name;
    ns := tag.Namespace(true);
    if (ns = '') then ns := 'jabber:client';
    size := IntToStr(Length(xml));
    dt := FormatDateTime(LongDateFormat, Now());
    op := Format('%s '#9' %s '#9' %s '#9' %s '#9' %s '#9, [from, t, ns, dt, size]);
    Writeln(_stat_file, op);
end;

procedure TStatsPlugin.Shutdown;
begin
    CloseFile(_stat_file);
    _exodus.UnRegisterCallback(_cb);
    _parser.Free();
end;

procedure TStatsPlugin.Startup(const ExodusController: IExodusController);
begin
    _parser := TXMLTagParser.Create();
    _exodus := ExodusController;
    _filename := _exodus.getPrefAsString('stats_filename');

    if (_filename = '') then begin
        _filename := _exodus.getPrefAsString('spool_path');
        _filename := ExtractFilePath(_filename) + 'stats.txt';
    end;

    // open the stat file
    AssignFile(_stat_file, _filename);
    if (FileExists(_filename)) then
        Append(_stat_file)
    else
        Rewrite(_stat_file);

    _exodus.setPrefAsString('stats_filename', _filename);

    _cb := _exodus.RegisterCallback('/packet', Self);
end;

function TStatsPlugin.NewIM(const jid: WideString; var Body,
  Subject: WideString; const XTags: WideString): WideString;
begin

end;

procedure TStatsPlugin.MsgMenuClick(const ID, jid: WideString; var Body,
  Subject: WideString);
begin

end;

procedure TStatsPlugin.NewOutgoingIM(const jid: WideString;
  const InstantMsg: IExodusChat);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TStatsPlugin, Class_StatsPlugin,
    ciMultiInstance, tmApartment);
end.
