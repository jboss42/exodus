unit SSLWarn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, ExtCtrls, buttonFrame;

type
  TfrmSSLWarn = class(TForm)
    Image1: TImage;
    lblHeader: TTntLabel;
    txtMsg: TTntMemo;
    frameButtons1: TframeButtons;
    optDisconnect: TTntRadioButton;
    optAllowSession: TTntRadioButton;
    optAllowAlways: TTntRadioButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSSLWarn: TfrmSSLWarn;

const
    sslReject = 0;
    sslAllowSession = 1;
    sslAllowAlways = 2;

function ShowSSLWarn(msg, fp: widestring): integer;

implementation

{$R *.dfm}

uses
    GnuGetText;

function ShowSSLWarn(msg, fp: widestring): integer;
var
    f: TfrmSSLWarn;
begin
    f := TfrmSSLWarn.Create(Application);
    f.txtMsg.Lines.Append(_('The SSL certificate received from the server has errors.'));
    f.txtMsg.Lines.Append(msg);
    f.txtMsg.Lines.Append(_('Certificate fingerprint: ') + fp);
    f.ShowModal();
    if (f.optDisconnect.Checked) then
        Result := sslReject
    else if (f.optAllowSession.Checked) then
        Result := sslAllowSession
    else
        Result := sslAllowAlways;
    f.Close();
end;

procedure TfrmSSLWarn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

end.
