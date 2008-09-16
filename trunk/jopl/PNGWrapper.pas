unit PNGWrapper;

interface
{$UNDEF PNGIMAGE}
//{$DEFINE PNGIMAGE}
uses
{$IFDEF PNGIMAGE}
    PNGImage,
{$ELSE}
    NGImages,
{$ENDIF}
    graphics,
    Windows,
    classes;

type
{$IFDEF PNGIMAGE}
    TPNGWrapper = class(TPNGObject)
{$ELSE}
    TPNGWrapper = class(TNGImage)
{$ENDIF}
    private
        _lastBG: TColor;
    public
        constructor Create(); override;
        procedure Draw(ACanvas: TCanvas; const Rect: TRect);
        procedure SetBackgroundColor(value: TColor);

        function  GetEmpty : boolean; override;
        procedure Assign(Source : TPersistent); override;

        procedure LoadFromFile(const filename: string); override;
        procedure LoadFromStream(stream: TStream); override;
    end;

implementation
uses
    SysUtils;

procedure log(msg: string);
begin
    OutputDebugString(PChar(msg));
end;

constructor TPNGWrapper.Create();
begin
log('TPNGWrapper.create');
    inherited;
    _lastBG := clNone;
end;

procedure TPNGWrapper.Draw(ACanvas: TCanvas; const Rect: TRect);
begin
log('TPNGWrapper.draw');

    SetBackgroundColor(ACanvas.Brush.Color);
    inherited;
end;

//TPNGObject will do the right thing with images, if they have alphablended
//bits it respects them, and determines the background color to bleed through
//TPNGIMage on the other hand should be expclitly told what color
//should bleed through on the alpha bits by setting the BGColor
//unset (#000000) if clNone
procedure TPNGWrapper.SetBackgroundColor(value: TColor);
begin
log('TPNGWrapper.SetBackgroundColor');
    //nop if TPNGObject
{$IFNDEF PNGIMAGE}
    if (_lastBG <> ColorToRGB(value)) then
        Self.BGColor := ColorToRGB(value);
{$ENDIF}
    _lastBG := ColorToRGB(value);
 end;

function  TPNGWrapper.GetEmpty : boolean;
{$IFNDEF PNGIMAGE}
var
    tbm: Graphics.TBitmap;
{$ENDIF}
begin
log('TPNGWrapper.getempty');
{$IFDEF PNGIMAGE}
    Result := inherited GetEmpty();
{$ELSE}
    //check bitmap for emptyness, header may exist without bmp,
    //thus not really ever "empty"
    tbm := CopyBitmap();
    Result := tbm.Empty;
    tbm.free();
{$ENDIF}
end;

procedure TPNGWrapper.Assign(Source : TPersistent);
{$IFNDEF PNGIMAGE}
var
    tbm: Graphics.TBitmap;
{$ENDIF}
begin
log('TPNGWrapper.assign');

{$IFDEF PNGIMAGE}
    inherited;
{$ELSE}
    if (Source = nil) then
    begin
        tbm := Graphics.TBitmap.Create();
        tbm.assign(nil);
        inherited Assign(tbm);
    end
    else begin
        if (Source is TPNGWrapper) then
            //set our background color on the source, so later assign
            //will keep our state. This feels hackish,
            TPNGWrapper(Source).SetBackgroundColor(Self.BGColor);
        inherited;
    end;
{$ENDIF}
end;

procedure TPNGWrapper.LoadFromFile(const filename: string);
begin
log('TPNGWrapper.loadfromfile');

    inherited;
{$IFNDEF PNGIMAGE}
    MNG_Stop(); //insures lib handles are in a good write state
{$ENDIF}
end;

procedure TPNGWrapper.LoadFromStream(stream: TStream);
begin
log('TPNGWrapper.LoadFromStream');
    inherited;
{$IFNDEF PNGIMAGE}
    MNG_Stop(); //insures lib handles are in a good write state
{$ENDIF}
end;

initialization
    TPicture.RegisterFileFormat('PNG', 'Portable Network Graphics', TPNGWrapper);
finalization
    TPicture.UnregisterGraphicClass(TPNGWrapper);

end.
