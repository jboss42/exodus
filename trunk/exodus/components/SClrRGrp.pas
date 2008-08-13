unit SClrRGrp;
{
More Extended TBevel Component for Kylix
to color the bevels.
made by Endre I. Simay, Hungary, 2001.
}

{
Code from http://www.torry.net (license: Freeware With Source)
modified to work with BDS 2006.

Douglas Abbink, 2008
}

interface

uses
  SysUtils, Classes, Graphics, Controls, Types,
  Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TfrColor= (frDefault,frGreen,frYellow,
             frBlue,frRed,frPurple,frUser);

type

 TColorBevel =class(TBevel)
 private
    FHighLight,
    FShadow   :TColor;
    FFrameColor:TfrColor;
    procedure SetHighLight(Value:TColor);
    procedure SetShadow(Value:TColor);
    procedure SetFrameColor(Value:TfrColor);
    procedure TypeFrameColor;
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent);override;
  published
    { Published declarations }
    property HighLight:TColor read FHighLight write SetHighLight;
    property Shadow   :TColor read FShadow write SetShadow;
    property FrameColor:TfrColor read FFrameColor write SetFrameColor;
  end;

procedure Register;

implementation

constructor TColorBevel.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 FHighlight:= clBtnHighlight;
 FShadow := clBtnShadow;
 FFrameColor:=frDefault;
end;

procedure TColorBevel.Paint;

var
  Color1, Color2: TColor;
  Temp: TColor;

  procedure BevelRect(const R: TRect);
  begin
    with Canvas do
    begin
      Pen.Color := Color1;
      PolyLine([Point(R.Left, R.Bottom), Point(R.Left, R.Top),
        Point(R.Right, R.Top)]);
      Pen.Color := Color2;
      PolyLine([Point(R.Right, R.Top), Point(R.Right, R.Bottom),
        Point(R.Left, R.Bottom)]);
    end;
  end;

  procedure BevelLine(C: TColor; X1, Y1, X2, Y2: Integer);
  begin
    with Canvas do
    begin
      Pen.Color := C;
      MoveTo(X1, Y1);
      LineTo(X2, Y2);
    end;
  end;

begin
  with Canvas do
  begin
    Pen.Width := 1;

    if Style = bsLowered then
    begin
      Color1 := FShadow;
      Color2 := FHighlight;
    end
    else
    begin
      Color1 := FHighlight;
      Color2 := FShadow;
    end;

    case Shape of
      bsBox: BevelRect(Rect(0, 0, Width - 1, Height - 1));
      bsFrame:
        begin
          Temp := Color1;
          Color1 := Color2;
          BevelRect(Rect(1, 1, Width - 1, Height - 1));
          Color2 := Temp;
          Color1 := Temp;
          BevelRect(Rect(0, 0, Width - 2, Height - 2));
        end;
      bsTopLine:
        begin
          BevelLine(Color1, 0, 0, Width, 0);
          BevelLine(Color2, 0, 1, Width, 1);
        end;
      bsBottomLine:
        begin
          BevelLine(Color1, 0, Height - 2, Width, Height - 2);
          BevelLine(Color2, 0, Height - 1, Width, Height - 1);
        end;
      bsLeftLine:
        begin
          BevelLine(Color1, 0, 0, 0, Height);
          BevelLine(Color2, 1, 0, 1, Height);
        end;
      bsRightLine:
        begin
          BevelLine(Color1, Width - 2, 0, Width - 2, Height);
          BevelLine(Color2, Width - 1, 0, Width - 1, Height);
        end;
    end;
  end;
end;

procedure TColorBevel.SetHighLight(Value:TColor);
begin
 if FHighLight<>Value then
  begin
   FHighLight:=Value;
   TypeFrameColor;
   Invalidate;
  end;
end;

procedure TColorBevel.SetShadow(Value:TColor);
begin
 if FShadow<>Value then
  begin
   FShadow:=Value;
   TypeFrameColor;
   Invalidate;
  end;
end;

procedure TColorBevel.TypeFrameColor;
begin
  if (FShadow = clBtnShadow)and(FHighLight=clBtnHighLight) then
               FFrameColor:=frDefault else
  if (FShadow =clNavy)and(FHighLight=clAqua) then
               FFrameColor:=frBlue else
  if (FShadow =clOlive)and(FHighLight=clYellow) then
               FFrameColor:=frYellow else
  if (FShadow =clMaroon)and(FHighLight=clRed )then
               FFrameColor:=frRed else
  if (FShadow =clPurple)and(FHighLight=clFuchsia )then
               FFrameColor:=frPurple else
  if (FShadow =clGreen)and(FHighLight=clLime )then
               FFrameColor:=frGreen
 else FFrameColor:=frUser;
end;

procedure TColorBevel.SetFrameColor(Value:TfrColor);
begin
 if FFrameColor<>Value then
  begin
   FFrameColor:=Value;
   case FFrameColor of
    frDefault:
     begin
      FHighLight := clBtnHighlight;
      FShadow    := clBtnShadow;
     end;
    frBlue:
     begin
      FHighLight := clAqua;
      FShadow    := clNavy;
     end;
    frGreen:
     begin
      FHighLight := clLime;
      FShadow    := clGreen;
     end;
    frRed:
     begin
      FHighLight := clRed;
      FShadow    := clMaroon;
     end;
    frPurple:
     begin
      FHighLight := clFuchsia;
      FShadow    := clPurple;
     end;
    frYellow:
     begin
      FHighLight := clYellow;
      FShadow    := clOlive;
     end;
    end;
   Invalidate;
  end;
end;


procedure Register;
begin
  RegisterComponents('Additional', [TColorBevel]);  
end;

end.
