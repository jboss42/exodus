unit vcard;
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
    XMLVCard,
    XMLTag,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, buttonFrame, StdCtrls, ExtCtrls, TntStdCtrls,
    TntComCtrls, ExtDlgs;

type
  TfrmVCard = class(TForm)
    Splitter1: TSplitter;
    PageControl1: TTntPageControl;
    TabSheet1: TTntTabSheet;
    TabSheet3: TTntTabSheet;
    Label12: TTntLabel;
    Label6: TTntLabel;
    Label28: TTntLabel;
    Label8: TTntLabel;
    Label9: TTntLabel;
    cboOcc: TTntComboBox;
    TabSheet4: TTntTabSheet;
    Label13: TTntLabel;
    Label21: TTntLabel;
    Label29: TTntLabel;
    Label30: TTntLabel;
    Label31: TTntLabel;
    Label32: TTntLabel;
    txtHomeCountry: TTntComboBox;
    TabSheet5: TTntTabSheet;
    Label22: TTntLabel;
    Label23: TTntLabel;
    Label24: TTntLabel;
    Label19: TTntLabel;
    Label20: TTntLabel;
    TabSheet6: TTntTabSheet;
    Label15: TTntLabel;
    Label16: TTntLabel;
    Label17: TTntLabel;
    Label18: TTntLabel;
    Label26: TTntLabel;
    Label14: TTntLabel;
    txtWorkCountry: TTntComboBox;
    frameButtons1: TframeButtons;
    txtBDay: TTntEdit;
    txtHomeVoice: TTntEdit;
    txtHomeFax: TTntEdit;
    txtHomeState: TTntEdit;
    txtHomeZip: TTntEdit;
    txtHomeCity: TTntEdit;
    txtHomeStreet2: TTntEdit;
    txtHomeStreet1: TTntEdit;
    txtOrgName: TTntEdit;
    txtOrgUnit: TTntEdit;
    txtOrgTitle: TTntEdit;
    txtWorkVoice: TTntEdit;
    txtWorkFax: TTntEdit;
    txtWorkState: TTntEdit;
    txtWorkZip: TTntEdit;
    txtWorkCity: TTntEdit;
    txtWorkStreet2: TTntEdit;
    txtWorkStreet1: TTntEdit;
    memDesc: TTntMemo;
    Label1: TTntLabel;
    TreeView1: TTntTreeView;
    OpenPic: TOpenPictureDialog;
    TntLabel1: TTntLabel;
    PaintBox1: TPaintBox;
    btnPicBrowse: TTntButton;
    Label2: TTntLabel;
    lblEmail: TTntLabel;
    Label7: TTntLabel;
    Label5: TTntLabel;
    lblURL: TTntLabel;
    txtNick: TTntEdit;
    txtPriEmail: TTntEdit;
    txtFirst: TTntEdit;
    txtLast: TTntEdit;
    txtWeb: TTntEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPicBrowseClick(Sender: TObject);
  private
    { Private declarations }
    _vcard: TXMLVCard;
    procedure Callback(event: string; tag: TXMLTag);
  public
    { Public declarations }
  end;

var
  frmVCard: TfrmVCard;

procedure ShowMyProfile;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    Avatar, JabberUtils, ExUtils,  GnuGetText, IQ, Session;
const
    sVCardError = 'No vCard response was ever returned.';

{---------------------------------------}
procedure ShowMyProfile;
var
    f: TfrmVCard;
begin
    f := TfrmVCard.Create(Application);
    f.Show;
end;

{---------------------------------------}
procedure TfrmVCard.FormCreate(Sender: TObject);
var
    n: TTntTreeNode;
    i: integer;
    tmps: Widestring;
    iq: TJabberIQ;
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);

    // Hide all the tabs
    TabSheet1.TabVisible := false;
    TabSheet3.TabVisible := false;
    TabSheet4.TabVisible := false;
    TabSheet5.TabVisible := false;
    TabSheet6.TabVisible := false;

    // Do this to ensure the nodes are properly translated.
         TreeView1.Items.Clear();
         TreeView1.Items.Add(nil,       _('Basic'));
    n := TreeView1.Items.AddChild(nil,  _('Personal Information'));
         TreeView1.Items.AddChild(n,    _('Address'));
    n := TreeView1.Items.AddChild(nil,  _('Work Information'));
         TreeView1.Items.AddChild(n,    _('Address'));

    for i := 0 to TreeView1.Items.Count - 1 do
        TreeView1.Items[i].Expand(true);

    PageControl1.ActivePageIndex := 0;
    TreeView1.FullExpand();
    MainSession.Prefs.RestorePosition(Self);

    _vcard := TXMLVCard.Create();

    tmps := MainSession.generateID();
    iq := TJabberIQ.Create(MainSession, tmps, Callback);
    iq.qTag.Name := 'VCARD';
    iq.Namespace := 'vcard-temp';
    iq.iqType := 'get';
    iq.toJid := MainSession.Username + '@' + MainSession.Server;
    iq.Send();
