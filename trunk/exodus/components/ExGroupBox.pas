unit ExGroupBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TntExtCtrls, StdCtrls, TntStdCtrls, ExFrame, Contnrs,
  ExBrandPanel;


type
  TExGroupBoxStyle = (gbsNone, gbsLabel{, gbsCheck});

  TExGroupBox = class(TExBrandPanel)
    pnlTop: TTntPanel;
    lblCaption: TTntLabel;
    pnlBevel: TTntPanel;
    TntBevel1: TTntBevel;

  private
    _style: TExGroupBoxStyle;

  protected
    function getCaption(): WideString;
    procedure setCaption(c: widestring);
    function getStyle(): TExGroupBoxStyle;
    procedure setStyle(s: TExGroupBoxStyle);
    function getChecked(): boolean;
    procedure setChecked(b: boolean);

    function visibleChildren(): integer; override;

  public
    procedure updateState();override;
  published
    property Caption: WideString read getCaption write setCaption;
    property BoxStyle: TExGroupBoxStyle read getStyle write setStyle;
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

procedure TExGroupBox.updateState();
begin
  if (csDesigning in Self.ComponentState) then exit;

  inherited updateState();

  //set style bits
  lblCaption.Visible := (_style <> gbsNone);
//  chkGroup.Visible := (_style = gbsCheck);
  pnlTop.Visible := (_style <> gbsNone);
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

end.
