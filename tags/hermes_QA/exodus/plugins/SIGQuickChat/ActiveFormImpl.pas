unit ActiveFormImpl;
{
    Copyright © 2006 Susquehanna International Group, LLP.
    Author: Dave Siracusa
}
{$WARN SYMBOL_PLATFORM OFF}
{$DEFINE FILTER}
interface

uses                     
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Controller,
  ActiveX, AxCtrls, SIGQuickChat_TLB, StdVcl, StdCtrls, DBCtrls, ExtCtrls,
  ComCtrls, ComboBoxExSIG;

type
  TActiveFormX = class(TActiveForm, IActiveFormX)
    DBComboBox1: TComboBoxExSIG;

  private
    _ignoreNextSearch: Integer;
    _Controller: IController;
    _lastSearch: string;
    _ChangeFired: Boolean;

    procedure WMSize(var Message: TWMSize); message WM_SIZE;

    procedure cboQCChange(Sender: TObject);
    procedure cboQCKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboQCKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);

    function  IndexOfFirst(search: String):Integer;
    function  ReadController(): IController;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy();

    property  DBComboBox:  TComboBoxExSIG read DBComboBox1;
    property  LastSearch:  string read _lastSearch;
    property  Controller: IController read ReadController write _Controller;
    procedure PreSearch();
    procedure PostSearch();
    procedure Clear(force: boolean);
    procedure AddItem(text: String; obj: TObject);
    procedure ClearSearchField(who: string);
    procedure SetTag(text: String);

  private
    { Private declarations }
    FEvents: IActiveFormXEvents;
    procedure ActivateEvent(Sender: TObject);
    procedure ClickEvent(Sender: TObject);
    procedure CreateEvent(Sender: TObject);
    procedure DblClickEvent(Sender: TObject);
    procedure DeactivateEvent(Sender: TObject);
    procedure DestroyEvent(Sender: TObject);
    procedure KeyPressEvent(Sender: TObject; var Key: Char);
    procedure MouseEnterEvent(Sender: TObject);
    procedure MouseLeaveEvent(Sender: TObject);
    procedure PaintEvent(Sender: TObject);
  protected
    function  Get_Active: WordBool; safecall;
    function  Get_AlignDisabled: WordBool; safecall;
    function  Get_AlignWithMargins: WordBool; safecall;
    function  Get_AutoScroll: WordBool; safecall;
    function  Get_AutoSize: WordBool; safecall;
    function  Get_AxBorderStyle: TxActiveFormBorderStyle; safecall;
    function  Get_Caption: WideString; safecall;
    function  Get_Color: OLE_COLOR; safecall;
    function  Get_DockSite: WordBool; safecall;
    function  Get_DoubleBuffered: WordBool; safecall;
    function  Get_DropTarget: WordBool; safecall;
    function Get_Enabled: WordBool; safecall;
    function Get_ExplicitHeight: Integer; safecall;
    function Get_ExplicitLeft: Integer; safecall;
    function Get_ExplicitTop: Integer; safecall;
    function Get_ExplicitWidth: Integer; safecall;
    function Get_Font: IFontDisp; safecall;
    function Get_HelpFile: WideString; safecall;
    function Get_KeyPreview: WordBool; safecall;
    function Get_MouseInClient: WordBool; safecall;
    function Get_PixelsPerInch: Integer; safecall;
    function Get_PopupMode: TxPopupMode; safecall;
    function Get_PrintScale: TxPrintScale; safecall;
    function Get_Scaled: WordBool; safecall;
    function Get_ScreenSnap: WordBool; safecall;
    function Get_SnapBuffer: Integer; safecall;
    function Get_UseDockManager: WordBool; safecall;
    function Get_Visible: WordBool; safecall;
    function Get_VisibleDockClientCount: Integer; safecall;
    procedure _Set_Font(var Value: IFontDisp); safecall;
    procedure Set_AlignWithMargins(Value: WordBool); safecall;
    procedure Set_AutoScroll(Value: WordBool); safecall;
    procedure Set_AutoSize(Value: WordBool); safecall;
    procedure Set_AxBorderStyle(Value: TxActiveFormBorderStyle); safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    procedure Set_Color(Value: OLE_COLOR); safecall;
    procedure Set_DockSite(Value: WordBool); safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    procedure Set_DropTarget(Value: WordBool); safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    procedure Set_Font(const Value: IFontDisp); safecall;
    procedure Set_HelpFile(const Value: WideString); safecall;
    procedure Set_KeyPreview(Value: WordBool); safecall;
    procedure Set_PixelsPerInch(Value: Integer); safecall;
    procedure Set_PopupMode(Value: TxPopupMode); safecall;
    procedure Set_PrintScale(Value: TxPrintScale); safecall;
    procedure Set_Scaled(Value: WordBool); safecall;
    procedure Set_ScreenSnap(Value: WordBool); safecall;
    procedure Set_SnapBuffer(Value: Integer); safecall;
    procedure Set_UseDockManager(Value: WordBool); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    { Protected declarations }
    procedure DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage); override;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
  public
    { Public declarations }
    procedure Initialize; override;
  end;


