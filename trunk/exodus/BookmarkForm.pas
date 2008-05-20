unit BookmarkForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExForm, StdCtrls, TntStdCtrls, TntForms, ExFrame, buttonFrame, Unicode,
  StateForm;

type
  TBookMarkForm = class(TfrmState)
    NameLabel: TTntLabel;
    frameButtons1: TframeButtons;
    txtName: TTntEdit;
    cboGroup: TTntComboBox;
    GroupLabel: TTntLabel;
    procedure TntFormCreate(Sender: TObject);
    procedure cboGroupChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  Form4: TForm4;

function ShowAddBookmark(var Value: WideString;
                          var Groups: TWideStringList) : Boolean;

implementation
uses Session, Exodus_TLB;
{$R *.dfm}

function ShowAddBookmark(var Value: WideString;
                         var Groups: TWideStringList) : Boolean;
var
   f: TBookMarkForm;
begin
   Result := false;
   f := TBookMarkForm.Create(Application);

   f.txtName.Text := Value;
   if (f.ShowModal = mrOK) then
   begin
       Groups.Add(f.cboGroup.Text);
       Result := true;
   end;
end;

procedure TBookMarkForm.cboGroupChange(Sender: TObject);
begin
  inherited;
  if (WideTrim(cboGroup.Text)) <> '' then
      frameButtons1.btnOK.Enabled := true
  else
      frameButtons1.btnOK.Enabled := false;
end;

procedure TBookMarkForm.TntFormCreate(Sender: TObject);
var
    i: Integer;
    Items: IExodusItemList;
begin
    inherited;
    Items := MainSession.ItemController.GetItemsByType('group');
    for i := 0 to items.Count - 1 do begin
        cboGroup.Items.Add(items.Item[i].UID);
    end;
end;

end.
