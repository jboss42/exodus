unit xdata;

interface

uses
    Unicode, XMLTag,
    TntCheckLst, TntStdCtrls, StdCtrls, ExodusLabel,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Dockable, buttonFrame, Grids, TntGrids, ExtCtrls, fXData;

type

  EXDataValidationError = class(Exception);

  TXDataRow = class
  private
    _grid: TTntStringGrid;
    _hint: Widestring;
    _opts: TWidestringlist;
    _visible: boolean;
    
    procedure buildLabel(l: Widestring);
    procedure setVisible(val: Boolean);

  public
    t: Widestring;
    v: Widestring;
    d: Widestring;
    lbl: TExodusLabel;
    con: TControl;
    btn: TTntButton;
    req: boolean;
    fixed: boolean;
    hidden: boolean;
    valid: boolean;
    r: TRect;

    constructor Create(grid: TTntStringGrid; x: TXMLTag);
    destructor Destroy(); override;

    procedure DrawLabel(r: TRect);
    procedure DrawControl(r: TRect);
    procedure DrawButton(r: TRect);
    
    function  GetXML(): TXMLTag;

    property Visible: boolean read _visible write setVisible;
  end;

  TfrmXData = class(TfrmDockable)
    frameButtons1: TframeButtons;
    frameXData: TframeXData;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    _packet: Widestring;
    _ns: Widestring;
    _thread: Widestring;
    _to_jid: Widestring;
    _type: Widestring;
    _responded: boolean;

    function getResponseTag(): TXMLTag;
  public
    { Public declarations }
    procedure Cancel();
    procedure Render(tag: TXMLTag);
  end;

var
  frmXData: TfrmXData;

const V_WS = 5;
const H_WS = 5;
const BTN_W = 30;

function  showXDataEx(tag: TXMLTag): boolean;
procedure showXData(tag: TXMLTag);
function  buildXData(x: TXMLTag; grid: TTntStringGrid; Rows: TList): integer; overload;

implementation
{$R *.dfm}
uses
    GnuGetText, JabberUtils, Session, Math, XMLUtils;

const
    sAllRequired = 'All required fields must be filled out.';
    sFormFrom = 'Form from %s';
    sClose = 'Close';
    sCancelled = 'Cancelled';
    sCancelMsg = '%s cancelled your form.';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function _showXData(tag: TXMLTag): boolean;
var
    f: TfrmXData;
begin
    f := TfrmXData.Create(nil);
    f.Render(tag);
    f.ShowDefault();
    f.BringToFront();
    Result := true;
end;

{---------------------------------------}
function  showXDataEx(tag: TXMLTag): boolean;
begin
    Result := _showXData(tag);
end;

{---------------------------------------}
procedure showXData(tag: TXMLTag);
begin
    _showXData(tag);
end;

{---------------------------------------}
function  buildXData(x: TXMLTag; grid: TTntStringGrid; Rows: TList): integer;
var
    tpe: Widestring;
    fields: TXMLTagList;
    ins: TXMLTag;
    t, i, idx, rh: integer;
    ro: TXDataRow;
begin
    //
    grid.Visible := false;

    tpe := x.GetAttribute('type');
    fields := x.QueryTags('field');
    ins := x.GetFirstTag('instructions');
    idx := 0;

    // size the grid correctly.
    assert((Rows.Count = 0));
    if (ins <> nil) then begin
        grid.RowCount := fields.Count + 1;
        ro := TXDataRow.Create(grid, ins);
        Rows.Add(ro);
        inc(idx);
    end
    else
        grid.RowCount := fields.Count;

    // generate rows
    t := 0;
    for i := 0 to fields.Count - 1 do begin
        ro := TXDataRow.Create(grid, fields[i]);
        if (ro.lbl <> nil) then
            rh := ro.lbl.Height
        else
            rh := 0;

        if (ro.con <> nil) then
            rh := max(rh, ro.con.Height);
        if (rh <> grid.RowHeights[idx]) then
            grid.RowHeights[idx] := rh;
        t := t + grid.RowHeights[idx];
        Rows.Add(ro);
        inc(idx);
    end;

    fields.Free();
    grid.Visible := true;
    Result := t;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
