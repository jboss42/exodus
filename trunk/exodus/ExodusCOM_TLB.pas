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

// PASTLWTR : 1.2
// File generated on 3/9/2006 9:11:17 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\src\exodus\exodus\Exodus.tlb (1)
// LIBID: {85AA8EC3-C4AB-460B-828D-584AD1A44A2A}
// LCID: 0
// Helpfile: 
// HelpString: Exodus COM Plugin interfaces
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
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

  LIBID_ExodusCOM: TGUID = '{85AA8EC3-C4AB-460B-828D-584AD1A44A2A}';

  IID_IExodusController: TGUID = '{808426B8-8C56-49FD-AE15-5D91DE1DE5EF}';
  CLASS_ExodusController: TGUID = '{E89B1EBA-8CF8-4A00-B15D-18149A0FA830}';
  IID_IExodusChat: TGUID = '{DA56D31B-1D1D-4F33-A04E-E28611E3011E}';
  CLASS_ExodusChat: TGUID = '{80A3C1AA-71CA-4504-9A81-EE29F91C63C3}';
  IID_IExodusPlugin: TGUID = '{DCDFAD67-6CB2-4202-B29C-50D633C02596}';
  IID_IExodusChatPlugin: TGUID = '{2C576B16-DD6A-4E8C-8DEB-38E255B48A88}';
  IID_IExodusRoster: TGUID = '{29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}';
  CLASS_ExodusRoster: TGUID = '{438DF52E-F892-456B-9FB0-3C64DBB85240}';
  IID_IExodusPPDB: TGUID = '{284E49F2-2006-4E48-B0E0-233867A78E54}';
  CLASS_ExodusPPDB: TGUID = '{41BB1EC9-3299-45C3-BBA9-7DD897F29826}';
  IID_IExodusRosterItem: TGUID = '{F710F80C-C74A-4A69-8D2B-023504125B96}';
  CLASS_ExodusRosterItem: TGUID = '{9C6A0965-39B0-4D72-A143-D210FB1BA988}';
  IID_IExodusPresence: TGUID = '{D2FD3425-40CE-469F-A95C-1C80B7FF3119}';
  CLASS_ExodusPresence: TGUID = '{B9EED6FA-AB95-48CA-B485-1AF7E3CC0D0B}';
  IID_IExodusAuth: TGUID = '{D33EA5B9-23FD-4E43-B5B7-3CCFD0F5CDD0}';
  IID_IExodusRosterGroup: TGUID = '{FA63024E-3453-4551-8CA0-AFB78B2066AD}';
  CLASS_ExodusRosterGroup: TGUID = '{21D07EDA-E275-4F43-9933-D1C9F45FCA15}';
  IID_IExodusRosterImages: TGUID = '{F4AAF511-D144-42E7-B108-8A196D4BD115}';
  CLASS_ExodusRosterImages: TGUID = '{1ADA45EB-EE12-4AC1-9E2B-AF1723DD1A28}';
  IID_IExodusEntityCache: TGUID = '{6759BFE4-C72D-42E3-86A3-1F343E848933}';
  CLASS_ExodusEntityCache: TGUID = '{560DA524-0368-4DD1-8FD6-DEB5C4D3836F}';
  IID_IExodusEntity: TGUID = '{1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}';
  CLASS_ExodusEntity: TGUID = '{E3AC5A8C-1771-4851-8CF0-106B4AD1AEBF}';
  IID_IExodusControl: TGUID = '{0B992E91-DAD7-4CDC-9FD6-8007A63700E0}';
  IID_IExodusControlCheckBox: TGUID = '{896CCC11-8929-4FEC-BC95-C96E5027C1F6}';
  IID_IExodusControlComboBox: TGUID = '{16D21C8F-EF88-4E93-87C6-CD8F8C1EE7F7}';
  IID_IExodusControlEdit: TGUID = '{A7B8A353-FF1E-4933-9A01-BD7B0FDC6F02}';
  IID_IExodusControlFont: TGUID = '{D8297D0C-A316-4E9D-A89C-095CFAE51141}';
  IID_IExodusControlLabel: TGUID = '{F53704E6-83C2-4021-97A5-169BC58D9E03}';
  IID_IExodusControlListBox: TGUID = '{F34F969E-4BC2-4ADE-8648-A8F618FCC205}';
  IID_IExodusControlMenuItem: TGUID = '{EFBC071A-460A-4E1B-89EC-25B23460BA93}';
  IID_IExodusControlPanel: TGUID = '{BA37BB99-F039-49B7-AB56-819E87B0472F}';
  IID_IExodusControlPopupMenu: TGUID = '{F80CD345-A91C-40C8-89CD-AD5BE532B9C2}';
  IID_IExodusControlRadioButton: TGUID = '{87FAD954-03E1-4657-B58D-9947087EAAEC}';
  IID_IExodusControlRichEdit: TGUID = '{3997314D-4068-43E7-ACEB-150FF196069C}';
  IID_IExodusControlButton: TGUID = '{0D41733E-3505-46FB-B199-C6046E1C84C7}';
  IID_IExodusIQListener: TGUID = '{57DFE494-4509-4972-A93B-6C7E6A9D6A59}';

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

// Constants for enum ActiveItem
type
  ActiveItem = TOleEnum;
const
  RosterItem = $00000000;
  Bookmark = $00000001;
  Group = $00000002;

// Constants for enum ExodusControlTypes
type
  ExodusControlTypes = TOleEnum;
const
  ExodusControlButton = $00000000;
  ExodusControlCheckBox = $00000001;
  ExodusControlComboBox = $00000002;
  ExodusControlEdit = $00000003;
  ExodusControlFont = $00000004;
  ExodusControlLabel = $00000005;
  ExodusControlListBox = $00000006;
  ExodusControlMenuItem = $00000007;
  ExodusControlPanel = $00000008;
  ExodusControlPopupMenu = $00000009;
  ExodusControlRadioButton = $0000000A;
  ExodusControlRichEdit = $0000000B;

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
  IExodusRosterItem = interface;
  IExodusRosterItemDisp = dispinterface;
  IExodusPresence = interface;
  IExodusPresenceDisp = dispinterface;
  IExodusAuth = interface;
  IExodusAuthDisp = dispinterface;
  IExodusRosterGroup = interface;
  IExodusRosterGroupDisp = dispinterface;
  IExodusRosterImages = interface;
  IExodusRosterImagesDisp = dispinterface;
  IExodusEntityCache = interface;
  IExodusEntityCacheDisp = dispinterface;
  IExodusEntity = interface;
  IExodusEntityDisp = dispinterface;
  IExodusControl = interface;
  IExodusControlDisp = dispinterface;
  IExodusControlCheckBox = interface;
  IExodusControlCheckBoxDisp = dispinterface;
  IExodusControlComboBox = interface;
  IExodusControlComboBoxDisp = dispinterface;
  IExodusControlEdit = interface;
  IExodusControlEditDisp = dispinterface;
  IExodusControlFont = interface;
  IExodusControlFontDisp = dispinterface;
  IExodusControlLabel = interface;
  IExodusControlLabelDisp = dispinterface;
  IExodusControlListBox = interface;
  IExodusControlListBoxDisp = dispinterface;
  IExodusControlMenuItem = interface;
  IExodusControlMenuItemDisp = dispinterface;
  IExodusControlPanel = interface;
  IExodusControlPanelDisp = dispinterface;
  IExodusControlPopupMenu = interface;
  IExodusControlPopupMenuDisp = dispinterface;
  IExodusControlRadioButton = interface;
  IExodusControlRadioButtonDisp = dispinterface;
  IExodusControlRichEdit = interface;
  IExodusControlRichEditDisp = dispinterface;
  IExodusControlButton = interface;
  IExodusControlButtonDisp = dispinterface;
  IExodusIQListener = interface;
  IExodusIQListenerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ExodusController = IExodusController;
  ExodusChat = IExodusChat;
  ExodusRoster = IExodusRoster;
  ExodusPPDB = IExodusPPDB;
  ExodusRosterItem = IExodusRosterItem;
  ExodusPresence = IExodusPresence;
  ExodusRosterGroup = IExodusRosterGroup;
  ExodusRosterImages = IExodusRosterImages;
  ExodusEntityCache = IExodusEntityCache;
  ExodusEntity = IExodusEntity;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PWideString1 = ^WideString; {*}


// *********************************************************************//
// Interface: IExodusController
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {808426B8-8C56-49FD-AE15-5D91DE1DE5EF}
// *********************************************************************//
  IExodusController = interface(IDispatch)
    ['{808426B8-8C56-49FD-AE15-5D91DE1DE5EF}']
    function Get_Connected: WordBool; safecall;
    function Get_Username: WideString; safecall;
    function Get_Server: WideString; safecall;
    function RegisterCallback(const xpath: WideString; const callback: IExodusPlugin): Integer; safecall;
    procedure UnRegisterCallback(ID: Integer); safecall;
    procedure Send(const xml: WideString); safecall;
    function isRosterJID(const jid: WideString): WordBool; safecall;
    function isSubscribed(const jid: WideString): WordBool; safecall;
    procedure ChangePresence(const Show: WideString; const Status: WideString; Priority: Integer); safecall;
    procedure StartChat(const jid: WideString; const resource: WideString; 
                        const nickname: WideString); safecall;
    procedure GetProfile(const jid: WideString); safecall;
    function CreateDockableWindow(const Caption: WideString): Integer; safecall;
    function addPluginMenu(const Caption: WideString): WideString; safecall;
    procedure removePluginMenu(const ID: WideString); safecall;
    procedure monitorImplicitRegJID(const JabberID: WideString; FullJID: WordBool); safecall;
    procedure getAgentList(const Server: WideString); safecall;
    function getAgentService(const Server: WideString; const Service: WideString): WideString; safecall;
    function generateID: WideString; safecall;
    function isBlocked(const JabberID: WideString): WordBool; safecall;
    procedure Block(const JabberID: WideString); safecall;
    procedure UnBlock(const JabberID: WideString); safecall;
    function Get_resource: WideString; safecall;
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
    function findChat(const JabberID: WideString; const resource: WideString): Integer; safecall;
    procedure startSearch(const SearchJID: WideString); safecall;
    procedure startRoom(const RoomJID: WideString; const nickname: WideString; 
                        const Password: WideString; SendPresence: WordBool); safecall;
    procedure startInstantMsg(const JabberID: WideString); safecall;
    procedure startBrowser(const BrowseJID: WideString); safecall;
    procedure showJoinRoom(const RoomJID: WideString; const nickname: WideString; 
                           const Password: WideString); safecall;
    procedure showPrefs; safecall;
    procedure showCustomPresDialog; safecall;
    procedure showDebug; safecall;
    procedure showLogin; safecall;
    procedure showToast(const Message: WideString; wndHandle: Integer; imageIndex: Integer); safecall;
    procedure setPresence(const Show: WideString; const Status: WideString; Priority: Integer); safecall;
    function Get_Roster: IExodusRoster; safecall;
    function Get_PPDB: IExodusPPDB; safecall;
    function registerDiscoItem(const JabberID: WideString; const Name: WideString): WideString; safecall;
    procedure removeDiscoItem(const ID: WideString); safecall;
    function registerPresenceXML(const xml: WideString): WideString; safecall;
    procedure removePresenceXML(const ID: WideString); safecall;
    procedure trackWindowsMsg(Message: Integer); safecall;
    function addContactMenu(const Caption: WideString): WideString; safecall;
    procedure removeContactMenu(const ID: WideString); safecall;
    function getActiveContact: WideString; safecall;
    function getActiveGroup: WideString; safecall;
    function getActiveContacts(Online: WordBool): OleVariant; safecall;
    function Get_LocalIP: WideString; safecall;
    procedure setPluginAuth(const AuthAgent: IExodusAuth); safecall;
    procedure setAuthenticated(Authed: WordBool; const xml: WideString); safecall;
    procedure setAuthJID(const Username: WideString; const Host: WideString; 
                         const resource: WideString); safecall;
    function addMessageMenu(const Caption: WideString): WideString; safecall;
    function addGroupMenu(const Caption: WideString): WideString; safecall;
    procedure removeGroupMenu(const ID: WideString); safecall;
    procedure registerWithService(const JabberID: WideString); safecall;
    procedure showAddContact(const jid: WideString); safecall;
    procedure registerCapExtension(const ext: WideString; const feature: WideString); safecall;
    procedure unregisterCapExtension(const ext: WideString); safecall;
    function Get_RosterImages: IExodusRosterImages; safecall;
    function Get_EntityCache: IExodusEntityCache; safecall;
    procedure Debug(const Value: WideString); safecall;
    property Connected: WordBool read Get_Connected;
    property Username: WideString read Get_Username;
    property Server: WideString read Get_Server;
    property resource: WideString read Get_resource;
    property Port: Integer read Get_Port;
    property Priority: Integer read Get_Priority;
    property PresenceStatus: WideString read Get_PresenceStatus;
    property PresenceShow: WideString read Get_PresenceShow;
    property IsPaused: WordBool read Get_IsPaused;
    property IsInvisible: WordBool read Get_IsInvisible;
    property Roster: IExodusRoster read Get_Roster;
    property PPDB: IExodusPPDB read Get_PPDB;
    property LocalIP: WideString read Get_LocalIP;
    property RosterImages: IExodusRosterImages read Get_RosterImages;
    property EntityCache: IExodusEntityCache read Get_EntityCache;
  end;

