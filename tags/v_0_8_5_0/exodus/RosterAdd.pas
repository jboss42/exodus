unit RosterAdd;
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
    Agents,
    XMLTag,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    buttonFrame, StdCtrls;

type
  TfrmAdd = class(TForm)
    Label1: TLabel;
    txtJID: TEdit;
    Label2: TLabel;
    txtNickname: TEdit;
    Label3: TLabel;
    cboGroup: TComboBox;
    frameButtons1: TframeButtons;
    lblAddGrp: TLabel;
    cboType: TComboBox;
    Label4: TLabel;
    lblGateway: TLabel;
    txtGateway: TEdit;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure lblAddGrpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure txtJIDExit(Sender: TObject);
    procedure cboTypeChange(Sender: TObject);
  private
    { Private declarations }
    cb: integer;
    agents: TAgents;
    svc, gw, sjid, snick, sgrp: string;
    procedure doAdd;
  published
    procedure agentsCallback(event: string; tag: TXMLTag);
  public
    { Public declarations }
  end;

var
  frmAdd: TfrmAdd;

resourcestring
    sNoDomain = 'The contact ID you entered does not follow the standard user@host convention. Do you want to continue?';
    sResourceSpec = 'Jabber Contact IDs do not typically include a resource. Are you sure you want to add this contact ID?';
    sNoGatewayFound = 'The gateway server you requested does not have a transport for this contact type.';
    sNotAddMyself = 'You can not add yourself to your roster.';

function ShowAddContact: TfrmAdd;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    InputPassword, ExSession, ExUtils, 
    GnuGetText, Jabber1, JabberID,  Presence, Session;
{$R *.DFM}

{---------------------------------------}
function ShowAddContact: TfrmAdd;
begin
    Result := TfrmAdd.Create(Application);
    Result.Show;
end;

{---------------------------------------}
procedure TfrmAdd.frameButtons1btnOKClick(Sender: TObject);
var
    tmp_jid: TJabberID;
begin
    // Add the new roster item..
    sjid := txtJID.Text;
    snick := txtNickname.Text;
    sgrp := cboGroup.Text;
    svc := lowercase(cboType.Text);

    // check to see if we need an agents list
    if (cboType.ItemIndex > 0) then begin
        // Adding a gateway'd user
        gw := txtGateway.Text;
        agents := MainSession.GetAgentsList(gw);
        if (agents = nil) then begin
            cb := MainSession.RegisterCallback(agentsCallback, '/session/agents');
            agents := MainSession.NewAgentsList(gw);
            agents.Fetch(gw);
            Self.Hide;
        end
        else
            doAdd();
    end
    else begin
        // Adding a normal Jabber user
        // check to see if we have an "@" sign
        if (Lowercase(sjid) = Lowercase(MainSession.Username + '@' + MainSession.Server)) then begin
            MessageDlg(sNotAddMyself, mtError, [mbOK], 0);
            exit;
        end;

        tmp_jid := TJabberID.Create(sjid);
        if (tmp_jid.user = '') then
            if MessageDlg(sNoDomain, mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
        if (tmp_jid.resource <> '') then
            if MessageDlg(sResourceSpec, mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
        doAdd();
        tmp_jid.Free();
    end;
end;

{---------------------------------------}
procedure TfrmAdd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmAdd.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmAdd.lblAddGrpClick(Sender: TObject);
var
    ngrp: WideString;
begin
    // Add a new group to the list...
    ngrp := sDefaultGroup;
    if InputQueryW(sNewGroup, sNewGroupPrompt, ngrp) then begin
        MainSession.Roster.GrpList.Add(ngrp);
        cboGroup.Items.Assign(MainSession.Roster.GrpList);
        removeSpecialGroups(cboGroup.Items);
    end;
end;

{---------------------------------------}
procedure TfrmAdd.FormCreate(Sender: TObject);
begin
    TranslateProperties(Self);
    cboGroup.Items.Assign(MainSession.Roster.GrpList);
    removeSpecialGroups(cboGroup.Items);
    cboGroup.Text := MainSession.Prefs.getString('roster_default');
    cboType.ItemIndex := 0;
    txtGateway.Text := MainSession.Server;
end;

{---------------------------------------}
procedure TfrmAdd.txtJIDExit(Sender: TObject);
var
    tmp_id: TJabberID;
begin
    // add the nickname if it's not there.
    if (txtNickname.Text = '') then begin
        tmp_id := TJabberID.Create(txtJID.Text);
        txtNickname.Text := tmp_id.user;
        tmp_id.Free();
    end;
end;

{---------------------------------------}
procedure TfrmAdd.cboTypeChange(Sender: TObject);
var
    en: boolean;
begin
    //
    en := (cboType.ItemIndex > 0);
    lblGateway.Enabled := en;
    txtGateway.Enabled := en;
end;

{---------------------------------------}
procedure TfrmAdd.doAdd;
var
    a: TAgentItem;
    j: string;
    i: integer;
begin
    // check to see if there is an agent for this type
    // of contact type

    if (svc = 'jabber') then begin
        MainSession.Roster.AddItem(sjid, snick, sgrp, true);
        Self.Close;
    end
    else begin
        a := agents.findService(Lowercase(svc));
        if (a <> nil) then begin
            // we have this type of svc..
            j := '';
            for i := 1 to length(sjid) do begin
                if (sjid[i] = '@') then
                    j := j + '%'
                else
                    j := j + sjid[i];
            end;
            sjid := j + '@' + a.jid;
            ExRegController.MonitorJid(sjid, false);
            MainSession.Roster.AddItem(sjid, snick, sgrp, true);
            Self.Close;
        end
        else begin
            // we don't have this svc..
            MessageDlg(sNoGatewayFound, mtError, [mbOK], 0);
            Self.Show();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmAdd.agentsCallback(event: string; tag: TXMLTag);
begin
    // we are getting some kind of agents list
    if (tag.GetAttribute('from') = gw) then begin
        MainSession.UnRegisterCallback(cb);
        doAdd();
    end;
end;


end.

