unit test_dispatcher;

interface
uses
    TestFramework, XMLTag, Signals, Classes;

type
    TCbContainer = class;

    TDispatcherTest = class(TTestCase)
    private
        tag: TXMLTag;
        disp: TSignalDispatcher;
        psig: TPacketSignal;
        flag: boolean;

        _cb1: integer;

        procedure pCallback(event: string; tag: TXMLTag);
    protected
        procedure Setup; override;
        procedure TearDown; override;
    published
        procedure testCallback;
        procedure testAddRemove;
    end;

    TCbContainer = class
        idx: integer;
        procedure pCallback(event: string; tag: TXMLTag);
    end;

var
    main_disp: TSignalDispatcher;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    LibXmlParser;

{---------------------------------------}
procedure TDispatcherTest.Setup;
var
    l: TPacketListener;
begin
    //
    disp := TSignalDispatcher.Create();
    psig := TPacketSignal.Create('/packet');
    disp.AddSignal('/packet', psig);

    l := psig.addListener(pCallback, '/packet/message');
    _cb1 := l.cb_id;

    tag := TXMLTag.Create('message');
    tag.PutAttribute('id', 'id-test');
    tag.AddBasicTag('bar', 'some bar context');

    main_disp := disp;

    flag := false;
end;

{---------------------------------------}
procedure TDispatcherTest.TearDown;
begin
    //
    tag.Free;
    psig.Free;
    disp.Free;
end;

{---------------------------------------}
procedure TCbContainer.pCallback(event: string; tag: TXMLTag);
begin
    // some callback container
    main_disp.DeleteListener(idx);
end;

{---------------------------------------}
procedure TDispatcherTest.pCallback(event: string; tag: TXMLTag);
begin
    // process the tag
    flag := true;
end;

{---------------------------------------}
procedure TDispatcherTest.testCallback;
begin
    //
    flag := false;
    disp.DispatchSignal('/packet', tag);
    Check(flag, 'Primary callback was never hit.');
end;

{---------------------------------------}
procedure TDispatcherTest.testAddRemove;
var
    ct: TcbContainer;
    s: integer;
    l: TPacketListener;
begin
    // First add the new callback to the signal
    ct := TcbContainer.Create();
    s := disp.TotalCount();
    checkEquals(1, s, 'Dispatcher total count, before add is wrong');

    // Add the signal and check
    l := psig.addListener(ct.pCallback, '/packet/message');
    ct.idx := l.cb_id;
    checkEquals( (s+1), disp.TotalCount(), 'Dispatcher total count did not increase after add.');

    // cache the current count
    Check(ct.idx >= 0, 'cbContainer callback index is < 0');
    s := disp.TotalCount();

    // dispatch the tag
    disp.DispatchSignal('/packet', tag);

    // Check the new # of listeners
    CheckEquals( (s-1), disp.TotalCount(), 'Dispatch total count is incorrect');
end;

{---------------------------------------}
initialization
    TestFramework.RegisterTest(TDispatcherTest.Suite);

end.