// *********************************************************************//
// DispIntf:  IExodusControllerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {808426B8-8C56-49FD-AE15-5D91DE1DE5EF}
// *********************************************************************//
  IExodusControllerDisp = dispinterface
    ['{808426B8-8C56-49FD-AE15-5D91DE1DE5EF}']
    property Connected: WordBool readonly dispid 1;
    property Username: WideString readonly dispid 2;
    property Server: WideString readonly dispid 3;
    function RegisterCallback(const xpath: WideString; const callback: IExodusPlugin): Integer; dispid 4;
    procedure UnRegisterCallback(ID: Integer); dispid 5;
    procedure Send(const xml: WideString); dispid 6;
    function isRosterJID(const jid: WideString): WordBool; dispid 7;
    function isSubscribed(const jid: WideString): WordBool; dispid 8;
    procedure ChangePresence(const Show: WideString; const Status: WideString; Priority: Integer); dispid 11;
    procedure StartChat(const jid: WideString; const resource: WideString; 
                        const nickname: WideString); dispid 12;
    procedure GetProfile(const jid: WideString); dispid 13;
    function CreateDockableWindow(const Caption: WideString): Integer; dispid 16;
    function addPluginMenu(const Caption: WideString): WideString; dispid 14;
    procedure removePluginMenu(const ID: WideString); dispid 15;
    procedure monitorImplicitRegJID(const JabberID: WideString; FullJID: WordBool); dispid 17;
    procedure getAgentList(const Server: WideString); dispid 18;
    function getAgentService(const Server: WideString; const Service: WideString): WideString; dispid 19;
    function generateID: WideString; dispid 20;
    function isBlocked(const JabberID: WideString): WordBool; dispid 21;
    procedure Block(const JabberID: WideString); dispid 22;
    procedure UnBlock(const JabberID: WideString); dispid 23;
    property resource: WideString readonly dispid 24;
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
    function findChat(const JabberID: WideString; const resource: WideString): Integer; dispid 40;
    procedure startSearch(const SearchJID: WideString); dispid 41;
    procedure startRoom(const RoomJID: WideString; const nickname: WideString; 
                        const Password: WideString; SendPresence: WordBool); dispid 42;
    procedure startInstantMsg(const JabberID: WideString); dispid 43;
    procedure startBrowser(const BrowseJID: WideString); dispid 44;
    procedure showJoinRoom(const RoomJID: WideString; const nickname: WideString; 
                           const Password: WideString); dispid 45;
    procedure showPrefs; dispid 46;
    procedure showCustomPresDialog; dispid 47;
    procedure showDebug; dispid 48;
    procedure showLogin; dispid 49;
    procedure showToast(const Message: WideString; wndHandle: Integer; imageIndex: Integer); dispid 50;
    procedure setPresence(const Show: WideString; const Status: WideString; Priority: Integer); dispid 51;
    property Roster: IExodusRoster readonly dispid 54;
    property PPDB: IExodusPPDB readonly dispid 55;
    function registerDiscoItem(const JabberID: WideString; const Name: WideString): WideString; dispid 10;
    procedure removeDiscoItem(const ID: WideString); dispid 53;
    function registerPresenceXML(const xml: WideString): WideString; dispid 57;
    procedure removePresenceXML(const ID: WideString); dispid 58;
    procedure trackWindowsMsg(Message: Integer); dispid 59;
    function addContactMenu(const Caption: WideString): WideString; dispid 60;
    procedure removeContactMenu(const ID: WideString); dispid 61;
    function getActiveContact: WideString; dispid 62;
    function getActiveGroup: WideString; dispid 63;
    function getActiveContacts(Online: WordBool): OleVariant; dispid 65;
    property LocalIP: WideString readonly dispid 64;
    procedure setPluginAuth(const AuthAgent: IExodusAuth); dispid 66;
    procedure setAuthenticated(Authed: WordBool; const xml: WideString); dispid 67;
    procedure setAuthJID(const Username: WideString; const Host: WideString; 
                         const resource: WideString); dispid 68;
    function addMessageMenu(const Caption: WideString): WideString; dispid 201;
    function addGroupMenu(const Caption: WideString): WideString; dispid 202;
    procedure removeGroupMenu(const ID: WideString); dispid 203;
    procedure registerWithService(const JabberID: WideString); dispid 204;
    procedure showAddContact(const jid: WideString); dispid 205;
    procedure registerCapExtension(const ext: WideString; const feature: WideString); dispid 206;
    procedure unregisterCapExtension(const ext: WideString); dispid 207;
    property RosterImages: IExodusRosterImages readonly dispid 208;
    property EntityCache: IExodusEntityCache readonly dispid 209;
    procedure Debug(const Value: WideString); dispid 210;
  end;

// *********************************************************************//
// Interface: IExodusChat
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DA56D31B-1D1D-4F33-A04E-E28611E3011E}
// *********************************************************************//
  IExodusChat = interface(IDispatch)
    ['{DA56D31B-1D1D-4F33-A04E-E28611E3011E}']
    function Get_jid: WideString; safecall;
    function AddContextMenu(const Caption: WideString): WideString; safecall;
    function Get_MsgOutText: WideString; safecall;
    function RegisterPlugin(const Plugin: IExodusChatPlugin): Integer; safecall;
    function UnRegister(ID: Integer): WordBool; safecall;
    function getMagicInt(Part: ChatParts): Integer; safecall;
    procedure RemoveContextMenu(const ID: WideString); safecall;
    procedure AddMsgOut(const Value: WideString); safecall;
    function AddMsgOutMenu(const Caption: WideString): WideString; safecall;
    procedure RemoveMsgOutMenu(const MenuID: WideString); safecall;
    procedure SendMessage(var Body: WideString; var Subject: WideString; var xml: WideString); safecall;
    function Get_CurrentThreadID: WideString; safecall;
    procedure DisplayMessage(const Body: WideString; const Subject: WideString; 
                             const From: WideString); safecall;
    procedure AddRoomUser(const jid: WideString; const nickname: WideString); safecall;
    procedure RemoveRoomUser(const jid: WideString); safecall;
    function Get_CurrentNick: WideString; safecall;
    function GetControl(const Name: WideString): IExodusControl; safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    property jid: WideString read Get_jid;
    property MsgOutText: WideString read Get_MsgOutText;
    property CurrentThreadID: WideString read Get_CurrentThreadID;
    property CurrentNick: WideString read Get_CurrentNick;
    property Caption: WideString read Get_Caption write Set_Caption;
  end;

// *********************************************************************//
// DispIntf:  IExodusChatDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DA56D31B-1D1D-4F33-A04E-E28611E3011E}
// *********************************************************************//
  IExodusChatDisp = dispinterface
    ['{DA56D31B-1D1D-4F33-A04E-E28611E3011E}']
    property jid: WideString readonly dispid 1;
    function AddContextMenu(const Caption: WideString): WideString; dispid 2;
    property MsgOutText: WideString readonly dispid 4;
    function RegisterPlugin(const Plugin: IExodusChatPlugin): Integer; dispid 3;
    function UnRegister(ID: Integer): WordBool; dispid 5;
    function getMagicInt(Part: ChatParts): Integer; dispid 6;
    procedure RemoveContextMenu(const ID: WideString); dispid 7;
    procedure AddMsgOut(const Value: WideString); dispid 201;
    function AddMsgOutMenu(const Caption: WideString): WideString; dispid 202;
    procedure RemoveMsgOutMenu(const MenuID: WideString); dispid 203;
    procedure SendMessage(var Body: WideString; var Subject: WideString; var xml: WideString); dispid 204;
    property CurrentThreadID: WideString readonly dispid 205;
    procedure DisplayMessage(const Body: WideString; const Subject: WideString; 
                             const From: WideString); dispid 206;
    procedure AddRoomUser(const jid: WideString; const nickname: WideString); dispid 207;
    procedure RemoveRoomUser(const jid: WideString); dispid 208;
    property CurrentNick: WideString readonly dispid 209;
    function GetControl(const Name: WideString): IExodusControl; dispid 210;
    property Caption: WideString dispid 211;
  end;

// *********************************************************************//
// Interface: IExodusPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DCDFAD67-6CB2-4202-B29C-50D633C02596}
// *********************************************************************//
  IExodusPlugin = interface(IDispatch)
    ['{DCDFAD67-6CB2-4202-B29C-50D633C02596}']
    procedure Startup(const ExodusController: IExodusController); safecall;
    procedure Shutdown; safecall;
    procedure Process(const xpath: WideString; const event: WideString; const xml: WideString); safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat); safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat); safecall;
    function NewIM(const jid: WideString; var Body: WideString; var Subject: WideString; 
                   const XTags: WideString): WideString; safecall;
    procedure Configure; safecall;
    procedure MenuClick(const ID: WideString); safecall;
    procedure MsgMenuClick(const ID: WideString; const jid: WideString; var Body: WideString; 
                           var Subject: WideString); safecall;
    procedure NewOutgoingIM(const jid: WideString; const InstantMsg: IExodusChat); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DCDFAD67-6CB2-4202-B29C-50D633C02596}
