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

// PASTLWTR : 1.2
// File generated on 6/16/2003 9:43:20 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\NetMeeting\ExNetMeeting.tlb (1)
// LIBID: {E6B4D6BB-6346-4D99-92BD-BAA6213E4FDB}
// LCID: 0
// Helpfile: 
// HelpString: ExNetMeeting Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
//   (2) v1.0 ExodusCOM, (C:\Program Files\Exodus\Exodus.exe)
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
  ExNetMeetingMajorVersion = 1;
  ExNetMeetingMinorVersion = 0;

  LIBID_ExNetMeeting: TGUID = '{E6B4D6BB-6346-4D99-92BD-BAA6213E4FDB}';

  CLASS_ExNetmeetingPlugin: TGUID = '{D44676BB-8F88-4A46-8981-4FFCE436AF76}';
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
