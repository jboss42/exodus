unit Prefs;

interface

uses
    LoggerPlugin, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, TntStdCtrls;

type
  TfrmPrefs = class(TForm)
    txtLogPath: TTntEdit;
    btnLogBrowse: TTntButton;
    chkLogRooms: TTntCheckBox;
    btnLogClearAll: TTntButton;
    chkLogRoster: TTntCheckBox;
    TntLabel1: TTntLabel;
    TntButton1: TTntButton;
    TntButton2: TTntButton;
    procedure btnLogClearAllClick(Sender: TObject);
    procedure btnLogBrowseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Logger: THTMLLogger;
  end;

var
  frmPrefs: TfrmPrefs;

implementation
{$WARN UNIT_PLATFORM OFF}
{$R *.dfm}

uses
    FileCtrl;

const
    sPrefsLogDir = 'Select log directory';

procedure TfrmPrefs.btnLogClearAllClick(Sender: TObject);
begin
    Logger.purgeLogs();
end;

procedure TfrmPrefs.btnLogBrowseClick(Sender: TObject);
var
    tmps: string;
begin
    tmps := txtLogPath.Text;
    if SelectDirectory(sPrefsLogDir, '', tmps) then
        txtLogPath.Text := tmps;
end;

end.
