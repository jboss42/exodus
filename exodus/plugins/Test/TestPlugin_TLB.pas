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
// File generated on 3/21/2006 10:14:52 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\Test\TestPlugin.tlb (1)
// LIBID: {AF37C26D-7CFA-4F88-B8B1-4231A360F8C7}
// LCID: 0
// Helpfile: 
// HelpString: TestPlugin Library
// DepndLst: 
//   (1) v1.0 Exodus, (D:\src\exodus\exodus\Exodus.exe)
//   (2) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
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
  TestPluginMajorVersion = 1;
  TestPluginMinorVersion = 0;

  LIBID_TestPlugin: TGUID = '{AF37C26D-7CFA-4F88-B8B1-4231A360F8C7}';

  CLASS_TesterPlugin: TGUID = '{937A783C-8F47-4BD4-A844-42A3627DA763}';
  CLASS_TesterIQCallback: TGUID = '{A43EF53C-B2D2-4E8E-8D44-142803FC1736}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  TesterPlugin = IExodusPlugin;
  TesterIQCallback = IExodusIQListener;


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

// *********************************************************************//
// The Class CoTesterIQCallback provides a Create and CreateRemote method to          
// create instances of the default interface IExodusIQListener exposed by              
// the CoClass TesterIQCallback. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTesterIQCallback = class
    class function Create: IExodusIQListener;
    class function CreateRemote(const MachineName: string): IExodusIQListener;
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

class function CoTesterIQCallback.Create: IExodusIQListener;
begin
  Result := CreateComObject(CLASS_TesterIQCallback) as IExodusIQListener;
end;

class function CoTesterIQCallback.CreateRemote(const MachineName: string): IExodusIQListener;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TesterIQCallback) as IExodusIQListener;
end;

end.
