unit IEMsgList;
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
    Dialogs, BaseMsgList, OleCtrls, SHDocVw;

type
  TfIEMsgList = class(TfBaseMsgList)
    Browser: TWebBrowser;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
    procedure Invalidate(); override;
    procedure CopyAll(); override;
    procedure Copy(); override;
    procedure ScrollToBottom(); override;
    procedure Clear(); override;
    procedure setContextMenu(popup: TTntPopupMenu); override;
    procedure setDragOver(event: TDragOverEvent); override;
    procedure setDragDrop(event: TDragDropEvent); override;
    procedure DisplayMsg(Msg: TJabberMessage; AutoScroll: boolean = true); override;
    procedure DisplayPresence(txt: string); override;
    function  getHandle(): THandle; override;
    function  getObject(): TObject; override;
    function  empty(): boolean; override;
    function  getHistory(): Widestring; override;
    procedure Save(fn: string); override;
    procedure populate(history: Widestring); override;
    procedure setupPrefs(); override;
  end;

var
  fIEMsgList: TfIEMsgList;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

{---------------------------------------}
constructor TfIEMsgList.Create(Owner: TComponent);
begin
    inherited;
end;

{---------------------------------------}
procedure TfIEMsgList.Invalidate();
begin
    //
end;

{---------------------------------------}
procedure TfIEMsgList.CopyAll();
begin
    //
end;

{---------------------------------------}
procedure TfIEMsgList.Copy();
begin
    //
end;

{---------------------------------------}
procedure TfIEMsgList.ScrollToBottom();
begin
    //
end;

{---------------------------------------}
procedure TfIEMsgList.Clear();
begin
    //
end;

{---------------------------------------}
procedure TfIEMsgList.setContextMenu(popup: TTntPopupMenu);
begin
    //
end;

{---------------------------------------}
function TfIEMsgList.getHandle(): THandle;
begin
    Result := Browser.Handle;
end;

{---------------------------------------}
function TfIEMsgList.getObject(): TObject;
begin
    Result := Browser;
end;

{---------------------------------------}
procedure TfIEMsgList.DisplayMsg(Msg: TJabberMessage; AutoScroll: boolean = true);
begin
    //
end;

{---------------------------------------}
procedure TfIEMsgList.DisplayPresence(txt: string);
begin
    //
end;

{---------------------------------------}
procedure TfIEMsgList.Save(fn: string);
begin
    //
end;

{---------------------------------------}
procedure TfIEMsgList.populate(history: Widestring);
begin
    //
end;

{---------------------------------------}
procedure TfIEMsgList.setupPrefs();
begin
    //
end;

{---------------------------------------}
function TfIEMsgList.empty(): boolean;
begin
    Result := true;
end;

{---------------------------------------}
function TfIEMsgList.getHistory(): Widestring;
begin
    Result := '';
end;

{---------------------------------------}
procedure TfIEMsgList.setDragOver(event: TDragOverEvent);
begin
    //
end;

{---------------------------------------}
procedure TfIEMsgList.setDragDrop(event: TDragDropEvent);
begin
    //
end;


end.
