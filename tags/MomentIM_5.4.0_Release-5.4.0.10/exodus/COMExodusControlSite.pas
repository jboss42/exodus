unit COMExodusControlSite;
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
    Classes, Controls, OleCtrls, Exodus_TLB;

type
    TExodusControlSite = class(TOleControl, IExodusControlSite, IExodusToolbarControl)
    private
        _controlClassID: TGUID;
        _controlName: widestring;
        _control: IDispatch;
    protected
        //IExodusToolbarControl
        function Get_Enabled: WordBool; virtual; safecall;
        function Get_Visible: WordBool; virtual; safecall;
        procedure Set_Enabled(value: WordBool); virtual; safecall;
        procedure Set_Visible(value: WordBool); virtual; safecall;
        //IExodusActiveXContainer
        function Get_Control: IDispatch; virtual; safecall;
        function Get_ControlName: WideString; virtual; safecall;
        function Get_ControlGUID: WideString; virtual; safecall;

        procedure InitControlData; override;
    public
        constructor Create(AOwner: TComponent; ClassId: TGuid; startAlignment: TAlign = alNone); reintroduce; overload;
        destructor Destroy(); override;

        property  ControlInterface: IDispatch read Get_Control;
        property  DefaultInterface: IDispatch read Get_Control;
    published
        //SIG provided a pretty good group of properties a default site should impl...
        property  Anchors;
        property  TabStop;
        property  Align;
        property  DragCursor;
        property  DragMode;
        property  ParentShowHint;
        property  PopupMenu;
        property  ShowHint;
        property  TabOrder;
        property  Visible;
        property  OnDragDrop;
        property  OnDragOver;
        property  OnEndDrag;
        property  OnEnter;
        property  OnExit;
        property  OnStartDrag;
    end;

implementation

uses SysUtils, StrUtils;
var
    _nameCounter: integer;

procedure TExodusControlSite.InitControlData;
const
  CControlData: TControlData2 = (
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: $00000000;
    Flags: $00000000;
    Version: 100);
begin
  ControlData := @CControlData;
  ControlData.ClassID := _controlClassID;
end;

constructor TExodusControlSite.Create(AOwner: TComponent; ClassId: TGuid; startAlignment: TAlign);
begin
    _controlClassID := ClassID;
    _controlName := 'exodus_ole_control_' + IntToStr(_nameCounter);
    inc(_nameCounter);
    inherited create(AOwner);
    if (AOwner <> nil) and (AOwner.InheritsFrom(TWinControl)) then
        Self.Parent := TWinCOntrol(AOwner);
    Self.Align := startAlignment;
    Self.Name := _controlName + '_controlsite';
end;

destructor TExodusControlSite.Destroy();
begin
    _control := nil;
    inherited;
end;

function TExodusControlSite.Get_Enabled: WordBool;
begin
    Result := Enabled;
end;

function TExodusControlSite.Get_Visible: WordBool;
begin
    Result := Visible;
end;

procedure TExodusControlSite.Set_Enabled(value: WordBool);
begin
    Enabled := value;
end;

procedure TExodusControlSite.Set_Visible(value: WordBool);
begin
    Visible := value;
end;

function TExodusControlSite.Get_ControlName: WideString;
begin
    Result := _controlName;
end;

function TExodusControlSite.Get_ControlGUID: WideString;
begin
    Result := GUIDToString(_controlClassID);
end;

function TExodusControlSite.Get_Control: IDispatch;
begin
    if (_control = nil) then
        _control := IUnknown(OleObject) as IDispatch;
    Result := _control;
end;

initialization
    _nameCounter := 0; 
end.
