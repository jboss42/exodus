  unit COMDockToolbar;
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
    TExodusDockToolbar = class(TAutoObject, IExodusDockToolbar)
    private
        _tbProxy: TToolbarProxy;
    protected
        function AddButton(const ImageID: WideString): ExodusToolbarButton; safecall;
        function AddControl(const ID: WideString): ExodusToolbarControl; safecall;
        function Get_Count: Integer; safecall;
        function GetButton(index: Integer): ExodusToolbarButton; safecall;
        procedure RemoveButton(const button: WideString); safecall;
    public
        constructor Create(btnBar: TToolbar; controlSite: TWinControl; imgList: IExodusRosterImages);reintroduce; overload;
        destructor Destroy; override;
    end;

implementation

uses
    ComServ;

constructor TExodusDockToolbar.Create(btnBar: TToolbar; controlSite: TWinControl; imgList: IExodusRosterImages);
begin
    _tbProxy := TToolbarProxy.create(btnBar, controlSite, imgList, false); //grow left
end;

destructor TExodusDockToolbar.Destroy;
begin
    _tbProxy.Free();
end;

function TExodusDockToolbar.AddButton(const ImageID: WideString): ExodusToolbarButton;
begin
    Result := _tbProxy.AddButton(ImageID);
end;

function TExodusDockToolbar.AddControl(const ID: WideString): ExodusToolbarControl;
begin
    Result := _tbProxy.AddControl(ID);
end;

function TExodusDockToolbar.Get_Count: Integer;
begin
    Result := _tbProxy.Count;
end;

function TExodusDockToolbar.GetButton(index: Integer): ExodusToolbarButton;
begin
    Result := _tbProxy.GetButton(index);
end;

procedure TExodusDockToolbar.RemoveButton(const button: WideString);
begin
    _tbProxy.RemoveButton(button);
end;

initialization
    TAutoObjectFactory.Create(ComServer, TExodusDockToolbar, Class_ExodusDockToolbar,
                              ciMultiInstance, tmApartment);
end.
