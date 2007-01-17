unit Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,  Controller,
  Unicode, JclStrings;

type
  TOptions = class(TForm)
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
    _plugin: IController;
    _judFields: TWideStringList;
    _field: WideString;

  procedure SetPlugin(plugin:IController);
  procedure SetFields(fields:TWideStringList);
  function  GetField:WideString;
  procedure SetField(field:WideString);

  public
    property  Plugin: IController write SetPlugin;
    property  Fields: TWideStringList write SetFields;
    property  Field: WideString read GetField write SetField;
  end;

var
  OptionsForm: TOptions;

implementation

{$R *.dfm}

{---------------------------------------}
procedure TOptions.SetFields(fields:TWideStringList);
var
  i: Integer;
begin
  _judFields := TWideStringList.Create();

  for i := 0 to fields.Count-1 do begin
    _judFields.Add(fields[i]);
    ComboBox1.Items.Add(_judFields[i]);
  end;
end;

{---------------------------------------}
function TOptions.GetField:WideString;
begin
  result := _field;
end;

{---------------------------------------}
procedure TOptions.SetField(field: WideString);
begin
  _field := field;
  ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(_field);
end;

{---------------------------------------}
procedure TOptions.SetPlugin(plugin:IController);
begin
  _plugin := plugin;
end;

{---------------------------------------}
procedure TOptions.Button1Click(Sender: TObject);
begin
  _plugin.ClearQuickChat;
end;

{---------------------------------------}
procedure TOptions.Button2Click(Sender: TObject);
begin
  _field := ComboBox1.Text;
  Self.ModalResult := mrOK;
  Self.CloseModal();
end;

procedure TOptions.Button3Click(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
  Self.CloseModal();
end;

end.
