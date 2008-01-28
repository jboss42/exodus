unit COMMsgOutToolbar;
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
  TExodusMsgOutToolbar = class(TAutoObject, IExodusMsgOutToolbar)
  public
    constructor Create(); overload;
    constructor Create(toolbar: TToolbar); overload;
    destructor Destroy; override;

  protected
    _toolbar: TToolbar;
    function addButton(const ImageID: WideString): IExodusToolbarButton; safecall;
    function Get_Count: Integer; safecall;
    function getButton(Index: Integer): IExodusToolbarButton; safecall;
    function addControl(const ClassId: WideString): IExodusToolbarControl; safecall;
    procedure removeButton(const Button: widestring); safecall;
  end;

implementation

uses
    RosterImages, Jabber1, COMToolbarControl, ComServ;

{---------------------------------------}
function TExodusMsgOutToolbar.addButton(
  const ImageID: WideString): IExodusToolbarButton;
var
    idx, old_left: integer;
    btn: TToolButton;
    g: TGUID;
    guid: string;
begin
    _toolbar.AutoSize := false;
    old_left := _toolbar.Buttons[_toolbar.ButtonCount - 1].Left +
                    _toolbar.Buttons[_toolbar.ButtonCount - 1].Width;
    btn := TToolButton.Create(frmExodus);
    btn.Top := _toolbar.Buttons[_toolbar.ButtonCount - 1].Top;
    btn.Left := old_left + 1;
    _toolbar.Width := _toolbar.Width +
                        _toolbar.Buttons[_toolbar.ButtonCount - 1].Width + 1;
    btn.Parent := _toolbar;
    _toolbar.AutoSize := true;

    idx := RosterTreeImages.Find(ImageID);
    if (idx >= 0) then
        btn.ImageIndex := idx;

    CreateGUID(g);
    guid := GUIDToString(g);
    guid := AnsiMidStr(guid, 2, length(guid) - 2);
    guid := AnsiReplaceStr(guid, '-', '_');
    btn.Name := 'msgout_toolbar_button_' + guid;


    Result := TExodusToolbarButton.Create(btn);
end;

{---------------------------------------}
function TExodusMsgOutToolbar.Get_Count: Integer;
begin
    Result := _toolbar.ButtonCount;
end;

{---------------------------------------}
function TExodusMsgOutToolbar.getButton(Index: Integer): IExodusToolbarButton;
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
constructor TExodusMsgOutToolbar.Create();
begin
    inherited Create;
end;

constructor TExodusMsgOutToolbar.Create(toolbar: TToolbar);
begin
    _toolbar := toolbar;
    Create;
end;

{---------------------------------------}
destructor TExodusMsgOutToolbar.Destroy();
begin
end;

{---------------------------------------}
function TExodusMsgOutToolbar.addControl(const ClassId: WideString): IExodusToolbarControl;
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

procedure TExodusMsgOutToolbar.removeButton(const Button: widestring);
var
    i: integer;
begin
    _toolbar.AutoSize := false;
    for i := _toolbar.ButtonCount - 1 downto 0 do begin
        if (_toolbar.Buttons[i].Name = button) then begin
            _toolbar.RemoveControl(_toolbar.Buttons[i]);
        end;
    end;
    _toolbar.AutoSize := true;
end;


initialization
  TAutoObjectFactory.Create(ComServer, TExodusMsgOutToolbar, Class_ExodusMsgOutToolbar,
    ciMultiInstance, tmApartment);
end.
