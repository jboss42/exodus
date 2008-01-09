unit ExImportICQ_TLB;

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
// File generated on 3/4/2003 7:04:27 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\ICQ-Import\ExImportICQ.tlb (1)
// LIBID: {E164BC8D-3C8D-4CB8-832A-F11638E78E69}
// LCID: 0
// Helpfile: 
// HelpString: ICQ Buddy List import plugin
// DepndLst: 
//   (1) v1.0 ExodusCOM, (D:\src\exodus\runner\Exodus.exe)
//   (2) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
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
  ExImportICQMajorVersion = 1;
  ExImportICQMinorVersion = 0;

  LIBID_ExImportICQ: TGUID = '{E164BC8D-3C8D-4CB8-832A-F11638E78E69}';

  CLASS_ICQImportPlugin: TGUID = '{8F2D42B5-330E-448B-B61F-F767522DD046}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ICQImportPlugin = IExodusPlugin;


// *********************************************************************//
// The Class CoICQImportPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass ICQImportPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoICQImportPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;

implementation

uses ComObj;

class function CoICQImportPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_ICQImportPlugin) as IExodusPlugin;
end;

class function CoICQImportPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ICQImportPlugin) as IExodusPlugin;
end;

end.
