unit RosterForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExForm, XMLTag, ExTreeView, Exodus_TLB, LoginWindow;

type
  TRosterForm = class(TExForm)
      procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
      procedure TntFormCreate(Sender: TObject);

  private
      { Private declarations }
      _sessionCB: integer;            // session callback id
      _rosterCB: integer;            // roster callback id
      _tree: TExTreeView;

      procedure _ToggleGUI(state: TLoginGuiState);
  public
      { Public declarations }
      procedure SessionCallback(event: string; tag: TXMLTag);
      procedure RosterCallback(event: string; item: IExodusItem);
      function  GetDockParent(): TForm;
      procedure DockWindow(docksite: TWinControl);
      property  RosterTree: TExTreeView read _tree;
  end;


function GetRosterWindow() : TRosterForm;
procedure CloseRosterWindow();

var
  frmRoster: TRosterForm;

implementation
uses ExUtils, CommCtrl, Session;

{$R *.dfm}

{
    Get the singleton instance of the roster
}
function GetRosterWindow() : TRosterForm;
begin
    if (frmRoster = nil) then
        frmRoster := TRosterForm.Create(Application);
    Result := frmRoster;
end;

{
    Free the singleton roster
}
procedure CloseRosterWindow();
begin
    if (frmRoster <> nil) then begin
        frmRoster.Close();
        frmRoster := nil;
    end;
end;


{---------------------------------------}
procedure TRosterForm.SessionCallback(event: string; tag: TXMLTag);
begin
    // catch session events
    if event = '/session/disconnected' then
    begin
        _ToggleGUI(lgsDisconnected);
    end
    // it's the end of the roster, update the GUI
    else if event = '/item/end' then
    begin
        if (not Visible) then
            Visible := true;
    end;

end;

{---------------------------------------}
procedure TRosterForm.TntFormClose(Sender: TObject; var Action: TCloseAction);
begin
   inherited;
   if (MainSession <> nil) then with MainSession do
   begin
        UnRegisterCallback(_rostercb);
        UnRegisterCallback(_sessioncb);
   end;
    _tree.Free();
    _tree := nil;

end;

{---------------------------------------}
procedure TRosterForm.TntFormCreate(Sender: TObject);
begin
    inherited;
    _tree := TExTreeView.Create(Self, MainSession);
    _tree.parent := Self;
    _tree.Align := alClient;
    _tree.Canvas.Pen.Width := 1;
    _tree.SetFontsAndColors();
    _rostercb := MainSession.RegisterCallback(RosterCallback, '/item');
    _sessionCB := MainSession.RegisterCallback(SessionCallback, '/session');


    AssignUnicodeFont(Self, 9);
end;

{---------------------------------------}
procedure TRosterForm.RosterCallback(event: string; item: IExodusItem);
begin
   if event = '/item/end' then
        Self.SessionCallback('/item/end', nil);
end;

{---------------------------------------}
procedure TRosterForm._ToggleGUI(state: TLoginGuiState);
begin
    if (state = lgsDisconnected) then
    begin
       Self.Visible := false;
       _tree.Items.Clear();
    end;
    
end;

{---------------------------------------}
function  TRosterForm.GetDockParent(): TForm;
begin
    Result := ExUtils.GetParentForm(Self);
end;

{---------------------------------------}
procedure TRosterForm.DockWindow(docksite: TWinControl);
begin
    if (docksite <> Self.Parent) then begin
        Self.ManualDock(docksite, nil, alClient);
        Application.ProcessMessages();
        Self.Align := alClient;
    end;
end;

end.
