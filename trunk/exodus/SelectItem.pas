{
    Copyright 2008, Peter Millard

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

unit SelectItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, ComCtrls, ExForm,
  Forms, ExTreeView, Exodus_TLB, Dialogs, ExtCtrls, StdCtrls, TntStdCtrls,
  Menus, TntMenus, ExGradientPanel, SClrRGrp;

type
  TfrmSelectItem = class;

  TTypedTreeView = class(TExTreeView)
  private
    _online: Boolean;

    constructor Create(AOwner: TfrmSelectItem; Session: TObject);

    procedure SetShowOnline(flag: Boolean);

  protected
    function FilterItem(item: IExodusItem): Boolean; override;

  public
    destructor Destroy; override;

    procedure DblClick; override;

    property ShowOnline: Boolean read _online write SetShowOnline;

  end;

  TfrmSelectItem = class(TExForm)
    pnlInput: TPanel;
    pnlActions: TPanel;
    pnlSelect: TPanel;
    pnlEntry: TPanel;
    btnCancel: TTntButton;
    btnOK: TTntButton;
    txtJID: TTntEdit;
    lblJID: TTntLabel;
    popSelected: TTntPopupMenu;
    mnuShowOnline: TTntMenuItem;
    ColorBevel1: TColorBevel;
    
    procedure FormCreate(Sender: TObject);

    procedure ItemChanged(Sender: TObject; Node: TTreeNode);
    procedure mnuShowOnlineClick(Sender: TObject);

  private
    { Private declarations }
    _itemType: Widestring;
    _selectedUID: Widestring;
    _itemView: TTypedTreeView;

    constructor Create(AOwner: TComponent; itemtype: Widestring);

  public
    { Public declarations }
    destructor Destroy; override;

    Property ItemType: Widestring read _itemType;
    Property SelectedUID: Widestring read _selectedUID;

  end;

function SelectUIDByType(itemtype: Widestring; title: Widestring = ''): Widestring;


implementation

uses gnugettext, Session;

{$R *.dfm}

function SelectUIDByType(itemtype: Widestring; title: Widestring): Widestring;
var
    selector: TfrmSelectItem;
begin
    Result := '';
    selector := TfrmSelectItem.Create(nil, itemtype);
    if (title <> '') then
        selector.Caption := title;

    if (selector.ShowModal = mrOk) then begin
        Result := selector.SelectedUID;
    end;

    selector.Free;
end;

constructor TTypedTreeView.Create(AOwner: TfrmSelectItem; Session: TObject);
begin
    inherited Create(AOwner, Session);
end;
destructor TTypedTreeView.Destroy;
begin
    inherited;
end;

procedure TTypedTreeView.SetShowOnline(flag: Boolean);
begin
    if (flag <> _online) then begin
        _online := flag;

        if not (csLoading in ComponentState) then
            Refresh();
    end;

end;

function TTypedTreeView.FilterItem(item: IExodusItem): Boolean;
var
    itemtype: Widestring;
begin
    Result := false;

    if ShowOnline and (not item.IsVisible) then
        exit;

    itemtype := TfrmSelectItem(Owner).ItemType;
    if (ItemType <> '') and (ItemType <> item.Type_) then
        exit;

    Result := true;
end;

procedure TTypedTreeView.DblClick;
begin
    if (Selected = nil) or (Selected.Data = nil) then begin
        inherited;
        exit;
    end;

    with TfrmSelectItem(Owner) do begin
        ItemChanged(Self, Selected);
        ModalResult := mrOk;
        Hide;
    end;
end;

{
}
constructor TfrmSelectItem.Create(AOwner: TComponent; itemtype: Widestring);
begin
    inherited Create(AOwner);

    _itemtype := itemtype;
    _selectedUID := '';
end;
destructor TfrmSelectItem.Destroy;
begin
    _itemView.Free;
    _itemView := nil;

    inherited;
end;

procedure TfrmSelectItem.FormCreate(Sender: TObject);
begin
    inherited;

    Self.Caption := _(Self.Caption + ' ' + _itemtype);

    _itemView := TTypedTreeView.Create(Self, MainSession);
    _itemView.Parent := pnlSelect;
    _itemView.MultiSelect := false;
    _itemView.Align := alClient;
    _itemView.AlignWithMargins := false;
    _itemView.OnChange := ItemChanged;
    _itemView.PopupMenu := popSelected;
    _itemView.ShowOnline := MainSession.Prefs.getBool('roster_only_online');

    _itemView.Refresh;
end;

procedure TfrmSelectItem.ItemChanged(Sender: TObject; Node: TTreeNode);
var
    item: IExodusItem;
    valid: Boolean;
begin
   if (Node = nil) then exit;
   
    valid := (Node.Data <> nil);
    if not valid then
        _selectedUID := ''
    else begin
        item := IExodusItem(Node.Data);
        _selectedUID := item.UID;
    end;

    btnOK.Enabled := valid;
end;

procedure TfrmSelectItem.mnuShowOnlineClick(Sender: TObject);
begin
    mnuShowOnline.Checked := not mnuShowOnline.Checked;
    _itemView.ShowOnline := mnuShowOnline.Checked;
end;

end.
