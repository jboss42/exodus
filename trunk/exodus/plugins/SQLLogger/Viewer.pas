unit Viewer;

interface

uses
    SQLiteTable,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, ComCtrls, RichEdit2, ExRichEdit,
    TntStdCtrls, Buttons, TntExtCtrls, Grids, TntGrids;

type
  TfrmView = class(TForm)
    MsgList: TExRichEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    pnlCal: TPanel;
    TntPanel1: TTntPanel;
    pnlCalHeader: TTntPanel;
    btnPrevMonth: TSpeedButton;
    btnNextMonth: TSpeedButton;
    gridCal: TTntStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure gridCalSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure gridCalDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnNextMonthClick(Sender: TObject);
  private
    { Private declarations }
    _jid: String;
    _days: Array of longword;
    _last: TDatetime;
    _m: Word;
    _y: Word;

    procedure DisplayMsg(tmp: TSQLiteTable);
    procedure SelectMonth(d: TDateTime);
    procedure SelectDay(d: TDateTime);
    procedure DrawCal(d: TDateTime);

  public
    { Public declarations }
    db: TSQLiteDatabase;

    procedure ShowJid(jid: Widestring);
  end;

var
  frmView: TfrmView;

implementation

uses
    XMLUtils, DateUtils;

{$R *.dfm}

const
    F_UJID = 0;
    F_JID = 1;
    F_DATE = 2;
    F_TIME = 3;
    F_THREAD = 4;
    F_SUBJECT = 5;
    F_NICK = 6;
    F_BODY = 7;
    F_TYPE = 8;
    F_OUT = 9;

{---------------------------------------}
{---------------------------------------}
procedure TfrmView.ShowJid(jid: Widestring);
begin
    _jid := UTF8Encode(jid);
    _last := 0;
    SelectMonth(Now());
    SelectDay(Now());
end;

{---------------------------------------}
procedure TfrmView.SelectDay(d: TDateTime);
var
    r, c, i: integer;
    sql, cmd, ds: string;
    tmp: TSQLiteTable;
begin
    MsgList.WideLines.Clear();
    ds := DateToStr(d);
    cmd := 'SELECT * FROM logs WHERE jid="%s" AND date="%s" ORDER BY DATE, TIME;';
    sql := Format(cmd, [_jid, ds]);
    tmp := db.GetTable(sql);

    for i := 0 to tmp.RowCount - 1 do begin
        DisplayMsg(tmp);
        tmp.Next();
    end;

    _last := d;

    c := DayOfWeek(d) - 1;
    r := NthDayOfWeek(d);
    gridCal.Row := r;
    gridCal.Col := c;
end;

{---------------------------------------}
procedure TfrmView.SelectMonth(d: TDateTime);
var
    y, m:  Word;
    td, d1, d2: TDateTime;
    s1, s2: string;
    sql, cmd: string;
    tmp: TSQLiteTable;
    i: integer;
begin
    y := YearOf(d);
    m := MonthOf(d);
    d1 := EncodeDate(y, m, 1);
    d2 := EncodeDate(y, m, DaysInMonth(d1));
    s1 := DateToStr(d1);
    s2 := DateToStr(d2);

    cmd := 'SELECT DISTINCT date FROM logs WHERE jid="%s" AND date > "%s" AND date < "%s";';
    sql := Format(cmd, [_jid, s1, s2]);
    tmp := db.GetTable(sql);

    if (tmp.RowCount = 0) then begin
        SetLength(_days, 1);
        _days[0] := 0;
    end
    else begin
        SetLength(_days, tmp.RowCount);
        for i := 0 to tmp.RowCount - 1 do begin
            // make all of these days bold
            td := StrToDate(tmp.Fields[0]);
            _days[i] := DayOf(td);
            tmp.Next();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmView.DisplayMsg(tmp: TSQLiteTable);
var
    txt: WideString;
    ts: TDatetime;
    nick: Widestring;
    c: TColor;
