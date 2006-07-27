unit ExJabberStats_TLB;

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
// File generated on 5/22/2006 10:08:24 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\source\exodus\exodus\plugins\JabberStats\ExJabberStats.tlb (1)
// LIBID: {B39E3BDE-7316-4019-8F34-0C8DEA778330}
// LCID: 0
// Helpfile: 
// HelpString: ExJabberStats Library
// DepndLst: 
//   (1) v1.0 Exodus, (C:\source\exodus\exodus\Exodus.exe)
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
  ExJabberStatsMajorVersion = 1;
  ExJabberStatsMinorVersion = 0;

  LIBID_ExJabberStats: TGUID = '{B39E3BDE-7316-4019-8F34-0C8DEA778330}';

  CLASS_StatsPlugin: TGUID = '{AA6AB775-9AF0-49E5-B2DB-7BD5C07F9CD0}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  StatsPlugin = IExodusPlugin;


// *********************************************************************//
// The Class CoStatsPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass StatsPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoStatsPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;

implementation

uses ComObj;

class function CoStatsPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_StatsPlugin) as IExodusPlugin;
end;

class function CoStatsPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_StatsPlugin) as IExodusPlugin;
end;

end.
