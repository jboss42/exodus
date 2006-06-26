unit ExSQLLogger_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 3/21/2006 10:14:52 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\SQLLogger\ExSQLLogger.tlb (1)
// LIBID: {8E0171A0-18AB-4B04-B55F-8BBAB8271357}
// LCID: 0
// Helpfile: 
// HelpString: ExSQLLogger Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v1.0 Exodus, (D:\src\exodus\exodus\Exodus.exe)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Exodus_TLB, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ExSQLLoggerMajorVersion = 1;
  ExSQLLoggerMinorVersion = 0;

  LIBID_ExSQLLogger: TGUID = '{8E0171A0-18AB-4B04-B55F-8BBAB8271357}';

  IID_ISQLLogger: TGUID = '{5FA146F7-920E-4DEC-A698-5391C4ED996B}';
  CLASS_SQLLogger: TGUID = '{B1D1A5F9-A60D-4257-AD11-E0F1C2F4759B}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ISQLLogger = interface;
  ISQLLoggerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SQLLogger = IExodusPlugin;


// *********************************************************************//
// Interface: ISQLLogger
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5FA146F7-920E-4DEC-A698-5391C4ED996B}
// *********************************************************************//
  ISQLLogger = interface(IDispatch)
    ['{5FA146F7-920E-4DEC-A698-5391C4ED996B}']
  end;

// *********************************************************************//
// DispIntf:  ISQLLoggerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5FA146F7-920E-4DEC-A698-5391C4ED996B}
// *********************************************************************//
  ISQLLoggerDisp = dispinterface
    ['{5FA146F7-920E-4DEC-A698-5391C4ED996B}']
  end;

// *********************************************************************//
// The Class CoSQLLogger provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass SQLLogger. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSQLLogger = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;

implementation

uses ComObj;

class function CoSQLLogger.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_SQLLogger) as IExodusPlugin;
end;

class function CoSQLLogger.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SQLLogger) as IExodusPlugin;
end;

end.
