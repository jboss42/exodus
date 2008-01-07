unit ExBrandPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Contnrs, ExFrame;

type
  TControlInfo = class
    _control: TControl;
    _visible: boolean;
    _enabled: boolean;
  end;

  //A simple panel that autohides, mass enables/disables
  TExBrandPanel = class(TExFrame)
  private
      _autoHide: boolean;
    //since we may be "disabling" an already disabled child, we don't want to
    //enable that child when mass enabling. track initial enabled and visible
    //states of children
    _initialStates: TObjectList; //of TControlInfo

    _initiallyEnabled: boolean;
  protected
      function getAutoHide(): boolean;
      procedure setAutoHide(b: boolean);

      function visibleChildren(): integer;virtual;
      procedure enableChildren(e: boolean; useInitial: boolean = false; ignore: TList = nil); virtual;
      procedure showChildren(v: boolean; useInitial: boolean = false; ignore: TList = nil);virtual;

      procedure SetEnabled(enabled: boolean);override;
  public
      Constructor Create(AOwner: TComponent);override;
      Destructor Destroy; Override;
      procedure checkAutoHide();virtual;
      procedure captureChildStates();virtual;

      property InitiallyEnabled: boolean read _initiallyEnabled write _initiallyEnabled;
  published
      property AutoHide: boolean read getAutoHide write setAutoHide;
  end;

  procedure Register();

implementation

{$R *.dfm}
procedure Register();
begin
  RegisterComponents('Win32', [TExBrandPanel]);
end;

//protected methods
function TExBrandPanel.visibleChildren(): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to Self.ControlCount -1 do begin
    if (Self.Controls[i].Visible) then
      inc(Result);
  end;
end;

function findControlInfo(list: TList; child: TControl): TControlInfo;
var
    i: integer;
begin
    Result := nil;
    if (list = nil) or (child = nil) then exit;

    for i := 0 to list.Count - 1 do begin
        if (TControlInfo(list[i])._control = child) then begin
            Result := TControlInfo(list[i]);
            break;
        end;
    end;
end;

function controlInList(list: TList; child: TControl): boolean;
var
    i: integer;
begin
    Result := false;
    if (list = nil) or (child = nil) then exit;
    for  i:= 0 to list.Count - 1 do begin
        if (list[i] = child) then begin
          Result := true;
          break;
        end;
    end;
end;

procedure TExBrandPanel.setEnabled(enabled: boolean);
begin
    inherited SetEnabled(_initiallyEnabled and enabled);
    
    if (_initiallyEnabled) then
        enableChildren(enabled);
end;

procedure TExBrandPanel.showChildren(v: boolean; useInitial: boolean = false; ignore: TList = nil);
var
  i: integer;
  oneT: TControl;
  oneI: TControlInfo;
  initialVisible: boolean;
begin
  for i := 0 to Self.ControlCount -1 do begin
      oneT := Self.Controls[i];
      if (not controlInList(ignore, oneT)) then begin
          if (oneT is TExBrandPanel) then
              TExBrandPanel(oneT).showChildren(v, useInitial, ignore)
          else begin
            initialVisible := true;
            if (v) then begin
                if (useInitial) then begin
                    oneI := findControlInfo(_initialStates, oneT);
                    if (oneI <> nil) then
                        initialVisible := oneI._visible;
                end;
            end;
            oneT.Visible := v and initialVisible;
          end;
      end;
  end;
end;

procedure TExBrandPanel.enableChildren(e: boolean; useInitial: boolean; ignore: TList);
var
    i: integer;
    oneT: TControl;
    oneI: TControlInfo;
    initialEnable: boolean;
begin
    for i := 0 to Self.ControlCount -1 do begin
        oneT := Self.Controls[i];
        if (not controlInList(ignore, oneT)) then begin
            if (oneT is TExBrandPanel) then
                TExBrandPanel(oneT).enableChildren(e, useInitial, ignore)
            else begin
              initialEnable := true;
              if (e) then begin
                  if (useInitial) then begin
                      oneI := findControlInfo(_initialStates, oneT);
                      if (oneI <> nil) then
                          initialEnable := oneI._enabled;
                  end;
              end;
              oneT.Enabled := e and initialEnable;
            end;
        end;
    end;
end;

function TExBrandPanel.getAutoHide(): boolean;
begin
  Result := _autoHide;
end;

procedure TExBrandPanel.setAutoHide(b: boolean);
begin
  _autoHide := b;
end;

procedure TExBrandPanel.captureChildStates();
var
  i: integer;
  t: TControlInfo;
begin
  if (csDesigning in Self.ComponentState) then exit;

  if (_initialStates <> nil) then
      _initialStates.Free();
  _initialStates := TObjectList.Create();

  //walk pnlGroups children and get their initial states
  for i := 0 to Self.ControlCount -1 do begin
      if (Controls[i] is TExBrandPanel) then
          TExBrandPanel(Controls[i]).captureChildStates()
      else begin
        t := TControlInfo.create();
        t._control := Self.Controls[i];
        t._visible := Self.Controls[i].visible;
        t._enabled := Self.Controls[i].enabled;
        _initialStates.Add(t);
      end
  end;
end;

Constructor TExBrandPanel.create(AOwner: TComponent);
begin
    inherited;
    _initialStates := nil;
    _initiallyEnabled := true;
end;

Destructor TExBrandPanel.Destroy;
begin
  if (_initialStates <> nil) then
    _initialStates.Free();
  inherited;
end;

procedure TExBrandPanel.checkAutoHide();
var
    i: integer;
begin
    if (csDesigning in Self.ComponentState) then exit;
    //update any TExBrandPanel children we have first so we can reliably check
    //visiblity states
    for i := 0 to Self.ControlCount - 1 do begin
        if (Self.Controls[i] is TExBrandPanel) then
            TExBrandPanel(Self.Controls[i]).checkAutoHide();
    end;

    //don't mess with visiblity if not autohiding
    if (_autoHide) then
        Self.Visible := (visibleChildren() > 0);
end;
end.
