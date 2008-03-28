unit RosterForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExForm, XMLTag, ExTreeView, Exodus_TLB, LoginWindow, ComCtrls,
  TntComCtrls, ExContactsTreeView, ExRoomsTreeView, COMExodusTabController;

type
  TRosterForm = class(TExForm)
     _PageControl: TTntPageControl;
      procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure _PageControlGetImageIndex(Sender: TObject; TabIndex: Integer;
      var ImageIndex: Integer);
    procedure _PageControlDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);

  private
      { Private declarations }
      _SessionCB: integer;            // session callback id
      _RosterCB: integer;            // roster callback id
      _TreeMain: TExTreeView;
      _TreeContacts: TExContactsTreeView;
      _TreeRooms: TExRoomsTreeView;
      _TabController: IExodusTabController;
      _PageControlSaveWinProc: TWndMethod;
      _ActiveTabColor: TColor;
      procedure _PageControlNewWndProc(var Msg: TMessage);
      procedure _ToggleGUI(state: TLoginGuiState);
      function _GetImages() : TImageList;
      procedure _SetImages(Value :TImageList);
      //procedure _RemovePluginTabs();
  public
      { Public declarations }
      procedure InitControlls();
      procedure SessionCallback(event: string; tag: TXMLTag);
      procedure RosterCallback(event: string; item: IExodusItem);
      function  GetDockParent(): TForm;
      procedure DockWindow(docksite: TWinControl);
      property  RosterTree: TExTreeView read _TreeMain;
      property  ContactsTree: TExContactsTreeView read _TreeContacts;
      property  RoomsTree: TExRoomsTreeView read _TreeRooms;
      property  ImageList: TImageList read _GetImages  write _SetImages;
      property  TabController: IExodusTabController read _TabController;
  end;


function GetRosterWindow() : TRosterForm;
procedure CloseRosterWindow();

var
  FrmRoster: TRosterForm;

implementation
uses ExUtils, CommCtrl, Session, RosterImages, gnugettext;

{$R *.dfm}

{
    Get the singleton instance of the roster
}
function GetRosterWindow() : TRosterForm;
begin
    if (FrmRoster = nil) then
        FrmRoster := TRosterForm.Create(Application);
    Result := FrmRoster;
end;

{
    Free the singleton roster
}
procedure CloseRosterWindow();
begin
    if (FrmRoster <> nil) then begin
        FrmRoster.Close();
        FrmRoster := nil;
    end;
end;

{---------------------------------------}
function TRosterForm._GetImages() : TImageList;
begin
    Result := TImageList(_PageControl.Images);
end;

procedure TRosterForm._PageControlDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
   ARect: TRect;
begin
  ARect := Rect;
  //inherited;
  if (Active) then
  begin
     _PageControl.Canvas.Brush.Color := _ActiveTabColor;
     _PageControl.Canvas.FillRect(ARect);
     ARect.Left := ARect.Left + 7;
     ARect.Top := ARect.Top  + 7;
  end
  else
  begin
     ARect.Left := ARect.Left + 3;
     ARect.Top := ARect.Top + 3;
  end;
  _PageControl.Images.Draw(_PageControl.Canvas,
                            ARect.Left,
                            ARect.Top, TabController.Tab[TabIndex].ImageIndex);
end;

procedure TRosterForm._PageControlGetImageIndex(Sender: TObject;
  TabIndex: Integer; var ImageIndex: Integer);
begin
  inherited;
//
   if (TabIndex > TabController.TabCount - 1) then exit;
   if (TabIndex < 0) then exit; 
   ImageIndex :=  TabController.Tab[TabIndex].ImageIndex;
end;

{---------------------------------------}
procedure TRosterForm._SetImages(Value :TImageList);
begin
    _PageControl.Images := Value;
end;

{---------------------------------------}
procedure TRosterForm.SessionCallback(Event: string; Tag: TXMLTag);
var
    Idx: Integer;
begin
    // catch session events
    if Event = '/session/disconnected' then
    begin
        _ToggleGUI(lgsDisconnected);
    end
    // it's the end of the roster, update the GUI
    else if event = '/item/end' then
    begin
        if (not Visible) then
            Visible := true;
    end
    else if Event = '/session/tab/hide' then
    begin
        if (TabController.VisibleTabCount = 1) then
        begin
            _PageControl.Visible := false;
            _TreeMain.Parent := Self;
        end;
    end
    else if Event = '/session/tab/show' then
    begin
        if (TabController.VisibleTabCount > 1) then
        begin
            _PageControl.Visible := true;
             Idx := _TabController.GetTabIndexByName('Main');
             if (Idx <> -1) then
                 _TreeMain.parent := _PageControl.Pages[Idx];
        end;
    end
    else if Event = '/session/prefs' then
        _ActiveTabColor := TColor(MainSession.prefs.getInt('roster_bg'));

