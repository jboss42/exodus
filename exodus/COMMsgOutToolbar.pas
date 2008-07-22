 unit COMMsgOutToolbar;
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
    ComObj, Exodus_TLB, COMToolbar, Controls, ComCtrls, StdVcl;

type
    TExodusMsgOutToolbar = class(TAutoObject, IExodusMsgOutToolbar)
    private
        _tbProxy: TToolbarProxy;
    protected
        function AddButton(const ImageID: WideString): IExodusToolbarButton; safecall;
        function AddControl(const ID: WideString): IExodusToolbarControl; safecall;
        function Get_Count: Integer; safecall;
        function GetButton(index: Integer): IExodusToolbarButton; safecall;
        procedure RemoveButton(const button: WideString); safecall;
    public
        constructor Create(btnBar: TToolbar; controlSite: TWinControl; imgList: IExodusRosterImages);reintroduce; overload;
        destructor Destroy; override;
    end;

implementation

uses
    ComServ;

constructor TExodusMsgOutToolbar.Create(btnBar: TToolbar; controlSite: TWinControl; imgList: IExodusRosterImages);
begin
    _tbProxy := TToolbarProxy.create(btnBar, controlSite, imgList);
end;

destructor TExodusMsgOutToolbar.Destroy;
begin
    _tbProxy.Free();
end;

function TExodusMsgOutToolbar.AddButton(const ImageID: WideString): IExodusToolbarButton;
begin
    Result := _tbProxy.AddButton(ImageID);
end;

function TExodusMsgOutToolbar.AddControl(const ID: WideString): IExodusToolbarControl;
begin
    Result := _tbProxy.AddControl(ID);
end;

function TExodusMsgOutToolbar.Get_Count: Integer;
begin
    Result := _tbProxy.Count;
end;

function TExodusMsgOutToolbar.GetButton(index: Integer): IExodusToolbarButton;
begin
    Result := _tbProxy.GetButton(index);
end;

procedure TExodusMsgOutToolbar.RemoveButton(const button: WideString);
begin
    _tbProxy.RemoveButton(button);
end;

initialization
    TAutoObjectFactory.Create(ComServer, TExodusMsgOutToolbar, Class_ExodusMsgOutToolbar,
                              ciMultiInstance, tmApartment);
end.
