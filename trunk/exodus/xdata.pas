unit xdata;
{
    Copyright 2002, Peter Millard

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
    XMLTag,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, buttonFrame, StdCtrls, ComCtrls, ExtCtrls, TntStdCtrls;

type
  TfrmXData = class(TForm)
    frameButtons1: TframeButtons;
    box: TScrollBox;
    insBevel: TBevel;
    lblIns: TTntLabel;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure Cancel();
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    packet: string;
    ns: string;
    to_jid: string;
    _type: string;
    _thread: WideString;
    _title: WideString;
    _responded: boolean;
    _valid: boolean;

    procedure getResponseTag(var m, x: TXMLTag);
  public
    { Public declarations }
    procedure render(tag: TXMLTag);

    property isValid: boolean read _valid;
  end;

var
  frmXData: TfrmXData;

function  showXDataEx(tag: TXMLTag): boolean;
procedure showXData(tag: TXMLTag);

implementation

{$R *.dfm}
uses
    GnuGetText, JabberConst, Session, ExUtils, StrUtils, fGeneric, IQ, Math;
const
    sAllRequired = 'All required fields must be filled out';
    sFormFrom = 'Form from %s';
    sClose = 'Close';
    sCancelled = 'Cancelled';
    sCancelMsg = '%s cancelled your form.';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}

function _showXData(tag: TXMLTag): boolean;
var
    f: TfrmXData;
begin
    f := TfrmXData.Create(nil);
    f.render(tag);
    if (f.isValid) then begin
        f.Show();
        f.BringToFront();
        Result := true;
    end
    else begin
        f.Close();
        Result := false;
    end;
end;

{---------------------------------------}
procedure showXData(tag: TXMLTag);
begin
    _showXData(tag);
end;

{---------------------------------------}
function showXDataEx(tag: TXMLTag): boolean;
begin
    Result := _showXData(tag);
end;

{---------------------------------------}
procedure TfrmXData.render(tag: TXMLTag);
var
    ins, x: TXMLTag;
    flds: TXMLTagList;
    xtra, h, i: integer;
    frm: TframeGeneric;
    thread: string;
    m : integer;
    c: TControl;
begin
    // Build the dialog based on the tag.
    _valid := false;
    AssignDefaultFont(Self.Canvas.Font);
    packet := tag.Name;
    to_jid := tag.GetAttribute('from');
    AssignDefaultFont(Self.Font);

    // Get our context/xmlns
    if (packet = 'iq') then
        ns := tag.QueryXPData('/iq/query@xmlns')
    else if (packet = 'message') then begin
        thread := tag.GetBasicText('thread');
        if (thread <> '') then _thread := thread;
    end;

    // Get the x-data container.
    x := tag.QueryXPTag('//x[@xmlns="jabber:x:data"]');
    if (x = nil) then exit;

    _type := x.GetAttribute('type');
    _responded := false;

    if (_type = 'cancel') then begin
        // this is a cancel notice
        self.Caption := _(sCancelled);
        lblIns.Caption := WideFormat(_(sCancelMsg), [to_jid]);
        insBevel.Visible := false;
        insBevel.Height := 0;
    end
    else begin
        // Get instructions and title
        ins := x.GetFirstTag('title');
        if (ins <> nil) then begin
          _title := ins.Data;
          self.Caption := _title;
        end
        else
        Self.Caption := WideFormat(_(sFormFrom), [to_jid]);

        ins := x.GetFirstTag('instructions');
        if (ins <> nil) then begin
          lblIns.Caption := ins.Data
        end
        else begin
          lblIns.Visible := false;
          lblIns.Height := 0;
          insBevel.Visible := false;
          insBevel.Height := 0;
        end;
    end;

    // Get all of our fields.
    flds := x.QueryTags('field');
    h := 1;
    m := 0;
    xtra := lblIns.Height + 5 + frameButtons1.Height;

    for i := flds.Count - 1 downto 0 do begin
        frm := TframeGeneric.Create(Self);
        frm.FormType := _type;
        frm.Name := 'xDataFrame' + IntToStr(i);
        frm.Parent := box;
        frm.Visible := true;
        frm.render(flds[i]);
        frm.Align := alTop;
        frm.TabOrder := 0;
        h := h + frm.Height;
        m := max(m, frm.getLabelWidth());
    end;

    for i := 0 to Self.box.ControlCount - 1 do begin
        c := Self.box.Controls[i];
        if (c is TframeGeneric) then begin
            frm := TframeGeneric(c);
            frm.setLabelWidth(m + 5);
        end;
    end;

    h := h + xtra;
    if (h > Trunc(Screen.Height * 0.750)) then
        h := Trunc(Screen.Height * 0.750);

    insBevel.Visible := lblIns.Visible;
    if (lblIns.Visible) then begin
        insBevel.Align := alTop;
        lblIns.Align := alTop;
    end;

    if (_type <> 'form') then begin
        frameButtons1.btnOK.Visible := false;
        frameButtons1.btnCancel.Caption := _(sClose);
    end;

    MainSession.Prefs.RestorePosition(Self);
    Self.ClientHeight := h;

    CenterMainForm(Self);
    _valid := true;