const MULTI_HEIGHT = 65;

constructor TXDataRow.Create(grid: TTntStringGrid; x: TXMLTag);
var
    i, idx: integer;
    o, ol, l: Widestring;
    xl: TXMLTagList;
begin
    _grid := grid;
    _opts := nil;
    _visible := false;
    lbl := nil;
    con := nil;
    btn := nil;
    fixed := false;
    hidden := false;
    valid := true;

    if (x.Name = 'instructions') then begin
        t := 'instructions';
        lbl := TExodusLabel.Create(grid);
        lbl.Caption := x.Data;
        lbl.Parent := grid;
        fixed := true;
        req := false;
        exit;
    end;

    v := x.GetAttribute('var');
    d := x.GetBasicText('value');
    l := x.GetAttribute('label');
    t := x.GetAttribute('type');
    _hint := x.GetBasicText('desc');
    req := (x.GetFirstTag('required') <> nil);

    // Create our controls
    if (t = 'fixed') then begin
        fixed := true;
        buildLabel(d);
        exit;
    end

    else if (t = 'hidden') then begin
        hidden := true;
        exit;
    end

    else if (t = 'boolean') then begin
        //con := TTntCheckBox.Create(grid);
        con := TCheckBox.Create(grid);
        con.Parent := grid;
        con.Visible := false;

        //with TTntCheckBox(con) do begin
        with TCheckBox(con) do begin
            Caption := x.GetAttribute('label');
            d := Lowercase(d);
            Checked := ((d = 'true') or (d = '1') or (d = 'yes') or (d = 'assent'));
            Hint := _hint;
            WordWrap := true;
        end;
    end

    else if ((t = 'text-multi') or (t = 'jid-multi')) then begin
        buildLabel(l);
        con := TTntMemo.Create(grid);
        con.Parent := grid;
        con.Visible := false;

        with TTntMemo(con) do begin
            Height := MULTI_HEIGHT;
            ScrollBars := ssBoth;
            Lines.Clear();
            xl := x.QueryTags('value');
            for i := 0 to xl.Count - 1 do
                Lines.Add(xl[i].Data);
            FreeAndNil(xl);
        end;
    end

    else if (t = 'list-single') then begin
        buildLabel(l);
        con := TTntComboBox.Create(grid);
        con.Parent := grid;
        con.Visible := false;
        _opts := TWidestringlist.Create();

        with TTntComboBox(con) do begin
            Style := csDropDownList;
            Items.Clear();
            xl := x.QueryTags('option');
            for i := 0 to xl.Count - 1 do begin
                o := xl[i].GetBasicText('value');
                ol := xl[i].GetAttribute('label');
                _opts.Add(o);
                if (ol = '') then
                    Items.Add(o)
                else
                    Items.Add(ol);
            end;
            FreeAndNil(xl);
            ItemIndex := _opts.IndexOf(d);
        end;
    end

    else if (t = 'list-multi') then begin
        buildLabel(l);
        con := TTntCheckListbox.Create(grid);
        con.Parent := grid;
        con.Visible := false;
        _opts := TWidestringlist.Create();

        with TTntCheckListbox(con) do begin
            Height := MULTI_HEIGHT;
            Items.Clear();
            xl := x.QueryTags('option');
            for i := 0 to xl.Count - 1 do begin
                o := xl[i].GetBasicText('value');
                ol := xl[i].GetAttribute('label');
                _opts.Add(o);
                if (ol = '') then
                    Items.Add(o)
                else
                    Items.Add(ol);
            end;
            FreeAndNil(xl);

            // select all <value> elements
            xl := x.QueryTags('value');
            for i := 0 to xl.Count - 1 do begin
                idx := _opts.IndexOf(xl[i].Data);
                if (idx >= 0) then
                    Checked[idx] := true;
            end;
        end;
    end

    else begin
        // text-single, text-private or unknown
        buildLabel(l);
        con := TTntEdit.Create(grid);
        con.Parent := grid;
        con.Visible := false;
        with TTntEdit(con) do begin
            Text := d;
            if (t = 'text-private') then
                PasswordChar := '*';
        end;
    end;
