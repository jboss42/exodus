unit ActiveXDockable;
{
    Copyright 2002, Peter Millard

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
    Dockable,
    ActiveX,
    ComObj,
    BaseMsgList,
    SysUtils,
    Unicode,
    COMDockToolbar,
    ToolWin,
    ComCtrls,
    ExtCtrls,
    Controls,
    Classes,
    PLUGINCONTROLLib_TLB,
    Forms,
    Exodus_TLB;

type
  TfrmActiveXDockable = class(TfrmDockable)
    pnlMsgList: TPanel;
    pnlChatTop: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    _AXControl: TAXControl;
    _callback: IExodusAXWindowCallback;
  protected

  public
    { Public declarations }
    DockToolbar: TExodusDockToolbar;

    procedure OnDocked(); override;
    procedure OnFloat(); override;

    property AXControl: TAXControl read _AXControl write _AXControl;
    property callback: IExodusAXWindowCallback read _callback write _callback;

  end;

var
  frmActiveXDockable: TfrmActiveXDockable;

function StartActiveX(ActiveX_GUID: widestring;
                      window_title: widestring;
                      show_window: boolean;
                      bring_to_front:boolean=true): TfrmActiveXDockable;

implementation

{$R *.dfm}

uses
    StrUtils, ExUtils;


function StartActiveX(ActiveX_GUID: widestring;
                      window_title: widestring;
                      show_window: boolean;
                      bring_to_front:boolean=true): TfrmActiveXDockable;
var
    AXControl: TAXControl;
    ParentControl: TWinControl;
begin
    Result := TfrmActiveXDockable.Create(nil);

    if (Result <> nil) then begin
        Result.Caption := window_title;

        ParentControl := Result.pnlMsgList;
        try
            AXControl := TAXControl.Create(ParentControl, StringToGuid(ActiveX_GUID));
            if (AXControl <> nil) then begin
                AXControl.Parent := ParentControl;
                AXControl.Align := alClient;

                Result.AXControl := AXControl;

                if (show_window) then begin
                    Result.ShowDefault(bring_to_front);
                end;
            end
            else begin
                Result.Close;
                Result := nil;
            end;
        except
            if (Result <> nil) then begin
                try
                    Result.Close;
                    Result := nil;
                except
                end;
            end;
        end;
    end;
end;

procedure TfrmActiveXDockable.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    inherited;

    if (_callback <> nil) then
    begin
        _callback.OnClose();
    end;

    _AXControl.Free();
    _AXControl := nil;
end;

procedure TfrmActiveXDockable.FormCreate(Sender: TObject);
var
    g: TGUID;
    guid: string;
begin
    try
        // generate a unique UID for activity window
        CreateGUID(g);
        guid := GUIDToString(g);
        guid := AnsiMidStr(guid, 2, length(guid) - 2);
        guid := AnsiReplaceStr(guid, '-', '_');
        Self.setUID('activeXWindow_' + guid);

        inherited;

        DockToolbar := TExodusDockToolbar.Create(Self.tbDockBar);
        DockToolbar.ObjAddRef();

        _windowType := 'activex_dockable';
        _callback := nil;
    except
    end;
end;

{---------------------------------------}
procedure TfrmActiveXDockable.FormDestroy(Sender: TObject);
begin
    if (DockToolbar <> nil) then
        DockToolbar.Free();

    _callback := nil;

    inherited;
end;

{---------------------------------------}
procedure TfrmActiveXDockable.OnDocked();
begin
    inherited;
    if (_callback <> nil) then
    begin
        _callback.OnDocked();
    end;
end;

{---------------------------------------}
procedure TfrmActiveXDockable.OnFloat();
begin
    inherited;
    if (_callback <> nil) then
    begin
        _callback.OnFloat();
    end;
end;


end.

