unit MsgDisplay;
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
    JabberMsg,
    Graphics, ComCtrls, 
    Messages, Windows, SysUtils;

//const EM_AUTOURLDETECT = WM_USER + 91;

procedure DisplayMsg(Msg: TJabberMessage; RichEdit: TRichEdit);
procedure DisplayPresence(txt: string; Browser: TRichEdit);

function GetMsgHTML(Msg: TJabberMessage): string;

// procedure AddHTML(html: string; Browser: TRichEdit);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Clipbrd,
    Jabber1,
    ExtCtrls, Dialogs,
    Session;

{---------------------------------------}
procedure DisplayMsg(Msg: TJabberMessage; RichEdit: TRichEdit);
var
    txt: string;
    c: TColor;
    p, min, max, thumb: integer;
    bmp: TPicture;
    at_bottom: boolean;
begin
    // add the message to the richedit control

    (*
    Emoticon map:

    1   :) :-) (-: (:
    2   :( :-(
    3   ;) ;-)
    4   :D :-D
    5   :-/ :-\
    6   :x :-x :X :-X
    7   :">
    8   :p :-p :P :-P
    9   :O :-O
    10  X-( X( x-( x(
    11  :> :->
    12  B-)
    13  >:)
    14  :(( :-((
    15  :)) :-))
    16  :| :-|
    17  O:) O:-) o:) o:-)
    18  :B :-B
    19  =;
    20  I-) |-) I-|
    21  3:-0 3:-o 3:-O 3:O
    22  @};-
    23  =:) =:-)
    24  <):)
    25  8-X
    0  :o) :0) :O) <@:)

    *)

    with RichEdit do begin
        GetScrollRange(Handle, SB_VERT, min, max);
        thumb := GetScrollPos(Handle, SB_VERT);
        // if the thumb is at the bottom, or we don't have a scrollbar yet,
        // assume we're at the bottom
        at_bottom := ((thumb >= max) or (max = 0));
        end;

    txt := Msg.Body;

    RichEdit.SelStart := Length(RichEdit.Lines.Text);
    RichEdit.SelLength := 0;

    RichEdit.SelAttributes.Color := clGray;
    RichEdit.SelText := '[' + formatdatetime('HH:MM',now) + ']';

    if (Msg.Nick = '') then begin
        // Server generated msgs (mostly in TC Rooms)
        c := clGreen;
        RichEdit.SelAttributes.Color := c;
        RichEdit.SelText := ' ' + txt;
        end

    else if not Msg.Action then begin
        // This is a normal message
        if Msg.isMe then
            // our own msgs
            c := TColor(MainSession.Prefs.getInt('color_me'))
        else
            // other person's msgs
            c := TColor(MainSession.Prefs.getInt('color_other'));

        RichEdit.SelAttributes.Color := c;
        RichEdit.SelText := '<' + Msg.nick + '> ';
        RichEdit.SelAttributes.Color := TColor(MainSession.Prefs.getInt('font_color'));

        p := Pos(':)', txt);
        if (p > 0) then begin
            RichEdit.SelText := Copy(txt, 1, p - 1);
            bmp := TPicture.Create();
            frmJabber.imgEmoticons.GetBitmap(1, bmp.Bitmap);
            Clipboard.Assign(bmp);
            RichEdit.PasteFromClipboard();
            RichEdit.SelText := Copy(txt, p + 2, length(txt) - p - 1);
            end
        else
            RichEdit.SelText := Trim(txt);
        end

    else begin
        // This is an action
        RichEdit.SelAttributes.Color := clPurple;
        RichEdit.SelText := ' * ' + Msg.Nick + ' ' + Trim(txt);
        end;

    RichEdit.SelAttributes.Color := TColor(MainSession.Prefs.getInt('font_color'));
    RichEdit.SelText := #13#10;

    // AutoScroll the window
    if (at_bottom) then with RichEdit do begin
        SelStart := GetTextLen;
        Perform(EM_SCROLLCARET, 0, 0);
        end;

end;

{---------------------------------------}
procedure DisplayPresence(txt: string; Browser: TRichEdit);
begin
    // add presence to the richEdit control
    with Browser do begin
        SelStart := Length(Lines.Text);
        SelLength := 0;

        SelAttributes.Color := clGray;
        SelText := txt + #13#10;
        end;
end;

function GetMsgHTML(Msg: TJabberMessage): string;
var
    color, txt, html: string;
    cr_pos: integer;
begin
    // replace CR's w/ <br> tags
    txt := Msg.Body;
    repeat
        cr_pos := Pos(#13#10, txt);
        if cr_pos > 0 then begin
            Delete(txt, cr_pos, 2);
            Insert('<br />', txt, cr_pos);
            end;
    until (cr_pos <= 0);

    if Msg.Action then
        html := '<div><span style="color: purple;">* ' + txt + '</span></div>'
    else begin
        if Msg.isMe then color := 'red' else color := 'blue';
        html := '<div><span style="color: ' + color + ';">&lt;' + Msg.Nick + '&gt;</span> ' + txt + '</div>';
        end;

    Result := html;
end;


(*
procedure DisplayMsg(Msg: TJabberMessage; Browser: TRichEdit);
var
    color, html, txt: string;
    cr_pos: integer;
begin

    {
    if FileExists(ExtractFilePath(Application.ExeName)+'smiley.gif') then
    while pos(smile,txt)> 0 do begin
         nPos := pos(smile,txt);
         delete(txt,nPos,3);
         insert('<img src='+ExtractFilePath(Application.ExeName)+'smiley.gif height='+inttostr(hw)+' width='+inttostr(hw)+'>',txt,nPos);
       end;
    }

    // replace CR's w/ <br> tags
    txt := Msg.Body;
    repeat
        cr_pos := Pos(#13#10, txt);
        if cr_pos > 0 then begin
            Delete(txt, cr_pos, 2);
            Insert('<br />', txt, cr_pos);
            end;
    until (cr_pos <= 0);

    if Msg.Action then
        html := '<div><span style="color: purple;">* ' + txt + '</span></div>'
    else begin
        if Msg.isMe then color := 'red' else color := 'blue';
        html := '<div><span style="color: ' + color + ';">&lt;' + Msg.Nick + '&gt;</span> ' + txt + '</div>';
        end;
    AddHTML(html, Browser);
end;

procedure DisplayPresence(txt: string; Browser: TDHTMLEdit);
var
    html: string;
begin
    // add "foo is now away (status) to the browser window
    html := '<div><span style="color: grey;">' + txt + '</span></div>';
    AddHTML(html, Browser);
end;

procedure AddHTML(html: string; Browser: TDHTMLEdit);
var
    tags, last: OleVariant;
begin
    Browser.DOM.body.insertAdjacentHTML('beforeEnd', html);

    // fetch the last tag from the body children
    tags := Browser.DOM.body.children;
    last := tags.Item(tags.length - 1);
    last.ScrollIntoView;
end;

*)

end.

