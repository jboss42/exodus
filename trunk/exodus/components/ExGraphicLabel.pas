unit ExGraphicLabel;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, TntExtCtrls, TntStdCtrls, StdCtrls,
  Graphics, pngimage;

type
  TExGraphicLabel = class(TGraphicControl)
  private
    { Private declarations }
    _selected: boolean;
    _caption: Widestring;
    _border: TBorderWidth;
    _key: String;

    procedure SetCaption(txt: WideString);
    procedure SetSelected(sel: boolean);
    procedure SetBorder(border: TBorderWidth);
    procedure SetKey(key: String);

  protected
    { Protected declarations }
    property Anchors default [akLeft, akTop, akRight, akBottom];
    property AutoSize default false;

    procedure Paint(); override;

  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;

  published
    { Published declarations }
    property BorderWidth: TBorderWidth read _border write SetBorder default 3;
    property Caption: Widestring read _caption write SetCaption;
    property Enabled default true;
    property Selected: boolean read _selected write SetSelected default false;
    property Key: String read _key write SetKey;

    property OnClick;
end;

procedure Register;

implementation

uses Types, Windows, TnTWindows;

var
  gInDesignMode: boolean;

procedure Register;
begin
  gInDesignMode := true;
  RegisterComponents('Win32', [TExGraphicLabel]);
end;

constructor TExGraphicLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TExGraphicLabel.SetCaption(txt: WideString);
begin
  if txt <> _caption then begin
    _caption := txt;
    Invalidate;
  end;
end;
procedure TExGraphicLabel.SetSelected(sel: Boolean);
begin
  if _selected <> sel then begin
    _selected := sel;
    Invalidate;
  end;
end;
procedure TExGraphicLabel.SetBorder(border: TBorderWidth);
begin
  if _border <> border then begin
    _border := border;
    Invalidate;
  end;
end;
procedure TExGraphicLabel.SetKey(key: string);
begin
  if _key <> key then begin
    _key := key;
    Invalidate;
  end;
end;

procedure TExGraphicLabel.Paint;
var
  OutRect, InRect: TRect;
  Flags: Longint;
  Text: Widestring;
  Png: TPNGObject;
  Color: TColor;
  Key: String;

begin
  if Selected then begin
    color := clWhite;
    key := Self.Key + 'Selected';
  end
  else begin
    color := clBlack;
    key := Self.Key + 'Enabled';
  end;

  Text := Caption;
  InRect := ClientRect;
  OutRect := InRect;
  InflateRect(InRect, -BorderWidth, -BorderWidth);

  with Canvas do begin
    //paint backround image
    if (not gInDesignMode) and (Self.Key <> '') then begin
      Png := TPngObject.Create();
      png.LoadFromResourceName(HInstance, key);
      png.Draw(Canvas, OutRect);
      png.Free;
    end;

    if Text <> '' then begin
      Brush.Style := bsClear;
      Font.Color := Color;
      Flags := DT_EXPANDTABS or DT_SINGLELINE or DT_BOTTOM or DT_CENTER;
      Flags := DrawTextBiDiModeFlags(Flags);
      Tnt_DrawTextW(Handle, PWideChar(Caption), Length(Caption), InRect, Flags);
    end;

    if gInDesignMode then begin
      Brush.Style := bsSolid;
      Brush.Color := clBlack;
      Canvas.FrameRect(OutRect);
    end;
  end;
end;

end.
