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

// PASTLWTR : 1.2
// File generated on 11/29/2006 10:58:26 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Projects\exodus\exodus\Exodus.tlb (1)
// LIBID: {37C1EF21-E4CD-4FF0-B6A5-3F0A649431C8}
// LCID: 0
// Helpfile: 
// HelpString: Exodus COM Plugin interfaces
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
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
  ExodusMajorVersion = 1;
  ExodusMinorVersion = 0;

  LIBID_Exodus: TGUID = '{37C1EF21-E4CD-4FF0-B6A5-3F0A649431C8}';

  IID_IExodusController: TGUID = '{A764C2F3-F1C9-4DE6-95D7-5876C9D4E99C}';
  CLASS_exodusController: TGUID = '{E89B1EBA-8CF8-4A00-B15D-18149A0FA830}';
  IID_IExodusChat: TGUID = '{D2639B6C-A7BB-4CCC-BD73-8C1EB197F9D3}';
  IID_IExodusMenuListener: TGUID = '{2ABB30A9-94E3-4085-BED5-4561F62E36EF}';
  IID_IExodusChatPlugin: TGUID = '{E28E487A-7258-4B32-AD1C-F23A808F0460}';
  IID_IExodusRoster: TGUID = '{29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}';
  IID_IExodusPPDB: TGUID = '{284E49F2-2006-4E48-B0E0-233867A78E54}';
  IID_IExodusRosterItem: TGUID = '{BDD5493D-440F-4376-802B-070B5A4ABFF3}';
  IID_IExodusPresence: TGUID = '{FF4EFE7E-35AC-48B5-ACDB-6753C402F0DB}';
  IID_IExodusAuth: TGUID = '{BFE1905C-3620-4C9D-B0C2-27EB456EF73B}';
  IID_IExodusRosterGroup: TGUID = '{FA63024E-3453-4551-8CA0-AFB78B2066AD}';
  IID_IExodusRosterImages: TGUID = '{F4AAF511-D144-42E7-B108-8A196D4BD115}';
  IID_IExodusEntityCache: TGUID = '{6759BFE4-C72D-42E3-86A3-1F343E848933}';
  IID_IExodusEntity: TGUID = '{1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}';
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
  CLASS_ExodusChat: TGUID = '{C9FEB6AF-32BE-4B47-984C-9DA11B4DF7A6}';
  CLASS_ExodusRoster: TGUID = '{027E1B53-59A9-4FA4-9610-AC6CA2561248}';
  CLASS_ExodusPPDB: TGUID = '{9ED8C497-1121-4C9E-B586-C7DFDB35B581}';
  CLASS_ExodusRosterItem: TGUID = '{B39343ED-2E2D-4C91-AE4F-E0153BA347DA}';
  CLASS_ExodusPresence: TGUID = '{8B7DF610-B49C-4A90-9B98-CB0CB27D8827}';
  CLASS_ExodusRosterGroup: TGUID = '{05237BC3-3093-4541-941D-A38FAFB78D89}';
  CLASS_ExodusRosterImages: TGUID = '{F0EA9081-9352-496D-94BA-E96605166527}';
  CLASS_ExodusEntityCache: TGUID = '{B777EA4A-A2A4-4597-87E2-E1B9800BFDC2}';
  CLASS_ExodusEntity: TGUID = '{F7D97ED8-C6BA-470F-8D63-7A6D70894AB3}';
  IID_IExodusControlBitBtn: TGUID = '{2954B16B-64BA-4441-A476-918CCCCA9B46}';
  IID_IExodusControlMainMenu: TGUID = '{0C3AE024-51A4-453F-91CB-B0EEBA175AED}';
  IID_IExodusControlMemo: TGUID = '{62B921DE-13F1-4F63-BCA6-30EE3C66D454}';
  IID_IExodusControlPageControl: TGUID = '{AF41AC90-38C4-46FB-9A45-D7C26ECB2E1C}';
  IID_IExodusControlSpeedButton: TGUID = '{0706359E-DD10-4D98-862B-7417E5E79DE8}';
  IID_IExodusListener: TGUID = '{28132170-54E2-4BDD-A37D-BE115E68F044}';
  IID_IExodusToolbar: TGUID = '{7949D67E-E287-4643-90DA-E6FE7EDEFA97}';
  IID_IExodusToolbarButton: TGUID = '{D4749AC4-6EBE-493B-844C-0455FF0A4A77}';
  CLASS_ExodusToolbar: TGUID = '{E12A4659-336B-4921-AC6A-771B1DCA5AF8}';
  CLASS_ExodusToolbarButton: TGUID = '{D29EB98A-994F-4E67-A12F-652733E7E5DD}';
  IID_IExodusControlForm: TGUID = '{2F60EC05-634D-44B2-BECB-059169BA1459}';
  IID_IExodusLogger: TGUID = '{35542007-5701-4190-AB28-D25EB186CC19}';
  IID_IExodusLogMsg: TGUID = '{2E945876-C2E5-4A24-98B4-0E38BD65D431}';
  CLASS_ExodusLogMsg: TGUID = '{740743C0-7BEF-48E8-BD05-1470047F03CA}';
  IID_IExodusLogListener: TGUID = '{6D58A577-6BC4-4B1C-B5F8-759B94136B0A}';
  CLASS_ExodusLogListener: TGUID = '{98ED888A-0569-4E5B-8933-36EBF08812B4}';
  IID_IExodusPlugin: TGUID = '{6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}';
  IID_IExodusBookmarkManager: TGUID = '{E40D85F3-9E0D-4368-89D0-C4298315CD30}';
  CLASS_ExodusBookmarkManager: TGUID = '{EEEE7D8D-0C7E-4DF1-B556-CFDAD2893123}';
  IID_IExodusToolbarControl: TGUID = '{B35EACB5-C3DC-473E-8C4C-EFA175DF4CAB}';
  CLASS_ExodusToolbarControl: TGUID = '{6AB0CC3F-2AF5-460B-B76C-1A4E807BA152}';

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
  ExodusControlBitBtn = $0000000C;
  ExodusControlMainMenu = $0000000D;
  ExodusControlMemo = $0000000E;
  ExodusControlPageControl = $0000000F;
  ExodusControlSpeedButton = $00000010;
  ExodusControlForm = $00000011;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IExodusController = interface;
  IExodusControllerDisp = dispinterface;
  IExodusChat = interface;
  IExodusChatDisp = dispinterface;
  IExodusMenuListener = interface;
  IExodusMenuListenerDisp = dispinterface;
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
  IExodusControlBitBtn = interface;
  IExodusControlBitBtnDisp = dispinterface;
  IExodusControlMainMenu = interface;
  IExodusControlMainMenuDisp = dispinterface;
  IExodusControlMemo = interface;
  IExodusControlMemoDisp = dispinterface;
  IExodusControlPageControl = interface;
  IExodusControlPageControlDisp = dispinterface;
  IExodusControlSpeedButton = interface;
  IExodusControlSpeedButtonDisp = dispinterface;
  IExodusListener = interface;
  IExodusListenerDisp = dispinterface;
  IExodusToolbar = interface;
  IExodusToolbarDisp = dispinterface;
  IExodusToolbarButton = interface;
  IExodusToolbarButtonDisp = dispinterface;
  IExodusControlForm = interface;
  IExodusControlFormDisp = dispinterface;
  IExodusLogger = interface;
  IExodusLoggerDisp = dispinterface;
  IExodusLogMsg = interface;
  IExodusLogMsgDisp = dispinterface;
  IExodusLogListener = interface;
  IExodusLogListenerDisp = dispinterface;
  IExodusPlugin = interface;
  IExodusPluginDisp = dispinterface;
  IExodusBookmarkManager = interface;
  IExodusBookmarkManagerDisp = dispinterface;
  IExodusToolbarControl = interface;
  IExodusToolbarControlDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  exodusController = IExodusController;
  ExodusChat = IExodusChat;
  ExodusRoster = IExodusRoster;
  ExodusPPDB = IExodusPPDB;
  ExodusRosterItem = IExodusRosterItem;
  ExodusPresence = IExodusPresence;
  ExodusRosterGroup = IExodusRosterGroup;
  ExodusRosterImages = IExodusRosterImages;
  ExodusEntityCache = IExodusEntityCache;
  ExodusEntity = IExodusEntity;
  ExodusToolbar = IExodusToolbar;
  ExodusToolbarButton = IExodusToolbarButton;
  ExodusLogMsg = IExodusLogMsg;
  ExodusLogListener = IExodusLogListener;
  ExodusBookmarkManager = IExodusBookmarkManager;
  ExodusToolbarControl = IExodusToolbarControl;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PWideString1 = ^WideString; {*}