// *********************************************************************//
  IExodusPluginDisp = dispinterface
    ['{DCDFAD67-6CB2-4202-B29C-50D633C02596}']
    procedure Startup(const ExodusController: IExodusController); dispid 1;
    procedure Shutdown; dispid 2;
    procedure Process(const xpath: WideString; const event: WideString; const xml: WideString); dispid 3;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat); dispid 4;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat); dispid 5;
    function NewIM(const jid: WideString; var Body: WideString; var Subject: WideString; 
                   const XTags: WideString): WideString; dispid 8;
    procedure Configure; dispid 12;
    procedure MenuClick(const ID: WideString); dispid 201;
    procedure MsgMenuClick(const ID: WideString; const jid: WideString; var Body: WideString; 
                           var Subject: WideString); dispid 202;
    procedure NewOutgoingIM(const jid: WideString; const InstantMsg: IExodusChat); dispid 203;
  end;

// *********************************************************************//
// Interface: IExodusChatPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C576B16-DD6A-4E8C-8DEB-38E255B48A88}
// *********************************************************************//
  IExodusChatPlugin = interface(IDispatch)
    ['{2C576B16-DD6A-4E8C-8DEB-38E255B48A88}']
    function onBeforeMessage(var Body: WideString): WordBool; safecall;
    function onAfterMessage(var Body: WideString): WideString; safecall;
    procedure onKeyPress(const Key: WideString); safecall;
    procedure onContextMenu(const ID: WideString); safecall;
    procedure onRecvMessage(const Body: WideString; const xml: WideString); safecall;
    procedure onClose; safecall;
    procedure onMenu(const ID: WideString); safecall;
    procedure onNewWindow(HWND: Integer); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusChatPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C576B16-DD6A-4E8C-8DEB-38E255B48A88}
// *********************************************************************//
  IExodusChatPluginDisp = dispinterface
    ['{2C576B16-DD6A-4E8C-8DEB-38E255B48A88}']
    function onBeforeMessage(var Body: WideString): WordBool; dispid 1;
    function onAfterMessage(var Body: WideString): WideString; dispid 2;
    procedure onKeyPress(const Key: WideString); dispid 3;
    procedure onContextMenu(const ID: WideString); dispid 4;
    procedure onRecvMessage(const Body: WideString; const xml: WideString); dispid 5;
    procedure onClose; dispid 6;
    procedure onMenu(const ID: WideString); dispid 201;
    procedure onNewWindow(HWND: Integer); dispid 202;
  end;

// *********************************************************************//
// Interface: IExodusRoster
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}
// *********************************************************************//
  IExodusRoster = interface(IDispatch)
    ['{29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}']
    procedure Fetch; safecall;
    function Subscribe(const JabberID: WideString; const nickname: WideString; 
                       const Group: WideString; Subscribe: WordBool): IExodusRosterItem; safecall;
    function Find(const JabberID: WideString): IExodusRosterItem; safecall;
    function Item(Index: Integer): IExodusRosterItem; safecall;
    function Count: Integer; safecall;
    procedure removeItem(const Item: IExodusRosterItem); safecall;
    function addGroup(const grp: WideString): IExodusRosterGroup; safecall;
    function getGroup(const grp: WideString): IExodusRosterGroup; safecall;
    procedure removeGroup(const grp: IExodusRosterGroup); safecall;
    function Get_GroupsCount: Integer; safecall;
    function Groups(Index: Integer): IExodusRosterGroup; safecall;
    function Items(Index: Integer): IExodusRosterItem; safecall;
    function AddContextMenu(const ID: WideString): WordBool; safecall;
    procedure RemoveContextMenu(const ID: WideString); safecall;
    function addContextMenuItem(const menu_id: WideString; const Caption: WideString; 
                                const action: WideString): WideString; safecall;
    procedure removeContextMenuItem(const menu_id: WideString; const item_id: WideString); safecall;
    function addItem(const JabberID: WideString): IExodusRosterItem; safecall;
    property GroupsCount: Integer read Get_GroupsCount;
  end;

// *********************************************************************//
// DispIntf:  IExodusRosterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}
// *********************************************************************//
  IExodusRosterDisp = dispinterface
    ['{29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}']
    procedure Fetch; dispid 1;
    function Subscribe(const JabberID: WideString; const nickname: WideString; 
                       const Group: WideString; Subscribe: WordBool): IExodusRosterItem; dispid 3;
    function Find(const JabberID: WideString): IExodusRosterItem; dispid 6;
    function Item(Index: Integer): IExodusRosterItem; dispid 7;
    function Count: Integer; dispid 8;
    procedure removeItem(const Item: IExodusRosterItem); dispid 201;
    function addGroup(const grp: WideString): IExodusRosterGroup; dispid 202;
    function getGroup(const grp: WideString): IExodusRosterGroup; dispid 203;
    procedure removeGroup(const grp: IExodusRosterGroup); dispid 204;
    property GroupsCount: Integer readonly dispid 205;
    function Groups(Index: Integer): IExodusRosterGroup; dispid 206;
    function Items(Index: Integer): IExodusRosterItem; dispid 207;
    function AddContextMenu(const ID: WideString): WordBool; dispid 208;
    procedure RemoveContextMenu(const ID: WideString); dispid 209;
    function addContextMenuItem(const menu_id: WideString; const Caption: WideString; 
                                const action: WideString): WideString; dispid 210;
    procedure removeContextMenuItem(const menu_id: WideString; const item_id: WideString); dispid 211;
    function addItem(const JabberID: WideString): IExodusRosterItem; dispid 212;
  end;

// *********************************************************************//
// Interface: IExodusPPDB
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {284E49F2-2006-4E48-B0E0-233867A78E54}
// *********************************************************************//
  IExodusPPDB = interface(IDispatch)
    ['{284E49F2-2006-4E48-B0E0-233867A78E54}']
    function Find(const JabberID: WideString; const resource: WideString): IExodusPresence; safecall;
    function Next(const JabberID: WideString; const resource: WideString): IExodusPresence; safecall;
    function Get_Count: Integer; safecall;
    function Get_LastPresence: IExodusPresence; safecall;
    property Count: Integer read Get_Count;
    property LastPresence: IExodusPresence read Get_LastPresence;
  end;

// *********************************************************************//
// DispIntf:  IExodusPPDBDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {284E49F2-2006-4E48-B0E0-233867A78E54}
// *********************************************************************//
  IExodusPPDBDisp = dispinterface
    ['{284E49F2-2006-4E48-B0E0-233867A78E54}']
    function Find(const JabberID: WideString; const resource: WideString): IExodusPresence; dispid 1;
    function Next(const JabberID: WideString; const resource: WideString): IExodusPresence; dispid 2;
    property Count: Integer readonly dispid 3;
    property LastPresence: IExodusPresence readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IExodusRosterItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F710F80C-C74A-4A69-8D2B-023504125B96}
// *********************************************************************//
  IExodusRosterItem = interface(IDispatch)
    ['{F710F80C-C74A-4A69-8D2B-023504125B96}']
    function Get_JabberID: WideString; safecall;
    procedure Set_JabberID(const Value: WideString); safecall;
    function Get_Subscription: WideString; safecall;
    procedure Set_Subscription(const Value: WideString); safecall;
    function Get_Ask: WideString; safecall;
    function Get_GroupCount: Integer; safecall;
    function Group(Index: Integer): WideString; safecall;
    function xml: WideString; safecall;
    procedure Remove; safecall;
    procedure Update; safecall;
    function Get_nickname: WideString; safecall;
    procedure Set_nickname(const Value: WideString); safecall;
    function Get_RawNickname: WideString; safecall;
    function Get_ContextMenuID: WideString; safecall;
    procedure Set_ContextMenuID(const Value: WideString); safecall;
    function Get_Status: WideString; safecall;
    procedure Set_Status(const Value: WideString); safecall;
    function Get_Tooltip: WideString; safecall;
    procedure Set_Tooltip(const Value: WideString); safecall;
    function Get_action: WideString; safecall;
    procedure Set_action(const Value: WideString); safecall;
    function Get_imageIndex: Integer; safecall;
    procedure Set_imageIndex(Value: Integer); safecall;
    function Get_InlineEdit: WordBool; safecall;
    procedure Set_InlineEdit(Value: WordBool); safecall;
    procedure fireChange; safecall;
    function Get_IsContact: WordBool; safecall;
    procedure Set_IsContact(Value: WordBool); safecall;
    procedure addGroup(const grp: WideString); safecall;
    procedure removeGroup(const grp: WideString); safecall;
    procedure setCleanGroups; safecall;
    function Get_ImagePrefix: WideString; safecall;
    procedure Set_ImagePrefix(const Value: WideString); safecall;
    function Get_IsNative: WordBool; safecall;
    procedure Set_IsNative(Value: WordBool); safecall;
    function Get_CanOffline: WordBool; safecall;
    procedure Set_CanOffline(Value: WordBool); safecall;
    property JabberID: WideString read Get_JabberID write Set_JabberID;
    property Subscription: WideString read Get_Subscription write Set_Subscription;
    property Ask: WideString read Get_Ask;
    property GroupCount: Integer read Get_GroupCount;
    property nickname: WideString read Get_nickname write Set_nickname;
    property RawNickname: WideString read Get_RawNickname;
    property ContextMenuID: WideString read Get_ContextMenuID write Set_ContextMenuID;
    property Status: WideString read Get_Status write Set_Status;
    property Tooltip: WideString read Get_Tooltip write Set_Tooltip;
    property action: WideString read Get_action write Set_action;
    property imageIndex: Integer read Get_imageIndex write Set_imageIndex;
    property InlineEdit: WordBool read Get_InlineEdit write Set_InlineEdit;
    property IsContact: WordBool read Get_IsContact write Set_IsContact;
    property ImagePrefix: WideString read Get_ImagePrefix write Set_ImagePrefix;
    property IsNative: WordBool read Get_IsNative write Set_IsNative;
    property CanOffline: WordBool read Get_CanOffline write Set_CanOffline;
  end;

// *********************************************************************//
// DispIntf:  IExodusRosterItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F710F80C-C74A-4A69-8D2B-023504125B96}
// *********************************************************************//
  IExodusRosterItemDisp = dispinterface
    ['{F710F80C-C74A-4A69-8D2B-023504125B96}']
    property JabberID: WideString dispid 1;
    property Subscription: WideString dispid 2;
    property Ask: WideString readonly dispid 4;
    property GroupCount: Integer readonly dispid 5;
    function Group(Index: Integer): WideString; dispid 6;
    function xml: WideString; dispid 7;
    procedure Remove; dispid 8;
    procedure Update; dispid 9;
    property nickname: WideString dispid 10;
    property RawNickname: WideString readonly dispid 11;
    property ContextMenuID: WideString dispid 201;
    property Status: WideString dispid 202;
    property Tooltip: WideString dispid 203;
    property action: WideString dispid 204;
    property imageIndex: Integer dispid 205;
    property InlineEdit: WordBool dispid 206;
    procedure fireChange; dispid 207;
    property IsContact: WordBool dispid 208;
    procedure addGroup(const grp: WideString); dispid 210;
    procedure removeGroup(const grp: WideString); dispid 211;
    procedure setCleanGroups; dispid 212;
    property ImagePrefix: WideString dispid 209;
    property IsNative: WordBool dispid 213;
    property CanOffline: WordBool dispid 214;
  end;

