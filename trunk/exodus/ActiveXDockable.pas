unit ActiveXDockable;
{
    Copyright 2002, Peter Millard

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
    Dockable, ActiveX, ComObj,
    BaseMsgList, SysUtils, Unicode,
    COMDockToolbar, ToolWin, ComCtrls,
    ExtCtrls, Controls, Classes;

type
  TfrmActiveXDockable = class(TfrmDockable)
    pnlMsgList: TPanel;
    pnlChatTop: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
  protected

  public
    { Public declarations }
    DockToolbar: TExodusDockToolbar;

  end;

var
  frmActiveXDockable: TfrmActiveXDockable;

function StartActiveX(window_title: widestring;
                   show_window: boolean;
                   chat_nick: widestring='';
                   bring_to_front:boolean=true): TfrmActiveXDockable;

implementation

{$R *.dfm}

uses
    StrUtils;


function StartActiveX(window_title: widestring;
                   show_window: boolean;
                   chat_nick: widestring='';
                   bring_to_front:boolean=true): TfrmActiveXDockable;
begin
    Result := TfrmActiveXDockable.Create(nil);

    if (show_window) then
        Result.ShowDefault(bring_to_front);
end;

{---------------------------------------}
procedure TfrmActiveXDockable.FormCreate(Sender: TObject);
var
    g: TGUID;
    guid: string;
begin
    try
        // generate a unique UID for activity window
        CreateGUID(g);
        guid := GUIDToString(g);
        guid := AnsiMidStr(guid, 2, length(guid) - 2);
        guid := AnsiReplaceStr(guid, '-', '_');
        Self.setUID('activeXWindow_' + guid);

        inherited;

        DockToolbar := TExodusDockToolbar.Create(Self.tbDockBar);
        DockToolbar.ObjAddRef();
    except
    end;
end;

{---------------------------------------}
procedure TfrmActiveXDockable.FormDestroy(Sender: TObject);
begin
    if (DockToolbar <> nil) then
        DockToolbar.Free();

    inherited;
end;







end.