// *********************************************************************//
// Interface: IExodusController
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A764C2F3-F1C9-4DE6-95D7-5876C9D4E99C}
// *********************************************************************//
  IExodusController = interface(IDispatch)
    ['{A764C2F3-F1C9-4DE6-95D7-5876C9D4E99C}']
    function Get_Connected: WordBool; safecall;
    function Get_Username: WideString; safecall;
    function Get_Server: WideString; safecall;
    function RegisterCallback(const xpath: WideString; const callback: IExodusPlugin): Integer; safecall;
    procedure UnRegisterCallback(ID: Integer); safecall;
    procedure Send(const XML: WideString); safecall;
    function IsRosterJID(const JID: WideString): WordBool; safecall;
    function IsSubscribed(const JID: WideString): WordBool; safecall;
    procedure ChangePresence(const Show: WideString; const Status: WideString; Priority: Integer); safecall;
    procedure StartChat(const JID: WideString; const Resource: WideString; 
                        const Nickname: WideString); safecall;
    procedure GetProfile(const JID: WideString); safecall;
    function CreateDockableWindow(const Caption: WideString): Integer; safecall;
    function AddPluginMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; safecall;
    procedure RemovePluginMenu(const menuID: WideString); safecall;
    procedure MonitorImplicitRegJID(const JabberID: WideString; fullJID: WordBool); safecall;
    function GetAgentService(const Server: WideString; const service: WideString): WideString; safecall;
    function GenerateID: WideString; safecall;
    function IsBlocked(const JabberID: WideString): WordBool; safecall;
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
    function GetPrefAsString(const key: WideString): WideString; safecall;
    function GetPrefAsInt(const key: WideString): Integer; safecall;
    function GetPrefAsBool(const key: WideString): WordBool; safecall;
    procedure SetPrefAsString(const key: WideString; const value: WideString); safecall;
    procedure SetPrefAsInt(const key: WideString; value: Integer); safecall;
    procedure SetPrefAsBool(const key: WideString; value: WordBool); safecall;
    function FindChat(const JabberID: WideString; const Resource: WideString): Integer; safecall;
    procedure StartSearch(const searchJID: WideString); safecall;
    procedure StartRoom(const roomJID: WideString; const Nickname: WideString; 
                        const password: WideString; sendPresence: WordBool; 
                        defaultConfig: WordBool; useRegisteredNickname: WordBool); safecall;
    procedure StartInstantMsg(const JabberID: WideString); safecall;
    procedure StartBrowser(const browseJID: WideString); safecall;
    procedure ShowJoinRoom(const roomJID: WideString; const Nickname: WideString; 
                           const password: WideString); safecall;
    procedure ShowPrefs; safecall;
    procedure ShowCustomPresDialog; safecall;
    procedure ShowDebug; safecall;
    procedure ShowLogin; safecall;
    procedure ShowToast(const message: WideString; wndHandle: Integer; ImageIndex: Integer); safecall;
    procedure SetPresence(const Show: WideString; const Status: WideString; Priority: Integer); safecall;
    function Get_Roster: IExodusRoster; safecall;
    function Get_PPDB: IExodusPPDB; safecall;
    function RegisterDiscoItem(const JabberID: WideString; const Name: WideString): WideString; safecall;
    procedure RemoveDiscoItem(const ID: WideString); safecall;
    function RegisterPresenceXML(const XML: WideString): WideString; safecall;
    procedure RemovePresenceXML(const ID: WideString); safecall;
    procedure TrackWindowsMsg(message: Integer); safecall;
    function AddContactMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; safecall;
    procedure RemoveContactMenu(const menuID: WideString); safecall;
    function GetActiveContact: WideString; safecall;
    function GetActiveGroup: WideString; safecall;
    function GetActiveContacts(Online: WordBool): OleVariant; safecall;
    function Get_LocalIP: WideString; safecall;
    procedure SetPluginAuth(const authAgent: IExodusAuth); safecall;
    procedure SetAuthenticated(authed: WordBool; const XML: WideString); safecall;
    procedure SetAuthJID(const Username: WideString; const host: WideString; 
                         const Resource: WideString); safecall;
    function AddMessageMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; safecall;
    function AddGroupMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; safecall;
    procedure RemoveGroupMenu(const menuID: WideString); safecall;
    procedure RegisterWithService(const JabberID: WideString); safecall;
    procedure ShowAddContact(const JID: WideString); safecall;
    procedure RegisterCapExtension(const ext: WideString; const Feature: WideString); safecall;
    procedure UnregisterCapExtension(const ext: WideString); safecall;
    function Get_RosterImages: IExodusRosterImages; safecall;
    function Get_EntityCache: IExodusEntityCache; safecall;
    procedure Debug(const value: WideString); safecall;
    function TrackIQ(const XML: WideString; const listener: IExodusIQListener; timeout: Integer): WideString; safecall;
    procedure FireEvent(const event: WideString; const XML: WideString; const arg: WideString); safecall;
    function RegisterListener(const xpath: WideString; const listener: IExodusListener): Integer; safecall;
    function Get_Toolbar: IExodusToolbar; safecall;
    function Get_ContactLogger: IExodusLogger; safecall;
    procedure Set_ContactLogger(const value: IExodusLogger); safecall;
    function Get_RoomLogger: IExodusLogger; safecall;
    procedure Set_RoomLogger(const value: IExodusLogger); safecall;
    procedure AddStringlistValue(const key: WideString; const value: WideString); safecall;
    procedure RemoveMessageMenu(const menuID: WideString); safecall;
    function GetStringlistCount(const key: WideString): Integer; safecall;
    function GetStringlistValue(const key: WideString; index: Integer): WideString; safecall;
    procedure RemoveStringlistValue(const key: WideString; const value: WideString); safecall;
    function Get_BookmarkManager: IExodusBookmarkManager; safecall;
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
    property LocalIP: WideString read Get_LocalIP;
    property RosterImages: IExodusRosterImages read Get_RosterImages;
    property EntityCache: IExodusEntityCache read Get_EntityCache;
    property Toolbar: IExodusToolbar read Get_Toolbar;
    property ContactLogger: IExodusLogger read Get_ContactLogger write Set_ContactLogger;
    property RoomLogger: IExodusLogger read Get_RoomLogger write Set_RoomLogger;
    property BookmarkManager: IExodusBookmarkManager read Get_BookmarkManager;
  end;

// *********************************************************************//
// DispIntf:  IExodusControllerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A764C2F3-F1C9-4DE6-95D7-5876C9D4E99C}
// *********************************************************************//
  IExodusControllerDisp = dispinterface
    ['{A764C2F3-F1C9-4DE6-95D7-5876C9D4E99C}']
    property Connected: WordBool readonly dispid 1;
    property Username: WideString readonly dispid 2;
    property Server: WideString readonly dispid 3;
    function RegisterCallback(const xpath: WideString; const callback: IExodusPlugin): Integer; dispid 4;
    procedure UnRegisterCallback(ID: Integer); dispid 5;
    procedure Send(const XML: WideString); dispid 6;
    function IsRosterJID(const JID: WideString): WordBool; dispid 7;
    function IsSubscribed(const JID: WideString): WordBool; dispid 8;
    procedure ChangePresence(const Show: WideString; const Status: WideString; Priority: Integer); dispid 11;
    procedure StartChat(const JID: WideString; const Resource: WideString; 
                        const Nickname: WideString); dispid 12;
    procedure GetProfile(const JID: WideString); dispid 13;
    function CreateDockableWindow(const Caption: WideString): Integer; dispid 16;
    function AddPluginMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; dispid 14;
    procedure RemovePluginMenu(const menuID: WideString); dispid 15;
    procedure MonitorImplicitRegJID(const JabberID: WideString; fullJID: WordBool); dispid 17;
    function GetAgentService(const Server: WideString; const service: WideString): WideString; dispid 19;
    function GenerateID: WideString; dispid 20;
    function IsBlocked(const JabberID: WideString): WordBool; dispid 21;
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
    function GetPrefAsString(const key: WideString): WideString; dispid 34;
    function GetPrefAsInt(const key: WideString): Integer; dispid 35;
    function GetPrefAsBool(const key: WideString): WordBool; dispid 36;
    procedure SetPrefAsString(const key: WideString; const value: WideString); dispid 37;
    procedure SetPrefAsInt(const key: WideString; value: Integer); dispid 38;
    procedure SetPrefAsBool(const key: WideString; value: WordBool); dispid 39;
    function FindChat(const JabberID: WideString; const Resource: WideString): Integer; dispid 40;
    procedure StartSearch(const searchJID: WideString); dispid 41;
    procedure StartRoom(const roomJID: WideString; const Nickname: WideString; 
                        const password: WideString; sendPresence: WordBool; 
                        defaultConfig: WordBool; useRegisteredNickname: WordBool); dispid 42;
    procedure StartInstantMsg(const JabberID: WideString); dispid 43;
    procedure StartBrowser(const browseJID: WideString); dispid 44;
    procedure ShowJoinRoom(const roomJID: WideString; const Nickname: WideString; 
                           const password: WideString); dispid 45;
    procedure ShowPrefs; dispid 46;
    procedure ShowCustomPresDialog; dispid 47;
    procedure ShowDebug; dispid 48;
    procedure ShowLogin; dispid 49;
    procedure ShowToast(const message: WideString; wndHandle: Integer; ImageIndex: Integer); dispid 50;
    procedure SetPresence(const Show: WideString; const Status: WideString; Priority: Integer); dispid 51;
    property Roster: IExodusRoster readonly dispid 54;
    property PPDB: IExodusPPDB readonly dispid 55;
    function RegisterDiscoItem(const JabberID: WideString; const Name: WideString): WideString; dispid 10;
    procedure RemoveDiscoItem(const ID: WideString); dispid 53;
    function RegisterPresenceXML(const XML: WideString): WideString; dispid 57;
    procedure RemovePresenceXML(const ID: WideString); dispid 58;
    procedure TrackWindowsMsg(message: Integer); dispid 59;
    function AddContactMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; dispid 60;
    procedure RemoveContactMenu(const menuID: WideString); dispid 61;
    function GetActiveContact: WideString; dispid 62;
    function GetActiveGroup: WideString; dispid 63;
    function GetActiveContacts(Online: WordBool): OleVariant; dispid 65;
    property LocalIP: WideString readonly dispid 64;
    procedure SetPluginAuth(const authAgent: IExodusAuth); dispid 66;
    procedure SetAuthenticated(authed: WordBool; const XML: WideString); dispid 67;
    procedure SetAuthJID(const Username: WideString; const host: WideString; 
                         const Resource: WideString); dispid 68;
    function AddMessageMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; dispid 201;
    function AddGroupMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; dispid 202;
    procedure RemoveGroupMenu(const menuID: WideString); dispid 203;
    procedure RegisterWithService(const JabberID: WideString); dispid 204;
    procedure ShowAddContact(const JID: WideString); dispid 205;
    procedure RegisterCapExtension(const ext: WideString; const Feature: WideString); dispid 206;
    procedure UnregisterCapExtension(const ext: WideString); dispid 207;
    property RosterImages: IExodusRosterImages readonly dispid 208;
    property EntityCache: IExodusEntityCache readonly dispid 209;
    procedure Debug(const value: WideString); dispid 210;
    function TrackIQ(const XML: WideString; const listener: IExodusIQListener; timeout: Integer): WideString; dispid 211;
    procedure FireEvent(const event: WideString; const XML: WideString; const arg: WideString); dispid 212;
    function RegisterListener(const xpath: WideString; const listener: IExodusListener): Integer; dispid 213;
    property Toolbar: IExodusToolbar readonly dispid 214;
    property ContactLogger: IExodusLogger dispid 215;
    property RoomLogger: IExodusLogger dispid 216;
    procedure AddStringlistValue(const key: WideString; const value: WideString); dispid 217;
    procedure RemoveMessageMenu(const menuID: WideString); dispid 218;
    function GetStringlistCount(const key: WideString): Integer; dispid 219;
    function GetStringlistValue(const key: WideString; index: Integer): WideString; dispid 220;
    procedure RemoveStringlistValue(const key: WideString; const value: WideString); dispid 221;
    property BookmarkManager: IExodusBookmarkManager readonly dispid 222;
  end;

// *********************************************************************//
// Interface: IExodusChat
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D2639B6C-A7BB-4CCC-BD73-8C1EB197F9D3}
// *********************************************************************//
  IExodusChat = interface(IDispatch)
    ['{D2639B6C-A7BB-4CCC-BD73-8C1EB197F9D3}']
    function Get_JID: WideString; safecall;
    function AddContextMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; safecall;
    function Get_MsgOutText: WideString; safecall;
    function RegisterPlugin(const plugin: IExodusChatPlugin): Integer; safecall;
    function UnRegisterPlugin(ID: Integer): WordBool; safecall;
    function GetMagicInt(part: ChatParts): Integer; safecall;
    procedure RemoveContextMenu(const menuID: WideString); safecall;
    procedure AddMsgOut(const value: WideString); safecall;
    function AddMsgOutMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; safecall;
    procedure RemoveMsgOutMenu(const menuID: WideString); safecall;
    procedure SendMessage(var Body: WideString; var Subject: WideString; var XML: WideString); safecall;
    function Get_CurrentThreadID: WideString; safecall;
    procedure DisplayMessage(const Body: WideString; const Subject: WideString; 
                             const from: WideString); safecall;
    procedure AddRoomUser(const JID: WideString; const Nickname: WideString); safecall;
    procedure RemoveRoomUser(const JID: WideString); safecall;
    function Get_CurrentNick: WideString; safecall;
    function GetControl(const Name: WideString): IExodusControl; safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    property JID: WideString read Get_JID;
    property MsgOutText: WideString read Get_MsgOutText;
    property CurrentThreadID: WideString read Get_CurrentThreadID;
    property CurrentNick: WideString read Get_CurrentNick;
    property Caption: WideString read Get_Caption write Set_Caption;
  end;

