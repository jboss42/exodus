unit RegForm;

interface

uses
    fLeftLabel,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmRegister = class(TForm)
    PageControl1: TPageControl;
    pnlBottom: TPanel;
    pnlBtns: TPanel;
    btnPrev: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    tabWelcome: TTabSheet;
    Label1: TLabel;
    lblIns: TLabel;
    tabAgent: TTabSheet;
    tabForm: TTabSheet;
    Panel2: TPanel;
    Panel3: TPanel;
    btnDelete: TButton;
    tabResult: TTabSheet;
    lblBad: TLabel;
    lblOK: TLabel;
    tabWait: TTabSheet;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
    cbIndex: integer;
    RegKey: string;
  public
    { Public declarations }
    Service: string;
    WaitingID: string;
    CurStage: integer;
    procedure GetRegInfo;
    // procedure DoElement(element: integer; en: boolean);
    function DoField(fld: string): TfrmField;
    function GetInfo(Data: OleVariant): boolean;
    function GetResult(Data: OleVariant): boolean;
  end;

{---------------------------------------}
const
    reg_Username = 0;
    reg_Password = 1;
    reg_Nick = 2;
    reg_Email = 3;
    reg_First = 4;
    reg_Last = 5;
    reg_Next = 6;
    reg_Prev = 7;
    reg_Misc = 8;
    reg_URL = 9;

    regStage_Welcome = 0;
    regStage_Agent = 1;
    regStage_Form = 2;
    regStage_FinishAgent = 3;
    regStage_FinishForm = 4;
    regStage_Ack = 5;

    regStage_Done = 100;

var
  frmRegister: TfrmRegister;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$R *.DFM}
uses
    StringTable, 
    wjUtils,
    JabberCOM_TLB, CallBacks, Jabber1;

{---------------------------------------}
function TfrmRegister.GetInfo(Data: OleVariant): boolean;
var
    q, n, it: OleVariant;
    frm: TfrmField;
begin
    // this is our callback
    Result := true;

    if CurStage = regStage_Welcome then begin
        // We are receiving the info from a Service
        {
        query, username, nick, password, name, first, last,
        email, address, city, state, zip, phone, url, date,
        misc, text, instructions, key, and registered.
        }
        it := Data.QueryTag('query');
        if it.HasNext then q := it.Next else exit;

        it := q.Children;
        while it.HasNext do begin
            n := it.Next;
            if n.NodeType = xtTag then begin
                if n.Name = 'instructions' then
                    lblIns.Caption := n.Data
                else if n.Name = 'registered' then begin
                    // todo: some kind of delete btn for registration
                    end
                else if n.Name = 'key' then begin
                    RegKey := n.Data
                    end
                else begin
                    frm := DoField(n.Name);
                    frm.txtData.Text := n.Data;
                    end;
                end;
            end;
        CurStage := regStage_Agent;
        btnNext.Enabled := true;
        Result := false;
        end;
    cbList.RemoveCallBack(cbIndex);
end;

{---------------------------------------}
function TfrmRegister.GetResult(Data: OleVariant): boolean;
var
    dt: string;
    t: IXMLTag;
    err: boolean;
begin
    try
        t := IUnknown(Data) as IXMLTag;
        dt := 'xml';
    except
        dt := 'iq';
    end;

    Result := false;

    if CurStage = regStage_Ack then begin
        PageControl1.ActivePage := tabResult;
        err := false;
        if dt = 'xml' then begin
            // We got an IXMLTag stored in t
            if t.GetAttrib('type') = 'result' then
                err := false
            else if t.GetAttrib('type') = 'error' then
                err := true;
            end
        else if Data.iqType = 'error' then
            err := true
        else
            err := false;

        if err = true then begin
            CurStage := regStage_FinishAgent;
            btnPrev.Enabled := true;
            btnNext.Enabled := false;
            lblOK.Visible := false;
            lblBad.Visible := true;
            end
        else begin
            btnPrev.Enabled := false;
            btnNext.Enabled := true;
            CurStage := regStage_Done;
            lblOK.Visible := true;
            lblBad.Visible := false;
            end;
        end;
    cbList.RemoveCallback(cbIndex);