// *********************************************************************//
// Interface: IExodusPresence
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D2FD3425-40CE-469F-A95C-1C80B7FF3119}
// *********************************************************************//
  IExodusPresence = interface(IDispatch)
    ['{D2FD3425-40CE-469F-A95C-1C80B7FF3119}']
    function Get_PresType: WideString; safecall;
    procedure Set_PresType(const Value: WideString); safecall;
    function Get_Status: WideString; safecall;
    procedure Set_Status(const Value: WideString); safecall;
    function Get_Show: WideString; safecall;
    procedure Set_Show(const Value: WideString); safecall;
    function Get_Priority: Integer; safecall;
    procedure Set_Priority(Value: Integer); safecall;
    function Get_ErrorString: WideString; safecall;
    procedure Set_ErrorString(const Value: WideString); safecall;
    function xml: WideString; safecall;
    function isSubscription: WordBool; safecall;
    function Get_toJid: WideString; safecall;
    procedure Set_toJid(const Value: WideString); safecall;
    function Get_fromJid: WideString; safecall;
    procedure Set_fromJid(const Value: WideString); safecall;
    property PresType: WideString read Get_PresType write Set_PresType;
    property Status: WideString read Get_Status write Set_Status;
    property Show: WideString read Get_Show write Set_Show;
    property Priority: Integer read Get_Priority write Set_Priority;
    property ErrorString: WideString read Get_ErrorString write Set_ErrorString;
    property toJid: WideString read Get_toJid write Set_toJid;
    property fromJid: WideString read Get_fromJid write Set_fromJid;
  end;

// *********************************************************************//
// DispIntf:  IExodusPresenceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D2FD3425-40CE-469F-A95C-1C80B7FF3119}
// *********************************************************************//
  IExodusPresenceDisp = dispinterface
    ['{D2FD3425-40CE-469F-A95C-1C80B7FF3119}']
    property PresType: WideString dispid 1;
    property Status: WideString dispid 2;
    property Show: WideString dispid 3;
    property Priority: Integer dispid 4;
    property ErrorString: WideString dispid 5;
    function xml: WideString; dispid 6;
    function isSubscription: WordBool; dispid 7;
    property toJid: WideString dispid 8;
    property fromJid: WideString dispid 9;
  end;

// *********************************************************************//
// Interface: IExodusAuth
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D33EA5B9-23FD-4E43-B5B7-3CCFD0F5CDD0}
// *********************************************************************//
  IExodusAuth = interface(IDispatch)
    ['{D33EA5B9-23FD-4E43-B5B7-3CCFD0F5CDD0}']
    procedure StartAuth; safecall;
    procedure CancelAuth; safecall;
    function StartRegistration: WordBool; safecall;
    procedure CancelRegistration; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusAuthDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D33EA5B9-23FD-4E43-B5B7-3CCFD0F5CDD0}
// *********************************************************************//
  IExodusAuthDisp = dispinterface
    ['{D33EA5B9-23FD-4E43-B5B7-3CCFD0F5CDD0}']
    procedure StartAuth; dispid 1;
    procedure CancelAuth; dispid 2;
    function StartRegistration: WordBool; dispid 3;
    procedure CancelRegistration; dispid 4;
  end;

// *********************************************************************//
// Interface: IExodusRosterGroup
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FA63024E-3453-4551-8CA0-AFB78B2066AD}
// *********************************************************************//
  IExodusRosterGroup = interface(IDispatch)
    ['{FA63024E-3453-4551-8CA0-AFB78B2066AD}']
    function Get_action: WideString; safecall;
    procedure Set_action(const Value: WideString); safecall;
    function Get_KeepEmpty: WordBool; safecall;
    procedure Set_KeepEmpty(Value: WordBool); safecall;
    function Get_SortPriority: Integer; safecall;
    procedure Set_SortPriority(Value: Integer); safecall;
    function Get_ShowPresence: WordBool; safecall;
    procedure Set_ShowPresence(Value: WordBool); safecall;
    function Get_DragTarget: WordBool; safecall;
    procedure Set_DragTarget(Value: WordBool); safecall;
    function Get_DragSource: WordBool; safecall;
    procedure Set_DragSource(Value: WordBool); safecall;
    function Get_AutoExpand: WordBool; safecall;
    procedure Set_AutoExpand(Value: WordBool); safecall;
    function getText: WideString; safecall;
    procedure addJid(const jid: WideString); safecall;
    procedure removeJid(const jid: WideString); safecall;
    function inGroup(const jid: WideString): WordBool; safecall;
    function isEmpty: WordBool; safecall;
    function getGroup(const group_name: WideString): IExodusRosterGroup; safecall;
    procedure addGroup(const child: IExodusRosterGroup); safecall;
    procedure removeGroup(const child: IExodusRosterGroup); safecall;
    function getRosterItems(Online: WordBool): OleVariant; safecall;
    function Get_NestLevel: Integer; safecall;
    function Get_Online: Integer; safecall;
    function Get_Total: Integer; safecall;
    function Get_FullName: WideString; safecall;
    function Get_Parent: IExodusRosterGroup; safecall;
    function Parts(Index: Integer): WideString; safecall;
    property action: WideString read Get_action write Set_action;
    property KeepEmpty: WordBool read Get_KeepEmpty write Set_KeepEmpty;
    property SortPriority: Integer read Get_SortPriority write Set_SortPriority;
    property ShowPresence: WordBool read Get_ShowPresence write Set_ShowPresence;
    property DragTarget: WordBool read Get_DragTarget write Set_DragTarget;
    property DragSource: WordBool read Get_DragSource write Set_DragSource;
    property AutoExpand: WordBool read Get_AutoExpand write Set_AutoExpand;
    property NestLevel: Integer read Get_NestLevel;
    property Online: Integer read Get_Online;
    property Total: Integer read Get_Total;
    property FullName: WideString read Get_FullName;
    property Parent: IExodusRosterGroup read Get_Parent;
  end;

// *********************************************************************//
// DispIntf:  IExodusRosterGroupDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FA63024E-3453-4551-8CA0-AFB78B2066AD}
// *********************************************************************//
  IExodusRosterGroupDisp = dispinterface
    ['{FA63024E-3453-4551-8CA0-AFB78B2066AD}']
    property action: WideString dispid 201;
    property KeepEmpty: WordBool dispid 202;
    property SortPriority: Integer dispid 203;
    property ShowPresence: WordBool dispid 204;
    property DragTarget: WordBool dispid 205;
    property DragSource: WordBool dispid 206;
    property AutoExpand: WordBool dispid 207;
    function getText: WideString; dispid 208;
    procedure addJid(const jid: WideString); dispid 209;
    procedure removeJid(const jid: WideString); dispid 210;
    function inGroup(const jid: WideString): WordBool; dispid 211;
    function isEmpty: WordBool; dispid 212;
    function getGroup(const group_name: WideString): IExodusRosterGroup; dispid 213;
    procedure addGroup(const child: IExodusRosterGroup); dispid 214;
    procedure removeGroup(const child: IExodusRosterGroup); dispid 215;
    function getRosterItems(Online: WordBool): OleVariant; dispid 216;
    property NestLevel: Integer readonly dispid 217;
    property Online: Integer readonly dispid 218;
    property Total: Integer readonly dispid 219;
    property FullName: WideString readonly dispid 220;
    property Parent: IExodusRosterGroup readonly dispid 221;
    function Parts(Index: Integer): WideString; dispid 222;
  end;

// *********************************************************************//
// Interface: IExodusRosterImages
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4AAF511-D144-42E7-B108-8A196D4BD115}
// *********************************************************************//
  IExodusRosterImages = interface(IDispatch)
    ['{F4AAF511-D144-42E7-B108-8A196D4BD115}']
    function AddImageFilename(const ID: WideString; const filename: WideString): Integer; safecall;
    function AddImageBase64(const ID: WideString; const base64: WideString): Integer; safecall;
    function AddImageResource(const ID: WideString; const LibName: WideString; 
                              const ResName: WideString): Integer; safecall;
    procedure Remove(const ID: WideString); safecall;
    function Find(const ID: WideString): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusRosterImagesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4AAF511-D144-42E7-B108-8A196D4BD115}
// *********************************************************************//
  IExodusRosterImagesDisp = dispinterface
    ['{F4AAF511-D144-42E7-B108-8A196D4BD115}']
    function AddImageFilename(const ID: WideString; const filename: WideString): Integer; dispid 201;
    function AddImageBase64(const ID: WideString; const base64: WideString): Integer; dispid 202;
    function AddImageResource(const ID: WideString; const LibName: WideString; 
                              const ResName: WideString): Integer; dispid 203;
    procedure Remove(const ID: WideString); dispid 204;
    function Find(const ID: WideString): Integer; dispid 205;
  end;

// *********************************************************************//
// Interface: IExodusEntityCache
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6759BFE4-C72D-42E3-86A3-1F343E848933}
// *********************************************************************//
  IExodusEntityCache = interface(IDispatch)
    ['{6759BFE4-C72D-42E3-86A3-1F343E848933}']
    function getByJid(const jid: WideString; const node: WideString): IExodusEntity; safecall;
    function Fetch(const jid: WideString; const node: WideString; items_limit: WordBool): IExodusEntity; safecall;
    function discoInfo(const jid: WideString; const node: WideString; timeout: Integer): IExodusEntity; safecall;
    function discoItems(const jid: WideString; const node: WideString; timeout: Integer): IExodusEntity; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusEntityCacheDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6759BFE4-C72D-42E3-86A3-1F343E848933}
// *********************************************************************//
  IExodusEntityCacheDisp = dispinterface
    ['{6759BFE4-C72D-42E3-86A3-1F343E848933}']
    function getByJid(const jid: WideString; const node: WideString): IExodusEntity; dispid 201;
    function Fetch(const jid: WideString; const node: WideString; items_limit: WordBool): IExodusEntity; dispid 202;
    function discoInfo(const jid: WideString; const node: WideString; timeout: Integer): IExodusEntity; dispid 203;
    function discoItems(const jid: WideString; const node: WideString; timeout: Integer): IExodusEntity; dispid 204;
  end;

// *********************************************************************//
// Interface: IExodusEntity
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}
// *********************************************************************//
  IExodusEntity = interface(IDispatch)
    ['{1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}']
    function hasFeature(const feature: WideString): WordBool; safecall;
    function hasIdentity(const Category: WideString; const DiscoType: WideString): WordBool; safecall;
    function hasItems: WordBool; safecall;
    function hasInfo: WordBool; safecall;
    function Get_jid: WideString; safecall;
    function Get_node: WideString; safecall;
    function Get_Category: WideString; safecall;
    function Get_DiscoType: WideString; safecall;
    function Get_Name: WideString; safecall;
    function Get_FeatureCount: Integer; safecall;
    function Get_feature(Index: Integer): WideString; safecall;
    function Get_ItemsCount: Integer; safecall;
    function Get_Item(Index: Integer): IExodusEntity; safecall;
    property jid: WideString read Get_jid;
    property node: WideString read Get_node;
    property Category: WideString read Get_Category;
    property DiscoType: WideString read Get_DiscoType;
    property Name: WideString read Get_Name;
    property FeatureCount: Integer read Get_FeatureCount;
    property feature[Index: Integer]: WideString read Get_feature;
    property ItemsCount: Integer read Get_ItemsCount;
    property Item[Index: Integer]: IExodusEntity read Get_Item;
  end;

// *********************************************************************//
// DispIntf:  IExodusEntityDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}
// *********************************************************************//
  IExodusEntityDisp = dispinterface
    ['{1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}']
    function hasFeature(const feature: WideString): WordBool; dispid 201;
    function hasIdentity(const Category: WideString; const DiscoType: WideString): WordBool; dispid 202;
    function hasItems: WordBool; dispid 203;
    function hasInfo: WordBool; dispid 204;
    property jid: WideString readonly dispid 205;
    property node: WideString readonly dispid 206;
    property Category: WideString readonly dispid 207;
    property DiscoType: WideString readonly dispid 208;
    property Name: WideString readonly dispid 209;
    property FeatureCount: Integer readonly dispid 210;
    property feature[Index: Integer]: WideString readonly dispid 211;
    property ItemsCount: Integer readonly dispid 212;
    property Item[Index: Integer]: IExodusEntity readonly dispid 213;
  end;

