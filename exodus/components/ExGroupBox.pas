unit ExGroupBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TntExtCtrls, StdCtrls, TntStdCtrls, ExFrame, Contnrs,
  ExBrandPanel;


type
  TExGroupBox = class(TExBrandPanel)
  private
    _pnlTop: TTntPanel;
    _pnlBevel: TTntPanel;
    _bevel: TTntBevel;
    _lblCaption: TTntLabel;
  protected
    //creates top panel and caption label
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure Loaded();override;
    function GetCaption(): WideString;
    procedure SetCaption(c: widestring); 

    function VisibleChildren(): integer; override;
    procedure EnableChildren(e: boolean; useInitial: boolean = false; ignore: TList = nil); override;
    procedure SetEnabled(enabled: boolean);override;
  public
    Constructor Create(AOwner: TComponent);override;
    Destructor Destroy; Override;

  published
    property Caption: WideString read getCaption write setCaption;
  end;

  procedure Register();

implementation
uses
  Consts;

procedure Register();
begin
  RegisterComponents('Exodus Components', [TExGroupBox]);
end;

Constructor TExGroupBox.Create(AOwner: TComponent);
begin
    inherited;

    _pnlTop := TTntPanel.Create(Self);
    _pnlTop.Parent := Self;
    _pnlTop.Name := 'pnlTop';

    _pnlBevel := TTntPanel.Create(_pnlTop);
    _pnlBevel.Parent := _pnlTop;
    _pnlBevel.Name := 'pnlBevel';
    _pnlBevel.Caption := '';
    
    _bevel := TTntBevel.Create(_pnlBevel);
    _bevel.parent := _pnlBevel;
    _bevel.Shape := bsTopLine;
    _bevel.Name := 'bevel';
    
    _lblCaption := TTntLabel.Create(_pnlTop);
    _lblCaption.parent := _pnlTop;
    _lblCaption.Name := 'lblCaption';
end;

Destructor TExGroupBox.Destroy;
begin
    inherited;
end;

procedure TExGroupBox.CreateWindowHandle(const Params: TCreateParams);
begin
    //get everyting lined up just right
    _pnlTop.Height := 18;
    _pnlTop.Align := alTop;
    _pnlTop.caption := '';
    _pnlTop.BevelOuter := bvNone;
    _pnlTop.ParentFont := true;
    _pnlTop.ParentColor := True;
    _pnlTop.TabStop := false;

    _lblCaption.Align := alLeft;
    _lblCaption.AutoSize := true;
    _lblCaption.ParentColor := true;
    _lblCaption.ParentFont := true;
    _lblCaption.ShowAccelChar := False;
    _lblCaption.Alignment := taCenter;

    _pnlBevel.Align := alClient;
    _pnlBevel.BevelOuter := bvNone;
    _pnlBevel.ParentFont := true;
    _pnlBevel.ParentColor := True;
    _pnlBevel.TabStop := false;

    _bevel.Align := alNone;
    _bevel.Left := 3;
    _bevel.Width := _pnlBevel.Width - 3;
    _bevel.Top := 9;
    _bevel.Anchors := [akTop, akleft, akRight];

    inherited;
end;

procedure TExGroupBox.Loaded();
begin
    inherited;
    //force a resize of our caption
    Self.Caption := Self.Caption;
end;

function TExGroupBox.getCaption(): WideString;
begin
    Result := _lblCaption.Caption;
end;

procedure TExGroupBox.setCaption(c: widestring);
begin
    _lblCaption.Caption := c;
    _lblCaption.AutoSize := false; //force a resize
    _lblCaption.AutoSize := true;
end;

procedure TExGroupBox.setEnabled(enabled: boolean);
begin
    //disable/enable title as well as children
    Self._lblCaption.Enabled := CanEnabled and enabled;
    Self._bevel.Enabled := CanEnabled and enabled;
    inherited;
end;

function TExGroupBox.visibleChildren(): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to Self.ControlCount -1 do begin
    if (Self.Controls[i].Visible and (Self.Controls[i].Name <> 'pnlTop')) then
      inc(Result);
  end;
end;

procedure TExGroupBox.enableChildren(e: boolean; useInitial: boolean; ignore: TList);
var
    tIgnore: TList;
begin
    //add top panel to ignore list and call inherited handler
    if (ignore = nil) then
      tIgnore := TList.Create()
    else
      tIgnore := ignore;
    tIgnore.Add(_pnlTop);

    inherited enableChildren(e, UseInitial, tIgnore);
    
    if (ignore = nil) then
      tIgnore.Free();
end; 


end.
