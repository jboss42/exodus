unit ExRosterTools_TLB;

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
// File generated on 5/17/2006 5:43:53 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\src\exodus\exodus\plugins\RosterTools\ExRosterTools.tlb (1)
// LIBID: {5EA5A7C9-CA6B-4F61-8FF1-95BFAD75397F}
// LCID: 0
// Helpfile: 
// HelpString: RosterTools Library
// DepndLst: 
//   (1) v1.0 Exodus, (C:\src\exodus\exodus\Exodus.exe)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
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
  ExRosterToolsMajorVersion = 1;
  ExRosterToolsMinorVersion = 0;

  LIBID_ExRosterTools: TGUID = '{5EA5A7C9-CA6B-4F61-8FF1-95BFAD75397F}';

  CLASS_RosterPlugin: TGUID = '{F4DAE94B-7B21-4576-A5D0-573A4E2CBD65}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RosterPlugin = IExodusPlugin;


// *********************************************************************//
// The Class CoRosterPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass RosterPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRosterPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;

implementation

uses ComObj;

class function CoRosterPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_RosterPlugin) as IExodusPlugin;
end;

class function CoRosterPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RosterPlugin) as IExodusPlugin;
end;

end.
