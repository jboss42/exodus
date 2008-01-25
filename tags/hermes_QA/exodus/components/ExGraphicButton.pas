unit ExGraphicButton;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, TntExtCtrls, TntStdCtrls, StdCtrls,
  Graphics, pngimage;

type
  TExGraphicButton = class(TCustomControl)
  private
    { Private declarations }
    _focused: boolean;
    _selected: boolean;
    _caption: Widestring;
    _border: TBorderWidth;
    _imgEnabled: TPNGObject;
    _imgSelected: TPNGObject;

    _target: TObject;

    procedure SetCaption(txt: WideString);
    procedure SetSelected(sel: boolean);
    procedure SetBorder(border: TBorderWidth);
    procedure SetImageEnabled(img: TPNGObject);
    procedure SetImageSelected(img: TPNGObject);

  protected
    { Protected declarations }
    property AutoSize default false;

    procedure Paint(); override;
    procedure DoEnter(); override;
    procedure DoExit(); override;

  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy(); override;

    function CanFocus(): Boolean; override;

  published
    { Published declarations }
    property Align;
    property Anchors default [akLeft, akTop];
    property BorderWidth: TBorderWidth read _border write SetBorder default 3;
    property Caption: Widestring read _caption write SetCaption;
    property Enabled default true;
    property Selected: boolean read _selected write SetSelected default false;

    property ImageEnabled: TPNGObject read _imgEnabled write SetImageEnabled;
    property ImageSelected: TPNGObject read _imgSelected write SetImageSelected;

    property Target: TObject read _target write _target;

    property OnClick;
end;

procedure Register;

implementation

uses Types, Windows, TnTWindows;

procedure Register;
begin
    RegisterComponents('Exodus Components', [TExGraphicButton]);
end;

constructor TExGraphicButton.Create(AOwner: TComponent);
begin
    _focused := false;

    _imgEnabled := TPNGObject.Create;
    _imgSelected := TPNGObject.Create;

    inherited Create(AOwner);
end;

destructor TExGraphicButton.Destroy;
begin
    _imgEnabled.Free;
    _imgSelected.Free;

    inherited Destroy;
end;

procedure TExGraphicButton.SetCaption(txt: WideString);
begin
    if txt <> _caption then begin
        _caption := txt;
        repaint;
    end;
end;
procedure TExGraphicButton.SetSelected(sel: Boolean);
begin
    if _selected <> sel then begin
        _selected := sel;
        repaint;
    end;
end;
procedure TExGraphicButton.SetBorder(border: TBorderWidth);
begin
    if _border <> border then begin
        _border := border;
        repaint;
    end;
end;
procedure TExGraphicButton.SetImageEnabled(img: TPNGObject);
begin
    _imgEnabled.Assign(img);
    repaint;
end;
procedure TExGraphicButton.SetImageSelected(img: TPNGObject);
begin
    _imgSelected.Assign(img);
    repaint;
end;

procedure TExGraphicButton.DoEnter;
begin
    inherited;

    _focused := true;
    repaint;
end;
procedure TExGraphicButton.DoExit;
begin
    inherited;

    _focused := false;
    repaint;
end;

procedure TExGraphicButton.Paint;
var
    OutRect, InRect, fRect: TRect;
    Flags: Longint;
    Text: Widestring;
    Png: TPNGObject;
    Color: TColor;

begin
    if Selected then begin
        color := clWhite;
        png := _imgSelected;
    end
    else begin
        color := clBlack;
        png := _imgEnabled;
    end;

    Text := Caption;
    OutRect := ClientRect;
    InRect := ClientRect;
    InflateRect(InRect, -BorderWidth, -BorderWidth);
    fRect := InRect;
    InflateRect(fRect, -2, -2);

    with Canvas do begin
        //paint backround image
        png.Draw(Canvas, OutRect);

        //paint text
        if Text <> '' then begin
            Brush.Style := bsClear;
            Font.Color := Color;
            Flags := DT_EXPANDTABS or DT_SINGLELINE or DT_BOTTOM or DT_CENTER;
            Flags := DrawTextBiDiModeFlags(Flags);
            Tnt_DrawTextW(Handle, PWideChar(Caption), Length(Caption), InRect, Flags);
        end;

        //paint "focus ring"
        if _focused then begin
            Pen.Style := psDot;
            Pen.Color := clBlack;
            Brush.Style := bsClear;
            RoundRect(fRect.Left, fRect.Top, fRect.Right, fRect.Bottom, 2, 2);
        end;

        //paint "design ring"
        {
        if (csDesigning in Self.ComponentState) then begin
            Brush.Style := bsSolid;
            Brush.Color := clBlack;
            FrameRect(inRect);
        end;
        }
  end;
end;

function TExGraphicButton.CanFocus;
begin
    Result := inherited CanFocus;
end;

end.
