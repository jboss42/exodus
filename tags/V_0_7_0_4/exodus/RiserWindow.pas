unit RiserWindow;
{
    Copyright 2001, Peter Millard

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
    Variants,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, StdCtrls;

type
  TfrmRiser = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    Image1: TImage;
    Label1: TLabel;
    Shape1: TShape;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer2Timer(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    _taskrect: TRect;
    _taskdir: integer;
    _clickForm: TForm;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
    singleToast: TfrmRiser;
    frmRiser: TfrmRiser;

procedure ShowRiserWindow(clickForm: TForm; msg: string; imgIndex: integer);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    Session, Dockable, 
    Jabber1;

{---------------------------------------}
procedure ShowRiserWindow(clickForm: TForm; msg: string; imgIndex: integer);
var
    bmp: TBitmap;
    animate: boolean;
begin

    // Don't show toast while auto away
    if ((frmExodus.IsAutoAway) or (frmExodus.IsAutoXA)) then exit;

    bmp := TBitmap.Create;
    frmExodus.ImageList2.GetBitmap(imgIndex, bmp);

    if singleToast = nil then begin
        // create a new instance
        singleToast := TfrmRiser.Create(Application);
        animate := true;
        // Setup alpha blending..
        if MainSession.Prefs.getBool('toast_alpha') then begin
            singleToast.AlphaBlend := true;
            singleToast.AlphaBlendValue := MainSession.Prefs.getInt('toast_alpha_val');
            end;
        end
    else begin
        // we already have an instance, reset the timer
        if singleToast.Timer2.Enabled then begin
            singleToast.Timer2.Enabled := false;
            singleToast.Timer2.Enabled := true;
            end;
        animate := false;
        end;

    singleToast._clickForm := clickForm;
    singleToast.Image1.Picture.Assign(bmp);
    singleToast.Label1.Caption := msg;

    // raise the window
    if animate then begin
        // singleToast.Show;
        ShowWindow(singleToast.Handle, SW_SHOWNOACTIVATE);
        singleToast.Visible := true;
        singleToast.Timer1.Enabled := true;
        end;
end;

{---------------------------------------}
procedure TfrmRiser.CreateParams(var Params: TCreateParams);
begin
    inherited CreateParams(Params);
    with Params do begin
        ExStyle := ExStyle or WS_EX_NOPARENTNOTIFY;
        //WndParent := 0;
        end;
end;

{---------------------------------------}
procedure TfrmRiser.FormCreate(Sender: TObject);
var
    taskbar: HWND;
    mh, mw: longint;
begin
    taskbar := FindWindow('Shell_TrayWnd', '');
    GetWindowRect(taskbar, _taskrect);

    // eval the rect to get it's direction
    {
    0 = left side
    1 = right side
    2 = top
    3 = bottom
    }

    mh := Screen.Height div 2;
    mw := Screen.Width div 2;
    if ((_taskrect.Left < mw) and (_taskrect.Top < mh) and (_taskrect.Right < mw)) then
        _taskdir := 0
    else if ((_taskrect.left > mw) and (_taskrect.Top < mh)) then
        _taskdir := 1
    else if (_taskrect.top < mh) then
        _taskdir := 2
    else
        _taskdir := 3;

    case _taskdir of
    0: begin
        // taskbar on left side
        Self.Left := -Self.Width - 2;
        Self.Top := Screen.Height - Self.Height - 2;
        end;
    1: begin
        // taskbar on right side
        Self.Left := Screen.Width + Self.Width + 2;
        Self.Top := Screen.Height - Self.Height - 2;
        end;
    2: begin
        // taskbar on top
        Self.Left := Screen.Width - Self.Width - 2;
        Self.Top := -Self.Height - 2;
        end;
    3: begin
        // taskbar on bottom
        Self.Left := Screen.Width - Self.Width - 2;
        Self.Top := Screen.Height;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRiser.Timer1Timer(Sender: TObject);
var
    stop: boolean;
begin
    stop := false;
    case _taskdir of
    0: begin
        // taskbar on left
        Self.Left := Self.Left + 2;
        if (Self.Left > _taskrect.Right) then stop := true;
        end;
    1: begin
        // taskbar on right
        Self.Left := Self.Left - 2;
        if ((Self.Left + Self.Width)  < _taskrect.Left) then stop := true;
        end;
    2: begin
        // taskbar on top
        Self.Top := Self.Top + 2;
        if (Self.Top > _taskrect.Bottom) then stop := true;
        end;
    3: begin
        // taskbar on bottom
        Self.Top := Self.Top - 2;
        if (Self.Top + Self.Height) < _taskrect.top then stop := true;
        end;
    end;

    if (stop) then begin
        Timer1.Enabled := false;
        Timer2.Enabled := true;
        end;

end;

{---------------------------------------}
procedure TfrmRiser.Panel2Click(Sender: TObject);
begin
    Self.Close;
    if (_clickForm is TfrmDockable) then with TfrmDockable(_clickForm) do begin
        if Docked then begin
            frmExodus.Tabs.ActivePage := TabSheet;
            frmExodus.Show();
            exit;
            end;
        end;
    _clickForm.Show();
end;

{---------------------------------------}
procedure TfrmRiser.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    singleToast := nil;
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmRiser.Timer2Timer(Sender: TObject);
begin
    // close ourself
    Self.Close;
end;

procedure TfrmRiser.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Panel2Click(Shape1);
end;

initialization
    singleToast := nil;

end.
