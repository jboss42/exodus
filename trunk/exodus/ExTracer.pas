unit ExTracer;
{
    Copyright 2004, Peter Millard

    This file is part of Exodus.

    Exodus is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Exodus is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Exodus; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, buttonFrame, StdCtrls;

{$ifdef TRACE_EXCEPTIONS}
type
  TfrmException = class(TForm)
    mmLog: TMemo;
    frameButtons1: TframeButtons;
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LogException(ExceptObj: TObject; ExceptAddr: Pointer; IsOS: Boolean);
  end;

var
  frmException: TfrmException;

procedure ExodusException(ExceptObj: TObject; ExceptAddr: Pointer; OSException: Boolean);
{$endif}

implementation

{$R *.dfm}

{$ifdef TRACE_EXCEPTIONS}
uses
  IdException, JclDebug, JclHookExcept, TypInfo;

procedure ExodusException(ExceptObj: TObject; ExceptAddr: Pointer; OSException: Boolean);
var
    e: Exception;
begin

    // ignore some exceptions
    e := Exception(ExceptObj);
    if (e is EConvertError) then exit;
    if (e is EIdSocketError) then exit;

    if (frmException = nil) then
        frmException := TfrmException.Create(Application);

    frmException.LogException(ExceptObj, ExceptAddr, OSException);
    with frmException do begin
        mmLog.Lines.BeginUpdate;
        mmLog.Lines.Add('');
        mmLog.Lines.Add('Stack Trace');
        JclLastExceptStackListToStrings(mmLog.Lines, True, True, True);
        mmLog.Lines.EndUpdate;
        mmLog.Lines.Add('');
        Show();
    end;
end;


procedure TfrmException.LogException(ExceptObj: TObject; ExceptAddr: Pointer; IsOS: Boolean);
var
  TmpS: string;
  ModInfo: TJclLocationInfo;
  I: Integer;
  ExceptionHandled: Boolean;
  HandlerLocation: Pointer;
  ExceptFrame: TJclExceptFrame;

begin
  TmpS := 'Exception ' + ExceptObj.ClassName;
  if ExceptObj is Exception then
    TmpS := TmpS + ': ' + Exception(ExceptObj).Message;
  if IsOS then
    TmpS := TmpS + ' (OS Exception)';
  mmLog.Lines.Add(TmpS);
  ModInfo := GetLocationInfo(ExceptAddr);
  mmLog.Lines.Add(Format(
    '  Exception occured at $%p (Module "%s", Procedure "%s", Unit "%s", Line %d)',
    [ModInfo.Address,
     ModInfo.UnitName,
     ModInfo.ProcedureName,
     ModInfo.SourceName,
     ModInfo.LineNumber]));
  if stExceptFrame in JclStackTrackingOptions then
  begin
    mmLog.Lines.Add('  Except frame-dump:');
    I := 0;
    ExceptionHandled := False;
    while (not ExceptionHandled) and
      (I < JclLastExceptFrameList.Count) do
    begin
      ExceptFrame := JclLastExceptFrameList.Items[I];
      ExceptionHandled := ExceptFrame.HandlerInfo(ExceptObj, HandlerLocation);
      if (ExceptFrame.FrameKind = efkFinally) or
          (ExceptFrame.FrameKind = efkUnknown) or
          not ExceptionHandled then
        HandlerLocation := ExceptFrame.CodeLocation;
      ModInfo := GetLocationInfo(HandlerLocation);
      TmpS := Format(
        '    Frame at $%p (type: %s',
        [ExceptFrame.ExcFrame,
         GetEnumName(TypeInfo(TExceptFrameKind), Ord(ExceptFrame.FrameKind))]);
      if ExceptionHandled then
        TmpS := TmpS + ', handles exception)'
      else
        TmpS := TmpS + ')';
      mmLog.Lines.Add(TmpS);
      if ExceptionHandled then
        mmLog.Lines.Add(Format(
          '      Handler at $%p',
          [HandlerLocation]))
      else
        mmLog.Lines.Add(Format(
          '      Code at $%p',
          [HandlerLocation]));
      mmLog.Lines.Add(Format(
        '      Module "%s", Procedure "%s", Unit "%s", Line %d',
        [ModInfo.UnitName,
         ModInfo.ProcedureName,
         ModInfo.SourceName,
         ModInfo.LineNumber]));
      Inc(I);
    end;
  end;
  mmLog.Lines.Add('');
end;

procedure TfrmException.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close();
end;

procedure TfrmException.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caHide;
end;

initialization
    frmException := nil;
    JclStackTrackingOptions := JclStackTrackingOptions + [stRawMode];
    JclStackTrackingOptions := JclStackTrackingOptions + [stExceptFrame];
    JclStackTrackingOptions := JclStackTrackingOptions + [stStaticModuleList];
    JclStartExceptionTracking;
    JclAddExceptNotifier(ExodusException);
{$endif}

end.
