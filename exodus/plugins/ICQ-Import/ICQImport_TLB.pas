unit ICQImport_TLB;

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

// PASTLWTR : $Revision: 1.2 $
// File generated on 1/3/2003 9:38:29 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\ICQ-Import\ICQImport.tlb (1)
// LIBID: {E164BC8D-3C8D-4CB8-832A-F11638E78E69}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
//   (3) v1.0 ExodusCOM, (D:\src\exodus\exodus\exodus.exe)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

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
  ICQImportMajorVersion = 1;
  ICQImportMinorVersion = 0;

  LIBID_ICQImport: TGUID = '{E164BC8D-3C8D-4CB8-832A-F11638E78E69}';

  IID_IICQImportPlugin: TGUID = '{B7A19EA6-E22D-47E1-BC97-63AA55533905}';
  CLASS_ICQImportPlugin: TGUID = '{8F2D42B5-330E-448B-B61F-F767522DD046}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IICQImportPlugin = interface;
  IICQImportPluginDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ICQImportPlugin = IICQImportPlugin;


// *********************************************************************//
// Interface: IICQImportPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B7A19EA6-E22D-47E1-BC97-63AA55533905}
// *********************************************************************//
  IICQImportPlugin = interface(IDispatch)
    ['{B7A19EA6-E22D-47E1-BC97-63AA55533905}']
  end;

// *********************************************************************//
// DispIntf:  IICQImportPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B7A19EA6-E22D-47E1-BC97-63AA55533905}
// *********************************************************************//
  IICQImportPluginDisp = dispinterface
    ['{B7A19EA6-E22D-47E1-BC97-63AA55533905}']
  end;

// *********************************************************************//
// The Class CoICQImportPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IICQImportPlugin exposed by              
// the CoClass ICQImportPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoICQImportPlugin = class
    class function Create: IICQImportPlugin;
    class function CreateRemote(const MachineName: string): IICQImportPlugin;
  end;

implementation

uses ComObj;

class function CoICQImportPlugin.Create: IICQImportPlugin;
begin
  Result := CreateComObject(CLASS_ICQImportPlugin) as IICQImportPlugin;
end;

class function CoICQImportPlugin.CreateRemote(const MachineName: string): IICQImportPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ICQImportPlugin) as IICQImportPlugin;
end;

end.
