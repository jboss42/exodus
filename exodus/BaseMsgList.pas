unit BaseMsgList;

interface

uses
    TntMenus, JabberMsg,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs;

type
  TfBaseMsgList = class(TFrame)
  protected
    _base: TObject; // this is our base form

  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;

    procedure Invalidate(); override;
    procedure CopyAll(); virtual;
    procedure Copy(); virtual;
    procedure ScrollToBottom(); virtual;
    procedure Clear(); virtual;
    procedure setContextMenu(popup: TTntPopupMenu); virtual;
    procedure setDragOver(event: TDragOverEvent); virtual;
    procedure setDragDrop(event: TDragDropEvent); virtual;
    procedure DisplayMsg(Msg: TJabberMessage; AutoScroll: boolean = true); virtual;
    procedure DisplayPresence(txt: string); virtual;
    function  getHandle(): THandle; virtual;
    function  getObject(): TObject; virtual;
    function  empty(): boolean; virtual;
    function  getHistory(): Widestring; virtual;
    procedure Save(fn: string); virtual;
    procedure populate(history: Widestring); virtual;
    procedure setupPrefs(); virtual;

    property Handle: THandle read getHandle;
    property winObject: TObject read getObject;
  end;

implementation

{$R *.dfm}

uses
    BaseChat;

constructor TfBaseMsgList.Create(Owner: TComponent);
begin
    inherited;
    _base := Owner;
end;

procedure TfBaseMsgList.Invalidate();
begin
    //
end;

procedure TfBaseMsgList.CopyAll();
begin
    //
end;

procedure TfBaseMsgList.Copy();
begin
    //
end;

procedure TfBaseMsgList.ScrollToBottom();
begin
    //
end;

procedure TfBaseMsgList.Clear();
begin
    //
end;

procedure TfBaseMsgList.setContextMenu(popup: TTntPopupMenu);
begin
    //
end;

function TfBaseMsgList.getHandle(): THandle;
begin
    Result := 0;
end;

function TfBaseMsgList.getObject(): TObject;
begin
    Result := nil;
end;

procedure TfBaseMsgList.DisplayMsg(Msg: TJabberMessage; AutoScroll: boolean = true);
begin
    // NOOP
end;

procedure TfBaseMsgList.DisplayPresence(txt: string);
begin
    // NOOP
end;

procedure TfBaseMsgList.Save(fn: string);
begin
    // NOOP
end;

procedure TfBaseMsgList.populate(history: Widestring);
begin
    // NOOP
end;

procedure TfBaseMsgList.setupPrefs();
begin
    // NOOP
end;

function TfBaseMsgList.empty(): boolean;
begin
    Result := true;
end;

function TfBaseMsgList.getHistory(): Widestring;
begin
    Result := '';
end;

procedure TfBaseMsgList.setDragOver(event: TDragOverEvent);
begin
    // NOOP
end;

procedure TfBaseMsgList.setDragDrop(event: TDragDropEvent);
begin
    // NOOP
end;

end.
