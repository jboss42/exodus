
{*******************************************************}
{    The Delphi Unicode Controls Project                }
{                                                       }
{      http://home.ccci.org/wolbrink                    }
{                                                       }
{ Copyright (c) 2002, Troy Wolbrink (wolbrink@ccci.org) }
{                                                       }
{*******************************************************}

unit TntDBCtrls;

{ If you want to use JCLUnicode that comes with Jedi Component Library,
    define JCL as a "Conditional Define" in the project options. }

interface

uses Classes, Windows, Messages, DB, DBCtrls, TntStdCtrls, Controls, TntControls,
{$IFDEF JCL} JclUnicode{$ELSE} Unicode {$ENDIF};

type
{TNT-WARN TDBEdit}
  TTntDBEdit = class(TDBEdit{TNT-ALLOW TDBEdit})
  private
    FDataLinkModified: Boolean;
    FAlignment: TAlignment;
    FFocused: Boolean;
    FDataLink: TFieldDataLink;
    InheritedDataChange: TNotifyEvent;
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure SetReadOnly;
  private
    function GetSelText: WideString; reintroduce;
    procedure SetSelText(const Value: WideString);
    function GetText: WideString;
    procedure SetText(const Value: WideString);
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure Change; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SelText: WideString read GetSelText write SetSelText;
    property Text: WideString read GetText write SetText;
  end;

{TNT-WARN TDBComboBox}
  TTntCustomDBComboBox = class(TDBComboBox{TNT-ALLOW TDBComboBox}, ITntComboBox)
  private
    FDataLink: TFieldDataLink;
    procedure UpdateData(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure SetReadOnly;
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
    procedure DataChange(Sender: TObject);
    procedure DoEditCharMsg(var Message: TWMChar); virtual;
    function GetComboValue: Variant; virtual; abstract;
    procedure SetComboValue(const Value: Variant); virtual; abstract;
  protected
    procedure CreateWnd; override;
    procedure WndProc(var Message: TMessage); override;
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

  TTntDBComboBox = class(TTntCustomDBComboBox)
  protected
    function GetComboValue: Variant; override;
    procedure SetComboValue(const Value: Variant); override;
  end;

function GetAsWideString(Field: TField): WideString;
procedure SetAsWideString(Field: TField; const Value: WideString);

type
{TNT-WARN TDBCheckBox}
  TTntDBCheckBox = class(TDBCheckBox{TNT-ALLOW TDBCheckBox})
  protected
    procedure Toggle; override;
  end;

procedure Register;

implementation

uses SysUtils, Forms, {$IFDEF VER140} Variants, {$ENDIF} StdCtrls;

procedure Register;
begin
  RegisterComponents('Tnt', [TTntDBEdit, TTntDBComboBox, TTntDBCheckBox]);
end;

function GetAsWideString(Field: TField): WideString;
begin
  if Field is TWideStringField then
    result := TWideStringField(Field).Value
  else
    result := Field.AsString{TNT-ALLOW AsString};
end;

procedure SetAsWideString(Field: TField; const Value: WideString);
begin
  if Field is TWideStringField then
    TWideStringField(Field).Value := Value
  else
    Field.AsString{TNT-ALLOW AsString} := Value;
end;


{ TTntDBEdit }

constructor TTntDBEdit.Create(AOwner: TComponent);
begin
  inherited;
  FDataLink := TDataLink(Perform(CM_GETDATALINK, 0, 0)) as TFieldDataLink;

  InheritedDataChange := FDataLink.OnDataChange;

  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
end;

destructor TTntDBEdit.Destroy;
begin
  FDataLink := nil;
  inherited;
end;

procedure TTntDBEdit.CreateWindowHandle(const Params: TCreateParams);
begin
  CreateUnicodeHandle(Self, Params, 'EDIT');
end;

function TTntDBEdit.GetSelText: WideString;
begin
  if (not IsWindowUnicode(Handle)) then
    Result := inherited SelText
  else
    Result := Copy(Text, SelStart + 1, SelLength);
end;

procedure TTntDBEdit.SetSelText(const Value: WideString);
begin
  if (not IsWindowUnicode(Handle)) then
    inherited SelText := Value
  else
    SendMessageW(Handle, EM_REPLACESEL, 0, Longint(PWideChar(Value)));
end;

function TTntDBEdit.GetText: WideString;
begin
  result := WideGetWindowText(Self);
end;

procedure TTntDBEdit.SetText(const Value: WideString);
begin
  WideSetWindowText(Self, Value);
end;

procedure TTntDBEdit.Change;
begin
  FDataLinkModified := True;
  inherited;
end;

procedure TTntDBEdit.CMEnter(var Message: TCMEnter);
begin
  FFocused := True;
  inherited;
  SetReadOnly;
end;

procedure TTntDBEdit.CMExit(var Message: TCMExit);
begin
  inherited;
  FFocused := False;
end;

procedure TTntDBEdit.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then
  begin
    InheritedDataChange(Sender); // properly sets FAlignment
    if FAlignment <> FDataLink.Field.Alignment then
    begin
      EditText := '';  {forces update}
      FAlignment := FDataLink.Field.Alignment;
    end;
    EditMask := FDataLink.Field.EditMask;
    if not (csDesigning in ComponentState) then
    begin
      if (FDataLink.Field.DataType in [ftString, ftWideString]) and (MaxLength = 0) then
        MaxLength := FDataLink.Field.Size;
    end;
    if FFocused and FDataLink.CanModify then
      Text := GetAsWideString(FDataLink.Field)
    else
    begin
      if (FDataLink.Field is TNumericField) then
        Text := FDataLink.Field.DisplayText
      else
        Text := GetAsWideString(FDataLink.Field);
      CheckCursor;
      if FDataLink.Editing and FDataLinkModified then
        Modified := True;
    end;
  end else
  begin
    FAlignment := taLeftJustify;
    InheritedDataChange(Sender);
  end;
  FDataLinkModified := False;
end;

procedure TTntDBEdit.SetReadOnly;
begin
  if HandleAllocated then
    SendMessage(Handle, EM_SETREADONLY, Ord(not FDataLink.CanModify), 0);
end;

procedure TTntDBEdit.EditingChange(Sender: TObject);
begin
  FDataLinkModified := False;
  SetReadOnly;
end;

procedure TTntDBEdit.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  SetAsWideString(FDataLink.Field, Text);
  FDataLinkModified := False;
end;

{ TTntCustomDBComboBox }

constructor TTntCustomDBComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TTntComboBoxStrings.Create;
  TTntComboBoxStrings(FItems).ComboBox := Self;
  FDataLink := TDataLink(Perform(CM_GETDATALINK, 0, 0)) as TFieldDataLink;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnEditingChange := EditingChange;
end;

destructor TTntCustomDBComboBox.Destroy;
begin
  FreeAndNil(FItems);
  FDataLink := nil;
  inherited;
end;

procedure TTntCustomDBComboBox.CreateWindowHandle(const Params: TCreateParams);
begin
  CreateUnicodeHandle(Self, Params, 'COMBOBOX');
end;

procedure TTntCustomDBComboBox.CreateWnd;
begin
  inherited;
  if Win32Platform = VER_PLATFORM_WIN32_NT then begin
    if ListHandle <> 0 then
      SetWindowLongW(ListHandle, GWL_WNDPROC, GetWindowLong(ListHandle, GWL_WNDPROC));
    SetWindowLongW(EditHandle, GWL_WNDPROC, GetWindowLong(EditHandle, GWL_WNDPROC));
  end;
end;

procedure TTntCustomDBComboBox.SetReadOnly;
begin
  if (Style in [csDropDown, csSimple]) and HandleAllocated then
    SendMessage(EditHandle, EM_SETREADONLY, Ord(not FDataLink.CanModify), 0);
end;

procedure TTntCustomDBComboBox.EditingChange(Sender: TObject);
begin
  SetReadOnly;
end;

procedure TTntCustomDBComboBox.CMEnter(var Message: TCMEnter);
begin
  inherited;
  SetReadOnly;
end;

procedure TTntCustomDBComboBox.WndProc(var Message: TMessage);
begin
  if (not (csDesigning in ComponentState))
  and (Message.Msg = CB_SHOWDROPDOWN)
  and (Message.WParam = 0)
  and (not FDataLink.Editing) then begin
    DataChange(Self); {Restore text}
    Dispatch(Message); {Do NOT call inherited!}
  end else
    inherited WndProc(Message);
end;

procedure TTntCustomDBComboBox.ComboWndProc(var Message: TMessage; ComboWnd: HWnd;
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

procedure TTntCustomDBComboBox.KeyPress(var Key: Char);
begin
  { Don't call inherited for VK_BACK and Delphi 6.  This combo's text will be copied to an
    AnsiString, last char deleted, and the AnsiString will be reassigned to this combo.
      This will drop all Unicode chars. }
  if Ord(Key) <> VK_BACK then
    inherited
  else if Assigned(OnKeyPress) then
    OnKeyPress(Self, Key);
end;

function TTntCustomDBComboBox.GetItems: TWideStrings;
begin
  result := FItems;
end;

procedure TTntCustomDBComboBox.SetItems(const Value: TWideStrings);
begin
  FItems.Assign(Value);
  DataChange(Self);
end;

function TTntCustomDBComboBox.GetSelText: WideString;
begin
  if (not IsWindowUnicode(Handle)) then
    Result := inherited SelText
  else begin
    Result := '';
    if Style < csDropDownList then
      Result := Copy(Text, SelStart + 1, SelLength);
  end;
end;

procedure TTntCustomDBComboBox.SetSelText(const Value: WideString);
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

function TTntCustomDBComboBox.GetText: WideString;
begin
  result := WideGetWindowText(Self);
end;

procedure TTntCustomDBComboBox.SetText(const Value: WideString);
begin
  WideSetWindowText(Self, Value);
end;

procedure TTntCustomDBComboBox.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode <> CBN_SELCHANGE then
    inherited
  else begin
    Text := Items[ItemIndex];
    Click;
    Change;
  end;
end;

procedure TTntCustomDBComboBox.DataChange(Sender: TObject);
begin
  if not (Style = csSimple) and DroppedDown then Exit;
  if FDataLink.Field <> nil then
    SetComboValue(FDataLink.Field.Value)
  else
    if csDesigning in ComponentState then
      SetComboValue(Name)
    else
      SetComboValue(Null);
end;

procedure TTntCustomDBComboBox.UpdateData(Sender: TObject);
begin
  FDataLink.Field.Value := GetComboValue;
end;

procedure TTntCustomDBComboBox.DoEditCharMsg(var Message: TWMChar);
begin
end;

function TTntCustomDBComboBox.GetSelLength: Integer;
begin
  result := SelLength;
end;

procedure TTntCustomDBComboBox.SetSelLength(Value: Integer);
begin
  SelLength := Value;
end;

function TTntCustomDBComboBox.GetSelStart: Integer;
begin
  result := SelStart;
end;

procedure TTntCustomDBComboBox.SetSelStart(Value: Integer);
begin
  SelStart := Value;
end;

function TTntCustomDBComboBox.GetItemIndex: Integer;
begin
  result := ItemIndex;
end;

procedure TTntCustomDBComboBox.SetItemIndex(const Value: Integer);
begin
  ItemIndex := Value;
end;

{ TTntDBComboBox }

procedure TTntDBComboBox.SetComboValue(const Value: Variant);

{$IFDEF VER130}
    // Delphi 6 compatiblity function
    function VarToWideStr(const V: Variant): WideString;
    begin
      if TVarData(V).VType <> varNull then Result := V else Result := '';
    end;
{$ENDIF}

var
  I: Integer;
  Redraw: Boolean;
  OldValue: WideString;
  NewValue: WideString;
begin
  OldValue := VarToWideStr(GetComboValue);
  NewValue := VarToWideStr(Value);

  if NewValue <> OldValue then
  begin
    if Style <> csDropDown then
    begin
      Redraw := (Style <> csSimple) and HandleAllocated;
      if Redraw then Items.BeginUpdate;
      try
        if NewValue = '' then I := -1 else I := Items.IndexOf(NewValue);
        ItemIndex := I;
      finally
        Items.EndUpdate;
      end;
      if I >= 0 then Exit;
    end;
    if Style in [csDropDown, csSimple] then Text := NewValue;
  end;
end;

function TTntDBComboBox.GetComboValue: Variant;
var
  I: Integer;
begin
  if Style in [csDropDown, csSimple] then Result := Text else
  begin
    I := ItemIndex;
    if I < 0 then Result := '' else Result := Items[I];
  end;
end;

{ TTntDBCheckBox }

procedure TTntDBCheckBox.Toggle;
var
  FDataLink: TDataLink;
begin
  inherited;
  FDataLink := TDataLink(Perform(CM_GETDATALINK, 0, 0)) as TFieldDataLink;
  FDataLink.UpdateRecord;
end;

end.
