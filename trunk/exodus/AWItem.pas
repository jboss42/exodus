unit AWItem;

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

{$ifdef VER150}
    {$define INDY9}
{$endif}

interface

uses
    Unicode,
    Windows,
    SysUtils,
    Classes,
    Controls,
    Forms,
    StdCtrls,
    ComCtrls,
    TntStdCtrls,
    ExtCtrls,
    ExFrame,
    ExGradientPanel,
    Graphics, Menus, TntMenus;

type
    TfAWItem = class(TExFrame)
    AWItemBevel: TBevel;
    pnlAWItemGPanel: TExGradientPanel;
    lblName: TTntLabel;
    lblCount: TTntLabel;
    imgPresence: TImage;
    LeftSpacer: TBevel;
    RightSpacer: TBevel;
    AWItemPopupMenu: TTntPopupMenu;
    mnuCloseWindow: TTntMenuItem;
    mnuFloatWindow: TTntMenuItem;
    mnuDockWindow: TTntMenuItem;
    procedure imgPresenceClick(Sender: TObject);
    procedure lblNameClick(Sender: TObject);
    procedure lblCountClick(Sender: TObject);
    procedure pnlAWItemGPanelClick(Sender: TObject);
    procedure TntFrameClick(Sender: TObject);
    procedure AWItemPopupMenuPopup(Sender: TObject);
    procedure mnuCloseWindowClick(Sender: TObject);
    procedure mnuDockWindowClick(Sender: TObject);
    procedure mnuFloatWindowClick(Sender: TObject);
    private
        { Private declarations }
    protected
        { Protected declarations }
        _count: integer;
        _imgIndex: integer;
        _priorityStartColor: TColor;
        _priorityEndColor: TColor;
        _activeStartColor: TColor;
        _activeEndColor: TColor;
        _startColor: TColor;
        _endColor: TColor;
        _docked: boolean;

        procedure _setCount(val:integer);
        function _getName(): widestring;
        procedure _setName(val:widestring);
        procedure _setImgIndex(val: integer);
        procedure _setPnlColors(startColor, endColor: TColor);
    public
        { Public declarations }
        constructor Create(AOwner: TComponent); reintroduce;

        procedure activate(setActive:boolean);
        procedure priorityFlag(setPriority:boolean);

        property name: WideString read _getName write _setName;
        property count: integer read _count write _setCount;
        property imgIndex: integer read _imgIndex write _setImgIndex;
        property priorityStartColor: TColor read _priorityStartColor write _priorityStartColor;
        property priorityEndColor: TColor read _priorityEndColor write _priorityEndColor;
        property activeStartColor: TColor read _activeStartColor write _activeStartColor;
        property activeEndColor: TColor read _activeEndColor write _activeEndColor;
        property docked: boolean read _docked write _docked;
    published
        { published declarations }
    end;

implementation

uses
    Jabber1, ActivityWindow;


{$R *.dfm}

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfAWItem.AWItemPopupMenuPopup(Sender: TObject);
begin
    inherited;
    if (_docked) then begin
        mnuDockWindow.Visible := false;
        mnuFloatWindow.Visible := true;
    end
    else begin
        mnuDockWindow.Visible := true;
        mnuFloatWindow.Visible := false;
    end;
end;

constructor TfAWItem.Create(AOwner: TComponent);
begin
    inherited;
    _startColor := pnlAWItemGPanel.GradientProperites.startColor;
    _endColor := pnlAWItemGPanel.GradientProperites.endColor;
    _priorityStartColor := $000000ff;
    _priorityEndColor := $000000ff;
    _activeStartColor := $0000ff00; //???dda
    _activeEndColor := $0000ff00; //??dda
end;

{---------------------------------------}
procedure TfAWItem._setCount(val:integer);
begin
    _count := val;
    lblCount.Caption := IntToStr(_count);
    if (_count > 0) then begin
        lblCount.Font.Color := clRed;
        lblCount.Font.Style := lblCount.Font.Style + [fsBold];
    end
    else begin
        lblCount.Font.Color := clBlack;
        lblCount.Font.Style := lblCount.Font.Style - [fsBold];
    end;
end;

