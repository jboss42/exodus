unit PrefPlugins;
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

interface

uses
    Unicode,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, PrefPanel, ComCtrls, TntComCtrls, StdCtrls;

type
  TfrmPrefPlugins = class(TfrmPrefPanel)
    Label6: TLabel;
    lblPluginScan: TLabel;
    StaticText12: TStaticText;
    btnAddPlugin: TButton;
    btnConfigPlugin: TButton;
    btnRemovePlugin: TButton;
    txtPluginDir: TEdit;
    btnBrowsePluginPath: TButton;
    lstPlugins: TTntListView;
    procedure btnBrowsePluginPathClick(Sender: TObject);
    procedure lblPluginScanClick(Sender: TObject);
    procedure btnConfigPluginClick(Sender: TObject);
  private
    { Private declarations }

    procedure loadPlugins();
    procedure savePlugins();
    procedure scanPluginDir(selected: TWidestringList);
    procedure CheckPluginDll(dll : WideString; selected: TWidestringlist);

  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

type
    TRegProc = function: HResult; stdcall;

resourcestring
    sRegPluginError = 'The plugin could not be registered with windows.';

var
  frmPrefPlugins: TfrmPrefPlugins;

implementation
{$R *.dfm}
uses
    ActiveX, COMController, ComObj, ExodusCOM_TLB,
    PathSelector, Session;

{---------------------------------------}
procedure TfrmPrefPlugins.LoadPrefs();
var
    dir: Widestring;
begin
    with MainSession.Prefs do begin
        // plugins
        dir := getString('plugin_dir');
        if (dir = '') then
            dir := ExtractFilePath(Application.ExeName) + 'plugins';

        if (not DirectoryExists(dir)) then
            dir := ExtractFilePath(Application.ExeName) + 'plugins';

        txtPluginDir.Text := dir;
        loadPlugins();
     end;
end;

{---------------------------------------}
procedure TfrmPrefPlugins.SavePrefs();
begin
    with MainSession.Prefs do begin
        // Plugins
        setString('plugin_dir', txtPluginDir.Text);
        savePlugins();
    end;
end;

{---------------------------------------}
procedure TfrmPrefPlugins.loadPlugins();
var
    sl: TWidestringList;
begin
    // load the listview
    lstPlugins.Clear();

    // get the list of selected plugins..
    sl := TWidestringList.Create();
    MainSession.Prefs.fillStringlist('plugin_selected', sl);

    // Scan the director
    scanPluginDir(sl);

    with lstPlugins do begin
        btnConfigPlugin.Enabled := (Items.Count > 0);
        btnRemovePlugin.Enabled := (Items.Count > 0);
    end;

    sl.Free();
end;

{---------------------------------------}
procedure TfrmPrefPlugins.savePlugins();
var
    i: integer;
    item: TTntListItem;
    sl: TWidestringlist;
    fl: TWidestringlist;

    // stuff for reg
    LibHandle: THandle;
    RegProc: TRegProc;
begin
    // save all "checked" captions
    sl := TWidestringlist.Create();
    fl := TWidestringlist.Create();

    for i := 0 to lstPlugins.Items.Count - 1 do begin
        item := lstPlugins.Items[i];
        fl.Add(item.SubItems[1]);

        if (item.Checked) then begin
            // save the Classname
            sl.Add(item.Caption);

            // try to register it??
            // From the TRegSvr example.
            LibHandle := LoadLibrary(PChar(String(item.SubItems[1])));
            if LibHandle = 0 then begin
                MessageDlg(sRegPluginError, mtError, [mbOK], 0);
                continue;
            end;


            try
                @RegProc := GetProcAddress(LibHandle, 'DllRegisterServer');
                if @RegProc = Nil then begin
                    MessageDlg(sRegPluginError, mtError, [mbOK], 0);
                    continue;
                end;

                if RegProc <> 0 then begin
                    MessageDlg(sRegPluginError, mtError, [mbOK], 0);
                    continue;
                end;

            finally
                FreeLibrary(LibHandle);
            end;

        end;
    end;

    MainSession.Prefs.setStringlist('plugin_selected', sl);
    MainSession.Prefs.setStringlist('plugin_files', fl);
    ReloadPlugins(sl);
    sl.Free();
    fl.Free();