end;

{---------------------------------------}
procedure TfrmVCard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    MainSession.Prefs.SavePosition(Self);
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmVCard.Callback(event: string; tag: TXMLTag);
begin
    // callback for vcard info
    if (tag = nil) then begin
        MessageDlgW(_(sVCardError), mtInformation, [mbOK], 0);
        exit;
    end;
    
    _vcard.parse(tag);

    with _vcard do begin
        txtFirst.Text := GivenName;
        txtLast.Text := FamilyName;
        txtNick.Text := nick;
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

        if (Picture <> nil) then
            Picture.Draw(PaintBox1.Canvas);
    end;
end;

{---------------------------------------}
procedure TfrmVCard.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmVCard.TreeView1Click(Sender: TObject);
begin
    PageControl1.ActivePageIndex := TreeView1.Selected.AbsoluteIndex;
end;

{---------------------------------------}
procedure TfrmVCard.frameButtons1btnOKClick(Sender: TObject);
var
    iq: TXMLTag;
begin
    // Save the vcard..
    with _vcard do begin
        GivenName := txtFirst.Text;
        FamilyName := txtLast.Text;
        nick := txtNick.Text;
        email := txtPriEmail.Text;
        url := txtWeb.Text;
        role := cboOcc.Text;
        bday := txtBday.Text;
        Desc := memDesc.Lines.Text;

        WorkPhone.number := txtWorkVoice.Text;
        WorkPhone.work := true; WorkPhone.voice := true;

        WorkFax.number := txtWorkFax.Text;
        WorkFax.work := true; WorkPhone.fax := true;

        HomePhone.number := txtHomeVoice.Text;
        HomePhone.home := true; HomePhone.voice := true;

        HomeFax.number := txtHomeFax.Text;
        HomeFax.home := true; HomePhone.fax := true;

        with work do begin
            work := true;
            home := false;
            Street := txtWorkStreet1.Text;
            ExtAdr := txtWorkStreet2.Text;
            Locality := txtWorkCity.Text;
            Region := txtWorkState.Text;
            PCode := txtWorkZip.Text;
            Country := txtWorkCountry.Text;
        end;

        with Home do begin
            home := true;
            work := false;
            Street := txtHomeStreet1.Text;
            ExtAdr := txtHomeStreet2.Text;
            Locality := txtHomeCity.Text;
            Region := txtHomeState.Text;
            PCode := txtHomeZip.Text;
            Country := txtHomeCountry.Text;
        end;

        OrgName := txtOrgName.Text;
        OrgUnit := txtOrgUnit.Text;
        OrgTitle := txtOrgTitle.Text;
    end;

    iq := TXMLTag.Create('iq');
    iq.setAttribute('id', MainSession.generateID());
    iq.setAttribute('type', 'set');
    _vcard.fillTag(iq);

    // save this hash to the profile..
    if (_vcard.Picture <> nil) then begin
        MainSession.Profile.Avatar := _vcard.Picture.Data;
        MainSession.Profile.AvatarHash := _vcard.Picture.getHash();
        MainSession.Profile.AvatarMime := _vcard.Picture.MimeType;
        MainSession.Prefs.SaveProfiles();
        MainSession.setPresence(MainSession.Show, MainSession.Status,
            MainSession.Priority);
    end;

    MainSession.SendTag(iq);
    Self.Close;
end;

{---------------------------------------}
procedure TfrmVCard.FormDestroy(Sender: TObject);
begin
    _vcard.Free();
end;

{---------------------------------------}
procedure TfrmVCard.btnPicBrowseClick(Sender: TObject);
var
    a: TAvatar;
begin
    // browse for a new vcard picture
    if (OpenPic.Execute()) then begin
        a := TAvatar.Create();
        a.LoadFromFile(OpenPic.FileName);
        if (not a.Valid) then begin
            a.Free();
        end
        else begin
            // a is valid
            if (_vcard.Picture <> nil) then
                _vcard.Picture.Free();
            _vcard.Picture := a;
            _vcard.Picture.Draw(PaintBox1.Canvas);
        end;
    end;
end;

end.
