unit RegForm;
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
    XMLTag, IQ, Agents, Presence,
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
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
    cur_iq: TJabberIQ;
    cur_stage: integer;
    cur_key: string;
    pres_cb: integer;
    function doField(fld: string): TfrmField;
  published
    procedure AgentCallback(event: string; tag: TXMLTag);
    procedure doRegister();
    procedure RegCallback(event: string; tag: TXMLTag);
    procedure PresCallback(event: string; tag: TXMLTag; pres: TJabberPres);
    procedure RemoveCallback(event: string; tag: TXMLTag);
  public
    { Public declarations }
    jid: string;
    agent: TAgentItem;
    procedure Start();
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
    Transports, S10n, Roster, Session;

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
    pres_cb := -1;
    agent := TAgentItem.Create();
end;

{---------------------------------------}
procedure TfrmRegister.Start();
begin
    // start the whole process off
    btnPrev.Enabled := false;
    btnNext.Enabled := false;
    btnCancel.Enabled := true;
    Self.Show();
    cur_iq := TJabberIQ.Create(MainSession, MainSession.generateID(), AgentCallback, 4);
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
    cur_fld: TfrmField;
begin
    // we got back a response to the iq-get, on the register namespace
    cur_iq := nil;
    if (event = 'xml') then begin
        if (tag.GetAttribute('type') = 'error') then begin
            // error packet
            MessageDlg('The agent you are trying to register with returned an error.',
                mtError, [mbOK], 0);
            Self.Close();
            exit;
            end
        else begin
            // normal result
            btnDelete.Enabled := false;
            ag_tag := tag.QueryXPTag('/iq/query');
            flds := ag_tag.ChildTags();
            for i := 0 to flds.count - 1 do begin
                f := flds[i];
                if (f.Name = 'instructions') then
                    lblIns.Caption := f.Data
                else if (f.Name = 'key') then
                    cur_key := f.Data
                else if (f.Name = 'registered') then
                    btnDelete.Enabled := true
                else begin
                    cur_fld := doField(f.Name);
                    if (f.Data <> '') then
                        cur_fld.txtData.Text := f.Data;
                    end;
                end;
            flds.Free();

            cur_stage := regStage_Form;
            btnNext.Enabled := true;
            end;
        end
    else begin
        // timeout on agent query
        MessageDlg('The agent you are trying to register with can not be reached.', mtError, [mbOK], 0);
        Self.Close();
        exit;
        end;
end;

{---------------------------------------}
function TfrmRegister.doField(fld: string): TfrmField;
var
    frm: TfrmField;
begin
    // create a new panel and input area for a field
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
    t: TXMLTag;
begin
    // send the iq-set
    // get pres packets
    pres_cb := MainSession.RegisterCallback(PresCallback);
    cur_iq := TJabberIQ.Create(MainSession, MainSession.generateID(), RegCallback);
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

    t := TXMLTag.Create('transport');
    t.PutAttribute('jid', cur_iq.toJid);
    t.PutAttribute('name', agent.name);
    MainSession.FireEvent('/session/transport', t);
    t.Free;

    cur_iq.Send();
end;

{---------------------------------------}
procedure TfrmRegister.PresCallback(event: string; tag: TXMLTag; pres: TJabberPres);
var
    i: integer;
    ritem: TJabberRosterItem;
begin
    // getting some pres packet
    if (pres.fromJID.jid = self.jid) then begin
        MainSession.UnRegisterCallback(pres_cb);
        pres_cb := -1;
        if (pres.PresType = 'error') then begin
            // some kind of error
            end

        else if (pres.PresType = 'unavailable') then begin
            // bad registration
            end

        else begin
            // ok registration, check all pendings and re-subscribe to them
            MainSession.roster.AddItem(pres.fromJID.full, agent.name, 'Transports', false);
            with MainSession do begin
                for i := 0 to roster.Count - 1 do begin
                    ritem := TJabberRosterItem(Roster.Objects[i]);
                    if ((ritem.ask = 'subscribe') and (ritem.jid.domain = self.jid)) then begin
                        SendSubscribe(ritem.jid.jid, MainSession);
                        end;
                    end;
                end;
            end;
        end;
end;

{---------------------------------------}
procedure TfrmRegister.RegCallback(event: string; tag: TXMLTag);
begin
    // We are getting a result from our iq-set
    cur_iq := nil;
    Tabs.ActivePage := tabResult;
    if ((event = 'xml') and (tag.getAttribute('type') = 'result')) then begin
        // normal result
        lblOK.Visible := true;
        lblBad.Visible := false;
        btnPrev.Enabled := false;
        btnNext.Caption := 'Finish';
        btnNext.Enabled := true;
        btnCancel.Enabled := false;
        end
    else begin
        // some kind of error
        lblOK.Visible := false;
        lblBad.Visible := true;
        btnPrev.Enabled := false;
        btnNext.Caption := 'Finish';
        btnNext.Enabled := true;
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

{---------------------------------------}
procedure TfrmRegister.btnCancelClick(Sender: TObject);
begin
    Self.Close();
end;

{---------------------------------------}
procedure TfrmRegister.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    if (cur_iq <> nil) then
        cur_iq.Free;

    if ((pres_cb <> -1) and (MainSession <> nil)) then
        MainSession.UnRegisterCallback(pres_cb);

    Action := caFree;
end;

{---------------------------------------}
procedure TfrmRegister.RemoveCallback(event: string; tag: TXMLTag);
begin
    if (event = 'timeout') then begin
        MessageDlg('The agent you are trying to register with can not be reached.', mtError, [mbOK], 0);
        end
    else begin
        if (tag.getAttribute('type') = 'error') then begin
            MessageDlg('There was an error trying to remove your registration.', mtError,
                [mbOK], 0);
            end
        else begin
            MessageDlg('Your registration has been removed.', mtInformation, [mbOK], 0);
            end;
        end;
    self.close();
    exit;
end;


procedure TfrmRegister.btnDeleteClick(Sender: TObject);
begin
    RemoveTransport(jid);
    Self.Close();
end;

end.
