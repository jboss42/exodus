unit ExodusWordSpeller_TLB;

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

// PASTLWTR : $Revision: 1.4 $
// File generated on 1/3/2003 3:47:53 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\MSWordSpeller\ExodusWordSpeller.tlb (1)
// LIBID: {ADD14710-280B-4B21-8AA5-DC33EC6B1C4B}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
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
  ExodusWordSpellerMajorVersion = 1;
  ExodusWordSpellerMinorVersion = 0;

  LIBID_ExodusWordSpeller: TGUID = '{ADD14710-280B-4B21-8AA5-DC33EC6B1C4B}';

  IID_IWordSpeller: TGUID = '{402309A8-0C58-423F-B261-0694F7D8328D}';
  CLASS_WordSpeller: TGUID = '{DD794B33-096B-4B73-93F1-AD85F372B395}';
  IID_IChatSpeller: TGUID = '{A3485E71-8423-4FFF-8FA6-B3273B406A78}';
  CLASS_ChatSpeller: TGUID = '{F3A13654-7BF1-4FE2-99BC-3ECB5B5E7B15}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IWordSpeller = interface;
  IWordSpellerDisp = dispinterface;
  IChatSpeller = interface;
  IChatSpellerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  WordSpeller = IWordSpeller;
  ChatSpeller = IChatSpeller;


// *********************************************************************//
// Interface: IWordSpeller
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {402309A8-0C58-423F-B261-0694F7D8328D}
// *********************************************************************//
  IWordSpeller = interface(IDispatch)
    ['{402309A8-0C58-423F-B261-0694F7D8328D}']
  end;

// *********************************************************************//
// DispIntf:  IWordSpellerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {402309A8-0C58-423F-B261-0694F7D8328D}
// *********************************************************************//
  IWordSpellerDisp = dispinterface
    ['{402309A8-0C58-423F-B261-0694F7D8328D}']
  end;

// *********************************************************************//
// Interface: IChatSpeller
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A3485E71-8423-4FFF-8FA6-B3273B406A78}
// *********************************************************************//
  IChatSpeller = interface(IDispatch)
    ['{A3485E71-8423-4FFF-8FA6-B3273B406A78}']
  end;

// *********************************************************************//
// DispIntf:  IChatSpellerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A3485E71-8423-4FFF-8FA6-B3273B406A78}
// *********************************************************************//
  IChatSpellerDisp = dispinterface
    ['{A3485E71-8423-4FFF-8FA6-B3273B406A78}']
  end;

// *********************************************************************//
// The Class CoWordSpeller provides a Create and CreateRemote method to          
// create instances of the default interface IWordSpeller exposed by              
// the CoClass WordSpeller. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoWordSpeller = class
    class function Create: IWordSpeller;
    class function CreateRemote(const MachineName: string): IWordSpeller;
  end;

// *********************************************************************//
// The Class CoChatSpeller provides a Create and CreateRemote method to          
// create instances of the default interface IChatSpeller exposed by              
// the CoClass ChatSpeller. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoChatSpeller = class
    class function Create: IChatSpeller;
    class function CreateRemote(const MachineName: string): IChatSpeller;
  end;

implementation

uses ComObj;

class function CoWordSpeller.Create: IWordSpeller;
begin
  Result := CreateComObject(CLASS_WordSpeller) as IWordSpeller;
end;

class function CoWordSpeller.CreateRemote(const MachineName: string): IWordSpeller;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_WordSpeller) as IWordSpeller;
end;

class function CoChatSpeller.Create: IChatSpeller;
begin
  Result := CreateComObject(CLASS_ChatSpeller) as IChatSpeller;
end;

class function CoChatSpeller.CreateRemote(const MachineName: string): IChatSpeller;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ChatSpeller) as IChatSpeller;
end;

end.
