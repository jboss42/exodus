unit fXData;

interface

uses
    Unicode, XMLTag,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Grids, TntGrids, ExtCtrls;

type
  TframeXData = class(TFrame)
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    xGrid: TTntStringGrid;
    procedure xGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    _w: integer;
    _rows: TList;
    _ns: Widestring;
    _thread: Widestring;
  public
    { Public declarations }
    procedure Clear();
    procedure Render(tag: TXMLTag);
    function submit(): TXMLTag;
    function cancel(): TXMLTag;
  end;

implementation
{$R *.dfm}
uses
    GnuGetText, JabberConst, XMLUtils, Math, xdata;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TframeXData.Render(tag: TXMLTag);
begin
    // Render the xdata fields
    _rows := TList.Create();
    xGrid.Height := buildXData(tag, xGrid, _rows);

    // Make sure we draw w/ the correct color
    xGrid.Canvas.Brush.Color := clBtnFace;
end;

{---------------------------------------}
procedure TframeXData.Clear();
begin
    if (_rows <> nil) then begin
        ClearListObjects(_rows);
        FreeAndNil(_rows);
    end;
    xGrid.Height := 100;
    _w := 0;
    _ns := '';
    _thread := '';
end;

{---------------------------------------}
function TframeXData.submit(): TXMLTag;
var
    i: integer;
    x,f: TXMLTag;
    ro: TXDataRow;
begin
    // Return the filled out xdata form and cleanup.
    x := TXMLTag.Create('x');
    x.setAttribute('xmlns', XMLNS_XDATA);

    for i := 0 to _rows.Count - 1 do begin
        ro := TXDataRow(_rows[i]);
        f := ro.GetXML();
        if (not ro.valid) then
            raise EXDataValidationError.Create(_('Empty required fields'))
        else if (f <> nil) then
            x.AddTag(f);
    end;

    Result := x;
end;

{---------------------------------------}
function TframeXData.cancel(): TXMLTag;
begin
    // cancel the form
    Clear();
    Result := TXMLTag.Create('x');
    Result.setAttribute('xmlns', XMLNS_XDATA);
    Result.setAttribute('type', 'cancel');
end;

{---------------------------------------}
procedure TframeXData.xGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
    rh: integer;
    ro: TXDataRow;
    lRect, rRect: TRect;
begin
  inherited;

    // Do all the drawing in Col0.. since thats easiest.
    ro := TXDataRow(_rows[ARow]);
    if (ACol = 1) then begin
        // Draw the btn
        xGrid.Canvas.FillRect(Rect);
    end

    else if (ACol = 0) then begin

        // don't draw anything for hidden rows
        if (ro.hidden) then begin
            if (xGrid.RowHeights[ARow] > 0) then
                xGrid.RowHeights[ARow] := 0;
            exit;
        end;

        ro.r := Rect;

        // calc the rect for column 1
        lRect.Left := Rect.Left;
        lRect.Right := Rect.Right - _w;
        lRect.Top := Rect.Top;
        lRect.Bottom := Rect.Bottom;

        // calc the rect for column 2
        rRect.Left := Rect.Left + _w;
        rRect.Right := Rect.Right;
        rRect.Top := Rect.Top;
        rRect.Bottom := Rect.Bottom;

        // Start fresh
        xGrid.Canvas.FillRect(Rect);

        // Do the label
        rh := -1;
        if (ro.lbl <> nil) then begin
            if (ro.fixed) then
                ro.DrawLabel(Rect)
            else
                ro.DrawLabel(lRect);
            rh := ro.lbl.Height + V_WS;
        end;

        // Draw the control
        if (ro.con <> nil) then begin
            if (ro.lbl = nil) then
                ro.DrawControl(Rect)
            else
                ro.DrawControl(rRect);
            rh := Max(rh, (ro.con.Height + V_WS));
        end;

        // resize this row-height to fit correctly.
        if ((rh <> -1) and (rh <> xGrid.RowHeights[ARow])) then begin
            lRect.Bottom := lRect.Top + rh;
            xGrid.RowHeights[ARow] := rh;
        end;

        if (xGrid.Height < lRect.Bottom) then
            xGrid.Height := lRect.Bottom + V_WS;
    end;
end;

{---------------------------------------}
procedure TframeXData.FrameResize(Sender: TObject);
var
    w: integer;
begin
  inherited;
    // re-render fields, etc.
    w := Self.ClientWidth - 30;
    w := w - BTN_W;         // allow for col #3
    w := w - (3 * H_WS);    // allow for some horiz whitespace
    _w := w div 2;

    xGrid.ColWidths[0] := _w * 2;
    xGrid.ColWidths[1] := BTN_W;
end;

end.
