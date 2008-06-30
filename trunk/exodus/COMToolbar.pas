    unit COMToolbar;
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
  ComObj, Controls, Exodus_TLB, ComCtrls, COMToolbarButton, StdVcl;

type
    TToolbarProxy = class
    private
        _btnBar: TToolbar;
        _controlSite: TWinControl;
        _imgList: IExodusRosterImages;
        _growRight: boolean;
    public
        constructor Create(); overload;
        constructor Create(btnBar: TToolbar; controlSite: TWinControl; imgList: IExodusRosterImages; growRight: boolean = true);overload;
        destructor Destroy; override;

        function Get_Count: Integer; virtual; safecall;
        function AddButton(const ImageID: WideString): IExodusToolbarButton; virtual; safecall;
        function GetButton(Index: Integer): IExodusToolbarButton; virtual; safecall;
        procedure RemoveButton(const button: WideString); virtual; safecall;
        function AddControl(const ClassId: WideString): IExodusToolbarControl; virtual; safecall;

        property Count: integer read Get_Count;
        property ImageList: IExodusRosterImages read _imgList write _imgList;
        property ButtonBar: TToolbar read _btnBar write _btnBar;
        property ControlSite: TWinControl read _controlSite write _controlSite;
    end;

    TExodusToolbar = class(TAutoObject, IExodusToolbar)
    private
        _tbProxy: TToolbarProxy;
    protected
        function AddButton(const ImageID: WideString): IExodusToolbarButton; safecall;
        function AddControl(const ID: WideString): IExodusToolbarControl; safecall;
        function Get_Count: Integer; safecall;
        function GetButton(index: Integer): IExodusToolbarButton; safecall;
    public
        constructor Create(btnBar: TToolbar; controlSite: TWinControl; imgList: IExodusRosterImages);reintroduce;overload;
        destructor Destroy(); override;
    end;

implementation

uses
    Forms, SysUtils, StrUtils, Jabber1, ExSession, Debug,
    COMToolbarControl, COMExodusControlSite, ComServ;

constructor TToolbarProxy.create();
begin
    inherited;
    _btnBar := nil;
    _controlSite := nil;
    _imgList := nil;
end;

constructor TToolbarProxy.Create(btnBar: TToolbar; controlSite: TWinControl; imgList: IExodusRosterImages; growRight: boolean);
begin
    inherited create();
    _btnBar := btnBar;
    _controlSite := controlSite;
    _imgList := imgList;
    _growRight := growRight;
end;

destructor TToolbarProxy.Destroy;
begin
    inherited;
end;

function TToolbarProxy.Get_Count: Integer;
begin
    Result := 0;
    try
        if (_btnBar = nil) then exit;
        Result := _btnBar.ButtonCount;
    except
        on E:Exception do
        begin
            DebugMessage('Exception in ' + Self.Classname + '.Get_Count (' + E.Message + ')');
            Result := 0;
        end;
    end;
end;

function TToolbarProxy.AddButton(const ImageID: WideString): IExodusToolbarButton;
var
    idx, oldLeft: integer;
    btn: TToolButton;
    g: TGUID;
    guid: string;
begin
    Result := nil;
    try
        if (_btnBar = nil) then exit;
        oldleft := _btnBar.Buttons[_btnBar.ButtonCount - 1].Left + _btnBar.Buttons[_btnBar.ButtonCount - 1].Width;
        _btnBar.AutoSize := false;
        btn := TToolButton.Create(Application.MainForm);
        btn.ShowHint := true;
        btn.Top := _btnBar.Buttons[_btnBar.ButtonCount - 1].Top;
        if (_growRight and (_btnBar.ButtonCount > 1)) then
            btn.Left := oldLeft + 1;
        _btnBar.Width := _btnBar.Width + _btnBar.Buttons[_btnBar.ButtonCount - 1].Width + 1;
        _btnBar.AutoSize := true;
        btn.Parent := _btnBar;
        idx := _imgList.Find(ImageID);
        if (idx >= 0) then
            btn.ImageIndex := idx;

        CreateGUID(g);
        guid := GUIDToString(g);
        guid := AnsiMidStr(guid, 2, length(guid) - 2);
        guid := AnsiReplaceStr(guid, '-', '_');
        btn.Name := _btnBar.Name + '_button_' + guid;

        _btnBar.Visible := true; //we have at least one button
        Result := TExodusToolbarButton.Create(btn, _imgList);
    except
        on E:Exception do
        begin
            DebugMessage('Exception in ' + Self.Classname + '.AddButton, ImageID: ' + imageID + ', (' + E.Message + ')');
            Result := nil;
        end;
    end;
