unit ExRichEdit;

interface

uses
    RichEdit,
    Windows, Messages, SysUtils, Classes, Controls, StdCtrls, ComCtrls;

type
  TRichEditURLClick = procedure (Sender: TObject; url: string) of object;

  TExRichEdit = class(TRichEdit)
  private
    { Private declarations }
    FOnURLClick: TRichEditURLClick;
  protected
    { Protected declarations }
    procedure CreateWnd; override;
    procedure CN_NOTIFY(var Msg: TWMNotify); message CN_NOTIFY;
  public
    { Public declarations }
  published
    { Published declarations }
    property OnURLClick: TRichEditURLClick read FOnURLClick write FOnURLClick;
  end;

const
    EN_LINK = $070b;

procedure Register;

implementation
uses
    ShellAPI;

procedure TExRichEdit.CreateWnd;
var
    mask: integer;
begin
    inherited;

    // Tell the window to auto-detect URL's
    SendMessage(Self.Handle, EM_AUTOURLDETECT, integer(true), 0);

    // Get the current Event Mask for notification
    mask := SendMessage(Self.Handle, EM_GETEVENTMASK, 0, 0);

    // Tell the window we want EN_LINK events
    SendMessage(Self.Handle, EM_SETEVENTMASK, 0, (mask + ENM_LINK));
end;

{
This is our custom CN_NOTIFY event handler..
It will pick up the EN_LINK events.
}
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

procedure Register;
begin
  RegisterComponents('Win32', [TExRichEdit]);
end;

end.