begin
    txt := UTF8Decode(tmp.Fields[F_BODY]);
    ts := StrToDate(tmp.Fields[F_DATE]) + StrToTime(tmp.FIELDS[F_TIME]);

    // Make sure we're inputting text in Unicode format.
    MsgList.InputFormat := ifUnicode;
    MsgList.SelStart := Length(MsgList.WideLines.Text);
    MsgList.SelLength := 0;

    MsgList.SelAttributes.Color := clGray;
    MsgList.WideSelText := '[' + FormatDateTime('h:mm am/pm', ts) + ']';

    nick := UTF8Decode(tmp.Fields[F_NICK]);
    if (nick = '') then begin
        c := clGreen;
        MsgList.SelAttributes.Color := c;
        MsgList.WideSelText := '' + txt;
    end
    else begin
        if (Uppercase(tmp.Fields[F_OUT]) = 'TRUE') then
            c := clRed
        else
            c := clBlue;

        MsgList.SelAttributes.Color := c;
        MsgList.WideSelText := '<' + nick + '>';

        MsgList.SelAttributes.Color := clDefault;
        MsgList.WideSelText := ' ' + txt;
    end;

    MsgList.WideSelText := #13#10;
end;

{---------------------------------------}
procedure TfrmView.FormCreate(Sender: TObject);
begin
    _last := 0;
    gridCal.Cells[0, 0] := 'S';
    gridCal.Cells[1, 0] := 'M';
    gridCal.Cells[2, 0] := 'T';
    gridCal.Cells[3, 0] := 'W';
    gridCal.Cells[4, 0] := 'T';
    gridCal.Cells[5, 0] := 'F';
    gridCal.Cells[6, 0] := 'S';
    DrawCal(Now());
end;

{---------------------------------------}
procedure TfrmView.DrawCal(d: TDateTime);
var
    cur: TDateTime;
    days: Word;
    r, c, i: integer;
begin
    // Draw this month in the calandar
    for r := 0 to gridCal.RowCount - 1 do begin
        for c := 0 to gridCal.ColCount - 1 do
            gridCal.Cells[c,r] := '';
    end;
    
    r := 1;
    _m := MonthOf(d);
    _y := YearOf(d);
    pnlCalHeader.Caption := FormatDateTime('mmmm, yyyy', d);
    days := DaysInMonth(d);
    for i := 1 to days do begin
        cur := EncodeDate(_y, _m, i);
        // DayOfTheWeek, 1 = Monday, 7 = Sunday
        c := DayOfTheWeek(cur);
        if (c = 7) then begin
            inc(r);
            c := 0;
        end;
        gridCal.Cells[c, r] := IntToStr(i);
    end;
end;


procedure TfrmView.gridCalSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
    d: Word;
    td: TDateTime;
begin
    d := SafeInt(gridCal.Cells[ACol, ARow]);
    if (d = 0) then exit;
    td := EncodeDate(_y, _m, d);
    if (td <> _last) then
        SelectDay(td);
end;

procedure TfrmView.gridCalDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
    b: boolean;
    l, i: integer;
    d: Word;
    txt: string;
    pw, ph, tw, th: integer;
begin
    txt := gridCal.Cells[ACol, ARow];
    d := SafeInt(txt);

    // Draw the cell..
    gridCal.Canvas.Brush.Style := bsSolid;
    if (gdFixed in State) then begin
        gridCal.Canvas.Brush.Color := clBtnFace;
        gridCal.Canvas.Font.Color := clBtnText;
    end
    else if (gdSelected in State) then begin
        gridCal.Canvas.Brush.Color := clHighlight;
        gridCal.Canvas.Font.Color := clHighlightText;
    end
    else begin
        gridCal.Canvas.Brush.Color := clWindow;
        gridCal.Canvas.Font.Color := clWindowText;
    end;

    // Draw the cell's BG
    gridCal.Canvas.FillRect(Rect);

    // If this day is bold, make it so..
    b := false;
    l := Length(_days);
    for i := 0 to l - 1 do begin
        if (_days[i] = d) then begin
            b := true;
            break;
        end;
    end;

    if (b) then
        gridCal.Canvas.Font.Style := [fsBold]
    else
        gridCal.Canvas.Font.Style := [];

    // center the text
    tw := gridCal.Canvas.TextWidth(txt);
    th := gridCal.Canvas.TextHeight(txt);
    pw := ((Rect.Right - Rect.Left) - tw) div 2;
    ph := ((Rect.Bottom - Rect.Top) - th) div 2;
    gridCal.Canvas.TextOut(Rect.Left + pw, Rect.Top + ph, txt);
end;

procedure TfrmView.btnNextMonthClick(Sender: TObject);
var
    i: integer;
    new: TDateTime;
    d: Word;
begin
    if (Sender = btnPrevMonth) then
        i := -1
    else
        i := +1;

    d := DayOf(_last);
    IncAMonth(_y, _m, d, i);
    new := EncodeDate(_y, _m, d);
    DrawCal(new);
    SelectMonth(new);
    SelectDay(new);
end;

end.
