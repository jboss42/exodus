unit ExNetMeeting_TLB;

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

// PASTLWTR : $Revision: 1.1 $
// File generated on 1/26/2003 9:07:04 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\NetMeeting\ExNetMeeting.tlb (1)
// LIBID: {D00007FF-BE47-4D97-9DC9-C700FC050CE3}
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
  ExNetMeetingMajorVersion = 1;
  ExNetMeetingMinorVersion = 0;

  LIBID_ExNetMeeting: TGUID = '{D00007FF-BE47-4D97-9DC9-C700FC050CE3}';

  CLASS_ExNetmeetingPlugin: TGUID = '{A4C0B3FE-BCA0-4AE2-A77A-0A816855DF5B}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ExNetmeetingPlugin = IExodusPlugin;


// *********************************************************************//
// The Class CoExNetmeetingPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass ExNetmeetingPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExNetmeetingPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;

implementation

uses ComObj;

class function CoExNetmeetingPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_ExNetmeetingPlugin) as IExodusPlugin;
end;

class function CoExNetmeetingPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExNetmeetingPlugin) as IExodusPlugin;
end;

end.
