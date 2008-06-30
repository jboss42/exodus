unit COMToolbarButton;
{
    Copyright 2008, Estate of Peter Millard

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
  ComCtrls, ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusToolbarButton = class(TAutoObject, IExodusToolbarButton, IExodusToolbarButton2)
  private
    _button: TToolButton;
    _menu_listener: IExodusMenuListener;
    _imgList: IExodusRosterImages;
  public
    constructor Create(btn: TToolButton; imgList: IExodusRosterImages = nil);
    destructor Destroy(); override;
  protected
    function Get_ImageID: WideString; safecall;
    function Get_Tooltip: WideString; safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_ImageID(const Value: WideString); safecall;
    procedure Set_Tooltip(const Value: WideString); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    function Get_MenuListener: IExodusMenuListener; safecall;
    procedure Set_MenuListener(const Value: IExodusMenuListener); safecall;
    function Get_Name: Widestring; safecall;

    procedure SetImageList(images: IExodusRosterImages);
  public
    procedure OnClick(Sender: TObject);
  end;


implementation

uses
    RosterImages, {ExodusImageList, }ComServ, Debug, ExSession;

constructor TExodusToolbarButton.Create(btn: TToolButton; imgList: IExodusRosterImages);
begin
    _button := btn;
    if (not Assigned(_button.OnClick)) then
        _button.OnClick := Self.OnClick;

    if (imgList <> nil) then
        SetImageList(imgList)
    else
        SetImageList(COMRosterImages);
    inherited create();
end;

destructor TExodusToolbarButton.Destroy();
begin
    _menu_listener := nil;
    _imgList := nil;
    //TODO JJF button may not be valid here, may have already been freed by parent
    //toolbar. Even so, if we assigned an onlcick handler to the button
    //we should clear it now.
    _button := nil;
    inherited;
end;

procedure TExodusToolbarButton.SetImageList(images: IExodusRosterImages);
begin
    _imgList := images;
end;

function TExodusToolbarButton.Get_ImageID: WideString;
begin
    Result := RosterTreeImages.GetID(_button.ImageIndex);
end;

function TExodusToolbarButton.Get_Tooltip: WideString;
begin
    Result := _button.Hint;
end;

function TExodusToolbarButton.Get_Visible: WordBool;
begin
    Result := _button.Visible;
end;

procedure TExodusToolbarButton.Set_ImageID(const Value: WideString);
var
    idx: integer;
begin
    idx := _imgList.Find(Value);
    if (idx >= 0) then
        _button.ImageIndex := idx;
end;

procedure TExodusToolbarButton.Set_Tooltip(const Value: WideString);
begin
    _button.Hint := Value;
end;

procedure TExodusToolbarButton.Set_Visible(Value: WordBool);
begin
    _button.Visible := Value;
end;

function TExodusToolbarButton.Get_Enabled: WordBool;
begin
    Result := _button.Enabled;
end;

procedure TExodusToolbarButton.Set_Enabled(Value: WordBool);
begin
    _button.Enabled := Value;
end;

function TExodusToolbarButton.Get_MenuListener: IExodusMenuListener;
begin
    Result := _menu_listener;
end;

procedure TExodusToolbarButton.Set_MenuListener(
  const Value: IExodusMenuListener);
begin
    _menu_listener := Value;
end;

procedure TExodusToolbarButton.OnClick(Sender: TObject);
begin
    if (_menu_listener <> nil) then begin
        try
            _menu_listener.OnMenuItemClick(_button.Name, '');
        except
            DebugMessage('COM Exception in TExodusToolbarButton.OnClick');
        end;
    end;
end;

function TExodusToolbarButton.Get_Name(): Widestring;
begin
    Result := _button.Name;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusToolbarButton, Class_ExodusToolbarButton,
    ciMultiInstance, tmApartment);
end.