function GetActiveFormX(Controller: IController): TActiveFormX;
function RightStr(Const Str: String; Size: Word): String;
function MidStr(Const Str: String; From, Size: Word): String;
function LeftStr(Const Str: String; Size: Word): String;

var      ActiveFormX : TActiveFormX;

implementation

uses ComObj, ComServ, SIGQuickChatPlugin;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function RightStr(Const Str: String; Size: Word): String;
begin
  if Size > Length(Str) then Size := Length(Str) ;
  RightStr := Copy(Str, Length(Str)-Size+1, Size)
end;

function MidStr(Const Str: String; From, Size: Word): String;
begin
  MidStr := Copy(Str, From, Size)
end;

function LeftStr(Const Str: String; Size: Word): String;
begin
  LeftStr := Copy(Str, 1, Size)
end;

{---------------------------------------}
function GetActiveFormX(Controller: IController): TActiveFormX;
begin
  ActiveFormX.Controller := Controller;
  Result := ActiveFormX;
end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}

{ TActiveFormX }
constructor TActiveFormX.Create(AOwner: TComponent);
begin
  Create(AOwner);
{$IFDEF DEBUG_FORM}
  Debug(TRACE_FORM, Format('TActiveFormX.Create %x', [Integer(Self)]));
{$ENDIF}
end;

{---------------------------------------}
destructor TActiveFormX.Destroy();
begin
  inherited;
{$IFDEF DEBUG_FORM}
  Debug(TRACE_FORM, Format('TActiveFormX.Destroy %x', [Integer(Self)]));
{$ENDIF}  
  ActiveFormX := nil;
end;

{---------------------------------------}
procedure TActiveFormX.WMSize(var Message: TWMSize);
begin
{$IFDEF RESIZE_FORM_WHEN_PARENT_RESIZES}
  if (Message.Width>100) AND (Message.Width<180) then begin
    SetWindowPos(DBComboBox1.Handle, 0, DBComboBox1.Left, DBComboBox1.Top,
                Self.Width, DBComboBox1.Height, SWP_NOMOVE);
  end;
{$ENDIF}
end;

{---------------------------------------}
// Clear the edit field in the combobox
procedure TActiveFormX.ClearSearchField(who: string);
begin
  DBComboBox1.Text := '';
  DBComboBox1.SelText := '';
  DBComboBox1.DroppedDown := false;
  _lastSearch := '';
end;

{---------------------------------------}
// Set the QC Text the edit field in the combobox Tag
procedure TActiveFormX.SetTag(text: String);
begin
  DBComboBox1.Tag := text;
end;

{---------------------------------------}
// set a flag to eat
procedure TActiveFormX.cboQCKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  search: String;
begin
  _ChangeFired := false;

  search := Lowercase(LeftStr(DBComboBox1.Text, DBComboBox1.SelStart));
{$IFDEF DEBUG_FORM}
  Debug(TRACE_FORM, Format('cboQCKeyDown(%d): %s, %s, %s, %d, %d, %d, %d',
                                [Key
                                ,DBComboBox1.Text
                                ,DBComboBox1.SelText
                                ,search
                                ,DBComboBox1.SelStart
                                ,DBComboBox1.SelLength
                                ,DBCombobox1.ItemIndex
                                ,_ignoreNextSearch]));
{$ENDIF}
  if (Key = 8) then begin
    if (length(_lastSearch)=1) then begin
      ClearSearchField('cboQCKeyDown');
      Controller.RestoreQuickChatList();
    end;
{$IFDEF FILTER}
{$ELSE}
    if (length(_lastSearch)=2) then
      _ignoreNextSearch := _ignoreNextSearch + 1;
{$ENDIF}
    exit;
  end;
  // Navigation keys
  if (Key in [33, 34, 35, 37, 38, 39, 40] ) then begin
    _ignoreNextSearch := _ignoreNextSearch + 1
  end else begin
    _ignoreNextSearch := 0;
  end;
