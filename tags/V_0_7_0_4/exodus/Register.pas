unit Register;
{
    Copyright 2001, Peter Millard

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
    XMLTag,
    SysUtils, Classes;

type
    TRegController = class
    private
        _s: TObject;
        _cb: integer;
    published
        procedure callback(event: string; tag: TXMLTag);
    public
        procedure SetSession(s: TObject);
    end;

implementation
uses
    Forms, RegForm,
    Session;

{---------------------------------------}
procedure TRegController.SetSession(s: TObject);
var
    js: TJabberSession;
begin
    // Create a new registration object
    _s := s;
    js := TJabberSession(_s);
    _cb := js.RegisterCallback(Callback, '/session/register');
end;

{---------------------------------------}
procedure TRegController.Callback(event: string; tag: TXMLTag);
var
    f: TfrmRegister;
begin
    // Create a new registration form and kick the process off
    if ((event = '/session/register') and (tag <> nil)) then begin
        f := TfrmRegister.Create(Application);
        f.jid := tag.getAttribute('jid');
        f.Start();
        end;
end;


end.
