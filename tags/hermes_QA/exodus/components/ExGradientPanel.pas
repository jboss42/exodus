unit ExGradientPanel;

interface

uses
  SysUtils,
  Classes,
  Controls,
  ExtCtrls,
  Windows,
  JCLGraphics,
  Graphics;

type
  TGradientProps = class(TPersistent)
      private
        _startColor: TColor;
        _endColor: TColor;
        _orientation: TGradientDirection;
      protected
      public
        procedure Assign(Source: TPersistent); override;
      published
        property startColor: TColor read _startColor write _startColor;
        property endColor: TColor read _endColor write _endColor;
        property orientation: TGradientDirection read _orientation write _orientation;
  end;

  TExGradientPanel = class(TPanel)
  private
    { Private declarations }
    _gprops: TGradientProps;
    procedure setProps(Value: TGradientProps);
  protected
    { Protected declarations }
    procedure Paint(); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property GradientProperites: TGradientProps read _gprops write setProps;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Exodus Components', [TExGradientPanel]);
end;

procedure TGradientProps.Assign(Source: TPersistent);
begin
    if (Source is TGradientProps) then
    begin
        _startColor := TGradientProps(Source).startColor;
        _endColor := TGradientProps(Source).endColor;
        _orientation := TGradientProps(Source).orientation;
        inherited Assign(Source);
    end;
end;

constructor TExGradientPanel.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    _gprops := TGradientProps.Create;
end;

destructor TExGradientPanel.Destroy;
begin
    _gprops.Free();
    inherited Destroy;
end;

procedure TExGradientPanel.setProps(Value: TGradientProps);
begin
    if (assigned(value)) then
    begin
        _gprops.Assign(Value);
    end;
end;

procedure TExGradientPanel.Paint();
var
    r: TRect;
begin
    inherited paint();

    if (self.BevelOuter <> bvNone) then begin
        r.Top := self.BevelWidth;
        r.Left := self.BevelWidth;
        r.Bottom := self.Height - (self.BevelWidth);
        r.Right := self.Width - (self.BevelWidth);
    end
    else begin
        r.Top := 0;
        r.Left := 0;
        r.Bottom := self.Height;
        r.Right := self.Width;
    end;

    FillGradient(canvas.Handle, r, 256, _gprops.startColor, _gprops.endColor, _gprops.orientation);
end;





end.

