unit DropTarget;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Dialogs, 
    Windows, Controls, ComObj, ActiveX, Exodus_TLB, StdVcl, Types;

type

  TExDropEvent = procedure(pt: TPoint; text: Widestring) of object;

  TExDropTarget = class(TInterfacedObject, IDropTarget)
  protected
    { Protected declarations }
    _control: TWinControl;
    _ref: integer;
  public

    DropEvent: TExDropEvent;

    constructor Create;
    destructor Destroy; override;

    // IDropTarget
    function DragEnter (const DataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragOver (grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragLeave : HResult; stdcall;
    function Drop (const DataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;

    function start(control: TWinControl): HRESULT;
    function stop(): HRESULT;

  end;

implementation

uses SysUtils, ComServ;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TExDropTarget.Create;
begin
    inherited Create();
    
    _ref := 0;
    DropEvent := nil;

end;

{---------------------------------------}
destructor TExDropTarget.Destroy;
begin
    inherited Destroy;
end;

{---------------------------------------}
function TExDropTarget.start(control: TWinControl): HRESULT;
begin
    Result := CoLockObjectExternal(Self, true, false);
    if (Result = S_OK) then
        Result := RegisterDragDrop(control.handle, Self);

    if (Result = S_OK) then
        _control := control
    else
        _control := nil;
end;

{---------------------------------------}
function TExDropTarget.stop(): HRESULT;
begin
    if (_control <> nil) then begin
        Result := CoLockObjectExternal(Self, false, false);
        if (Result = S_OK) then
            Result := RevokeDragDrop(_control.handle);
        _control := nil;
        end
    else
        Result := S_OK;
    // Self._Release();
end;

{---------------------------------------}
function TExDropTarget.DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
  pt: TPoint; var dwEffect: Longint): HResult;
var
    r: HResult;
    fe: TFormatEtc;
begin
    //
    with fe do begin
        // cfFormat := CF_HDROP;
        cfFormat := CF_UNICODETEXT;
        ptd := nil;
        dwAspect := DVASPECT_CONTENT;
        lindex := -1;
        tymed := TYMED_HGLOBAL;
    end;

    r := dataObj.QueryGetData(fe);
    if (r = S_OK) then
        dwEffect := DROPEFFECT_COPY
    else
        dwEffect := DROPEFFECT_NONE;

    Result := r;
end;

{---------------------------------------}
function TExDropTarget.DragOver(grfKeyState: Longint; pt: TPoint;
  var dwEffect: Longint): HResult;
begin
    //
    dwEffect := DROPEFFECT_COPY;
    Result := S_OK;
end;

{---------------------------------------}
function TExDropTarget.DragLeave: HResult;
begin
    //
    Result := S_OK;
end;

{---------------------------------------}
function TExDropTarget.Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
  var dwEffect: Longint): HResult;
var
    r: HRESULT;
    fe: TFormatEtc;
    med: TStgMedium;
    p: PWideChar;
    s: string;
    sep: integer;
begin
    //
    with fe do begin
        // cfFormat := CF_HDROP;
        cfFormat := CF_UNICODETEXT;
        ptd := nil;
        dwAspect := DVASPECT_CONTENT;
        lindex := -1;
        tymed := TYMED_HGLOBAL;
    end;

    r := dataObj.QueryGetData(fe);
    if (r <> S_OK) then begin
        dwEffect := DROPEFFECT_NONE;
        Result := r;
        exit;
    end;

    r := dataObj.GetData(fe, med);
    if (r <> S_OK) then begin
        dwEffect := DROPEFFECT_NONE;
        Result := r;
        exit;
    end;

    // get the UCS string out of the global mem storage
    p := GlobalLock(med.hGlobal);
    s := WideCharToString(p);
    GlobalUnLock(med.hGlobal);
    GlobalFree(med.hGlobal);
    ReleaseStgMedium(med);
    med.tymed := TYMED_NULL;

    // URL's typically come across in this fashion:
    // 'http://foo.com/'$0A'My HomePage title'
    sep := Pos(Chr($A), s);
    if (sep > 0) then begin
        s := Copy(s, 1, sep - 1);
    end;

    if Assigned(DropEvent) then
        DropEvent(pt, s);

    dwEffect := DROPEFFECT_COPY;
    Result := S_OK;
end;

end.
