unit ExAspell_TLB;

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
// File generated on 8/24/2006 1:41:57 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: ExAspell.tlb (1)
// LIBID: {FCC22055-8B46-40DE-A8D1-59666F9B8D06}
// LCID: 0
// Helpfile: 
// HelpString: ExAspell Library
// DepndLst: 
//   (1) v1.0 Exodus, (C:\Projects\Devel\Clients\Hermes\bin\Exodus.exe)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Error creating palette bitmap of (TSpellPlugin) : Server C:\Projects\exodus\exodus\plugins\ExAspell.dll contains no icons
//   Error creating palette bitmap of (TChatSpeller) : Server C:\Projects\exodus\exodus\plugins\ExAspell.dll contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Exodus_TLB, Graphics, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ExAspellMajorVersion = 1;
  ExAspellMinorVersion = 0;

  LIBID_ExAspell: TGUID = '{FCC22055-8B46-40DE-A8D1-59666F9B8D06}';

  CLASS_SpellPlugin: TGUID = '{0C80F5C7-86D3-4372-9158-2C5E463225D4}';
  CLASS_ChatSpeller: TGUID = '{28855332-70A4-465E-BF77-D4C141837D62}';
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
// OLE Server Proxy class declaration
// Server Object    : TSpellPlugin
// Help String      : 
// Default Interface: IExodusPlugin
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSpellPluginProperties= class;
{$ENDIF}
  TSpellPlugin = class(TOleServer)
  private
    FIntf: IExodusPlugin;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TSpellPluginProperties;
    function GetServerProperties: TSpellPluginProperties;
{$ENDIF}
    function GetDefaultInterface: IExodusPlugin;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IExodusPlugin);
    procedure Disconnect; override;
    procedure Startup(const exodusController: IExodusController);
    procedure Shutdown;
    procedure Process(const xpath: WideString; const event: WideString; const XML: WideString);
    procedure NewChat(const JID: WideString; const chat: IExodusChat);
    procedure NewRoom(const JID: WideString; const room: IExodusChat);
    function NewIM(const JID: WideString; var Body: WideString; var Subject: WideString; 
                   const xTags: WideString): WideString;
    procedure Configure;
    procedure NewOutgoingIM(const JID: WideString; const instantMsg: IExodusChat);
    property DefaultInterface: IExodusPlugin read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSpellPluginProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSpellPlugin
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSpellPluginProperties = class(TPersistent)
  private
    FServer:    TSpellPlugin;
    function    GetDefaultInterface: IExodusPlugin;
    constructor Create(AServer: TSpellPlugin);
  protected
  public
    property DefaultInterface: IExodusPlugin read GetDefaultInterface;
  published
  end;
{$ENDIF}


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


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TChatSpeller
// Help String      : 
// Default Interface: IExodusChatPlugin
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TChatSpellerProperties= class;
{$ENDIF}
  TChatSpeller = class(TOleServer)
  private
    FIntf: IExodusChatPlugin;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TChatSpellerProperties;
    function GetServerProperties: TChatSpellerProperties;
{$ENDIF}
    function GetDefaultInterface: IExodusChatPlugin;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IExodusChatPlugin);
    procedure Disconnect; override;
    function OnBeforeMessage(var Body: WideString): WordBool;
    function OnAfterMessage(var Body: WideString): WideString;
    procedure OnClose;
    procedure OnNewWindow(hwnd: Integer);
    function OnBeforeRecvMessage(const Body: WideString; const XML: WideString): WordBool;
    procedure OnAfterRecvMessage(var Body: WideString);
    function OnKeyUp(key: Integer; shiftState: Integer): WordBool;
    function OnKeyDown(key: Integer; shiftState: Integer): WordBool;
    property DefaultInterface: IExodusChatPlugin read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TChatSpellerProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TChatSpeller
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TChatSpellerProperties = class(TPersistent)
  private
    FServer:    TChatSpeller;
    function    GetDefaultInterface: IExodusChatPlugin;
    constructor Create(AServer: TChatSpeller);
  protected
  public
    property DefaultInterface: IExodusChatPlugin read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

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

procedure TSpellPlugin.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{0C80F5C7-86D3-4372-9158-2C5E463225D4}';
    IntfIID:   '{6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSpellPlugin.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IExodusPlugin;
  end;
end;

