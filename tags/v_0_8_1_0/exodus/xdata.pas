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
  private
    { Private declarations }
    packet: string;
    ns: string;
    to_jid: string;
    _type: string;
    _thread: WideString;
    _title: WideString;

    procedure getResponseTag(var m, x: TXMLTag);
  public
    { Public declarations }
    procedure render(tag: TXMLTag);
  end;

var
  frmXData: TfrmXData;

procedure showXData(tag: TXMLTag);

resourcestring
    sAllRequired = 'All required fields must be filled out';
    sFormFrom = 'Form from %s';
    sClose = 'Close';

implementation

{$R *.dfm}
uses
    JabberConst, Session, ExUtils, StrUtils, fGeneric, IQ, Math;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}

procedure showXData(tag: TXMLTag);
var
    f: TfrmXData;
begin
    f := TfrmXData.Create(nil);
    f.render(tag);
    f.Show();
    f.BringToFront();
end;

{---------------------------------------}
procedure TfrmXData.render(tag: TXMLTag);
var
    report, ins, x: TXMLTag;
    flds: TXMLTagList;
    h, i: integer;
    frm: TframeGeneric;
    thread: string;
    m : integer;
    c: TControl;
begin
    //
    AssignDefaultFont(Self.Canvas.Font);
    packet := tag.Name;
    to_jid := tag.GetAttribute('from');
    AssignDefaultFont(Self.Font);

    if (packet = 'iq') then
        ns := tag.QueryXPData('/iq/query@xmlns')
    else if (packet = 'message') then begin
        thread := tag.GetBasicText('thread');
        if (thread <> '') then _thread := thread;
    end;

    x := tag.QueryXPTag('//x[@xmlns="jabber:x:data"]');

    _type := x.GetAttribute('type');

    ins := x.GetFirstTag('title');
    if (ins <> nil) then begin
        _title := ins.Data;
        self.Caption := _title;
    end;

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

    flds := x.QueryTags('field');
    h := 10;
    m := 0;
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
        m :=  max(m, frm.getLabelWidth());
    end;

    for i := 0 to Self.box.ControlCount - 1 do begin
        c := Self.box.Controls[i];
        if (c is TframeGeneric) then begin
            frm := TframeGeneric(c);
            frm.setLabelWidth(m + 5);
        end;
    end;

    if (h > Trunc(Screen.Height * 0.667)) then
        h := Trunc(Screen.Height * 0.667);

    report := x.GetFirstTag('title');
    if (report <> nil) then
        Self.Caption := report.Data
    else
        Self.Caption := Format(sFormFrom, [to_jid]);

    insBevel.Visible := lblIns.Visible;
    if (lblIns.Visible) then begin
        insBevel.Align := alTop;
        lblIns.Align := alTop;
    end;

    if (_type = 'submit') then begin
        frameButtons1.btnOK.Visible := false;
        frameButtons1.btnCancel.Caption := sClose;
    end;

    MainSession.Prefs.RestorePosition(Self);
    Self.ClientHeight := h + lblIns.Height + 10 + frameButtons1.Height;

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
    // do something
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
        MessageDlg(sAllRequired, mtError, [mbOK], 0);
        exit;
    end;

    MainSession.SendTag(m);
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
var
    m, x: TXMLTag;
begin
    getResponseTag(m, x);
    x.setAttribute('type', 'cancel');
    MainSession.SendTag(m);
    Self.Close;
end;

(*
{---------------------------------------}
procedure TfrmXData.ResultsCB(event: string; tag: TXMLTag);
var
    item, field: TXMLTag;
    items, fields : TXMLTagList;
    i, j: integer;
    it: TListItem;
begin
{
<iq from='users.jabber.org' id='jcl_8' to='hildjj-foo@jabber.org/Exodus' type='result'>
  <query xmlns='jabber:iq:search'>
    <item jid='JoshHi@jabber.org'>
      <x xmlns='jabber:x:data'>
        <field var='first'><value>Josh</value></field>
        <field var='last'><value>Hildebrand</value></field>
        <field var='nick'><value>JoshHi</value></field>
        <field var='email'><value>josh@jedi.net</value></field>
      </x>
    </item>
  </query>
</iq>
}

    // timeout
    if (event <> 'xml') then exit;

    items := tag.QueryXPTags('/iq/query/item');
    for i := 0 to items.Count - 1 do begin
        item := items[i];
        it := lstReport.Items.Add();
        fields := item.QueryXPTags('/item/x/field');
        for j := 0 to fields.Count - 1 do begin
            field := fields[j];
            // TODO: look up the right column, based on the var of the field.
            it.SubItems.Add(field.GetBasicText('value'));
        end;
    end;
end;
*)

{---------------------------------------}
procedure TfrmXData.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
    if (MainSession <> nil) then
        MainSession.Prefs.SavePosition(Self);
    inherited;
end;

procedure TfrmXData.FormResize(Sender: TObject);
begin
    lblIns.AutoSize := false;
    lblIns.AutoSize := true;
end;

end.
