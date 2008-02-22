unit Debug;
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
    Dockable, XMLTag,
    XMLParser,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, RichEdit2, ExRichEdit,
    Buttons, TntStdCtrls, TntMenus, ToolWin, DebugManager;

type
  TfrmDebug = class(TfrmDockable, IDebugLogger)
    Panel2: TPanel;
    Splitter1: TSplitter;
    PopupMenu1: TTntPopupMenu;
    MsgDebug: TExRichEdit;
    FindDialog1: TFindDialog;
    MemoSend: TExRichEdit;
    popPres: TTntMenuItem;
    popIQSet: TTntMenuItem;
    popIQGet: TTntMenuItem;
    popMsg: TTntMenuItem;
    N1: TTntMenuItem;
    WordWrap1: TTntMenuItem;
    Find1: TTntMenuItem;
    SendXML1: TTntMenuItem;
    Clear1: TTntMenuItem;
    pnlTop: TPanel;
    lblJID: TTntLabel;
    lblLabel: TTntLabel;
    procedure FormCreate(Sender: TObject);
    procedure chkDebugWrapClick(Sender: TObject);
    procedure btnClearDebugClick(Sender: TObject);
    procedure btnSendRawClick(Sender: TObject);
    procedure popMsgClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure WordWrap1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure lblJIDClick(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure MsgDebugKeyPress(Sender: TObject; var Key: Char);
    procedure MemoSendKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    _scb: integer;

  protected
    procedure SessionCallback(event: string; tag: TXMLTag);
  published
    class procedure AutoOpenFactory(autoOpenInfo: TXMLTag); override;
    function GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;override;
  public
    procedure AddWideText(txt: WideString; txt_color: TColor);

    // IDebugLogger
    procedure DebugStatement(msg: Widestring; dt: TDateTime);
    procedure DataSent(xml: TXMLTag; data: Widestring; dt: TDateTime);
    procedure DataRecv(xml: TXMLTag; data: Widestring; dt: TDateTime);
  end;

procedure ShowDebugForm(bringToFront: boolean=true);
procedure CloseDebugForm();
procedure DebugMessage(txt: Widestring);

function isDebugShowing(): boolean;

const
    DEBUG_LIMIT = 500;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    WideStrUtils,
    RosterImages,
    DisplayName,
    MsgDisplay, GnuGetText, Signals, Session, JabberUtils, ExUtils,  Jabber1;


var
    frmDebug: TfrmDebug;


{---------------------------------------}
procedure ShowDebugForm(bringToFront: boolean);
begin
    // Singleton factory
    if ( frmDebug = nil ) then
        frmDebug := TfrmDebug.Create(Application);
    frmDebug.ShowDefault(bringToFront);
    frmExodus.mnuFile_ShowDebugXML.Checked := true;
end;

{---------------------------------------}
function isDebugShowing(): boolean;
begin
    Result := (frmDebug <> nil);
end;

{---------------------------------------}
procedure CloseDebugForm();
begin
    if ( frmDebug = nil ) then exit;
    frmDebug.Close();
end;

{---------------------------------------}
procedure DebugMessage(txt: Widestring);
begin
    if (frmDebug = nil) then exit;
    if (not frmDebug.Visible) then exit;

    frmDebug.AddWideText(txt, clRed);
end;

class procedure TfrmDebug.AutoOpenFactory(autoOpenInfo: TXMLTag);
begin
    ShowDebugForm(false);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}

procedure TfrmDebug.FormCreate(Sender: TObject);
begin
    // make sure the output is showing..
    inherited;

    setUID('dbgwindow');

    dbgManager.AddDebugger('dbgwindow', Self);

    ImageIndex := RosterTreeImages.Find('filter');

    lblJID.Left := lblLabel.Left + lblLabel.Width + 5;
    lblJID.Font.Color := clBlue;
    lblJID.Font.Style := [fsUnderline];

    _scb := MainSession.RegisterCallback(SessionCallback, '/session');

    if MainSession.Active then begin
        lblJID.Caption := DisplayName.getDisplayNameCache().getDisplayName(MainSession.Profile.getJabberID()) + ' <' + MainSession.Profile.getJabberID().getDisplayFull() + '>';
    end
    else begin
        lblJID.Caption := _('Disconnected');
    end;

    _windowType := 'debug';
end;

function TfrmDebug.GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;
begin
    if (event = 'shutdown') then begin
        Result := TXMLtag.Create(Self.ClassName);
        useProfile := false;
    end
    else Result := inherited GetAutoOpenInfo(event, useProfile);
end;

{---------------------------------------}
procedure TfrmDebug.AddWideText(txt: WideString; txt_color: TColor);
var
    time: string;
    fvl: integer;
    at_bottom, is_scrolling: boolean;