end;

{---------------------------------------}
// Handle key up's
// Escape = cancels, Enter = selects, downarrow = drop the list
procedure TActiveFormX.cboQCKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  search, selected: string;
begin
  search := Lowercase(LeftStr(DBComboBox1.Text, DBComboBox1.SelStart));
{$IFDEF DEBUG_FORM}
  Debug(TRACE_FORM, Format('cboQCKeyUp(%d): %s, %s, %s, %d, %d, %d, %d',
                                [Key
                                ,DBComboBox1.Text
                                ,DBComboBox1.SelText
                                ,search
                                ,DBComboBox1.SelStart
                                ,DBComboBox1.SelLength
                                ,DBCombobox1.ItemIndex
                                ,_ignoreNextSearch]));
{$ENDIF}
  case Key of
{$IFDEF FILTER}
    8: begin
      // Backspace key pressed
      _lastSearch := LeftStr(_lastSearch, Length(_lastSearch)-1);
      if Length(_lastSearch)>0 then
        Controller.PopulateControlWithSearchResults()
      else begin
        ClearSearchField('backspace key');
        Controller.RestoreQuickChatList();
      end;
    end;
{$ENDIF}
    27: begin
      // escape key pressed
      ClearSearchField('escape key');
      Controller.RestoreQuickChatList();
    end;
    13: begin
      // enter key pressed
      selected := DBComboBox1.Text;
      ClearSearchField('enter key');
      Controller.ExodusDebug(2, Format('Quick Chat Selected: %s', [selected]));
      Controller.Selected(selected);
    end;
    36: begin
      //  home
      if DBComboBox1.Items.Count > 0 then begin
        DBComboBox1.DroppedDown := true;
        DBComboBox1.ItemIndex := 0;
      end;
    end;
    35: begin
      //  end
      if DBComboBox1.Items.Count > 0 then begin
        DBComboBox1.DroppedDown := true;
        DBComboBox1.ItemIndex := DBComboBox1.Items.Count-1;
      end;
    end;
    40: begin
      //  down arrow
      if DBComboBox1.Items.Count > 0 then begin
        if (DBComboBox1.Text = '') then begin
          DBComboBox1.DroppedDown := true;
          DBComboBox1.ItemIndex := 0;
        end
      end;
    end
    else begin
      // Navigation keys
      if (Key in [33, 34, 35, 37, 38, 39, 40] ) then begin
        exit;
      end;
       // All other keys
{$IFDEF FILTER}
      // The combo does fire a change when it finds a fully qualified search
      // so I filter 
      if _ChangeFired=false then begin
        _lastSearch := search;
        Controller.PopulateControlWithSearchResults()
      end;
{$ENDIF}
    end;
  end;
end;

{---------------------------------------}
// Edit field changed
procedure TActiveFormX.cboQCChange(Sender: TObject);
var
  search, selected: String;
  len: Integer;
begin
  _ChangeFired := true;
  
  search := Lowercase(LeftStr(DBComboBox1.Text, DBComboBox1.SelStart));
{$IFDEF DEBUG_FORM}
  Debug(TRACE_FORM, Format('cboQCChange: %s, %s, %s, %d, %d, %d, %d',
                                [DBComboBox1.Text
                                ,DBComboBox1.SelText
                                ,search
                                ,DBComboBox1.SelStart
                                ,DBComboBox1.SelLength
                                ,DBCombobox1.ItemIndex
                                ,_ignoreNextSearch]));
{$ENDIF}
  if (length(DBComboBox1.Text) = 0) then
    exit;

  if (_ignoreNextSearch > 0) then begin
    _ignoreNextSearch := _ignoreNextSearch - 1;
    exit;
  end;

  _lastSearch := search;
  len := Length(search);

  if ( (length(DBComboBox.Text)>0) and (len=0) ) then begin
    selected := DBComboBox.Text;
    ClearSearchField('OnChange');
    Controller.ExodusDebug(2, Format('Quick Chat Selected: %s', [selected]));
    Controller.Selected(selected);
    exit;
  end;

  if (len>1) then begin
{$IFDEF FILTER}
    Controller.PopulateControlWithSearchResults();
{$ENDIF}    
    exit;
  end;

