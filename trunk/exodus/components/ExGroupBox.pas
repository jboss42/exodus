unit ExGroupBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TntExtCtrls, StdCtrls, TntStdCtrls, ExFrame, Contnrs;

type
  TExGroupBoxStyle = (gbsNone, gbsLabel{, gbsCheck});

  TControlInfo = class
    _control: TControl;
    _visible: boolean;
    _enabled: boolean;
  end;

  TExGroupBox = class(TFrame)
    pnlTop: TTntPanel;
    lblCaption: TTntLabel;
    pnlBevel: TTntPanel;
    TntBevel1: TTntBevel;

  private
    _style: TExGroupBoxStyle;
    _autoHide: boolean;
    //since we may be "disabling" an already disabled child, we don't want to
    //enable that child when mass enabling. track initial enabled and visible
    //states of children
    _initialStates: TObjectList; //of TControlInfo

    function visibleChildren(): integer;
    procedure enableChildren(e: boolean);

    procedure initialize();

  protected
    function getCaption(): WideString;
    procedure setCaption(c: widestring);
    function getStyle(): TExGroupBoxStyle;
    procedure setStyle(s: TExGroupBoxStyle);
    function getAutoHide(): boolean;
    procedure setAutoHide(b: boolean);
    function getChecked(): boolean;
    procedure setChecked(b: boolean);

    //initialize controls
    procedure Loaded(); override;
  public
    Destructor Destroy; Override;
    procedure updateBox();
  published
    property Caption: WideString read getCaption write setCaption;
    property BoxStyle: TExGroupBoxStyle read getStyle write setStyle;
    property AutoHide: boolean read getAutoHide write setAutoHide;
    Property Checked: boolean read getChecked write setChecked;
  end;

  procedure Register();
implementation

{$R *.dfm}
uses
  Consts;
procedure Register();
begin
  RegisterComponents('Win32', [TExGroupBox]);
end;

Destructor TExGroupBox.Destroy;
begin
  if (_initialStates <> nil) then
    _initialStates.Free();
  inherited;
end;

procedure TExGroupBox.Loaded();
begin
  inherited;
  initialize();
  updateBox();
end;

function TExGroupBox.getCaption(): WideString;
begin
  Result := lblCaption.Caption;
end;

procedure TExGroupBox.setCaption(c: widestring);
begin
  lblCaption.Caption := c;
end;

function TExGroupBox.getStyle(): TExGroupBoxStyle;
begin
  Result := _style;
end;

procedure TExGroupBox.setStyle(s: TExGroupBoxStyle);
begin
  _style := s;
end;

function TExGroupBox.getAutoHide(): boolean;
begin
  Result := _autoHide;
end;

procedure TExGroupBox.setAutoHide(b: boolean);
begin
  _autoHide := b;
//  if (_autoHide and not(csDesigning in Self.ComponentState)) then
//    updateBox();
end;

function TExGroupBox.getChecked(): boolean;
begin
  Result := false;//chkGroup.Checked;
end;

procedure TExGroupBox.setChecked(b: boolean);
begin
  //nop
  {
  chkGroup.Checked := b;
  if ((_style = gbsCheck) and
      (([csLoading, csDesigning] * Self.ComponentState) = [])) then
    enableChildren(chkGroup.Checked);
  }
end;

//private methods
function TExGroupBox.visibleChildren(): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to Self.ControlCount -1 do begin
    if (Self.Controls[i].Visible) and (Self.Controls[i].Name <> 'pnlTop') then
      inc(Result);
  end;
end;

procedure TExGroupBox.enableChildren(e: boolean);
var
  i: integer;
begin
  //use initial enabled state
  for i := 0 to _initialStates.Count -1 do begin
//    TControl(TControlInfo(_initialStates[i])._control).Enabled := TControlInfo(_initialStates[i])._enabled and e;
  end;
end;

procedure TExGroupBox.initialize();
var
  i: integer;
  t: TControlInfo;
begin
  if (csDesigning in Self.ComponentState) then exit;
  if (_initialStates = nil) then
    _initialStates := TObjectList.Create();
  //walk pnlGroups children and get their initial states
  for i := 0 to Self.ControlCount -1 do begin
    if (Self.Controls[i].Name <> 'pnlTop') then begin
      t := TControlInfo.create();
      t._control := Self.Controls[i];
      t._visible := Self.Controls[i].visible;
      t._enabled := Self.Controls[i].enabled;
      _initialStates.Add(t);
    end;
  end;
end;

procedure TExGroupBox.updateBox();
var
  i: integer;
begin
  if (csDesigning in Self.ComponentState) then exit;
  //update any TExGroupBox children we have first so we can reliably check
  //visiblity states
  for i := 0 to Self.ControlCount - 1 do begin
    if (Self.Controls[i] is TExGroupBox) then
      TExGroupBox(Self.Controls[i]).updateBox();
  end;

  Self.Visible := (not _autoHide) or (visibleChildren() > 0);

  //set style bits
  lblCaption.Visible := (_style <> gbsNone);
//  chkGroup.Visible := (_style = gbsCheck);
  pnlTop.Visible := (_style <> gbsNone);
end;
end.
