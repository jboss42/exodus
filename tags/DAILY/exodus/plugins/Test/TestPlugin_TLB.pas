unit TestPlugin_TLB;

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
// File generated on 1/29/2006 1:03:44 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\src\exodus\exodus\plugins\Test\TestPlugin.tlb (1)
// LIBID: {78FCE930-6D97-4E80-A634-59897D6E8BB2}
// LCID: 0
// Helpfile: 
// HelpString: TestPlugin Library
// DepndLst: 
//   (1) v1.0 ExodusCOM, (c:\src\exodus\exodus\Exodus.exe)
//   (2) v2.0 stdole, (C:\WINDOWS\System32\STDOLE2.TLB)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, ExodusCOM_TLB, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  TestPluginMajorVersion = 1;
  TestPluginMinorVersion = 0;

  LIBID_TestPlugin: TGUID = '{78FCE930-6D97-4E80-A634-59897D6E8BB2}';

  IID_ITesterPlugin: TGUID = '{AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}';
  CLASS_TesterPlugin: TGUID = '{DE6D1148-AC93-412F-AF4B-F26C24136D2C}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ITesterPlugin = interface;
  ITesterPluginDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  TesterPlugin = IExodusPlugin;


// *********************************************************************//
// Interface: ITesterPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}
// *********************************************************************//
  ITesterPlugin = interface(IDispatch)
    ['{AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}']
  end;

// *********************************************************************//
// DispIntf:  ITesterPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}
// *********************************************************************//
  ITesterPluginDisp = dispinterface
    ['{AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}']
  end;

// *********************************************************************//
// The Class CoTesterPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass TesterPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTesterPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;

implementation

uses ComObj;

class function CoTesterPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_TesterPlugin) as IExodusPlugin;
end;

class function CoTesterPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TesterPlugin) as IExodusPlugin;
end;

end.
