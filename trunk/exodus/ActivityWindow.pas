unit ActivityWindow;

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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExForm, Dockable, TntComCtrls, ComCtrls, ExtCtrls,
  TntExtCtrls, ExodusDockManager, StdCtrls, ExGradientPanel,
  AWItem, Unicode, DockWindow;

type
  TAWTrackerItem = class
  private
    { Private declarations }

  protected
    { Protected declarations }
    _dockable_frm: TfrmDockable;
    _awItem: TfAWItem;

  public
    { Public declarations }
    property frm: TfrmDockable read _dockable_frm write _dockable_frm;
    property awItem: TfAWItem read _awItem write _awItem;
  end;

  TfrmActivityWindow = class(TExForm)
    pnlListBase: TExGradientPanel;
    pnlListTop: TExGradientPanel;
    pnlListBottom: TExGradientPanel;
    Button1: TButton;
    Button2: TButton;
    pnlList: TExGradientPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }

  protected
    { Protected declarations }
    _trackingList: TWidestringList;
    _docked: boolean;
    _activeitem: TfAWItem;
    _dockwindow: TfrmDockWindow;

    procedure _clearTrackingList();
    procedure CreateParams(Var params: TCreateParams); override;
    procedure onItemClick(Sender: TObject);
    function _findItem(awitem: TfAWItem): TAWTrackerItem;

  public
    { Public declarations }
    procedure activateItem(awitem: TfAWItem); overload;
    procedure DockActivityWindow(dockSite : TWinControl);
    procedure removeItem(item:TAWTrackerItem); overload;
    procedure removeItem(id:widestring); overload;
    function addItem(id:widestring; frm:TfrmDockable): TAWTrackerItem;
    function findItem(id:widestring): TAWTrackerItem; overload;
    function findItem(frm:TfrmDockable): TAWTrackerItem; overload;
    procedure activateItem(id:widestring); overload;

    property docked: boolean read _docked write _docked;
    property dockwindow: TfrmDockWindow read _dockwindow write _dockwindow;
  end;

  // Global Functions
  procedure DockActivityWindow(docksite : TWinControl);
  function GetActivityWindow() : TfrmActivityWindow;
  procedure CloseActivityWindow();

var
  frmActivityWindow: TfrmActivityWindow;

implementation


{$R *.dfm}

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure DockActivityWindow(docksite : TWinControl);
begin
    if (frmActivityWindow <> nil) then
        frmActivityWindow.DockActivityWindow(docksite);
end;

{
    Get the singleton instance of the activity window
}
function GetActivityWindow() : TfrmActivityWindow;
begin
    if (frmActivityWindow = nil) then
        frmActivityWindow := TfrmActivityWindow.Create(Application);
    Result := frmActivityWindow;
end;

{
    Free the singleton activity window
}
procedure CloseActivityWindow();
begin
    if (frmActivityWindow <> nil) then begin
        frmActivityWindow.Close();
        frmActivityWindow := nil;
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmActivityWindow.CreateParams(Var params: TCreateParams);
begin
    // Make this window show up on the taskbar
    inherited CreateParams( params );
    params.ExStyle := params.ExStyle or WS_EX_APPWINDOW;
//    params.WndParent := GetDesktopwindow;
end;

{---------------------------------------}
procedure TfrmActivityWindow.FormCreate(Sender: TObject);
begin
    inherited;
    _trackingList := TWidestringList.Create;
end;

{---------------------------------------}
procedure TfrmActivityWindow.FormDestroy(Sender: TObject);
begin
    inherited;
    _clearTrackingList();
    _trackingList.Free;
end;

{---------------------------------------}
procedure TfrmActivityWindow.Button1Click(Sender: TObject);
var
    item: TAWTrackerItem;
begin
    item := findItem('yuck@wrk217.corp.jabber.com');
    if (item <> nil) then begin
        item.awItem.pnlAWItemGPanel.GradientProperites.startColor := $000000FF; //$00D0C3AF;
        item.awItem.pnlAWItemGPanel.GradientProperites.endColor := $000000FF; //$00D0C3AF;
        item.awItem.pnlAWItemGPanel.Invalidate;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow._clearTrackingList();
var
    i: integer;
    item: TAWTrackerItem;
begin
    for i := _trackingList.Count - 1 downto 0 do begin
        item := TAWTrackerItem(_trackingList.Objects[i]);
        removeItem(item);
        _trackingList.Delete(i);
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.removeItem(item:TAWTrackerItem);
var
    i: integer;