// *********************************************************************//
// Interface: IExodusControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0B992E91-DAD7-4CDC-9FD6-8007A63700E0}
// *********************************************************************//
  IExodusControl = interface(IDispatch)
    ['{0B992E91-DAD7-4CDC-9FD6-8007A63700E0}']
    function Get_ControlType: ExodusControlTypes; safecall;
    property ControlType: ExodusControlTypes read Get_ControlType;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0B992E91-DAD7-4CDC-9FD6-8007A63700E0}
// *********************************************************************//
  IExodusControlDisp = dispinterface
    ['{0B992E91-DAD7-4CDC-9FD6-8007A63700E0}']
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlCheckBox
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {896CCC11-8929-4FEC-BC95-C96E5027C1F6}
// *********************************************************************//
  IExodusControlCheckBox = interface(IExodusControl)
    ['{896CCC11-8929-4FEC-BC95-C96E5027C1F6}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(Value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(Value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(Value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(Value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(Value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(Value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(Value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const Value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(Value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(Value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(Value: Integer); safecall;
    function Get_AllowGrayed: Integer; safecall;
    procedure Set_AllowGrayed(Value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(Value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Checked: Integer; safecall;
    procedure Set_Checked(Value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(Value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(Value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(Value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(Value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(Value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(Value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(Value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(Value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(Value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(Value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(Value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(Value: Integer); safecall;
    function Get_State: Integer; safecall;
    procedure Set_State(Value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(Value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(Value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(Value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Alignment: Integer read Get_Alignment write Set_Alignment;
    property AllowGrayed: Integer read Get_AllowGrayed write Set_AllowGrayed;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Checked: Integer read Get_Checked write Set_Checked;
    property Color: Integer read Get_Color write Set_Color;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property State: Integer read Get_State write Set_State;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WordWrap: Integer read Get_WordWrap write Set_WordWrap;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlCheckBoxDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {896CCC11-8929-4FEC-BC95-C96E5027C1F6}
// *********************************************************************//
  IExodusControlCheckBoxDisp = dispinterface
    ['{896CCC11-8929-4FEC-BC95-C96E5027C1F6}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property TabStop: Integer dispid 12;
    property Alignment: Integer dispid 13;
    property AllowGrayed: Integer dispid 14;
    property BiDiMode: Integer dispid 15;
    property Caption: WideString dispid 16;
    property Checked: Integer dispid 17;
    property Color: Integer dispid 18;
    property Ctl3D: Integer dispid 19;
    property DragCursor: Integer dispid 20;
    property DragKind: Integer dispid 21;
    property DragMode: Integer dispid 22;
    property Enabled: Integer dispid 23;
    property Font: IExodusControlFont readonly dispid 24;
    property ParentBiDiMode: Integer dispid 25;
    property ParentColor: Integer dispid 26;
    property ParentCtl3D: Integer dispid 27;
    property ParentFont: Integer dispid 28;
    property ParentShowHint: Integer dispid 29;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 30;
    property ShowHint: Integer dispid 31;
    property State: Integer dispid 32;
    property TabOrder: Integer dispid 33;
    property Visible: Integer dispid 34;
    property WordWrap: Integer dispid 35;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlComboBox
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {16D21C8F-EF88-4E93-87C6-CD8F8C1EE7F7}
// *********************************************************************//
  IExodusControlComboBox = interface(IExodusControl)
    ['{16D21C8F-EF88-4E93-87C6-CD8F8C1EE7F7}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(Value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(Value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(Value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(Value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(Value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(Value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(Value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const Value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(Value: Integer); safecall;
    function Get_AutoComplete: Integer; safecall;
    procedure Set_AutoComplete(Value: Integer); safecall;
    function Get_AutoDropDown: Integer; safecall;
    procedure Set_AutoDropDown(Value: Integer); safecall;
    function Get_AutoCloseUp: Integer; safecall;
    procedure Set_AutoCloseUp(Value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(Value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(Value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(Value: Integer); safecall;
    function Get_Style: Integer; safecall;
    procedure Set_Style(Value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(Value: Integer); safecall;
    function Get_CharCase: Integer; safecall;
    procedure Set_CharCase(Value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(Value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(Value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(Value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(Value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(Value: Integer); safecall;
    function Get_DropDownCount: Integer; safecall;
    procedure Set_DropDownCount(Value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(Value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(Value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const Value: WideString); safecall;
    function Get_ItemHeight: Integer; safecall;
    procedure Set_ItemHeight(Value: Integer); safecall;
    function Get_ItemIndex: Integer; safecall;
    procedure Set_ItemIndex(Value: Integer); safecall;
    function Get_MaxLength: Integer; safecall;
    procedure Set_MaxLength(Value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(Value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(Value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(Value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(Value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(Value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(Value: Integer); safecall;
    function Get_Sorted: Integer; safecall;
    procedure Set_Sorted(Value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(Value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(Value: Integer); safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Text(const Value: WideString); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(Value: Integer); safecall;
    function Get_Items(Index: Integer): WideString; safecall;
    procedure Set_Items(Index: Integer; const Value: WideString); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property AutoComplete: Integer read Get_AutoComplete write Set_AutoComplete;
    property AutoDropDown: Integer read Get_AutoDropDown write Set_AutoDropDown;
    property AutoCloseUp: Integer read Get_AutoCloseUp write Set_AutoCloseUp;
    property BevelInner: Integer read Get_BevelInner write Set_BevelInner;
    property BevelKind: Integer read Get_BevelKind write Set_BevelKind;
    property BevelOuter: Integer read Get_BevelOuter write Set_BevelOuter;
    property Style: Integer read Get_Style write Set_Style;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property CharCase: Integer read Get_CharCase write Set_CharCase;
    property Color: Integer read Get_Color write Set_Color;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property DropDownCount: Integer read Get_DropDownCount write Set_DropDownCount;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property ImeMode: Integer read Get_ImeMode write Set_ImeMode;
    property ImeName: WideString read Get_ImeName write Set_ImeName;
    property ItemHeight: Integer read Get_ItemHeight write Set_ItemHeight;
    property ItemIndex: Integer read Get_ItemIndex write Set_ItemIndex;
    property MaxLength: Integer read Get_MaxLength write Set_MaxLength;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property Sorted: Integer read Get_Sorted write Set_Sorted;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Text: WideString read Get_Text write Set_Text;
    property Visible: Integer read Get_Visible write Set_Visible;
    property Items[Index: Integer]: WideString read Get_Items write Set_Items;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlComboBoxDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {16D21C8F-EF88-4E93-87C6-CD8F8C1EE7F7}
// *********************************************************************//
  IExodusControlComboBoxDisp = dispinterface
    ['{16D21C8F-EF88-4E93-87C6-CD8F8C1EE7F7}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property AutoComplete: Integer dispid 12;
    property AutoDropDown: Integer dispid 13;
    property AutoCloseUp: Integer dispid 14;
    property BevelInner: Integer dispid 15;
    property BevelKind: Integer dispid 16;
    property BevelOuter: Integer dispid 17;
    property Style: Integer dispid 18;
    property BiDiMode: Integer dispid 19;
    property CharCase: Integer dispid 20;
    property Color: Integer dispid 21;
    property Ctl3D: Integer dispid 22;
    property DragCursor: Integer dispid 23;
    property DragKind: Integer dispid 24;
    property DragMode: Integer dispid 25;
    property DropDownCount: Integer dispid 26;
    property Enabled: Integer dispid 27;
    property Font: IExodusControlFont readonly dispid 28;
    property ImeMode: Integer dispid 29;
    property ImeName: WideString dispid 30;
    property ItemHeight: Integer dispid 31;
    property ItemIndex: Integer dispid 32;
    property MaxLength: Integer dispid 33;
    property ParentBiDiMode: Integer dispid 34;
    property ParentColor: Integer dispid 35;
    property ParentCtl3D: Integer dispid 36;
    property ParentFont: Integer dispid 37;
    property ParentShowHint: Integer dispid 38;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 39;
    property ShowHint: Integer dispid 40;
    property Sorted: Integer dispid 41;
    property TabOrder: Integer dispid 42;
    property TabStop: Integer dispid 43;
    property Text: WideString dispid 44;
    property Visible: Integer dispid 45;
    property Items[Index: Integer]: WideString dispid 46;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlEdit
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A7B8A353-FF1E-4933-9A01-BD7B0FDC6F02}
// *********************************************************************//
  IExodusControlEdit = interface(IExodusControl)
    ['{A7B8A353-FF1E-4933-9A01-BD7B0FDC6F02}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(Value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(Value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(Value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(Value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(Value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(Value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(Value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const Value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(Value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(Value: Integer); safecall;
    function Get_AutoSelect: Integer; safecall;
    procedure Set_AutoSelect(Value: Integer); safecall;
    function Get_AutoSize: Integer; safecall;
    procedure Set_AutoSize(Value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(Value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(Value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(Value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(Value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(Value: Integer); safecall;
    function Get_CharCase: Integer; safecall;
    procedure Set_CharCase(Value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(Value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(Value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(Value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(Value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(Value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(Value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_HideSelection: Integer; safecall;
    procedure Set_HideSelection(Value: Integer); safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(Value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const Value: WideString); safecall;
    function Get_MaxLength: Integer; safecall;
    procedure Set_MaxLength(Value: Integer); safecall;
    function Get_OEMConvert: Integer; safecall;
    procedure Set_OEMConvert(Value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(Value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(Value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(Value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(Value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(Value: Integer); safecall;
    function Get_PasswordChar: WideString; safecall;
    procedure Set_PasswordChar(const Value: WideString); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ReadOnly: Integer; safecall;
    procedure Set_ReadOnly(Value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(Value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(Value: Integer); safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Text(const Value: WideString); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(Value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property AutoSelect: Integer read Get_AutoSelect write Set_AutoSelect;
    property AutoSize: Integer read Get_AutoSize write Set_AutoSize;
    property BevelInner: Integer read Get_BevelInner write Set_BevelInner;
    property BevelKind: Integer read Get_BevelKind write Set_BevelKind;
    property BevelOuter: Integer read Get_BevelOuter write Set_BevelOuter;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property BorderStyle: Integer read Get_BorderStyle write Set_BorderStyle;
    property CharCase: Integer read Get_CharCase write Set_CharCase;
    property Color: Integer read Get_Color write Set_Color;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property HideSelection: Integer read Get_HideSelection write Set_HideSelection;
    property ImeMode: Integer read Get_ImeMode write Set_ImeMode;
    property ImeName: WideString read Get_ImeName write Set_ImeName;
    property MaxLength: Integer read Get_MaxLength write Set_MaxLength;
    property OEMConvert: Integer read Get_OEMConvert write Set_OEMConvert;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PasswordChar: WideString read Get_PasswordChar write Set_PasswordChar;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ReadOnly: Integer read Get_ReadOnly write Set_ReadOnly;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property Text: WideString read Get_Text write Set_Text;
    property Visible: Integer read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlEditDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A7B8A353-FF1E-4933-9A01-BD7B0FDC6F02}
// *********************************************************************//
  IExodusControlEditDisp = dispinterface
    ['{A7B8A353-FF1E-4933-9A01-BD7B0FDC6F02}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property TabStop: Integer dispid 12;
    property AutoSelect: Integer dispid 13;
    property AutoSize: Integer dispid 14;
    property BevelInner: Integer dispid 15;
    property BevelKind: Integer dispid 16;
    property BevelOuter: Integer dispid 17;
    property BiDiMode: Integer dispid 18;
    property BorderStyle: Integer dispid 19;
    property CharCase: Integer dispid 20;
    property Color: Integer dispid 21;
    property Ctl3D: Integer dispid 22;
    property DragCursor: Integer dispid 23;
    property DragKind: Integer dispid 24;
    property DragMode: Integer dispid 25;
    property Enabled: Integer dispid 26;
    property Font: IExodusControlFont readonly dispid 27;
    property HideSelection: Integer dispid 28;
    property ImeMode: Integer dispid 29;
    property ImeName: WideString dispid 30;
    property MaxLength: Integer dispid 31;
    property OEMConvert: Integer dispid 32;
    property ParentBiDiMode: Integer dispid 33;
    property ParentColor: Integer dispid 34;
    property ParentCtl3D: Integer dispid 35;
    property ParentFont: Integer dispid 36;
    property ParentShowHint: Integer dispid 37;
    property PasswordChar: WideString dispid 38;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 39;
    property ReadOnly: Integer dispid 40;
    property ShowHint: Integer dispid 41;
    property TabOrder: Integer dispid 42;
    property Text: WideString dispid 43;
    property Visible: Integer dispid 44;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlFont
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D8297D0C-A316-4E9D-A89C-095CFAE51141}
// *********************************************************************//
  IExodusControlFont = interface(IExodusControl)
    ['{D8297D0C-A316-4E9D-A89C-095CFAE51141}']
    function Get_Charset: Integer; safecall;
    procedure Set_Charset(Value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(Value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(Value: Integer); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Pitch: Integer; safecall;
    procedure Set_Pitch(Value: Integer); safecall;
    function Get_Size: Integer; safecall;
    procedure Set_Size(Value: Integer); safecall;
    property Charset: Integer read Get_Charset write Set_Charset;
    property Color: Integer read Get_Color write Set_Color;
    property Height: Integer read Get_Height write Set_Height;
    property Name: WideString read Get_Name write Set_Name;
    property Pitch: Integer read Get_Pitch write Set_Pitch;
    property Size: Integer read Get_Size write Set_Size;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlFontDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D8297D0C-A316-4E9D-A89C-095CFAE51141}
// *********************************************************************//
  IExodusControlFontDisp = dispinterface
    ['{D8297D0C-A316-4E9D-A89C-095CFAE51141}']
    property Charset: Integer dispid 1;
    property Color: Integer dispid 2;
    property Height: Integer dispid 3;
    property Name: WideString dispid 4;
    property Pitch: Integer dispid 5;
    property Size: Integer dispid 6;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlLabel
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F53704E6-83C2-4021-97A5-169BC58D9E03}
// *********************************************************************//
  IExodusControlLabel = interface(IExodusControl)
    ['{F53704E6-83C2-4021-97A5-169BC58D9E03}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(Value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(Value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(Value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(Value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(Value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(Value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(Value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const Value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(Value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(Value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(Value: Integer); safecall;
    function Get_AutoSize: Integer; safecall;
    procedure Set_AutoSize(Value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(Value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(Value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(Value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(Value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(Value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(Value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(Value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(Value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(Value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(Value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowAccelChar: Integer; safecall;
    procedure Set_ShowAccelChar(Value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(Value: Integer); safecall;
    function Get_Transparent: Integer; safecall;
    procedure Set_Transparent(Value: Integer); safecall;
    function Get_Layout: Integer; safecall;
    procedure Set_Layout(Value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(Value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(Value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property Align: Integer read Get_Align write Set_Align;
    property Alignment: Integer read Get_Alignment write Set_Alignment;
    property AutoSize: Integer read Get_AutoSize write Set_AutoSize;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Color: Integer read Get_Color write Set_Color;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowAccelChar: Integer read Get_ShowAccelChar write Set_ShowAccelChar;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property Transparent: Integer read Get_Transparent write Set_Transparent;
    property Layout: Integer read Get_Layout write Set_Layout;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WordWrap: Integer read Get_WordWrap write Set_WordWrap;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlLabelDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F53704E6-83C2-4021-97A5-169BC58D9E03}
// *********************************************************************//
  IExodusControlLabelDisp = dispinterface
    ['{F53704E6-83C2-4021-97A5-169BC58D9E03}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property Align: Integer dispid 12;
    property Alignment: Integer dispid 13;
    property AutoSize: Integer dispid 14;
    property BiDiMode: Integer dispid 15;
    property Caption: WideString dispid 16;
    property Color: Integer dispid 17;
    property DragCursor: Integer dispid 18;
    property DragKind: Integer dispid 19;
    property DragMode: Integer dispid 20;
    property Enabled: Integer dispid 21;
    property Font: IExodusControlFont readonly dispid 22;
    property ParentBiDiMode: Integer dispid 23;
    property ParentColor: Integer dispid 24;
    property ParentFont: Integer dispid 25;
    property ParentShowHint: Integer dispid 26;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 27;
    property ShowAccelChar: Integer dispid 28;
    property ShowHint: Integer dispid 29;
    property Transparent: Integer dispid 30;
    property Layout: Integer dispid 31;
    property Visible: Integer dispid 32;
    property WordWrap: Integer dispid 33;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlListBox
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F34F969E-4BC2-4ADE-8648-A8F618FCC205}
// *********************************************************************//
  IExodusControlListBox = interface(IExodusControl)
    ['{F34F969E-4BC2-4ADE-8648-A8F618FCC205}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(Value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(Value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(Value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(Value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(Value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(Value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(Value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const Value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(Value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(Value: Integer); safecall;
    function Get_Style: Integer; safecall;
    procedure Set_Style(Value: Integer); safecall;
    function Get_AutoComplete: Integer; safecall;
    procedure Set_AutoComplete(Value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(Value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(Value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(Value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(Value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(Value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(Value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(Value: Integer); safecall;
    function Get_Columns: Integer; safecall;
    procedure Set_Columns(Value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(Value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(Value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(Value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(Value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(Value: Integer); safecall;
    function Get_ExtendedSelect: Integer; safecall;
    procedure Set_ExtendedSelect(Value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(Value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const Value: WideString); safecall;
    function Get_IntegralHeight: Integer; safecall;
    procedure Set_IntegralHeight(Value: Integer); safecall;
    function Get_ItemHeight: Integer; safecall;
    procedure Set_ItemHeight(Value: Integer); safecall;
    function Get_Items(Index: Integer): WideString; safecall;
    procedure Set_Items(Index: Integer; const Value: WideString); safecall;
    function Get_MultiSelect: Integer; safecall;
    procedure Set_MultiSelect(Value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(Value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(Value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(Value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(Value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(Value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ScrollWidth: Integer; safecall;
    procedure Set_ScrollWidth(Value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(Value: Integer); safecall;
    function Get_Sorted: Integer; safecall;
    procedure Set_Sorted(Value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(Value: Integer); safecall;
    function Get_TabWidth: Integer; safecall;
    procedure Set_TabWidth(Value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(Value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Style: Integer read Get_Style write Set_Style;
    property AutoComplete: Integer read Get_AutoComplete write Set_AutoComplete;
    property Align: Integer read Get_Align write Set_Align;
    property BevelInner: Integer read Get_BevelInner write Set_BevelInner;
    property BevelKind: Integer read Get_BevelKind write Set_BevelKind;
    property BevelOuter: Integer read Get_BevelOuter write Set_BevelOuter;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property BorderStyle: Integer read Get_BorderStyle write Set_BorderStyle;
    property Color: Integer read Get_Color write Set_Color;
    property Columns: Integer read Get_Columns write Set_Columns;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property ExtendedSelect: Integer read Get_ExtendedSelect write Set_ExtendedSelect;
    property Font: IExodusControlFont read Get_Font;
    property ImeMode: Integer read Get_ImeMode write Set_ImeMode;
    property ImeName: WideString read Get_ImeName write Set_ImeName;
    property IntegralHeight: Integer read Get_IntegralHeight write Set_IntegralHeight;
    property ItemHeight: Integer read Get_ItemHeight write Set_ItemHeight;
    property Items[Index: Integer]: WideString read Get_Items write Set_Items;
    property MultiSelect: Integer read Get_MultiSelect write Set_MultiSelect;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ScrollWidth: Integer read Get_ScrollWidth write Set_ScrollWidth;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property Sorted: Integer read Get_Sorted write Set_Sorted;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property TabWidth: Integer read Get_TabWidth write Set_TabWidth;
    property Visible: Integer read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlListBoxDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F34F969E-4BC2-4ADE-8648-A8F618FCC205}
// *********************************************************************//
  IExodusControlListBoxDisp = dispinterface
    ['{F34F969E-4BC2-4ADE-8648-A8F618FCC205}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property TabStop: Integer dispid 12;
    property Style: Integer dispid 13;
    property AutoComplete: Integer dispid 14;
    property Align: Integer dispid 15;
    property BevelInner: Integer dispid 16;
    property BevelKind: Integer dispid 17;
    property BevelOuter: Integer dispid 18;
    property BiDiMode: Integer dispid 19;
    property BorderStyle: Integer dispid 20;
    property Color: Integer dispid 21;
    property Columns: Integer dispid 22;
    property Ctl3D: Integer dispid 23;
    property DragCursor: Integer dispid 24;
    property DragKind: Integer dispid 25;
    property DragMode: Integer dispid 26;
    property Enabled: Integer dispid 27;
    property ExtendedSelect: Integer dispid 28;
    property Font: IExodusControlFont readonly dispid 29;
    property ImeMode: Integer dispid 30;
    property ImeName: WideString dispid 31;
    property IntegralHeight: Integer dispid 32;
    property ItemHeight: Integer dispid 33;
    property Items[Index: Integer]: WideString dispid 34;
    property MultiSelect: Integer dispid 35;
    property ParentBiDiMode: Integer dispid 36;
    property ParentColor: Integer dispid 37;
    property ParentCtl3D: Integer dispid 38;
    property ParentFont: Integer dispid 39;
    property ParentShowHint: Integer dispid 40;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 41;
    property ScrollWidth: Integer dispid 42;
    property ShowHint: Integer dispid 43;
    property Sorted: Integer dispid 44;
    property TabOrder: Integer dispid 45;
    property TabWidth: Integer dispid 46;
    property Visible: Integer dispid 47;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlMenuItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFBC071A-460A-4E1B-89EC-25B23460BA93}
// *********************************************************************//
  IExodusControlMenuItem = interface(IExodusControl)
    ['{EFBC071A-460A-4E1B-89EC-25B23460BA93}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(Value: Integer); safecall;
    function Get_AutoCheck: Integer; safecall;
    procedure Set_AutoCheck(Value: Integer); safecall;
    function Get_AutoHotkeys: Integer; safecall;
    procedure Set_AutoHotkeys(Value: Integer); safecall;
    function Get_AutoLineReduction: Integer; safecall;
    procedure Set_AutoLineReduction(Value: Integer); safecall;
    function Get_Break: Integer; safecall;
    procedure Set_Break(Value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Checked: Integer; safecall;
    procedure Set_Checked(Value: Integer); safecall;
    function Get_Default: Integer; safecall;
    procedure Set_Default(Value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(Value: Integer); safecall;
    function Get_GroupIndex: Integer; safecall;
    procedure Set_GroupIndex(Value: Integer); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(Value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    function Get_imageIndex: Integer; safecall;
    procedure Set_imageIndex(Value: Integer); safecall;
    function Get_RadioItem: Integer; safecall;
    procedure Set_RadioItem(Value: Integer); safecall;
    function Get_ShortCut: Integer; safecall;
    procedure Set_ShortCut(Value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(Value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property AutoCheck: Integer read Get_AutoCheck write Set_AutoCheck;
    property AutoHotkeys: Integer read Get_AutoHotkeys write Set_AutoHotkeys;
    property AutoLineReduction: Integer read Get_AutoLineReduction write Set_AutoLineReduction;
    property Break: Integer read Get_Break write Set_Break;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Checked: Integer read Get_Checked write Set_Checked;
    property Default: Integer read Get_Default write Set_Default;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property GroupIndex: Integer read Get_GroupIndex write Set_GroupIndex;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property Hint: WideString read Get_Hint write Set_Hint;
    property imageIndex: Integer read Get_imageIndex write Set_imageIndex;
    property RadioItem: Integer read Get_RadioItem write Set_RadioItem;
    property ShortCut: Integer read Get_ShortCut write Set_ShortCut;
    property Visible: Integer read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlMenuItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFBC071A-460A-4E1B-89EC-25B23460BA93}
// *********************************************************************//
  IExodusControlMenuItemDisp = dispinterface
    ['{EFBC071A-460A-4E1B-89EC-25B23460BA93}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property AutoCheck: Integer dispid 3;
    property AutoHotkeys: Integer dispid 4;
    property AutoLineReduction: Integer dispid 5;
    property Break: Integer dispid 6;
    property Caption: WideString dispid 7;
    property Checked: Integer dispid 8;
    property Default: Integer dispid 9;
    property Enabled: Integer dispid 10;
    property GroupIndex: Integer dispid 11;
    property HelpContext: Integer dispid 12;
    property Hint: WideString dispid 13;
    property imageIndex: Integer dispid 14;
    property RadioItem: Integer dispid 15;
    property ShortCut: Integer dispid 16;
    property Visible: Integer dispid 17;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlPanel
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA37BB99-F039-49B7-AB56-819E87B0472F}
// *********************************************************************//
  IExodusControlPanel = interface(IExodusControl)
    ['{BA37BB99-F039-49B7-AB56-819E87B0472F}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(Value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(Value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(Value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(Value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(Value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(Value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(Value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const Value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(Value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(Value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(Value: Integer); safecall;
    function Get_AutoSize: Integer; safecall;
    procedure Set_AutoSize(Value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(Value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(Value: Integer); safecall;
    function Get_BevelWidth: Integer; safecall;
    procedure Set_BevelWidth(Value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(Value: Integer); safecall;
    function Get_BorderWidth: Integer; safecall;
    procedure Set_BorderWidth(Value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(Value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(Value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(Value: Integer); safecall;
    function Get_UseDockManager: Integer; safecall;
    procedure Set_UseDockManager(Value: Integer); safecall;
    function Get_DockSite: Integer; safecall;
    procedure Set_DockSite(Value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(Value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(Value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(Value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(Value: Integer); safecall;
    function Get_FullRepaint: Integer; safecall;
    procedure Set_FullRepaint(Value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_Locked: Integer; safecall;
    procedure Set_Locked(Value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(Value: Integer); safecall;
    function Get_ParentBackground: Integer; safecall;
    procedure Set_ParentBackground(Value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(Value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(Value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(Value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(Value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(Value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(Value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(Value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(Value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property Align: Integer read Get_Align write Set_Align;
    property Alignment: Integer read Get_Alignment write Set_Alignment;
    property AutoSize: Integer read Get_AutoSize write Set_AutoSize;
    property BevelInner: Integer read Get_BevelInner write Set_BevelInner;
    property BevelOuter: Integer read Get_BevelOuter write Set_BevelOuter;
    property BevelWidth: Integer read Get_BevelWidth write Set_BevelWidth;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property BorderWidth: Integer read Get_BorderWidth write Set_BorderWidth;
    property BorderStyle: Integer read Get_BorderStyle write Set_BorderStyle;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Color: Integer read Get_Color write Set_Color;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property UseDockManager: Integer read Get_UseDockManager write Set_UseDockManager;
    property DockSite: Integer read Get_DockSite write Set_DockSite;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property FullRepaint: Integer read Get_FullRepaint write Set_FullRepaint;
    property Font: IExodusControlFont read Get_Font;
    property Locked: Integer read Get_Locked write Set_Locked;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentBackground: Integer read Get_ParentBackground write Set_ParentBackground;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Visible: Integer read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlPanelDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA37BB99-F039-49B7-AB56-819E87B0472F}
// *********************************************************************//
  IExodusControlPanelDisp = dispinterface
    ['{BA37BB99-F039-49B7-AB56-819E87B0472F}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property Align: Integer dispid 12;
    property Alignment: Integer dispid 13;
    property AutoSize: Integer dispid 14;
    property BevelInner: Integer dispid 15;
    property BevelOuter: Integer dispid 16;
    property BevelWidth: Integer dispid 17;
    property BiDiMode: Integer dispid 18;
    property BorderWidth: Integer dispid 19;
    property BorderStyle: Integer dispid 20;
    property Caption: WideString dispid 21;
    property Color: Integer dispid 22;
    property Ctl3D: Integer dispid 23;
    property UseDockManager: Integer dispid 24;
    property DockSite: Integer dispid 25;
    property DragCursor: Integer dispid 26;
    property DragKind: Integer dispid 27;
    property DragMode: Integer dispid 28;
    property Enabled: Integer dispid 29;
    property FullRepaint: Integer dispid 30;
    property Font: IExodusControlFont readonly dispid 31;
    property Locked: Integer dispid 32;
    property ParentBiDiMode: Integer dispid 33;
    property ParentBackground: Integer dispid 34;
    property ParentColor: Integer dispid 35;
    property ParentCtl3D: Integer dispid 36;
    property ParentFont: Integer dispid 37;
    property ParentShowHint: Integer dispid 38;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 39;
    property ShowHint: Integer dispid 40;
    property TabOrder: Integer dispid 41;
    property TabStop: Integer dispid 42;
    property Visible: Integer dispid 43;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlPopupMenu
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F80CD345-A91C-40C8-89CD-AD5BE532B9C2}
// *********************************************************************//
  IExodusControlPopupMenu = interface(IExodusControl)
    ['{F80CD345-A91C-40C8-89CD-AD5BE532B9C2}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(Value: Integer); safecall;
    function Get_Items: IExodusControlMenuItem; safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(Value: Integer); safecall;
    function Get_AutoHotkeys: Integer; safecall;
    procedure Set_AutoHotkeys(Value: Integer); safecall;
    function Get_AutoLineReduction: Integer; safecall;
    procedure Set_AutoLineReduction(Value: Integer); safecall;
    function Get_AutoPopup: Integer; safecall;
    procedure Set_AutoPopup(Value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(Value: Integer); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(Value: Integer); safecall;
    function Get_OwnerDraw: Integer; safecall;
    procedure Set_OwnerDraw(Value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(Value: Integer); safecall;
    function Get_TrackButton: Integer; safecall;
    procedure Set_TrackButton(Value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Items: IExodusControlMenuItem read Get_Items;
    property Alignment: Integer read Get_Alignment write Set_Alignment;
    property AutoHotkeys: Integer read Get_AutoHotkeys write Set_AutoHotkeys;
    property AutoLineReduction: Integer read Get_AutoLineReduction write Set_AutoLineReduction;
    property AutoPopup: Integer read Get_AutoPopup write Set_AutoPopup;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property OwnerDraw: Integer read Get_OwnerDraw write Set_OwnerDraw;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property TrackButton: Integer read Get_TrackButton write Set_TrackButton;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlPopupMenuDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F80CD345-A91C-40C8-89CD-AD5BE532B9C2}
// *********************************************************************//
  IExodusControlPopupMenuDisp = dispinterface
    ['{F80CD345-A91C-40C8-89CD-AD5BE532B9C2}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Items: IExodusControlMenuItem readonly dispid 3;
    property Alignment: Integer dispid 4;
    property AutoHotkeys: Integer dispid 5;
    property AutoLineReduction: Integer dispid 6;
    property AutoPopup: Integer dispid 7;
    property BiDiMode: Integer dispid 8;
    property HelpContext: Integer dispid 9;
    property OwnerDraw: Integer dispid 10;
    property ParentBiDiMode: Integer dispid 11;
    property TrackButton: Integer dispid 12;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlRadioButton
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {87FAD954-03E1-4657-B58D-9947087EAAEC}
// *********************************************************************//
  IExodusControlRadioButton = interface(IExodusControl)
    ['{87FAD954-03E1-4657-B58D-9947087EAAEC}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(Value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(Value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(Value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(Value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(Value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(Value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(Value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const Value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(Value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(Value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(Value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Checked: Integer; safecall;
    procedure Set_Checked(Value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(Value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(Value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(Value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(Value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(Value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(Value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(Value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(Value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(Value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(Value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(Value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(Value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(Value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(Value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(Value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(Value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property Alignment: Integer read Get_Alignment write Set_Alignment;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Checked: Integer read Get_Checked write Set_Checked;
    property Color: Integer read Get_Color write Set_Color;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WordWrap: Integer read Get_WordWrap write Set_WordWrap;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlRadioButtonDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {87FAD954-03E1-4657-B58D-9947087EAAEC}
// *********************************************************************//
  IExodusControlRadioButtonDisp = dispinterface
    ['{87FAD954-03E1-4657-B58D-9947087EAAEC}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property Alignment: Integer dispid 12;
    property BiDiMode: Integer dispid 13;
    property Caption: WideString dispid 14;
    property Checked: Integer dispid 15;
    property Color: Integer dispid 16;
    property Ctl3D: Integer dispid 17;
    property DragCursor: Integer dispid 18;
    property DragKind: Integer dispid 19;
    property DragMode: Integer dispid 20;
    property Enabled: Integer dispid 21;
    property Font: IExodusControlFont readonly dispid 22;
    property ParentBiDiMode: Integer dispid 23;
    property ParentColor: Integer dispid 24;
    property ParentCtl3D: Integer dispid 25;
    property ParentFont: Integer dispid 26;
    property ParentShowHint: Integer dispid 27;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 28;
    property ShowHint: Integer dispid 29;
    property TabOrder: Integer dispid 30;
    property TabStop: Integer dispid 31;
    property Visible: Integer dispid 32;
    property WordWrap: Integer dispid 33;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlRichEdit
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3997314D-4068-43E7-ACEB-150FF196069C}
// *********************************************************************//
  IExodusControlRichEdit = interface(IExodusControl)
    ['{3997314D-4068-43E7-ACEB-150FF196069C}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(Value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(Value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(Value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(Value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(Value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(Value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(Value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const Value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(Value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(Value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(Value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(Value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(Value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(Value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(Value: Integer); safecall;
    function Get_BevelWidth: Integer; safecall;
    procedure Set_BevelWidth(Value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(Value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(Value: Integer); safecall;
    function Get_BorderWidth: Integer; safecall;
    procedure Set_BorderWidth(Value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(Value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(Value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(Value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(Value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(Value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(Value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_HideSelection: Integer; safecall;
    procedure Set_HideSelection(Value: Integer); safecall;
    function Get_HideScrollBars: Integer; safecall;
    procedure Set_HideScrollBars(Value: Integer); safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(Value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const Value: WideString); safecall;
    function Get_LinesCount: Integer; safecall;
    function Get_Lines(Index: Integer): WideString; safecall;
    procedure Set_Lines(Index: Integer; const Value: WideString); safecall;
    function Get_MaxLength: Integer; safecall;
    procedure Set_MaxLength(Value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(Value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(Value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(Value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(Value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(Value: Integer); safecall;
    function Get_PlainText: Integer; safecall;
    procedure Set_PlainText(Value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ReadOnly: Integer; safecall;
    procedure Set_ReadOnly(Value: Integer); safecall;
    function Get_ScrollBars: Integer; safecall;
    procedure Set_ScrollBars(Value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(Value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(Value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(Value: Integer); safecall;
    function Get_WantTabs: Integer; safecall;
    procedure Set_WantTabs(Value: Integer); safecall;
    function Get_WantReturns: Integer; safecall;
    procedure Set_WantReturns(Value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(Value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Align: Integer read Get_Align write Set_Align;
    property Alignment: Integer read Get_Alignment write Set_Alignment;
    property BevelInner: Integer read Get_BevelInner write Set_BevelInner;
    property BevelOuter: Integer read Get_BevelOuter write Set_BevelOuter;
    property BevelKind: Integer read Get_BevelKind write Set_BevelKind;
    property BevelWidth: Integer read Get_BevelWidth write Set_BevelWidth;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property BorderStyle: Integer read Get_BorderStyle write Set_BorderStyle;
    property BorderWidth: Integer read Get_BorderWidth write Set_BorderWidth;
    property Color: Integer read Get_Color write Set_Color;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property HideSelection: Integer read Get_HideSelection write Set_HideSelection;
    property HideScrollBars: Integer read Get_HideScrollBars write Set_HideScrollBars;
    property ImeMode: Integer read Get_ImeMode write Set_ImeMode;
    property ImeName: WideString read Get_ImeName write Set_ImeName;
    property LinesCount: Integer read Get_LinesCount;
    property Lines[Index: Integer]: WideString read Get_Lines write Set_Lines;
    property MaxLength: Integer read Get_MaxLength write Set_MaxLength;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PlainText: Integer read Get_PlainText write Set_PlainText;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ReadOnly: Integer read Get_ReadOnly write Set_ReadOnly;
    property ScrollBars: Integer read Get_ScrollBars write Set_ScrollBars;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WantTabs: Integer read Get_WantTabs write Set_WantTabs;
    property WantReturns: Integer read Get_WantReturns write Set_WantReturns;
    property WordWrap: Integer read Get_WordWrap write Set_WordWrap;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlRichEditDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3997314D-4068-43E7-ACEB-150FF196069C}
// *********************************************************************//
  IExodusControlRichEditDisp = dispinterface
    ['{3997314D-4068-43E7-ACEB-150FF196069C}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property TabStop: Integer dispid 12;
    property Align: Integer dispid 13;
    property Alignment: Integer dispid 14;
    property BevelInner: Integer dispid 15;
    property BevelOuter: Integer dispid 16;
    property BevelKind: Integer dispid 17;
    property BevelWidth: Integer dispid 18;
    property BiDiMode: Integer dispid 19;
    property BorderStyle: Integer dispid 20;
    property BorderWidth: Integer dispid 21;
    property Color: Integer dispid 22;
    property Ctl3D: Integer dispid 23;
    property DragCursor: Integer dispid 24;
    property DragKind: Integer dispid 25;
    property DragMode: Integer dispid 26;
    property Enabled: Integer dispid 27;
    property Font: IExodusControlFont readonly dispid 28;
    property HideSelection: Integer dispid 29;
    property HideScrollBars: Integer dispid 30;
    property ImeMode: Integer dispid 31;
    property ImeName: WideString dispid 32;
    property LinesCount: Integer readonly dispid 33;
    property Lines[Index: Integer]: WideString dispid 34;
    property MaxLength: Integer dispid 35;
    property ParentBiDiMode: Integer dispid 36;
    property ParentColor: Integer dispid 37;
    property ParentCtl3D: Integer dispid 38;
    property ParentFont: Integer dispid 39;
    property ParentShowHint: Integer dispid 40;
    property PlainText: Integer dispid 41;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 42;
    property ReadOnly: Integer dispid 43;
    property ScrollBars: Integer dispid 44;
    property ShowHint: Integer dispid 45;
    property TabOrder: Integer dispid 46;
    property Visible: Integer dispid 47;
    property WantTabs: Integer dispid 48;
    property WantReturns: Integer dispid 49;
    property WordWrap: Integer dispid 50;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlButton
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0D41733E-3505-46FB-B199-C6046E1C84C7}
// *********************************************************************//
  IExodusControlButton = interface(IExodusControl)
    ['{0D41733E-3505-46FB-B199-C6046E1C84C7}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(Value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(Value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(Value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(Value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(Value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(Value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(Value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const Value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(Value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(Value: Integer); safecall;
    function Get_Cancel: Integer; safecall;
    procedure Set_Cancel(Value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Default: Integer; safecall;
    procedure Set_Default(Value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(Value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(Value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(Value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(Value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ModalResult: Integer; safecall;
    procedure Set_ModalResult(Value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(Value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(Value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(Value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(Value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(Value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(Value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(Value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(Value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property Cancel: Integer read Get_Cancel write Set_Cancel;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Default: Integer read Get_Default write Set_Default;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property ModalResult: Integer read Get_ModalResult write Set_ModalResult;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WordWrap: Integer read Get_WordWrap write Set_WordWrap;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlButtonDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0D41733E-3505-46FB-B199-C6046E1C84C7}
// *********************************************************************//
  IExodusControlButtonDisp = dispinterface
    ['{0D41733E-3505-46FB-B199-C6046E1C84C7}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property BiDiMode: Integer dispid 12;
    property Cancel: Integer dispid 13;
    property Caption: WideString dispid 14;
    property Default: Integer dispid 15;
    property DragCursor: Integer dispid 16;
    property DragKind: Integer dispid 17;
    property DragMode: Integer dispid 18;
    property Enabled: Integer dispid 19;
    property Font: IExodusControlFont readonly dispid 20;
    property ModalResult: Integer dispid 21;
    property ParentBiDiMode: Integer dispid 22;
    property ParentFont: Integer dispid 23;
    property ParentShowHint: Integer dispid 24;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 25;
    property ShowHint: Integer dispid 26;
    property TabOrder: Integer dispid 27;
    property TabStop: Integer dispid 28;
    property Visible: Integer dispid 29;
    property WordWrap: Integer dispid 30;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusIQListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {57DFE494-4509-4972-A93B-6C7E6A9D6A59}
// *********************************************************************//
  IExodusIQListener = interface(IDispatch)
    ['{57DFE494-4509-4972-A93B-6C7E6A9D6A59}']
    procedure Process(Handle: Integer; const XML: WideString); safecall;
    procedure Timeout(Handle: Integer); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusIQListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {57DFE494-4509-4972-A93B-6C7E6A9D6A59}
// *********************************************************************//
  IExodusIQListenerDisp = dispinterface
    ['{57DFE494-4509-4972-A93B-6C7E6A9D6A59}']
    procedure Process(Handle: Integer; const XML: WideString); dispid 201;
    procedure Timeout(Handle: Integer); dispid 202;
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

// *********************************************************************//
// The Class CoExodusRosterItem provides a Create and CreateRemote method to          
// create instances of the default interface IExodusRosterItem exposed by              
// the CoClass ExodusRosterItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusRosterItem = class
    class function Create: IExodusRosterItem;
    class function CreateRemote(const MachineName: string): IExodusRosterItem;
  end;

// *********************************************************************//
// The Class CoExodusPresence provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPresence exposed by              
// the CoClass ExodusPresence. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusPresence = class
    class function Create: IExodusPresence;
    class function CreateRemote(const MachineName: string): IExodusPresence;
  end;

// *********************************************************************//
// The Class CoExodusRosterGroup provides a Create and CreateRemote method to          
// create instances of the default interface IExodusRosterGroup exposed by              
// the CoClass ExodusRosterGroup. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusRosterGroup = class
    class function Create: IExodusRosterGroup;
    class function CreateRemote(const MachineName: string): IExodusRosterGroup;
  end;

// *********************************************************************//
// The Class CoExodusRosterImages provides a Create and CreateRemote method to          
// create instances of the default interface IExodusRosterImages exposed by              
// the CoClass ExodusRosterImages. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusRosterImages = class
    class function Create: IExodusRosterImages;
    class function CreateRemote(const MachineName: string): IExodusRosterImages;
  end;

// *********************************************************************//
// The Class CoExodusEntityCache provides a Create and CreateRemote method to          
// create instances of the default interface IExodusEntityCache exposed by              
// the CoClass ExodusEntityCache. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusEntityCache = class
    class function Create: IExodusEntityCache;
    class function CreateRemote(const MachineName: string): IExodusEntityCache;
  end;

// *********************************************************************//
// The Class CoExodusEntity provides a Create and CreateRemote method to          
// create instances of the default interface IExodusEntity exposed by              
// the CoClass ExodusEntity. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusEntity = class
    class function Create: IExodusEntity;
    class function CreateRemote(const MachineName: string): IExodusEntity;
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

class function CoExodusRosterItem.Create: IExodusRosterItem;
begin
  Result := CreateComObject(CLASS_ExodusRosterItem) as IExodusRosterItem;
end;

class function CoExodusRosterItem.CreateRemote(const MachineName: string): IExodusRosterItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusRosterItem) as IExodusRosterItem;
end;

class function CoExodusPresence.Create: IExodusPresence;
begin
  Result := CreateComObject(CLASS_ExodusPresence) as IExodusPresence;
end;

class function CoExodusPresence.CreateRemote(const MachineName: string): IExodusPresence;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusPresence) as IExodusPresence;
end;

class function CoExodusRosterGroup.Create: IExodusRosterGroup;
begin
  Result := CreateComObject(CLASS_ExodusRosterGroup) as IExodusRosterGroup;
end;

class function CoExodusRosterGroup.CreateRemote(const MachineName: string): IExodusRosterGroup;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusRosterGroup) as IExodusRosterGroup;
end;

class function CoExodusRosterImages.Create: IExodusRosterImages;
begin
  Result := CreateComObject(CLASS_ExodusRosterImages) as IExodusRosterImages;
end;

class function CoExodusRosterImages.CreateRemote(const MachineName: string): IExodusRosterImages;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusRosterImages) as IExodusRosterImages;
end;

class function CoExodusEntityCache.Create: IExodusEntityCache;
begin
  Result := CreateComObject(CLASS_ExodusEntityCache) as IExodusEntityCache;
end;

class function CoExodusEntityCache.CreateRemote(const MachineName: string): IExodusEntityCache;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusEntityCache) as IExodusEntityCache;
end;

class function CoExodusEntity.Create: IExodusEntity;
begin
  Result := CreateComObject(CLASS_ExodusEntity) as IExodusEntity;
end;

class function CoExodusEntity.CreateRemote(const MachineName: string): IExodusEntity;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusEntity) as IExodusEntity;
end;

end.