procedure TSpellPlugin.ConnectTo(svrIntf: IExodusPlugin);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSpellPlugin.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSpellPlugin.GetDefaultInterface: IExodusPlugin;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TSpellPlugin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSpellPluginProperties.Create(Self);
{$ENDIF}
end;

destructor TSpellPlugin.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSpellPlugin.GetServerProperties: TSpellPluginProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TSpellPlugin.Startup(const exodusController: IExodusController);
begin
  DefaultInterface.Startup(exodusController);
end;

procedure TSpellPlugin.Shutdown;
begin
  DefaultInterface.Shutdown;
end;

procedure TSpellPlugin.Process(const xpath: WideString; const event: WideString; 
                               const XML: WideString);
begin
  DefaultInterface.Process(xpath, event, XML);
end;

procedure TSpellPlugin.NewChat(const JID: WideString; const chat: IExodusChat);
begin
  DefaultInterface.NewChat(JID, chat);
end;

procedure TSpellPlugin.NewRoom(const JID: WideString; const room: IExodusChat);
begin
  DefaultInterface.NewRoom(JID, room);
end;

function TSpellPlugin.NewIM(const JID: WideString; var Body: WideString; var Subject: WideString; 
                            const xTags: WideString): WideString;
begin
  Result := DefaultInterface.NewIM(JID, Body, Subject, xTags);
end;

procedure TSpellPlugin.Configure;
begin
  DefaultInterface.Configure;
end;

procedure TSpellPlugin.NewOutgoingIM(const JID: WideString; const instantMsg: IExodusChat);
begin
  DefaultInterface.NewOutgoingIM(JID, instantMsg);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSpellPluginProperties.Create(AServer: TSpellPlugin);
begin
  inherited Create;
  FServer := AServer;
end;

function TSpellPluginProperties.GetDefaultInterface: IExodusPlugin;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoChatSpeller.Create: IExodusChatPlugin;
begin
  Result := CreateComObject(CLASS_ChatSpeller) as IExodusChatPlugin;
end;

class function CoChatSpeller.CreateRemote(const MachineName: string): IExodusChatPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ChatSpeller) as IExodusChatPlugin;
end;

procedure TChatSpeller.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{28855332-70A4-465E-BF77-D4C141837D62}';
    IntfIID:   '{E28E487A-7258-4B32-AD1C-F23A808F0460}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TChatSpeller.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IExodusChatPlugin;
  end;
end;

procedure TChatSpeller.ConnectTo(svrIntf: IExodusChatPlugin);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TChatSpeller.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TChatSpeller.GetDefaultInterface: IExodusChatPlugin;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TChatSpeller.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TChatSpellerProperties.Create(Self);
{$ENDIF}
end;

destructor TChatSpeller.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TChatSpeller.GetServerProperties: TChatSpellerProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TChatSpeller.OnBeforeMessage(var Body: WideString): WordBool;
begin
  Result := DefaultInterface.OnBeforeMessage(Body);
end;

function TChatSpeller.OnAfterMessage(var Body: WideString): WideString;
begin
  Result := DefaultInterface.OnAfterMessage(Body);
end;

procedure TChatSpeller.OnClose;
begin
  DefaultInterface.OnClose;
end;

procedure TChatSpeller.OnNewWindow(hwnd: Integer);
begin
  DefaultInterface.OnNewWindow(hwnd);
end;

function TChatSpeller.OnBeforeRecvMessage(const Body: WideString; const XML: WideString): WordBool;
begin
  Result := DefaultInterface.OnBeforeRecvMessage(Body, XML);
end;

procedure TChatSpeller.OnAfterRecvMessage(var Body: WideString);
begin
  DefaultInterface.OnAfterRecvMessage(Body);
end;

function TChatSpeller.OnKeyUp(key: Integer; shiftState: Integer): WordBool;
begin
  Result := DefaultInterface.OnKeyUp(key, shiftState);
end;

function TChatSpeller.OnKeyDown(key: Integer; shiftState: Integer): WordBool;
begin
  Result := DefaultInterface.OnKeyDown(key, shiftState);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TChatSpellerProperties.Create(AServer: TChatSpeller);
begin
  inherited Create;
  FServer := AServer;
end;

function TChatSpellerProperties.GetDefaultInterface: IExodusChatPlugin;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TSpellPlugin, TChatSpeller]);
end;

end.