// *********************************************************************//
// DispIntf:  IExodusChatDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D2639B6C-A7BB-4CCC-BD73-8C1EB197F9D3}
// *********************************************************************//
  IExodusChatDisp = dispinterface
    ['{D2639B6C-A7BB-4CCC-BD73-8C1EB197F9D3}']
    property JID: WideString readonly dispid 1;
    function AddContextMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; dispid 2;
    property MsgOutText: WideString readonly dispid 4;
    function RegisterPlugin(const plugin: IExodusChatPlugin): Integer; dispid 3;
    function UnRegisterPlugin(ID: Integer): WordBool; dispid 5;
    function GetMagicInt(part: ChatParts): Integer; dispid 6;
    procedure RemoveContextMenu(const menuID: WideString); dispid 7;
    procedure AddMsgOut(const value: WideString); dispid 201;
    function AddMsgOutMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; dispid 202;
    procedure RemoveMsgOutMenu(const menuID: WideString); dispid 203;
    procedure SendMessage(var Body: WideString; var Subject: WideString; var XML: WideString); dispid 204;
    property CurrentThreadID: WideString readonly dispid 205;
    procedure DisplayMessage(const Body: WideString; const Subject: WideString; 
                             const from: WideString); dispid 206;
    procedure AddRoomUser(const JID: WideString; const Nickname: WideString); dispid 207;
    procedure RemoveRoomUser(const JID: WideString); dispid 208;
    property CurrentNick: WideString readonly dispid 209;
    function GetControl(const Name: WideString): IExodusControl; dispid 210;
    property Caption: WideString dispid 211;
  end;

// *********************************************************************//
// Interface: IExodusMenuListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2ABB30A9-94E3-4085-BED5-4561F62E36EF}
// *********************************************************************//
  IExodusMenuListener = interface(IDispatch)
    ['{2ABB30A9-94E3-4085-BED5-4561F62E36EF}']
    procedure OnMenuItemClick(const menuID: WideString; const XML: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusMenuListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2ABB30A9-94E3-4085-BED5-4561F62E36EF}
// *********************************************************************//
  IExodusMenuListenerDisp = dispinterface
    ['{2ABB30A9-94E3-4085-BED5-4561F62E36EF}']
    procedure OnMenuItemClick(const menuID: WideString; const XML: WideString); dispid 255;
  end;

// *********************************************************************//
// Interface: IExodusChatPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E28E487A-7258-4B32-AD1C-F23A808F0460}
// *********************************************************************//
  IExodusChatPlugin = interface(IDispatch)
    ['{E28E487A-7258-4B32-AD1C-F23A808F0460}']
    function OnBeforeMessage(var Body: WideString): WordBool; safecall;
    function OnAfterMessage(var Body: WideString): WideString; safecall;
    procedure OnClose; safecall;
    procedure OnNewWindow(hwnd: Integer); safecall;
    function OnBeforeRecvMessage(const Body: WideString; const XML: WideString): WordBool; safecall;
    procedure OnAfterRecvMessage(var Body: WideString); safecall;
    function OnKeyUp(key: Integer; shiftState: Integer): WordBool; safecall;
    function OnKeyDown(key: Integer; shiftState: Integer): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusChatPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E28E487A-7258-4B32-AD1C-F23A808F0460}
// *********************************************************************//
  IExodusChatPluginDisp = dispinterface
    ['{E28E487A-7258-4B32-AD1C-F23A808F0460}']
    function OnBeforeMessage(var Body: WideString): WordBool; dispid 1;
    function OnAfterMessage(var Body: WideString): WideString; dispid 2;
    procedure OnClose; dispid 6;
    procedure OnNewWindow(hwnd: Integer); dispid 202;
    function OnBeforeRecvMessage(const Body: WideString; const XML: WideString): WordBool; dispid 203;
    procedure OnAfterRecvMessage(var Body: WideString); dispid 204;
    function OnKeyUp(key: Integer; shiftState: Integer): WordBool; dispid 301;
    function OnKeyDown(key: Integer; shiftState: Integer): WordBool; dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusRoster
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}
// *********************************************************************//
  IExodusRoster = interface(IDispatch)
    ['{29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}']
    procedure Fetch; safecall;
    function Subscribe(const JabberID: WideString; const Nickname: WideString; 
                       const Group: WideString; Subscribe: WordBool): IExodusRosterItem; safecall;
    function Find(const JabberID: WideString): IExodusRosterItem; safecall;
    function Item(index: Integer): IExodusRosterItem; safecall;
    function Count: Integer; safecall;
    procedure RemoveItem(const Item: IExodusRosterItem); safecall;
    function AddGroup(const grp: WideString): IExodusRosterGroup; safecall;
    function GetGroup(const grp: WideString): IExodusRosterGroup; safecall;
    procedure RemoveGroup(const grp: IExodusRosterGroup); safecall;
    function Get_GroupsCount: Integer; safecall;
    function Groups(index: Integer): IExodusRosterGroup; safecall;
    function AddContextMenu(const ID: WideString): WordBool; safecall;
    procedure RemoveContextMenu(const ID: WideString); safecall;
    function AddContextMenuItem(const menuID: WideString; const Caption: WideString; 
                                const MenuListener: IExodusMenuListener): WideString; safecall;
    procedure RemoveContextMenuItem(const menuID: WideString; const itemID: WideString); safecall;
    function AddItem(const JabberID: WideString): IExodusRosterItem; safecall;
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
    function Subscribe(const JabberID: WideString; const Nickname: WideString; 
                       const Group: WideString; Subscribe: WordBool): IExodusRosterItem; dispid 3;
    function Find(const JabberID: WideString): IExodusRosterItem; dispid 6;
    function Item(index: Integer): IExodusRosterItem; dispid 7;
    function Count: Integer; dispid 8;
    procedure RemoveItem(const Item: IExodusRosterItem); dispid 201;
    function AddGroup(const grp: WideString): IExodusRosterGroup; dispid 202;
    function GetGroup(const grp: WideString): IExodusRosterGroup; dispid 203;
    procedure RemoveGroup(const grp: IExodusRosterGroup); dispid 204;
    property GroupsCount: Integer readonly dispid 205;
    function Groups(index: Integer): IExodusRosterGroup; dispid 206;
    function AddContextMenu(const ID: WideString): WordBool; dispid 208;
    procedure RemoveContextMenu(const ID: WideString); dispid 209;
    function AddContextMenuItem(const menuID: WideString; const Caption: WideString; 
                                const MenuListener: IExodusMenuListener): WideString; dispid 210;
    procedure RemoveContextMenuItem(const menuID: WideString; const itemID: WideString); dispid 211;
    function AddItem(const JabberID: WideString): IExodusRosterItem; dispid 212;
  end;

// *********************************************************************//
// Interface: IExodusPPDB
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {284E49F2-2006-4E48-B0E0-233867A78E54}
// *********************************************************************//
  IExodusPPDB = interface(IDispatch)
    ['{284E49F2-2006-4E48-B0E0-233867A78E54}']
    function Find(const JabberID: WideString; const Resource: WideString): IExodusPresence; safecall;
    function Next(const JabberID: WideString; const Resource: WideString): IExodusPresence; safecall;
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
    function Find(const JabberID: WideString; const Resource: WideString): IExodusPresence; dispid 1;
    function Next(const JabberID: WideString; const Resource: WideString): IExodusPresence; dispid 2;
    property Count: Integer readonly dispid 3;
    property LastPresence: IExodusPresence readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IExodusRosterItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BDD5493D-440F-4376-802B-070B5A4ABFF3}
// *********************************************************************//
  IExodusRosterItem = interface(IDispatch)
    ['{BDD5493D-440F-4376-802B-070B5A4ABFF3}']
    function Get_JabberID: WideString; safecall;
    function Get_Subscription: WideString; safecall;
    function Get_Ask: WideString; safecall;
    function Get_GroupCount: Integer; safecall;
    function Group(index: Integer): WideString; safecall;
    function XML: WideString; safecall;
    procedure Remove; safecall;
    procedure Update; safecall;
    function Get_Nickname: WideString; safecall;
    procedure Set_Nickname(const value: WideString); safecall;
    function Get_ContextMenuID: WideString; safecall;
    procedure Set_ContextMenuID(const value: WideString); safecall;
    function Get_Status: WideString; safecall;
    procedure Set_Status(const value: WideString); safecall;
    function Get_Tooltip: WideString; safecall;
    procedure Set_Tooltip(const value: WideString); safecall;
    function Get_Action: WideString; safecall;
    procedure Set_Action(const value: WideString); safecall;
    function Get_ImageIndex: Integer; safecall;
    procedure Set_ImageIndex(value: Integer); safecall;
    function Get_InlineEdit: WordBool; safecall;
    procedure Set_InlineEdit(value: WordBool); safecall;
    procedure FireChange; safecall;
    function Get_IsContact: WordBool; safecall;
    procedure Set_IsContact(value: WordBool); safecall;
    procedure AddGroup(const grp: WideString); safecall;
    procedure RemoveGroup(const grp: WideString); safecall;
    procedure SetCleanGroups; safecall;
    function Get_ImagePrefix: WideString; safecall;
    procedure Set_ImagePrefix(const value: WideString); safecall;
    function Get_IsNative: WordBool; safecall;
    procedure Set_IsNative(value: WordBool); safecall;
    function Get_CanOffline: WordBool; safecall;
    procedure Set_CanOffline(value: WordBool); safecall;
    property JabberID: WideString read Get_JabberID;
    property Subscription: WideString read Get_Subscription;
    property Ask: WideString read Get_Ask;
    property GroupCount: Integer read Get_GroupCount;
    property Nickname: WideString read Get_Nickname write Set_Nickname;
    property ContextMenuID: WideString read Get_ContextMenuID write Set_ContextMenuID;
    property Status: WideString read Get_Status write Set_Status;
    property Tooltip: WideString read Get_Tooltip write Set_Tooltip;
    property Action: WideString read Get_Action write Set_Action;
    property ImageIndex: Integer read Get_ImageIndex write Set_ImageIndex;
    property InlineEdit: WordBool read Get_InlineEdit write Set_InlineEdit;
    property IsContact: WordBool read Get_IsContact write Set_IsContact;
    property ImagePrefix: WideString read Get_ImagePrefix write Set_ImagePrefix;
    property IsNative: WordBool read Get_IsNative write Set_IsNative;
    property CanOffline: WordBool read Get_CanOffline write Set_CanOffline;
  end;

// *********************************************************************//
// DispIntf:  IExodusRosterItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BDD5493D-440F-4376-802B-070B5A4ABFF3}
// *********************************************************************//
  IExodusRosterItemDisp = dispinterface
    ['{BDD5493D-440F-4376-802B-070B5A4ABFF3}']
    property JabberID: WideString readonly dispid 1;
    property Subscription: WideString readonly dispid 2;
    property Ask: WideString readonly dispid 4;
    property GroupCount: Integer readonly dispid 5;
    function Group(index: Integer): WideString; dispid 6;
    function XML: WideString; dispid 7;
    procedure Remove; dispid 8;
    procedure Update; dispid 9;
    property Nickname: WideString dispid 10;
    property ContextMenuID: WideString dispid 201;
    property Status: WideString dispid 202;
    property Tooltip: WideString dispid 203;
    property Action: WideString dispid 204;
    property ImageIndex: Integer dispid 205;
    property InlineEdit: WordBool dispid 206;
    procedure FireChange; dispid 207;
    property IsContact: WordBool dispid 208;
    procedure AddGroup(const grp: WideString); dispid 210;
    procedure RemoveGroup(const grp: WideString); dispid 211;
    procedure SetCleanGroups; dispid 212;
    property ImagePrefix: WideString dispid 209;
    property IsNative: WordBool dispid 213;
    property CanOffline: WordBool dispid 214;
  end;

