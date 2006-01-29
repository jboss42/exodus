unit RosterImages;
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

interface
uses
    Unicode,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ComCtrls, ExtCtrls, Buttons, ImgList, Menus, StdCtrls;

type

    TRosterImages = class
    private
        _imglist: TImageList;
        _ids: TWidestringlist;
        _tmp_bmp: TBitmap;

        //function findHandle(handle: HBitmap): integer;

    public
        constructor Create();
        destructor Destroy(); override;

        procedure Clear();
        procedure setImagelist(images: TImagelist);
        function  AddImage(id: Widestring; Image: TBitmap): integer;
        procedure Remove(ImageIndex: integer); overload;
        procedure Remove(id: Widestring); overload;
        function  Find(id: Widestring): integer;
    end;

var
    RosterTreeImages: TRosterImages;

implementation
{$ifdef Exodus}
uses
    Jabber1;
{$endif}


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TRosterImages.Create();
begin
    inherited Create;
    _tmp_bmp := TBitmap.Create();
    _ids := TWidestringlist.Create();    
end;

{---------------------------------------}
procedure TRosterImages.Clear();
begin
    _ids.Clear();
    _imglist := nil;
end;

{---------------------------------------}
procedure TRosterImages.setImagelist(images: TImagelist);
begin
    _imglist := images;

    {$ifdef Exodus}
    _ids.Add('offline');
    _ids.Add('available');
    _ids.Add('away');
    _ids.Add('dnd');
    _ids.Add('chat');
    _ids.Add('full_folder');
    _ids.Add('unknown');
    _ids.Add('multiple');
    _ids.Add('closed_folder');
    _ids.Add('open_folder');
    _ids.Add('xa');
    _ids.Add('headline');
    _ids.Add('info');
    _ids.Add('book');
    _ids.Add('reply');
    _ids.Add('note');
    _ids.Add('key_old');
    _ids.Add('flowchart');
    _ids.Add('newsitem_old');
    _ids.Add('image');
    _ids.Add('contact');
    _ids.Add('bookmark');
    _ids.Add('service');
    _ids.Add('newitem');
    _ids.Add('keyword');
    _ids.Add('filter');
    _ids.Add('contact_folder');
    _ids.Add('open_group');
    _ids.Add('closed_group');
    _ids.Add('right');
    _ids.Add('left');
    _ids.Add('warn');
    _ids.Add('error');
    _ids.Add('offline_attn');
    _ids.Add('available_attn');
    _ids.Add('away_attn');
    _ids.Add('dnd_attn');
    _ids.Add('chat_attn');
    _ids.Add('xa_attn');
    _ids.Add('online_blocked');
    _ids.Add('delete');
    _ids.Add('offline_blocked');
    _ids.Add('attn');
    _ids.Add('exodus');
    _ids.Add('avail_neg');
    _ids.Add('away_neg');
    _ids.Add('dnd_neg');
    _ids.Add('chat_neg');
    _ids.Add('xa_neg');
    {$endif}
end;

{---------------------------------------}
destructor TRosterImages.Destroy();
begin
    _tmp_bmp.Free();
    _ids.Free();
    inherited Destroy;
end;

{---------------------------------------}
function TRosterImages.AddImage(id: Widestring; Image: TBitmap): integer;
var
    i: integer;
begin
    i := _ids.IndexOf(id);
    if (i = -1) then begin
        // add the image
        _ids.Add(id);
        Result := _imglist.Add(Image, nil);
    end
    else
        Result := i;
end;

{---------------------------------------}
procedure TRosterImages.Remove(ImageIndex: integer);
begin
    if (ImageIndex < _imglist.Count) then begin
        _imglist.Delete(ImageIndex);
        _ids.Delete(ImageIndex);
    end;
end;

{---------------------------------------}
procedure TRosterImages.Remove(id: Widestring);
var
    i: integer;
begin
    i := _ids.IndexOf(id);
    if (i >= 0) then
        Remove(i);
end;

{---------------------------------------}
{
function TRosterImages.findHandle(handle: HBitmap): integer;
var
    i: integer;
begin
    // find this hbitmap in the list
    for i := 0 to _imglist.Count - 1 do begin
        _imglist.GetBitmap(i, _tmp_bmp);
        if (_tmp_bmp.Handle = handle) then begin
            Result := i;
            exit;
        end;
    end;
    Result := -1;
end;
}

{---------------------------------------}
function TRosterImages.Find(id: Widestring): integer;
begin
    Result := _ids.IndexOf(id);
end;

initialization
    RosterTreeImages := TRosterImages.Create();

finalization
    RosterTreeImages.Free();

end.
