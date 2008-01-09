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
    iniFiles,
    ExRichEdit, RichEdit2, RegExpr, Classes, JabberMsg,
    Graphics, ComCtrls, Controls,
    Messages, Windows, SysUtils;

type
    TEmoticon = class
        il: TImageList;
        idx: integer;
end;

var
    use_emoticons: boolean;
    emoticon_list: THashedStringList;

procedure DisplayMsg(Msg: TJabberMessage; RichEdit: TExRichEdit; AutoScroll: boolean = true);
procedure DisplayPresence(txt: string; Browser: TExRichEdit);

function GetMsgHTML(Msg: TJabberMessage): string;

procedure ProcessEmoticons(RichEdit: TExRichEdit; color: TColor; txt: Widestring);
procedure ConfigEmoticons();

// procedure AddHTML(html: string; Browser: TRichEdit);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses

    Clipbrd,
    Jabber1, ExUtils,
    ExtCtrls, Dialogs,
    XMLUtils, Session;

var
    _pic: TPicture;
    emoticon_regex: TRegExpr;

{---------------------------------------}
function atBottom(RichEdit: TExRichEdit): boolean;
var
    bot_thumb: integer;
    ScrollInfo: TSCROLLINFO;
begin
    with RichEdit do begin
        ScrollInfo.cbSize := SizeOf(TScrollInfo);
        ScrollInfo.fMask := SIF_PAGE + SIF_POS + SIF_RANGE;
        GetScrollInfo(Handle, SB_VERT, ScrollInfo);
        bot_thumb := ScrollInfo.nPos + Integer(ScrollInfo.nPage) + 2;
        {
        Result := (bot_thumb >= ScrollInfo.nMax) or (ScrollInfo.nMax = 0) or
            (ts >= Trunc(0.8 * r));
        }
        Result := ((bot_thumb >= ScrollInfo.nMax) or (ScrollInfo.nMax = 0));
    end;
end;

{---------------------------------------}
procedure scrollRichEdit(RichEdit: TExRichEdit);
begin
    // Send a "page down" scroll message
    with RichEdit do
        Perform(EM_SCROLL, SB_PAGEDOWN, 0);
end;

{---------------------------------------}
procedure DisplayMsg(Msg: TJabberMessage; RichEdit: TExRichEdit; AutoScroll: boolean = true);
var
    txt: WideString;
    c: TColor;
    at_bottom: boolean;
begin
    // add the message to the richedit control
    at_bottom := atBottom(RichEdit);
    txt := Msg.Body;

    // Make sure we're inputting text in Unicode format.
    RichEdit.InputFormat := ifUnicode;
    RichEdit.SelStart := Length(RichEdit.WideLines.Text);
    RichEdit.SelLength := 0;

    if (MainSession.Prefs.getBool('timestamp')) then begin
        RichEdit.SelAttributes.Color := clGray;
        RichEdit.WideSelText := '[' +
                            FormatDateTime(MainSession.Prefs.getString('timestamp_format'),
                            Msg.Time) + ']';
    end;

    if (Msg.Nick = '') then begin
        // Server generated msgs (mostly in TC Rooms)
        c := clGreen;
        RichEdit.SelAttributes.Color := c;
        RichEdit.WideSelText := ' ' + txt;
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
        RichEdit.WideSelText := '<' + Msg.nick + '>';
        c := TColor(MainSession.Prefs.getInt('font_color'));
        RichEdit.SelAttributes.Color := c;
        RichEdit.WideSelText := ' ';

        if (use_emoticons) then
            ProcessEmoticons(RichEdit, c, txt)
        else
            RichEdit.WideSelText := txt;
    end

    else begin
        // This is an action
        RichEdit.SelAttributes.Color := clPurple;
        RichEdit.WideSelText := ' * ' + Msg.Nick + ' ';
        if (use_emoticons) then
            ProcessEmoticons(RichEdit, clPurple, Trim(txt))
        else
            RichEdit.WideSelText := txt;
    end;

    RichEdit.SelAttributes.Color := TColor(MainSession.Prefs.getInt('font_color'));
    RichEdit.WideSelText := #13#10;

    // AutoScroll the window
    if ((at_bottom) and (AutoScroll)) then scrollRichEdit(RichEdit);
