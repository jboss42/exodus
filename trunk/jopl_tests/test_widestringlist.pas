unit test_widestringlist;

interface

uses
    Unicode, TestFramework, Classes;

type
    TWideStringListTest = class(TTestCase)
    private
        sl: TWidestringList;
        //sl: TStringList;
        procedure Cleanup;
    protected
        procedure Setup; override;
        procedure TearDown; override;
    published
        procedure testAdd;
        procedure testDelete;
        procedure testInsert;
        procedure testAddObject;
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    SysUtils; 

procedure TWideStringListTest.Setup;
begin
    //
    sl := TWideStringList.Create();
    // sl := TStringList.Create();
end;

procedure TWideStringListTest.Cleanup;
var
    i: integer;
    o: TObject;
begin
    for i := 0 to sl.Count - 1 do begin
        o := sl.Objects[i];
        if (o <> nil) then
            o.Free();
        end;
end;

{---------------------------------------}
procedure TWideStringListTest.TearDown;
begin
    //
    sl.Free();
end;

{---------------------------------------}
procedure TWideStringListTest.testAdd;
var
    i: integer;
    foo: WideString;
begin
    //
    for i := 0 to 10000 do begin
        foo := 'foo_' + IntToStr(i);
        sl.Add(foo);
        end;

    assert(sl.Count = 10001, 'Invalid Ending Count.');
    Cleanup();

end;

{---------------------------------------}
procedure TWideStringListTest.testDelete;
var
    i: integer;
    foo: WideString;
begin
    //
    sl.BeginUpdate();
    for i := 0 to 10000 do begin
        foo := 'foo_' + IntToStr(i);
        sl.Add(foo);
        end;
    sl.EndUpdate();


    for i := 10000 downto 0 do begin
        if ((i mod 1000) = 0) then begin
            sl.Delete(i);
            end;
        end;

    assert(sl.Count = 9990, 'Invalid count after deletes');
    sl.Clear();
    Cleanup();
end;

{---------------------------------------}
procedure TWideStringListTest.testInsert;
var
    i: integer;
    foo: WideString;
begin
    //
    sl.BeginUpdate();
    for i := 0 to 10000 do begin
        foo := 'foo_' + IntToStr(i);
        sl.Add(foo);
        end;
    sl.EndUpdate();

    assert(sl.Count = 10001, 'Invalid count before inserts.');

    i := 0;
    while (i < sl.Count) do begin
        foo := 'bar_' + IntToStr(i);
        sl.Insert(i, foo);
        i := i + 5;
        end;

    assert(sl.Count = 12502, 'Invalid count after inserts.');
    Cleanup();
end;

{---------------------------------------}
procedure TWideStringListTest.testAddObject;
var
    i: integer;
    foo: WideString;
    o: TStringList;
begin
    //
    for i := 0 to 10000 do begin
        foo := 'foo_' + IntToStr(i);
        o := TStringList.Create();
        o.Add('blah');
        o.Add('blah');
        sl.AddObject(foo, o);
        end;

    assert(sl.Count = 10001, 'Invalid Count after add-objects');
    cleanup();

end;

{---------------------------------------}
initialization
    TestFramework.RegisterTest(TWideStringListTest.Suite);


end.
