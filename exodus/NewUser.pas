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
    IQ, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Wizard, ComCtrls, ExtCtrls, StdCtrls, TntStdCtrls, TntExtCtrls,
    fXData;

type
  TNewUserState = (nus_list, nus_server, nus_connect, nus_user,
        nus_get, nus_xdata, nus_reg, nus_set, nus_finish);

  TfrmNewUser = class(TfrmWizard)
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    cboServer: TTntComboBox;
    tbsWait: TTabSheet;
    lblWait: TTntLabel;
    aniWait: TAnimate;
    tbsXData: TTabSheet;
    frameXData1: TframeXData;
    tbsReg: TTabSheet;
    tbsProfile: TTabSheet;
    lblBad: TTntLabel;
    lblOK: TTntLabel;
    tbsUser: TTabSheet;
    TntLabel4: TTntLabel;
    txtUsername: TTntEdit;
    TntLabel5: TTntLabel;
    txtPassword: TTntEdit;
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

    procedure _runState();
  public
    { Public declarations }
  end;

var
  frmNewUser: TfrmNewUser;

implementation
{$R *.dfm}
uses
    PrefController, Session, ExUtils;

{---------------------------------------}
procedure TfrmNewUser.FormCreate(Sender: TObject);
begin
  inherited;
    // Setup the form
    AssignUnicodeFont(Self, 9);
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
    nus_list: begin
        _state := nus_server;
        _runState();
        end;
    nus_server: begin
        _state := nus_connect;
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
procedure TfrmNewUser._runState();
begin
    // XXX: run each state
{
  TNewUserState = (nus_list, nus_server, nus_connect, nus_user,
        nus_get, nus_xdata, nus_reg, nus_set, nus_finish);
}
    case _state of
    nus_list: begin
        // XXX: fetch the list of public servers
        _state := nus_server;
        Tabs.ActivePage := TabSheet1;
        end;
    nus_connect: begin
        // XXX: try and connect to this server
        _state := nus_user;
        Tabs.ActivePage := tbsUser;
        end;
    nus_user: begin
        // XXX: send the iq-reg-get
        _state := nus_get;
        with MainSession.Profile do begin
            Server := cboServer.Text;
            Username := txtUsername.Text;
            password := txtPassword.Text;
            Resource := 'Exodus';
            SavePasswd := true;
            NewAccount := true;
        end;
        MainSession.Connect();
    end;
end;

end.
