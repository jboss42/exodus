unit ActivityNode;
{
    Copyright 2005, Joe Hildebrand

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
    NodeItem, JabberID, Unicode, XMLTag, SysUtils, Classes;

type
    TActivityNode = class(TJabberNodeItem)
    public
        Count: integer;
        Caption: WideString;
        Data: TObject;

        constructor Create(name: Widestring);
        function getText(): WideString; override;
    end;

function GetTotalUnread(): integer;
function GetActivityNode(hwnd: string; caption: WideString): TActivityNode;
procedure RemoveActivityNode(hwnd: string);
procedure ClearActivityNodes();

var
    _wins : TStringList;
    
implementation

constructor TActivityNode.Create(name: WideString);
begin
    Caption := name;
end;

function TActivityNode.getText(): WideString;
begin
    result := Caption;
end;

function GetTotalUnread(): integer;
var
    i : integer;
    c : integer;
begin
    c := 0;
    for i := 0 to _wins.Count - 1 do
        c := c + TActivityNode(_wins.Objects[i]).Count;
    result := c;
end;

function GetActivityNode(hwnd: string; caption: WideString): TActivityNode;
var
    i: integer;
    n: TActivityNode;
begin
    i := _wins.IndexOf(hwnd);
    if (i = -1) then begin
        n := TActivityNode.Create(caption);
        _wins.AddObject(hwnd, n);
    end
    else
        n := TActivityNode(_wins.Objects[i]);
    result := n;
end;

procedure RemoveActivityNode(hwnd: string);
var
    i: integer;
begin
    i := _wins.IndexOf(hwnd);
    if (i = -1) then exit;
    _wins.Objects[i].Free();
    _wins.Delete(i);
end;

procedure ClearActivityNodes();
var
    i: integer;
begin
    for i:= 0 to _wins.Count - 1 do
        _wins.Objects[i].Free();
    _wins.Clear();
end;

initialization
_wins := TStringList.Create();

finalization
ClearActivityNodes();
FreeAndNil(_wins);

end.
