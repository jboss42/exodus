unit InputPassword;
{
    Copyright 2002, Peter Millard

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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, buttonFrame, StdCtrls, TntStdCtrls;

type
  TfrmInputPass = class(TForm)
    Label1: TLabel;
    frameButtons1: TframeButtons;
    txtPassword: TTntEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function InputQueryW(const ACaption, APrompt: WideString; var Value: WideString; password:boolean = False): Boolean;

implementation

uses
    ExUtils, GnuGetText;
{$R *.dfm}

function InputQueryW(const ACaption, APrompt: WideString; var Value: WideString; password:boolean = False): Boolean;
var
    pf: TfrmInputPass;
begin
    result := false;
    pf := TfrmInputPass.Create(Application);
    pf.Caption := ACaption;
    pf.Label1.Caption := APrompt;
    pf.txtPassword.Text := Value;
    AssignDefaultFont(pf.Font);
    if (not password) then
        pf.txtPassword.PasswordChar := #0;

    if (pf.ShowModal) = mrOK then begin
        Value := pf.txtPassword.Text;
        result := true;
    end;
    pf.Close();
end;

procedure TfrmInputPass.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmInputPass.FormCreate(Sender: TObject);
begin
    TranslateProperties(Self);
end;

end.
