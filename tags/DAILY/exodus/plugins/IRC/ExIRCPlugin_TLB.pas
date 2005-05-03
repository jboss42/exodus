unit ExIRCPlugin_TLB;

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
// File generated on 8/25/2003 7:25:54 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\IRC\ExIRCPlugin.tlb (1)
// LIBID: {467946CF-A73A-4084-B226-57C0FA897CBF}
// LCID: 0
// Helpfile: 
// HelpString: ExIRCPlugin Library
// DepndLst: 
//   (1) v1.0 ExodusCOM, (D:\src\exodus\exodus\Exodus.exe)
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
  ExIRCPluginMajorVersion = 1;
  ExIRCPluginMinorVersion = 0;

  LIBID_ExIRCPlugin: TGUID = '{467946CF-A73A-4084-B226-57C0FA897CBF}';

  CLASS_IRCPlugin: TGUID = '{5B2D612D-7F76-4496-A6C6-6E7187D1F57F}';
  CLASS_IRCRoomPlugin: TGUID = '{1D9F8982-BCDC-49FF-95C9-B87BAE450977}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  IRCPlugin = IExodusPlugin;
  IRCRoomPlugin = IExodusChatPlugin;


// *********************************************************************//
// The Class CoIRCPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass IRCPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoIRCPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;

// *********************************************************************//
// The Class CoIRCRoomPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusChatPlugin exposed by              
// the CoClass IRCRoomPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoIRCRoomPlugin = class
    class function Create: IExodusChatPlugin;
    class function CreateRemote(const MachineName: string): IExodusChatPlugin;
  end;

implementation

uses ComObj;

class function CoIRCPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_IRCPlugin) as IExodusPlugin;
end;

class function CoIRCPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_IRCPlugin) as IExodusPlugin;
end;

class function CoIRCRoomPlugin.Create: IExodusChatPlugin;
begin
  Result := CreateComObject(CLASS_IRCRoomPlugin) as IExodusChatPlugin;
end;

class function CoIRCRoomPlugin.CreateRemote(const MachineName: string): IExodusChatPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_IRCRoomPlugin) as IExodusChatPlugin;
end;

end.
