unit Password;
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

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, buttonFrame, TntStdCtrls;

type
  TfrmPassword = class(TForm)
    Label1: TTntLabel;
    txtOldPassword: TTntEdit;
    frameButtons1: TframeButtons;
    Label2: TTntLabel;
    txtNewPassword: TTntEdit;
    Label3: TTntLabel;
    txtConfirmPassword: TTntEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPassword: TfrmPassword;

implementation

{$R *.dfm}
uses
    ExUtils, GnuGetText;

procedure TfrmPassword.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self);
    TranslateProperties(Self);
end;

end.
 
