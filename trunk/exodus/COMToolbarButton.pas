unit COMToolbarButton;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComCtrls, ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusToolbarButton = class(TAutoObject, IExodusToolbarButton, IExodusToolbarButton2)
  private
    _button: TToolButton;
    _menu_listener: IExodusMenuListener;

  public
    constructor Create(btn: TToolButton);

  protected
    function Get_ImageID: WideString; safecall;
    function Get_Tooltip: WideString; safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_ImageID(const Value: WideString); safecall;
    procedure Set_Tooltip(const Value: WideString); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    function Get_MenuListener: IExodusMenuListener; safecall;
    procedure Set_MenuListener(const Value: IExodusMenuListener); safecall;
    function Get_Name: Widestring; safecall;

  published
    procedure OnClick(Sender: TObject);

  end;

implementation

uses
    RosterImages, ComServ;

constructor TExodusToolbarButton.Create(btn: TToolButton);
begin
    _button := btn;
    _button.OnClick := Self.OnClick;
end;

function TExodusToolbarButton.Get_ImageID: WideString;
begin
    Result := RosterTreeImages.GetID(_button.ImageIndex);
end;

function TExodusToolbarButton.Get_Tooltip: WideString;
begin
    Result := _button.Hint;
end;

function TExodusToolbarButton.Get_Visible: WordBool;
begin
    Result := _button.Visible;
end;

procedure TExodusToolbarButton.Set_ImageID(const Value: WideString);
var
    idx: integer;
begin
    idx := RosterTreeImages.Find(Value);
    if (idx >= 0) then
        _button.ImageIndex := idx;
end;

procedure TExodusToolbarButton.Set_Tooltip(const Value: WideString);
begin
    _button.Hint := Value;
end;

procedure TExodusToolbarButton.Set_Visible(Value: WordBool);
begin
    _button.Visible := Value;
end;

function TExodusToolbarButton.Get_Enabled: WordBool;
begin
    Result := _button.Enabled;
end;

procedure TExodusToolbarButton.Set_Enabled(Value: WordBool);
begin
    _button.Enabled := Value;
end;

function TExodusToolbarButton.Get_MenuListener: IExodusMenuListener;
begin
    Result := _menu_listener;
end;

procedure TExodusToolbarButton.Set_MenuListener(
  const Value: IExodusMenuListener);
begin
    _menu_listener := Value;
end;

procedure TExodusToolbarButton.OnClick(Sender: TObject);
begin
    if (_menu_listener <> nil) then
        _menu_listener.OnMenuItemClick(_button.Name, '');
end;

function TExodusToolbarButton.Get_Name(): Widestring;
begin
    Result := _button.Name;
end; 

initialization
  TAutoObjectFactory.Create(ComServer, TExodusToolbarButton, Class_ExodusToolbarButton,
    ciMultiInstance, tmApartment);
end.