// *********************************************************************//
// Interface: IExodusPresence
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF4EFE7E-35AC-48B5-ACDB-6753C402F0DB}
// *********************************************************************//
  IExodusPresence = interface(IDispatch)
    ['{FF4EFE7E-35AC-48B5-ACDB-6753C402F0DB}']
    function Get_PresType: WideString; safecall;
    procedure Set_PresType(const value: WideString); safecall;
    function Get_Status: WideString; safecall;
    procedure Set_Status(const value: WideString); safecall;
    function Get_Show: WideString; safecall;
    procedure Set_Show(const value: WideString); safecall;
    function Get_Priority: Integer; safecall;
    procedure Set_Priority(value: Integer); safecall;
    function Get_ErrorString: WideString; safecall;
    procedure Set_ErrorString(const value: WideString); safecall;
    function XML: WideString; safecall;
    function IsSubscription: WordBool; safecall;
    function Get_ToJid: WideString; safecall;
    procedure Set_ToJid(const value: WideString); safecall;
    function Get_FromJid: WideString; safecall;
    procedure Set_FromJid(const value: WideString); safecall;
    property PresType: WideString read Get_PresType write Set_PresType;
    property Status: WideString read Get_Status write Set_Status;
    property Show: WideString read Get_Show write Set_Show;
    property Priority: Integer read Get_Priority write Set_Priority;
    property ErrorString: WideString read Get_ErrorString write Set_ErrorString;
    property ToJid: WideString read Get_ToJid write Set_ToJid;
    property FromJid: WideString read Get_FromJid write Set_FromJid;
  end;

// *********************************************************************//
// DispIntf:  IExodusPresenceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF4EFE7E-35AC-48B5-ACDB-6753C402F0DB}
// *********************************************************************//
  IExodusPresenceDisp = dispinterface
    ['{FF4EFE7E-35AC-48B5-ACDB-6753C402F0DB}']
    property PresType: WideString dispid 1;
    property Status: WideString dispid 2;
    property Show: WideString dispid 3;
    property Priority: Integer dispid 4;
    property ErrorString: WideString dispid 5;
    function XML: WideString; dispid 6;
    function IsSubscription: WordBool; dispid 7;
    property ToJid: WideString dispid 8;
    property FromJid: WideString dispid 9;
  end;

// *********************************************************************//
// Interface: IExodusAuth
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BFE1905C-3620-4C9D-B0C2-27EB456EF73B}
// *********************************************************************//
  IExodusAuth = interface(IDispatch)
    ['{BFE1905C-3620-4C9D-B0C2-27EB456EF73B}']
    procedure StartAuth; safecall;
    procedure CancelAuth; safecall;
    function StartRegistration: WordBool; safecall;
    procedure CancelRegistration; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusAuthDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BFE1905C-3620-4C9D-B0C2-27EB456EF73B}
// *********************************************************************//
  IExodusAuthDisp = dispinterface
    ['{BFE1905C-3620-4C9D-B0C2-27EB456EF73B}']
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
    function Get_Action: WideString; safecall;
    procedure Set_Action(const value: WideString); safecall;
    function Get_KeepEmpty: WordBool; safecall;
    procedure Set_KeepEmpty(value: WordBool); safecall;
    function Get_SortPriority: Integer; safecall;
    procedure Set_SortPriority(value: Integer); safecall;
    function Get_ShowPresence: WordBool; safecall;
    procedure Set_ShowPresence(value: WordBool); safecall;
    function Get_DragTarget: WordBool; safecall;
    procedure Set_DragTarget(value: WordBool); safecall;
    function Get_DragSource: WordBool; safecall;
    procedure Set_DragSource(value: WordBool); safecall;
    function Get_AutoExpand: WordBool; safecall;
    procedure Set_AutoExpand(value: WordBool); safecall;
    function GetText: WideString; safecall;
    procedure AddJid(const JID: WideString); safecall;
    procedure RemoveJid(const JID: WideString); safecall;
    function InGroup(const JID: WideString): WordBool; safecall;
    function IsEmpty: WordBool; safecall;
    function GetGroup(const group_name: WideString): IExodusRosterGroup; safecall;
    procedure AddGroup(const child: IExodusRosterGroup); safecall;
    procedure RemoveGroup(const child: IExodusRosterGroup); safecall;
    function GetRosterItems(Online: WordBool): OleVariant; safecall;
    function Get_NestLevel: Integer; safecall;
    function Get_Online: Integer; safecall;
    function Get_Total: Integer; safecall;
    function Get_FullName: WideString; safecall;
    function Get_Parent: IExodusRosterGroup; safecall;
    function Parts(index: Integer): WideString; safecall;
    procedure FireChange; safecall;
    property Action: WideString read Get_Action write Set_Action;
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
    property Action: WideString dispid 201;
    property KeepEmpty: WordBool dispid 202;
    property SortPriority: Integer dispid 203;
    property ShowPresence: WordBool dispid 204;
    property DragTarget: WordBool dispid 205;
    property DragSource: WordBool dispid 206;
    property AutoExpand: WordBool dispid 207;
    function GetText: WideString; dispid 208;
    procedure AddJid(const JID: WideString); dispid 209;
    procedure RemoveJid(const JID: WideString); dispid 210;
    function InGroup(const JID: WideString): WordBool; dispid 211;
    function IsEmpty: WordBool; dispid 212;
    function GetGroup(const group_name: WideString): IExodusRosterGroup; dispid 213;
    procedure AddGroup(const child: IExodusRosterGroup); dispid 214;
    procedure RemoveGroup(const child: IExodusRosterGroup); dispid 215;
    function GetRosterItems(Online: WordBool): OleVariant; dispid 216;
    property NestLevel: Integer readonly dispid 217;
    property Online: Integer readonly dispid 218;
    property Total: Integer readonly dispid 219;
    property FullName: WideString readonly dispid 220;
    property Parent: IExodusRosterGroup readonly dispid 221;
    function Parts(index: Integer): WideString; dispid 222;
    procedure FireChange; dispid 223;
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
    function AddImageResource(const ID: WideString; const libName: WideString; 
                              const resName: WideString): Integer; safecall;
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
    function AddImageResource(const ID: WideString; const libName: WideString; 
                              const resName: WideString): Integer; dispid 203;
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
    function GetByJid(const JID: WideString; const Node: WideString): IExodusEntity; safecall;
    function Fetch(const JID: WideString; const Node: WideString; items_limit: WordBool): IExodusEntity; safecall;
    function DiscoInfo(const JID: WideString; const Node: WideString; timeout: Integer): IExodusEntity; safecall;
    function DiscoItems(const JID: WideString; const Node: WideString; timeout: Integer): IExodusEntity; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusEntityCacheDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6759BFE4-C72D-42E3-86A3-1F343E848933}
// *********************************************************************//
  IExodusEntityCacheDisp = dispinterface
    ['{6759BFE4-C72D-42E3-86A3-1F343E848933}']
    function GetByJid(const JID: WideString; const Node: WideString): IExodusEntity; dispid 201;
    function Fetch(const JID: WideString; const Node: WideString; items_limit: WordBool): IExodusEntity; dispid 202;
    function DiscoInfo(const JID: WideString; const Node: WideString; timeout: Integer): IExodusEntity; dispid 203;
    function DiscoItems(const JID: WideString; const Node: WideString; timeout: Integer): IExodusEntity; dispid 204;
  end;

// *********************************************************************//
// Interface: IExodusEntity
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}
// *********************************************************************//
  IExodusEntity = interface(IDispatch)
    ['{1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}']
    function HasFeature(const Feature: WideString): WordBool; safecall;
    function HasIdentity(const Category: WideString; const DiscoType: WideString): WordBool; safecall;
    function HasItems: WordBool; safecall;
    function HasInfo: WordBool; safecall;
    function Get_JID: WideString; safecall;
    function Get_Node: WideString; safecall;
    function Get_Category: WideString; safecall;
    function Get_DiscoType: WideString; safecall;
    function Get_Name: WideString; safecall;
    function Get_FeatureCount: Integer; safecall;
    function Get_Feature(index: Integer): WideString; safecall;
    function Get_ItemsCount: Integer; safecall;
    function Get_Item(index: Integer): IExodusEntity; safecall;
    property JID: WideString read Get_JID;
    property Node: WideString read Get_Node;
    property Category: WideString read Get_Category;
    property DiscoType: WideString read Get_DiscoType;
    property Name: WideString read Get_Name;
    property FeatureCount: Integer read Get_FeatureCount;
    property Feature[index: Integer]: WideString read Get_Feature;
    property ItemsCount: Integer read Get_ItemsCount;
    property Item[index: Integer]: IExodusEntity read Get_Item;
  end;

