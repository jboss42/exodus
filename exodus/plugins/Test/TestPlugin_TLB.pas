unit TestPlugin_TLB;

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
// File generated on 8/24/2006 1:42:15 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: TestPlugin.tlb (1)
// LIBID: {78FCE930-6D97-4E80-A634-59897D6E8BB2}
// LCID: 0
// Helpfile: 
// HelpString: TestPlugin Library
// DepndLst: 
//   (1) v1.0 Exodus, (C:\Projects\Devel\Clients\Hermes\bin\Exodus.exe)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Error creating palette bitmap of (TTesterPlugin) : No Server registered for this CoClass
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
  TestPluginMajorVersion = 1;
  TestPluginMinorVersion = 0;

  LIBID_TestPlugin: TGUID = '{78FCE930-6D97-4E80-A634-59897D6E8BB2}';

  IID_ITesterPlugin: TGUID = '{AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}';
  CLASS_TesterPlugin: TGUID = '{DE6D1148-AC93-412F-AF4B-F26C24136D2C}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ITesterPlugin = interface;
  ITesterPluginDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  TesterPlugin = IExodusPlugin;


// *********************************************************************//
// Interface: ITesterPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}
// *********************************************************************//
  ITesterPlugin = interface(IExodusPlugin)
    ['{AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}']
  end;

// *********************************************************************//
// DispIntf:  ITesterPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}
// *********************************************************************//
  ITesterPluginDisp = dispinterface
    ['{AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}']
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
// The Class CoTesterPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass TesterPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTesterPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTesterPlugin
// Help String      : TesterPlugin Object
// Default Interface: IExodusPlugin
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTesterPluginProperties= class;
{$ENDIF}
  TTesterPlugin = class(TOleServer)
  private
    FIntf: IExodusPlugin;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TTesterPluginProperties;
    function GetServerProperties: TTesterPluginProperties;
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
    property Server: TTesterPluginProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTesterPlugin
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTesterPluginProperties = class(TPersistent)
  private
    FServer:    TTesterPlugin;
    function    GetDefaultInterface: IExodusPlugin;
    constructor Create(AServer: TTesterPlugin);
  protected
  public
    property DefaultInterface: IExodusPlugin read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoTesterPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_TesterPlugin) as IExodusPlugin;
end;

class function CoTesterPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TesterPlugin) as IExodusPlugin;
end;

procedure TTesterPlugin.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{DE6D1148-AC93-412F-AF4B-F26C24136D2C}';
    IntfIID:   '{6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTesterPlugin.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IExodusPlugin;
  end;
end;

procedure TTesterPlugin.ConnectTo(svrIntf: IExodusPlugin);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTesterPlugin.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTesterPlugin.GetDefaultInterface: IExodusPlugin;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTesterPlugin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTesterPluginProperties.Create(Self);
{$ENDIF}
end;

destructor TTesterPlugin.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTesterPlugin.GetServerProperties: TTesterPluginProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TTesterPlugin.Startup(const exodusController: IExodusController);
begin
  DefaultInterface.Startup(exodusController);
end;

procedure TTesterPlugin.Shutdown;
begin
  DefaultInterface.Shutdown;
end;

procedure TTesterPlugin.Process(const xpath: WideString; const event: WideString; 
                                const XML: WideString);
begin
  DefaultInterface.Process(xpath, event, XML);
end;

procedure TTesterPlugin.NewChat(const JID: WideString; const chat: IExodusChat);
begin
  DefaultInterface.NewChat(JID, chat);
end;

procedure TTesterPlugin.NewRoom(const JID: WideString; const room: IExodusChat);
begin
  DefaultInterface.NewRoom(JID, room);
end;

function TTesterPlugin.NewIM(const JID: WideString; var Body: WideString; var Subject: WideString; 
                             const xTags: WideString): WideString;
begin
  Result := DefaultInterface.NewIM(JID, Body, Subject, xTags);
end;

procedure TTesterPlugin.Configure;
begin
  DefaultInterface.Configure;
end;

procedure TTesterPlugin.NewOutgoingIM(const JID: WideString; const instantMsg: IExodusChat);
begin
  DefaultInterface.NewOutgoingIM(JID, instantMsg);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTesterPluginProperties.Create(AServer: TTesterPlugin);
begin
  inherited Create;
  FServer := AServer;
end;

function TTesterPluginProperties.GetDefaultInterface: IExodusPlugin;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TTesterPlugin]);
end;

end.
