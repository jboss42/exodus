unit ExItemHoverForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExForm, Exodus_TLB, ExtCtrls, ExBrandPanel, ExGroupBox, StdCtrls,
  TntStdCtrls, Menus, TntMenus, AppEvnts, ExContactHoverFrame, ExRoomHoverFrame,
  Exframe;

type
  TExItemHoverForm = class(TExForm)
    HoverHide: TTimer;
    HoverReenter: TTimer;
    procedure TntFormMouseLeave(Sender: TObject);
    procedure HoverHideTimer(Sender: TObject);
    procedure TntFormMouseEnter(Sender: TObject);
    procedure HoverReenterTimer(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
  private
    { Private declarations }
     _ContactFrame: TExContactHoverFrame;
     _RoomFrame: TExRoomHoverFrame;
     _CurrentFrame: TExFrame;
     _OldWndProc: TWndMethod;
     procedure _NewWndProc(var Message: TMessage);
     procedure _WMSysCommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
     procedure _CalcHoverPosition(Point: TPoint);
     procedure _InitControls(Item: IExodusItem);
     //

  public
    { Public declarations }
    procedure ActivateHover(Point: TPoint; Item: IExodusItem);
    procedure CancelHover();
    procedure SetHover();
  end;

implementation
uses COMExodusItem, ExTreeView, Jabber1, Presence, Session, RosterForm;

procedure TExItemHoverForm._NewWndProc(var Message: TMessage);
begin
    if (Message.Msg = WM_NCMOUSELEAVE) then
        CancelHover()
    else if (Message.Msg = WM_NCMOUSEMOVE) then
        SetHover();

    _OldWndProc(Message);
end;


procedure TExItemHoverForm.ActivateHover(Point: TPoint; Item: IExodusItem);
begin
    HoverHide.Enabled := false;
    if (Item = nil) then
    begin
        Hide;
        exit;
    end;

    if ((Item.Type_ <> EI_TYPE_ROOM) and (Item.Type_ <> EI_TYPE_CONTACT)) then
    begin
        Hide;
        exit;
    end;

    _InitControls(Item);
    _CalcHoverPosition(Point);

    Self.Show;
    HoverHide.Enabled := true;
    HoverReenter.Enabled := false;
end;

procedure TExItemHoverForm._InitControls(Item: IExodusItem);
begin
    Caption := Item.Text;
    if (_CurrentFrame <> nil) then
        _CurrentFrame.Parent := nil;
    AutoSize := false;    
    if (Item.Type_ = EI_TYPE_CONTACT) then
    begin
        _CurrentFrame := _ContactFrame;
        _ContactFrame.Parent := Self;
        _ContactFrame.InitControls(Item);
    end
    else if (Item.Type_ = EI_TYPE_ROOM) then
    begin
        _CurrentFrame := _RoomFrame;
        _RoomFrame.Parent := Self;
        _RoomFrame.InitControls(Item);
    end;   
    AutoSize := true;
end;

procedure TExItemHoverForm.CancelHover();
begin
   HoverReenter.Enabled := true;
end;

procedure TExItemHoverForm.SetHover();
begin
  HoverReenter.Enabled := false;
  HoverHide.Enabled := false;
end;

procedure TExItemHoverForm.HoverHideTimer(Sender: TObject);
begin
  inherited;
  OutputDebugString(PChar('Hide Timer fired'));
  HoverHide.Enabled := false;
  Hide;
end;

procedure TExItemHoverForm.HoverReenterTimer(Sender: TObject);
begin
  inherited;
  //OutputDebugString(PChar('Reenter Timer fired'));
  HoverReenter.Enabled := false;
  Hide;
end;


procedure TExItemHoverForm.TntFormCreate(Sender: TObject);
begin
    inherited;
    _ContactFrame := TExContactHoverFrame.Create(Self);
    _RoomFrame := TExRoomHoverFrame.Create(Self);
    _OldWndProc := Self.WindowProc;
    Self.WindowProc := _NewWndProc;
    HoverReenter.Interval := MainSession.prefs.getInt('roster_hint_reentry_delay');
    HoverHide.Interval := MainSession.prefs.getInt('roster_hint_hide_delay');
end;


procedure TExItemHoverForm.TntFormDestroy(Sender: TObject);
begin
  inherited;
  _ContactFrame.Free();
  _RoomFrame.Free();
  Self.WindowProc := _OldWndProc;
end;

procedure TExItemHoverForm.TntFormMouseEnter(Sender: TObject);
begin
  inherited;
  //OutputDebugString(PChar('Form MouseEnter'));
  SetHover();
end;

procedure TExItemHoverForm.TntFormMouseLeave(Sender: TObject);
begin
    //OutputDebugString(PChar('Form MouseLeave'));
    CancelHover();
end;


procedure TExItemHoverForm._WMSysCommand(var msg: TWmSysCommand);
begin
  if msg.CmdType and $FFF0 = SC_CLOSE then
  begin
    Hide;
  end;
end;

procedure TExItemHoverForm._CalcHoverPosition(Point: TPoint);
var
    CurMonitor: TMonitor;
begin
    Point.X := Point.X - Width;


    CurMonitor := Screen.MonitorFromPoint(Point);
    if Width > CurMonitor.Width then
        Width := CurMonitor.Width;
    if Height > CurMonitor.Height then
        Height := CurMonitor.Height;

    if Point.Y + Height > CurMonitor.Top + CurMonitor.Height then
        Point.Y := (CurMonitor.Top + CurMonitor.Height) - Height;
    if Point.X + Width > CurMonitor.Left + CurMonitor.Width then
        Point.X := (CurMonitor.Left + CurMonitor.Width) - Width;

    if Point.X < CurMonitor.Left then
        Point.X := Point.X + GetRosterWindow().Width + Width;
    
    SetWindowPos(Handle, HWND_TOPMOST, Point.X, Point.Y, Width, Height,
      0);
end;
{$R *.dfm}

end.
