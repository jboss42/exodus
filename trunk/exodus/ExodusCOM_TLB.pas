unit ExodusCOM_TLB;

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

// PASTLWTR : $Revision: 1.7 $
// File generated on 12/31/2002 6:52:06 PM from Type Library described below.

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
  ExodusCOMMajorVersion = 1;
  ExodusCOMMinorVersion = 0;

  LIBID_ExodusCOM: TGUID = '{219E0029-5710-4C9B-BE33-4C7F046D7792}';

  IID_IExodusController: TGUID = '{47213401-DAB2-4560-82F7-E5AB15C34397}';
  CLASS_ExodusController: TGUID = '{35B80906-4D4D-4A1D-8BB2-1F0029916422}';
  IID_IExodusChat: TGUID = '{27176DA5-4EEB-442F-9B1F-D25EF948B9CB}';
  CLASS_ExodusChat: TGUID = '{DB3F5C90-0575-47E4-8F00-EED79757A97B}';
  IID_IExodusPlugin: TGUID = '{72470D1C-9A66-4735-A7CF-446F43561C92}';
  CLASS_ExodusPlugin: TGUID = '{B4CEBD09-6E5E-4A42-8CEA-219989832597}';
  IID_IExodusChatPlugin: TGUID = '{2C576B16-DD6A-4E8C-8DEB-38E255B48A88}';
  CLASS_ExodusChatPlugin: TGUID = '{4B956942-1A82-4AE9-804F-68E1B6CA4AB4}';
  IID_IExodusRoster: TGUID = '{29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}';
  CLASS_ExodusRoster: TGUID = '{438DF52E-F892-456B-9FB0-3C64DBB85240}';
  IID_IExodusPPDB: TGUID = '{284E49F2-2006-4E48-B0E0-233867A78E54}';
  CLASS_ExodusPPDB: TGUID = '{41BB1EC9-3299-45C3-BBA9-7DD897F29826}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum ChatParts
type
  ChatParts = TOleEnum;