{---------------------------------------}
procedure TfAWItem.imgPresenceClick(Sender: TObject);
begin
    inherited;
    Self.OnClick(Self);
end;

{---------------------------------------}
procedure TfAWItem.lblCountClick(Sender: TObject);
begin
    inherited;
    Self.OnClick(Self);
end;

{---------------------------------------}
procedure TfAWItem.lblNameClick(Sender: TObject);
begin
    inherited;
    Self.OnClick(Self);
end;

{---------------------------------------}
procedure TfAWItem.mnuCloseWindowClick(Sender: TObject);
var
    aw: TfrmActivityWindow;
    item: TAWTrackerItem;
begin
    inherited;

    aw := GetActivityWindow();

    if (aw <> nil) then begin
        item := aw.findItem(self);
        if (item <> nil) then begin
            item.frm.Close();
        end;
    end;
end;

{---------------------------------------}
procedure TfAWItem.mnuDockWindowClick(Sender: TObject);
var
    aw: TfrmActivityWindow;
    item: TAWTrackerItem;
begin
    inherited;

    aw := GetActivityWindow();

    if (aw <> nil) then begin
        item := aw.findItem(self);
        if (item <> nil) then begin
            item.frm.DockForm();
            aw.activateItem(Self);
            _docked := true;
        end;
    end;
end;

{---------------------------------------}
procedure TfAWItem.mnuFloatWindowClick(Sender: TObject);
var
    aw: TfrmActivityWindow;
    item: TAWTrackerItem;
begin
    inherited;

    aw := GetActivityWindow();

    if (aw <> nil) then begin
        item := aw.findItem(self);
        if (item <> nil) then begin
            item.frm.FloatForm();
            aw.activateItem(Self);
            _docked := false;
        end;
    end;
end;

{---------------------------------------}
function TfAWItem._getName(): widestring;
begin
    Result := lblName.Caption;
end;

{---------------------------------------}
procedure TfAWItem._setName(val:widestring);
begin
    lblName.Caption := val;
    Hint := val;
end;

{---------------------------------------}
procedure TfAWItem._setImgIndex(val: Integer);
begin
    if ((val >= 0) and
        (val < frmExodus.ImageList2.Count)) then begin
        _imgIndex := val;
//        imgPresence.Picture := nil;
//        frmExodus.ImageList2.GetBitmap(val, imgPresence.Picture.Bitmap);
//        imgPresence.Picture.Graphic.Transparent := true;
//        with imgPresence.Picture.Bitmap do begin
//            TransparentColor := $00FF00FF;
//            TransparentMode := tmFixed;
//        end;
        frmExodus.ImageList2.GetIcon(_imgIndex, imgPresence.Picture.Icon);
      end;
end;

{---------------------------------------}
procedure TfAWItem.activate(setActive:boolean);
begin
    if (setActive) then begin
        _setPnlColors(_activeStartColor, _activeEndColor);
    end
    else begin
        _setPnlColors(_startColor, _endColor);
    end;
end;

{---------------------------------------}
procedure TfAWItem.pnlAWItemGPanelClick(Sender: TObject);
begin
    inherited;
    Self.OnClick(Self);
end;

procedure TfAWItem.priorityFlag(setPriority:boolean);
begin
    if (setPriority) then begin
        _setPnlColors(_priorityStartColor, _priorityEndColor);
    end
    else begin
        if ((pnlAWItemGPanel.GradientProperites.startColor = _priorityStartColor) and
            (pnlAWItemGPanel.GradientProperites.startColor = _priorityStartColor)) then begin
            // This clears out Priority color only if it is showing
            // If the color is something else (like the selected color, then
            // color will be left alone.
            _setPnlColors(_startColor, _endColor);
        end;
    end;
end;

procedure TfAWItem.TntFrameClick(Sender: TObject);
begin
    inherited;
    Self.OnClick(Self);
end;

{---------------------------------------}
procedure TfAWItem._setPnlColors(startColor, endColor: TColor);
begin
    pnlAWItemGPanel.GradientProperites.startColor := startColor;
    pnlAWItemGPanel.GradientProperites.endColor := endColor;
    pnlAWItemGPanel.Invalidate;
end;


end.
