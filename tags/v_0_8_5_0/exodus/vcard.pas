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
    Dialogs, ComCtrls, buttonFrame, StdCtrls, ExtCtrls, TntStdCtrls;

type
  TfrmVCard = class(TForm)
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label2: TLabel;
    lblEmail: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    TabSheet3: TTabSheet;
    Label12: TLabel;
    Label6: TLabel;
    Label28: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    cboOcc: TTntComboBox;
    TabSheet4: TTabSheet;
    Label13: TLabel;
    Label21: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    txtHomeCountry: TTntComboBox;
    TabSheet5: TTabSheet;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    TabSheet6: TTabSheet;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label26: TLabel;
    Label14: TLabel;
    txtWorkCountry: TTntComboBox;
    frameButtons1: TframeButtons;
    TreeView1: TTreeView;
    lblURL: TLabel;
    txtNick: TTntEdit;
    txtPriEmail: TTntEdit;
    txtFirst: TTntEdit;
    txtLast: TTntEdit;
    txtWeb: TTntEdit;
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
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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

resourcestring
    sVCardError = 'No vCard response was ever returned.';


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    GnuGetText, IQ, Session;

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
    tmps: Widestring;
    iq: TJabberIQ;
begin
    TranslateProperties(Self);

    // Hide all the tabs
    TabSheet1.TabVisible := false;
    TabSheet3.TabVisible := false;
    TabSheet4.TabVisible := false;
    TabSheet5.TabVisible := false;
    TabSheet6.TabVisible := false;

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
        MessageDlg(sVCardError,
            mtInformation, [mbOK], 0);
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

    MainSession.SendTag(iq);
    Self.Close;
end;

procedure TfrmVCard.FormDestroy(Sender: TObject);
begin
    _vcard.Free();
end;

end.
