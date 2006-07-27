unit ExHTMLLogger_TLB;

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
// File generated on 3/21/2006 10:14:50 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\HTMLLogger\ExHTMLLogger.tlb (1)
// LIBID: {4F0D5848-3AA1-4BCF-9116-870104CA12DD}
// LCID: 0
// Helpfile: 
// HelpString: ExHTMLLogger Library
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
  ExHTMLLoggerMajorVersion = 1;
  ExHTMLLoggerMinorVersion = 0;

  LIBID_ExHTMLLogger: TGUID = '{4F0D5848-3AA1-4BCF-9116-870104CA12DD}';

  IID_IHTMLLogger: TGUID = '{15C111F4-17C7-4681-8C38-21036BD3A482}';
  CLASS_HTMLLogger: TGUID = '{BA304092-987A-42C3-A4CC-40D196BE1A4F}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IHTMLLogger = interface;
  IHTMLLoggerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  HTMLLogger = IExodusPlugin;


// *********************************************************************//
// Interface: IHTMLLogger
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {15C111F4-17C7-4681-8C38-21036BD3A482}
// *********************************************************************//
  IHTMLLogger = interface(IDispatch)
    ['{15C111F4-17C7-4681-8C38-21036BD3A482}']
  end;

// *********************************************************************//
// DispIntf:  IHTMLLoggerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {15C111F4-17C7-4681-8C38-21036BD3A482}
// *********************************************************************//
  IHTMLLoggerDisp = dispinterface
    ['{15C111F4-17C7-4681-8C38-21036BD3A482}']
  end;

// *********************************************************************//
// The Class CoHTMLLogger provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass HTMLLogger. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoHTMLLogger = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;

implementation

uses ComObj;

class function CoHTMLLogger.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_HTMLLogger) as IExodusPlugin;
end;

class function CoHTMLLogger.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HTMLLogger) as IExodusPlugin;
end;

end.
