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

function RTFColor(color_pref: integer) : string;
procedure DisplayMsg(Msg: TJabberMessage; msglist: TfBaseMsgList; AutoScroll: boolean = true);
procedure DisplayRTFMsg(RichEdit: TExRichEdit; Msg: TJabberMessage; AutoScroll: boolean = true) overload;
procedure DisplayRTFMsg(RichEdit: TExRichEdit; Msg: TJabberMessage; AutoScroll: boolean; color_time, color_server, color_action, color_me, color_other, font_color: integer) overload;
function RTFEncodeKeywords(txt: Widestring) : Widestring;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberConst,
    XMLParser,
    RT_XIMConversion,
    Clipbrd, Jabber1, JabberUtils, ExUtils,  Emote,
    ExtCtrls, Dialogs, XMLTag, XMLUtils, Session, Keywords;

const
    MAX_MSG_LENGTH = 512;

{---------------------------------------}
procedure DisplayMsg(Msg: TJabberMessage; msglist: TfBaseMsgList; AutoScroll: boolean = true);
begin
    // Just write out using the frame's rendering code
    msglist.DisplayMsg(msg, AutoScroll);
end;

{---------------------------------------}
function RTFColor(color_pref: integer) : string;
var
    color: TColor;
begin
    color := TColor(color_pref);
    result :=
        '\red'   + IntToStr(color and clRed) +
        '\green' + IntToStr((color and clLime) shr 8) +
        '\blue'  + IntToStr((color and clBlue) shr 16) +
        ';';
end;

{---------------------------------------}
procedure DisplayRTFMsg(RichEdit: TExRichEdit; Msg: TJabberMessage; AutoScroll: boolean = true);
begin
    DisplayRTFMsg(RichEdit,
                  Msg,
                  AutoScroll,
                  MainSession.Prefs.getInt('color_time'),
                  MainSession.Prefs.getInt('color_server'),
                  MainSession.Prefs.getInt('color_action'),
                  MainSession.Prefs.getInt('color_me'),
                  MainSession.Prefs.getInt('color_other'),
                  MainSession.Prefs.getInt('font_color'));
end;

function getXIMTag(msg: TJabberMessage): TXMLTag;
var
    fooTag: TXMLTag;
    _parser: TXMLTagParser;
begin
    fooTag := Msg.Tag;
    Result := fooTag.GetFirstTag('html');
    if ((Result = nil) or (Result.getAttribute('xmlns') <> XMLNS_XHTMLIM)) then begin
        //check XML attrib of message to see if there is any additional
        //children that haven't made it inot tag yet...
        if (fooTag.XML <> '') and (Pos('<html', fooTag.XML) > 0) then begin
            _parser := TXMLTagParser.Create();
            _parser.Clear();
            _parser.ParseString(fooTag.XML, '');
            if (_parser.Count > 0) then begin
                fooTag.Free();
                fooTag := _parser.popTag();
                Result := fooTag.GetFirstTag('html');
            end;
            _parser.Free();
        end;
    end;
    if ((Result <> nil) and (Result.getAttribute('xmlns') <> XMLNS_XHTMLIM)) then
        Result := nil;
    if (Result <> nil) then
        Result := TXMLTag.Create(Result);
    fooTag.Free();        
end;

{---------------------------------------}
procedure DisplayRTFMsg(RichEdit: TExRichEdit; Msg: TJabberMessage; AutoScroll: boolean;
                        color_time, color_server, color_action, color_me, color_other, font_color: integer);
var
    len, fvl: integer;
    txt, body: WideString;
    at_bottom: boolean;
    is_scrolling: boolean;
    ximTag: TXMLTag;
begin
    // add the message to the richedit control
    fvl := RichEdit.FirstVisibleLine;
    at_bottom := RichEdit.atBottom;
    is_scrolling := RichEdit.isScrolling;

    txt := '{\rtf1 {\colortbl;'  +
        RTFColor(color_time)   + // \cf1
        RTFColor(color_server) + // \cf2
        RTFColor(color_action) + // \cf3
        RTFColor(color_me)     + // \cf4
        RTFColor(color_other)  + // \cf5
        RTFColor(font_color)   + // \cf6
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
        txt := txt + '<' + EscapeRTF(Msg.nick) + '>\cf6  ';
        //check to see if xhtmlim is supported and supplied
        ximTag := nil;
        if (MainSession.Prefs.getBool('richtext_enabled')) then
            ximTag := getXIMTag(Msg);
        if (ximTag = nil) then begin
            //Parse emoticons and/or escape RTF chars
            if ((use_emoticons) and (len < MAX_MSG_LENGTH)) then
              body := ProcessRTFEmoticons(Msg.Body)
            else
              body := EscapeRTF(Msg.Body);

            // Format keywords
            if (Msg.Highlight) then
              body := RTFEncodeKeywords(body);

            //Append body
            txt := txt + body;
        end;
    end
    else begin
        // This is an action
        txt := txt + '\cf3  * ' + Msg.Nick + ' ';
        if ((use_emoticons) and (len < MAX_MSG_LENGTH)) then
            txt := txt + ProcessRTFEmoticons(Trim(Msg.Body))
        else
            txt := txt + EscapeRTF(Msg.Body);
    end;

    txt := txt + '\cf6 }';

    RichEdit.SelStart := Length(RichEdit.Lines.Text);
    RichEdit.SelLength := 0;
    RichEdit.Paragraph.Alignment := taLeft;
    RichEdit.SelAttributes.BackColor := RichEdit.Color;
    RichEdit.RTFSelText := txt;

    if (ximTag <> nil) then begin
        //if this is our messages, don't eat font style props
        if (Msg.isMe) then
            txt := ''
        else txt := MainSession.Prefs.getString('richtext_ignored_font_styles');

        XIMToRT(richedit, ximTag, txt);
        ximTag.Free();
    end;
    
    RichEdit.SelStart := Length(RichEdit.Lines.Text);
    RichEdit.SelLength := 0;
    RichEdit.RTFSelText := '{\rtf1 \par }';

    // AutoScroll the window
    if ((at_bottom) and (AutoScroll) and (not is_scrolling)) then begin
        RichEdit.ScrollToBottom();
    end
    else begin
        RichEdit.Line := fvl;
    end;
end;

function RTFEncodeKeywords(txt: Widestring) : Widestring;
const
  PREFIX : Widestring = '\cf4\b '; //Highlight formatting
  SUFFIX : Widestring = '\b0\cf6 '; //Regular formatting
var
  pos : integer;
  keywords : RegExpr.TRegExpr;
begin
  pos := 1;

  //Create a TRegExpr based on Keyword Prefs
  keywords := CreateKeywordsExpr();

  if (keywords <> nil) then begin
    try
      //Find one or more keyword matches and format them
      if (keywords.Exec(txt)) then begin
        repeat
          result := result +
            Copy(txt,pos,keywords.MatchPos[0]-pos) + //Chunk before the keyword
            PREFIX +
            Copy(txt,keywords.MatchPos[0],keywords.MatchLen[0]) + //Keyword
            SUFFIX;

          pos := keywords.MatchPos[0] + keywords.MatchLen[0];
        until not Keywords.ExecNext;
      end;
    except
      result := txt;
    end;

    FreeAndNil(keywords);
  end;

  result := result + Copy(txt,pos,length(txt)-pos+1); //Append the remaining chunk
end;

end.