const
  HWND_MsgInput = $00000000;
  Ptr_MsgInput = $00000001;
  HWND_MsgOutput = $00000002;
  Ptr_MsgOutput = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IExodusController = interface;
  IExodusControllerDisp = dispinterface;
  IExodusChat = interface;
  IExodusChatDisp = dispinterface;
  IExodusPlugin = interface;
  IExodusPluginDisp = dispinterface;
  IExodusChatPlugin = interface;
  IExodusChatPluginDisp = dispinterface;
  IExodusRoster = interface;
  IExodusRosterDisp = dispinterface;
  IExodusPPDB = interface;
  IExodusPPDBDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ExodusController = IExodusController;
  ExodusChat = IExodusChat;
  ExodusPlugin = IExodusPlugin;
  ExodusChatPlugin = IExodusChatPlugin;
  ExodusRoster = IExodusRoster;
  ExodusPPDB = IExodusPPDB;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PWideString1 = ^WideString; {*}


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
    function RegisterCallback(const xpath: WideString; const callback: IExodusPlugin): Integer; safecall;
    procedure UnRegisterCallback(ID: Integer); safecall;
    procedure Send(const xml: WideString); safecall;
    function isRosterJID(const jid: WideString): WordBool; safecall;
    function isSubscribed(const jid: WideString): WordBool; safecall;
    procedure AddRosterItem(const jid: WideString; const nickname: WideString; 
                            const group: WideString); safecall;
    procedure RemoveRosterItem(const jid: WideString); safecall;
    procedure ChangePresence(const Show: WideString; const Status: WideString; Priority: Integer); safecall;
    procedure StartChat(const jid: WideString; const resource: WideString; 
                        const nickname: WideString); safecall;
    procedure GetProfile(const jid: WideString); safecall;
    procedure CreateDockableWindow(HWND: Integer; const Caption: WideString); safecall;
    function addPluginMenu(const Caption: WideString): WideString; safecall;
    procedure removePluginMenu(const ID: WideString); safecall;
    procedure monitorImplicitRegJID(const JabberID: WideString; FullJID: WordBool); safecall;
    procedure getAgentList(const Server: WideString); safecall;
    function getAgentService(const Server: WideString; const Service: WideString): WideString; safecall;
    function generateID: WideString; safecall;
    function isBlocked(const JabberID: WideString): WordBool; safecall;
    procedure Block(const JabberID: WideString); safecall;
    procedure UnBlock(const JabberID: WideString); safecall;
    function Get_Resource: WideString; safecall;
    function Get_Port: Integer; safecall;
    function Get_Priority: Integer; safecall;
    function Get_PresenceStatus: WideString; safecall;
    function Get_PresenceShow: WideString; safecall;
    function Get_IsPaused: WordBool; safecall;
    function Get_IsInvisible: WordBool; safecall;
    procedure Connect; safecall;
    procedure Disconnect; safecall;
    function getPrefAsString(const Key: WideString): WideString; safecall;
    function getPrefAsInt(const Key: WideString): Integer; safecall;
    function getPrefAsBool(const Key: WideString): WordBool; safecall;
    procedure setPrefAsString(const Key: WideString; const Value: WideString); safecall;
    procedure setPrefAsInt(const Key: WideString; Value: Integer); safecall;
    procedure setPrefAsBool(const Key: WideString; Value: WordBool); safecall;
    function findChat(const JabberID: WideString; const Resource: WideString): Integer; safecall;
    procedure startSearch(const SearchJID: WideString); safecall;
    procedure startRoom(const RoomJID: WideString; const Nickname: WideString; 
                        const Password: WideString); safecall;
    procedure startInstantMsg(const JabberID: WideString); safecall;
    procedure startBrowser(const BrowseJID: WideString); safecall;
    procedure showJoinRoom(const RoomJID: WideString; const Nickname: WideString; 
                           const Password: WideString); safecall;
    procedure showPrefs; safecall;
    procedure showCustomPresDialog; safecall;
    procedure showDebug; safecall;
    procedure showLogin; safecall;
    procedure showToast(const Message: WideString; wndHandle: Integer; imageIndex: Integer); safecall;
    procedure setPresence(const Show: WideString; const Status: WideString; Priority: Integer); safecall;
    function Get_Roster: IExodusRoster; safecall;
    function Get_PPDB: IExodusPPDB; safecall;
    property Connected: WordBool read Get_Connected;
    property Username: WideString read Get_Username;
    property Server: WideString read Get_Server;
    property Resource: WideString read Get_Resource;
    property Port: Integer read Get_Port;
    property Priority: Integer read Get_Priority;
    property PresenceStatus: WideString read Get_PresenceStatus;
    property PresenceShow: WideString read Get_PresenceShow;
    property IsPaused: WordBool read Get_IsPaused;
    property IsInvisible: WordBool read Get_IsInvisible;
    property Roster: IExodusRoster read Get_Roster;
    property PPDB: IExodusPPDB read Get_PPDB;
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
    function RegisterCallback(const xpath: WideString; const callback: IExodusPlugin): Integer; dispid 4;
    procedure UnRegisterCallback(ID: Integer); dispid 5;
    procedure Send(const xml: WideString); dispid 6;
    function isRosterJID(const jid: WideString): WordBool; dispid 7;
    function isSubscribed(const jid: WideString): WordBool; dispid 8;
    procedure AddRosterItem(const jid: WideString; const nickname: WideString; 
                            const group: WideString); dispid 9;
    procedure RemoveRosterItem(const jid: WideString); dispid 10;
    procedure ChangePresence(const Show: WideString; const Status: WideString; Priority: Integer); dispid 11;
    procedure StartChat(const jid: WideString; const resource: WideString; 
                        const nickname: WideString); dispid 12;
    procedure GetProfile(const jid: WideString); dispid 13;
    procedure CreateDockableWindow(HWND: Integer; const Caption: WideString); dispid 16;
    function addPluginMenu(const Caption: WideString): WideString; dispid 14;
    procedure removePluginMenu(const ID: WideString); dispid 15;
    procedure monitorImplicitRegJID(const JabberID: WideString; FullJID: WordBool); dispid 17;
    procedure getAgentList(const Server: WideString); dispid 18;
    function getAgentService(const Server: WideString; const Service: WideString): WideString; dispid 19;
    function generateID: WideString; dispid 20;
    function isBlocked(const JabberID: WideString): WordBool; dispid 21;
    procedure Block(const JabberID: WideString); dispid 22;
    procedure UnBlock(const JabberID: WideString); dispid 23;
    property Resource: WideString readonly dispid 24;
    property Port: Integer readonly dispid 25;
    property Priority: Integer readonly dispid 26;
    property PresenceStatus: WideString readonly dispid 28;
    property PresenceShow: WideString readonly dispid 29;
    property IsPaused: WordBool readonly dispid 30;
    property IsInvisible: WordBool readonly dispid 31;
    procedure Connect; dispid 32;
    procedure Disconnect; dispid 33;
    function getPrefAsString(const Key: WideString): WideString; dispid 34;
    function getPrefAsInt(const Key: WideString): Integer; dispid 35;
    function getPrefAsBool(const Key: WideString): WordBool; dispid 36;
    procedure setPrefAsString(const Key: WideString; const Value: WideString); dispid 37;
    procedure setPrefAsInt(const Key: WideString; Value: Integer); dispid 38;
    procedure setPrefAsBool(const Key: WideString; Value: WordBool); dispid 39;
    function findChat(const JabberID: WideString; const Resource: WideString): Integer; dispid 40;
    procedure startSearch(const SearchJID: WideString); dispid 41;
    procedure startRoom(const RoomJID: WideString; const Nickname: WideString; 
                        const Password: WideString); dispid 42;
    procedure startInstantMsg(const JabberID: WideString); dispid 43;
    procedure startBrowser(const BrowseJID: WideString); dispid 44;
    procedure showJoinRoom(const RoomJID: WideString; const Nickname: WideString; 
                           const Password: WideString); dispid 45;
    procedure showPrefs; dispid 46;
    procedure showCustomPresDialog; dispid 47;
    procedure showDebug; dispid 48;
    procedure showLogin; dispid 49;
    procedure showToast(const Message: WideString; wndHandle: Integer; imageIndex: Integer); dispid 50;
    procedure setPresence(const Show: WideString; const Status: WideString; Priority: Integer); dispid 51;
    property Roster: IExodusRoster readonly dispid 54;
    property PPDB: IExodusPPDB readonly dispid 55;
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
    function RegisterPlugin(const Plugin: IExodusChatPlugin): Integer; safecall;
    function UnRegister(ID: Integer): WordBool; safecall;
    function getMagicInt(Part: ChatParts): Integer; safecall;
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
    function RegisterPlugin(const Plugin: IExodusChatPlugin): Integer; dispid 3;
    function UnRegister(ID: Integer): WordBool; dispid 5;
    function getMagicInt(Part: ChatParts): Integer; dispid 6;
  end;