{$IFDEF DEBUG_FORM}
  Debug(TRACE_FORM, Format('%s, %s, %d, %d ', [DBComboBox1.Text, DBComboBox1.SelText, DBComboBox1.SelStart, DBComboBox1.SelLength]));
{$ENDIF}

  if (search <> '') then begin
    search := search + '*';
    Controller.ExodusDebug(2, Format('Quick Chat Search: %s', [search]));
    Controller.Search(search);
  end;
end;

{---------------------------------------}
// Search has completed, so prepare the combobox
procedure  TActiveFormX.PreSearch();
begin
  DBComboBox1.AutoComplete := false;
end;

{---------------------------------------}
function TActiveFormX.ReadController: IController;
begin
  Result := _Controller;
end;

{---------------------------------------}
function  TActiveFormX.IndexOfFirst(search: String):Integer;
var
  index, count: Integer;
  item: String;
begin
  count := DBComboBox1.Items.Count;

  for index := 0 to count - 1 do begin
    item := LeftStr(DBComboBox1.Items[index], Length(search));
    if CompareText(search, item)=0 then begin
      Result := index;
      exit;
    end;
  end;
  Result := -1;
end;

{---------------------------------------}
// Search has completed, so prepare the combobox
procedure TActiveFormX.PostSearch();
var
  index: Integer;
begin
  DBComboBox1.Refresh;
  DBComboBox1.Text := _lastSearch;
  DBComboBox1.SelLength := 0;
  DBComboBox1.SelStart := Length(_lastSearch);
{$IFNDEF NSET_INDEX_IF_THE_USER_TYPES_TOO_FAST}
  index := IndexOfFirst(_lastSearch);
  if (index >= 0) then begin
    DBCombobox1.ItemIndex := index;
    DBComboBox1.SelStart := Length(_lastSearch);
    DBComboBox1.SelLength := Length(DBComboBox1.Items[index]);
  end;
{$ENDIF}
  DBComboBox1.AutoComplete := true;

{$IFDEF DEBUG_FORM}
  Debug(TRACE_FORM, Format('Quick Chat Search Completed: Txt:%s, Sel:%s, Start:%d, SelLen:%d, Index:%d, Ignore:%',
                                [DBComboBox1.Text
                                ,DBComboBox1.SelText
                                ,DBComboBox1.SelStart
                                ,DBComboBox1.SelLength
                                ,DBCombobox1.ItemIndex
                                ,_ignoreNextSearch]));
{$ENDIF}                                

end;

{---------------------------------------}
procedure TActiveFormX.Clear(force: boolean);
begin
  Controller.ExodusDebug(2, 'Clear');
  DBComboBox1.Clear();
end;

{---------------------------------------}
// Add an item, we should use the object instead of the name
// Figure that out later
procedure TActiveFormX.AddItem(text: String; obj: TObject);
begin
  DBComboBox1.AddItem(text, obj);
end;

{---------------------------------------}
{---------------------------------------}
procedure TActiveFormX.DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage);
begin
  { Define property pages here.  Property pages are defined by calling
    DefinePropertyPage with the class id of the page.  For example,
      DefinePropertyPage(Class_ActiveFormXPage); }
end;

procedure TActiveFormX.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IActiveFormXEvents;
  inherited EventSinkChanged(EventSink);
end;

