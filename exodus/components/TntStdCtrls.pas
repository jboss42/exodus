
{*******************************************************}
{    The Delphi Unicode Controls Project                }
{                                                       }
{      http://home.ccci.org/wolbrink                    }
{                                                       }
{ Copyright (c) 2002, Troy Wolbrink (wolbrink@ccci.org) }
{                                                       }
{*******************************************************}

unit TntStdCtrls;

{ If you want to use JCLUnicode that comes with Jedi Component Library,
    define JCL as a "Conditional Define" in the project options. }

interface

uses
  Windows, Messages, Classes, Controls, StdCtrls, CheckLst,
{$IFDEF JCL} JclUnicode {$ELSE} Unicode {$ENDIF};

type
  TWideKeyPressEvent = procedure(Sender: TObject; var Key: WideChar) of object;

{TNT-WARN TCustomEdit}
type
  TTntCustomEdit = class(TCustomEdit{TNT-ALLOW TCustomEdit})
  private
    function GetSelText: WideString; reintroduce;
    procedure SetSelText(const Value: WideString);
    function GetText: WideString;
    procedure SetText(const Value: WideString);
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
  public
    property SelText: WideString read GetSelText write SetSelText;
    property Text: WideString read GetText write SetText;
  end;

{TNT-WARN TEdit}
  TTntEdit = class(TTntCustomEdit)
  published
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

{TNT-WARN TCustomMemo}
type
  TTntCustomMemo = class(TCustomMemo{TNT-ALLOW TCustomMemo})
  private
    FLines: TWideStrings;
    procedure SetLines(const Value: TWideStrings);
    function GetSelText: WideString; reintroduce;
    procedure SetSelText(const Value: WideString);
    function GetText: WideString;
    procedure SetText(const Value: WideString);
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SelText: WideString read GetSelText write SetSelText;
    property Text: WideString read GetText write SetText;
    property Lines: TWideStrings read FLines write SetLines;
  end;

{TNT-WARN TMemo}
  TTntMemo = class(TTntCustomMemo)
  published
    property Align;
    property Alignment;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property Lines;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordWrap;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TTntComboBoxStrings = class(TWideStrings)
  protected
    function Get(Index: Integer): WideString; override;
    function GetCount: Integer; override;
    function GetObject(Index: Integer): TObject; override;
{$IFDEF JCL}
    procedure Put(Index: Integer; const S: WideString); override;
{$ENDIF}
    procedure PutObject(Index: Integer; AObject: TObject); override;
    procedure SetUpdateState(Updating: Boolean); override;
  public
    ComboBox: TCustomComboBox{TNT-ALLOW TCustomComboBox};
    function Add(const S: WideString): Integer; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    function IndexOf(const S: WideString): Integer; override;
    procedure Insert(Index: Integer; const S: WideString); override;
  end;

type
  ITntComboBox = interface
    function GetItems: TWideStrings;
    procedure SetItems(const Value: TWideStrings);
    function GetSelLength: Integer;
    function GetSelStart: Integer;
    function GetSelText: WideString;
    procedure SetSelLength(Value: Integer);
    procedure SetSelStart(Value: Integer);
    procedure SetSelText(const Value: WideString);
    function GetText: WideString;
    procedure SetText(const Value: WideString);
    function GetItemIndex: Integer;
    procedure SetItemIndex(const Value: Integer);
    //--
    property SelLength: Integer read GetSelLength write SetSelLength;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelText: WideString read GetSelText write SetSelText;
    property Text: WideString read GetText write SetText;
    property Items: TWideStrings read GetItems write SetItems;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
  end;

{TNT-WARN TCustomComboBox}
type
  TTntCustomComboBox = class(TCustomComboBox{TNT-ALLOW TCustomComboBox}, ITntComboBox)
  private
    FItems: TWideStrings;
    function GetItems: TWideStrings;
    procedure SetItems(const Value: TWideStrings); reintroduce;
    function GetSelLength: Integer;
    procedure SetSelLength(Value: Integer);
    function GetSelStart: Integer;
    procedure SetSelStart(Value: Integer);
    function GetSelText: WideString;
    procedure SetSelText(const Value: WideString);
    function GetText: WideString;
    procedure SetText(const Value: WideString);
    function GetItemIndex: Integer; reintroduce;
    procedure SetItemIndex(const Value: Integer); reintroduce;

    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
  protected
    procedure DoEditCharMsg(var Message: TWMChar); virtual;
    procedure CreateWnd; override;
    procedure ComboWndProc(var Message: TMessage; ComboWnd: HWnd;
      ComboProc: Pointer); override;
    procedure KeyPress(var Key: Char); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
  public
    property SelText: WideString read GetSelText write SetSelText;
    property Text: WideString read GetText write SetText;
    property Items: TWideStrings read GetItems write SetItems;
  end;

{TNT-WARN TComboBox}
  TTntComboBox = class(TTntCustomComboBox)
  published
    property Style; {Must be published before Items}
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDock;
    property OnStartDrag;
    property Items; { Must be published after OnMeasureItem }
  end;

{TNT-WARN TCustomListBox}
type
  TTntCustomListBox = class(TCustomListBox{TNT-ALLOW TCustomListBox})
  private
    FItems: TWideStrings;
    procedure SetItems(const Value: TWideStrings);
  protected
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
  published
    property Items: TWideStrings read FItems write SetItems;
  end;

{TNT-WARN TListBox}
  TTntListBox = class(TTntCustomListBox)
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Columns;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Font;
    property ImeMode;
    property ImeName;
    property IntegralHeight;
    property ItemHeight;
    property Items;
    property MultiSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property Style;
    property TabOrder;
    property TabStop;
    property TabWidth;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

{TNT-WARN TCheckListBox}
  TTntCheckListBox = class(TCheckListBox{TNT-ALLOW TCheckListBox})
  private
    FItems: TWideStrings;
    procedure SetItems(const Value: TWideStrings);
    procedure DrawItemStub(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
  protected
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
  published
    property Items: TWideStrings read FItems write SetItems;
  end;

procedure Register;

implementation

uses Forms, SysUtils, Consts,
{$IFDEF VER140}
     RTLConsts,
{$ENDIF}
     TntControls, TntForms, TntClasses;

procedure Register;
begin
  RegisterComponents('Tnt', [TTntEdit, TTntComboBox, TTntListBox, TTntMemo,
                             TTntCheckListBox]);
end;

type
  TTntMemoStrings = class(TWideStrings)
  private
    Memo: TTntCustomMemo;
  protected
    function Get(Index: Integer): WideString; override;
    function GetCount: Integer; override;
{$IFDEF JCL}
    function GetText: WideString; override;
    procedure SetText(const Value: WideString); override;
    procedure PutObject(Index: Integer; AObject: TObject); override;
{$ELSE}
    function GetTextStr: WideString; override;
    procedure SetTextStr(const Value: WideString); override;
{$ENDIF}
    procedure Put(Index: Integer; const S: WideString); override;
    procedure SetUpdateState(Updating: Boolean); override;
  public
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: WideString); override;
  end;

  TAccessCustomListBox = class(TCustomListBox{TNT-ALLOW TCustomListBox});

  TTntListBoxStrings = class(TWideStrings)
  private
    ListBox: TAccessCustomListBox;
  protected
    procedure Put(Index: Integer; const S: WideString); override;
    function Get(Index: Integer): WideString; override;
    function GetCount: Integer; override;
    function GetObject(Index: Integer): TObject; override;
    procedure PutObject(Index: Integer; AObject: TObject); override;
    procedure SetUpdateState(Updating: Boolean); override;
  public
    function Add(const S: WideString): Integer; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Exchange(Index1, Index2: Integer); override;
    function IndexOf(const S: WideString): Integer; override;
    procedure Insert(Index: Integer; const S: WideString); override;
    procedure Move(CurIndex, NewIndex: Integer); override;
  end;

{ TTntCustomEdit }

procedure TTntCustomEdit.CreateWindowHandle(const Params: TCreateParams);
begin
  if SysLocale.FarEast and (Win32Platform <> VER_PLATFORM_WIN32_NT)
  and ((Params.Style and ES_READONLY) <> 0) then
    inherited
  else
    CreateUnicodeHandle(Self, Params, 'EDIT');
end;

function TTntCustomEdit.GetSelText: WideString;
begin
  if (not IsWindowUnicode(Handle)) then
    Result := inherited SelText
  else
    Result := Copy(Text, SelStart + 1, SelLength);
end;

procedure TTntCustomEdit.SetSelText(const Value: WideString);
begin
  if (not IsWindowUnicode(Handle)) then
    inherited SelText := Value
  else
    SendMessageW(Handle, EM_REPLACESEL, 0, Longint(PWideChar(Value)));
end;

function TTntCustomEdit.GetText: WideString;
begin
  result := WideGetWindowText(Self);
end;

procedure TTntCustomEdit.SetText(const Value: WideString);
begin
  WideSetWindowText(Self, Value);
end;

{ TTntMemoStrings }

function TTntMemoStrings.GetCount: Integer;
begin
  result := TCustomMemo{TNT-ALLOW TCustomMemo}(Memo).Lines.Count;
end;

function MemoLineLengthW(Handle: THandle; Index: Integer): Integer;
var
  SelStart: Integer;
begin
  SelStart := SendMessageW(Handle, EM_LINEINDEX, Index, 0);
  if SelStart < 0 then
    result := 0
  else
    result := SendMessageW(Handle, EM_LINELENGTH, SelStart, 0);
end;

function TTntMemoStrings.Get(Index: Integer): WideString;
var
  Len: Integer;
begin
  if (not IsWindowUnicode(Memo.Handle)) then
    result := TCustomMemo{TNT-ALLOW TCustomMemo}(Memo).Lines[Index]
  else begin
    SetLength(Result, MemoLineLengthW(Memo.Handle, Index));
    if Length(Result) > 0 then begin
      Word((PWideChar(Result))^) := Length(Result);
      Len := SendMessageW(Memo.Handle, EM_GETLINE, Index, Longint(PWideChar(Result)));
      SetLength(Result, Len);
    end;
  end;
end;

procedure TTntMemoStrings.Put(Index: Integer; const S: WideString);
var
  SelStart: Integer;
begin
  if (not IsWindowUnicode(Memo.Handle)) then
    TCustomMemo{TNT-ALLOW TCustomMemo}(Memo).Lines[Index] := S
  else begin
    SelStart := SendMessageW(Memo.Handle, EM_LINEINDEX, Index, 0);
    if SelStart >= 0 then
    begin
      SendMessageW(Memo.Handle, EM_SETSEL, SelStart, SelStart + MemoLineLengthW(Memo.Handle, Index));
      SendMessageW(Memo.Handle, EM_REPLACESEL, 0, Longint(PWideChar(S)));
    end;
  end;
end;

procedure TTntMemoStrings.Insert(Index: Integer; const S: Widestring);
var
  SelStart, LineLen: Integer;
  Line: WideString;
begin
  if (not IsWindowUnicode(Memo.Handle)) then
    TCustomMemo{TNT-ALLOW TCustomMemo}(Memo).Lines.Insert(Index, S)
  else begin
    if Index >= 0 then
    begin
      SelStart := SendMessageW(Memo.Handle, EM_LINEINDEX, Index, 0);
      if SelStart >= 0 then
        Line := S + #13#10
      else begin
        SelStart := SendMessageW(Memo.Handle, EM_LINEINDEX, Index - 1, 0);
        LineLen := MemoLineLengthW(Memo.Handle, Index - 1);
        if LineLen = 0 then
          Exit;
        Inc(SelStart, LineLen);
        Line := #13#10 + s;
      end;
      SendMessageW(Memo.Handle, EM_SETSEL, SelStart, SelStart);
      SendMessageW(Memo.Handle, EM_REPLACESEL, 0, Longint(PWideChar(Line)));
    end;
  end;
end;

procedure TTntMemoStrings.Delete(Index: Integer);
begin
  TCustomMemo{TNT-ALLOW TCustomMemo}(Memo).Lines.Delete(Index);
end;

procedure TTntMemoStrings.Clear;
begin
  TCustomMemo{TNT-ALLOW TCustomMemo}(Memo).Lines.Clear;
end;

procedure TTntMemoStrings.SetUpdateState(Updating: Boolean);
begin
  if Updating then
    TCustomMemo{TNT-ALLOW TCustomMemo}(Memo).Lines.BeginUpdate
  else
    TCustomMemo{TNT-ALLOW TCustomMemo}(Memo).Lines.EndUpdate
end;

{$IFDEF JCL}
function TTntMemoStrings.GetText: WideString;
{$ELSE}
function TTntMemoStrings.GetTextStr: WideString;
{$ENDIF}
begin
  Result := Memo.Text;
end;

{$IFDEF JCL}
procedure TTntMemoStrings.SetText(const Value: WideString);
{$ELSE}
procedure TTntMemoStrings.SetTextStr(const Value: WideString);
{$ENDIF}
begin
  Memo.Text := TntAdjustLineBreaks(Value);
end;

{$IFDEF JCL}
procedure TTntMemoStrings.PutObject(Index: Integer; AObject: TObject);
begin
  JCL_WideStrings_PutObject(Self, Index, AObject);
end;
{$ENDIF}

{ TTntCustomMemo }

constructor TTntCustomMemo.Create(AOwner: TComponent);
begin
  inherited;
  FLines := TTntMemoStrings.Create;
  TTntMemoStrings(FLines).Memo := Self;
end;

destructor TTntCustomMemo.Destroy;
begin
  FreeAndNil(FLines);
  inherited;
end;

procedure TTntCustomMemo.SetLines(const Value: TWideStrings);
begin
  FLines.Assign(Value);
end;

procedure TTntCustomMemo.CreateWindowHandle(const Params: TCreateParams);
begin
  if SysLocale.FarEast and (Win32Platform <> VER_PLATFORM_WIN32_NT)
  and ((Params.Style and ES_READONLY) <> 0) then
    inherited
  else
    CreateUnicodeHandle(Self, Params, 'EDIT');
end;

function TTntCustomMemo.GetSelText: WideString;
begin
  if (not IsWindowUnicode(Handle)) then
    Result := inherited SelText
  else
    Result := Copy(Text, SelStart + 1, SelLength);
end;

procedure TTntCustomMemo.SetSelText(const Value: WideString);
begin
  if (not IsWindowUnicode(Handle)) then
    inherited SelText := Value
  else
    SendMessageW(Handle, EM_REPLACESEL, 0, Longint(PWideChar(Value)));
end;

function TTntCustomMemo.GetText: WideString;
begin
  result := WideGetWindowText(Self);
end;

procedure TTntCustomMemo.SetText(const Value: WideString);
begin
  WideSetWindowText(Self, Value);
end;

{ TTntComboBoxStrings }

function TTntComboBoxStrings.GetCount: Integer;
begin
  Result := ComboBox.Items.Count;
end;

function TTntComboBoxStrings.Get(Index: Integer): WideString;
var
  Len: Integer;
begin
  if (not IsWindowUnicode(ComboBox.Handle)) then
    result := ComboBox.Items[Index]
  else begin
    Len := SendMessageW(ComboBox.Handle, CB_GETLBTEXTLEN, Index, 0);
    if Len = CB_ERR then
      Result := ''
    else begin
      SetLength(Result, Len + 1);
      Len := SendMessageW(ComboBox.Handle, CB_GETLBTEXT, Index, Longint(PWideChar(Result)));
      if Len = CB_ERR then
        Result := ''
       else
        Result := PWideChar(Result);
    end;
  end;
end;

function TTntComboBoxStrings.GetObject(Index: Integer): TObject;
begin
  result := ComboBox.Items.Objects[Index];
end;

{$IFDEF JCL}
procedure TTntComboBoxStrings.Put(Index: Integer; const S: WideString);
begin
  JCL_WideStrings_Put(Self, Index, S);
end;
{$ENDIF}

procedure TTntComboBoxStrings.PutObject(Index: Integer; AObject: TObject);
begin
  ComboBox.Items.Objects[Index] := AObject;
end;

function TTntComboBoxStrings.Add(const S: WideString): Integer;
begin
  if (not IsWindowUnicode(ComboBox.Handle)) then
    result := ComboBox.Items.Add(S)
  else begin
    Result := SendMessageW(ComboBox.Handle, CB_ADDSTRING, 0, Longint(PWideChar(S)));
    if Result < 0 then
      raise EOutOfResources.Create(SInsertLineError);
  end;
end;

procedure TTntComboBoxStrings.Insert(Index: Integer; const S: WideString);
begin
  if (not IsWindowUnicode(ComboBox.Handle)) then
    ComboBox.Items.Insert(Index, S)
  else begin
    if SendMessageW(ComboBox.Handle, CB_INSERTSTRING, Index, Longint(PWideChar(S))) < 0 then
      raise EOutOfResources.Create(SInsertLineError);
  end;
end;

procedure TTntComboBoxStrings.Delete(Index: Integer);
begin
  ComboBox.Items.Delete(Index);
end;

procedure TTntComboBoxStrings.Clear;
var
  S: WideString;
begin
  S := WideGetWindowText(ComboBox);
  SendMessage(ComboBox.Handle, CB_RESETCONTENT, 0, 0);
  WideSetWindowText(ComboBox, S);
  ComboBox.Update;
end;

procedure TTntComboBoxStrings.SetUpdateState(Updating: Boolean);
begin
  if Updating then
    ComboBox.Items.BeginUpdate
  else
    ComboBox.Items.EndUpdate
end;

function TTntComboBoxStrings.IndexOf(const S: WideString): Integer;
begin
  if (not IsWindowUnicode(ComboBox.Handle)) then
    result := ComboBox.Items.IndexOf(S)
  else
    Result := SendMessageW(ComboBox.Handle, CB_FINDSTRINGEXACT, -1, LongInt(PWideChar(S)));
end;

{ TTntCustomComboBox }

constructor TTntCustomComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TTntComboBoxStrings.Create;
  TTntComboBoxStrings(FItems).ComboBox := Self;
end;

destructor TTntCustomComboBox.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

procedure TTntCustomComboBox.CreateWindowHandle(const Params: TCreateParams);
begin
  CreateUnicodeHandle(Self, Params, 'COMBOBOX');
end;

procedure TTntCustomComboBox.CreateWnd;
begin
  inherited;
  if Win32Platform = VER_PLATFORM_WIN32_NT then begin
    if ListHandle <> 0 then
      SetWindowLongW(ListHandle, GWL_WNDPROC, GetWindowLong(ListHandle, GWL_WNDPROC));
    SetWindowLongW(EditHandle, GWL_WNDPROC, GetWindowLong(EditHandle, GWL_WNDPROC));
  end;
end;

procedure TTntCustomComboBox.ComboWndProc(var Message: TMessage; ComboWnd: HWnd;
  ComboProc: Pointer);
begin
  if (not IsWindowUnicode(ComboWnd)) then begin
    if Message.Msg = WM_CHAR then
      DoEditCharMsg(TWMKey(Message));
    inherited;
  end else begin
    try
      // UNICODE
      if IsTextMessage(Message.Msg) then
        with Message do
          Result := CallWindowProcW(ComboProc, ComboWnd, Msg, WParam, LParam)
      else if Message.Msg = WM_CHAR then begin
        MakeWMCharMsgSafeForAnsi(Message);
        DoEditCharMsg(TWMKey(Message));
        if DoKeyPress(TWMKey(Message)) then Exit;
        RestoreWMCharMsg(Message);
        with TWMKey(Message) do begin
          if ((CharCode = VK_RETURN) or (CharCode = VK_ESCAPE)) and DroppedDown then
          begin
            DroppedDown := False;
            Exit;
          end;
        end;
        with Message do
          Result := CallWindowProcW(ComboProc, ComboWnd, Msg, WParam, LParam)
      end else if not HandleIMEComposition(ComboWnd, Message) then
        inherited;
    except
      Application.HandleException(Self);
    end;
  end;
end;

procedure TTntCustomComboBox.KeyPress(var Key: Char);
begin
  { Don't call inherited for VK_BACK and Delphi 6.  This combo's text will be copied to an
    AnsiString, last char deleted, and the AnsiString will be reassigned to this combo.
      This will drop all Unicode chars. }
  if Ord(Key) <> VK_BACK then
    inherited
  else if Assigned(OnKeyPress) then
    OnKeyPress(Self, Key);
end;

function TTntCustomComboBox.GetItems: TWideStrings;
begin
  result := FItems;
end;

procedure TTntCustomComboBox.SetItems(const Value: TWideStrings);
begin
  FItems.Assign(Value);
end;

function TTntCustomComboBox.GetSelText: WideString;
begin
  if (not IsWindowUnicode(Handle)) then
    Result := inherited SelText
  else begin
    Result := '';
    if Style < csDropDownList then
      Result := Copy(Text, SelStart + 1, SelLength);
  end;
end;

procedure TTntCustomComboBox.SetSelText(const Value: WideString);
begin
  if (not IsWindowUnicode(Handle)) then
    inherited SelText := Value
  else begin
    if Style < csDropDownList then
    begin
      HandleNeeded;
      SendMessageW(EditHandle, EM_REPLACESEL, 0, Longint(PWideChar(Value)));
    end;
  end;
end;

function TTntCustomComboBox.GetText: WideString;
begin
  result := WideGetWindowText(Self);
end;

procedure TTntCustomComboBox.SetText(const Value: WideString);
begin
  WideSetWindowText(Self, Value);
end;

procedure TTntCustomComboBox.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode <> CBN_SELCHANGE then
    inherited
  else begin
    Text := Items[ItemIndex];
    Click;
    Change;
  end;
end;

procedure TTntCustomComboBox.DoEditCharMsg(var Message: TWMChar);
begin
end;

function TTntCustomComboBox.GetSelLength: Integer;
begin
  result := SelLength;
end;

procedure TTntCustomComboBox.SetSelLength(Value: Integer);
begin
  SelLength := Value;
end;

function TTntCustomComboBox.GetSelStart: Integer;
begin
  result := SelStart;
end;

procedure TTntCustomComboBox.SetSelStart(Value: Integer);
begin
  SelStart := Value;
end;

function TTntCustomComboBox.GetItemIndex: Integer;
begin
  result := ItemIndex;
end;

procedure TTntCustomComboBox.SetItemIndex(const Value: Integer);
begin
  ItemIndex := Value;
end;

{ TTntListBoxStrings }

function TTntListBoxStrings.GetCount: Integer;
begin
  Result := ListBox.Items.Count;
end;

function TTntListBoxStrings.Get(Index: Integer): WideString;
var
  Len: Integer;
begin
  if (not IsWindowUnicode(ListBox.Handle)) then
    result := ListBox.Items[Index]
  else begin
    Len := SendMessageW(ListBox.Handle, LB_GETTEXTLEN, Index, 0);
    if Len = LB_ERR then
      Error(SListIndexError, Index)
    else begin
      SetLength(Result, Len + 1);
      Len := SendMessageW(ListBox.Handle, LB_GETTEXT, Index, Longint(PWideChar(Result)));
      if Len = LB_ERR then
        Result := ''
       else
        Result := PWideChar(Result);
    end;
  end;
end;

function TTntListBoxStrings.GetObject(Index: Integer): TObject;
begin
  result := ListBox.Items.Objects[Index];
end;

procedure TTntListBoxStrings.Put(Index: Integer; const S: WideString);
var
  I: Integer;
  TempData: Longint;
begin
  I := ListBox.ItemIndex;
  TempData := ListBox.InternalGetItemData(Index);
  // Set the Item to 0 in case it is an object that gets freed during Delete
  ListBox.InternalSetItemData(Index, 0);
  Delete(Index);
  InsertObject(Index, S, nil);
  ListBox.InternalSetItemData(Index, TempData);
  ListBox.ItemIndex := I;
end;

procedure TTntListBoxStrings.PutObject(Index: Integer; AObject: TObject);
begin
  ListBox.Items.Objects[Index] := AObject;
end;

function TTntListBoxStrings.Add(const S: WideString): Integer;
begin
  if (not IsWindowUnicode(ListBox.Handle)) then
    result := ListBox.Items.Add(S)
  else begin
    Result := SendMessageW(ListBox.Handle, LB_ADDSTRING, 0, Longint(PWideChar(S)));
    if Result < 0 then
      raise EOutOfResources.Create(SInsertLineError);
  end;
end;

procedure TTntListBoxStrings.Insert(Index: Integer; const S: WideString);
begin
  if (not IsWindowUnicode(ListBox.Handle)) then
    ListBox.Items.Insert(Index, S)
  else begin
    if SendMessageW(ListBox.Handle, LB_INSERTSTRING, Index, Longint(PWideChar(S))) < 0 then
      raise EOutOfResources.Create(SInsertLineError);
  end;
end;

procedure TTntListBoxStrings.Delete(Index: Integer);
begin
  ListBox.DeleteString(Index);
end;

procedure TTntListBoxStrings.Exchange(Index1, Index2: Integer);
var
  TempData: Longint;
  TempString: WideString;
begin
  BeginUpdate;
  try
    TempString := Strings[Index1];
    TempData := ListBox.InternalGetItemData(Index1);
    Strings[Index1] := Strings[Index2];
    ListBox.InternalSetItemData(Index1, ListBox.InternalGetItemData(Index2));
    Strings[Index2] := TempString;
    ListBox.InternalSetItemData(Index2, TempData);
    if ListBox.ItemIndex = Index1 then
      ListBox.ItemIndex := Index2
    else if ListBox.ItemIndex = Index2 then
      ListBox.ItemIndex := Index1;
  finally
    EndUpdate;
  end;
end;

procedure TTntListBoxStrings.Clear;
begin
  ListBox.ResetContent;
end;

procedure TTntListBoxStrings.SetUpdateState(Updating: Boolean);
begin
  if Updating then
    ListBox.Items.BeginUpdate
  else
    ListBox.Items.EndUpdate
end;

function TTntListBoxStrings.IndexOf(const S: WideString): Integer;
begin
  if (not IsWindowUnicode(ListBox.Handle)) then
    result := ListBox.Items.IndexOf(S)
  else
    Result := SendMessageW(ListBox.Handle, LB_FINDSTRINGEXACT, -1, LongInt(PWideChar(S)));
end;

procedure TTntListBoxStrings.Move(CurIndex, NewIndex: Integer);
var
  TempData: Longint;
  TempString: WideString;
begin
  BeginUpdate;
  ListBox.FMoving := True;
  try
    if CurIndex <> NewIndex then
    begin
      TempString := Get(CurIndex);
      TempData := ListBox.InternalGetItemData(CurIndex);
      ListBox.InternalSetItemData(CurIndex, 0);
      Delete(CurIndex);
      Insert(NewIndex, TempString);
      ListBox.InternalSetItemData(NewIndex, TempData);
    end;
  finally
    ListBox.FMoving := False;
    EndUpdate;
  end;
end;

{ TTntCustomListBox }

constructor TTntCustomListBox.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TTntListBoxStrings.Create;
  TTntListBoxStrings(FItems).ListBox := TAccessCustomListBox(Self as TCustomListBox{TNT-ALLOW TCustomListBox});
end;

destructor TTntCustomListBox.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

procedure TTntCustomListBox.CreateWindowHandle(const Params: TCreateParams);
begin
  CreateUnicodeHandle(Self, Params, 'LISTBOX');
end;

procedure TTntCustomListBox.SetItems(const Value: TWideStrings);
begin
  FItems.Assign(Value);
end;

procedure TTntCustomListBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Flags: Longint;
begin
  if Assigned(OnDrawItem) then OnDrawItem(Self, Index, Rect, State) else
  begin
    Canvas.FillRect(Rect);
    if Index < Items.Count then
    begin
      Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
      if not UseRightToLeftAlignment then
        Inc(Rect.Left, 2)
      else
        Dec(Rect.Right, 2);
      if Win32Platform = VER_PLATFORM_WIN32_NT then
        DrawTextW(Canvas.Handle, PWideChar(Items[Index]), Length(Items[Index]), Rect, Flags)
      else begin
        DrawTextA(Canvas.Handle, PAnsiChar(inherited Items[Index]), Length(inherited Items[Index]), Rect, Flags)
      end;
    end;
  end;
end;

{ TTntCheckListBox }

constructor TTntCheckListBox.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TTntListBoxStrings.Create;
  TTntListBoxStrings(FItems).ListBox := TAccessCustomListBox(Self as TCustomListBox{TNT-ALLOW TCustomListBox});
end;

destructor TTntCheckListBox.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

procedure TTntCheckListBox.CreateWindowHandle(const Params: TCreateParams);
begin
  CreateUnicodeHandle(Self, Params, 'LISTBOX');
end;

procedure TTntCheckListBox.SetItems(const Value: TWideStrings);
begin
  FItems.Assign(Value);
end;

procedure TTntCheckListBox.DrawItemStub(Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
begin
end;

procedure TTntCheckListBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Flags: Longint;
  SaveEvent: TDrawItemEvent;
begin
  if Assigned(OnDrawItem) then OnDrawItem(Self, Index, Rect, State) else
  begin
    SaveEvent := OnDrawItem;
    try
      OnDrawItem := DrawItemStub;
      inherited;
    finally
      OnDrawItem := SaveEvent;
    end;
    Canvas.FillRect(Rect);
    if Index < Items.Count then
    begin
      Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
      if not UseRightToLeftAlignment then
        Inc(Rect.Left, 2)
      else
        Dec(Rect.Right, 2);
      if Win32Platform = VER_PLATFORM_WIN32_NT then
        DrawTextW(Canvas.Handle, PWideChar(Items[Index]), Length(Items[Index]), Rect, Flags)
      else begin
        DrawTextA(Canvas.Handle, PAnsiChar(inherited Items[Index]), Length(inherited Items[Index]), Rect, Flags)
      end;
    end;
  end;
end;

end.
