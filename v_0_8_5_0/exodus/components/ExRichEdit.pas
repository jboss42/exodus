unit ExRichEdit;

interface

uses
    Graphics, RichEdit2, RichEdit,
    Windows, Messages, SysUtils, Classes, Controls, StdCtrls, ComCtrls;

type
  TRichEditURLClick = procedure (Sender: TObject; url: string) of object;

  TExRichEdit = class(TRichEdit98)
  private
    { Private declarations }
    // FOnURLClick: TRichEditURLClick;
  protected
    { Protected declarations }
    procedure CreateWnd; override;
    // procedure CreateParams(var Params: TCreateParams); override;
    // procedure CN_NOTIFY(var Msg: TWMNotify); message CN_NOTIFY;
  public
    { Public declarations }
    procedure InsertBitmap(bmp: Graphics.TBitmap);
  published
    { Published declarations }
    // property OnURLClick: TRichEditURLClick read FOnURLClick write FOnURLClick;
  end;

const
    EN_LINK = $070b;

function BitmapToRTF(pict: Graphics.TBitmap): string;
procedure Register;

implementation
uses
    ShellAPI;

procedure TExRichEdit.CreateWnd;
begin
    inherited;
    {
    // Tell the window to auto-detect URL's
    SendMessage(Self.Handle, EM_AUTOURLDETECT, integer(true), 0);

    // Get the current Event Mask for notification
    mask := SendMessage(Self.Handle, EM_GETEVENTMASK, 0, 0);

    // Tell the window we want EN_LINK events
    SendMessage(Self.Handle, EM_SETEVENTMASK, 0, (mask + ENM_LINK));
    }
end;

(*
procedure TExRichEdit.CreateParams(var Params: TCreateParams);
begin
    // Make sure the richedit controls are subclassed using riched20.dll
    if (_riched20 = 0) then begin
        _riched20 := LoadLibrary('RICHED20.DLL');
        if (_riched20 <= HINSTANCE_ERROR) then
            _riched20 := 0;
        end;
    inherited CreateParams(Params);
    CreateSubClass(Params, RICHEDIT_CLASS);
end;
*)

{
This is our custom CN_NOTIFY event handler..
It will pick up the EN_LINK events.
}

{
procedure TExRichEdit.CN_NOTIFY(var Msg: TWMNotify);
var
    purl: PChar;
    en_link: TENLINK;
    text_range: TTextRangeA;
    ch_range: TCharRange;
begin
    case Msg.NMHdr^.code of
        $070b: begin
            en_link := TENLink((Pointer(Msg.NMHdr))^);
            if (en_link.msg = WM_LBUTTONUP) then begin
                ch_range := en_link.chrg;
                text_range.chrg.cpMin := ch_range.cpMin;
                text_range.chrg.cpMax := ch_range.cpMax;
                purl := StrAlloc(ch_range.cpMax - ch_range.cpMin + 1);
                text_range.lpstrText := purl;
                SendMessage(Handle, EM_GETTEXTRANGE, 0, LongInt(@text_range));
                if Assigned(FOnURLClick) then
                    FOnURLClick(Self, String(purl));
                // ShellExecute(0, 'open', purl, nil, nil, SW_SHOWNORMAL);
                end;
            end
        else
            inherited;
        end;
end;
}

{
pgm 3/3/02 - Adding stuff to the rich edit control
so that we can directly insert bitmaps
}
procedure TExRichEdit.InsertBitmap(bmp: Graphics.TBitmap);
var
    s : TStringStream;
begin
    // Insert a bitmap into the control
    s := TStringStream.Create(BitmapToRTF(bmp));
    RTFSelText := s.DataString;
    s.Free;
end;


procedure Register;
begin
  RegisterComponents('Win32', [TExRichEdit]);
end;

function BitmapToRTF(pict: Graphics.TBitmap): string;
var
    bi, bb, rtf: string;
    bis, bbs: Cardinal;
    achar: ShortString;
    hexpict: string;
    i: Integer;
begin
    GetDIBSizes(pict.Handle, bis, bbs);
    SetLength(bi,bis);
    SetLength(bb,bbs);
    GetDIB(pict.Handle, pict.Palette, PChar(bi)^, PChar(bb)^);
    rtf := '{\rtf1 {\pict\dibitmap ';
    SetLength(hexpict,(Length(bb) + Length(bi)) * 2);
    i := 2;
    for bis := 1 to Length(bi) do begin
        achar := Format('%x',[Integer(bi[bis])]);
        if Length(achar) = 1 then
            achar := '0' + achar;
        hexpict[i-1] := achar[1];
        hexpict[i] := achar[2];
        inc(i,2);
    end;
    for bbs := 1 to Length(bb) do begin
        achar := Format('%x',[Integer(bb[bbs])]);
        if Length(achar) = 1 then
            achar := '0' + achar;
        hexpict[i-1] := achar[1];
        hexpict[i] := achar[2];
        inc(i,2);
    end;
    rtf := rtf + hexpict + ' }}';
    Result := rtf;
end;


end.