begin
    fvl := MsgDebug.FirstVisibleLine;
    at_bottom := MsgDebug.atBottom;
    is_scrolling := MsgDebug.isScrolling;
    DateTimeToString(time, 'yyyy-mm-dd hh:mm:ss.zzz', Now());
    with MsgDebug do begin
        SelStart := GetTextLen;
        SelLength := 0;
        SelAttributes.Color := txt_Color;
        WideSelText := '[' + time + ']  ' + txt + ''#13#10;
    end;

    // AutoScroll the window
    if ((at_bottom) and (not is_scrolling)) then begin
        MsgDebug.ScrollToBottom();
    end
    else begin
        MsgDebug.Line := fvl;
    end;

end;

function getObfuscatedData(event : String; tag : TXMLTag; data : WideString) : WideString;
const
    PASSWORD_NAME : WideString = 'password'; //don't localize
    PASSWORD_TAG  : string = '<password>';
var
    ptag        : TXMLTag;
    ctags       : TXMLTagList;
    xmlParser   : TXMLTagParser;
begin
    Result := data;
    if (((event = '/data/send') or (event = '/data/recv')) and
        (data <> '') and (AnsiPos(PASSWORD_TAG, data) <> 0)) then begin
        //attempt ot build xml tag from data, so we can manipluate it...
        xmlParser := TXMLTagParser.Create();
        try
            xmlParser.ParseString(data, '');
            ptag := xmlParser.popTag;
            //get pass element
            ctags := ptag.QueryRecursiveTags(PASSWORD_NAME, true);
            if ((ctags.Count > 0) and (ctags[0].Data <> ''))then begin
                ctags[0].ClearCData();
                ctags[0].AddCData('*******');
            end;
            Result := ptag.XML;
            ptag.Free();
        finally
            xmlParser.Free();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmDebug.chkDebugWrapClick(Sender: TObject);
begin
end;

{---------------------------------------}
procedure TfrmDebug.btnClearDebugClick(Sender: TObject);
begin
end;

{---------------------------------------}
procedure TfrmDebug.btnSendRawClick(Sender: TObject);
var
    cmd: WideString;
    sig: TSignal;
    i, s: integer;
    msg: WideString;
    l: TSignalListener;
