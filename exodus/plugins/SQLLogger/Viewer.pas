unit Viewer;

interface

uses
    SQLiteTable,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, ComCtrls, RichEdit2, ExRichEdit,
    TntStdCtrls;

type
  TfrmView = class(TForm)
    MsgList: TExRichEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    cal: TMonthCalendar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure calClick(Sender: TObject);
    procedure calGetMonthInfo(Sender: TObject; Month: Cardinal;
      var MonthBoldInfo: Cardinal);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    _jid: String;
    _days: Array of longword;
    _last: TDatetime;

    procedure DisplayMsg(tmp: TSQLiteTable);
    procedure SelectMonth(d: TDateTime);
    procedure SelectDay(d: TDateTime);


  public
    { Public declarations }
    db: TSQLiteDatabase;

    procedure ShowJid(jid: Widestring);
  end;

var
  frmView: TfrmView;

implementation

uses DateUtils;

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
    cal.Date := Now();
end;

{---------------------------------------}
procedure TfrmView.calClick(Sender: TObject);
begin
    SelectDay(cal.Date);
end;

{---------------------------------------}
procedure TfrmView.SelectDay(d: TDateTime);
var
    i: integer;
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
procedure TfrmView.calGetMonthInfo(Sender: TObject; Month: Cardinal;
  var MonthBoldInfo: Cardinal);
begin
    if (cal.Date = _last) then
        cal.BoldDays(_days, MonthBoldInfo)
    else begin
        SelectMonth(cal.Date);
        cal.BoldDays(_days, MonthBoldInfo);
        _last := cal.Date;
    end;
end;

{---------------------------------------}
procedure TfrmView.FormCreate(Sender: TObject);
begin
    _last := 0;

end;

end.
