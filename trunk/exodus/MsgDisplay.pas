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
    RegExpr, Classes, JabberMsg,
    Graphics, ComCtrls, Controls,
    Messages, Windows, SysUtils;

type
    TEmoticon = class
        il: TImageList;
        idx: integer;
    end;

//const EM_AUTOURLDETECT = WM_USER + 91;
var
    emoticon_regex: TRegExpr;
    emoticon_list: TStringList;

procedure DisplayMsg(Msg: TJabberMessage; RichEdit: TRichEdit);
procedure DisplayPresence(txt: string; Browser: TRichEdit);

function GetMsgHTML(Msg: TJabberMessage): string;

procedure ProcessEmoticons(RichEdit: TRichEdit; txt: string);
procedure ConfigEmoticons();
function getEmoticonIndex(match: string): integer;

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
    min, max, thumb: integer;
    at_bottom: boolean;
begin
    // add the message to the richedit control

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
        RichEdit.SelText := '<' + Msg.nick + '>';
        RichEdit.SelAttributes.Color := TColor(MainSession.Prefs.getInt('font_color'));
        RichEdit.SelText := ' ';

        ProcessEmoticons(RichEdit, txt);
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
procedure ProcessEmoticons(RichEdit: TRichEdit; txt: string);
var
    m: boolean;
    pic: TPicture;
    s: string;
    im, lm: integer;
    eo: TEmoticon;
begin
    // search for various smileys
    if (emoticon_regex = nil) then
        ConfigEmoticons();

    RichEdit.ReadOnly := false;
    pic := nil;
    s := txt;
    m := emoticon_regex.Exec(txt);
    lm := 0;
    while(m) do begin
        // we have a match
        lm := emoticon_regex.MatchPos[0] + emoticon_regex.MatchLen[0];
        RichEdit.SelText := emoticon_regex.Match[1];

        if (pic = nil) then pic := TPicture.Create();

        // frmJabber.imgEmoticons.GetBitmap(getEmoticonIndex(emoticon_regex.Match[2]), pic.Bitmap);
        im := emoticon_list.IndexOf(emoticon_regex.Match[2]);
        if (im >= 0) then begin
            eo := TEmoticon(emoticon_list.Objects[im]);
            eo.il.GetBitmap(eo.idx, pic.Bitmap);
            Clipboard.Assign(pic);
            RichEdit.PasteFromClipboard();
            end
        else
            RichEdit.SelText := emoticon_regex.Match[2];

        // RichEdit.SelText := ' ';
        m := emoticon_regex.ExecNext();
        end;

    if (lm < length(txt)) then begin
        // we have a remainder
        txt := Copy(txt, lm, length(txt) - lm + 1);
        RichEdit.SelText := txt;
        end;

    RichEdit.ReadOnly := true;
end;

{---------------------------------------}
procedure ConfigEmoticons();

    function AddEmot(val: string; il: TImageList; idx: integer): string;
    var
        eo: TEmoticon;
    begin
        eo := TEmoticon.Create();
        eo.il := il;
        eo.idx := idx;
        emoticon_list.AddObject(val, eo);
        Result := QuoteRegExprMetaChars(val);
    end;

var
    e: string;
    y, msn: TImageList;
