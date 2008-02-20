unit BaseMsgList;
{
    Copyright 2004, Peter Millard

    This file is part of Exodus.

    Exodus is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Exodus is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Exodus; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

interface

uses
    TntMenus, JabberMsg,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExFrame;

type
  TfBaseMsgList = class(TExFrame)
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
    procedure DisplayPresence(txt: Widestring; timestamp: string); virtual;
    function  getHandle(): THandle; virtual;
    function  getObject(): TObject; virtual;
    function  empty(): boolean; virtual;
    function  getHistory(): Widestring; virtual;
    procedure Save(fn: string); virtual;
    procedure populate(history: Widestring); virtual;
    procedure setupPrefs(); virtual;
    procedure setTitle(title: Widestring); virtual;
    procedure refresh(); virtual; // start dock
    procedure ready(); virtual;  // form up, (un)dock done, etc.

    procedure DisplayComposing(msg: Widestring); virtual;
    procedure HideComposing(); virtual;
    function  isComposing(): boolean; virtual;

    property Handle: THandle read getHandle;
    property winObject: TObject read getObject;
  end;

  function MsgListFactory(Owner: TComponent;
                          Parent: TWinControl;
                          ListName: widestring = 'msg_list_frame'): TfBaseMsgList;

implementation

{$R *.dfm}

uses
    RTFMsgList,
    IEMsgList,
    Session;

const
    RTF_MSGLIST = 0;
    HTML_MSGLIST = 1;

function MsgListFactory(Owner: TComponent; Parent: TWinControl; ListName: widestring): TfBaseMsgList;
 var
    mtype: integer;
begin
    mtype := MainSession.prefs.getInt('msglist_type');
    if (mtype = HTML_MSGLIST) then
        Result := TfIEMsgList.Create(Owner)
    else if (mtype = RTF_MSGLIST) then
        Result := TfRTFMsgList.Create(Owner)         
    else Result := TfRTFMsgList.Create(Owner);

    Result.Parent := Parent;
    Result.Name := ListName;
    Result.Align := alClient;
    Result.Visible := true;
end;

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

procedure TfBaseMsgList.DisplayPresence(txt: Widestring; timestamp: string);
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

procedure TfBaseMsgList.setTitle(title: Widestring);
begin
    // NOOP
end;

procedure TfBaseMsgList.ready();
begin
    // NOOP
end;

procedure TfBaseMsgList.refresh();
begin
    // NOOP
end;

procedure TfBaseMsgList.DisplayComposing(msg: Widestring);
begin
    // NOOP
end;

procedure TfBaseMsgList.HideComposing();
begin
    // NOOP
end;

function TfBaseMsgList.IsComposing(): boolean;
begin
    result := false;
end;

end.
