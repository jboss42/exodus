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
// File generated on 2/7/2006 7:31:30 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\RosterTools\ExRosterTools.tlb (1)
// LIBID: {FB6C445F-B685-4A36-8176-A1F8BE4CFC5E}
// LCID: 0
// Helpfile: 
// HelpString: ExRosterTools Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v1.0 ExodusCOM, (D:\src\exodus\exodus\Exodus.exe)
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

  LIBID_ExRosterTools: TGUID = '{FB6C445F-B685-4A36-8176-A1F8BE4CFC5E}';

  CLASS_RosterPlugin: TGUID = '{2C1FCC87-075A-4369-9937-DDC9D91AF7BE}';
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
