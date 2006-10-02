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
  ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusToolbar = class(TAutoObject, IExodusToolbar)
  protected
    function addButton(const ImageID: WideString): IExodusToolbarButton;
      safecall;
    function Get_Count: Integer; safecall;
    function getButton(Index: Integer): IExodusToolbarButton; safecall;

  end;

implementation

uses
    RosterImages, ComCtrls, Jabber1, COMToolbarButton, ComServ;

function TExodusToolbar.addButton(
  const ImageID: WideString): IExodusToolbarButton;
var
    idx, old_left: integer;
    btn: TToolButton;
begin
    with frmExodus do
        old_left := Toolbar1.Buttons[Toolbar1.ButtonCount - 1].Left +
            Toolbar1.Buttons[Toolbar1.ButtonCount - 1].Width;
    btn := TToolButton.Create(frmExodus);
    btn.Parent := frmExodus.ToolBar1;
    btn.Left := old_left + 1;

    idx := RosterTreeImages.Find(ImageID);
    if (idx >= 0) then
        btn.ImageIndex := idx;

    Result := TExodusToolbarButton.Create(btn);
end;

function TExodusToolbar.Get_Count: Integer;
begin
    Result := frmExodus.ToolBar1.ButtonCount;
end;

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

initialization
  TAutoObjectFactory.Create(ComServer, TExodusToolbar, Class_ExodusToolbar,
    ciMultiInstance, tmApartment);
end.
