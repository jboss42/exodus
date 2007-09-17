unit COMDockToolbar;
{
    Copyright 2006, Peter Millard

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

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Classes, windows, ComObj, Messages, Controls, ActiveX, Exodus_TLB,
  StdVcl, COMToolbarButton, PLUGINCONTROLLib_TLB, JclStrHashMap
  ,Forms, Dialogs, StdCtrls, ComCtrls, SysUtils, strutils;

type
  TExodusDockToolbar = class(TAutoObject, IExodusDockToolbar)
  public
    constructor Create(); overload;
    constructor Create(toolbar: TToolbar); overload;
    destructor Destroy; override;

  protected
    _toolbar: TToolbar;
    function AddButton(const ImageID: WideString): ExodusToolbarButton; safecall;
    function Get_Count: Integer; safecall;
    function getButton(Index: Integer): IExodusToolbarButton; safecall;
    function addControl(const ClassId: WideString): IExodusToolbarControl; safecall;
    procedure RemoveButton(const button: WideString); safecall;  function IExodusDockToolbar.AddControl = IExodusDockToolbar_AddControl;
    function IExodusDockToolbar.GetButton = IExodusDockToolbar_GetButton;
  
    function IExodusDockToolbar_AddControl(
      const ID: WideString): ExodusToolbarControl; safecall;
    function IExodusDockToolbar_GetButton(index: Integer): ExodusToolbarButton;
      safecall;
  end;

implementation

uses
    Debug, RosterImages, Jabber1, COMToolbarControl, ComServ;

{---------------------------------------}
function TExodusDockToolbar.AddButton(
  const ImageID: WideString): ExodusToolbarButton;
var
    idx: integer;
    btn: TToolButton;
    g: TGUID;
    guid: string;
begin
    btn := TToolButton.Create(frmExodus);
    btn.Parent := _toolbar;

    idx := RosterTreeImages.Find(ImageID);
    if (idx >= 0) then
        btn.ImageIndex := idx;

    CreateGUID(g);
    guid := GUIDToString(g);
    guid := AnsiMidStr(guid, 2, length(guid) - 2);
    guid := AnsiReplaceStr(guid, '-', '_');
    btn.Name := 'dock_toolbar_button_' + guid;

    _toolbar.Visible := true;

    Result := TExodusToolbarButton.Create(btn);
end;

{---------------------------------------}
function TExodusDockToolbar.Get_Count: Integer;
begin
    Result := _toolbar.ButtonCount;
end;

{---------------------------------------}
function TExodusDockToolbar.getButton(Index: Integer): IExodusToolbarButton;
var
    btn: TToolButton;
begin
    Result := nil;
    if (Index >= 0) and (Index < _toolbar.ButtonCount) then begin
        btn := _toolbar.Buttons[Index];
        Result := TExodusToolbarButton.Create(btn) as IExodusToolbarButton;
    end;
end;

{---------------------------------------}
{---------------------------------------}
constructor TExodusDockToolbar.Create();
begin
    inherited Create;
end;

constructor TExodusDockToolbar.Create(toolbar: TToolbar);
begin
    _toolbar := toolbar;
    Create;
end;

{---------------------------------------}
destructor TExodusDockToolbar.Destroy();
begin
end;

{---------------------------------------}
function TExodusDockToolbar.addControl(const ClassId: WideString): IExodusToolbarControl;
var
  MyControl: TMyControl;
  ParentControl: TWinControl;
begin
  ParentControl := frmExodus.Toolbar;

  MyControl := TMyControl.Create(ParentControl, StringToGuid(ClassId));
  MyControl.Parent := ParentControl;
  Result := TExodusToolbarControl.Create(MyControl);

  frmExodus.Toolbar.Bands.Items[frmExodus.Toolbar.Bands.Count-1].Text := ClassId;
  frmExodus.Toolbar.ShowText := false;
end;

procedure TExodusDockToolbar.RemoveButton(const button: WideString);
var
    i: integer;
    visibleButtons: integer;
begin
    try
        _toolbar.AutoSize := false;
        for i := _toolbar.ButtonCount - 1 downto 0 do begin
            if (_toolbar.Buttons[i].Name = button) then begin
                _toolbar.RemoveControl(_toolbar.Buttons[i]);
            end;
        end;
        _toolbar.AutoSize := true;

//        if (_toolbar.Visible) then begin
            visibleButtons := 0;
            for i := 0 to _toolbar.ButtonCount - 1 do begin
                if (_toolbar.Buttons[i].Visible) then
                    inc(visibleButtons);
            end;

            _toolbar.Visible := (visibleButtons > 0);
//        end;
    except
        on E:Exception do
            DebugMessage('Exception in TExodusDockToolbar.RemoveButton (' + E.Message + ')');
    end;
end;


function TExodusDockToolbar.IExodusDockToolbar_AddControl(
  const ID: WideString): ExodusToolbarControl;
begin

end;

function TExodusDockToolbar.IExodusDockToolbar_GetButton(
  index: Integer): ExodusToolbarButton;
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusDockToolbar, Class_ExodusDockToolbar,
    ciMultiInstance, tmApartment);
end.
