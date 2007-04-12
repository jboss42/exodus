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
procedure DisplayRTFMsg(RichEdit: TExRichEdit; Msg: TJabberMessage; AutoScroll: boolean; color_time, color_priority, color_server, color_action, color_me, color_other, font_color: integer) overload;
function RTFEncodeKeywords(txt: Widestring) : Widestring;
procedure HighlightKeywords(rtDest: TExRichEdit; startPos: integer);forward;
function AdjustDST( inTime : TDateTime): TDateTime;
function isTimeDST(time: TDateTime): Boolean;
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberConst,
    XMLParser,
    RT_XIMConversion,
    Clipbrd, Jabber1, JabberUtils, ExUtils,  Emote,
    ExtCtrls, Dialogs, XMLTag, XMLUtils, Session, Keywords, TypInfo, DateUtils;

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
                  MainSession.Prefs.getInt('color_priority'),
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
    fooTag := Msg.GetTag;
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
                        color_time, color_priority, color_server, color_action, color_me, color_other, font_color: integer);
var
    len, fvl: integer;
    txt, body: WideString;
    at_bottom: boolean;
    is_scrolling: boolean;
    ximTag: TXMLTag;
    hlStartPos: integer;
begin
    // add the message to the richedit control
    fvl := RichEdit.FirstVisibleLine;
    at_bottom := RichEdit.atBottom;
    is_scrolling := RichEdit.isScrolling;
    ximTag := nil;
    txt := '{\rtf1 {\colortbl;'  +
        RTFColor(color_time)   + // \cf1
        RTFColor(color_server) + // \cf2
        RTFColor(color_action) + // \cf3
        RTFColor(color_me)     + // \cf4
        RTFColor(color_other)  + // \cf5
        RTFColor(font_color)   + // \cf6
        RTFColor(color_priority) + // \cf7
        '}\uc1';

    if (MainSession.Prefs.getBool('timestamp')) then begin
        txt := txt + '\cf1[';
        try
         DebugMsg('Original:' + FormatDateTime(MainSession.Prefs.getString('timestamp_format'),
                                         Msg.Time));
         Msg.Time := AdjustDST(Msg.Time);
         DebugMsg('Adjusted:' + FormatDateTime(MainSession.Prefs.getString('timestamp_format'),
                                         Msg.Time));
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

    if (Msg.Priority = high) then begin
        txt := txt + '\cf7[' + EscapeRTF(GetDisplayPriority(Msg.Priority)) + ']';
    end
    else if (Msg.Priority = low) then begin
       //We want to default color for low priority messages to timestamp color
       txt := txt + '\cf1[' + EscapeRTF(GetDisplayPriority(Msg.Priority)) + ']';
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

    RichEdit.SelStart := Length(RichEdit.WideLines.Text);
    RichEdit.SelLength := 0;
    RichEdit.Paragraph.Alignment := taLeft;
    RichEdit.SelAttributes.BackColor := RichEdit.Color;
    hlStartPos := Length(RichEdit.WideLines.Text); // Done here because RTFSelText messes this up.
    RichEdit.RTFSelText := txt;

    if (ximTag <> nil) then begin
        //if this is our messages, don't eat font style props
        XIMToRT(richedit, ximTag, Msg.Body, not Msg.isMe);
        HighlightKeywords(RichEdit, hlStartPos);
        ximTag.Free();
    end
    else begin
        HighlightKeywords(RichEdit, hlStartPos);
    end;

    RichEdit.SelStart := Length(RichEdit.WideLines.Text);
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

procedure HighlightKeywords(rtDest: TExRichEdit; startPos: integer);
var
    keywords : RegExpr.TRegExpr;
    hlColor: TColor;
    allTxt: WideString;
    currPos: integer;
    len: integer;
    tint: integer;
begin
    hlColor := MainSession.Prefs.getInt('color_me');

    allTxt := Copy(rtDest.WideLines.Text, startPos+1, length(rtDest.WideLines.Text));
    allTxt := StringReplace(allTxt, #$D#$A, '', [rfReplaceAll, rfIgnoreCase]);

    //Create a TRegExpr based on Keyword Prefs
    keywords := CreateKeywordsExpr();
    currPos := startPos;
    len := length(rtDest.WideLines.Text);

    if (keywords <> nil) then begin
        try
            //Find one or more keyword matches and format them
            if (keywords.Exec(allTxt)) then begin
                repeat
                    tint := rtDest.FindWideText(keywords.Match[0], currPos, len, []);
                    if (tint <> -1) then begin
                        rtDest.SelStart := tint;
                        rtDest.SelLength := keywords.MatchLen[0];
                        rtDest.SelAttributes.Color := hlColor;
                        rtDest.SelAttributes.Bold := true;
                        currPos := tint + keywords.MatchLen[0]; 
                    end;
                until not Keywords.ExecNext;
            end;
        except
        end;

        FreeAndNil(keywords);
    end;
end;

function AdjustDST( inTime : TDateTime): TDateTime;
var
  timezoneinfo: TTimezoneinformation;
  dstNow, dstTime: Boolean;
  timezoneResult: word;
begin
  Result := inTime;
  timezoneResult  := GetTimezoneInformation(timezoneinfo);
  //If automatic DST adjustment check box is not checked,
  //we do not need to adjust time.
  if (timezoneinfo.DaylightBias = 0) then
     exit;
     
  dstTime := isTimeDST(inTime);
  //If we are currently in DST and time for the message is
  //not in DST, we need to adjust by subtracting (bias is negative)
  if (timezoneResult = TIME_ZONE_ID_DAYLIGHT) then begin
    if (dstTime = false) then
      Result := IncMinute(inTime, timezoneinfo.DaylightBias);

  end
  else begin
     //If we are currently not in DST and time for the message is
     //in DST, we need to adjust by adding (bias is negative)
     if (dstTime = true) then
      Result := IncMinute(inTime, -timezoneinfo.DaylightBias);

  end;

end;

function isTimeDST(time: TDateTime): Boolean;
var
  timezoneinfo: TTimezoneinformation;
  dstStart, dstEnd: TDateTime;
  Year, Month, Day, Hour, Min, Sec, Milli: word;
begin

    GetTimezoneInformation(timezoneinfo);
    DecodeDateTime(time, Year, Month, Day, Hour, Min, Sec, Milli);
    //Calculate when daylight savings time begins
    with timezoneinfo.DaylightDate do
      dstStart:=encodedate(Year,wmonth,wday)+encodetime(whour,wminute,wsecond,wmilliseconds);
    //Calculate when daylight savings time ends
    with timezoneinfo.StandardDate do
      dstEnd:=encodedate(Year,wmonth,wday)+encodetime(whour,wminute,wsecond,wmilliseconds);

    if ((time >= dstStart) and (time <= dstEnd)) then
      Result := true
    else
      Result := false;

end;
end.



