unit RosterForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExForm, XMLTag, ExAllTreeView, Exodus_TLB, LoginWindow, ComCtrls,
  TntComCtrls, ExContactsTreeView, ExRoomsTreeView, COMExodusTabController,
  Unicode, AppEvnts, ExItemHoverForm;

type
  TRosterForm = class(TExForm)
     _PageControl: TTntPageControl;
    ApplicationEvents: TApplicationEvents;
      procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure _PageControlGetImageIndex(Sender: TObject; TabIndex: Integer;
      var ImageIndex: Integer);
    procedure _PageControlDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure ApplicationEventsShowHint(var HintStr: string;
      var CanShow: Boolean; var HintInfo: THintInfo);
    //procedure TntFormCreate(Sender: TObject);

  private
      { Private declarations }

      _SessionCB: integer;            // session callback id
      _RosterCB: integer;            // roster callback id
      _TreeMain: TExAllTreeView;
      _TreeContacts: TExContactsTreeView;
      _TreeRooms: TExRoomsTreeView;
      _TabController: IExodusTabController;
      _PageControlSaveWinProc: TWndMethod;
      _ActiveTabColor: TColor;
      _HoverWindow: TExItemHoverForm;
      _LastHoverTab: Integer;
      procedure _PageControlNewWndProc(var Msg: TMessage);
      procedure _ToggleGUI(state: TLoginGuiState);
      function _GetImages() : TImageList;
      procedure _SetImages(Value :TImageList);
      function _GetTreeByTabIndex(Index: Integer): TTntTreeView;
      procedure TntPageControlMouseMove(Sender: TObject; Shift: TShiftState;
                                        X, Y: Integer);
      //procedure _RemovePluginTabs();
  public
      { Public declarations }
      procedure InitControlls();
      procedure SessionCallback(event: string; tag: TXMLTag);
      procedure RosterCallback(event: string; item: IExodusItem);
      function  GetDockParent(): TForm;
      procedure DockWindow(docksite: TWinControl);
      function  SelectionFor(Index: Integer): IExodusItemList;
      property  RosterTree: TExAllTreeView read _TreeMain;
      property  ContactsTree: TExContactsTreeView read _TreeContacts;
      property  RoomsTree: TExRoomsTreeView read _TreeRooms;
      property  ImageList: TImageList read _GetImages  write _SetImages;
      property  TabController: IExodusTabController read _TabController;
      property  PageControl: TTntPageControl read _PageControl;
      property  HoverWindow: TExItemHoverForm read _HoverWindow;
  end;


function GetRosterWindow() : TRosterForm;
procedure CloseRosterWindow();

var
  FrmRoster: TRosterForm;

implementation