procedure TActiveFormX.Initialize;
begin
  inherited Initialize;
  OnActivate := ActivateEvent;
  OnClick := ClickEvent;
  OnCreate := CreateEvent;
  OnDblClick := DblClickEvent;
  OnDeactivate := DeactivateEvent;
  OnDestroy := DestroyEvent;
  OnKeyPress := KeyPressEvent;
  OnPaint := PaintEvent;

  _ignoreNextSearch := 0;
  _lastSearch := '';

  DBComboBox1.Tag := QUICKCHAT;
  DBComboBox1.AutoCloseUp := true;
  DBComboBox1.AutoDropDown := true;
  DBComboBox1.AutoComplete := true;
  DBComboBox1.OnChange := cboQCChange;
  DBComboBox1.OnKeyUp := cboQCKeyUp;
  DBComboBox1.OnKeyDown := cboQCKeyDown;

  DBComboBox1.DropDownCount := NUMQC;

  Self.Enabled := false;

  // This sets a global variable, consider pulling back the control via
  // GUID as IExodusToolbar was designed (not fully implemented)
  // I only set it once as Initialize gets called more than once.
  // Not sure why though...
  if ActiveFormX = nil then
    ActiveFormX := Self;        

{$IFDEF DEBUG_FORM}
  Debug(TRACE_FORM, Format('TActiveFormX.Initialize %x, %x', [Integer(Self), Integer(ActiveFormX)]));
{$ENDIF}
end;

function TActiveFormX.Get_Active: WordBool;
begin
  Result := Active;
end;

function TActiveFormX.Get_AlignDisabled: WordBool;
begin
  Result := AlignDisabled;
end;

function TActiveFormX.Get_AlignWithMargins: WordBool;
begin
  Result := AlignWithMargins;
end;

function TActiveFormX.Get_AutoScroll: WordBool;
begin
  Result := AutoScroll;
end;

function TActiveFormX.Get_AutoSize: WordBool;
begin
  Result := AutoSize;
end;

function TActiveFormX.Get_AxBorderStyle: TxActiveFormBorderStyle;
begin
  Result := Ord(AxBorderStyle);
end;

function TActiveFormX.Get_Caption: WideString;
begin
  Result := WideString(Caption);
end;

function TActiveFormX.Get_Color: OLE_COLOR;
begin
  Result := OLE_COLOR(Color);
end;

function TActiveFormX.Get_DockSite: WordBool;
begin
  Result := DockSite;
end;

function TActiveFormX.Get_DoubleBuffered: WordBool;
begin
  Result := DoubleBuffered;
end;

function TActiveFormX.Get_DropTarget: WordBool;
begin
  Result := DropTarget;
end;

function TActiveFormX.Get_Enabled: WordBool;
begin
  Result := Enabled;
end;

function TActiveFormX.Get_ExplicitHeight: Integer;
begin
  Result := ExplicitHeight;
end;

function TActiveFormX.Get_ExplicitLeft: Integer;
begin
  Result := ExplicitLeft;
end;

function TActiveFormX.Get_ExplicitTop: Integer;
begin
  Result := ExplicitTop;
end;

function TActiveFormX.Get_ExplicitWidth: Integer;
begin
  Result := ExplicitWidth;
end;

function TActiveFormX.Get_Font: IFontDisp;
begin
  GetOleFont(Font, Result);
end;

function TActiveFormX.Get_HelpFile: WideString;
begin
  Result := WideString(HelpFile);
end;

function TActiveFormX.Get_KeyPreview: WordBool;
begin
  Result := KeyPreview;
end;

function TActiveFormX.Get_MouseInClient: WordBool;
begin
  Result := MouseInClient;
end;

function TActiveFormX.Get_PixelsPerInch: Integer;
begin
  Result := PixelsPerInch;
end;

function TActiveFormX.Get_PopupMode: TxPopupMode;
begin
  Result := Ord(PopupMode);
end;

function TActiveFormX.Get_PrintScale: TxPrintScale;
begin
  Result := Ord(PrintScale);
end;

function TActiveFormX.Get_Scaled: WordBool;
begin
  Result := Scaled;
end;

function TActiveFormX.Get_ScreenSnap: WordBool;
begin
  Result := ScreenSnap;
end;

function TActiveFormX.Get_SnapBuffer: Integer;
begin
  Result := SnapBuffer;
end;

function TActiveFormX.Get_UseDockManager: WordBool;
begin
  Result := UseDockManager;
end;

function TActiveFormX.Get_Visible: WordBool;
begin
  Result := Visible;
