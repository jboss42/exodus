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
    Entity, EntityCache, JabberID, XMLTag,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    buttonFrame, StdCtrls, TntStdCtrls;

type
  TfrmAdd = class(TForm)
    Label1: TTntLabel;
    txtJID: TTntEdit;
    Label2: TTntLabel;
    txtNickname: TTntEdit;
    Label3: TTntLabel;
    cboGroup: TTntComboBox;
    frameButtons1: TframeButtons;
    lblAddGrp: TTntLabel;
    cboType: TTntComboBox;
    Label4: TTntLabel;
    lblGateway: TTntLabel;
    txtGateway: TTntEdit;
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
    gw_ent: TJabberEntity;
    svc, gw, sjid, snick, sgrp: Widestring;
    procedure doAdd;
  published
    procedure EntityCallback(event: string; tag: TXMLTag);
  public
    { Public declarations }
  end;

var
  frmAdd: TfrmAdd;

procedure ShowAddContact(contact: TJabberID = nil); overload;
procedure ShowAddContact(contact: Widestring); overload;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    InputPassword, ExSession, JabberUtils, ExUtils,  NodeItem,
    GnuGetText, Jabber1, Presence, Session;

const
    sNoDomain = 'The contact ID you entered does not follow the standard user@host convention. Do you want to continue?';
    sResourceSpec = 'Jabber Contact IDs do not typically include a resource. Are you sure you want to add this contact ID?';
    sNoGatewayFound = 'The gateway server you requested does not have a transport for this contact type.';
    sNotAddMyself = 'You can not add yourself to your roster.';
{$R *.DFM}

{---------------------------------------}
procedure ShowAddContact(contact: TJabberID);
var
    f: TfrmAdd;
begin
    f := TfrmAdd.Create(Application);
    if (contact <> nil) then begin
        f.txtJid.Text := contact.GetDisplayJID();
        f.txtNickname.Text := contact.userDisplay;
    end;
    contact.Free();
    f.Show;
    f.BringToFront();
end;

{---------------------------------------}
procedure ShowAddContact(contact: Widestring);
var
    j: TJabberID;
begin
    j := TJabberID.Create(contact);
    ShowAddContact(j);
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

    {
    // DO NOT translate these!
    case (cboType.ItemIndex) of
    1: svc := 'msn';
    2: svc := 'yahoo';
    3: svc := 'aim';
    3: svc := 'icq';
    else
        svc := 'jabber';
    end;
    }

    //SLKSLKSLK
    svc := 'jabber';

    {
    // check to see if we need an entity info
    if (cboType.ItemIndex > 0) then begin
        // Adding a gateway'd user
        gw := txtGateway.Text;
        gw_ent := jEntityCache.getByJid(gw);
        if (gw_ent = nil) then begin
            cb := MainSession.RegisterCallback(EntityCallback, '/session/entity/items');
            gw_ent := jEntityCache.fetch(gw, MainSession);
            self.Hide();
        end
        else
            doAdd();
    end
    else begin
    }
        // Adding a normal Jabber user
        // check to see if we have an "@" sign
        tmp_jid := TJabberID.Create(sjid, false);
        sjid := tmp_jid.jid;
        if (Lowercase(sjid) = Lowercase(MainSession.Profile.getJabberID().jid())) then begin
            MessageDlgW(_(sNotAddMyself), mtError, [mbOK], 0);
            exit;
        end;

        if (tmp_jid.user = '') then
            if MessageDlgW(_(sNoDomain), mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
        if (tmp_jid.resource <> '') then
            if MessageDlgW(_(sResourceSpec), mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
        doAdd();
        tmp_jid.Free();
    //end;
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
    go: TJabberGroup;
begin
    // Add a new group to the list...
    go := promptNewGroup();
    if (go <> nil) then
        MainSession.Roster.AssignGroups(cboGroup.Items);
end;

{---------------------------------------}
procedure TfrmAdd.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);
    URLLabel(lblAddGrp);
    MainSession.Roster.AssignGroups(cboGroup.Items);
    cboGroup.Text := MainSession.Prefs.getString('roster_default');

    txtGateway.Text := MainSession.Server;
    //cboType.Enabled := MainSession.Prefs.getBool('brand_addcontact_gateways');

    //SLKSLKSLK
    cboType.AddItem(_('Jabber'), nil);
    if (MainSession.GetExtList().IndexOf('aim') <> -1) then begin
        cboType.AddItem(_('AIM'), nil);
    end;

    cboType.ItemIndex := 0;

end;

{---------------------------------------}
procedure TfrmAdd.txtJIDExit(Sender: TObject);
var
    new: Widestring;
    tmp_id: TJabberID;
begin
    if (txtJID.Text = '') then exit;
    tmp_id := TJabberID.Create(txtJID.Text);

    if ((cboType.ItemIndex = 0) and (tmp_id.user = '')) then begin
        new := txtJid.Text + '@' + MainSession.Profile.Server;
        tmp_id.Free();
        tmp_id := TJabberID.Create(new);
        txtJid.Text := new;
    end;

    // add the nickname if it's not there.
    if (txtNickname.Text = '') then
        txtNickname.Text := tmp_id.user;

    tmp_id.Free();

end;

{---------------------------------------}
procedure TfrmAdd.cboTypeChange(Sender: TObject);
var
    en: boolean;
begin
    //SLKSLKSLK
    {
    if (cboType.
    MainSession.GetExtList().IndexOf('aim') <> -1) then begin

    end;
    }
    {
    en := (cboType.ItemIndex > 0);
    lblGateway.Enabled := en;
    txtGateway.Enabled := en;
    }
end;

{---------------------------------------}
procedure TfrmAdd.doAdd;
var
    a: TJabberEntity;
    j: Widestring;
    i: integer;
begin
    // check to see if there is an agent for this type
    // of contact type
    if (svc = 'jabber') then begin
        MainSession.Roster.AddItem(sjid, snick, sgrp, true);
        Self.Close;
    end
    else begin
        a := gw_ent.getItemByFeature(Lowercase(svc));
        if (a <> nil) then begin
            // we have this type of svc..
            j := '';
            for i := 1 to length(sjid) do begin
                if (sjid[i] = '@') then
                    j := j + '%'
                else
                    j := j + sjid[i];
            end;
            sjid := j + '@' + a.jid.full;
            ExRegController.MonitorJid(sjid, false);
            MainSession.Roster.AddItem(sjid, snick, sgrp, true);
            Self.Close;
        end
        else begin
            // we don't have this svc..
            MessageDlgW(_(sNoGatewayFound), mtError, [mbOK], 0);
            Self.Show();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmAdd.EntityCallback(event: string; tag: TXMLTag);
begin
    // we are getting some kind of entity info
    if ((event = '/session/entity/items') and
        (tag.GetAttribute('from') = gw)) then begin
        MainSession.UnRegisterCallback(cb);
        doAdd();
    end;
end;


end.

