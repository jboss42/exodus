unit IEMsgList;

{
    Copyright 2004, Peter Millard

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

// To use IE (TWebBrowser) as the history window in chats/rooms
// set <msglist_type value="1"/> in the defaults
// or a branding file.  If msglist_type is left at a value of 0, then the
// history window will still be RTF and not HTML even though HTML support is
// compiled in.

interface


uses
    TntMenus, JabberMsg,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Regexpr, iniFiles,
    BaseMsgList, Session, gnugettext, unicode,
    XMLTag, XMLNode, XMLConstants, XMLCdata, LibXmlParser, XMLUtils,
    OleCtrls, SHDocVw, MSHTML, mshtmlevents, ActiveX,
    IEMsgListUIHandler;

  function HTMLColor(color_pref: integer) : widestring;

type
  TfIEMsgList = class(TfBaseMsgList)
    browser: TWebBrowser;
    procedure browserDocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure browserBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure browserDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure browserDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);

  private
    { Private declarations }
    _home: WideString;

    _doc: IHTMLDocument2;
    _win: IHTMLWindow2;
    _body: IHTMLElement;
    _style: IHTMLStyleSheet;
    _content: IHTMLElement;
    _content2: IHTMLElement2;
    _lastelement: IHTMLElement;
    _composingelement: IHTMLElement;

    _we: TMSHTMLHTMLElementEvents;
    _we2: TMSHTMLHTMLElementEvents2;
    _de: TMSHTMLHTMLDocumentEvents;

    _bottom: Boolean;
    _menu:  TTntPopupMenu;
    _queue: TWideStringList;
    _title: WideString;
    _ready: Boolean;
    _idCount: integer;
    _displayDateSeparator: boolean;
    _lastTimeStamp: TDateTime;
    _composing: integer;
    _msgCount: integer;
    _maxMsgCountHigh: integer;
    _maxMsgCountLow: integer;
    _doMessageLimiting: boolean;

    _dragDrop: TDragDropEvent;
    _dragOver: TDragOverEvent;

    _lastLineClass: WideString;
    _lastMsgNick: WideString;
    _exeName: Widestring;

    _font_name: widestring;
    _font_size: widestring;
    _font_color: integer;
    _color_bg: integer;
    _color_alt_bg: integer;
    _color_date_bg: integer;
    _color_date: integer;
    _color_me: integer;
    _color_other: integer;
    _color_time: integer;
    _color_action: integer;
    _color_server: integer;
    _font_bold: boolean;
    _font_italic: boolean;
    _font_underline: boolean;
    _stylesheet_name: widestring;
    _webBrowserUI: TWebBrowserUIObject;

    _ForceIgnoreScrollToBottom: boolean;
    _Clearing: boolean;
    _ClearingMsgCache: TWidestringList;

    procedure onScroll(Sender: TObject);
    procedure onResize(Sender: TObject);

    function onDrop(Sender: TObject): WordBool;
    function onDragOver(Sender: TObject): WordBool;
    function onContextMenu(Sender: TObject): WordBool;
    function onKeyPress(Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool;
    function _genElementID(): WideString;
    procedure _ClearOldMessages();
    function _getHistory(includeCount: boolean = true): WideString;
    function _processUnicode(txt: widestring): WideString;
    function _getLineClass(Msg: TJabberMessage): WideString; overload;
    function _getLineClass(nick: widestring): WideString; overload;
    function _checkLastNickForMsgGrouping(Msg: TJabberMessage): boolean; overload;
    function _checkLastNickForMsgGrouping(nick: widestring): boolean; overload;

  protected
      procedure writeHTML(html: WideString);

  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

    procedure Invalidate(); override;
    procedure CopyAll(); override;
    procedure Copy(); override;
    procedure ScrollToBottom(); override;
    procedure ScrollToTop();
    procedure Clear(); override;
    procedure setContextMenu(popup: TTntPopupMenu); override;
    procedure setDragOver(event: TDragOverEvent); override;
    procedure setDragDrop(event: TDragDropEvent); override;
    procedure DisplayMsg(Msg: TJabberMessage; AutoScroll: boolean = true); override;
    procedure DisplayPresence(nick, txt: Widestring; timestamp: string); override;
    function  getHandle(): THandle; override;
    function  getObject(): TObject; override;
    function  empty(): boolean; override;
    function  getHistory(): Widestring; override;
    procedure Save(fn: string); override;
    procedure populate(history: Widestring); override;
    procedure setupPrefs(); override;
    procedure setTitle(title: Widestring); override;
    procedure ready(); override;
    procedure refresh(); override;
    procedure DisplayComposing(msg: Widestring); override;
    procedure HideComposing(); override;
    function  isComposing(): boolean; override;

    procedure ChangeStylesheet( resname: WideString);
    procedure ResetStylesheet();
    procedure print(ShowDialog: boolean);

    property font_name: widestring read _font_name write _font_name;
    property font_size: widestring read _font_size write _font_size;
    property font_color: integer read _font_color write _font_color;
    property color_bg: integer read _color_bg write _color_bg;
    property color_alt_bg: integer read _color_alt_bg write _color_alt_bg;
    property color_date_bg: integer read _color_date_bg write _color_date_bg;
    property color_date: integer read _color_date write _color_date;
    property color_me: integer read _color_me write _color_me;
    property color_other: integer read _color_other write _color_other;
    property color_time: integer read _color_time write _color_time;
    property color_action: integer read _color_action write _color_action;
    property color_server: integer read _color_server write _color_server;
    property stylesheet_name: widestring read _stylesheet_name write _stylesheet_name;
    property font_bold: boolean read _font_bold write _font_bold;
    property font_italic: boolean read _font_italic write _font_italic;
    property font_underline: boolean read _font_underline write _font_underline;
    property ForceIgnoreScrollToBottom: boolean read _ForceIgnoreScrollToBottom write _ForceIgnoreScrollToBottom;

  end;

var
  fIEMsgList: TfIEMsgList;
  xp_xhtml: TXPLite;
  ok_tags: THashedStringList;
  style_tags: THashedStringList;
  style_props: THashedStringList;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation


uses
    JabberConst,
    Jabber1,
    BaseChat,
    JabberUtils,
    ExUtils,
    ShellAPI,
    Emote,
    StrUtils,
    RT_XIMConversion,
    Registry,
    PrefController;

{$R *.dfm}

{---------------------------------------}
function HTMLColor(color_pref: integer) : widestring;
var
    color: TColor;
begin
    color := TColor(color_pref);
    Result := IntToHex(GetRValue(color), 2) +
              IntToHex(GetGValue(color), 2) +
              IntToHex(GetBValue(color), 2);
end;

{---------------------------------------}
constructor TfIEMsgList.Create(Owner: TComponent);
var
    OleObj: IOleObject;
    reg: TRegistry;
    IEOverrideReg: widestring;
    tstring: widestring;
begin
    inherited;
    _queue := TWideStringList.Create();
    _ready := true;
    _idCount := 0;
    _composing := -1;
    _msgCount := 0;
    _doMessageLimiting := false;
    _Clearing := false;
    _ClearingMsgCache := TWidestringList.Create();

    // Setup registry to override IE settings
    try
        reg := TRegistry.Create();
        if (reg <> nil) then begin
            IEOverrideReg := '\Software\Jabber\' + PrefController.GetAppInfo().ID + '\IEMsgList';

            tstring := IEOverrideReg + '\Settings';
            reg.RootKey := HKEY_CURRENT_USER;
            reg.OpenKey(tstring, true);
            reg.WriteInteger('Always Use My Colors', 0);
            reg.WriteInteger('Always Use My Font Face', 0);
            reg.WriteInteger('Always Use My Font Size', 0);
            reg.CloseKey();

            tstring := IEOverrideReg + '\Styles';
            reg.RootKey := HKEY_CURRENT_USER;
            reg.OpenKey(tstring, true);
            reg.WriteInteger('Use My Stylesheet', 0);
            reg.CloseKey();

            reg.Free();
        end;
    except
    end;

    with MainSession.Prefs do begin
        _maxMsgCountHigh := getInt('maximum_displayed_messages');
        _maxMsgCountLow := getInt('maximum_displayed_messages_drop_down_to');
        if ((_maxMsgCountHigh <> 0) and
            (_maxMsgCountHigh >= _maxMsgCountLow))then begin
            _doMessageLimiting := true;
            if (_maxMsgCountLow <= 0) then begin
                // High water mark set, but low water mark not set.
                // So, we will make the low water mark equal to the  high water mark.
                // This will only drop 1 message at a time.
                _maxMsgCountLow := _maxMsgCountHigh;
            end;
        end;
        _displayDateSeparator := getBool('display_date_separator');
        _exeName := getString('exe_FullPath');

        _stylesheet_name := getString('ie_css');
        _font_name := getString('font_name');
        _font_size := getString('font_size');
        _font_bold := getBool('font_bold');
        _font_italic := getBool('font_italic');
        _font_underline := getBool('font_underline');
        _font_color := getInt('font_color');
        _color_bg := getInt('color_bg');
        _color_alt_bg := getInt('color_alt_bg');
        _color_date_bg := getInt('color_date_bg');
        _color_date := getInt('color_date');
        _color_me := getInt('color_me');
        _color_other := getInt('color_other');
        _color_time := getInt('color_time');
        _color_action := getInt('color_action');
        _color_server := getInt('color_server');
    end;

    // Set IDocHostUIHandler interface to handle override of IE settings
    try
        if (browser <> nil) then begin
            if (Supports(browser.DefaultInterface, IOleObject, OleObj)) then begin
                _webBrowserUI.Free();
                _webBrowserUI := TWebBrowserUIObject.Create();
                OleObj.SetClientSite(_webBrowserUI as IOleClientSite);
            end
            else begin
                _webBrowserUI := nil;
                raise Exception.Create('MsgList interface does not support IOleObject');
            end;
        end;
    except

    end;
end;

{---------------------------------------}
destructor TfIEMsgList.Destroy;
var
    i: integer;
begin
    try
        for i := _ClearingMsgCache.Count - 1 downto 0 do begin
            TJabberMessage(_ClearingMsgCache.Objects[i]).Free();
            _ClearingMsgCache.Delete(i);
        end;
        _ClearingMsgCache.Free();
        
        _queue.Free();
    except
    end;

    inherited;
end;

{---------------------------------------}
procedure TfIEMsgList.writeHTML(html: WideString);
begin
    if (_content = nil) then begin
        assert(_queue <> nil);
        _queue.Add(html);
        exit;
    end;

    // For some reason, the _content that is set
    // elsewhere is causing exceptions
    _content := _doc.all.item('content', 0) as IHTMLElement;
    _content.insertAdjacentHTML('beforeEnd', html);
end;

{---------------------------------------}
procedure TfIEMsgList.Invalidate();
begin
//    browser.Invalidate();
end;

{---------------------------------------}
procedure TfIEMsgList.CopyAll();
begin
    _doc.execCommand('SelectAll', false, varNull);
    _doc.execCommand('Copy', true, varNull);
    _doc.execCommand('Unselect', false, varNull);
end;

{---------------------------------------}
procedure TfIEMsgList.Copy();
begin
    _doc.execCommand('Copy', true, varNull);
end;

{---------------------------------------}
procedure TfIEMsgList.ScrollToBottom();
var
    tags: IHTMLElementCollection;
    last: IHTMLElement;
begin
    if (_win = nil) then exit;
    if (_ForceIgnoreScrollToBottom) then exit;
    

    // this is a slowness for large histories, I think, but it is the only
    // thing that seems to work, since we are now scrolling the _content
    // element, rather than the window, as Bill intended.
    tags := _content.children as IHTMLElementCollection;
    if (tags.length > 0) then begin
        last := tags.Item(tags.length - 1, 0) as IHTMLElement;
        last.ScrollIntoView(false);
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.ScrollToTop();
var
    tags: IHTMLElementCollection;
    first: IHTMLElement;
begin
    if (_win = nil) then exit;

    // this is a slowness for large histories, I think, but it is the only
    // thing that seems to work, since we are now scrolling the _content
    // element, rather than the window, as Bill intended.
    tags := _content.children as IHTMLElementCollection;
    if (tags.length > 0) then begin
        first := tags.Item(0, 0) as IHTMLElement;
        first.ScrollIntoView(false);
    end;
end;     

{---------------------------------------}
procedure TfIEMsgList.Clear();
begin
    try
        _ready := true;
        _home := 'res://' + URL_EscapeChars(Application.ExeName);
        _Clearing := true;
        browser.Navigate(_home + '/iemsglist');
    except
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.setContextMenu(popup: TTntPopupMenu);
begin
    _menu := popup;
end;

{---------------------------------------}
function TfIEMsgList.getHandle(): THandle;
begin
    Result := 0; //Browser.Handle;
end;

{---------------------------------------}
function TfIEMsgList.getObject(): TObject;
begin
    // Result := Browser;
    result := nil;
end;

{---------------------------------------}
function ProcessTag(parent: TXMLTag; n: TXMLNode): WideString;
var
    nodes: TXMLNodeList;
    i, j: integer;
    attrs: TAttrList;
    attr: TAttr;
    tag: TXMLTag;
    chunks: TWideStringList;
    nv : TWideStringList;
    started: boolean;
    str: WideString;
    tag_name: WideString;
    aname: WideString;
begin
    // See JEP-71 (http://www.jabber.org/jeps/jep-0071.html) for details.
    result := '';

    // any tag not in the good list should be deleted, but everything else
    // around it should stay.
    // opted to do own serialization for efficiency; didn't want to have to
    // make many passes over the same data.
    if (n.NodeType = xml_Tag) then begin
        tag := TXMLTag(n);
        tag_name := lowercase(tag.Name);

        if (ok_tags.IndexOf(tag_name) < 0) then
            exit;

        result := result + '<' + tag_name;

        nv := TWideStringList.Create();
        chunks := TWideStringList.Create();
        attrs := tag.Attributes;
        for i := 0 to attrs.Count - 1 do begin
            attr := TAttr(attrs[i]);
            aname := lowercase(attr.Name);
            if (aname = 'style') then begin
                // style attribute only allowed on style_tags.
                if (style_tags.IndexOf(tag_name) >= 0) then begin
                    //  remove any style properties that aren't in the allowed list
                    chunks.Clear();
                    split(attr.value, chunks, ';');
                    started := false;
                    for j := 0 to chunks.Count - 1 do begin
                        nv.Clear();
                        split(chunks[j], nv, ':');
                        if (nv.Count < 1) then
                            continue;
                        if (style_props.IndexOf(nv[0]) >= 0) then begin
                            if (not started) then begin
                                started := true;
                                result := result + ' style="';
                            end;
                            result := result + HTML_EscapeChars(chunks[j], false, true) + ';';
                        end;
                    end;
                    if (started) then
                        result := result + '"';
                end;
            end
            else if (tag_name = 'a') then begin
                if (aname = 'href') then
                    result := result + ' ' +
                        attr.Name + '="' + HTML_EscapeChars(attr.Value, false, true) + '"';
            end
            else if (tag_name = 'img') then begin
                if ((aname = 'alt') or
                    (aname = 'height') or
                    (aname = 'longdesc') or
                    (aname = 'src') or
                    (aname = 'width')) then begin
                    result := result + ' ' +
                        aname + '="' + HTML_EscapeChars(attr.Value, false, true) + '"';
                end;
            end
        end;
        nv.Free();
        chunks.Free();

        nodes := tag.Nodes;
        if (nodes.Count = 0) then
            result := result + '/>'
        else begin
            // iterate over all the children
            result := result + '>';
            for i := 0 to nodes.Count - 1 do
                result := result + ProcessTag(tag, TXMLNode(nodes[i]));
            result := result + '</' + tag.name + '>';
        end;
    end
    else if (n.NodeType = xml_CDATA) then begin
        // Check for URLs
        if ((parent = nil) or (parent.Name <> 'a')) then begin
            str := REGEX_URL.Replace(TXMLCData(n).XML,
                                     '<a href="$0">$0</a>', true);
            // Look for and replace &APOS; as HTML doesn't understand this escaping.
            str := StringReplace(str, '&apos;', '''', [rfReplaceAll]);
            result := result + ProcessIEEmoticons(str);
        end
        else
            result := result + TXMLCData(n).Data;
    end;
end;

{---------------------------------------}
function TfIEMsgList._checkLastNickForMsgGrouping(nick: widestring): boolean;
var
    tmsg: TJabberMessage;
begin
    Result := false;

    if (nick <> '') then begin
        tmsg := TJabberMessage.Create();
        if (tmsg <> nil) then begin
            tmsg.Nick := nick;
            Result := _checkLastNickForMsgGrouping(tmsg);
            tmsg.Free();
        end;
    end;
end;

{---------------------------------------}
function TfIEMsgList._checkLastNickForMsgGrouping(Msg: TJabberMessage): boolean;
begin
    if (Msg.Nick = _lastMsgNick) then begin
        Result := true;
    end
    else begin
        Result := false;
    end;
end;

{---------------------------------------}
function TfIEMsgList._getLineClass(nick: widestring): WideString;
var
    tmsg: TJabberMessage;
begin
    Result := 'line1';

    if (nick <> '') then begin;
        tmsg := TJabberMessage.Create();
        if (tmsg <> nil) then begin
            tmsg.Nick := nick;
            Result := _getLineClass(tmsg);
            tmsg.Free();
        end;
    end;
end;

{---------------------------------------}
function TfIEMsgList._getLineClass(Msg: TJabberMessage): WideString;
begin
    if (_checkLastNickForMsgGrouping(Msg)) then begin
        Result := _lastLineClass;
        exit;
    end;

    if (_lastLineClass = 'line1') then begin
        _lastLineClass := 'line2';
        Result := _lastLineClass;
    end
    else begin
        _lastLineClass := 'line1';
        Result := _lastLineClass;
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.DisplayMsg(Msg: TJabberMessage; AutoScroll: boolean = true);
var
    txt: WideString;
    body: TXmlTag;
    cleanXIM: TXmlTag;
    i: integer;
    nodes: TXMLNodeList;
    dv: WideString;
    t: TDateTime;
    id: WideString;
begin
    if (msg = nil) then exit;

    if (_Clearing) then begin
        _ClearingMsgCache.AddObject('', msg);
    end
    else begin
        try
            if (_displayDateSeparator) then begin
                t := msg.Time;
                if ((DateToStr(t) <> DateToStr(_lastTimeStamp)) and
                    (msg.Subject = '') and
                    (msg.Nick <> ''))then begin
                    txt := '<div class="date">' +
                           '<span>' +
                           DateToStr(t) +
                           '</span>' +
                           '</div>';

                    writeHTML(txt);
                    _lastTimeStamp := msg.Time;
                    txt := '';
                    _lastMsgNick := '';
                    if (_doMessageLimiting) then
                        Inc(_msgCount);
                end;
            end;
        except
        end;

        _clearOldMessages();

        if ((not Msg.Action) and
            (MainSession.Prefs.getBool('richtext_enabled'))) then begin
            // ignore HTML for actions.  it's harder than you think.
            body := Msg.Tag.QueryXPTag(xp_xhtml);

            if (body <> nil) then begin
                // Strip out font tags we wish to ignore
                cleanXIM := cleanXIMTag(body);
                if (cleanXIM <> nil) then begin
                    // if first node is a p tag, make it a span...
                    if ((cleanXIM.Nodes.Count > 0) and
                        (TXMLTag(cleanXIM.Nodes[0]).NodeType = xml_tag) and
                        (TXMLTag(cleanXIM.Nodes[0]).Name = 'p')) then
                        TXMLTag(cleanXIM.Nodes[0]).Name := 'span';

                    nodes := cleanXIM.nodes;
                    for i := 0 to nodes.Count - 1 do
                        txt := txt + ProcessTag(cleanXIM, TXMLNode(nodes[i]));
                end;
            end;
        end;

        if (txt = '') then begin
            txt := HTML_EscapeChars(Msg.Body, false, false);
            txt := _processUnicode(txt); //StringReplace() cannot handle
            // Make sure the spaces are preserved
            txt := StringReplace(txt, ' ', '&ensp;', [rfReplaceAll]);
            // Change CRLF to HTML equiv
            txt := REGEX_CRLF.Replace(txt, '<br />', true);
            // Detect URLs in text
            txt := REGEX_URL.Replace(txt, '<a href="$0">$0</a>', true);
        end;

        // build up a string, THEN call writeHTML, since IE is being "helpful" by
        // canonicalizing HTML as it gets inserted.
        id := _genElementID();
        dv := '<div id="' + id + '" class="' + _getLineClass(Msg) + '">';

        // Author Stamp
        if (Msg.Nick <> '') then begin
            // This is a normal message
            if (not _checkLastNickForMsgGrouping(Msg)) then begin
                if Msg.isMe then begin
                    // Our own msgs
                    dv := dv + '<span class="me">' + Msg.Nick + '</span>';
                end
                else begin
                    // Msgs from "others"
                    dv := dv + '<span class="other">' + Msg.Nick + '</span>';
                end;
            end;

        end
        else begin
            dv := dv + '<span class="svr">' + _('System Message') + '</span>';
        end;

        _lastMsgNick := Msg.Nick;

        // Wrap msg and time stamp for css
        dv := dv + '<div class="msgts">';

        // Timestamp
        if (MainSession.Prefs.getBool('timestamp')) then begin
            try
                dv := dv + '<span class="ts">' +
                    FormatDateTime(MainSession.Prefs.getString('timestamp_format'), Msg.Time) +
                    '</span>';
            except
                on EConvertError do begin
                    dv := dv + '<span class="ts">' +
                        FormatDateTime(MainSession.Prefs.getString('timestamp_format'),
                        Now()) + '</span>';
                end;
            end;
        end;

        // MSG Content
        if (Msg.Nick = '') then begin
            // Server generated msgs (mostly in TC Rooms)
            dv := dv + '<span class="svr">' + txt + '</span>';
        end
        else if not Msg.Action then begin
            if (_exeName <> '') then begin
                if (Msg.Priority = high) then begin
                    dv := dv +
                          '<img class="priorityimg" src="res://' +
                          _exeName +
                          '/GIF/HIGH_PRI" alt="' +
                          _('High Priority') +
                          '" />';
                end
                else if (Msg.Priority = low) then begin
                    dv := dv +
                          '<img class="priorityimg" src="res://' +
                          _exeName +
                          '/GIF/LOW_PRI" alt="' +
                          _('Low Priority') +
                          '" />';
                end;
            end;

            if (Msg.Highlight) then
                dv := dv + '<span class="alert"> ' + txt + '</span>'
            else
                dv := dv + '<span class="msg">' + txt + '</span>';
        end
        else begin
            // This is an action
            dv := dv + '<span class="action">&nbsp;*&nbsp;' + Msg.Nick + '&nbsp;' + txt + '</span>';
        end;

        // Close off msgts and line1/2 div tags
        dv := dv + '</div></div>';
        writeHTML(dv);

        if (_doc <> nil) then begin
            _lastelement := _doc.all.item(id, 0) as IHTMLElement;
        end
        else begin
            _lastelement := nil;
        end;

        if (_doMessageLimiting) then
            Inc(_msgCount);

        if (_bottom) then
            ScrollToBottom();
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.DisplayPresence(nick, txt: Widestring; timestamp: string);
var
    pt : integer;
    tags: IHTMLElementCollection;
    dv : IHTMLElement;
    sp : IHTMLElement;
    i : integer;
    htmlout: widestring;
begin
    pt := MainSession.Prefs.getInt('pres_tracking');
    if (pt = 2) then exit;

    if ((pt = 1) and (_content <> nil)) then begin
        // if previous is a presence, replace with this one.
        tags := _content.children as IHTMLElementCollection;
        if (tags.length > 0) then begin
            dv := tags.Item(tags.length - 1, 0) as IHTMLElement;
            tags := dv.children as IHTMLElementCollection;
            for i := 0 to tags.length - 1 do begin
                sp := tags.Item(i, 0) as IHTMLElement;
                if sp.className = 'pres' then begin
                    dv.outerHTML := '';
                    if (_doMessageLimiting) then
                        Dec(_msgCount);
                    break;
                end;
            end;
        end;
    end;

    htmlout := '<div class="' + _getLineClass(nick) + '">';
    if ((not _checkLastNickForMsgGrouping(nick)) and
        (nick <> '')) then begin
        // Must NOT be a "me" message
        htmlout := htmlout + '<span class="other">' + nick + '</span>';
    end;

    // Put presence Icon in with the presence message
    // How to get image from image list and not resource?
{    if (_exeName <> '') then begin
        htmlout := htmlout +
              '<img class="priorityimg" src="res://' +
              _exeName +
              '/GIF/HIGH_PRI"/>';
    end;    }

    if timestamp <> '' then begin
        htmlout := htmlout + '<div class="msgts"><span class="ts">' + timestamp + '</span><span class="pres">' + txt + '</span></div></div>';
    end
    else begin
        if (nick <> '') then begin
            htmlout := htmlout + '<div class="' + _getLineClass(nick) + '"><div class="msgts"><span class="pres">' + txt + '</span></div></div>';
        end
        else begin
            htmlout := htmlout + '<div class="' + _getLineClass(nick) + '"><span class="pres">' + txt + '</span></div>';
        end;
    end;

    writeHTML(htmlout);

    if (_bottom) then
        ScrollToBottom();

    if (_doMessageLimiting) then
        Inc(_msgCount);
end;

{---------------------------------------}
procedure TfIEMsgList.Save(fn: string);
var
    txt: widestring;
    elem: IHTMLElement;
    byteorder_marker: Word;
    fs: TFileStream;
begin
    fs := nil;

    // Save out the HTML to a file using widestring
    // This means that it is UTF-16
    if (browser = nil) then exit;

    elem := _doc.body.parentElement;
    if (elem = nil) then exit;

    try
        try
            fs := TFileStream.Create(fn, fmCreate);
            byteorder_marker := $FEFF; // Unicode marker for file.
            txt := elem.outerHTML;
            fs.WriteBuffer(byteorder_marker, sizeof(byteorder_marker));
            fs.WriteBuffer(txt[1], Length(txt)*sizeof(txt[1]));
        except

        end;
    finally
        fs.free;
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.populate(history: Widestring);
var
    txt: widestring;
    p: integer;
begin
    p := pos('-->', history);

    if ((p > 0) and
        (LeftStr(history, 4) = '<!--')) then begin
        txt := LeftStr(history, p - 1);
        txt := MidStr(txt, 5, Length(txt));
        try
            if (_doMessageLimiting) then begin
                _msgCount := StrToInt(txt);
            end;
        except
        end;
        history := MidStr(history, p + 3, Length(history));
    end;

    writeHTML(history);

    if (_doMessageLimiting) then begin
        _clearOldMessages();
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.setupPrefs();
begin
    with MainSession.Prefs do begin
        _stylesheet_name := getString('ie_css');
        _color_me := getInt('color_me');
        _color_other := getInt('color_other');
        _color_action := getInt('color_action');
        _color_server := getInt('color_server');
        _color_time := getInt('color_time');
        _color_bg := getInt('color_bg');
        _color_alt_bg := getInt('color_alt_bg');
        _color_date_bg := getInt('color_date_bg');
        _color_date := getInt('color_date');
        _font_name := getString('font_name');
        _font_size := IntToStr(getInt('font_size'));
        _font_bold := getBool('font_bold');
        _font_italic := getBool('font_italic');
        _font_underline := getBool('font_underline');
        _font_color := getInt('font_color');
    end;
end;

{---------------------------------------}
function TfIEMsgList.empty(): boolean;
begin
    if (_content = nil) then
        Result := true
    else
        Result := (_content.innerHTML = '');
end;

{---------------------------------------}
function TfIEMsgList.getHistory(): Widestring;
begin
    Result := _getHistory();
end;

{---------------------------------------}
function TfIEMsgList._getHistory(includeCount: boolean): WideString;
begin
    Result := '';
    if (_content = nil) then
        Result := ''
    else begin
        if (includeCount) then
            Result := '<!--' + IntToStr(_msgCount) + '-->';
        Result := Result + _content.innerHTML;
    end;
end;


{---------------------------------------}
procedure TfIEMsgList.setDragOver(event: TDragOverEvent);
begin
    _dragOver := event;
end;

{---------------------------------------}
procedure TfIEMsgList.setDragDrop(event: TDragDropEvent);
begin
    _dragDrop := event;
end;

{---------------------------------------}
procedure TfIEMsgList.ChangeStylesheet(resname: WideString);
begin
    _stylesheet_name := resname;
    ResetStylesheet();
end;

{---------------------------------------}
procedure TfIEMsgList.ResetStylesheet();
    function replaceString(source, key, newtxt: Widestring): widestring;
    var
        offset: integer;
    begin
        if ((source = '') or
            (key = '')) then
            exit;

        Result := '';
        offset := Pos(key, source);
        while (offset > 0) do begin
            Result := Result + LeftStr(source, offset - 1);
            Result := Result + newtxt;
            source := MidStr(source, offset + Length(key), Length(source));
            offset := Pos(key, source);
        end;
        Result := Result + source;
    end;
var
    stream: TResourceStream;
    tmp: TWideStringList;
    css: Widestring;
    i: integer;
begin
    try
        // Get CSS template from resouce
        stream := TResourceStream.Create(HInstance, _stylesheet_name, 'CSS');

        tmp := TWideStringList.Create;
        tmp.LoadFromStream(stream);
        css := '';
        for i := 0 to tmp.Count - 1 do
            css := css + tmp.Strings[i];

        tmp.Clear;
        tmp.Free;
        stream.Free(); 

        // Place colors in CSS
        if (css <> '') then begin
            css := replaceString(css, '/*font_name*/', _font_name);
            css := replaceString(css, '/*font_size*/', _font_size + 'pt');
            if (_font_bold) then begin
                css := replaceString(css, '/*font_weight*/', 'bold');
            end
            else begin
                css := replaceString(css, '/*font_weight*/', 'normal');
            end;
            if (_font_italic) then begin
                css := replaceString(css, '/*font_style*/', 'italic');
            end
            else begin
                css := replaceString(css, '/*font_style*/', 'normal');
            end;
            if (_font_underline) then begin
                css := replaceString(css, '/*text_decoration*/', 'underline');
            end
            else begin
                css := replaceString(css, '/*text_decoration*/', 'none');
            end; 
            css := replaceString(css, '/*font_color*/', HTMLColor(_font_color));
            css := replaceString(css, '/*color_bg*/', HTMLColor(_color_bg));
            css := replaceString(css, '/*color_alt_bg*/', HTMLColor(_color_alt_bg));
            css := replaceString(css, '/*color_date_bg*/', HTMLColor(_color_date_bg));
            css := replaceString(css, '/*color_date*/', HTMLColor(_color_date));
            css := replaceString(css, '/*color_me*/', HTMLColor(_color_me));
            css := replaceString(css, '/*color_other*/', HTMLColor(_color_other));
            css := replaceString(css, '/*color_time*/', HTMLColor(_color_time));
            css := replaceString(css, '/*color_action*/', HTMLColor(_color_action));
            css := replaceString(css, '/*color_server*/', HTMLColor(_color_server));
        end;

        // put CSS into page
        if ((css <> '') and
            (_doc <> nil)) then begin
            _style := _doc.createStyleSheet('', 0);
            _style.cssText := css;
            _style.disabled := false;
        end;
    except
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.onScroll(Sender: TObject);
begin
    if _content2 = nil then
        _bottom := true
    else
    _bottom :=
        ((_content2.scrollTop + _content2.clientHeight) >= _content2.scrollHeight);
end;

{---------------------------------------}
procedure TfIEMsgList.onResize(Sender: TObject);
begin
//    if (_bottom) then
//         ScrollToBottom();
end;

{---------------------------------------}
function TfIEMsgList.onContextMenu(Sender: TObject): WordBool;
begin
    if (_menu <> nil) then
    begin
        _menu.Popup(_win.event.screenX, _win.event.screeny);
    end;
    result := false;
end;

{---------------------------------------}
function TfIEMsgList.onKeyPress(Sender: TObject; const pEvtObj: IHTMLEventObj): WordBool;
var
    bc: TfrmBaseChat;
    key: integer;
begin
    // If typing starts on the MsgList, then bump it to the outgoing
    // text box.
    bc := TfrmBaseChat(_base);
    if (not bc.MsgOut.Enabled) then exit;

    if (not bc.Visible) then exit;

    key := pEvtObj.keyCode;

    if (key = 22) then begin
        // paste, Ctrl-V
        if (bc.MsgOut.Visible and bc.MsgOut.Enabled) then begin
            try
                bc.MsgOut.PasteFromClipboard();
                bc.MsgOut.SetFocus();
            except
                // To handle Cannot focus exception
            end;
        end;
    end
    else if ((MainSession.Prefs.getBool('esc_close')) and (key = 27)) then begin
        if (Self.Parent <> nil) then begin
            if (Self.Parent.Parent <> nil) then begin
                SendMessage(Self.Parent.Parent.Handle, WM_CLOSE, 0, 0);
            end;
        end;
    end
    else if (key < 32) then begin
        // Not a "printable" key
        try
            bc.MsgOut.SetFocus();
        except
            // To handle Cannot focus exception
        end;
    end
    else if (bc.pnlInput.Visible) then begin
        if (bc.MsgOut.Visible and bc.MsgOut.Enabled and not bc.MsgOut.ReadOnly) then begin
            try
                bc.MsgOut.WideSelText := WideChar(Key);
                bc.MsgOut.SetFocus();
            except
                // To handle Cannot focus exception
            end;
        end;
    end;
    pEvtObj.returnValue := false;
    // This shouldn't be needed, but the TWebbrowser control takes back focus.
    // You would think that the SetFocus() calls above wouldn't be necessary then
    // but for some reason the Post doesn't work if they aren't called?
    PostMessage(bc.Handle, WM_SETFOCUS, 0, 0);
    Result := false;
end;

{---------------------------------------}
function TfIEMsgList.onDrop(Sender: TObject): WordBool;
begin
    _dragDrop(sender, browser, _win.event.x, _win.event.y);
    result := false;
end;

{---------------------------------------}
function TfIEMsgList.onDragOver(Sender: TObject): WordBool;
var
    accept: boolean;
begin
    accept := true;
    _dragOver(sender, browser, _win.event.x, _win.event.y, dsDragMove, accept);
    result := accept;
end;

{---------------------------------------}
procedure TfIEMsgList.browserDocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
    i: integer;
begin
    inherited;
    try
        _Clearing := false;

        if ((not _ready) or (browser.Document = nil)) then
            exit;

        _ready := false;
        _doc := browser.Document as IHTMLDocument2;

        ResetStylesheet();


        _content := _doc.all.item('content', 0) as IHTMLElement;
        _content2 := _content as IHTMLElement2;
        _body := _doc.body;
        _bottom := true;

        _win := _doc.parentWindow;
        if (_we <> nil) then
            _we.Free();
        if (_we2 <> nil) then
            _we2.Free();

        _we := TMSHTMLHTMLElementEvents.Create(self);
        _we.Connect(_content);
        _we.onscroll   := onscroll;
        _we.onresize   := onresize;
        _we.ondrop     := ondrop;
        _we.ondragover := ondragover;

        _we2 := TMSHTMLHTMLElementEvents2.Create(self);
        _we2.Connect(_content);
        _we2.onkeypress := onkeypress;

        if (_de <> nil) then
            _de.Free();
        _de := TMSHTMLHTMLDocumentEvents.Create(self);
        _de.Connect(_doc);
        _de.oncontextmenu := onContextMenu;

        assert (_queue <> nil);
        for i := 0 to _queue.Count - 1 do begin
            writeHTML(_queue.Strings[i]);
        end;
        _queue.Clear();
        if (_title <> '') then begin
            setTitle(_title);
        end;

        for i := 0 to _ClearingMsgCache.Count - 1 do begin
            DisplayMsg(TJabberMessage(_ClearingMsgCache.Objects[i]));
        end;
        for i := _ClearingMsgCache.Count - 1 downto 0 do begin
            TJabberMessage(_ClearingMsgCache.Objects[i]);
            _ClearingMsgCache.Delete(i);
        end;                                                

        ScrollToBottom();
    except
        // When Undocking, the browser.Document becomes bad and
        // throws an exception.  Call Clear() to force a re-navigation
        // to reset browser.Document.
        Clear();
    end;
end;

{---------------------------------------}
procedure TfIEMsgList.browserBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
    u: string;
begin
    u := URL;
    if (u <> _home + '/iemsglist') then begin
        ShellExecute(Application.Handle, 'open', pAnsiChar(u), '', '', SW_SHOW);
        cancel := true;
    end;
    inherited;
end;

{---------------------------------------}
procedure TfIEMsgList.setTitle(title: Widestring);
//var
//    splash : IHTMLElement;
begin
//    if (_doc = nil) then begin
//        _title := title;
//        exit;
//    end;
//
//    splash :=  _doc.all.item('splash', 0) as IHTMLElement;
//    if (splash = nil) then exit;
//
//    splash.innerText := _title;
end;

{---------------------------------------}
procedure TfIEMsgList.ready();
begin
//    _ready := true;
//    Clear();
end;

{---------------------------------------}
procedure TfIEMsgList.refresh();
begin
    _queue.Add(_getHistory(false));
    Clear();
end;

{---------------------------------------}
procedure TfIEMsgList.browserDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
    _dragDrop(sender, source, x, y);
//  inherited;
end;

{---------------------------------------}
procedure TfIEMsgList.browserDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    _dragOver(sender, source, x, y, state, accept);
//   inherited;
end;

{---------------------------------------}
procedure TfIEMsgList.DisplayComposing(msg: Widestring);
var
    outstring: Widestring;
    id: widestring;
begin
    HideComposing();
    _composing := 1;
    id := _genElementID();
    outstring := '<div id="' +
                 id +
                 '"><br /><span class="composing">' +
                 HTML_EscapeChars(msg, false, false) +
                 '</span><br /></div>';
    writeHTML(outstring);
    _composingelement := _doc.all.item(id, 0) as IHTMLElement;

    ScrollToBottom();
end;

{---------------------------------------}
procedure TfIEMsgList.HideComposing();
begin
    if (_composing = -1) then exit;

    if (_composingelement <> nil) then begin
        _composingelement.outerHTML := '';
        _composingelement := nil;
    end;

    _composing := -1;
end;

{---------------------------------------}
function TfIEMsgList.isComposing(): boolean;
begin
    Result := (_composing >= 0);
end;

{---------------------------------------}
function TfIEMsgList._genElementID(): WideString;
begin
    Result := 'msg_id_' + IntToStr(_idCount);
    Inc(_idCount);
end;

{---------------------------------------}
procedure TfIEMsgList.print(ShowDialog: boolean);
var
   vIn, vOut: OleVariant;
begin
    if (browser = nil) then exit;

    if (ShowDialog) then begin
        browser.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER, vIn, vOut);
    end
    else begin
        browser.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_DONTPROMPTUSER, vIn, vOut);
    end;
end;


{---------------------------------------}
procedure TfIEMsgList._clearOldMessages();
var
    children: IHTMLElementCollection;
    elem: IHTMLElement;
begin
    if ((_doMessageLimiting) and
        (_msgCount >= _maxMsgCountHigh) and
        (_content <> nil)) then begin
        while (_msgCount >= _maxMsgCountLow) do begin
            children := _content.children as IHTMLElementCollection;
            if (children <> nil) then begin
                elem := children.item(0, 0) as IHTMLElement;
                if (elem <> nil) then begin
                    elem.outerHTML := '';
                    Dec(_msgCount);
                end;
            end;
        end;
    end;
end;

{---------------------------------------}
function TfIEMsgList._processUnicode(txt: widestring): WideString;
var
    i: integer;
begin
    Result := '';
    for i := 1 to Length(txt) do begin
        if (Ord(txt[i]) > 126) then begin
            // This looks to be a non-ascii char so represent in HTML escaped notation
            try
                Result := Result + '&#' + IntToStr(Ord(txt[i])) + ';';
            except
                exit;
            end;
        end
        else begin
            Result := Result + txt[i];
        end;
    end;
end;

initialization
    TP_GlobalIgnoreClassProperty(TWebBrowser, 'StatusText');

    xp_xhtml := TXPLite.Create('/message/html/body');

    ok_tags := THashedStringList.Create();
    ok_tags.Add('blockquote');
    ok_tags.Add('br');
    ok_tags.Add('cite');
    ok_tags.Add('code');
    ok_tags.Add('div');
    ok_tags.Add('em');
    ok_tags.Add('h1');
    ok_tags.Add('h2');
    ok_tags.Add('h3');
    ok_tags.Add('p');
    ok_tags.Add('pre');
    ok_tags.Add('q');
    ok_tags.Add('span');
    ok_tags.Add('strong');
    ok_tags.Add('a');
    ok_tags.Add('ol');
    ok_tags.Add('ul');
    ok_tags.Add('li');
    ok_tags.Add('img');

    style_tags := THashedStringList.Create();
    style_tags.Add('blockquote');
    style_tags.Add('body');
    style_tags.Add('div');
    style_tags.Add('h1');
    style_tags.Add('h2');
    style_tags.Add('h3');
    style_tags.Add('li');
    style_tags.Add('ol');
    style_tags.Add('p');
    style_tags.Add('pre');
    style_tags.Add('q');
    style_tags.Add('span');
    style_tags.Add('ul');

    style_props := THashedStringList.Create();
    style_props.Add('color');
    style_props.Add('font-family');
    style_props.Add('font-size');
    style_props.Add('font-style');
    style_props.Add('font-weight');
    style_props.Add('text-align');
    style_props.Add('text-decoration');

finalization
    xp_xhtml.Free();
    ok_tags.Free();
    style_tags.Free();
    style_props.Free();


end.


