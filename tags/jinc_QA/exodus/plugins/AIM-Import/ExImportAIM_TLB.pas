unit ExImportAIM_TLB;

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
// File generated on 1/30/2006 9:26:08 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\AIM-Import\ExImportAIM.tlb (1)
// LIBID: {76296895-2056-42BC-8886-4DBFD8D4C1DB}
// LCID: 0
// Helpfile: 
// HelpString: ExImportAIM Library
// DepndLst: 
//   (1) v1.0 ExodusCOM, (D:\src\exodus\exodus\Exodus.exe)
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
  ExImportAIMMajorVersion = 1;
  ExImportAIMMinorVersion = 0;

  LIBID_ExImportAIM: TGUID = '{76296895-2056-42BC-8886-4DBFD8D4C1DB}';

  CLASS_AIMPlugin: TGUID = '{811F504E-B9AA-42E5-A2A4-E49DB64D866A}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  AIMPlugin = IExodusPlugin;


// *********************************************************************//
// The Class CoAIMPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass AIMPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAIMPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;

implementation

uses ComObj;

class function CoAIMPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_AIMPlugin) as IExodusPlugin;
end;

class function CoAIMPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AIMPlugin) as IExodusPlugin;
end;

end.
