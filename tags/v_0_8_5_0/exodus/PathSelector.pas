unit PathSelector;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, buttonFrame, ComCtrls, ShellCtrls;

type
  TfrmPathSelector = class(TForm)
    frameButtons1: TframeButtons;
    Label1: TLabel;
    Folders: TShellTreeView;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPathSelector: TfrmPathSelector;

function browsePath(var SelectedPath: string): boolean;

implementation
{$R *.dfm}
uses
    GnuGetText;

function browsePath(var SelectedPath: string): boolean;
var
    f: TfrmPathSelector;
begin
    //
    Result := false;
    f := TfrmPathSelector.Create(nil);
    if (SelectedPath <> '') then
        f.Folders.Path := SelectedPath;

    if (f.ShowModal = mrOK) then begin
        SelectedPath := f.Folders.Path;
        Result := true;
    end;
    f.Free();
end;


procedure TfrmPathSelector.FormCreate(Sender: TObject);
begin
    TranslateProperties(Self);
end;

end.
