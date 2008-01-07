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
  public
      Constructor Create(AOwner: TComponent);override;
      Destructor Destroy();override;

      procedure updateState();override;
      procedure initializeChildStates();override;
  published
      Property Checked: boolean read getChecked write setChecked;
      property OnCheckChanged: TNotifyEvent read _checkChangeEvent write _checkChangeEvent;
  end;

  procedure Register();

implementation

{$R *.dfm}

procedure Register();
begin
    RegisterComponents('Win32', [TExCheckGroupBox]);
end;

procedure TExCheckGroupBox.chkBoxClick(Sender: TObject);
begin
    inherited;
    //relay event
    if (Assigned(_checkChangeEvent)) then begin
        _checkChangeEvent(Sender);
    end;
    UpdateState();
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
    chkBox.Enabled := enabled;
    inherited;
end;

function TExCheckGroupBox.getChecked(): boolean;
begin
  Result := chkBox.Checked
end;

procedure TExCheckGroupBox.setChecked(b: boolean);
begin
  chkBox.Checked := b;
  if ((not (csDesigning in Self.ComponentState)) and _initialized) then begin
      enableChildren(b);
  end;
end;

procedure TExCheckGroupBox.updateState();
begin
    if (not _initialized) then
        initializeChildStates();
    inherited;

    enableChildren(Checked, true, nil);
end;

procedure TExCheckGroupBox.initializeChildStates();
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
    inherited enableChildren(e, UseInitial, tIgnore);
    if (ignore = nil) then
      tIgnore.Free();
end;

end.
