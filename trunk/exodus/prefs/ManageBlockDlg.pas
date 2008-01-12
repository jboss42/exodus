unit ManageBlockDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  Unicode,
  TnTClasses,
  ExForm, StdCtrls, TntStdCtrls, TntForms, ExFrame, ExBrandPanel;

type
  TManageBlockDlg = class(TExForm)
    ExBrandPanel1: TExBrandPanel;
    lblBlockIns: TTntLabel;
    memBlocks: TTntMemo;
    btnOK: TTntButton;
    btnCancel: TTntButton;
    procedure TntFormCreate(Sender: TObject);
  private
  public
    procedure setBlockers(blockers: TWideStringList);
    procedure getBlockers(blockers: TWideStringList);
  end;

implementation

{$R *.dfm}
uses
    PrefController,
    ExUtils;

procedure TManageBlockDlg.TntFormCreate(Sender: TObject);
begin
    inherited;
    AssignUnicodeFont(memBlocks.Font, 10);
end;

procedure TManageBlockDlg.setBlockers(blockers: TWideStringList);
begin
    memBlocks.Lines.BeginUpdate();
    memBlocks.lines.clear();
    AssignTntStrings(blockers,memBlocks.lines);
    memBlocks.lines.EndUpdate();
end;

procedure TManageBlockDlg.getBlockers(blockers: TWideStringList);
var
    i: integer;
begin
    blockers.Clear();
    for i := 0 to memBlocks.lines.Count - 1 do
        blockers.Add(memBlocks.lines[i]);
end;

end.