end;

{---------------------------------------}
destructor TXDataRow.Destroy();
begin
    if (lbl <> nil) then
        FreeAndNil(lbl);
    if (con <> nil) then
        FreeAndNil(con);
    if (btn <> nil) then
        FreeAndNil(btn);
    if (_opts <> nil) then
        FreeAndNil(_opts);
end;

{---------------------------------------}
procedure TXDataRow.buildLabel(l: Widestring);
begin
    lbl := TExodusLabel.Create(_grid);
    lbl.Parent := _grid;

    // put stars on required fields
    if (req) then
        lbl.Caption := l + '*'
    else
        lbl.Caption := l;
        
    lbl.Hint := _hint;
    lbl.Visible := false;
    if (fixed) then
        lbl.Width := _grid.ColWidths[0] * 2
    else
        lbl.Width := _grid.ColWidths[0];
end;

{---------------------------------------}
function TXDataRow.GetXML(): TXMLTag;
var
    f: TXMLTag;
    i, j: integer;
begin
    // fetch data from controls into d params
    // and send back the <field/> element
    valid := true;
    if (t = 'fixed') then begin
        Result := nil;
        exit;
    end;

    f := TXMLTag.Create('field');
    f.setAttribute('var', v);

    if (t = 'hidden') then begin
        f.AddBasicTag('value', d);
    end

    else if (t = 'boolean') then begin
        if (TTntCheckBox(con).Checked) then
            d := 'true'
        else
            d := 'false';
        f.AddBasicTag('value', d);
    end

    else if ((t = 'text-multi') or (t = 'jid-multi')) then begin
        with TTntMemo(con) do begin
            if ((req) and (Lines.Count = 0)) then
                valid := false
            else begin
                for i := 0 to Lines.Count - 1 do
                    f.AddBasicTag('value', Lines[i]);
            end;
        end;
    end

    else if (t = 'list-single') then begin
        i := TTntComboBox(con).ItemIndex;
        f.AddBasicTag('value', _opts[i]);
    end

    else if (t = 'list-multi') then begin
        with TTntCheckListbox(con) do begin
            j := 0;
            for i := 0 to Items.Count - 1 do begin
                if (Checked[i]) then begin
                    inc(j);
                    f.AddBasicTag('value', _opts[i]);
                end;
            end;
            if ((req) and (j = 0)) then
                valid := false;
        end;
    end

    else begin
        // text-single, text-private or unknown
        d := TTntEdit(con).Text;
        if ((req) and (d = '')) then
            valid := false;
        f.AddBasicTag('value', d);
    end;

    Result := f;

end;

{---------------------------------------}
procedure TXDataRow.setVisible(val: Boolean);
begin
    if (val = _visible) then exit;

    if (lbl <> nil) then lbl.Visible := val;
    if (con <> nil) then con.Visible := val;
    if (btn <> nil) then btn.Visible := val;

    _visible := val;
end;

{---------------------------------------}
procedure TXDataRow.DrawLabel(r: TRect);
begin
    if (lbl = nil) then exit;
    if (r.Top < 0) then exit;

    lbl.Top := r.Top;
    lbl.Width := r.Right - r.Left;

    if (not lbl.Visible) then begin
        lbl.Visible := true;
        lbl.Refresh();
        _visible := true;
    end;
end;

{---------------------------------------}
procedure TXDataRow.DrawControl(r: TRect);
var
    move: boolean;