begin
    if (not MainSession.Active) then exit;

    // Send the text in the MsgSend memo box
    cmd := getInputText(MemoSend);
    // cmd := Trim(MemoSend.Lines.Text);
    if (cmd = '') then exit;
    if (cmd[1] = '/') then begin
        // we are giving some kind of interactive debugger cmd
        if (cmd ='/help') then
            DebugMessage('/dispcount'#13#10'/dispdump'#13#10'/args')
        else if (cmd = '/args') then begin
            for i := 0 to ParamCount do
                DebugMessage(ParamStr(i))
        end
        else if (cmd = '/dispcount') then
            DebugMessage('Dispatcher listener count: ' + IntToStr(MainSession.Dispatcher.TotalCount))
        else if (cmd = '/dispdump') then begin
            // dump out all signals
            with MainSession.Dispatcher do begin
                for s := 0 to Count - 1 do begin
                    sig := TSignal(Objects[s]);
                    DebugMessage('SIGNAL: ' + Strings[s] + ' of class: ' + sig.ClassName);
                    DebugMessage('-----------------------------------');
                    for i := 0 to sig.Count - 1 do begin
                        l := TSignalListener(sig.Objects[i]);
                        msg := 'LID: ' + IntToStr(l.cb_id) + ', ';
                        msg := msg + sig.Strings[i] + ', ';
                        msg := msg + l.classname + ', ';
                        msg := msg + l.methodname;
                        DebugMessage(msg);
                    end;
                    DebugMessage(''#13#10);
                end;
            end;
        end;
    end
    else
        MainSession.Stream.Send(cmd);
end;

{---------------------------------------}
procedure TfrmDebug.popMsgClick(Sender: TObject);
var
    id: string;
begin
    // setup an XML fragment
    id := MainSession.generateID;
    with MemoSend.Lines do begin
        Clear;
        if Sender = popMsg then
            Add('<message to="" id="' + id + '"><body></body></message>')
        else if Sender = popIQGet then
            Add('<iq type="get" to="" id="' + id + '"><query xmlns=""></query></iq>')
        else if Sender = popIQSet then
            Add('<iq type="set" to="" id="' + id + '"><query xmlns=""></query></iq>')
        else if Sender = popPres then
            Add('<presence to="" id="' + id + '"/>');
    end;
end;

{---------------------------------------}
procedure TfrmDebug.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    dbgManager.RemoveDebugger('dbgwindow');

    Action := caFree;

    if (MainSession <> nil) then begin
        MainSession.UnregisterCallback(_scb);
    end;

    frmDebug := nil;

    inherited;
    frmExodus.mnuFile_ShowDebugXML.Checked := false;

end;

{---------------------------------------}
procedure TfrmDebug.btnCloseClick(Sender: TObject);
begin
    inherited;
    Self.Close;
end;

{---------------------------------------}
procedure TfrmDebug.WordWrap1Click(Sender: TObject);
begin
  inherited;
    WordWrap1.Checked := not WordWrap1.Checked;
    MsgDebug.WordWrap := WordWrap1.Checked;
end;

{---------------------------------------}
procedure TfrmDebug.Clear1Click(Sender: TObject);
begin
  inherited;
    MsgDebug.Lines.Clear;
end;

{---------------------------------------}
procedure TfrmDebug.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/authenticated') then begin
        lblJID.Caption := DisplayName.getDisplayNameCache().getDisplayName(MainSession.Profile.getJabberID()) + ' <' + MainSession.Profile.getJabberID().getDisplayFull() + '>';
    end
    else if (event = '/session/disconnected') then
        lblJID.Caption := _('Disconnected');
end;

{---------------------------------------}
procedure TfrmDebug.lblJIDClick(Sender: TObject);
var
    cp: TPoint;
begin
  inherited;
    GetCursorPos(cp);
    popupMenu1.popup(cp.x, cp.y);
end;

{---------------------------------------}
procedure TfrmDebug.Find1Click(Sender: TObject);
begin
  inherited;
    FindDialog1.Execute();
end;

{---------------------------------------}
procedure TfrmDebug.FindDialog1Find(Sender: TObject);
var
    FoundAt: LongInt;
    StartPos: Integer;
begin
  inherited;
    { begin the search after the current selection if there is one }
    { otherwise, begin at the start of the text }
    with MsgDebug do begin
        if SelLength <> 0 then
          StartPos := SelStart + SelLength
        else
          StartPos := 0;

        FoundAt := FindText(FindDialog1.FindText, StartPos, -1, [stMatchCase]);
        if FoundAt <> -1 then begin
            SetFocus;
            SelStart := FoundAt;
            SelLength := Length(FindDialog1.FindText);
        end
        else if (StartPos > 0) then begin
            Beep();
            SelLength := 0;
            FindDialog1Find(Self);
        end
        else
            Beep();
    end;
end;

{---------------------------------------}
procedure TfrmDebug.MsgDebugKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
    Key := Chr(0);
end;

{---------------------------------------}
procedure TfrmDebug.MemoSendKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    prefstag: TXMLTag;
begin
  inherited;
    if (Key = 0) then exit;

    // handle Ctrl-Tab to switch tabs
    if ((Key = VK_TAB) and (ssCtrl in Shift) and (self.Docked))then begin
        GetDockManager().SelectNext(not (ssShift in Shift));
        Key := 0;
    end

    // handle Ctrl-ENTER and ENTER to send msgs
    else if ((Key = VK_RETURN) and (Shift = [ssCtrl])) then begin
        Key := 0;
        btnSendRawClick(Self);
    end

    // magic debug key sequence Ctrl-Shift-P to dump the Prefs XML to debug.
    else if ((chr(Key) = 'P') and  (Shift = [ssCtrl, ssShift])) then begin
        prefstag := nil;
        MainSession.Prefs.getRoot('', prefstag);
        if (prefstag <> nil) then begin
            DebugMsg(prefstag.XML);
        end;
        prefstag.Free();
    end;
end;

{---------------------------------------}
procedure TfrmDebug.DebugStatement(msg: Widestring; dt: TDateTime);
begin
    AddWideText(msg, clRed);
end;

{---------------------------------------}
procedure TfrmDebug.DataSent(xml: TXMLTag; data: Widestring; dt: TDateTime);
var
    tstr: Widestring;
    l, d: integer;
begin
    if (frmDebug = nil) then exit;
    if (not frmDebug.Visible) then exit;

    if (MsgDebug.Lines.Count >= DEBUG_LIMIT) then begin
        d := (MsgDebug.Lines.Count - DEBUG_LIMIT) + 1;
        for l := 1 to d do
            MsgDebug.Lines.Delete(0);
    end;

    tstr := getObfuscatedData('/data/send', xml, data);
    AddWideText('SENT: ' + tstr, clBlue);
end;

{---------------------------------------}
procedure TfrmDebug.DataRecv(xml: TXMLTag; data: Widestring; dt: TDateTime);
var
    tstr: Widestring;
    l, d: integer;
begin
    if (frmDebug = nil) then exit;
    if (not frmDebug.Visible) then exit;

    if (MsgDebug.Lines.Count >= DEBUG_LIMIT) then begin
        d := (MsgDebug.Lines.Count - DEBUG_LIMIT) + 1;
        for l := 1 to d do
            MsgDebug.Lines.Delete(0);
    end;

    tstr := getObfuscatedData('/data/recv', xml, data);
    AddWideText('RECV: ' + tstr, clGreen);
end;

initialization
    Classes.RegisterClass(TfrmDebug);
end.