// *********************************************************************//
// Interface: IExodusPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {72470D1C-9A66-4735-A7CF-446F43561C92}
// *********************************************************************//
  IExodusPlugin = interface(IDispatch)
    ['{72470D1C-9A66-4735-A7CF-446F43561C92}']
    procedure Startup(const ExodusController: IExodusController); safecall;
    procedure Shutdown; safecall;
    procedure Process(const xml: WideString); safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat); safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat); safecall;
    procedure menuClick(const ID: WideString); safecall;
    procedure onAgentsList(const Server: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {72470D1C-9A66-4735-A7CF-446F43561C92}
// *********************************************************************//
  IExodusPluginDisp = dispinterface
    ['{72470D1C-9A66-4735-A7CF-446F43561C92}']
    procedure Startup(const ExodusController: IExodusController); dispid 1;
    procedure Shutdown; dispid 2;
    procedure Process(const xml: WideString); dispid 3;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat); dispid 4;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat); dispid 5;
    procedure menuClick(const ID: WideString); dispid 6;
    procedure onAgentsList(const Server: WideString); dispid 7;
  end;

// *********************************************************************//
// Interface: IExodusChatPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C576B16-DD6A-4E8C-8DEB-38E255B48A88}
// *********************************************************************//
  IExodusChatPlugin = interface(IDispatch)
    ['{2C576B16-DD6A-4E8C-8DEB-38E255B48A88}']
    procedure onBeforeMessage(var Body: WideString); safecall;
    function onAfterMessage(var Body: WideString): WideString; safecall;
    procedure onKeyPress(const Key: WideString); safecall;
    procedure onContextMenu(const ID: WideString); safecall;
    procedure onRecvMessage(const Body: WideString; const xml: WideString); safecall;
    procedure onClose; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusChatPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C576B16-DD6A-4E8C-8DEB-38E255B48A88}