begin
    if (con = nil) then exit;
    if (r.Top < 0) then exit;

    move := (r.Top <> con.Top) or (r.Left <> con.Left);

    con.Top := r.Top;
    con.Left := r.Left;
    con.Width := r.Right - r.Left;

    if (not con.visible) or (move) then begin
        con.Visible := true;
        con.Refresh();
        _visible := true;
    end;

end;

{---------------------------------------}
procedure TXDataRow.DrawButton(r: TRect);
begin
    if (btn = nil) then exit;
    if (r.Top < 0) then exit;

    btn.SetBounds(r.Left, r.Top, (r.Right - r.Left), (r.Bottom - r.Top));
    if (not btn.Visible) then begin
        btn.Visible := true;
        btn.Invalidate();
        _visible := true;
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmXData.FormCreate(Sender: TObject);
begin
  inherited;
end;

{---------------------------------------}
procedure TfrmXData.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if (not _responded) then Cancel();
    Action := caFree;
    if (MainSession <> nil) then
        MainSession.Prefs.SavePosition(Self);
end;

{---------------------------------------}
procedure TfrmXData.Render(tag: TXMLTag);
var
    x: TXMLTag;
begin
    // Get our context/xmlns
    _to_jid := tag.getAttribute('from');
    if (tag.Name = 'iq') then begin
        _packet := 'iq';
        _ns := tag.QueryXPData('/iq/query@xmlns')
    end
    else if (tag.Name = 'message') then begin
        _packet := 'message';
        _thread := tag.GetBasicText('thread');
    end;

    // Get the x-data container.
    x := tag.QueryXPTag('//x[@xmlns="jabber:x:data"]');
    if (x = nil) then exit;

    _type := x.GetAttribute('type');
    _responded := false;

    frameXData.Render(x);
end;

{---------------------------------------}
function TfrmXData.getResponseTag(): TXMLTag;
var
    r, q: TXMLTag;
begin
    // Get a properly formatted result or cancel packet
    r := TXMLTag.Create(_packet);
    r.setAttribute('to', _to_jid);

    if (_packet = 'message') then begin
        if (_thread <> '') then
            r.AddBasicTag('thread', _thread);
        r.AddTag('body');
    end
    else if (_packet = 'iq') then begin
        r.setAttribute('type', 'set');
        r.setAttribute('id', MainSession.generateID());

        q := r.AddTag('query');
        q.setAttribute('xmlns', _ns);
    end;

    Result := r;
end;

{---------------------------------------}
procedure TfrmXData.frameButtons1btnOKClick(Sender: TObject);
var
    r,x: TXMLTag;
begin
  inherited;

    // submit the form
    if (_type = 'form') then begin
        // do something
        if (not MainSession.Active) then begin
            MessageDlgW(_('You are currently disconnected. Please reconnect before responding to this form.'),
                mtError, [mbOK], 0);
            exit;
        end;

        try
            r := getResponseTag();
            x := frameXData.submit();
            r.AddTag(x);
            x.setAttribute('type', 'submit');
        except
            on EXDataValidationError do begin
                MessageDlgW(_(sAllRequired), mtError, [mbOK], 0);
                exit;
            end;
        end;

        MainSession.SendTag(r);
        _responded := true;
    end;

    Self.Close();
end;

{---------------------------------------}
procedure TfrmXData.frameButtons1btnCancelClick(Sender: TObject);
begin
  inherited;
    frameXData.Cancel();
end;

{---------------------------------------}
procedure TfrmXData.Cancel();
var
    r, x: TXMLTag;
begin
    if (_type = 'form') then begin
        if (not MainSession.Active) then begin
            MessageDlgW(_('You are currently disconnected. Please reconnect before responding to this form.'),
                mtError, [mbOK], 0);
            exit;
        end;
        r := getResponseTag();
        x := frameXData.cancel();
        r.AddTag(x);
        MainSession.SendTag(r);
        _responded := true;
    end;
end;

end.
