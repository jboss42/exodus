unit Viewer;

interface

uses
    SQLiteTable,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, ComCtrls, RichEdit2, ExRichEdit,
    TntStdCtrls, Buttons, TntExtCtrls, Grids, TntGrids;

type
  TMonthDay = 1..31;
  
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
    _days: set of TMonthDay;
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
    SQLPlugin, XMLUtils, DateUtils;

{$R *.dfm}

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
    td, c1, r, c, i: integer;
    d1: TDateTime;
    sql, cmd: string;
    tmp: TSQLiteTable;
begin
    MsgList.WideLines.Clear();
    td := Trunc(d);
    cmd := 'SELECT * FROM jlogs WHERE jid="%s" AND date=%d ORDER BY DATE, TIME;';
    sql := Format(cmd, [_jid, td]);
    tmp := db.GetTable(sql);

    for i := 0 to tmp.RowCount - 1 do begin
        DisplayMsg(tmp);
        tmp.Next();
    end;

    _last := d;

    // find out where the first of this month is..
    d1 := EncodeDate(YearOf(d), MonthOf(d), 1);
    c1 := DayOfWeek(d1) - 1;

    c := DayOfWeek(d) - 1;
    r := NthDayOfWeek(d);

    // if todays day of the week is before the day of the week of the
    // first of the month, then we aren't on the first "row", we're on the
    // "second" row (ie, Jan 1, is a Friday, it's currently Jan 3, which
    // is the following sunday, which is row 2).
    if (c < c1) then r := r + 1;

    gridCal.Row := r;
    gridCal.Col := c;
end;

{---------------------------------------}
procedure TfrmView.SelectMonth(d: TDateTime);
var
    y, m:  Word;
    d1, d2: TDateTime;
    dd, i1, i2: integer;
    sql, cmd: string;
    tmp: TSQLiteTable;
    i: integer;
begin
    y := YearOf(d);
    m := MonthOf(d);
    d1 := EncodeDate(y, m, 1);
    d2 := EncodeDate(y, m, DaysInMonth(d1));
    i1 := Trunc(d1);
    i2 := Trunc(d2);

    cmd := 'SELECT DISTINCT date FROM jlogs WHERE jid="%s" AND date > %d AND date < %d;';
    sql := Format(cmd, [_jid, i1, i2]);
    tmp := db.GetTable(sql);

    _days := [];
    for i := 0 to tmp.RowCount - 1 do begin
        // make all of these days bold
        dd := StrToInt(tmp.Fields[0]);
        _days := _days + [DayOf(dd)];
        tmp.Next();
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
    d: integer;
    t: double;
    txt: WideString;
    ts: double;
    nick: Widestring;
    c: TColor;
begin
    txt := UTF8Decode(tmp.Fields[F1_BODY]);

    d := StrToInt(tmp.Fields[F1_DATE]);
    t := StrToFloat(tmp.Fields[F1_TIME]);
    ts := d + t;

    // Make sure we're inputting text in Unicode format.
    MsgList.InputFormat := ifUnicode;
    MsgList.SelStart := Length(MsgList.WideLines.Text);
    MsgList.SelLength := 0;

    MsgList.SelAttributes.Color := clGray;
    MsgList.WideSelText := '[' + FormatDateTime('h:mm am/pm', ts) + ']';

    nick := UTF8Decode(tmp.Fields[F1_NICK]);
    if (nick = '') then begin
        c := clGreen;
        MsgList.SelAttributes.Color := c;
        MsgList.WideSelText := '' + txt;
    end
    else begin
        if (Uppercase(tmp.Fields[F1_OUT]) = 'TRUE') then
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
var
    i, cw: integer;
begin
    _last := 0;
    gridCal.Cells[0, 0] := 'S';
    gridCal.Cells[1, 0] := 'M';
    gridCal.Cells[2, 0] := 'T';
    gridCal.Cells[3, 0] := 'W';
    gridCal.Cells[4, 0] := 'T';
    gridCal.Cells[5, 0] := 'F';
    gridCal.Cells[6, 0] := 'S';

    cw := Trunc(gridCal.Width / 7.0);
    for i := 0 to 6 do
        gridCal.ColWidths[i] := cw;

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
    for r := 1 to gridCal.RowCount - 1 do begin
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

    CanSelect := (d in _days);
    if (CanSelect) then begin
        td := EncodeDate(_y, _m, d);
        if (td <> _last) then
            SelectDay(td);
    end;
end;

procedure TfrmView.gridCalDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
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
    end;

    // Draw the cell's BG
    gridCal.Canvas.FillRect(Rect);

    // If this day is bold, make it so..
    if (d in _days) then begin
        gridCal.Canvas.Font.Color := clWindowText;
        gridCal.Canvas.Font.Style := [fsBold];
    end
    else begin
        gridCal.Canvas.Font.Color := clGrayText;
        gridCal.Canvas.Font.Style := [];
    end;

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
