unit NewUser;
{
    Copyright 2005, Peter Millard

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
    IQ, XMLTag, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Wizard, ComCtrls, ExtCtrls, StdCtrls, TntStdCtrls, TntExtCtrls,
    fXData;

type
  TNewUserState = (nus_init, nus_list, nus_connect, nus_user,
        nus_get, nus_xdata, nus_reg, nus_set, nus_error, nus_finish);

  TfrmNewUser = class(TfrmWizard)
    TntLabel1: TTntLabel;
    cboServer: TTntComboBox;
    tbsWait: TTabSheet;
    lblWait: TTntLabel;
    aniWait: TAnimate;
    tbsXData: TTabSheet;
    xData: TframeXData;
    tbsReg: TTabSheet;
    tbsFinish: TTabSheet;
    lblBad: TTntLabel;
    lblOK: TTntLabel;
    tbsUser: TTabSheet;
    TntLabel4: TTntLabel;
    txtUsername: TTntEdit;
    TntLabel5: TTntLabel;
    txtPassword: TTntEdit;
    optServer: TTntRadioButton;
    optPublic: TTntRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    _state: TNewUserState;
    _server: Widestring;
    _username: Widestring;
    _password: Widestring;
    _iq: TJabberIQ;
    _have_public_servers: boolean;
    _session_cb: integer;

    procedure _runState();
    procedure _fetchServers();
    procedure _wait();
    procedure _doneWait();
  published
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure RegGetCallback(event: string; tag: TXMLTag);
    procedure RegSetCallback(event: string; tag: TXMLTag);
  public
    { Public declarations }
  end;

var
  frmNewUser: TfrmNewUser;

procedure ShowNewUserWizard();

implementation
{$R *.dfm}
uses
    GnuGetText, 
    WebGet, XMLParser, Unicode, PrefController, Session, ExUtils;

{---------------------------------------}
procedure ShowNewUserWizard();
begin
    frmNewUser := TfrmNewUser.Create(nil);
    frmNewUser.Show();
end;

{---------------------------------------}
procedure TfrmNewUser.FormCreate(Sender: TObject);
var
    i: integer;
    list: TWidestringlist;
begin
  inherited;
    // Setup the form
    AssignUnicodeFont(Self, 9);

    _state := nus_init;
    _have_public_servers := false;
    _iq := nil;

    TabSheet1.TabVisible := false;
    tbsUser.TabVisible := false;
    tbsWait.TabVisible := false;
    tbsXData.TabVisible := false;
    tbsReg.TabVisible := false;
    tbsFinish.TabVisible := false;
    
    Tabs.ActivePage := TabSheet1;

    // the default list is brandable
    list := TWideStringList.Create();
    MainSession.Prefs.fillStringList('brand_profile_server_list', list);
    if (list.Count > 0) then begin
        cboServer.Items.Clear();
        for i := 0 to list.Count - 1 do
            cboServer.Items.Add(list[i]);
    end;

    // auto-select the first thing in the list
    if (cboServer.Items.Count > 0) then
        cboServer.ItemIndex := 0;

    _session_cb := MainSession.RegisterCallback(Self.SessionCallback, '/session');
end;

{---------------------------------------}
procedure TfrmNewUser.btnNextClick(Sender: TObject);
begin
  inherited;
  {
  TNewUserState = (nus_list, nus_server, nus_connect, nus_user,
        nus_get, nus_xdata, nus_reg, nus_set, nus_finish);
  }
    // goto the next state
    case _state of
    nus_init: begin
        if (optServer.Checked) then
            _state := nus_connect
        else
            _state := nus_list;
        _runState();
    end;
    nus_user: begin
        _state := nus_get;
        _runState();
    end;
    nus_xdata: begin
        _state := nus_set;
        _runState();
    end;
    nus_reg: begin
        _state := nus_set;
        _runState();
    end;
    nus_finish: begin
        Self.Close();
    end;
    end;
end;

{---------------------------------------}
procedure TfrmNewUser.btnBackClick(Sender: TObject);
begin
  inherited;
    // XXX: implement back functionality
end;

{---------------------------------------}
procedure TfrmNewUser.btnCancelClick(Sender: TObject);
begin
  inherited;
    // XXX: implement cancel functionality
end;

{---------------------------------------}
procedure TfrmNewUser._fetchServers();
var
    slist: string;
    parser: TXMLTagParser;
    q: TXMLTag;
    items: TXMLTagList;
    i: integer;
begin
    slist := ExWebDownload(_('New User Wizard'), 'http://www.jabber.org/servers.xml');
    if (slist = '') then exit;
    parser := TXMLTagParser.Create();
    parser.ParseString(slist, '');
    if (parser.Count > 0) then begin
        q := parser.popTag();
        items := q.QueryTags('item');
        if (items.Count > 0) then
            cboServer.Items.Clear();
        for i := 0 to items.Count - 1 do
            cboServer.Items.Add(items[i].getAttribute('jid'));
        items.Free();
        q.Free();
    end;
    parser.Free();
end;

{---------------------------------------}
procedure TfrmNewUser.SessionCallback(event: string; tag: TXMLTag);
begin
    //
    if (_state = nus_connect) then begin
        if (event = '/session/connected') then
            _state := nus_user
        else if (event = '/session/commerror') then
            _state := nus_error;

        if (_state <> nus_connect) then
            _runState();
    end;
end;

{---------------------------------------}
procedure TfrmNewUser.RegGetCallback(event: string; tag: TXMLTag);
begin
    //
    assert(_state = nus_get);
    
end;

{---------------------------------------}
procedure TfrmNewUser.RegSetCallback(event: string; tag: TXMLTag);
begin
    //
end;

{---------------------------------------}
procedure TfrmNewUser._wait();
begin
    Tabs.ActivePage := tbsWait;
    aniWait.Active := true;
end;

{---------------------------------------}
procedure TfrmNewUser._doneWait();
begin
    aniWait.Active := false;
end;

{---------------------------------------}
procedure TfrmNewUser._runState();
var
    x: TXMLTag;
begin
    // XXX: run each state
    {
      TNewUserState = (nus_list, nus_server, nus_connect, nus_user,
            nus_get, nus_xdata, nus_reg, nus_set, nus_finish);
    }
    case _state of
    nus_list: begin
        // fetch the list of public servers
        _wait();
        _fetchServers();
        _doneWait();
        _state := nus_init;
        _have_public_servers := true;
        optPublic.Enabled := false;
        optServer.Checked := true;
    end;
    nus_connect: begin
        // XXX: try and connect to this server
        // XXX: DO SRV lookups here??
        _server := cboServer.Text;
        MainSession.NoAuth := true;
        with MainSession.Profile do begin
            Port := 5222;
            ssl := 0;
            Server := _server;
            Host := _server;
            ResolvedIP := _server;
            ResolvedPort := 5222;
        end;
        MainSession.Prefs.SaveProfiles();
        Tabs.ActivePage := tbsWait;
        aniWait.Active := true;
        MainSession.Connect();
    end;
    nus_user: begin
        Tabs.ActivePage := tbsUser;
    end;
    nus_get: begin
        // send the iq-reg-get
        _state := nus_get;
        with MainSession.Profile do begin
            Username := txtUsername.Text;
            password := txtPassword.Text;
            Resource := 'Exodus';
            SavePasswd := true;
            NewAccount := true;
        end;

        _iq := TJabberIQ.Create(MainSession, MainSession.generateID(),
            RegGetCallback, 30);
        _iq.Namespace := 'jabber:iq:register';
        _iq.iqType := 'get';
        x := _iq.qTag.AddTag('username');
        x.AddCData(txtUsername.Text);
        _iq.Send();
    end;

    end;
end;

end.