// *********************************************************************//
// DispIntf:  IExodusEntityDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}
// *********************************************************************//
  IExodusEntityDisp = dispinterface
    ['{1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}']
    function HasFeature(const Feature: WideString): WordBool; dispid 201;
    function HasIdentity(const Category: WideString; const DiscoType: WideString): WordBool; dispid 202;
    function HasItems: WordBool; dispid 203;
    function HasInfo: WordBool; dispid 204;
    property JID: WideString readonly dispid 205;
    property Node: WideString readonly dispid 206;
    property Category: WideString readonly dispid 207;
    property DiscoType: WideString readonly dispid 208;
    property Name: WideString readonly dispid 209;
    property FeatureCount: Integer readonly dispid 210;
    property Feature[index: Integer]: WideString readonly dispid 211;
    property ItemsCount: Integer readonly dispid 212;
    property Item[index: Integer]: IExodusEntity readonly dispid 213;
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
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_AllowGrayed: Integer; safecall;
    procedure Set_AllowGrayed(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Checked: Integer; safecall;
    procedure Set_Checked(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_State: Integer; safecall;
    procedure Set_State(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
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
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_AutoComplete: Integer; safecall;
    procedure Set_AutoComplete(value: Integer); safecall;
    function Get_AutoDropDown: Integer; safecall;
    procedure Set_AutoDropDown(value: Integer); safecall;
    function Get_AutoCloseUp: Integer; safecall;
    procedure Set_AutoCloseUp(value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(value: Integer); safecall;
    function Get_Style: Integer; safecall;
    procedure Set_Style(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_CharCase: Integer; safecall;
    procedure Set_CharCase(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_DropDownCount: Integer; safecall;
    procedure Set_DropDownCount(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const value: WideString); safecall;
    function Get_ItemHeight: Integer; safecall;
    procedure Set_ItemHeight(value: Integer); safecall;
    function Get_ItemIndex: Integer; safecall;
    procedure Set_ItemIndex(value: Integer); safecall;
    function Get_MaxLength: Integer; safecall;
    procedure Set_MaxLength(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_Sorted: Integer; safecall;
    procedure Set_Sorted(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Text(const value: WideString); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_Items(index: Integer): WideString; safecall;
    procedure Set_Items(index: Integer; const value: WideString); safecall;
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
    property Items[index: Integer]: WideString read Get_Items write Set_Items;
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
    property Items[index: Integer]: WideString dispid 46;
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
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_AutoSelect: Integer; safecall;
    procedure Set_AutoSelect(value: Integer); safecall;
    function Get_AutoSize: Integer; safecall;
    procedure Set_AutoSize(value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(value: Integer); safecall;
    function Get_CharCase: Integer; safecall;
    procedure Set_CharCase(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_HideSelection: Integer; safecall;
    procedure Set_HideSelection(value: Integer); safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const value: WideString); safecall;
    function Get_MaxLength: Integer; safecall;
    procedure Set_MaxLength(value: Integer); safecall;
    function Get_OEMConvert: Integer; safecall;
    procedure Set_OEMConvert(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PasswordChar: WideString; safecall;
    procedure Set_PasswordChar(const value: WideString); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ReadOnly: Integer; safecall;
    procedure Set_ReadOnly(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Text(const value: WideString); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
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
    procedure Set_Charset(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Pitch: Integer; safecall;
    procedure Set_Pitch(value: Integer); safecall;
    function Get_Size: Integer; safecall;
    procedure Set_Size(value: Integer); safecall;
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
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_AutoSize: Integer; safecall;
    procedure Set_AutoSize(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowAccelChar: Integer; safecall;
    procedure Set_ShowAccelChar(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_Transparent: Integer; safecall;
    procedure Set_Transparent(value: Integer); safecall;
    function Get_Layout: Integer; safecall;
    procedure Set_Layout(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
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
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Style: Integer; safecall;
    procedure Set_Style(value: Integer); safecall;
    function Get_AutoComplete: Integer; safecall;
    procedure Set_AutoComplete(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Columns: Integer; safecall;
    procedure Set_Columns(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_ExtendedSelect: Integer; safecall;
    procedure Set_ExtendedSelect(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const value: WideString); safecall;
    function Get_IntegralHeight: Integer; safecall;
    procedure Set_IntegralHeight(value: Integer); safecall;
    function Get_ItemHeight: Integer; safecall;
    procedure Set_ItemHeight(value: Integer); safecall;
    function Get_Items(index: Integer): WideString; safecall;
    procedure Set_Items(index: Integer; const value: WideString); safecall;
    function Get_MultiSelect: Integer; safecall;
    procedure Set_MultiSelect(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ScrollWidth: Integer; safecall;
    procedure Set_ScrollWidth(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_Sorted: Integer; safecall;
    procedure Set_Sorted(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabWidth: Integer; safecall;
    procedure Set_TabWidth(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
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
    property Items[index: Integer]: WideString read Get_Items write Set_Items;
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
    property Items[index: Integer]: WideString dispid 34;
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
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_AutoCheck: Integer; safecall;
    procedure Set_AutoCheck(value: Integer); safecall;
    function Get_AutoHotkeys: Integer; safecall;
    procedure Set_AutoHotkeys(value: Integer); safecall;
    function Get_AutoLineReduction: Integer; safecall;
    procedure Set_AutoLineReduction(value: Integer); safecall;
    function Get_Break: Integer; safecall;
    procedure Set_Break(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Checked: Integer; safecall;
    procedure Set_Checked(value: Integer); safecall;
    function Get_Default: Integer; safecall;
    procedure Set_Default(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_GroupIndex: Integer; safecall;
    procedure Set_GroupIndex(value: Integer); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_ImageIndex: Integer; safecall;
    procedure Set_ImageIndex(value: Integer); safecall;
    function Get_RadioItem: Integer; safecall;
    procedure Set_RadioItem(value: Integer); safecall;
    function Get_ShortCut: Integer; safecall;
    procedure Set_ShortCut(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
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
    property ImageIndex: Integer read Get_ImageIndex write Set_ImageIndex;
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
    property ImageIndex: Integer dispid 14;
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
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_AutoSize: Integer; safecall;
    procedure Set_AutoSize(value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(value: Integer); safecall;
    function Get_BevelWidth: Integer; safecall;
    procedure Set_BevelWidth(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_BorderWidth: Integer; safecall;
    procedure Set_BorderWidth(value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_UseDockManager: Integer; safecall;
    procedure Set_UseDockManager(value: Integer); safecall;
    function Get_DockSite: Integer; safecall;
    procedure Set_DockSite(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_FullRepaint: Integer; safecall;
    procedure Set_FullRepaint(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_Locked: Integer; safecall;
    procedure Set_Locked(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentBackground: Integer; safecall;
    procedure Set_ParentBackground(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
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
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_ItemsCount: Integer; safecall;
    function Get_Items(index: Integer): IExodusControlMenuItem; safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_AutoHotkeys: Integer; safecall;
    procedure Set_AutoHotkeys(value: Integer); safecall;
    function Get_AutoLineReduction: Integer; safecall;
    procedure Set_AutoLineReduction(value: Integer); safecall;
    function Get_AutoPopup: Integer; safecall;
    procedure Set_AutoPopup(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_OwnerDraw: Integer; safecall;
    procedure Set_OwnerDraw(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_TrackButton: Integer; safecall;
    procedure Set_TrackButton(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property ItemsCount: Integer read Get_ItemsCount;
    property Items[index: Integer]: IExodusControlMenuItem read Get_Items;
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
    property ItemsCount: Integer readonly dispid 3;
    property Items[index: Integer]: IExodusControlMenuItem readonly dispid 4;
    property Alignment: Integer dispid 5;
    property AutoHotkeys: Integer dispid 6;
    property AutoLineReduction: Integer dispid 7;
    property AutoPopup: Integer dispid 8;
    property BiDiMode: Integer dispid 9;
    property HelpContext: Integer dispid 10;
    property OwnerDraw: Integer dispid 11;
    property ParentBiDiMode: Integer dispid 12;
    property TrackButton: Integer dispid 13;
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
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Checked: Integer; safecall;
    procedure Set_Checked(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
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
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(value: Integer); safecall;
    function Get_BevelWidth: Integer; safecall;
    procedure Set_BevelWidth(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(value: Integer); safecall;
    function Get_BorderWidth: Integer; safecall;
    procedure Set_BorderWidth(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_HideSelection: Integer; safecall;
    procedure Set_HideSelection(value: Integer); safecall;
    function Get_HideScrollBars: Integer; safecall;
    procedure Set_HideScrollBars(value: Integer); safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const value: WideString); safecall;
    function Get_LinesCount: Integer; safecall;
    function Get_Lines(index: Integer): WideString; safecall;
    procedure Set_Lines(index: Integer; const value: WideString); safecall;
    function Get_MaxLength: Integer; safecall;
    procedure Set_MaxLength(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PlainText: Integer; safecall;
    procedure Set_PlainText(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ReadOnly: Integer; safecall;
    procedure Set_ReadOnly(value: Integer); safecall;
    function Get_ScrollBars: Integer; safecall;
    procedure Set_ScrollBars(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WantTabs: Integer; safecall;
    procedure Set_WantTabs(value: Integer); safecall;
    function Get_WantReturns: Integer; safecall;
    procedure Set_WantReturns(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
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
    property Lines[index: Integer]: WideString read Get_Lines write Set_Lines;
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
    property Lines[index: Integer]: WideString dispid 34;
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
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_Cancel: Integer; safecall;
    procedure Set_Cancel(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Default: Integer; safecall;
    procedure Set_Default(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ModalResult: Integer; safecall;
    procedure Set_ModalResult(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
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
    procedure ProcessIQ(const handle: WideString; const XML: WideString); safecall;
    procedure TimeoutIQ(const handle: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusIQListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {57DFE494-4509-4972-A93B-6C7E6A9D6A59}
// *********************************************************************//
  IExodusIQListenerDisp = dispinterface
    ['{57DFE494-4509-4972-A93B-6C7E6A9D6A59}']
    procedure ProcessIQ(const handle: WideString; const XML: WideString); dispid 201;
    procedure TimeoutIQ(const handle: WideString); dispid 202;
  end;

// *********************************************************************//
// Interface: IExodusControlBitBtn
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2954B16B-64BA-4441-A476-918CCCCA9B46}
// *********************************************************************//
  IExodusControlBitBtn = interface(IDispatch)
    ['{2954B16B-64BA-4441-A476-918CCCCA9B46}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_Cancel: Integer; safecall;
    procedure Set_Cancel(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Default: Integer; safecall;
    procedure Set_Default(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ModalResult: Integer; safecall;
    procedure Set_ModalResult(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
    function Get_Kind: Integer; safecall;
    procedure Set_Kind(value: Integer); safecall;
    function Get_Layout: Integer; safecall;
    procedure Set_Layout(value: Integer); safecall;
    function Get_Margin: Integer; safecall;
    procedure Set_Margin(value: Integer); safecall;
    function Get_NumGlyphs: Integer; safecall;
    procedure Set_NumGlyphs(value: Integer); safecall;
    function Get_Style: Integer; safecall;
    procedure Set_Style(value: Integer); safecall;
    function Get_Spacing: Integer; safecall;
    procedure Set_Spacing(value: Integer); safecall;
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
    property Kind: Integer read Get_Kind write Set_Kind;
    property Layout: Integer read Get_Layout write Set_Layout;
    property Margin: Integer read Get_Margin write Set_Margin;
    property NumGlyphs: Integer read Get_NumGlyphs write Set_NumGlyphs;
    property Style: Integer read Get_Style write Set_Style;
    property Spacing: Integer read Get_Spacing write Set_Spacing;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlBitBtnDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2954B16B-64BA-4441-A476-918CCCCA9B46}
// *********************************************************************//
  IExodusControlBitBtnDisp = dispinterface
    ['{2954B16B-64BA-4441-A476-918CCCCA9B46}']
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
    property Kind: Integer dispid 31;
    property Layout: Integer dispid 32;
    property Margin: Integer dispid 33;
    property NumGlyphs: Integer dispid 34;
    property Style: Integer dispid 35;
    property Spacing: Integer dispid 36;
  end;

// *********************************************************************//
// Interface: IExodusControlMainMenu
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0C3AE024-51A4-453F-91CB-B0EEBA175AED}
// *********************************************************************//
  IExodusControlMainMenu = interface(IDispatch)
    ['{0C3AE024-51A4-453F-91CB-B0EEBA175AED}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_ItemsCount: Integer; safecall;
    function Get_Items(index: Integer): IExodusControlMenuItem; safecall;
    function Get_AutoHotkeys: Integer; safecall;
    procedure Set_AutoHotkeys(value: Integer); safecall;
    function Get_AutoLineReduction: Integer; safecall;
    procedure Set_AutoLineReduction(value: Integer); safecall;
    function Get_AutoMerge: Integer; safecall;
    procedure Set_AutoMerge(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_OwnerDraw: Integer; safecall;
    procedure Set_OwnerDraw(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property ItemsCount: Integer read Get_ItemsCount;
    property Items[index: Integer]: IExodusControlMenuItem read Get_Items;
    property AutoHotkeys: Integer read Get_AutoHotkeys write Set_AutoHotkeys;
    property AutoLineReduction: Integer read Get_AutoLineReduction write Set_AutoLineReduction;
    property AutoMerge: Integer read Get_AutoMerge write Set_AutoMerge;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property OwnerDraw: Integer read Get_OwnerDraw write Set_OwnerDraw;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlMainMenuDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0C3AE024-51A4-453F-91CB-B0EEBA175AED}
// *********************************************************************//
  IExodusControlMainMenuDisp = dispinterface
    ['{0C3AE024-51A4-453F-91CB-B0EEBA175AED}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property ItemsCount: Integer readonly dispid 3;
    property Items[index: Integer]: IExodusControlMenuItem readonly dispid 4;
    property AutoHotkeys: Integer dispid 5;
    property AutoLineReduction: Integer dispid 6;
    property AutoMerge: Integer dispid 7;
    property BiDiMode: Integer dispid 8;
    property OwnerDraw: Integer dispid 9;
    property ParentBiDiMode: Integer dispid 10;
  end;

// *********************************************************************//
// Interface: IExodusControlMemo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {62B921DE-13F1-4F63-BCA6-30EE3C66D454}
// *********************************************************************//
  IExodusControlMemo = interface(IDispatch)
    ['{62B921DE-13F1-4F63-BCA6-30EE3C66D454}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_HideSelection: Integer; safecall;
    procedure Set_HideSelection(value: Integer); safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const value: WideString); safecall;
    function Get_LinesCount: Integer; safecall;
    function Get_Lines(index: Integer): WideString; safecall;
    procedure Set_Lines(index: Integer; const value: WideString); safecall;
    function Get_MaxLength: Integer; safecall;
    procedure Set_MaxLength(value: Integer); safecall;
    function Get_OEMConvert: Integer; safecall;
    procedure Set_OEMConvert(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ReadOnly: Integer; safecall;
    procedure Set_ReadOnly(value: Integer); safecall;
    function Get_ScrollBars: Integer; safecall;
    procedure Set_ScrollBars(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WantReturns: Integer; safecall;
    procedure Set_WantReturns(value: Integer); safecall;
    function Get_WantTabs: Integer; safecall;
    procedure Set_WantTabs(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
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
    property BevelKind: Integer read Get_BevelKind write Set_BevelKind;
    property BevelOuter: Integer read Get_BevelOuter write Set_BevelOuter;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property BorderStyle: Integer read Get_BorderStyle write Set_BorderStyle;
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
    property LinesCount: Integer read Get_LinesCount;
    property Lines[index: Integer]: WideString read Get_Lines write Set_Lines;
    property MaxLength: Integer read Get_MaxLength write Set_MaxLength;
    property OEMConvert: Integer read Get_OEMConvert write Set_OEMConvert;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ReadOnly: Integer read Get_ReadOnly write Set_ReadOnly;
    property ScrollBars: Integer read Get_ScrollBars write Set_ScrollBars;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WantReturns: Integer read Get_WantReturns write Set_WantReturns;
    property WantTabs: Integer read Get_WantTabs write Set_WantTabs;
    property WordWrap: Integer read Get_WordWrap write Set_WordWrap;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlMemoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {62B921DE-13F1-4F63-BCA6-30EE3C66D454}
// *********************************************************************//
  IExodusControlMemoDisp = dispinterface
    ['{62B921DE-13F1-4F63-BCA6-30EE3C66D454}']
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
    property BevelKind: Integer dispid 16;
    property BevelOuter: Integer dispid 17;
    property BiDiMode: Integer dispid 18;
    property BorderStyle: Integer dispid 19;
    property Color: Integer dispid 20;
    property Ctl3D: Integer dispid 21;
    property DragCursor: Integer dispid 22;
    property DragKind: Integer dispid 23;
    property DragMode: Integer dispid 24;
    property Enabled: Integer dispid 25;
    property Font: IExodusControlFont readonly dispid 26;
    property HideSelection: Integer dispid 27;
    property ImeMode: Integer dispid 28;
    property ImeName: WideString dispid 29;
    property LinesCount: Integer readonly dispid 30;
    property Lines[index: Integer]: WideString dispid 31;
    property MaxLength: Integer dispid 32;
    property OEMConvert: Integer dispid 33;
    property ParentBiDiMode: Integer dispid 34;
    property ParentColor: Integer dispid 35;
    property ParentCtl3D: Integer dispid 36;
    property ParentFont: Integer dispid 37;
    property ParentShowHint: Integer dispid 38;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 39;
    property ReadOnly: Integer dispid 40;
    property ScrollBars: Integer dispid 41;
    property ShowHint: Integer dispid 42;
    property TabOrder: Integer dispid 43;
    property Visible: Integer dispid 44;
    property WantReturns: Integer dispid 45;
    property WantTabs: Integer dispid 46;
    property WordWrap: Integer dispid 47;
  end;

// *********************************************************************//
// Interface: IExodusControlPageControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF41AC90-38C4-46FB-9A45-D7C26ECB2E1C}
// *********************************************************************//
  IExodusControlPageControl = interface(IDispatch)
    ['{AF41AC90-38C4-46FB-9A45-D7C26ECB2E1C}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_DockSite: Integer; safecall;
    procedure Set_DockSite(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_HotTrack: Integer; safecall;
    procedure Set_HotTrack(value: Integer); safecall;
    function Get_MultiLine: Integer; safecall;
    procedure Set_MultiLine(value: Integer); safecall;
    function Get_OwnerDraw: Integer; safecall;
    procedure Set_OwnerDraw(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_RaggedRight: Integer; safecall;
    procedure Set_RaggedRight(value: Integer); safecall;
    function Get_ScrollOpposite: Integer; safecall;
    procedure Set_ScrollOpposite(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_Style: Integer; safecall;
    procedure Set_Style(value: Integer); safecall;
    function Get_TabHeight: Integer; safecall;
    procedure Set_TabHeight(value: Integer); safecall;
    function Get_TabIndex: Integer; safecall;
    procedure Set_TabIndex(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabPosition: Integer; safecall;
    procedure Set_TabPosition(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_TabWidth: Integer; safecall;
    procedure Set_TabWidth(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
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
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property DockSite: Integer read Get_DockSite write Set_DockSite;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property HotTrack: Integer read Get_HotTrack write Set_HotTrack;
    property MultiLine: Integer read Get_MultiLine write Set_MultiLine;
    property OwnerDraw: Integer read Get_OwnerDraw write Set_OwnerDraw;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property RaggedRight: Integer read Get_RaggedRight write Set_RaggedRight;
    property ScrollOpposite: Integer read Get_ScrollOpposite write Set_ScrollOpposite;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property Style: Integer read Get_Style write Set_Style;
    property TabHeight: Integer read Get_TabHeight write Set_TabHeight;
    property TabIndex: Integer read Get_TabIndex write Set_TabIndex;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property TabPosition: Integer read Get_TabPosition write Set_TabPosition;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property TabWidth: Integer read Get_TabWidth write Set_TabWidth;
    property Visible: Integer read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlPageControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF41AC90-38C4-46FB-9A45-D7C26ECB2E1C}
// *********************************************************************//
  IExodusControlPageControlDisp = dispinterface
    ['{AF41AC90-38C4-46FB-9A45-D7C26ECB2E1C}']
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
    property BiDiMode: Integer dispid 13;
    property DockSite: Integer dispid 14;
    property DragCursor: Integer dispid 15;
    property DragKind: Integer dispid 16;
    property DragMode: Integer dispid 17;
    property Enabled: Integer dispid 18;
    property Font: IExodusControlFont readonly dispid 19;
    property HotTrack: Integer dispid 20;
    property MultiLine: Integer dispid 21;
    property OwnerDraw: Integer dispid 22;
    property ParentBiDiMode: Integer dispid 23;
    property ParentFont: Integer dispid 24;
    property ParentShowHint: Integer dispid 25;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 26;
    property RaggedRight: Integer dispid 27;
    property ScrollOpposite: Integer dispid 28;
    property ShowHint: Integer dispid 29;
    property Style: Integer dispid 30;
    property TabHeight: Integer dispid 31;
    property TabIndex: Integer dispid 32;
    property TabOrder: Integer dispid 33;
    property TabPosition: Integer dispid 34;
    property TabStop: Integer dispid 35;
    property TabWidth: Integer dispid 36;
    property Visible: Integer dispid 37;
  end;

// *********************************************************************//
// Interface: IExodusControlSpeedButton
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0706359E-DD10-4D98-862B-7417E5E79DE8}
// *********************************************************************//
  IExodusControlSpeedButton = interface(IDispatch)
    ['{0706359E-DD10-4D98-862B-7417E5E79DE8}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_AllowAllUp: Integer; safecall;
    procedure Set_AllowAllUp(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_GroupIndex: Integer; safecall;
    procedure Set_GroupIndex(value: Integer); safecall;
    function Get_Down: Integer; safecall;
    procedure Set_Down(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Flat: Integer; safecall;
    procedure Set_Flat(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_Layout: Integer; safecall;
    procedure Set_Layout(value: Integer); safecall;
    function Get_Margin: Integer; safecall;
    procedure Set_Margin(value: Integer); safecall;
    function Get_NumGlyphs: Integer; safecall;
    procedure Set_NumGlyphs(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_Spacing: Integer; safecall;
    procedure Set_Spacing(value: Integer); safecall;
    function Get_Transparent: Integer; safecall;
    procedure Set_Transparent(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
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
    property AllowAllUp: Integer read Get_AllowAllUp write Set_AllowAllUp;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property GroupIndex: Integer read Get_GroupIndex write Set_GroupIndex;
    property Down: Integer read Get_Down write Set_Down;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Flat: Integer read Get_Flat write Set_Flat;
    property Font: IExodusControlFont read Get_Font;
    property Layout: Integer read Get_Layout write Set_Layout;
    property Margin: Integer read Get_Margin write Set_Margin;
    property NumGlyphs: Integer read Get_NumGlyphs write Set_NumGlyphs;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property Spacing: Integer read Get_Spacing write Set_Spacing;
    property Transparent: Integer read Get_Transparent write Set_Transparent;
    property Visible: Integer read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlSpeedButtonDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0706359E-DD10-4D98-862B-7417E5E79DE8}
// *********************************************************************//
  IExodusControlSpeedButtonDisp = dispinterface
    ['{0706359E-DD10-4D98-862B-7417E5E79DE8}']
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
    property AllowAllUp: Integer dispid 12;
    property BiDiMode: Integer dispid 13;
    property GroupIndex: Integer dispid 14;
    property Down: Integer dispid 15;
    property Caption: WideString dispid 16;
    property Enabled: Integer dispid 17;
    property Flat: Integer dispid 18;
    property Font: IExodusControlFont readonly dispid 19;
    property Layout: Integer dispid 20;
    property Margin: Integer dispid 21;
    property NumGlyphs: Integer dispid 22;
    property ParentFont: Integer dispid 23;
    property ParentShowHint: Integer dispid 24;
    property ParentBiDiMode: Integer dispid 25;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 26;
    property ShowHint: Integer dispid 27;
    property Spacing: Integer dispid 28;
    property Transparent: Integer dispid 29;
    property Visible: Integer dispid 30;
  end;

// *********************************************************************//
// Interface: IExodusListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {28132170-54E2-4BDD-A37D-BE115E68F044}
// *********************************************************************//
  IExodusListener = interface(IDispatch)
    ['{28132170-54E2-4BDD-A37D-BE115E68F044}']
    procedure ProcessEvent(const event: WideString; const XML: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {28132170-54E2-4BDD-A37D-BE115E68F044}
// *********************************************************************//
  IExodusListenerDisp = dispinterface
    ['{28132170-54E2-4BDD-A37D-BE115E68F044}']
    procedure ProcessEvent(const event: WideString; const XML: WideString); dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusToolbar
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7949D67E-E287-4643-90DA-E6FE7EDEFA97}
// *********************************************************************//
  IExodusToolbar = interface(IDispatch)
    ['{7949D67E-E287-4643-90DA-E6FE7EDEFA97}']
    function Get_Count: Integer; safecall;
    function GetButton(index: Integer): IExodusToolbarButton; safecall;
    function AddButton(const ImageID: WideString): IExodusToolbarButton; safecall;
    function AddControl(const ID: WideString): IExodusToolbarControl; safecall;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IExodusToolbarDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7949D67E-E287-4643-90DA-E6FE7EDEFA97}
// *********************************************************************//
  IExodusToolbarDisp = dispinterface
    ['{7949D67E-E287-4643-90DA-E6FE7EDEFA97}']
    property Count: Integer readonly dispid 201;
    function GetButton(index: Integer): IExodusToolbarButton; dispid 202;
    function AddButton(const ImageID: WideString): IExodusToolbarButton; dispid 203;
    function AddControl(const ID: WideString): IExodusToolbarControl; dispid 204;
  end;

// *********************************************************************//
// Interface: IExodusToolbarButton
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D4749AC4-6EBE-493B-844C-0455FF0A4A77}
// *********************************************************************//
  IExodusToolbarButton = interface(IDispatch)
    ['{D4749AC4-6EBE-493B-844C-0455FF0A4A77}']
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(value: WordBool); safecall;
    function Get_Tooltip: WideString; safecall;
    procedure Set_Tooltip(const value: WideString); safecall;
    function Get_ImageID: WideString; safecall;
    procedure Set_ImageID(const value: WideString); safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(value: WordBool); safecall;
    function Get_MenuListener: IExodusMenuListener; safecall;
    procedure Set_MenuListener(const value: IExodusMenuListener); safecall;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property Tooltip: WideString read Get_Tooltip write Set_Tooltip;
    property ImageID: WideString read Get_ImageID write Set_ImageID;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property MenuListener: IExodusMenuListener read Get_MenuListener write Set_MenuListener;
  end;

// *********************************************************************//
// DispIntf:  IExodusToolbarButtonDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D4749AC4-6EBE-493B-844C-0455FF0A4A77}
// *********************************************************************//
  IExodusToolbarButtonDisp = dispinterface
    ['{D4749AC4-6EBE-493B-844C-0455FF0A4A77}']
    property Visible: WordBool dispid 201;
    property Tooltip: WideString dispid 202;
    property ImageID: WideString dispid 203;
    property Enabled: WordBool dispid 204;
    property MenuListener: IExodusMenuListener dispid 205;
  end;

// *********************************************************************//
// Interface: IExodusControlForm
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2F60EC05-634D-44B2-BECB-059169BA1459}
// *********************************************************************//
  IExodusControlForm = interface(IDispatch)
    ['{2F60EC05-634D-44B2-BECB-059169BA1459}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_AlphaBlend: Integer; safecall;
    procedure Set_AlphaBlend(value: Integer); safecall;
    function Get_AlphaBlendValue: Integer; safecall;
    procedure Set_AlphaBlendValue(value: Integer); safecall;
    function Get_AutoScroll: Integer; safecall;
    procedure Set_AutoScroll(value: Integer); safecall;
    function Get_AutoSize: Integer; safecall;
    procedure Set_AutoSize(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(value: Integer); safecall;
    function Get_BorderWidth: Integer; safecall;
    procedure Set_BorderWidth(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_ClientHeight: Integer; safecall;
    procedure Set_ClientHeight(value: Integer); safecall;
    function Get_ClientWidth: Integer; safecall;
    procedure Set_ClientWidth(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_TransparentColor: Integer; safecall;
    procedure Set_TransparentColor(value: Integer); safecall;
    function Get_TransparentColorValue: Integer; safecall;
    procedure Set_TransparentColorValue(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_UseDockManager: Integer; safecall;
    procedure Set_UseDockManager(value: Integer); safecall;
    function Get_DefaultMonitor: Integer; safecall;
    procedure Set_DefaultMonitor(value: Integer); safecall;
    function Get_DockSite: Integer; safecall;
    procedure Set_DockSite(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_FormStyle: Integer; safecall;
    procedure Set_FormStyle(value: Integer); safecall;
    function Get_HelpFile: WideString; safecall;
    procedure Set_HelpFile(const value: WideString); safecall;
    function Get_KeyPreview: Integer; safecall;
    procedure Set_KeyPreview(value: Integer); safecall;
    function Get_Menu: IExodusControlMainMenu; safecall;
    function Get_OldCreateOrder: Integer; safecall;
    procedure Set_OldCreateOrder(value: Integer); safecall;
    function Get_ObjectMenuItemCount: Integer; safecall;
    function Get_ObjectMenuItem(index: Integer): IExodusControlMenuItem; safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_PixelsPerInch: Integer; safecall;
    procedure Set_PixelsPerInch(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(value: Integer); safecall;
    function Get_PrintScale: Integer; safecall;
    procedure Set_PrintScale(value: Integer); safecall;
    function Get_Scaled: Integer; safecall;
    procedure Set_Scaled(value: Integer); safecall;
    function Get_ScreenSnap: Integer; safecall;
    procedure Set_ScreenSnap(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_SnapBuffer: Integer; safecall;
    procedure Set_SnapBuffer(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WindowState: Integer; safecall;
    procedure Set_WindowState(value: Integer); safecall;
    function Get_WindowMenuCount: Integer; safecall;
    function Get_WindowMenu(index: Integer): IExodusControlMenuItem; safecall;
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
    property AlphaBlend: Integer read Get_AlphaBlend write Set_AlphaBlend;
    property AlphaBlendValue: Integer read Get_AlphaBlendValue write Set_AlphaBlendValue;
    property AutoScroll: Integer read Get_AutoScroll write Set_AutoScroll;
    property AutoSize: Integer read Get_AutoSize write Set_AutoSize;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property BorderStyle: Integer read Get_BorderStyle write Set_BorderStyle;
    property BorderWidth: Integer read Get_BorderWidth write Set_BorderWidth;
    property Caption: WideString read Get_Caption write Set_Caption;
    property ClientHeight: Integer read Get_ClientHeight write Set_ClientHeight;
    property ClientWidth: Integer read Get_ClientWidth write Set_ClientWidth;
    property Color: Integer read Get_Color write Set_Color;
    property TransparentColor: Integer read Get_TransparentColor write Set_TransparentColor;
    property TransparentColorValue: Integer read Get_TransparentColorValue write Set_TransparentColorValue;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property UseDockManager: Integer read Get_UseDockManager write Set_UseDockManager;
    property DefaultMonitor: Integer read Get_DefaultMonitor write Set_DefaultMonitor;
    property DockSite: Integer read Get_DockSite write Set_DockSite;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property Font: IExodusControlFont read Get_Font;
    property FormStyle: Integer read Get_FormStyle write Set_FormStyle;
    property HelpFile: WideString read Get_HelpFile write Set_HelpFile;
    property KeyPreview: Integer read Get_KeyPreview write Set_KeyPreview;
    property Menu: IExodusControlMainMenu read Get_Menu;
    property OldCreateOrder: Integer read Get_OldCreateOrder write Set_OldCreateOrder;
    property ObjectMenuItemCount: Integer read Get_ObjectMenuItemCount;
    property ObjectMenuItem[index: Integer]: IExodusControlMenuItem read Get_ObjectMenuItem;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property PixelsPerInch: Integer read Get_PixelsPerInch write Set_PixelsPerInch;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property Position: Integer read Get_Position write Set_Position;
    property PrintScale: Integer read Get_PrintScale write Set_PrintScale;
    property Scaled: Integer read Get_Scaled write Set_Scaled;
    property ScreenSnap: Integer read Get_ScreenSnap write Set_ScreenSnap;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property SnapBuffer: Integer read Get_SnapBuffer write Set_SnapBuffer;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WindowState: Integer read Get_WindowState write Set_WindowState;
    property WindowMenuCount: Integer read Get_WindowMenuCount;
    property WindowMenu[index: Integer]: IExodusControlMenuItem read Get_WindowMenu;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlFormDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2F60EC05-634D-44B2-BECB-059169BA1459}
// *********************************************************************//
  IExodusControlFormDisp = dispinterface
    ['{2F60EC05-634D-44B2-BECB-059169BA1459}']
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
    property AlphaBlend: Integer dispid 13;
    property AlphaBlendValue: Integer dispid 14;
    property AutoScroll: Integer dispid 15;
    property AutoSize: Integer dispid 16;
    property BiDiMode: Integer dispid 17;
    property BorderStyle: Integer dispid 18;
    property BorderWidth: Integer dispid 19;
    property Caption: WideString dispid 20;
    property ClientHeight: Integer dispid 21;
    property ClientWidth: Integer dispid 22;
    property Color: Integer dispid 23;
    property TransparentColor: Integer dispid 24;
    property TransparentColorValue: Integer dispid 25;
    property Ctl3D: Integer dispid 26;
    property UseDockManager: Integer dispid 27;
    property DefaultMonitor: Integer dispid 28;
    property DockSite: Integer dispid 29;
    property DragKind: Integer dispid 30;
    property DragMode: Integer dispid 31;
    property Enabled: Integer dispid 32;
    property ParentFont: Integer dispid 33;
    property Font: IExodusControlFont readonly dispid 34;
    property FormStyle: Integer dispid 35;
    property HelpFile: WideString dispid 36;
    property KeyPreview: Integer dispid 37;
    property Menu: IExodusControlMainMenu readonly dispid 38;
    property OldCreateOrder: Integer dispid 39;
    property ObjectMenuItemCount: Integer readonly dispid 40;
    property ObjectMenuItem[index: Integer]: IExodusControlMenuItem readonly dispid 41;
    property ParentBiDiMode: Integer dispid 42;
    property PixelsPerInch: Integer dispid 43;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 44;
    property Position: Integer dispid 45;
    property PrintScale: Integer dispid 46;
    property Scaled: Integer dispid 47;
    property ScreenSnap: Integer dispid 48;
    property ShowHint: Integer dispid 49;
    property SnapBuffer: Integer dispid 50;
    property Visible: Integer dispid 51;
    property WindowState: Integer dispid 52;
    property WindowMenuCount: Integer readonly dispid 53;
    property WindowMenu[index: Integer]: IExodusControlMenuItem readonly dispid 54;
  end;

// *********************************************************************//
// Interface: IExodusLogger
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {35542007-5701-4190-AB28-D25EB186CC19}
// *********************************************************************//
  IExodusLogger = interface(IDispatch)
    ['{35542007-5701-4190-AB28-D25EB186CC19}']
    procedure LogMessage(const msg: IExodusLogMsg); safecall;
    procedure Show(const JID: WideString); safecall;
    procedure Clear(const JID: WideString); safecall;
    procedure Purge; safecall;
    procedure GetDays(const JID: WideString; month: Integer; year: Integer; 
                      const listener: IExodusLogListener); safecall;
    procedure GetMessages(const JID: WideString; chunkSize: Integer; day: Integer; month: Integer; 
                          year: Integer; Cancel: WordBool; const listener: IExodusLogListener); safecall;
    function Get_IsDateEnabled: WordBool; safecall;
    property IsDateEnabled: WordBool read Get_IsDateEnabled;
  end;

// *********************************************************************//
// DispIntf:  IExodusLoggerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {35542007-5701-4190-AB28-D25EB186CC19}
// *********************************************************************//
  IExodusLoggerDisp = dispinterface
    ['{35542007-5701-4190-AB28-D25EB186CC19}']
    procedure LogMessage(const msg: IExodusLogMsg); dispid 201;
    procedure Show(const JID: WideString); dispid 202;
    procedure Clear(const JID: WideString); dispid 203;
    procedure Purge; dispid 204;
    procedure GetDays(const JID: WideString; month: Integer; year: Integer; 
                      const listener: IExodusLogListener); dispid 205;
    procedure GetMessages(const JID: WideString; chunkSize: Integer; day: Integer; month: Integer; 
                          year: Integer; Cancel: WordBool; const listener: IExodusLogListener); dispid 206;
    property IsDateEnabled: WordBool readonly dispid 207;
  end;

// *********************************************************************//
// Interface: IExodusLogMsg
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2E945876-C2E5-4A24-98B4-0E38BD65D431}
// *********************************************************************//
  IExodusLogMsg = interface(IDispatch)
    ['{2E945876-C2E5-4A24-98B4-0E38BD65D431}']
    function Get_ToJid: WideString; safecall;
    function Get_FromJid: WideString; safecall;
    function Get_MsgType: WideString; safecall;
    function Get_ID: WideString; safecall;
    function Get_Nick: WideString; safecall;
    function Get_Body: WideString; safecall;
    function Get_Thread: WideString; safecall;
    function Get_Subject: WideString; safecall;
    function Get_Timestamp: WideString; safecall;
    function Get_Direction: WideString; safecall;
    function Get_XML: WideString; safecall;
    property ToJid: WideString read Get_ToJid;
    property FromJid: WideString read Get_FromJid;
    property MsgType: WideString read Get_MsgType;
    property ID: WideString read Get_ID;
    property Nick: WideString read Get_Nick;
    property Body: WideString read Get_Body;
    property Thread: WideString read Get_Thread;
    property Subject: WideString read Get_Subject;
    property Timestamp: WideString read Get_Timestamp;
    property Direction: WideString read Get_Direction;
    property XML: WideString read Get_XML;
  end;

// *********************************************************************//
// DispIntf:  IExodusLogMsgDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2E945876-C2E5-4A24-98B4-0E38BD65D431}
// *********************************************************************//
  IExodusLogMsgDisp = dispinterface
    ['{2E945876-C2E5-4A24-98B4-0E38BD65D431}']
    property ToJid: WideString readonly dispid 201;
    property FromJid: WideString readonly dispid 202;
    property MsgType: WideString readonly dispid 203;
    property ID: WideString readonly dispid 204;
    property Nick: WideString readonly dispid 205;
    property Body: WideString readonly dispid 206;
    property Thread: WideString readonly dispid 207;
    property Subject: WideString readonly dispid 208;
    property Timestamp: WideString readonly dispid 209;
    property Direction: WideString readonly dispid 210;
    property XML: WideString readonly dispid 211;
  end;

// *********************************************************************//
// Interface: IExodusLogListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6D58A577-6BC4-4B1C-B5F8-759B94136B0A}
// *********************************************************************//
  IExodusLogListener = interface(IDispatch)
    ['{6D58A577-6BC4-4B1C-B5F8-759B94136B0A}']
    procedure ProcessMessages(Count: Integer; messages: PSafeArray); safecall;
    procedure EndMessages(day: Integer; month: Integer; year: Integer); safecall;
    procedure Error(day: Integer; month: Integer; year: Integer); safecall;
    procedure ProcessDates(Count: Integer; dates: PSafeArray); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusLogListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6D58A577-6BC4-4B1C-B5F8-759B94136B0A}
// *********************************************************************//
  IExodusLogListenerDisp = dispinterface
    ['{6D58A577-6BC4-4B1C-B5F8-759B94136B0A}']
    procedure ProcessMessages(Count: Integer; messages: {??PSafeArray}OleVariant); dispid 201;
    procedure EndMessages(day: Integer; month: Integer; year: Integer); dispid 202;
    procedure Error(day: Integer; month: Integer; year: Integer); dispid 203;
    procedure ProcessDates(Count: Integer; dates: {??PSafeArray}OleVariant); dispid 204;
  end;

// *********************************************************************//
// Interface: IExodusPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}
// *********************************************************************//
  IExodusPlugin = interface(IDispatch)
    ['{6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}']
    procedure Startup(const exodusController: IExodusController); safecall;
    procedure Shutdown; safecall;
    procedure Process(const xpath: WideString; const event: WideString; const XML: WideString); safecall;
    procedure NewChat(const JID: WideString; const chat: IExodusChat); safecall;
    procedure NewRoom(const JID: WideString; const room: IExodusChat); safecall;
    function NewIM(const JID: WideString; var Body: WideString; var Subject: WideString; 
                   const xTags: WideString): WideString; safecall;
    procedure Configure; safecall;
    procedure NewOutgoingIM(const JID: WideString; const instantMsg: IExodusChat); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}
// *********************************************************************//
  IExodusPluginDisp = dispinterface
    ['{6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}']
    procedure Startup(const exodusController: IExodusController); dispid 1;
    procedure Shutdown; dispid 2;
    procedure Process(const xpath: WideString; const event: WideString; const XML: WideString); dispid 3;
    procedure NewChat(const JID: WideString; const chat: IExodusChat); dispid 4;
    procedure NewRoom(const JID: WideString; const room: IExodusChat); dispid 5;
    function NewIM(const JID: WideString; var Body: WideString; var Subject: WideString; 
                   const xTags: WideString): WideString; dispid 8;
    procedure Configure; dispid 12;
    procedure NewOutgoingIM(const JID: WideString; const instantMsg: IExodusChat); dispid 203;
  end;

// *********************************************************************//
// Interface: IExodusBookmarkManager
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E40D85F3-9E0D-4368-89D0-C4298315CD30}
// *********************************************************************//
  IExodusBookmarkManager = interface(IDispatch)
    ['{E40D85F3-9E0D-4368-89D0-C4298315CD30}']
    procedure AddBookmark(const JabberID: WideString; const bmName: WideString; 
                          const Nickname: WideString; AutoJoin: WordBool; 
                          UseRegisteredNick: WordBool); safecall;
    procedure RemoveBookmark(const JabberID: WideString); safecall;
    function FindBookmark(const JabberID: WideString): WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusBookmarkManagerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E40D85F3-9E0D-4368-89D0-C4298315CD30}
// *********************************************************************//
  IExodusBookmarkManagerDisp = dispinterface
    ['{E40D85F3-9E0D-4368-89D0-C4298315CD30}']
    procedure AddBookmark(const JabberID: WideString; const bmName: WideString; 
                          const Nickname: WideString; AutoJoin: WordBool; 
                          UseRegisteredNick: WordBool); dispid 201;
    procedure RemoveBookmark(const JabberID: WideString); dispid 202;
    function FindBookmark(const JabberID: WideString): WideString; dispid 203;
  end;

// *********************************************************************//
// Interface: IExodusToolbarControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B35EACB5-C3DC-473E-8C4C-EFA175DF4CAB}
// *********************************************************************//
  IExodusToolbarControl = interface(IDispatch)
    ['{B35EACB5-C3DC-473E-8C4C-EFA175DF4CAB}']
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(value: WordBool); safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(value: WordBool); safecall;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
  end;

// *********************************************************************//
// DispIntf:  IExodusToolbarControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B35EACB5-C3DC-473E-8C4C-EFA175DF4CAB}
// *********************************************************************//
  IExodusToolbarControlDisp = dispinterface
    ['{B35EACB5-C3DC-473E-8C4C-EFA175DF4CAB}']
    property Visible: WordBool dispid 201;
    property Enabled: WordBool dispid 202;
  end;

// *********************************************************************//
// The Class CoexodusController provides a Create and CreateRemote method to          
// create instances of the default interface IExodusController exposed by              
// the CoClass exodusController. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoexodusController = class
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

// *********************************************************************//
// The Class CoExodusToolbar provides a Create and CreateRemote method to          
// create instances of the default interface IExodusToolbar exposed by              
// the CoClass ExodusToolbar. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusToolbar = class
    class function Create: IExodusToolbar;
    class function CreateRemote(const MachineName: string): IExodusToolbar;
  end;

// *********************************************************************//
// The Class CoExodusToolbarButton provides a Create and CreateRemote method to          
// create instances of the default interface IExodusToolbarButton exposed by              
// the CoClass ExodusToolbarButton. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusToolbarButton = class
    class function Create: IExodusToolbarButton;
    class function CreateRemote(const MachineName: string): IExodusToolbarButton;
  end;

// *********************************************************************//
// The Class CoExodusLogMsg provides a Create and CreateRemote method to          
// create instances of the default interface IExodusLogMsg exposed by              
// the CoClass ExodusLogMsg. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusLogMsg = class
    class function Create: IExodusLogMsg;
    class function CreateRemote(const MachineName: string): IExodusLogMsg;
  end;

// *********************************************************************//
// The Class CoExodusLogListener provides a Create and CreateRemote method to          
// create instances of the default interface IExodusLogListener exposed by              
// the CoClass ExodusLogListener. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusLogListener = class
    class function Create: IExodusLogListener;
    class function CreateRemote(const MachineName: string): IExodusLogListener;
  end;

// *********************************************************************//
// The Class CoExodusBookmarkManager provides a Create and CreateRemote method to          
// create instances of the default interface IExodusBookmarkManager exposed by              
// the CoClass ExodusBookmarkManager. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusBookmarkManager = class
    class function Create: IExodusBookmarkManager;
    class function CreateRemote(const MachineName: string): IExodusBookmarkManager;
  end;

// *********************************************************************//
// The Class CoExodusToolbarControl provides a Create and CreateRemote method to          
// create instances of the default interface IExodusToolbarControl exposed by              
// the CoClass ExodusToolbarControl. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusToolbarControl = class
    class function Create: IExodusToolbarControl;
    class function CreateRemote(const MachineName: string): IExodusToolbarControl;
  end;

implementation

uses ComObj;

class function CoexodusController.Create: IExodusController;
begin
  Result := CreateComObject(CLASS_exodusController) as IExodusController;
end;

class function CoexodusController.CreateRemote(const MachineName: string): IExodusController;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_exodusController) as IExodusController;
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

class function CoExodusToolbar.Create: IExodusToolbar;
begin
  Result := CreateComObject(CLASS_ExodusToolbar) as IExodusToolbar;
end;

class function CoExodusToolbar.CreateRemote(const MachineName: string): IExodusToolbar;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusToolbar) as IExodusToolbar;
end;

class function CoExodusToolbarButton.Create: IExodusToolbarButton;
begin
  Result := CreateComObject(CLASS_ExodusToolbarButton) as IExodusToolbarButton;
end;

class function CoExodusToolbarButton.CreateRemote(const MachineName: string): IExodusToolbarButton;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusToolbarButton) as IExodusToolbarButton;
end;

class function CoExodusLogMsg.Create: IExodusLogMsg;
begin
  Result := CreateComObject(CLASS_ExodusLogMsg) as IExodusLogMsg;
end;

class function CoExodusLogMsg.CreateRemote(const MachineName: string): IExodusLogMsg;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusLogMsg) as IExodusLogMsg;
end;

class function CoExodusLogListener.Create: IExodusLogListener;
begin
  Result := CreateComObject(CLASS_ExodusLogListener) as IExodusLogListener;
end;

class function CoExodusLogListener.CreateRemote(const MachineName: string): IExodusLogListener;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusLogListener) as IExodusLogListener;
end;

class function CoExodusBookmarkManager.Create: IExodusBookmarkManager;
begin
  Result := CreateComObject(CLASS_ExodusBookmarkManager) as IExodusBookmarkManager;
end;

class function CoExodusBookmarkManager.CreateRemote(const MachineName: string): IExodusBookmarkManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusBookmarkManager) as IExodusBookmarkManager;
end;

class function CoExodusToolbarControl.Create: IExodusToolbarControl;
begin
  Result := CreateComObject(CLASS_ExodusToolbarControl) as IExodusToolbarControl;
end;

class function CoExodusToolbarControl.CreateRemote(const MachineName: string): IExodusToolbarControl;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusToolbarControl) as IExodusToolbarControl;
end;

end.
