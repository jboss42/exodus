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
    iniFiles, BaseMsgList,
    ExRichEdit, RichEdit2, RegExpr, Classes, JabberMsg,
    Graphics, ComCtrls, Controls, Messages, Windows, SysUtils;

function RTFColor(color_pref: string) : string;
procedure DisplayMsg(Msg: TJabberMessage; msglist: TfBaseMsgList; AutoScroll: boolean = true);
procedure DisplayRTFMsg(RichEdit: TExRichEdit; Msg: TJabberMessage; AutoScroll: boolean = true);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses

    Clipbrd, Jabber1, JabberUtils, ExUtils,  Emote,
    ExtCtrls, Dialogs, XMLUtils, Session;

const
    MAX_MSG_LENGTH = 512;

{---------------------------------------}
procedure DisplayMsg(Msg: TJabberMessage; msglist: TfBaseMsgList; AutoScroll: boolean = true);
begin
    // Just write out using the frame's rendering code
    msglist.DisplayMsg(msg, AutoScroll);
end;

{---------------------------------------}
function RTFColor(color_pref: string) : string;
var
    color: TColor;
begin
    color := TColor(MainSession.Prefs.getInt(color_pref));
    result :=
        '\red'   + IntToStr(color and clRed) +
        '\green' + IntToStr((color and clLime) shr 8) +
        '\blue'  + IntToStr((color and clBlue) shr 16) +
        ';';
end;

{---------------------------------------}
procedure DisplayRTFMsg(RichEdit: TExRichEdit; Msg: TJabberMessage; AutoScroll: boolean = true);
var
    len, fvl: integer;
    txt: WideString;
    at_bottom: boolean;
    is_scrolling: boolean;
begin
    // add the message to the richedit control
    fvl := RichEdit.FirstVisibleLine;
    at_bottom := RichEdit.atBottom;
    is_scrolling := RichEdit.isScrolling;

    txt := '{\rtf1 {\colortbl;'  +
        RTFColor('color_time')   + // \cf1
        RTFColor('color_server') + // \cf2
        RTFColor('color_action') + // \cf3
        RTFColor('color_me')     + // \cf4
        RTFColor('color_other')  + // \cf5
        RTFColor('font_color')   + // \cf6
        '}\uc1';

    if (MainSession.Prefs.getBool('timestamp')) then begin
        txt := txt + '\cf1[';
        try
            txt := txt +
                EscapeRTF(FormatDateTime(MainSession.Prefs.getString('timestamp_format'),
                                         Msg.Time));
        except
            on EConvertError do begin
                txt := txt +
                    EscapeRTF(FormatDateTime(MainSession.Prefs.getString('timestamp_format'),
                                             Now()));
            end;
        end;

        txt := txt + ']';
    end;

    len := Length(Msg.Body);
    
    if (Msg.Nick = '') then begin
        // Server generated msgs (mostly in TC Rooms)
        txt := txt + '\cf2  ' + EscapeRTF(Msg.Body);
    end

    else if not Msg.Action then begin
        // This is a normal message
        if Msg.isMe then
            // our own msgs
            txt := txt + '\cf4 '
        else
            // other person's msgs
            txt := txt + '\cf5 ';

        txt := txt + '<' + EscapeRTF(Msg.nick) + '>';

        if (Msg.Highlight) then
            txt := txt + '\cf4  '
        else
            txt := txt + '\cf6  ';

        if ((use_emoticons) and (len < MAX_MSG_LENGTH)) then
            txt := txt + ProcessRTFEmoticons(Msg.Body)
        else
            txt := txt + EscapeRTF(Msg.Body);
    end

    else begin
        // This is an action
        txt := txt + '\cf3  * ' + Msg.Nick + ' ';
        if ((use_emoticons) and (len < MAX_MSG_LENGTH)) then
            txt := txt + ProcessRTFEmoticons(Trim(Msg.Body))
        else
            txt := txt + EscapeRTF(Msg.Body);
    end;

    txt := txt + '\cf6\par }';

    RichEdit.SelStart := Length(RichEdit.Lines.Text);
    RichEdit.SelLength := 0;
    RichEdit.Paragraph.Alignment := taLeft;
    RichEdit.SelAttributes.BackColor := RichEdit.Color;
    RichEdit.RTFSelText := txt;

    // AutoScroll the window
    if ((at_bottom) and (AutoScroll) and (not is_scrolling)) then begin
        RichEdit.ScrollToBottom();
    end
    else begin
        RichEdit.Line := fvl;
    end;


end;

end.



