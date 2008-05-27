unit COMToolbar;
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
  ,Forms, Dialogs, StdCtrls, ComCtrls, SysUtils, strutils  ;

type
  TExodusToolbar = class(TAutoObject, IExodusToolbar)
  public
    constructor Create();
    destructor Destroy; override;

  protected
   function addButton(const ImageID: WideString): IExodusToolbarButton; safecall;
    function Get_Count: Integer; safecall;
    function getButton(Index: Integer): IExodusToolbarButton; safecall;
    function addControl(const ClassId: WideString): IExodusToolbarControl; safecall;
  end;

implementation

uses
    RosterImages, Jabber1, COMToolbarControl, ComServ;

{---------------------------------------}
function TExodusToolbar.addButton(
  const ImageID: WideString): IExodusToolbarButton;
var
    idx, old_left: integer;
    btn: TToolButton;
    g: TGUID;
    guid: string;
begin
    with frmExodus do begin
        Toolbar1.AutoSize := false;
        old_left := Toolbar1.Buttons[Toolbar1.ButtonCount - 1].Left +
                        Toolbar1.Buttons[Toolbar1.ButtonCount - 1].Width;
        btn := TToolButton.Create(frmExodus);
        btn.ShowHint := true;
        btn.Top := Toolbar1.Buttons[Toolbar1.ButtonCount - 1].Top;
        btn.Left := old_left + 1;
        ToolBar1.Width := Toolbar1.Width +
                            Toolbar1.Buttons[Toolbar1.ButtonCount - 1].Width + 1;
        btn.Parent := ToolBar1;
        Toolbar1.AutoSize := true;
    end;

    idx := RosterTreeImages.Find(ImageID);
    if (idx >= 0) then
        btn.ImageIndex := idx;

    CreateGUID(g);
    guid := GUIDToString(g);
    guid := AnsiMidStr(guid, 2, length(guid) - 2);
    guid := AnsiReplaceStr(guid, '-', '_');
    btn.Name := 'toolbar_button_' + guid;


    Result := TExodusToolbarButton.Create(btn);
end;

{---------------------------------------}
function TExodusToolbar.Get_Count: Integer;
begin
    Result := frmExodus.ToolBar1.ButtonCount;
end;

{---------------------------------------}
function TExodusToolbar.getButton(Index: Integer): IExodusToolbarButton;
var
    btn: TToolButton;
begin
    Result := nil;
    if (Index >= 0) and (Index < frmExodus.ToolBar1.ButtonCount) then begin
        btn := frmExodus.ToolBar1.Buttons[Index];
        Result := TExodusToolbarButton.Create(btn) as IExodusToolbarButton;
    end;
end;

{---------------------------------------}
{---------------------------------------}
constructor TExodusToolbar.Create();
begin
    inherited Create;
end;

{---------------------------------------}
destructor TExodusToolbar.Destroy();
begin
end;

{---------------------------------------}
function TExodusToolbar.addControl(const ClassId: WideString): IExodusToolbarControl;
var
  AXControl: TAXControl;
  ParentControl: TWinControl;
begin
  ParentControl := frmExodus.Toolbar;

  AXControl := TAXControl.Create(ParentControl, StringToGuid(ClassId));
  AXControl.Parent := ParentControl;
  Result := TExodusToolbarControl.Create(AXControl);

  frmExodus.Toolbar.Bands.Items[frmExodus.Toolbar.Bands.Count-1].Text := ClassId;
  frmExodus.Toolbar.ShowText := false;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusToolbar, Class_ExodusToolbar,
    ciMultiInstance, tmApartment);
end.
