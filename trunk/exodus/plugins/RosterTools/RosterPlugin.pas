unit RosterPlugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ExodusCOM_TLB, Import, 
    ComObj, ActiveX, RosterTools_TLB, StdVcl;

type
  TRosterPlugin = class(TAutoObject, IExodusPlugin)
  protected
    function onInstantMsg(const Body, Subject: WideString): WideString;
      safecall;
    procedure Configure; safecall;
    procedure menuClick(const ID: WideString); safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat);
      safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat);
      safecall;
    procedure Process(const xpath, event, xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(const ExodusController: IExodusController); safecall;
    { Protected declarations }
  private
    _exodus: IExodusController;
    _import: Widestring;
    _export: Widestring;

  end;

implementation

uses ComServ, Unicode, XMLTag;

function TRosterPlugin.onInstantMsg(const Body,
  Subject: WideString): WideString;
begin

end;

procedure TRosterPlugin.Configure;
begin

end;

procedure TRosterPlugin.menuClick(const ID: WideString);
var
    fImport: TfrmImport;
    sl: TWidestringlist;
    doc, item: TXMLTag;
    r: IExodusRoster;
    ri: IExodusRosterItem;
    i: integer;
    grp: Widestring;
begin
    if (id = _export) then begin
        fImport := TfrmImport.Create(nil);
        if (fImport.SaveDialog1.Execute()) then begin
            r := _exodus.Roster;
            doc := TXMLTag.Create('exodus-roster');
            for i := 0 to r.Count - 1 do begin
                ri := r.Item(i);
                item := doc.AddTag('item');
                item.setAttribute('jid', ri.JabberID);
                item.setAttribute('name', ri.nickname);
                grp := ri.Group(0);
                if (grp <> '') then
                    item.AddBasicTag('group', grp);
            end;

            sl := TWidestringlist.Create();
            sl.Add(doc.xml);
            sl.SaveToFile(fImport.SaveDialog1.Filename);
            sl.Free();
            fImport.Free();
        end;
    end
    else if (id = _import) then begin
        fImport := TfrmImport.Create(nil);
        if (not fImport.OpenDialog1.Execute()) then begin
            fImport.Free();
            exit;
        end;

        fImport.ImportFile(_exodus, fImport.OpenDialog1.FileName);
    end;
end;

procedure TRosterPlugin.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin

end;

procedure TRosterPlugin.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin

end;

procedure TRosterPlugin.Process(const xpath, event, xml: WideString);
begin

end;

procedure TRosterPlugin.Shutdown;
begin
    _exodus.removePluginMenu(_import);
    _exodus.removePluginMenu(_export);
    _export := '';
    _import := '';
end;

procedure TRosterPlugin.Startup(const ExodusController: IExodusController);
begin
    _exodus := ExodusController;
    _export := _exodus.addPluginMenu('Export Jabber Roster...');
    _import := _exodus.addPluginMenu('Import Jabber Roster...');
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRosterPlugin, Class_RosterPlugin,
    ciMultiInstance, tmApartment);


end.