end;

{---------------------------------------}
procedure TfrmPrefPlugins.scanPluginDir(selected: TWidestringList);
var
    dir: Widestring;
    sr: TSearchRec;
begin
    dir := txtPluginDir.Text;
    if (not DirectoryExists(dir)) then exit;
    if (FindFirst(dir + '\\*.dll', faAnyFile, sr) = 0) then begin
        repeat
            CheckPluginDll(dir + '\' + sr.Name, selected);
        until FindNext(sr) <> 0;
        FindClose(sr);
    end;
end;

{---------------------------------------}
procedure TfrmPrefPlugins.CheckPluginDll(dll : WideString; selected: TWidestringList);
var
    lib : ITypeLib;
    idx, i, j : integer;
    item: TTntListItem;
    tinfo, iface : ITypeInfo;
    tattr, iattr: PTypeAttr;
    r: cardinal;
    libname, obname, doc: WideString;
begin
    // load the .dll.  This SHOULD register the bloody thing if it's not, but that
    // doesn't seem to work for me.
    OleCheck(LoadTypeLibEx(PWideChar(dll), REGKIND_REGISTER, lib));

    // get the project name
    OleCheck(lib.GetDocumentation(-1, @libname, nil, nil, nil));

    // for each type in the project
    for i := 0 to lib.GetTypeInfoCount() - 1 do begin
        // get the info about the type
        OleCheck(lib.GetTypeInfo(i, tinfo));

        // get attributes of the type
        OleCheck(tinfo.GetTypeAttr(tattr));
        // is this a coclass?
        if (tattr.typekind <> TKIND_COCLASS) then continue;

        // for each interface that the coclass implements
        for j := 0 to tattr.cImplTypes - 1 do begin
            // get the type info for the interface
            OleCheck(tinfo.GetRefTypeOfImplType(j, r));
            OleCheck(tinfo.GetRefTypeInfo(r, iface));

            // get the attributes of the interface
            OleCheck(iface.GetTypeAttr(iattr));

            // is this the IExodusPlugin interface?
            if  (IsEqualGUID(iattr.guid, ExodusCOM_TLB.IID_IExodusPlugin)) then begin
                // oho!  it IS.  Get the name of this coclass, so we can show
                // what we did.  Get the doc string, just to show off.
                OleCheck(tinfo.GetDocumentation(-1, @obname, @doc, nil, nil));
                // SysFreeString of obname and doc needed?  In C, yes, but here?

                item := lstPlugins.Items.Add();
                item.Caption := libname + '.' + obname;
                item.SubItems.Add(doc);
                item.SubItems.Add(dll);

                // check to see if this is selected
                idx := selected.IndexOf(item.Caption);
                item.Checked := (idx >= 0);
            end;
            iface.ReleaseTypeAttr(iattr);
        end;
        tinfo.ReleaseTypeAttr(tattr);
    end;
end;

{---------------------------------------}
procedure TfrmPrefPlugins.btnBrowsePluginPathClick(Sender: TObject);
var
    p: String;
begin
    // Change the plugin dir
    p := txtPluginDir.Text;
    if (browsePath(p)) then begin
        if (p <> txtPluginDir.Text) then begin
            txtPluginDir.Text := p;
            loadPlugins();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmPrefPlugins.lblPluginScanClick(Sender: TObject);
begin
  inherited;
    loadPlugins();
end;

{---------------------------------------}
procedure TfrmPrefPlugins.btnConfigPluginClick(Sender: TObject);
var
    li: TListItem;
    com_name: string;
begin
    li := lstPlugins.Selected;
    if (li = nil) then exit;
    com_name := li.Caption;
    ConfigurePlugin(com_name);
end;

end.