end;

{---------------------------------------}
procedure ProcessEmoticons(RichEdit: TExRichEdit; color: TColor; txt: Widestring);
var
    m: boolean;
    ms, s: Widestring;
    im, lm: integer;
    eo: TEmoticon;
begin
    // search for various smileys

    // Change the control to allow pasting
    RichEdit.ReadOnly := false;
    s := txt;
    m := emoticon_regex.Exec(txt);
    lm := 0;
    while(m) do begin
        // we have a match
        lm := emoticon_regex.MatchPos[0] + emoticon_regex.MatchLen[0];
        RichEdit.SelAttributes.Color := color;
        RichEdit.WideSelText := emoticon_regex.Match[1];

        if (_pic = nil) then
            _pic := TPicture.Create()
        else
            _pic.Graphic := nil;

        eo := nil;
        // Grab the match text and look it up in our emoticon list
        ms := emoticon_regex.Match[2];
        if (ms <> '') then begin
            im := emoticon_list.IndexOf(ms);
            if (im >= 0) then
                eo := TEmoticon(emoticon_list.Objects[im]);
        end;

        // if we have a legal emoticon object, insert it..
        // otherwise insert the matched text
        if (eo <> nil) then begin
            eo.il.GetBitmap(eo.idx, _pic.Bitmap);
            _pic.Bitmap.Transparent := true;
            RichEdit.InsertBitmap(_pic.Bitmap);
        end
        else begin
            RichEdit.SelAttributes.Color := color;
            RichEdit.WideSelText := ms;
        end;

        // Match-6 is any trailing whitespace
        RichEdit.SelAttributes.Color := color;
        if (lm <= length(txt)) then
            RichEdit.WideSelText := emoticon_regex.Match[6];

        // Search for the next emoticon
        m := emoticon_regex.ExecNext();

        // do a sanity check here, probably because the regex prolly isn't
        // _REALLY_ widestr compliant
        if (m) then begin
            if (length(txt) < emoticon_regex.MatchPos[0]) then
                m := false;
        end;
    end;

    if (lm <= length(txt)) then begin
        // we have a remainder
        txt := Copy(txt, lm, length(txt) - lm + 1);
        RichEdit.SelAttributes.Color := color;
        RichEdit.WideSelText := txt;
    end;

    RichEdit.ReadOnly := true;
end;

{---------------------------------------}
procedure ConfigEmoticons();

    procedure AddEmot(val: string; il: TImageList; idx: integer);
    var
        eo: TEmoticon;
    begin
        eo := TEmoticon.Create();
        eo.il := il;
        eo.idx := idx;
        emoticon_list.AddObject(val, eo);
end;

var
    e: string;
    y, msn: TImageList;
