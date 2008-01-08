unit ExGroupBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TntExtCtrls, StdCtrls, TntStdCtrls, ExFrame, Contnrs,
  ExBrandPanel;


type
  TExGroupBox = class(TExBrandPanel)
    pnlTop: TTntPanel;
    lblCaption: TTntLabel;
    pnlBevel: TTntPanel;
    TntBevel1: TTntBevel;

  private

  protected
    function getCaption(): WideString;
    procedure setCaption(c: widestring);
    function visibleChildren(): integer; override;
    procedure enableChildren(e: boolean; useInitial: boolean = false; ignore: TList = nil); override;
    procedure SetEnabled(enabled: boolean);override;

  published
    property Caption: WideString read getCaption write setCaption;
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

procedure TExGroupBox.setEnabled(enabled: boolean);
begin
    //disable/enable title as well as children
    Self.lblCaption.Enabled := CanEnabled and enabled;
    Self.TntBevel1.Enabled := CanEnabled and enabled;
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

procedure TExGroupBox.enableChildren(e: boolean; useInitial: boolean = false; ignore: TList = nil);
var
    tIgnore: TList;
begin
    //add top panel to ignore list and call inherited handler
    if (ignore = nil) then
      tIgnore := TList.Create()
    else
      tIgnore := ignore;
    tIgnore.Add(pnlTop);

    inherited enableChildren(e, UseInitial, tIgnore);
    
    if (ignore = nil) then
      tIgnore.Free();
end; 


end.
