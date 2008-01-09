unit ExGraphicLabel;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, TntExtCtrls, TntStdCtrls, StdCtrls,
  Graphics, pngimage;

type
  TExGraphicLabel = class(TCustomControl)
  private
    { Private declarations }
    _focused: boolean;
    _selected: boolean;
    _caption: Widestring;
    _border: TBorderWidth;
    _key: String;

    _target: TObject;

    procedure SetFocued(f: boolean);
    procedure SetCaption(txt: WideString);
    procedure SetSelected(sel: boolean);
    procedure SetBorder(border: TBorderWidth);
    procedure SetKey(key: String);

  protected
    { Protected declarations }
    property AutoSize default false;

    procedure Paint(); override;

  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;

  published
    { Published declarations }
    property Align;
    property Anchors default [akLeft, akTop];
    property BorderWidth: TBorderWidth read _border write SetBorder default 3;
    property Caption: Widestring read _caption write SetCaption;
    property Enabled default true;
    property Selected: boolean read _selected write SetSelected default false;
    property Key: String read _key write SetKey;

    property Target: TObject read _target write _target;

    property OnClick;
end;

procedure Register;

implementation

uses Types, Windows, TnTWindows;

procedure Register;
begin
    RegisterComponents('Win32', [TExGraphicLabel]);
end;

constructor TExGraphicLabel.Create(AOwner: TComponent);
begin
    _focused := false;
    
    inherited Create(AOwner);
end;

procedure TExGraphicLabel.SetCaption(txt: WideString);
begin
    if txt <> _caption then begin
        _caption := txt;
        Invalidate;
    end;
end;
procedure TExGraphicLabel.SetFocued(f: Boolean);
begin
    if _focused <> f then begin
        _focused := f;
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
    OutRect, InRect, fRect: TRect;
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
    fRect := InRect;
    InflateRect(fRect, -2, -2);
    
    with Canvas do begin
        //paint backround image
        if not (csDesigning in Self.ComponentState) and (Self.Key <> '') then begin
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

        if _focused then begin
        end;

        if (csDesigning in Self.ComponentState) then begin
            Brush.Style := bsSolid;
            Brush.Color := clBlack;
            Canvas.FrameRect(inRect);
        end;
  end;
end;

end.
