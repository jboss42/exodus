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
    Dialogs, buttonFrame, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmXData = class(TForm)
    frameButtons1: TframeButtons;
    lblIns: TLabel;
    lstReport: TListView;
    box: TScrollBox;
    insBevel: TBevel;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    packet: string;
    ns: string;
    to_jid: string;
    report_cols: TStringList;
    procedure ResultsCB(event: string; tag: TXMLTag);

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

implementation

{$R *.dfm}
uses
    Session, ExUtils, StrUtils, fGeneric, IQ;

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
    rflds, flds: TXMLTagList;
    h, i: integer;
    c: TListColumn;
    frm: TframeGeneric;
    subj: string;
begin
    //
    packet := tag.Name;
    to_jid := tag.GetAttribute('from');

    if (packet = 'iq') then
        ns := tag.QueryXPData('/iq/query@xmlns')
    else if (packet = 'message') then begin
        subj := tag.GetBasicText('subject');
        if (subj <> '') then self.Caption := subj;
        end;

    x := tag.QueryXPTag('//x[@xmlns="jabber:x:data"]');
    flds := x.QueryTags('field');


    ins := x.GetFirstTag('instructions');
    lblIns.Visible := (ins <> nil);
    if (ins <> nil) then
        lblIns.Caption := trimNewLines(ins.Data);

    report := x.GetFirstTag('reported');
    lstReport.Visible := (report <> nil);

    if (report <> nil) then begin
        report_cols := TStringList.Create();
        rflds := report.QueryTags('field');
        for i := 0 to rflds.Count - 1 do begin
            c := lstReport.Columns.Add();
            c.Caption := rflds[i].getAttribute('label');
            report_cols.Add(rflds[i].GetAttribute('var'));
            end;
        end;

    h := 10;
    for i := flds.Count - 1 downto 0 do begin
        frm := TframeGeneric.Create(Self);
        frm.Name := 'xDataFrame' + IntToStr(i);
        frm.Parent := box;
        frm.Visible := true;
        frm.render(flds[i]);
        frm.Align := alTop;
        frm.TabOrder := 0;
        h := h + frm.Height;
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

    MainSession.Prefs.RestorePosition(Self);
    Self.ClientHeight := h + lblIns.Height + 10 + frameButtons1.Height;

end;

{---------------------------------------}
procedure TfrmXData.frameButtons1btnOKClick(Sender: TObject);
var
    i: integer;
    c: TControl;
    f: TframeGeneric;
    fx, m, x, body: TXMLTag;
    valid: boolean;
    iq : TJabberIQ;
begin
    // do something
    m := nil;
    x := nil;
    body := nil;
    iq := nil;

    if (packet = 'message') then begin
        m := TXMLTag.Create('message');
        m.PutAttribute('to', to_jid);
        x := m.AddTag('x');
        x.PutAttribute('xmlns', XMLNS_DATA);
        body := m.AddTag('body');
        end
    else if (packet = 'iq') then begin
        iq := TJabberIQ.Create(MainSession,
                               MainSession.generateID(),
                               Self.ResultsCB);
        iq.toJid := to_jid;
        iq.iqType := 'set';
        iq.Namespace := ns;
        x := iq.qTag.AddTag('x');
        x.PutAttribute('xmlns', XMLNS_DATA);
        end;


    valid := true;
    for i := 0 to Self.box.ControlCount - 1 do begin
        c := Self.box.Controls[i];
        if (c is TframeGeneric) then begin
            f := TframeGeneric(c);

            if (not f.isValid()) then
               valid := false;
            if (x <> nil) then begin
                fx := f.getXML();
                if (fx <> nil) then begin
                    x.AddTag(fx);
                    if (body <> nil) then
                       body.AddCData(fx.GetAttribute('var') + ': ' +
                                     fx.GetBasicText('value') + ''#13#10);
                    end;
                end;
            end;
        end;

        if (not valid) then begin
          if (m <> nil) then m.Free();
          MessageDlg(sAllRequired, mtError, [mbOK], 0);
          exit;
          end;

    if (m <> nil) then
        MainSession.SendTag(m)
    else if (iq <> nil) then
        iq.Send();

    if (not lstReport.Visible) then
        Self.Close();
end;

{---------------------------------------}
procedure TfrmXData.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

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

{---------------------------------------}
procedure TfrmXData.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
    MainSession.Prefs.SavePosition(Self);
    inherited;
end;

end.