end;

{---------------------------------------}
procedure TfrmRegister.GetRegInfo;
var
    iq: IJabberIQ;
begin
    CurStage := regStage_Welcome;

    WaitingID := frmJabber.Jabber.GetNextID;
    iq := frmJabber.Jabber.CreateIQ;
    with iq do begin
        Namespace := 'jabber:iq:register';
        iqType := 'get';
        ToJID := Service;
        ID := WaitingID;
        end;
    cbIndex := cbList.AddCallBack(WaitingID, cbe_IQ, Self.GetInfo);
    frmJabber.Jabber.SendIQ(iq);
end;

{---------------------------------------}
function TfrmRegister.DoField(fld: string): TfrmField;
var
    frm: TfrmField;
begin
    // create a new panel
    frm := TfrmField.Create(tabAgent);
    with frm do begin
        Parent := tabAgent;
        Name := 'fld_' + fld;
        lblPrompt.Caption := fld;
        if Lowercase(fld) = 'password' then
            txtData.PasswordChar := '*';
        Align := alTop;
        Visible := true;
        end;
    Result := frm;
end;

{---------------------------------------}
procedure TfrmRegister.FormCreate(Sender: TObject);
begin
    tabWelcome.TabVisible := false;
    tabAgent.TabVisible := false;
    tabForm.TabVisible := false;
    tabResult.TabVisible := false;
    tabWait.TabVisible := false;

    CurStage := regStage_Welcome;
    PageControl1.ActivePage := tabWelcome;
    RegKey := '';
end;

{---------------------------------------}
procedure TfrmRegister.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmRegister.btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmRegister.btnNextClick(Sender: TObject);
var
    iq: IJabberIQ;
    frm: TfrmField;
    i: integer;
begin
    if CurStage = regStage_Agent then begin
        PageControl1.ActivePage := tabAgent;
        CurStage := regStage_FinishAgent;
        end
    else if CurStage = regStage_FinishAgent then begin
        // Send out the registration
        iq := frmJabber.Jabber.CreateIQ;
        with iq do begin
            for i := 0 to tabAgent.ControlCount - 1 do begin
                if tabAgent.Controls[i] is TfrmField then begin
                    frm := TfrmField(tabAgent.Controls[i]);
                    with frm do
                        SetField(lblPrompt.Caption, txtData.Text);
                end;
            end;

            if RegKey <> '' then
                SetField('key', RegKey);

            Namespace := 'jabber:iq:register';
            WaitingID := frmJabber.Jabber.GetNextID;
            ID := WaitingID;
            ToJID := Service;
            iqType := 'set';
            end;
        CurStage := regStage_Ack;
        PageControl1.ActivePage := tabWait;
        t_jids.Add(Service);
        cbIndex := cbList.AddCallBack(WaitingID, cbe_IQ, Self.GetResult);
        frmJabber.Jabber.SendIQ(iq);
        end
    else if CurStage = regStage_FinishForm then begin
        // Send out the registration
        Self.Close;
        end
    else if CurStage = regStage_Done then begin
        Self.Close;
        end;
end;

procedure TfrmRegister.btnDeleteClick(Sender: TObject);
var
    iq: IXMLTag;
begin
    // Delete my reg to this transport.
    iq := frmJabber.Jabber.CreateXMLTag;
    with iq do begin
        Name := 'iq';
        PutAttrib('id', frmJabber.Jabber.GetNextID);
        PutAttrib('to', Service);
        PutAttrib('type', 'set');
        with AddTag('query') do begin
            PutAttrib('xmlns', 'jabber:iq:register');
            AddTag('remove');
            if RegKey <> '' then
                AddBasicTag('key', RegKey);
            end;
        end;
    frmJabber.Jabber.SendXML(iq.xml);
    Self.Close;
end;

end.
