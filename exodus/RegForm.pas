unit RegForm;

interface

uses
    XMLTag, IQ, Agents, 
    fLeftLabel,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmRegister = class(TForm)
    pnlBottom: TPanel;
    pnlBtns: TPanel;
    btnPrev: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    Tabs: TPageControl;
    tabWelcome: TTabSheet;
    Label1: TLabel;
    lblIns: TLabel;
    tabAgent: TTabSheet;
    Panel2: TPanel;
    Panel3: TPanel;
    btnDelete: TButton;
    tabWait: TTabSheet;
    Label2: TLabel;
    tabResult: TTabSheet;
    lblBad: TLabel;
    lblOK: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);

    (*
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    *)
  private
    { Private declarations }
    {
    cbIndex: integer;
    RegKey: string;
    }
    cur_iq: TJabberIQ;
    cur_stage: integer;
    cur_key: string;

    ins: string;
    flds: TStringList;

    function doField(fld: string): TfrmField;

    procedure AgentCallback(event: string; tag: TXMLTag);
    procedure doRegister();
    procedure RegCallback(event: string; tag: TXMLTag);
  public
    { Public declarations }
    jid: string;
    agent: TAgentItem;

    procedure Start();

    (*
    Service: string;
    WaitingID: string;
    CurStage: integer;
    procedure GetRegInfo;
    // procedure DoElement(element: integer; en: boolean);
    function DoField(fld: string): TfrmField;
    function GetInfo(Data: OleVariant): boolean;
    function GetResult(Data: OleVariant): boolean;
    *)
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
    regStage_Form = 1;
    regStage_Register = 2;
    regStage_Finish = 3;

    regStage_Done = 100;

var
  frmRegister: TfrmRegister;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$R *.DFM}
uses
    Session;

(*
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
*)

{---------------------------------------}
procedure TfrmRegister.FormCreate(Sender: TObject);
begin
    // Hide all the tabs and make the welcome tab visible
    tabWelcome.TabVisible := false;
    tabAgent.TabVisible := false;
    tabResult.TabVisible := false;
    tabWait.TabVisible := false;

    cur_stage := regStage_Welcome;
    Tabs.ActivePage := tabWelcome;
    cur_iq := nil;
    cur_key := '';
    agent := TAgentItem.Create();
end;

{---------------------------------------}
procedure TfrmRegister.Start();
var
    a: TAgentItem;
begin
    // start the whole process off
    btnPrev.Enabled := false;
    btnNext.Enabled := false;
    btnCancel.Enabled := true;
    Self.Show();
    cur_iq := TJabberIQ.Create(MainSession, MainSession.generateID(), AgentCallback);
    with cur_iq do begin
        toJid := self.jid;
        iqType := 'get';
        Namespace := XMLNS_REGISTER;
        Send();
        end;
end;

{---------------------------------------}
procedure TfrmRegister.AgentCallback(event: string; tag: TXMLTag);
var
    i: integer;
    f, ag_tag: TXMLTag;
    flds: TXMLTagList;
begin
    // we got back a response..
    cur_iq := nil;
    if (event = 'xml') then begin
        if (tag.GetAttribute('type') = 'error') then begin
            // error packet
            end
        else begin
            // normal result
            ag_tag := tag.QueryXPTag('/iq/query/agent');
            flds := ag_tag.ChildTags();
            for i := 0 to flds.count - 1 do begin
                f := flds[i];
                if (f.Name = 'instructions') then
                    lblIns.Caption := f.Data
                else if (f.Name = 'key') then
                    cur_key := f.Data
                else
                    doField(f.Name);
                end;

            cur_stage := regStage_Form;
            btnNext.Enabled := true;
            end;
        end
    else begin
        // todo: timeout on agent query
        end;
end;

{---------------------------------------}
function TfrmRegister.doField(fld: string): TfrmField;
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
        TabOrder := 0;
        field := fld;
        end;
    Result := frm;
end;

{---------------------------------------}
procedure TfrmRegister.doRegister();
var
    i: integer;
    frm: TfrmField;
begin
    // send the iq-set
    cur_iq := TJabberIQ.Create(MainSession, MainSession.generateID(), AgentCallback);
    cur_iq.iqType := 'set';
    cur_iq.toJID := self.jid;
    cur_iq.Namespace := XMLNS_REGISTER;

    for i := 0 to tabAgent.ControlCount - 1 do begin
        if tabAgent.Controls[i] is TfrmField then begin
            frm := TfrmField(tabAgent.Controls[i]);
            with frm do
                cur_iq.qTag.AddBasicTag(lblPrompt.Caption, txtData.Text);
            end;
        end;

    if (cur_key <> '') then
        cur_iq.qTag.AddBasicTag('key', cur_key);

    cur_stage := regStage_Register;
    cur_iq.Send();
end;

{---------------------------------------}
procedure TfrmRegister.RegCallback(event: string; tag: TXMLTag);
begin
    Tabs.ActivePage := tabResult;

    if ((event = 'xml') and (tag.getAttribute('type') = 'result')) then begin
        // normal result
        lblOK.Visible := true;
        lblBad.Visible := false;
        btnPrev.Enabled := false;
        btnNext.Caption := 'Finish';
        btnCancel.Enabled := false;
        end
    else begin
        // some kind of error
        lblOK.Visible := false;
        lblBad.Visible := true;
        btnPrev.Enabled := false;
        btnNext.Caption := 'Finish';
        btnCancel.Enabled := false;
        end;
end;

{---------------------------------------}
procedure TfrmRegister.btnNextClick(Sender: TObject);
begin
    // goto the next tab
    if (Tabs.ActivePage = tabWelcome) then
        Tabs.ActivePage := tabAgent

    else if (Tabs.ActivePage = tabAgent) then begin
        // do the actual registration
        Tabs.ActivePage := tabWait;
        doRegister();
        btnNext.Enabled := false;
        btnPrev.Enabled := false;
        end

    else if (Tabs.ActivePage = tabResult) then begin
        Self.Close();
        end;
end;

end.
