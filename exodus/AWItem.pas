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
        _active: boolean;
        _priority: boolean;
        _activity_window_selected_font_color: TColor;
        _activity_window_non_selected_font_color: TColor;
        _activity_window_unread_msgs_font_color: TColor;
        _activity_window_high_priority_font_color: TColor;
        _activity_window_unread_msgs_high_priority_font_color: TColor;

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
        property active: boolean read _active;
        property priority: boolean read _priority;
    published
        { published declarations }
    end;

implementation

uses
    Jabber1, ActivityWindow, Session,
    XMLTag;


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
var
    tag: TXMLTag;
begin
    inherited;
    // Set defaults
    _startColor := pnlAWItemGPanel.GradientProperites.startColor;
    _endColor := pnlAWItemGPanel.GradientProperites.endColor;
    _priorityStartColor := $000000ff;
    _priorityEndColor := $000000ff;
    _activeStartColor := $0000ff00;
    _activeEndColor := $0000ff00;
    _activity_window_selected_font_color := $00000000;
    _activity_window_non_selected_font_color := $00000000;
    _activity_window_unread_msgs_font_color := $000000ff;
    _activity_window_high_priority_font_color := $00000000;
    _activity_window_unread_msgs_high_priority_font_color := $00000000;

    // Set from prefs
    tag := MainSession.Prefs.getXMLPref('activity_window_selected_color');
    if (tag <> nil) then begin
        _activeStartColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
        _activeEndColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
    end;
    tag := MainSession.Prefs.getXMLPref('activity_window_high_priority_color');
    if (tag <> nil) then begin
        _priorityStartColor := TColor(StrToInt(tag.GetFirstTag('start').Data));
        _priorityEndColor := TColor(StrToInt(tag.GetFirstTag('end').Data));
    end;
    _activity_window_selected_font_color := TColor(MainSession.Prefs.GetInt('activity_window_non_selected_font_color'));
    _activity_window_non_selected_font_color := TColor(MainSession.Prefs.GetInt('activity_window_selected_font_color'));
    _activity_window_unread_msgs_font_color := TColor(MainSession.Prefs.GetInt('activity_window_unread_msgs_font_color'));
    _activity_window_high_priority_font_color := TColor(MainSession.Prefs.GetInt('activity_window_high_priority_font_color'));
    _activity_window_unread_msgs_high_priority_font_color := TColor(MainSession.Prefs.GetInt('activity_window_unread_msgs_high_priority_font_color'));
end;

{---------------------------------------}
procedure TfAWItem._setCount(val:integer);
begin
    _count := val;
    lblCount.Caption := IntToStr(_count);
    if (_count > 0) then begin
        if (_priority) then begin
            lblCount.Font.Color := _activity_window_unread_msgs_high_priority_font_color;
        end
        else begin
            lblCount.Font.Color := _activity_window_unread_msgs_font_color;
        end;
        lblCount.Font.Style := lblCount.Font.Style + [fsBold];
    end
    else begin
        if (_active) then begin
            lblCount.Font.Color := _activity_window_selected_font_color;
        end
        else begin
            lblCount.Font.Color := _activity_window_non_selected_font_color;
        end;
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
        frmExodus.ImageList2.GetIcon(_imgIndex, imgPresence.Picture.Icon);
      end;
end;

{---------------------------------------}
procedure TfAWItem.activate(setActive: boolean);
begin
    _active := setActive;
    if (setActive) then begin
        _setPnlColors(_activeStartColor, _activeEndColor);
        lblName.Font.Color := _activity_window_selected_font_color;
        lblCount.Font.Color := _activity_window_selected_font_color;
    end
    else begin
        _setPnlColors(_startColor, _endColor);
        lblName.Font.Color := _activity_window_non_selected_font_color;
        lblCount.Font.Color := _activity_window_non_selected_font_color;
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
    _priority := setPriority;
    if (setPriority) then begin
        _setPnlColors(_priorityStartColor, _priorityEndColor);
        lblName.Font.Color := _activity_window_high_priority_font_color;
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
