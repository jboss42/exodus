unit SelContact;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fRosterTree, buttonFrame;

type
  TfrmSelContact = class(TForm)
    frameButtons1: TframeButtons;
    frameTreeRoster1: TframeTreeRoster;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure frameTreeRoster1treeRosterDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetSelectedJID(): string;
  end;

var
  frmSelContact: TfrmSelContact;

implementation

{$R *.dfm}
uses
    Roster, ComCtrls;

procedure TfrmSelContact.FormCreate(Sender: TObject);
begin
    frameTreeRoster1.Initialize();
end;

procedure TfrmSelContact.FormDestroy(Sender: TObject);
begin
    frameTreeRoster1.Cleanup();
end;

procedure TfrmSelContact.frameTreeRoster1treeRosterDblClick(
  Sender: TObject);
begin
    if (frameTreeRoster1.treeRoster.Selected = nil) then exit;
    if (frameTreeRoster1.treeRoster.Selected.Level = 0) then exit;

    Self.ModalResult := mrOK;
    Self.Hide();
end;

function TfrmSelContact.GetSelectedJID(): string;
var
    n: TTreeNode;
begin
    Result := '';
    n := frameTreeRoster1.treeRoster.Selected;
    if (n = nil) then exit;
    if (n.Level = 0) then exit;

    Result := TJabberRosterItem(n.Data).jid.full;
end;

end.