end;

function TToolbarProxy.GetButton(Index: Integer): IExodusToolbarButton;
var
    btn: TToolButton;
begin
    Result := nil;
    try
        if (_btnBar = nil) then exit;

        Result := nil;
        if (Index >= 0) and (Index < _btnBar.ButtonCount) then
        begin
            btn := _btnBar.Buttons[Index];
            Result := TExodusToolbarButton.Create(btn, _imgList) as IExodusToolbarButton;
        end;
    except
        on E:Exception do
        begin
            DebugMessage('Exception in ' + Self.Classname + '.GetButton, index: ' + IntToStr(index) + ', (' + E.Message + ')');
            Result := nil;
        end;
    end;
end;

procedure TToolbarProxy.RemoveButton(const button: WideString);
var
    i: integer;
begin
    try
        if (_btnBar = nil) then exit;

        _btnBar.AutoSize := false;
        for i := _btnBar.ButtonCount - 1 downto 0 do begin
            if (_btnBar.Buttons[i].Name = button) then begin
                _btnBar.RemoveControl(_btnBar.Buttons[i]);
            end;
        end;
        _btnBar.AutoSize := true;

        i := 0;
        while (i < _btnBar.ButtonCount) and (not _btnBar.Buttons[i].Visible) do
            inc(i);

        _btnBar.Visible := (i = _btnBar.ButtonCount);
    except
        on E:Exception do
            DebugMessage('Exception in ' + Self.Classname + '.RemoveButton, name: ' + button + ', (' + E.Message + ')');
    end;
end;

function TToolbarProxy.AddControl(const ClassId: WideString): IExodusToolbarControl;
begin
    Result := nil;
    try
        if (_controlSite = nil) then exit;
        Result := TExodusControlSite.Create(_controlSite, StringToGuid(ClassId));
        if (Result <> nil) then
            _controlSite.Visible := true;
        _controlSite.Realign();
        _controlSite.Parent.Realign();
    except
        on E:Exception do
        begin
            DebugMessage('Exception in ' + Self.Classname + '.AddControl, ClassID: ' + ClassID + ', (' + E.Message + ')');
            Result := nil;
        end;
    end;
end;

constructor TExodusToolbar.Create(btnBar: TToolbar; controlSite: TWinControl; imgList: IExodusRosterImages);
begin
    _tbProxy := TToolbarProxy.create(btnBar, controlSite, imgList);
end;

destructor TExodusToolbar.Destroy();
begin
    _tbProxy.free();
end;

function TExodusToolbar.AddButton(const ImageID: WideString): IExodusToolbarButton;
begin
    Result := _tbProxy.AddButton(ImageID);
end;

function TExodusToolbar.AddControl(const ID: WideString): IExodusToolbarControl;
begin
    Result := _tbProxy.AddControl(ID);
end;

function TExodusToolbar.Get_Count: Integer;
begin
    Result := _tbProxy.Count;
end;

function TExodusToolbar.GetButton(index: Integer): IExodusToolbarButton;
begin
    Result := _tbProxy.GetButton(index);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusToolbar, Class_ExodusToolbar,
    ciMultiInstance, tmApartment);
end.
