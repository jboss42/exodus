unit Exodus_TLB;

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
// File generated on 12/5/2002 7:02:23 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\Exodus.tlb (1)
// LIBID: {219E0029-5710-4C9B-BE33-4C7F046D7792}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\System32\stdvcl40.dll)
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
  ExodusMajorVersion = 1;
  ExodusMinorVersion = 0;

  LIBID_Exodus: TGUID = '{219E0029-5710-4C9B-BE33-4C7F046D7792}';

  IID_IExodusController: TGUID = '{47213401-DAB2-4560-82F7-E5AB15C34397}';
  CLASS_ExodusController: TGUID = '{35B80906-4D4D-4A1D-8BB2-1F0029916422}';
  IID_IExodusChat: TGUID = '{27176DA5-4EEB-442F-9B1F-D25EF948B9CB}';
  CLASS_ExodusChat: TGUID = '{DB3F5C90-0575-47E4-8F00-EED79757A97B}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IExodusController = interface;
  IExodusControllerDisp = dispinterface;
  IExodusChat = interface;
  IExodusChatDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ExodusController = IExodusController;
  ExodusChat = IExodusChat;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}


// *********************************************************************//
// Interface: IExodusController
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {47213401-DAB2-4560-82F7-E5AB15C34397}
// *********************************************************************//
  IExodusController = interface(IDispatch)
    ['{47213401-DAB2-4560-82F7-E5AB15C34397}']
    function Get_Connected: WordBool; safecall;
    function Get_Username: WideString; safecall;
    function Get_Server: WideString; safecall;
    procedure RegisterCallback(const xpath: WideString; var callback: OleVariant); safecall;
    procedure UnRegisterCallback(callback_id: Integer); safecall;
    procedure Send(const xml: WideString); safecall;
    function isRosterJID(const jid: WideString): WordBool; safecall;
    function isSubscribed(const jid: WideString): WordBool; safecall;
    procedure AddRosterItem(const jid: WideString; const nickname: WideString; 
                            const group: WideString); safecall;
    procedure RemoveRosterItem(const jid: WideString); safecall;
    procedure ChangePresence; safecall;
    procedure StartChat(const jid: WideString; const resource: WideString; 
                        const nickname: WideString); safecall;
    procedure GetProfile(const jid: WideString); safecall;
    procedure RegisterChatPlugin(var Plugin: OleVariant); safecall;
    procedure RegisterRoomPlugin(var Plugin: OleVariant); safecall;
    procedure CreateDockableWindow(HWND: Integer); safecall;
    property Connected: WordBool read Get_Connected;
    property Username: WideString read Get_Username;
    property Server: WideString read Get_Server;
  end;

// *********************************************************************//
// DispIntf:  IExodusControllerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {47213401-DAB2-4560-82F7-E5AB15C34397}
// *********************************************************************//
  IExodusControllerDisp = dispinterface
    ['{47213401-DAB2-4560-82F7-E5AB15C34397}']
    property Connected: WordBool readonly dispid 1;
    property Username: WideString readonly dispid 2;
    property Server: WideString readonly dispid 3;
    procedure RegisterCallback(const xpath: WideString; var callback: OleVariant); dispid 4;
    procedure UnRegisterCallback(callback_id: Integer); dispid 5;
    procedure Send(const xml: WideString); dispid 6;
    function isRosterJID(const jid: WideString): WordBool; dispid 7;
    function isSubscribed(const jid: WideString): WordBool; dispid 8;
    procedure AddRosterItem(const jid: WideString; const nickname: WideString; 
                            const group: WideString); dispid 9;
    procedure RemoveRosterItem(const jid: WideString); dispid 10;
    procedure ChangePresence; dispid 11;
    procedure StartChat(const jid: WideString; const resource: WideString; 
                        const nickname: WideString); dispid 12;
    procedure GetProfile(const jid: WideString); dispid 13;
    procedure RegisterChatPlugin(var Plugin: OleVariant); dispid 14;
    procedure RegisterRoomPlugin(var Plugin: OleVariant); dispid 15;
    procedure CreateDockableWindow(HWND: Integer); dispid 16;
  end;

// *********************************************************************//
// Interface: IExodusChat
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27176DA5-4EEB-442F-9B1F-D25EF948B9CB}
// *********************************************************************//
  IExodusChat = interface(IDispatch)
    ['{27176DA5-4EEB-442F-9B1F-D25EF948B9CB}']
    function Get_jid: WideString; safecall;
    function AddContextMenu(const Caption: WideString): WideString; safecall;
    function Get_MsgOutText: WideString; safecall;
    property jid: WideString read Get_jid;
    property MsgOutText: WideString read Get_MsgOutText;
  end;

// *********************************************************************//
// DispIntf:  IExodusChatDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27176DA5-4EEB-442F-9B1F-D25EF948B9CB}
// *********************************************************************//
  IExodusChatDisp = dispinterface
    ['{27176DA5-4EEB-442F-9B1F-D25EF948B9CB}']
    property jid: WideString readonly dispid 1;
    function AddContextMenu(const Caption: WideString): WideString; dispid 2;
    property MsgOutText: WideString readonly dispid 4;
  end;

// *********************************************************************//
// The Class CoExodusController provides a Create and CreateRemote method to          
// create instances of the default interface IExodusController exposed by              
// the CoClass ExodusController. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusController = class
    class function Create: IExodusController;
    class function CreateRemote(const MachineName: string): IExodusController;
  end;

// *********************************************************************//
// The Class CoExodusChat provides a Create and CreateRemote method to          
// create instances of the default interface IExodusChat exposed by              
// the CoClass ExodusChat. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusChat = class
    class function Create: IExodusChat;
    class function CreateRemote(const MachineName: string): IExodusChat;
  end;

implementation

uses ComObj;

class function CoExodusController.Create: IExodusController;
begin
  Result := CreateComObject(CLASS_ExodusController) as IExodusController;
end;

class function CoExodusController.CreateRemote(const MachineName: string): IExodusController;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusController) as IExodusController;
end;

class function CoExodusChat.Create: IExodusChat;
begin
  Result := CreateComObject(CLASS_ExodusChat) as IExodusChat;
end;

class function CoExodusChat.CreateRemote(const MachineName: string): IExodusChat;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusChat) as IExodusChat;
end;

end.