uses
    ExUtils,
    CommCtrl,
    COMExodusItemList,
    Session,
    RosterImages,
    gnugettext,
    ExTreeView,
    Jabber1,
    PrefController,
    FontConsts;

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
                            ARect.Top, TabController.VisibleTab[TabIndex].ImageIndex);
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
function TRosterForm._GetTreeByTabIndex(Index: Integer): TTntTreeView;
begin
   Result := nil;
   if (_TreeMain.TabIndex = Index) then
       Result := _TreeMain
   else if (_TreeContacts.TabIndex = Index) then
       Result := _TreeContacts
   else if (_TreeRooms.TabIndex = Index) then
       Result := _TreeRooms;

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
    else if event = '/contact/item/end' then
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
        _ActiveTabColor := TColor(MainSession.prefs.getInt(P_ROSTER_BG));

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
    _HoverWindow.Free;
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
    _ActiveTabColor := TColor(MainSession.prefs.getInt(P_ROSTER_BG));
    _TreeMain := TExAllTreeView.Create(Self, MainSession);
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
    begin
        _treeMain.parent := _PageControl.Pages[Idx];
        _treeMain.TabIndex := Idx;
    end;

    ITab := _TabController.AddTab('', _('Contacts'));
    ITab.Description := _('Tab containing contacts only. ');
    ITab.ImageIndex := RI_CONTACTS_TAB_INDEX;
    Idx := _TabController.GetTabIndexByUid(ITab.UID);
    if (Idx > -1) then
    begin
        _TreeContacts.parent := _PageControl.Pages[Idx];
        _TreeContacts.TabIndex := Idx;
    end;
    ITab := _TabController.AddTab('', _('Rooms'));
    ITab.ImageIndex := RI_ROOMS_TAB_INDEX;
    ITab.Description := _('Tab containing rooms only. ');
    Idx := _TabController.GetTabIndexByUid(ITab.UID);
    if (Idx > -1) then
    begin
        _TreeRooms.parent := _PageControl.Pages[Idx];
        _TreeRooms.TabIndex := Idx;
    end;

    AssignUnicodeFont(Self, 9);
    Application.HintPause := MainSession.prefs.getInt('roster_hint_delay');

   _HoverWindow := TExItemHoverForm.Create(Self);
   _LastHoverTab := -1;
   _PageControl.OnMouseMove := TntPageControlMouseMove;
   _PageControl.ShowHint := true;
end;

{---------------------------------------}
procedure TRosterForm.RosterCallback(Event: string; Item: IExodusItem);
begin
   if Event = '/contact/item/end' then
        Self.SessionCallback('/contact/item/end', nil);
end;

{---------------------------------------}
procedure TRosterForm._ToggleGUI(State: TLoginGuiState);
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


procedure TRosterForm.ApplicationEventsShowHint(var HintStr: string;
  var CanShow: Boolean; var HintInfo: THintInfo);
var
   HitTest: THitTests;
   hnd: HWnd;
begin
    if (HintInfo.HintControl is TExTreeView) then
    begin
       CanShow := false;
       hnd := GetForegroundWindow();
       if (((frmExodus.Handle = hnd) or
            (HoverWindow.Handle = hnd)) and
            (MainSession.Prefs.GetBool('roster_show_popup'))) then
          TExTreeView(HintInfo.HintControl).ActivateHover();
       exit;
    end;

    if (HintInfo.HintControl = _PageControl) then
    begin
        //We want to suppress hints for tabs when user hovers over tree area of the tab
        HitTest := _PageControl.GetHitTestInfoAt(HintInfo.CursorPos.X, HintInfo.CursorPos.Y) ;
        if (HitTest = [htNowhere])  then
        begin
           CanShow := false;
           exit;
        end;

       exit;
    end;
    inherited;
end;

procedure TRosterForm.DockWindow(docksite: TWinControl);
begin
    if (docksite <> Self.Parent) then begin
        Self.ManualDock(docksite, nil, alClient);
        Application.ProcessMessages();
        Self.Align := alClient;
    end;
end;

{---------------------------------------}
function TRosterForm.SelectionFor(Index: Integer): IExodusItemList;
var
    Tree: TTntTreeView;
begin
    Tree := _GetTreeByTabIndex(Index);
    if (Tree = nil) then exit;
    if (Tree is TExTreeView) then
        Result := TExTreeView(Tree).GetSelectedItems()
    else
        Result := TExodusItemList.Create() as IExodusItemList;
end;

{---------------------------------------}
//This function performs custom code for tool tips on the tabs
//We only want to show tool tips if the user hovers over different tab
//We should suppress tooltips if the user hovers over tree control area of the tab
procedure TRosterForm.TntPageControlMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
   Idx: Integer;
begin
   Idx := _PageControl.IndexOfTabAt(X, Y);

   if (Idx > -1) then
   begin
     if (_LastHoverTab <> Idx) then
     begin
         Application.CancelHint;
         _PageControl.Hint := TabController.Tab[Idx].Name;
         _LastHoverTab := Idx;
     end;
   end;

end;

end.