begin
    // Build the regex expression and
    // compile the emoticon_list for fast lookups.
    y := frmExodus.imgYahooEmoticons;
    msn := frmExodus.imgMSNEmoticons;

    // This is a "meta-regex" that should match everything
    e := '(.*)((\([a-zA-Z0-9@{}%&~?/^]+\))|([:;BoOxX][^\t ]+)|(=[;)]))(\s|$)';

    // Normal smileys
    AddEmot(':)', msn, 0);       // normal
    AddEmot('=)', msn, 0);       // normal
    AddEmot(':-)', msn, 0);
    AddEmot(':(', msn, 9);       // unhappy
    AddEmot(':-(', msn, 9);
    AddEmot(';)', msn, 38);      // wink
    AddEmot(';-)', msn, 38);
    AddEmot(':D', msn, 42);      // big smile
    AddEmot(':-D', msn, 42);
    AddEmot(':>', msn, 42);
    AddEmot(':->', msn, 42);
    AddEmot(':$', msn, 3);       // blushing
    AddEmot(':blush', msn, 3);   // blushing
    AddEmot(':-/', y, 5);        // question
    AddEmot(':-\', y, 5);
    AddEmot(':x', y, 6);         // love
    AddEmot(':-x', y, 6);
    AddEmot(':X', y, 6);
    AddEmot(':-X', y, 6);
    AddEmot(':">', y, 7);        // blushing
    AddEmot(':p', msn, 45);      // tongue
    AddEmot(':-p', msn, 45);
    AddEmot(':P', msn, 45);
    AddEmot(':-P', msn, 45);
    AddEmot(':o', msn, 44);      // surprise
    AddEmot(':O', msn, 44);
    AddEmot(':-o', msn, 44);
    AddEmot(':-O', msn, 44);
    AddEmot('(/)', msn, 43);     // graphy-thing
    AddEmot(':|', msn, 2);       // undecided
    AddEmot(':-|', msn, 2);
    AddEmot(':cool', msn, 22);   // sunglasses
    AddEmot('B)', msn, 22);
    AddEmot('B-)', msn, 22);

//    AddEmot('>:)', y, 13);       // yahoo devil
    AddEmot(':devil', y, 13);       // yahoo devil
    AddEmot('O:)', y, 17);       // yahoo angel
    AddEmot('O:-)', y, 17);
    AddEmot('o:)', y, 17);
    AddEmot('o:-)', y, 17);
    AddEmot(':B', y, 18);        // smiley wearing glasses
    AddEmot(':-B', y, 18);
    AddEmot('=;', y, 19);        // talk to the hand
    AddEmot(':sleep', y, 20);       // sleeping
    AddEmot('(F)', msn, 20);
    AddEmot(':rose', msn, 20);   // rose
//    AddEmot('@}:-', msn, 20);  // regex doesn't match this.
    AddEmot(':skull', y, 25);       // skull
    AddEmot('(A)', msn, 15);     // Angel
    AddEmot(':saint', msn, 15);
    AddEmot(':S', msn, 1);       // confused look
    AddEmot(':-S', msn, 1);
    AddEmot(':s', msn, 1);
    AddEmot(':-s', msn, 1);
    AddEmot(':conf', msn, 1);
    AddEmot('(Y)', msn, 36);     // yes, thumb up
    AddEmot('(N)', msn, 27);     // no, thumb down
    AddEmot('(X)', msn, 35);     // girl
    AddEmot(':girl', msn, 35);
    AddEmot('(Z)', msn, 37);     // boy
    AddEmot(':boy', msn, 37);
    AddEmot('(L)', msn, 25);     // Love
    AddEmot('(U)', msn, 33);     // Unlove
    AddEmot('(P)', msn, 29);     // Picture
    AddEmot('(G)', msn, 21);     // Gift
    AddEmot('(%)', msn, 6);      // handcuffs
    AddEmot('(D)', msn, 18);     // Drink (martini)
    AddEmot(':[', msn, 40);      // bat/vampire
    AddEmot(':=[', msn, 40);
    AddEmot('(E)', msn, 19);     // Email
    AddEmot('(T)', msn, 32);     // Telephone
    AddEmot('(K)', msn, 24);     // kiss
    AddEmot(':lips', msn, 24);
    AddEmot('(I)', msn, 23);     // idea/light bulb
    AddEmot('(S)', msn, 31);     // asleep
    AddEmot('(8)', msn, 5);      // music
    AddEmot('o/~', msn, 5);
    AddEmot('o/`', msn, 5);
    AddEmot('(@)', msn, 10);     // cat
    AddEmot('(C)', msn, 17);     // cup
    AddEmot('(c)', msn, 17);     // cup
    AddEmot('(^)', msn, 11);     // cake
    AddEmot('(W)', msn, 34);     // Wilted rose
    AddEmot('(?)', msn, 41);     // ASL/Age Sex Location
    AddEmot(':@', msn, 39);      // angry
    AddEmot(':-@', msn, 39);
    AddEmot(':mad', msn, 39);
    AddEmot(':grrr', msn, 39);
    AddEmot('X(', msn, 39);
    AddEmot('X-(', msn, 39);
    AddEmot('x(', msn, 39);
    AddEmot('x-(', msn, 39);
    AddEmot('({)', msn, 12);     // hug right
    AddEmot('(})', msn, 13);     // hug left
    AddEmot(':''(', y, 14);   // cry
    AddEmot(';''(', msn, 8);
    AddEmot(':cry', y, 14);
    AddEmot('(&)', msn, 7);      // dog
    AddEmot('(~)', msn, 14);     // movie
    AddEmot('(R)', msn, 30);     // Rainbow
    AddEmot('(O)', msn, 28);     // time/clock
    AddEmot('(6)', msn, 4);      // devil
    AddEmot(':eek2', msn, 4);
    AddEmot(':jester', y, 0);    // clown
    AddEmot(':breath', msn, 46); // hold my breath
//    AddEmot('(o)', msn, 46);
    AddEmot('(B)', msn, 16);
    AddEmot(':kissme', msn, 47);
    AddEmot(':kissmyass', msn, 47);
    AddEmot('(H)', msn, 22);

    (*
    Emoticon map:

    GO Client
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
    x:mad
    x:eek2
    x:jester
    x:saint
    :oops
    :crazed
    :roll
    :crazy
    :love
    :ninja
    x:girl
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

    *)


    // Create the static regex object and compile it.
    emoticon_regex := TRegExpr.Create();
    emoticon_regex.ModifierG := false;
    emoticon_regex.Expression := e;
    emoticon_regex.Compile();

    _pic := nil;
end;

{---------------------------------------}
procedure DisplayPresence(txt: string; Browser: TExRichEdit);
var
    pt : integer;
    at_bottom: boolean;
begin
    at_bottom := atBottom(Browser);
    pt := MainSession.Prefs.getInt('pres_tracking');
    if (pt = 2) then exit;
    with Browser do begin
        if (pt = 1) then begin
            Browser.SelStart := Length(Browser.Lines.Text) - 3;
            Browser.SelLength := 1;
            if (Browser.SelAttributes.Color = clGray) then
                Browser.WideLines.Delete(Browser.Lines.Count-1);
        end;

        SelStart := Length(Lines.Text);
        SelLength := 0;

        SelAttributes.Color := clGray;
        WideSelText := txt + #13#10;
    end;

    if (at_bottom) then scrollRichEdit(Browser);
end;

{---------------------------------------}
function GetMsgHTML(Msg: TJabberMessage): string;
var
    color, txt, html, time, bg, font: string;
    cr_pos: integer;
begin
    // replace CR's w/ <br> tags
    txt := HTML_EscapeChars(Msg.Body, false);
    repeat
        cr_pos := Pos(#13#10, txt);
        if cr_pos > 0 then begin
            Delete(txt, cr_pos, 2);
            Insert('<br />', txt, cr_pos);
        end;
    until (cr_pos <= 0);

    with MainSession.Prefs do begin
        if (getBool('timestamp')) then
            time := '<span style="color: gray;">[' +
                    FormatDateTime(getString('timestamp_format'), Msg.Time) +
                    ']</span>'
        else
            time := '';
        bg := 'background-color: ' + ColorToHTML(TColor(getInt('color_bg'))) + ';';

        //font-family: Arial Black; font-size: 10pt
        font := 'font-family: ' + getString('font_name') + '; ' +
                'font-size: ' + getString('font_size') + 'pt;';
        if Msg.Action then
            html := '<div style="' + bg + font + '">' + time +
                    '<span style="color: purple;">* ' + txt + '</span></div>'
        else begin
            if Msg.isMe then
                color := ColorToHTML(TColor(MainSession.Prefs.getInt('color_me')))
            else
                color := ColorToHTML(TColor(MainSession.Prefs.getInt('color_other')));

            if (Msg.Nick <> '') then
                html := '<div style="' + bg + font + '">' +
                    time + '<span style="color: ' + color + ';">&lt;' +
                    Msg.Nick + '&gt;</span> ' + txt + '</div>'
            else
                html := '<div style="' + bg + font + '">' +
                    time + '<span style="color: green;">' +
                    txt + '</span></div>';
        end;
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
    emoticon_list := THashedStringList.Create();

finalization
    if (emoticon_regex <> nil) then
        emoticon_regex.Free();
    if (_pic <> nil) then
        _pic.Free();
    ClearStringListObjects(emoticon_list);
    emoticon_list.Free();

end.