begin
    if (item = nil) then exit;

    for i := 0 to _trackingList.Count - 1 do begin
        if (item = TAWTrackerItem(_trackingList.Objects[i])) then begin
            _trackingList.Delete(i);
            break;
        end;
    end;

    item.frm := nil;
    item.awItem.Free();
    item.awItem := nil;
    item.Free();
end;

{---------------------------------------}
procedure TfrmActivityWindow.removeItem(id:widestring);
var
    item: TAWTrackerItem;
begin
    item := findItem(id);
    if (item <> nil) then begin
        removeItem(item);
    end;
end;

{---------------------------------------}
function TfrmActivityWindow.addItem(id:widestring; frm:TfrmDockable): TAWTrackerItem;
begin
    Result := findItem(id);

    if ((Result = nil) and
        (frm <> nil)) then begin
//        if (id = '') then begin
//            id := frm.Caption;
//        end;

        Result := TAWTrackerItem.Create();
        Result.awItem := TfAWItem.Create(nil);
        Result.frm := frm;
        _trackingList.AddObject(id, Result);
        Result.awItem.OnClick := Self.onItemClick;

        //???dda
        Result.awItem.Parent := pnlList;
        Result.awItem.Top := pnlList.Top + pnlList.Height;
        Result.awItem.Align := alTop;
        Result.awItem.name := id;
    end;
end;

{---------------------------------------}
function TfrmActivityWindow.findItem(id:widestring): TAWTrackerItem;
var
    idx: integer;
begin
    Result := nil;

    idx := _trackingList.IndexOf(id);

    if (idx >= 0) then begin
        Result := TAWTrackerItem(_trackingList.Objects[idx]);
    end;
end;

{---------------------------------------}
function TfrmActivityWindow.findItem(frm:TfrmDockable): TAWTrackerItem;
var
    i:integer;
    item: TAWTrackerItem;
begin
    Result := nil;

    for i := 0 to _trackingList.Count - 1 do begin
        item := TAWTrackerItem(_trackingList.Objects[i]);
        if (item.frm = frm) then begin
            Result := item;
            exit;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.DockActivityWindow(dockSite : TWinControl);
begin
    if (dockSite <> Self.Parent) then begin
        Self.ManualDock(dockSite, nil, alClient);
        Application.processMessages();
        Self.Align := alClient;
        _docked := true;
//        MainSession.dock_windows := Docked;
//        _drop.DropEvent := onURLDrop;
//        _drop.start(treeRoster);
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.activateItem(id:widestring);
var
    awitem: TfAWItem;
    trackeritem: TAWTrackerItem;
begin
    if (id = '') then exit;

    trackeritem := findItem(id);
    if (trackeritem <> nil) then begin
        awitem := trackeritem.awItem;
        if (awitem <> nil) then begin
            activateItem(awitem);
        end;
    end;
end;


{---------------------------------------}
procedure TfrmActivityWindow.onItemClick(Sender: TObject);
var
    awitem: TfAWItem;
    trackitem: TAWTrackerItem;
    tsheet: TTntTabSheet;
begin
    if (Sender = nil) then exit;

    try
        awitem := TfAWItem(Sender);
        activateItem(awitem);
    except
    end;
end;

{---------------------------------------}
procedure TfrmActivityWindow.activateItem(awitem: TfAWItem);
var
    trackitem: TAWTrackerItem;
    tsheet: TTntTabSheet;
begin
    if (awitem = nil) then exit;

    try
        // Set the active state of the List Item
        try
            if (_activeitem <> nil) then begin
                _activeitem.activate(false);
            end;
        except
            _activeitem := nil;
        end;
        awitem.activate(true);
        _activeitem := awitem;

        trackitem := _findItem(awitem);

        if (trackitem <> nil) then begin
            trackitem.frm.ClearUnreadMsgCount();
            trackitem.awItem.count := trackitem.frm.UnreadMsgCount;
            if (trackitem.frm.Docked) then begin
                tsheet := _dockwindow.getTabSheet(trackitem.frm);
                if (tsheet <> nil) then begin
                    _dockwindow.AWTabControl.ActivePage := tsheet;
                end;
            end
            else begin
                trackitem.frm.BringToFront;
            end;
        end;
    except
    end;
end;

{---------------------------------------}
function TfrmActivityWindow._findItem(awitem: TfAWItem): TAWTrackerItem;
var
    item: TAWTrackerItem;
    i: integer;
begin
    Result := nil;
    if (awitem = nil) then exit;

    for i := 0 to _trackingList.Count -1 do begin
        item := TAWTrackerItem(_trackingList.Objects[i]);
        if (item.awItem = awitem) then begin
            Result := item;
            break;
        end;
    end;
end;



initialization
    frmActivityWindow := nil;

end.

