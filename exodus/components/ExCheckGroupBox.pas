unit ExCheckGroupBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ExGroupBox, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls;

type
  TExCheckGroupBox = class(TExGroupBox)
    chkBox: TTntCheckBox;
    procedure chkBoxClick(Sender: TObject);
  private
      _ignoreList: TList;
      _initialized: boolean;
      _checkChangeEvent: TNotifyEvent;
  protected
      function getChecked(): boolean;
      procedure setChecked(b: boolean);
      procedure SetEnabled(enabled: boolean);override;
      procedure enableChildren(e: boolean; useInitial: boolean = false; ignore: TList = nil); override;
      procedure Loaded();override;
  public
      Constructor Create(AOwner: TComponent);override;
      Destructor Destroy();override;

      procedure checkAutoHide();override;
      procedure captureChildStates();override;
  published
      Property Checked: boolean read getChecked write setChecked;
      property OnCheckChanged: TNotifyEvent read _checkChangeEvent write _checkChangeEvent;
  end;

  procedure Register();

implementation

{$R *.dfm}

procedure Register();
begin
    RegisterComponents('Exodus Components', [TExCheckGroupBox]);
end;

procedure OutputDebugMsg(Message : String);
begin
    OutputDebugString(PChar(Message));
end;

procedure TExCheckGroupBox.Loaded();
begin
    inherited;
    if (lblCaption.Visible and
       (lblCaption.Caption <> 'ExGroupBox') and
       (not (csDesigning in ComponentState))) then begin
        chkBox.Caption := lblCaption.Caption;
        chkBox.Width := chkBox.Width + lblCaption.Width + 9;
        lblCaption.Visible := false;
    end;
end;

procedure TExCheckGroupBox.chkBoxClick(Sender: TObject);
begin
    inherited;
    //only update children if we have been "initialized". We
    //don't want to step on initial child states...
    if (not _initialized) then exit;

    //relay event
    if (Assigned(_checkChangeEvent)) then begin
        _checkChangeEvent(Sender);
    end;
    enableChildren(Checked, true, nil);
end;

Constructor TExCheckGroupBox.create(AOwner: TComponent);
begin
    inherited;
    _ignoreList := nil;
    _initialized := false;
end;

Destructor TExCheckGroupBox.Destroy;
begin
  if (_ignoreList <> nil) then
    _ignoreList.Free();
  inherited;
end;

procedure TExCheckGroupBox.setEnabled(enabled: boolean);
begin
    chkBox.Enabled := CanEnabled and enabled;
    inherited;
end;

function TExCheckGroupBox.getChecked(): boolean;
begin
    Result := chkBox.Checked
end;

procedure TExCheckGroupBox.setChecked(b: boolean);
begin
    chkBox.Checked := b;
    if _initialized then enableChildren(b, true, nil);
end;

procedure TExCheckGroupBox.checkAutoHide();
begin
    if (not _initialized) then
        captureChildStates();

    inherited;
end;

procedure TExCheckGroupBox.captureChildStates();
begin
    inherited;
    _initialized := true;
end;

procedure TExCheckGroupBox.enableChildren(e: boolean; useInitial: boolean; ignore: TList);
var
    tIgnore: TList;
begin
    //add check box to ignore list and call inherited handler
    if (ignore = nil) then
      tIgnore := TList.Create()
    else
      tIgnore := ignore;

    tIgnore.Add(chkBox);
    //only enable children if we are checked.
    inherited enableChildren(e and Checked, UseInitial, tIgnore);
    if (ignore = nil) then
      tIgnore.Free();
end;

end.
