unit Profile;
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
    XMLTag, IQ,
    ShellAPI, 
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    buttonFrame, StdCtrls, CheckLst, ExtCtrls, ComCtrls, TntStdCtrls;

type
  TfrmProfile = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    lblEmail: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    txtJID: TEdit;
    txtNick: TEdit;
    optSubscrip: TRadioGroup;
    txtPriEmail: TEdit;
    txtFirst: TEdit;
    txtMiddle: TEdit;
    txtLast: TEdit;
    TabSheet2: TTabSheet;
    GrpListBox: TCheckListBox;
    TabSheet3: TTabSheet;
    lblURL: TLabel;
    Label12: TLabel;
    Label6: TLabel;
    Label28: TLabel;
    txtWeb: TEdit;
    cboOcc: TComboBox;
    txtBDay: TEdit;
    TabSheet4: TTabSheet;
    Label13: TLabel;
    Label21: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    txtHomeState: TEdit;
    txtHomeZip: TEdit;
    txtHomeCity: TEdit;
    txtHomeStreet2: TEdit;
    txtHomeStreet1: TEdit;
    txtHomeCountry: TComboBox;
    TabSheet5: TTabSheet;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    txtOrgName: TEdit;
    txtOrgUnit: TEdit;
    txtOrgTitle: TEdit;
    txtWorkVoice: TEdit;
    txtWorkFax: TEdit;
    frameButtons1: TframeButtons;
    TreeView1: TTreeView;
    TabSheet6: TTabSheet;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label26: TLabel;
    Label14: TLabel;
    txtWorkState: TEdit;
    txtWorkZip: TEdit;
    txtWorkCity: TEdit;
    txtWorkStreet2: TEdit;
    txtWorkStreet1: TEdit;
    txtWorkCountry: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    txtHomeVoice: TEdit;
    txtHomeFax: TEdit;
    TabSheet7: TTabSheet;
    ResListBox: TListBox;
    Panel1: TPanel;
    Splitter1: TSplitter;
    aniProfile: TAnimate;
    memDesc: TTntMemo;
    Label3: TLabel;
    lblUpdateNick: TLabel;
    Panel2: TPanel;
    btnVersion: TButton;
    btnTime: TButton;
    btnLast: TButton;
    Panel3: TPanel;
    txtNewGrp: TTntEdit;
    btnAddGroup: TButton;
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure btnVersionClick(Sender: TObject);
    procedure lblEmailClick(Sender: TObject);
    procedure btnAddGroupClick(Sender: TObject);
    procedure btnUpdateNickClick(Sender: TObject);
  private
    { Private declarations }
    iq: TJabberIQ;
  public
    { Public declarations }
    procedure vcard(event: string; tag: TXMLTag);
  end;

var
  frmProfile: TfrmProfile;

function ShowProfile(jid: string): TfrmProfile;

implementation

{$R *.DFM}
uses
    JabberConst, XMLVCard, ExUtils, GnuGetText,  
    Presence, Roster, JabberID, Session, Jabber1;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function ShowProfile(jid: string): TfrmProfile;
var
    tmp_jid: TJabberID;
    ritem: TJabberRosterItem;
    f: TfrmProfile;
    p: TJabberPres;
    tmps: string;
    i, gi: integer;
begin
    tmp_jid := TJabberID.Create(jid);
    f := TfrmProfile.Create(Application);

    with f do begin
        GrpListBox.Items.Assign(MainSession.roster.GrpList);
        removeSpecialGroups(GrpListBox.Items);
        ResListBox.Items.Clear;
        optSubscrip.ItemIndex := 3;
        txtJID.Text := tmp_jid.jid;
        ritem := MainSession.Roster.Find(tmp_jid.jid);
        if (ritem <> nil) then begin
            txtNick.Text := ritem.RawNickname;
            if ritem.subscription = 'from' then
                optSubscrip.ItemIndex := 1
            else if ritem.subscription = 'to' then
                optSubscrip.ItemIndex := 2
            else if ritem.subscription = 'both' then
                optSubscrip.ItemIndex := 3;

            for i := 0 to ritem.Groups.Count - 1 do begin
                gi := GrpListBox.Items.IndexOf(ritem.Groups[i]);
                GrpListBox.Checked[gi] := true;
            end;
        end;

        // Show all the resources
        p := MainSession.ppdb.FindPres(tmp_jid.jid, '');
        while p <> nil do begin
            ResListBox.Items.Add(p.fromJID.resource);
            p := MainSession.ppdb.NextPres(p)
        end;

        tmps := MainSession.generateID();
        iq := TJabberIQ.Create(MainSession, tmps, vcard);
        iq.Namespace := 'vcard-temp';
        iq.qTag.Name := 'vCard';
        iq.iqType := 'get';
        iq.toJid := tmp_jid.jid;
        iq.Send;

        TreeView1.Selected := TreeView1.Items[0];
        TreeView1.FullExpand();
        PageControl1.ActivePageIndex := 0;
    end;

    tmp_jid.Free();

    f.Show;
    f.aniProfile.Visible := true;
    f.aniProfile.Active := true;
    Result := f;
end;

{---------------------------------------}
procedure TfrmProfile.vcard (event: string; tag: TXMLTag);
var
    vcard: TXMLVCard;