// *********************************************************************//
  IExodusChatPluginDisp = dispinterface
    ['{2C576B16-DD6A-4E8C-8DEB-38E255B48A88}']
    procedure onBeforeMessage(var Body: WideString); dispid 1;
    function onAfterMessage(var Body: WideString): WideString; dispid 2;
    procedure onKeyPress(const Key: WideString); dispid 3;
    procedure onContextMenu(const ID: WideString); dispid 4;
    procedure onRecvMessage(const Body: WideString; const xml: WideString); dispid 5;
    procedure onClose; dispid 6;
  end;

// *********************************************************************//
// Interface: IExodusRoster
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}
// *********************************************************************//
  IExodusRoster = interface(IDispatch)
    ['{29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}']
  end;

// *********************************************************************//
// DispIntf:  IExodusRosterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}
// *********************************************************************//
  IExodusRosterDisp = dispinterface
    ['{29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}']
  end;

// *********************************************************************//
// Interface: IExodusPPDB
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {284E49F2-2006-4E48-B0E0-233867A78E54}
// *********************************************************************//
  IExodusPPDB = interface(IDispatch)
    ['{284E49F2-2006-4E48-B0E0-233867A78E54}']
  end;

// *********************************************************************//
// DispIntf:  IExodusPPDBDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {284E49F2-2006-4E48-B0E0-233867A78E54}
// *********************************************************************//
  IExodusPPDBDisp = dispinterface
    ['{284E49F2-2006-4E48-B0E0-233867A78E54}']
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

// *********************************************************************//
// The Class CoExodusPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass ExodusPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;

// *********************************************************************//
// The Class CoExodusChatPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusChatPlugin exposed by              
// the CoClass ExodusChatPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusChatPlugin = class
    class function Create: IExodusChatPlugin;
    class function CreateRemote(const MachineName: string): IExodusChatPlugin;
  end;

// *********************************************************************//
// The Class CoExodusRoster provides a Create and CreateRemote method to          
// create instances of the default interface IExodusRoster exposed by              
// the CoClass ExodusRoster. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusRoster = class
    class function Create: IExodusRoster;
    class function CreateRemote(const MachineName: string): IExodusRoster;
  end;

// *********************************************************************//
// The Class CoExodusPPDB provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPPDB exposed by              
// the CoClass ExodusPPDB. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusPPDB = class
    class function Create: IExodusPPDB;
    class function CreateRemote(const MachineName: string): IExodusPPDB;
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

class function CoExodusPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_ExodusPlugin) as IExodusPlugin;
end;

class function CoExodusPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusPlugin) as IExodusPlugin;
end;

class function CoExodusChatPlugin.Create: IExodusChatPlugin;
begin
  Result := CreateComObject(CLASS_ExodusChatPlugin) as IExodusChatPlugin;
end;

class function CoExodusChatPlugin.CreateRemote(const MachineName: string): IExodusChatPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusChatPlugin) as IExodusChatPlugin;
end;

class function CoExodusRoster.Create: IExodusRoster;
begin
  Result := CreateComObject(CLASS_ExodusRoster) as IExodusRoster;
end;

class function CoExodusRoster.CreateRemote(const MachineName: string): IExodusRoster;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusRoster) as IExodusRoster;
end;

class function CoExodusPPDB.Create: IExodusPPDB;
begin
  Result := CreateComObject(CLASS_ExodusPPDB) as IExodusPPDB;
end;

class function CoExodusPPDB.CreateRemote(const MachineName: string): IExodusPPDB;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusPPDB) as IExodusPPDB;
end;

end.
