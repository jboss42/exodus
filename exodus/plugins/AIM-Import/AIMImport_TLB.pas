unit AIMImport_TLB;

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

// PASTLWTR : $Revision: 1.3 $
// File generated on 1/3/2003 7:28:10 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\AIM-Import\AIMImport.tlb (1)
// LIBID: {1DC7B769-E8C0-42B0-BD6A-A89E9000854F}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\System32\stdvcl40.dll)
//   (3) v1.0 ExodusCOM, (D:\src\exodus\exodus\Exodus.exe)
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
  AIMImportMajorVersion = 1;
  AIMImportMinorVersion = 0;

  LIBID_AIMImport: TGUID = '{1DC7B769-E8C0-42B0-BD6A-A89E9000854F}';

  IID_IAIMImportPlugin: TGUID = '{78FCA3E3-8744-4A42-BF2D-BEFE03F0C837}';
  CLASS_AIMImportPlugin: TGUID = '{13E0E3B0-4CFB-4EE0-A508-C3B9EC969BAA}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IAIMImportPlugin = interface;
  IAIMImportPluginDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  AIMImportPlugin = IAIMImportPlugin;


// *********************************************************************//
// Interface: IAIMImportPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {78FCA3E3-8744-4A42-BF2D-BEFE03F0C837}
// *********************************************************************//
  IAIMImportPlugin = interface(IDispatch)
    ['{78FCA3E3-8744-4A42-BF2D-BEFE03F0C837}']
  end;

// *********************************************************************//
// DispIntf:  IAIMImportPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {78FCA3E3-8744-4A42-BF2D-BEFE03F0C837}
// *********************************************************************//
  IAIMImportPluginDisp = dispinterface
    ['{78FCA3E3-8744-4A42-BF2D-BEFE03F0C837}']
  end;

// *********************************************************************//
// The Class CoAIMImportPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IAIMImportPlugin exposed by              
// the CoClass AIMImportPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAIMImportPlugin = class
    class function Create: IAIMImportPlugin;
    class function CreateRemote(const MachineName: string): IAIMImportPlugin;
  end;

implementation

uses ComObj;

class function CoAIMImportPlugin.Create: IAIMImportPlugin;
begin
  Result := CreateComObject(CLASS_AIMImportPlugin) as IAIMImportPlugin;
end;

class function CoAIMImportPlugin.CreateRemote(const MachineName: string): IAIMImportPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AIMImportPlugin) as IAIMImportPlugin;
end;

end.