end;

function TActiveFormX.Get_VisibleDockClientCount: Integer;
begin
  Result := VisibleDockClientCount;
end;

procedure TActiveFormX._Set_Font(var Value: IFontDisp);
begin
  SetOleFont(Font, Value);
end;

procedure TActiveFormX.ActivateEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnActivate;
end;

procedure TActiveFormX.ClickEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnClick;
end;

procedure TActiveFormX.CreateEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnCreate;
end;

procedure TActiveFormX.DblClickEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnDblClick;
end;

procedure TActiveFormX.DeactivateEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnDeactivate;
end;

procedure TActiveFormX.DestroyEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnDestroy;
end;

procedure TActiveFormX.KeyPressEvent(Sender: TObject; var Key: Char);
var
  TempKey: Smallint;
begin
  TempKey := Smallint(Key);
  if FEvents <> nil then FEvents.OnKeyPress(TempKey);
  Key := Char(TempKey);
end;

procedure TActiveFormX.MouseEnterEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnMouseEnter;
end;

procedure TActiveFormX.MouseLeaveEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnMouseLeave;
end;

procedure TActiveFormX.PaintEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnPaint;
end;

procedure TActiveFormX.Set_AlignWithMargins(Value: WordBool);
begin
  AlignWithMargins := Value;
end;

procedure TActiveFormX.Set_AutoScroll(Value: WordBool);
begin
  AutoScroll := Value;
end;

procedure TActiveFormX.Set_AutoSize(Value: WordBool);
begin
  AutoSize := Value;
end;

procedure TActiveFormX.Set_AxBorderStyle(Value: TxActiveFormBorderStyle);
begin
  AxBorderStyle := TActiveFormBorderStyle(Value);
end;

procedure TActiveFormX.Set_Caption(const Value: WideString);
begin
  Caption := TCaption(Value);
end;

procedure TActiveFormX.Set_Color(Value: OLE_COLOR);
begin
  Color := TColor(Value);
end;

procedure TActiveFormX.Set_DockSite(Value: WordBool);
begin
  DockSite := Value;
end;

procedure TActiveFormX.Set_DoubleBuffered(Value: WordBool);
begin
  DoubleBuffered := Value;
end;

procedure TActiveFormX.Set_DropTarget(Value: WordBool);
begin
  DropTarget := Value;
end;

procedure TActiveFormX.Set_Enabled(Value: WordBool);
begin
  Enabled := Value;
  DBCOmbobox1.Enabled := Value;
end;

procedure TActiveFormX.Set_Font(const Value: IFontDisp);
begin
  SetOleFont(Font, Value);
end;

procedure TActiveFormX.Set_HelpFile(const Value: WideString);
begin
  HelpFile := string(Value);
end;

procedure TActiveFormX.Set_KeyPreview(Value: WordBool);
begin
  KeyPreview := Value;
end;

procedure TActiveFormX.Set_PixelsPerInch(Value: Integer);
begin
  PixelsPerInch := Value;
end;

procedure TActiveFormX.Set_PopupMode(Value: TxPopupMode);
begin
  PopupMode := TPopupMode(Value);
end;

procedure TActiveFormX.Set_PrintScale(Value: TxPrintScale);
begin
  PrintScale := TPrintScale(Value);
end;

procedure TActiveFormX.Set_Scaled(Value: WordBool);
begin
  Scaled := Value;
end;

procedure TActiveFormX.Set_ScreenSnap(Value: WordBool);
begin
  ScreenSnap := Value;
end;

procedure TActiveFormX.Set_SnapBuffer(Value: Integer);
begin
  SnapBuffer := Value;
end;

procedure TActiveFormX.Set_UseDockManager(Value: WordBool);
begin
  UseDockManager := Value;
end;

procedure TActiveFormX.Set_Visible(Value: WordBool);
begin
  Visible := Value;
end;

initialization
  ActiveFormX := nil;
  TActiveFormFactory.Create(
    ComServer,
    TActiveFormControl,
    TActiveFormX,
    Class_ActiveFormX,
    1,
    '',
    OLEMISC_SIMPLEFRAME or OLEMISC_ACTSLIKELABEL,
    tmApartment);
end.