end;

{---------------------------------------}
procedure TRosterForm.TntFormClose(Sender: TObject; var Action: TCloseAction);
begin
   inherited;
   _PageControl.WindowProc := _PageControlSaveWinProc;
   _PageControlSaveWinProc := nil;
   if (MainSession <> nil) then with MainSession do
   begin
        UnRegisterCallback(_rostercb);
        UnRegisterCallback(_sessioncb);
   end;
    _TreeMain.Free();
    _TreeMain := nil;
    _TreeContacts.Free();
    _TreeContacts := nil;
    _TreeRooms.Free();
    _TreeRooms := nil;
    _TabController := nil;
end;

{---------------------------------------}
procedure TRosterForm.InitControlls();
var
    ITab: IExodusTab;
    Idx: Integer;
begin
    _PageControlSaveWinProc := _PageControl.WindowProc;
    _PageControl.WindowProc := _PageControlNewWndProc;
    _TabController := TExodusTabController.Create();
    _ActiveTabColor := TColor(MainSession.prefs.getInt('roster_bg'));
    _TreeMain := TExTreeView.Create(Self, MainSession);
    _TreeMain.Align := alClient;
    _TreeMain.Canvas.Pen.Width := 1;
    _TreeMain.SetFontsAndColors();
    _Rostercb := MainSession.RegisterCallback(RosterCallback, '/item');
    _SessionCB := MainSession.RegisterCallback(SessionCallback, '/session');


    _TreeContacts := TExContactsTreeView.Create(Self, MainSession);
    _TreeContacts.Align := alClient;
    _TreeContacts.Canvas.Pen.Width := 1;
    _TreeContacts.SetFontsAndColors();

    _TreeRooms := TExRoomsTreeView.Create(Self, MainSession);
    _TreeRooms.Align := alClient;
    _TreeRooms.Canvas.Pen.Width := 1;
    _TreeRooms.SetFontsAndColors();

    ITab := _tabController.AddTab('', 'Main');
    ITab.ImageIndex := RI_MAIN_TAB_INDEX;
    Idx := _TabController.GetTabIndexByUid(ITab.UID);
    if (Idx > -1) then
        _treeMain.parent := _PageControl.Pages[Idx];

    ITab := _TabController.AddTab('', _('Contacts '));
    ITab.Description := _('Tab containing contacts only. ');
    ITab.ImageIndex := RI_CONTACTS_TAB_INDEX;
    Idx := _TabController.GetTabIndexByUid(ITab.UID);
    if (Idx > -1) then
        _TreeContacts.parent := _PageControl.Pages[Idx];

    ITab := _TabController.AddTab('', _('Rooms '));
    ITab.ImageIndex := RI_ROOMS_TAB_INDEX;
    ITab.Description := _('Tab containing rooms only. ');
    Idx := _TabController.GetTabIndexByUid(ITab.UID);
    if (Idx > -1) then
        _TreeRooms.parent := _PageControl.Pages[Idx];

    AssignUnicodeFont(Self, 9);
end;

{---------------------------------------}
procedure TRosterForm.RosterCallback(Event: string; Item: IExodusItem);
begin
   if Event = '/item/end' then
        Self.SessionCallback('/item/end', nil);
end;

{---------------------------------------}
procedure TRosterForm._ToggleGUI(State: TLoginGuiState);
var
   ITab: IExodusTab;
   control: TWinControl;
   Idx: Integer;
begin
    if (State = lgsDisconnected) then
    begin
       Self.Visible := false;
       _TreeMain.Items.Clear();
       _TreeContacts.Items.Clear();
       _TreeRooms.Items.Clear();
    end;

end;

{---------------------------------------}
procedure TRosterForm._PageControlNewWndProc(var Msg: TMessage);
var
    hdn: ^THDNotify;
    i: Integer;
begin
  if(Msg.Msg=TCM_ADJUSTRECT) then
  begin
      _PageControlSaveWinProc(Msg);
      PRect(Msg.LParam)^.Left:=0;
      PRect(Msg.LParam)^.Right:=ClientWidth;
      PRect(Msg.LParam)^.Top:=PRect(Msg.LParam)^.Top-4;
      PRect(Msg.LParam)^.Bottom:=ClientHeight - _PageControl.TabWidth - 2;
  end
  else
      _PageControlSaveWinProc(Msg);

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
