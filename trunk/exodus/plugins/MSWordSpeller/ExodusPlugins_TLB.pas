unit ExodusPlugins_TLB;

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

// PASTLWTR : $Revision: 1.2 $
// File generated on 12/12/2002 8:51:48 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\ExodusPlugin.tlb (1)
// LIBID: {053C946B-D466-4686-BC8F-CB5B5D7C9C2A}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
// Parent TypeLibrary:
//   (0) v1.0 ExodusWordSpeller, (D:\src\exodus\exodus\plugins\MSWordSpeller\ExodusWordSpeller.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ExodusPluginsMajorVersion = 1;
  ExodusPluginsMinorVersion = 0;

  LIBID_ExodusPlugins: TGUID = '{053C946B-D466-4686-BC8F-CB5B5D7C9C2A}';

  IID_IExodusPlugin: TGUID = '{ACC22059-DC3D-4C6E-B1B1-A6DB095A983E}';
  DIID_ExodusPlugin: TGUID = '{7A44F5FC-3C6D-4982-B375-1E04E899F49C}';
  IID_IExodusChatPlugin: TGUID = '{46DA66FE-CDA8-469F-A632-E9EBFB7E85FE}';
  DIID_ExodusChatPlugin: TGUID = '{39EA70E1-35B8-43DD-83EC-D2B8ED5D3481}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IExodusPlugin = interface;
  IExodusPluginDisp = dispinterface;
  ExodusPlugin = dispinterface;
  IExodusChatPlugin = interface;
  IExodusChatPluginDisp = dispinterface;
  ExodusChatPlugin = dispinterface;

// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PWideString1 = ^WideString; {*}


// *********************************************************************//
// Interface: IExodusPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ACC22059-DC3D-4C6E-B1B1-A6DB095A983E}
// *********************************************************************//
  IExodusPlugin = interface(IDispatch)
    ['{ACC22059-DC3D-4C6E-B1B1-A6DB095A983E}']
    procedure Startup(Exodus: OleVariant); safecall;
    procedure Shutdown; safecall;
    procedure Process(const xml: WideString); safecall;
    procedure NewChat(const JID: WideString; Chat: OleVariant); safecall;
    procedure NewRoom(const JID: WideString; Chat: OleVariant); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ACC22059-DC3D-4C6E-B1B1-A6DB095A983E}
// *********************************************************************//
  IExodusPluginDisp = dispinterface
    ['{ACC22059-DC3D-4C6E-B1B1-A6DB095A983E}']
    procedure Startup(Exodus: OleVariant); dispid 1;
    procedure Shutdown; dispid 2;
    procedure Process(const xml: WideString); dispid 3;
    procedure NewChat(const JID: WideString; Chat: OleVariant); dispid 4;
    procedure NewRoom(const JID: WideString; Chat: OleVariant); dispid 5;
  end;

// *********************************************************************//
// DispIntf:  ExodusPlugin
// Flags:     (4096) Dispatchable
// GUID:      {7A44F5FC-3C6D-4982-B375-1E04E899F49C}
// *********************************************************************//
  ExodusPlugin = dispinterface
    ['{7A44F5FC-3C6D-4982-B375-1E04E899F49C}']
  end;

// *********************************************************************//
// Interface: IExodusChatPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {46DA66FE-CDA8-469F-A632-E9EBFB7E85FE}
// *********************************************************************//
  IExodusChatPlugin = interface(IDispatch)
    ['{46DA66FE-CDA8-469F-A632-E9EBFB7E85FE}']
    procedure onBeforeMessage(var Body: WideString); safecall;
    function onAfterMessage(var Body: WideString): WideString; safecall;
    procedure onKeyPress(const Key: WideString); safecall;
    procedure onContextMenu(const ID: WideString); safecall;
    procedure onMsg(const Body: WideString; const xml: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusChatPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {46DA66FE-CDA8-469F-A632-E9EBFB7E85FE}
// *********************************************************************//
  IExodusChatPluginDisp = dispinterface
    ['{46DA66FE-CDA8-469F-A632-E9EBFB7E85FE}']
    procedure onBeforeMessage(var Body: WideString); dispid 1;
    function onAfterMessage(var Body: WideString): WideString; dispid 2;
    procedure onKeyPress(const Key: WideString); dispid 3;
    procedure onContextMenu(const ID: WideString); dispid 4;
    procedure onMsg(const Body: WideString; const xml: WideString); dispid 5;
  end;

// *********************************************************************//
// DispIntf:  ExodusChatPlugin
// Flags:     (4096) Dispatchable
// GUID:      {39EA70E1-35B8-43DD-83EC-D2B8ED5D3481}
// *********************************************************************//
  ExodusChatPlugin = dispinterface
    ['{39EA70E1-35B8-43DD-83EC-D2B8ED5D3481}']
  end;

implementation

uses ComObj;

end.