begin
    //
    y := frmJabber.imgYahooEmoticons;
    msn := frmJabber.imgMSNEmoticons;
    // emoticon_list := TStringList.Create();
    e := '(.*)(';

    // Normal smileys
    e := e + AddEmot(':)', msn, 0) + '|';       // normal
    e := e + AddEmot(':-)', msn, 0) + '|';
    e := e + AddEmot('(:', msn, 0) + '|';
    e := e + AddEmot('(-:', msn, 0) + '|';
    e := e + AddEmot(':(', msn, 9) + '|';       // unhappy
    e := e + AddEmot(':-(', msn, 9) + '|';
    e := e + AddEmot(';)', msn, 38) + '|';      // wink
    e := e + AddEmot(';-)', msn, 38) + '|';
    e := e + AddEmot(':D', msn, 42) + '|';      // big smile
    e := e + AddEmot(':-D', msn, 42) + '|';
    e := e + AddEmot(':>', msn, 42) + '|';
    e := e + AddEmot(':->', msn, 42) + '|';
    e := e + AddEmot(':-/', y, 5) + '|';        // question
    e := e + AddEmot(':-\', y, 5) + '|';
    e := e + AddEmot(':x', y, 6) + '|';         // love
    e := e + AddEmot(':-x', y, 6) + '|';
    e := e + AddEmot(':X', y, 6) + '|';
    e := e + AddEmot(':-X', y, 6) + '|';
    e := e + AddEmot(':">', y, 7) + '|';        // blushing
    e := e + AddEmot(':p', msn, 45) + '|';      // tongue
    e := e + AddEmot(':-p', msn, 45) + '|';
    e := e + AddEmot(':P', msn, 45) + '|';
    e := e + AddEmot(':-P', msn, 45) + '|';
    e := e + AddEmot(':o', msn, 44) + '|';      // surprise
    e := e + AddEmot(':O', msn, 44) + '|';
    e := e + AddEmot(':-o', msn, 44) + '|';
    e := e + AddEmot(':-O', msn, 44) + '|';
    e := e + AddEmot(':|', msn, 2) + '|';       // undecided
    e := e + AddEmot(':-|', msn, 2) + '|';
    e := e + AddEmot(':cool', msn, 22) + '|';   // sunglasses
    e := e + AddEmot('B)', msn, 22) + '|';
    e := e + AddEmot('B-)', msn, 22) + '|';
    e := e + AddEmot('>:)', y, 13) + '|';       // yahoo devil
    e := e + AddEmot('O:)', y, 17) + '|';       // yahoo angel
    e := e + AddEmot('O:-)', y, 17) + '|';
    e := e + AddEmot('o:)', y, 17) + '|';
    e := e + AddEmot('o:-)', y, 17) + '|';
    e := e + AddEmot(':B', y, 18) + '|';        // smiley wearing glasses
    e := e + AddEmot(':-B', y, 18) + '|';
    e := e + AddEmot('=;', y, 19) + '|';        // talk to the hand
    e := e + AddEmot('I-)', y, 20) + '|';       // sleeping
    e := e + AddEmot('|-)', y, 20) + '|';
    e := e + AddEmot('I-|', y, 20) + '|';
    e := e + AddEmot('@}:-', msn, 20) + '|';    // rose
    e := e + AddEmot('(F)', msn, 20) + '|';
    e := e + AddEmot(':rose', msn, 20) + '|';
    e := e + AddEmot('8-X', y, 25) + '|';       // skull
    e := e + AddEmot('8-x', y, 25) + '|';
    e := e + AddEmot('(A)', msn, 15) + '|';     // Angel
    e := e + AddEmot(':saint', msn, 15) + '|';

    e := e + AddEmot(':S', msn, 1) + '|';       // confused look
    e := e + AddEmot(':-S', msn, 1) + '|';
    e := e + AddEmot(':s', msn, 1) + '|';
    e := e + AddEmot(':-s', msn, 1) + '|';
    e := e + AddEmot(':conf', msn, 1) + '|';
    e := e + AddEmot('(Y)', msn, 36) + '|';     // yes, thumb up
    e := e + AddEmot('(N)', msn, 27) + '|';     // no, thumb down
    e := e + AddEmot('(X)', msn, 35) + '|';     // girl
    e := e + AddEmot(':girl', msn, 35) + '|';
    e := e + AddEmot('(Z)', msn, 37) + '|';     // boy
    e := e + AddEmot('(L)', msn, 25) + '|';     // Love
    e := e + AddEmot('(U)', msn, 33) + '|';     // Unlove
    e := e + AddEmot('(P)', msn, 29) + '|';     // Picture
    e := e + AddEmot('(G)', msn, 21) + '|';     // Gift
    e := e + AddEmot('(%)', msn, 6) + '|';      // handcuffs
    e := e + AddEmot('(D)', msn, 18) + '|';     // Drink (martini)
    e := e + AddEmot(':[', msn, 40) + '|';      // bat/vampire
    e := e + AddEmot(':=[', msn, 40) + '|';
    e := e + AddEmot('(E)', msn, 19) + '|';     // Email
    e := e + AddEmot('(T)', msn, 32) + '|';     // Telephone
    e := e + AddEmot('(K)', msn, 24) + '|';     // kiss
    e := e + AddEmot(':lips', msn, 24) + '|';
    e := e + AddEmot('(I)', msn, 23) + '|';     // idea/light bulb
    e := e + AddEmot('(S)', msn, 31) + '|';     // asleep
    e := e + AddEmot('(8)', msn, 5) + '|';      // music
    e := e + AddEmot('o/~', msn, 5) + '|';
    e := e + AddEmot('o/`', msn, 5) + '|';
    e := e + AddEmot('(@)', msn, 10) + '|';     // cat
    e := e + AddEmot('(C)', msn, 18) + '|';     // cup
    e := e + AddEmot('(^)', msn, 11) + '|';     // cake
    e := e + AddEmot('(W)', msn, 34) + '|';     // Wilted rose
    e := e + AddEmot('(?)', msn, 41) + '|';     // ASL/Age Sex Location
    e := e + AddEmot(':@', msn, 39) + '|';      // angry
    e := e + AddEmot(':-@', msn, 39) + '|';
    e := e + AddEmot(':mad', msn, 39) + '|';
    e := e + AddEmot(':grrr', msn, 39) + '|';
    e := e + AddEmot('X(', msn, 39) + '|';
    e := e + AddEmot('X-(', msn, 39) + '|';
    e := e + AddEmot('x(', msn, 39) + '|';
    e := e + AddEmot('x-(', msn, 39) + '|';
    e := e + AddEmot('({)', msn, 12) + '|';     // hug right
    e := e + AddEmot('(})', msn, 13) + '|';     // hug left
    e := e + AddEmot(':' + Chr(39) + '(', msn, 11) + '|';   // cry
    e := e + AddEmot(';' + Chr(39) + '(', msn, 11) + '|';
    e := e + AddEmot('(&)', msn, 7) + '|';      // dog
    e := e + AddEmot('(~)', msn, 14) + '|';     // movie
    e := e + AddEmot('(R)', msn, 30) + '|';     // Rainbow
    e := e + AddEmot('(O)', msn, 28) + '|';     // time/clock
    e := e + AddEmot('(6)', msn, 4) + '|';      // devil
    e := e + AddEmot(':eek2', msn, 4) + '|';
    e := e + AddEmot(':jester', y, 0) + '|';    // clown

    e := e + AddEmot('(B)', msn, 16);

    e := e + ')';

    (*
    Emoticon map:
    :bones
    x:lips
    x:rose
    :spineye
    x:cool
    :blueanger
    :shinner
    :sick
    x:grrr
    :paranoid
    :king
    :redeyes
    :blah
    :mad
    :eek2
    :jester
    :saint
    :oops
    :crazed
    :roll
    :crazy
    :love
    :ninja
    :girl
    :sigh
    x:conf

    MSN Yahoo

    100   1   :) :-) (-: (:
    109   2   :( :-(
    138   3   ;) ;-)
    142   4   :D :-D
          5   :-/ :-\
          6   :x :-x :X :-X
          7   :">
    145   8   :p :-p :P :-P
    144   9   :O :-O
          10  X-( X( x-( x(
    142   11  :> :->
    122   12  B-) (B)
          13  >:)
          14  :(( :-((
          15  :)) :-))
    102   16  :| :-|
          17  O:) O:-) o:) o:-)
          18  :B :-B
          19  =;
          20  I-) |-) I-|
          21  3:-0 3:-o 3:-O 3:O
    120   22  @};-
          23  =:) =:-)
          24  <):)
          25  8-X
           0  :o) :0) :O) <@:)

    101     :-S :S :-s
    103     :-$ :$
    136     (Y)
    127     (N)
    135     (X)
    137     (Z)
    125     (L)
    133     (U)
    129     (P)
    121     (G)
    106     (%)
    120     (F)
    118     (D)
    116     (B)
    140     :-[ :[
    119     (E)
    132     (T)
    124     (K)
    123     (I)
    131     (S)
    105     (8)
    110     (@)
    118     (C)
    111     (^)
    134     (W)
    141     (?)
    139     :@ :-@
    112     ({)
    113     (})
    108     ;'(
    107     (&)
    114     (~)
    130     (R)
    128     (O)
    104     (6)

    GO CLient:
    *)

    emoticon_regex := TRegExpr.Create();
    emoticon_regex.ModifierG := false;
    emoticon_regex.Expression := e;
    emoticon_regex.Compile();
end;

{---------------------------------------}
function getEmoticonIndex(match: string): integer;
begin
    // return the image index for a specific match

    // Default to normal smiley
    Result := 1;
    if ((match = ':(') or (match = ':-(')) then
        Result := 2;
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

initialization
    emoticon_list := TStringList.Create();

finalization
    emoticon_list.Free();

end.



