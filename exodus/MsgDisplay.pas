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

procedure DisplayMsg(Msg: TJabberMessage; msglist: TfBaseMsgList; AutoScroll: boolean = true);
procedure DisplayRTFMsg(RichEdit: TExRichEdit; Msg: TJabberMessage; AutoScroll: boolean = true);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses

    Clipbrd, Jabber1, JabberUtils, ExUtils,  Emote,
    ExtCtrls, Dialogs, XMLUtils, Session;

{---------------------------------------}
procedure DisplayMsg(Msg: TJabberMessage; msglist: TfBaseMsgList; AutoScroll: boolean = true);
begin
    // Just write out using the frame's rendering code
    msglist.DisplayMsg(msg, AutoScroll);
end;

{---------------------------------------}
procedure DisplayRTFMsg(RichEdit: TExRichEdit; Msg: TJabberMessage; AutoScroll: boolean = true);
var
    txt: WideString;
    c: TColor;
    at_bottom: boolean;
    is_scrolling: boolean;
begin
    // add the message to the richedit control
    //at_bottom := atBottom(RichEdit);
    at_bottom := RichEdit.atBottom;
    is_scrolling := RichEdit.isScrolling;

    txt := Msg.Body;

    // Make sure we're inputting text in Unicode format.
    RichEdit.InputFormat := ifUnicode;
    //RichEdit.SelAttributes.Protected := false;
    RichEdit.SelStart := Length(RichEdit.WideLines.Text);
    RichEdit.SelLength := 0;

    if (MainSession.Prefs.getBool('timestamp')) then begin
        RichEdit.SelAttributes.Color := clGray;
        try
            RichEdit.WideSelText := '[' +
                FormatDateTime(MainSession.Prefs.getString('timestamp_format'),
                Msg.Time) + ']';
        except
            on EConvertError do begin
                RichEdit.WideSelText := '[' +
                    FormatDateTime(MainSession.Prefs.getString('timestamp_format'),
                    Now()) + ']';
            end;
        end;
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

        if (Msg.Highlight) then begin
            c := TColor(MainSession.Prefs.getInt('color_me'));
        end
        else begin
            c := TColor(MainSession.Prefs.getInt('font_color'));
        end;
        RichEdit.SelAttributes.Color := c;
        RichEdit.WideSelText := ' ';

        if (use_emoticons) then
            ProcessRTFEmoticons(RichEdit, c, txt)
        else
            RichEdit.WideSelText := txt;
    end

    else begin
        // This is an action
        RichEdit.SelAttributes.Color := clPurple;
        RichEdit.WideSelText := ' * ' + Msg.Nick + ' ';
        if (use_emoticons) then
            ProcessRTFEmoticons(RichEdit, clPurple, Trim(txt))
        else
            RichEdit.WideSelText := txt;
    end;

    RichEdit.SelAttributes.Color := TColor(MainSession.Prefs.getInt('font_color'));
    RichEdit.WideSelText := #13#10;

    // AutoScroll the window
    if ((at_bottom) and (AutoScroll) and (not is_scrolling)) then
        RichEdit.ScrollToBottom();
end;


end.



