unit ExASpell_TLB;

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
// File generated on 3/1/2003 12:15:51 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\ASpeller\ExASpell.tlb (1)
// LIBID: {54B1F156-FFD4-4D86-9D55-100EC4AD76FD}
// LCID: 0
// Helpfile: 
// HelpString: ExASpell Library
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
  ExASpellMajorVersion = 1;
  ExASpellMinorVersion = 0;

  LIBID_ExASpell: TGUID = '{54B1F156-FFD4-4D86-9D55-100EC4AD76FD}';

  CLASS_SpellPlugin: TGUID = '{84720F83-B439-4D99-8EB3-247FA604749F}';
  CLASS_ChatSpeller: TGUID = '{58049F15-9738-4770-BE48-A082B111B7BC}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SpellPlugin = IExodusPlugin;
  ChatSpeller = IExodusChatPlugin;


// *********************************************************************//
// The Class CoSpellPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass SpellPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSpellPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;

// *********************************************************************//
// The Class CoChatSpeller provides a Create and CreateRemote method to          
// create instances of the default interface IExodusChatPlugin exposed by              
// the CoClass ChatSpeller. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoChatSpeller = class
    class function Create: IExodusChatPlugin;
    class function CreateRemote(const MachineName: string): IExodusChatPlugin;
  end;

implementation

uses ComObj;

class function CoSpellPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_SpellPlugin) as IExodusPlugin;
end;

class function CoSpellPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SpellPlugin) as IExodusPlugin;
end;

class function CoChatSpeller.Create: IExodusChatPlugin;
begin
  Result := CreateComObject(CLASS_ChatSpeller) as IExodusChatPlugin;
end;

class function CoChatSpeller.CreateRemote(const MachineName: string): IExodusChatPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ChatSpeller) as IExodusChatPlugin;
end;

end.
