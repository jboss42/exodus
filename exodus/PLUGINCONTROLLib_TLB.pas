unit PLUGINCONTROLLib_TLB;

{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  PLUGINCONTROLLibMajorVersion = 1;
  PLUGINCONTROLLibMinorVersion = 0;

  LIBID_PLUGINCONTROLLib: TGUID = '{D11520D5-FB89-4274-903C-33C011EA81F3}';

  IID_IMyControl: TGUID = '{F476FEEF-2622-4BB2-BA35-1DDE736F469D}';
  CLASS_MyControl: TGUID = '{524459CD-5F81-4825-96E8-2EA2573B9A14}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IMyControl = interface;
  IMyControlDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  MyControl = IMyControl;

// *********************************************************************//
// Interface: IMyControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F476FEEF-2622-4BB2-BA35-1DDE736F469D}
// *********************************************************************//
  IMyControl = interface(IDispatch)
    ['{F476FEEF-2622-4BB2-BA35-1DDE736F469D}']
    procedure Connect; safecall;
    procedure Disconnect; safecall;
  end;

// *********************************************************************//
// DispIntf:  IMyControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F476FEEF-2622-4BB2-BA35-1DDE736F469D}
// *********************************************************************//
  IMyControlDisp = dispinterface
    ['{F476FEEF-2622-4BB2-BA35-1DDE736F469D}']
    procedure Connect; dispid 1;
    procedure Disconnect; dispid 2;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TMyControl
// Help String      : MyControl Class
// Default Interface: IMyControl
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TMyControl = class(TOleControl)
  private
    ClassId:  TGuid;
    FIntf:    IMyControl;
    function  GetControlInterface: IMyControl;
    function  Get_GUID: WideString; safecall;

  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    property  GUID: WideString read Get_GUID;

    constructor Create(AOwner: TComponent; ClassId: TGuid); overload;

    procedure Connect;
    procedure Disconnect;
    property  ControlInterface: IMyControl read GetControlInterface;
    property  DefaultInterface: IMyControl read GetControlInterface;
  published
    property Anchors;
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
  end;

{
procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

}
implementation

uses ComObj;

constructor TMyControl.Create(AOwner: TComponent; ClassId: TGuid);
begin
      Self.ClassID := ClassId;
      inherited Create(AOwner);
end;

function TMyControl.Get_GUID: WideString; safecall;
begin
  Result := GuidToString(Self.ClassID);
end;

procedure TMyControl.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{524459CD-5F81-4825-96E8-2EA2573B9A14}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  if (not (ClassId.D1 = 0)) then
       ControlData.ClassID := Self.ClassId;
end;

procedure TMyControl.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IMyControl;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TMyControl.GetControlInterface: IMyControl;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TMyControl.Connect;
begin
  try
    DefaultInterface.Connect();
  except
  // eat, not mandatory
  end;
end;

procedure TMyControl.Disconnect;
begin
  try
    DefaultInterface.Disconnect;
  except
   // eat, not mandatory
 end;
end;
{
procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TMyControl]);
end;
}
end.
