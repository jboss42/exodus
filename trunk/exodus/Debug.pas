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
    Dockable, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus;

type
  TfrmDebug = class(TfrmDockable)
    Panel1: TPanel;
    chkDebugWrap: TCheckBox;
    Panel2: TPanel;
    MsgDebug: TRichEdit;
    MemoSend: TMemo;
    Splitter1: TSplitter;
    Panel3: TPanel;
    btnSendRaw: TButton;
    btnClearDebug: TButton;
    PopupMenu1: TPopupMenu;
    popMsg: TMenuItem;
    popIQGet: TMenuItem;
    popIQSet: TMenuItem;
    popPres: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure chkDebugWrapClick(Sender: TObject);
    procedure btnClearDebugClick(Sender: TObject);
    procedure btnSendRawClick(Sender: TObject);
    procedure popMsgClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MemoSendKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure DebugCallback(send: boolean; data: string);
  end;

    procedure ShowDebugForm();
    procedure DockDebugForm();
    procedure FloatDebugForm();
    procedure CloseDebugForm();
    procedure DebugMessage(txt: string);

const
    DEBUG_LIMIT = 500;


implementation

{$R *.dfm}
uses
    Signals, Session, Jabber1;

var
    frmDebug: TfrmDebug;


{---------------------------------------}
procedure ShowDebugForm();
begin
    // Singleton factory
    if ( frmDebug = nil ) then
        frmDebug := TfrmDebug.Create(nil);
    if (not frmDebug.Visible) then
        frmDebug.ShowDefault();

    if (frmDebug.Docked) then
        frmExodus.Tabs.ActivePage := frmDebug.TabSheet
    else
        frmDebug.Show();
end;

{---------------------------------------}
procedure DockDebugForm();
begin
    if ((frmDebug <> nil) and (not frmDebug.Docked)) then begin
        frmDebug.DockForm;
        frmDebug.Show;
        end;
end;

{---------------------------------------}
procedure FloatDebugForm();
begin
    // make sure debug window is hidden and undocked
    if ((frmDebug <> nil) and (frmDebug.Docked)) then begin
        frmDebug.Hide;
        frmDebug.FloatForm;
        end;
end;

{---------------------------------------}
procedure CloseDebugForm();
begin
    if ( frmDebug = nil ) then exit;
    frmDebug.Close();
end;

{---------------------------------------}
procedure DebugMessage(txt: string);
begin
    if (frmDebug = nil) then exit;
    if (not frmDebug.Visible) then exit;

    // add some text to the debug log
    with frmDebug.MsgDebug do begin
        SelStart := GetTextLen;
        SelLength := 0;
        SelAttributes.Color := clRed;
        SelText := txt + ''#13#10;
        SelAttributes.Color := clBlack;
        end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmDebug.FormCreate(Sender: TObject);
begin
    // make sure the output is showing..
    inherited;
    MainSession.Stream.RegisterDataCallback(DebugCallback);
end;


{---------------------------------------}
procedure TfrmDebug.DebugCallback(send: boolean; data: string);
var
    l, d: integer;
begin
    if (frmDebug = nil) then exit;
    if (not frmDebug.Visible) then exit;

    if (MsgDebug.Lines.Count >= DEBUG_LIMIT) then begin
        d := (MsgDebug.Lines.Count - DEBUG_LIMIT) + 1;
        for l := 1 to d do
            MsgDebug.Lines.Delete(0);
        end;

    if send then with MsgDebug do begin
        SelStart := GetTextLen;
        SelLength := 0;
        SelAttributes.Color := clBlue;
        SelText := 'SENT: ' + data + #13#10;
        SelAttributes.Color := clBlack;
        end
    else with MsgDebug do begin
        SelStart := GetTextLen;
        SelLength := 0;
        SelAttributes.Color := clGreen;
        SelText := 'RECV: ' + data + #13#10;
        SelAttributes.Color := clBlack;
        end;

    with MsgDebug do begin
        {
        GetScrollRange(Handle, SB_VERT, min, max);
        thumb := GetScrollPos(Handle, SB_VERT);
        if ((thumb >= max) or ((thumb = 0) and ((max - Height) < 20))) then begin
            SelStart := GetTextLen;
            Perform(EM_SCROLLCARET, 0, 0);
            end;
        }
        SelStart := GetTextLen;
        Perform(EM_SCROLLCARET, 0, 0);
        end;
end;

{---------------------------------------}
procedure TfrmDebug.chkDebugWrapClick(Sender: TObject);
begin
    MsgDebug.WordWrap := chkDebugWrap.Checked;
end;

{---------------------------------------}
procedure TfrmDebug.btnClearDebugClick(Sender: TObject);
begin
    MsgDebug.Lines.Clear;
end;

{---------------------------------------}
procedure TfrmDebug.btnSendRawClick(Sender: TObject);
var
    cmd: string;
    sig: TSignal;
    i, s: integer;
    msg: string;
    l: TSignalListener;
begin
    // Send the text in the MsgSend memo box
    cmd := MemoSend.Lines.Text;
    if (cmd[1] = '/') then begin
        // we are giving some kind of interactive debugger cmd
        if (cmd = '/dispcount') then
            DebugMessage('Dispatcher listener count: ' + IntToStr(MainSession.Dispatcher.TotalCount));
        if (cmd = '/dispdump') then begin
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
    Action := caFree;
    //Action := caHide;
    MainSession.Stream.UnregisterDataCallback(DebugCallback);
    inherited;
    frmDebug := nil;
end;

procedure TfrmDebug.MemoSendKeyPress(Sender: TObject; var Key: Char);
begin
      if ( (Key = #10) and (HiWord(GetKeyState(VK_CONTROL)) <> 0)) then begin
        btnSendRawClick(Self);
        Key := #0;
        end
    else
        inherited;

end;

end.