end;

{---------------------------------------}
procedure TfrmXData.frameButtons1btnOKClick(Sender: TObject);
var
    i: integer;
    c: TControl;
    f: TframeGeneric;
    fx, m, x: TXMLTag;
    valid: boolean;
begin

    if (_type = 'form') then begin
        // do something
        if (not MainSession.Active) then begin
            MessageDlgW(_('You are currently disconnected. Please reconnect before responding to this form.'),
                mtError, [mbOK], 0);
            exit;
        end;

        getResponseTag(m, x);

        x.setAttribute('xmlns', XMLNS_XDATA);
        x.setAttribute('type', 'submit');
        if (_title <> '') then
          x.AddBasicTag('title', _title);

        valid := true;
        for i := 0 to Self.box.ControlCount - 1 do begin
            c := Self.box.Controls[i];
            if (c is TframeGeneric) then begin
                f := TframeGeneric(c);

                if (not f.isValid()) then
                    valid := false;
                if (x <> nil) then begin
                    fx := f.getXML();
                    if (fx <> nil) then x.AddTag(fx);
                end;
            end;
        end;

        if (not valid) then begin
            if (m <> nil) then m.Free();
            MessageDlgW(_(sAllRequired), mtError, [mbOK], 0);
            exit;
        end;
        MainSession.SendTag(m);
        _responded := true;
    end;

    Self.Close();
end;

{---------------------------------------}
procedure TfrmXData.getResponseTag(var m, x: TXMLTag);
var
    q: TXMLTag;
begin
    // Get a properly formatted result or cancel packet
    m := TXMLTag.Create(packet);
    m.setAttribute('to', to_jid);

    if (packet = 'message') then begin
        if (_thread <> '') then
            m.AddBasicTag('thread', _thread);
        m.AddTag('body');
        x := m.AddTag('x');
    end
    else if (packet = 'iq') then begin
        m.setAttribute('type', 'set');
        m.setAttribute('id', MainSession.generateID());

        q := m.AddTag('query');
        q.setAttribute('xmlns', ns);
        x := q.AddTag('x');
    end;

    x.setAttribute('xmlns', XMLNS_XDATA);
end;

{---------------------------------------}
procedure TfrmXData.frameButtons1btnCancelClick(Sender: TObject);
begin
    Cancel();
    Self.Close;
end;

{---------------------------------------}
procedure TfrmXData.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if (not _responded) then Cancel();

    Action := caFree;
    if (MainSession <> nil) then
        MainSession.Prefs.SavePosition(Self);
    inherited;
end;

{---------------------------------------}
procedure TfrmXData.FormResize(Sender: TObject);
var
    f : TframeGeneric;
    i: integer;
    c: TControl;
begin
    lblIns.AutoSize := false;
    lblIns.AutoSize := true;

    for i := 0 to Self.box.ControlCount - 1 do begin
        c := Self.box.Controls[i];
        if (c is TframeGeneric) then begin
            f := TframeGeneric(c);
            f.formResize();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmXData.Cancel();
var
    m, x: TXMLTag;
begin
    if (_type = 'form') then begin
        if (not MainSession.Active) then begin
            MessageDlgW(_('You are currently disconnected. Please reconnect before responding to this form.'),
                mtError, [mbOK], 0);
            exit;
        end;
        getResponseTag(m, x);
        x.setAttribute('type', 'cancel');
        MainSession.SendTag(m);
        _responded := true;
    end;
end;

{---------------------------------------}
procedure TfrmXData.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);
end;

end.
