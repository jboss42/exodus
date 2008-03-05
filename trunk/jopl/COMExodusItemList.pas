unit COMExodusItemList;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, Classes, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusItemList = class(TAutoObject, IExodusItemList)
  private
    _items: TInterfaceList;

  protected
    function Get_Count: Integer; safecall;
    function Get_Item(Index: Integer): IExodusItem; safecall;
    function IndexOf(const item: IExodusItem): Integer; safecall;
    procedure Add(const item: IExodusItem); safecall;
    procedure Clear; safecall;
    procedure Delete(index: Integer); safecall;
    procedure Set_Item(Index: Integer; const Value: IExodusItem); safecall;
    procedure Remove(const Value: IExodusItem); safecall;
    function IExodusItemList.Get_Count = IExodusItemList_Get_Count;
    function IExodusItemList_Get_Count: Integer; safecall;

  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses ComServ;

constructor TExodusItemList.Create;
begin
    inherited Create;

    _items := TInterfaceList.Create;
end;
destructor TExodusItemList.Destroy;
begin
    _items.Free;

    inherited;
end;

function TExodusItemList.Get_Count: Integer;
begin
    Result := _items.Count;
end;

function TExodusItemList.Get_Item(Index: Integer): IExodusItem;
begin
    Result := IExodusItem(_items.Items[Index]);
end;
procedure TExodusItemList.Set_Item(Index: Integer; const Value: IExodusItem);
begin
    if (value <> nil) then
        _items.Items[index] := value
    else
        _items.Delete(Index);
end;

procedure TExodusItemList.Add(const item: IExodusItem);
begin
    if (IndexOf(item) = -1) then _items.Add(item);

end;
procedure TExodusItemList.Delete(index: Integer);
begin
    _items.Delete(index);
end;
procedure TExodusItemList.Clear;
begin
    _items.Clear;
end;

function TExodusItemList.IndexOf(const item: IExodusItem): Integer;
begin
    Result := _items.IndexOf(item);
end;
procedure TExodusItemList.Remove(const Value: IExodusItem);
begin

end;

function TExodusItemList.IExodusItemList_Get_Count: Integer;
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusItemList, Class_ExodusItemList,
    ciMultiInstance, tmApartment);
end.
