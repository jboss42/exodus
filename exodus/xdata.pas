unit xdata;

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
  private
    { Private declarations }
    packet: string;
    id: string;
    ns: string;
    to_jid: string;
    report_cols: TStringList;
  public
    { Public declarations }
    procedure render(tag: TXMLTag);
  end;

var
  frmXData: TfrmXData;

procedure showXData(tag: TXMLTag);

resourcestring
    sAllRequired = 'All required fields must be filled out';

implementation

{$R *.dfm}
uses
    Session, ExUtils, StrUtils, fGeneric;

procedure showXData(tag: TXMLTag);
var
    f: TfrmXData;
begin
    f := TfrmXData.Create(nil);
    f.render(tag);
    f.Show();
end;

procedure TfrmXData.render(tag: TXMLTag);
var
    report, ins, x: TXMLTag;
    rflds, flds: TXMLTagList;
    i: integer;
    c: TListColumn;
    frm: TframeGeneric;
    subj: string;
begin
    //
    packet := tag.Name;
    id := tag.GetAttribute('id');
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

    for i := flds.Count - 1 downto 0 do begin
        frm := TframeGeneric.Create(Self);
        frm.Name := 'xDataFrame' + IntToStr(i);
        frm.Parent := box;
        frm.Visible := true;
        frm.render(flds[i]);
        frm.Align := alTop;
        end;

    insBevel.Visible := lblIns.Visible;
    if (lblIns.Visible) then begin
        insBevel.Align := alTop;
        lblIns.Align := alTop;
        end;

end;

procedure TfrmXData.frameButtons1btnOKClick(Sender: TObject);
var
    i: integer;
    c: TControl;
    f: TframeGeneric;
    fx, m, x, body: TXMLTag;
    valid: boolean;
begin
    // do something
    m := nil;
    x := nil;
    body := nil;
    if (packet = 'message') then begin
        m := TXMLTag.Create('message');
        m.putAttribute('to', to_jid);
        x := m.AddTag('x');
        body := m.AddTag('body');
        end
    else if (packet = 'iq') then begin
        m := TXMLTag.Create('iq');
        if (id <> '') then
            m.PutAttribute('id', id);
        body := m.AddTag('query');
        body.PutAttribute('xmlns', ns);
        x := body.AddTag('x');
        end;

    x.PutAttribute('xmlns', XMLNS_DATA);

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

    MainSession.SendTag(m);
    Self.Close();
end;

procedure TfrmXData.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

end.