begin
    // callback for vcard info
    iq := nil;
    aniProfile.Visible := false;
    aniProfile.Active := false;

    if (event <> 'xml') then exit;
    vcard := TXMLVCard.Create;
    vcard.parse(tag);

    with vcard do begin
        txtFirst.Text := GivenName;
        txtLast.Text := FamilyName;
        txtPriEmail.Text := email;
        txtWeb.Text := url;
        cboOcc.Text := role;
        txtBday.Text := bday;

        txtWorkVoice.Text := WorkPhone.number;
        txtWorkFax.Text := WorkFax.number;
        txtHomeVoice.Text := HomePhone.number;
        txtHomeFax.Text := HomeFax.number;

        with work do begin
            txtWorkStreet1.Text := Street;
            txtWorkStreet2.Text := ExtAdr;
            txtWorkCity.Text := Locality;
            txtWorkState.Text := Region;
            txtWorkZip.Text := PCode;
            txtWorkCountry.Text := Country;
        end;

        with Home do begin
            txtHomeStreet1.Text := Street;
            txtHomeStreet2.Text := ExtAdr;
            txtHomeCity.Text := Locality;
            txtHomeState.Text := Region;
            txtHomeZip.Text := PCode;
            txtHomeCountry.Text := Country;
        end;

        txtOrgName.Text := OrgName;
        txtOrgUnit.Text := OrgUnit;
        txtOrgTitle.Text := OrgTitle;
        memDesc.Lines.Text := Desc;
    end;

    vcard.Free();
end;

{---------------------------------------}
procedure TfrmProfile.FormCreate(Sender: TObject);
begin
    TranslateProperties(Self);

    // make all the tabs invisible
    tabSheet1.TabVisible := false;
    tabSheet2.TabVisible := false;
    tabSheet3.TabVisible := false;
    tabSheet4.TabVisible := false;
    tabSheet5.TabVisible := false;
    tabSheet6.TabVisible := false;
    tabSheet7.TabVisible := false;
    iq := nil;
    MainSession.Prefs.RestorePosition(Self);
end;

{---------------------------------------}
procedure TfrmProfile.TreeView1Click(Sender: TObject);
var
    i: integer;
begin
    // Goto this tabsheet
    i := TreeView1.Selected.AbsoluteIndex;
    PageControl1.ActivePageIndex := i;
end;

{---------------------------------------}
procedure TfrmProfile.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    MainSession.Prefs.SavePosition(Self);
    if (iq <> nil) then
        iq.Free;
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmProfile.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmProfile.frameButtons1btnOKClick(Sender: TObject);
var
    ritem: TJabberRosterItem;
    changed: boolean;
    i: integer;
    tmp_grplist: TStringList;
begin
    // if the nick has changed then change the roster item
    ritem := MainSession.roster.Find(txtJID.Text);
    changed := false;
    if ritem <> nil then begin
        if ritem.RawNickname <> txtNick.Text then begin
            ritem.RawNickname := txtNick.Text;
            changed := true;
        end;

        tmp_grplist := TStringlist.Create;
        for i := 0 to GrpListBox.Items.Count - 1 do begin
            if GrpListBox.Checked[i] then
                tmp_grplist.Add(grpListBox.Items[i]);
        end;

        for i := 0 to tmp_grplist.Count - 1 do begin
            if ritem.Groups.indexOf(tmp_grplist[i]) < 0 then begin
                ritem.Groups.Add(tmp_grplist[i]);
                changed := true;
            end;
        end;

        for i := ritem.Groups.Count - 1 downto 0 do begin
            if tmp_grpList.indexOf(ritem.Groups[i]) < 0 then begin
                ritem.Groups.Delete(i);
                changed := true;
            end;
        end;
        tmp_grplist.Free();

        if changed then ritem.update();
        MainSession.FireEvent('/roster/item', nil, ritem);
    end;
    Self.Close;
end;

{---------------------------------------}
procedure TfrmProfile.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
    Self.TreeView1Click(Self);
end;

{---------------------------------------}
procedure TfrmProfile.btnVersionClick(Sender: TObject);
var
    jid, res: string;
    iq: TJabberIQ;
begin
    // do some CTCP queries..
    if (ResListBox.ItemIndex < 0) then exit;
    res := ResListBox.Items[ResListBox.ItemIndex];
    iq := TJabberIQ.Create(MainSession, MainSession.generateID, frmExodus.CTCPCallback);
    iq.iqType := 'get';
    jid := txtJID.Text + '/' + res;
    iq.toJID := jid;
    if Sender = btnVersion then
        iq.Namespace := XMLNS_VERSION
    else if Sender = btnTime then
        iq.Namespace := XMLNS_TIME
    else if Sender = btnLast then
        iq.Namespace := XMLNS_LAST;
    iq.Send;
end;

{---------------------------------------}
procedure TfrmProfile.lblEmailClick(Sender: TObject);
var
    url: string;
begin
    // launch a mailto link..
    if (Sender = lblURL) then
        url := txtWeb.Text
    else
        url := 'mailto:' + txtPriEmail.Text;
    ShellExecute(0, 'open', PChar(url), '', '', SW_SHOW);
end;

{---------------------------------------}
procedure TfrmProfile.btnAddGroupClick(Sender: TObject);
var
    tmps: Widestring;
begin
    // add this group to the listbox.
    tmps := txtNewGrp.Text;
    if (tmps <> '') then begin
        GrpListBox.Items.Add(tmps);
    end;
end;

procedure TfrmProfile.btnUpdateNickClick(Sender: TObject);
begin
    if (txtFirst.Text <> '') or (txtLast.Text <> '') then
        txtNick.Text := txtFirst.Text + ' ' + txtLast.Text;
end;

end.
