{
    Copyright 2001, Peter Millard

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

unit ExTreeView;

interface

uses
  SysUtils, Classes, Controls, TntComCtrls, XMLTag, Exodus_TLB,
  RegExpr, ComCtrls, Contnrs;

type
  TExTreeView = class(TTntTreeView)
  private
      { Private declarations }
      _JS: TObject;
      _SessionCB: Integer;
      _RosterCB: Integer;
      _NestedGroups : TRegExpr;
      _StatusColor: Integer;
      _TotalsColor: Integer;
      _InactiveColor: Integer;
      _ShowGroupTotals: Boolean;
      _ShowStatus: Boolean;
      _CurrentNode: TTntTreeNode;

      //Methods
      procedure _RosterCallback(Event: string; Item: IExodusItem);
      procedure _SessionCallback(Event: string; Tag: TXMLTag);
      
  protected
      { Protected declarations }
      function  AddItemNode(Item: IExodusItem): TTntTreeNode;virtual;
      function  GetNodeByName(Group: WideString): TTntTreeNode;virtual;
      function  AddNodeByName(Group: WideString): TTntTreeNode;virtual;
      function  GetChildNodeByName(Group: WideString; Parent: TTntTreeNode): TTntTreeNode;virtual;
      function  AddChildNodeByName(Group: WideString; Parent: TTntTreeNode): TTntTreeNode;virtual;
      function  GetItemNodes(Uid: WideString) : TObjectList; virtual;
      procedure UpdateItemNodes(Item: IExodusItem); virtual;
      procedure RemoveItemNodes(Item: IExodusItem); virtual;
      procedure UpdateItemNode(Node: TTntTreeNode); virtual;
      function  GetActiveCounts(Node: TTntTreeNode): Integer; virtual;
      function  GetLeavesCounts(Node: TTntTreeNode): Integer; virtual;
      procedure CustomDrawItem(Sender: TCustomTreeView;
                               Node: TTreeNode;
                               State: TCustomDrawState;
                               var DefaultDraw: Boolean); virtual;
      procedure DrawNodeText(Node: TTntTreeNode;
                             State: TCustomDrawState;
                             Text, ExtendedText: Widestring);  virtual;
      procedure DoubleClick(Sender: TObject);
      procedure MouseDown(Sender: TObject; Button: TMouseButton;
                          Shift: TShiftState; X, Y: Integer);
      //procedure GroupExpanded(Sender: TObject; Node: TTreeNode);
      //procedure SelectionChange(Sender: TObject; Node: TTreeNode);
  public
      { Public declarations }
      constructor Create(AOwner: TComponent; Session: TObject);
      destructor Destroy(); override;
      //Properties
      property Session: TObject read _JS write _JS;
      procedure SetFontsAndColors();

  end;

//procedure Register;

implementation
uses Session, Unicode, Graphics, Windows, ExUtils, CommCtrl, Jabber1,
     RosterImages, JabberID, ContactController, COMExodusItem, ChatWin;

{---------------------------------------}
constructor TExTreeView.Create(AOwner: TComponent; Session: TObject);
begin
    inherited Create(AOwner);
    Align := alClient;
    Anchors := [akLeft, akTop, akRight, akBottom];
    RowSelect := true;
    MultiSelect := true;
    ShowButtons := false;
    ShowLines := false;
    AutoExpand := false;
    HideSelection := false;
    OnCustomDrawItem := CustomDrawItem;
    OnDblClick := DoubleClick;
    OnMouseDown := MouseDown;
    _JS :=  TJabberSession(Session);
    _RosterCB := TJabberSession(_JS).RegisterCallback(_RosterCallback, '/item');
    _SessionCB := TJabberSession(_JS).RegisterCallback(_SessionCallback, '/session');
    _NestedGroups := TRegExpr.Create();
    _NestedGroups.SpaceChars :=  chr(47);
    _NestedGroups.WordChars := _NestedGroups.WordChars + chr(32);
    _NestedGroups.Expression := '\b\w+';
    _NestedGroups.Compile();
    _TotalsColor := TColor(RGB(196, 202, 207));
    _InactiveColor := TColor(RGB(196, 202, 207));
    Perform(TVM_SETITEMHEIGHT, -1, 0);
    _CurrentNode := nil;
end;

{---------------------------------------}
destructor TExTreeView.Destroy();
begin
    with TJabberSession(_js) do begin
        UnregisterCallback(_SessionCB);
        UnregisterCallback(_RosterCB);
    end;
   _NestedGroups.Free;
  
   inherited;
end;

{---------------------------------------}
procedure TExTreeView.SetFontsAndColors();
begin
    //Initialize fonts and colors
    _StatusColor := TColor(TJabberSession(_JS).Prefs.getInt('inline_color'));
    Color := TColor(TJabberSession(_JS).prefs.getInt('roster_bg'));
    Font.Name := TJabberSession(_JS).prefs.getString('roster_font_name');
    Font.Size := TJabberSession(_JS).prefs.getInt('roster_font_size');
    Font.Color := TColor(TJabberSession(_JS).prefs.getInt('roster_font_color'));
    Font.Charset := TJabberSession(_JS).prefs.getInt('roster_font_charset');
    Font.Style := [];
    if (TJabberSession(_JS).prefs.getBool('font_bold')) then
        Font.Style := Font.Style + [fsBold];
    if (TJabberSession(_JS).prefs.getBool('font_italic')) then
        Font.Style := Font.Style + [fsItalic];
    if (TJabberSession(_JS).prefs.getBool('font_underline')) then
        Font.Style := Font.Style + [fsUnderline];
    _ShowGroupTotals := TJabberSession(_JS).prefs.getBool('roster_groupcounts');
    _ShowStatus := TJabberSession(_JS).prefs.getBool('inline_status');
end;

{---------------------------------------}
procedure TExTreeView._RosterCallback(Event: string; Item: IExodusItem);
var
    i: Integer;
begin
  if Event = '/item/begin' then begin
      Self.Items.BeginUpdate;
      exit;
  end;
  if Event = '/item/add' then begin
     AddItemNode(Item);
     exit;
  end;
  if Event = '/item/update' then begin
     UpdateItemNodes(Item);
     exit;
  end;
  if event = '/item/remove' then begin
     RemoveItemNodes(Item);
     exit;
  end;
  if event = '/item/end' then begin
     for i := 0 to Items.Count - 1 do
         Items[i].Expand(true);
     Self.Items.EndUpdate;
     exit;
  end;

end;

{---------------------------------------}
procedure TExTreeView._SessionCallback(Event: string; Tag: TXMLTag);
begin
     //Force repaing if prefs have changed.
     if Event = '/session/prefs' then
     begin
         SetFontsAndColors();
         Invalidate();
     end;
end;

function TExTreeView.AddItemNode(Item: IExodusItem): TTntTreeNode;
var
    Group, Node: TTntTreeNode;
    i: Integer;
begin
    //Remove all nodes pointing to the item
    RemoveItemNodes(Item);

    //Iterate through list of groups and make sure group exists
    for i := 0 to Item.GroupCount - 1 do
    begin
        //Check if group node exists
        Group := GetNodeByName(Item.Group[i]);
        //If group does not exists, create node.
        if (Group = nil) then
            Group := AddNodeByName(Item.Group[i]);

        //Add item to the group
        Node := Items.AddChild(Group, Item.Text);
        Node.Data := Pointer(Item);
        UpdateItemNode(Node);

    end;

end;

{---------------------------------------}
//This function will use regular expression to parse group strings in
//format a/b/c or /a/b/c or /a/b/c/  and will return node with the name
//matching the passed string in the above format.
function TExTreeView.GetNodeByName(Group: WideString): TTntTreeNode;
var
    Found: Boolean;
    Node, Parent: TTntTreeNode;
begin
   Result := nil;
   Node := nil;
   Parent := nil;
   Found := _NestedGroups.Exec(group);
   //Continue while finding tokens separated by /
   while (Found) do
   begin
       Node := GetChildNodeByName(_NestedGroups.Match[0], Parent);
       if (Node = nil) then
           exit;
       //Found node becomes a parent and continue working down the tree.
       Parent := Node;
       Found := _NestedGroups.ExecNext();
   end;
   Result := Node;
end;

{---------------------------------------}
// Returns child node with the given name for the give parent.
function TExTreeView.GetChildNodeByName(Group: WideString; Parent: TTntTreeNode): TTntTreeNode;
var
     Child: TTntTreeNode;
     i: Integer;
begin
     Result := nil;
     //If no parent, look in all root the nodes.
     if (Parent = nil) then
     begin
         for i := 0 to Items.Count - 1 do
         begin
            if (WideTrim(Items[i].Text) = WideTrim(Group)) then
            begin
                Result := Items[i];
                exit;
            end;
         end;
         exit;
     end;

     //Match text for all children.
     Child := Parent.GetFirstChild();
     while (Child <> nil) do
     begin
         if (WideTrim(Child.Text) = WideTrim(Group)) then
         begin
             Result := Child;
             exit;
         end;
         Child := Parent.GetNextChild(Child);
     end;

end;

{---------------------------------------}
//This function will use regular expression to parse group strings in
//format a/b/c or /a/b/c or /a/b/c/  and will add node with the name
//matching the passed string in the above format if the node does not
//exists.
function TExTreeView.AddNodeByName(Group: WideString): TTntTreeNode;
var
    Found: Boolean;
    Node, Parent: TTntTreeNode;
begin
   Node := nil;
   Parent := nil;
   Found := _NestedGroups.Exec(Group);
   while (Found) do
   begin
       Node := GetChildNodeByName(_NestedGroups.Match[0], Parent);
       if (node = nil) then
           node := AddChildNodeByName(_NestedGroups.Match[0], Parent);
       Parent := Node;
       Found := _NestedGroups.ExecNext();
   end;
   Result := Node;
end;

{---------------------------------------}
//Adds group node to the given parent. Node name for the group is parsed (it
//will not contain '/')
function TExTreeView.AddChildNodeByName(group: WideString; parent: TTntTreeNode): TTntTreeNode;
begin
   Result := Items.AddChild(Parent, Group);
end;

{---------------------------------------}
//Returns a list of nodes for the given uid.
function TExTreeView.GetItemNodes(Uid: WideString) : TObjectList;
var
    i:Integer;
    Item: IExodusItem;
begin
    Result := TObjectList.Create();
    try
        for i := 0 to Items.Count - 1 do
        begin
           //Find non-group nodes
           if (Items[i].Data <> nil) then
           begin
              Item := IExodusItem(Items[i].Data);
              if (Item.Uid = Uid) then
                  Result.Add(Items[i]);
           end;
        end;
    except

    end;

end;

{---------------------------------------}
//Perform repainting for all the nodes for the given item.
procedure TExTreeView.UpdateItemNodes(Item: IExodusItem);
var
    Nodes: TObjectList;
    i: Integer;
begin
    if (Item = nil) then exit;
    Nodes := GetItemNodes(Item.Uid);
    for i := 0 to Nodes.Count - 1 do
       UpdateItemNode(TTntTreeNode(Nodes[i]));
end;

{---------------------------------------}
//Removes all the nodes for the given item.
procedure TExTreeView.RemoveItemNodes(Item: IExodusItem);
var
    i:Integer;
    CurrentItem: IExodusItem;
begin
    try
        for i := 0 to Items.Count - 1 do
        begin
           //Find non-group nodes
           if (Items[i].Data <> nil) then
           begin
              CurrentItem := IExodusItem(Items[i].Data);
              if (CurrentItem.Uid = Item.Uid) then
                  Items.Delete(Items[i]);
           end;
        end;
    except

    end;
end;

{---------------------------------------}
//Repaint given node and all it's ancestors.
procedure TExTreeView.UpdateItemNode(Node: TTntTreeNode);
var
    Rect: TRect;
begin
    //Update all ancestors for the node if showing totals
    Rect := Node.DisplayRect(false);
    InvalidateRect(Handle, @Rect, true);
    Node := Node.Parent;
    while (Node <> nil) do
    begin
        UpdateItemNode(Node);
        Node := Node.parent;
    end;
end;

{---------------------------------------}
//This recursive function counts totals
//for active items in the given group node.
function  TExTreeView.GetActiveCounts(Node: TTntTreeNode): Integer;
var
    Child: TTntTreeNode;
    Item: IExodusItem;
begin
    if (node.Data <> nil) then
    begin
        //If it is a leaf, end recursion.
        item := IExodusItem(node.Data);
        if (item.Active) then
            Result := 1
        else
            Result := 0;
        exit;
    end;

    //Iterate through children and accumulate
    //totals for active for each child.
    Result := 0;
    Child := Node.GetFirstChild();
    while (Child <> nil) do
    begin
        //The following statement takes care of nested group totals.
        Result := Result + GetActiveCounts(Child);
        Child := Node.GetNextChild(Child);
    end;
end;

{---------------------------------------}
//This recursive function counts totals
//for total number of items in the given group node.
function  TExTreeView.GetLeavesCounts(Node: TTntTreeNode): Integer;
var
    Child: TTntTreeNode;
begin
    if (Node.Data <> nil) then
    //If it is a leaf, end recursion.
    begin
        Result := 1;
        exit;
    end;

    //Iterate through children and accumulate
    //totals for each child.
    Result := 0;
    Child := node.GetFirstChild();
    while (child <> nil) do
    begin
        //The following statement takes care of nested group totals.
        Result := Result + GetLeavesCounts(Child);
        Child := Node.GetNextChild(child);
    end;
end;


{---------------------------------------}
//This function figures out all the pieces
//to perform custom drawing for the individual node.
procedure TExTreeView.CustomDrawItem(Sender: TCustomTreeView;
                                     Node: TTreeNode;
                                     State: TCustomDrawState;
                                     var DefaultDraw: Boolean);
var
    Text, ExtendedText: WideString;
    IsGroup: Boolean;
    Item: IExodusItem;
begin
    // Perform initialization
    if (Node = nil) then exit;

    if (not Node.IsVisible) then exit;
    Item := nil;
    DefaultDraw := false;
    Text := '';
    ExtendedText := '';

    //If there is no data attached to the node, it is a group.
    if (Node.Data = nil) then
        IsGroup := true
    else
    begin
        IsGroup := false;
        Item := IExodusItem(Node.Data);
    end;

   if (IsGroup) then
   begin
       //Set extended text for totals for the groups, if required.
       Text := Node.Text;
       if (_ShowGroupTotals) then
          ExtendedText := '(' + IntToStr(GetActiveCounts(TTntTreeNode(Node))) + ' of '+ IntToStr(GetLeavesCounts(TTntTreeNode(Node))) + ' online)';
   end
   else
   begin
       if (Item <> nil) then
       begin
           //Set extended text for status for the node, if required.
           Text := Item.Text;
           if (_ShowStatus) then
               if (WideTrim(Item.ExtendedText) <> '') then
                   ExtendedText := ' - ' + Item.ExtendedText;
           //c2 := WideTrim(c2);
       end;
    end;

    DrawNodeText(TTntTreeNode(Node), State, Text, ExtendedText);
end;

{---------------------------------------}
//Performs drawing of text and images for the given node.
procedure TExTreeView.DrawNodeText(Node: TTntTreeNode; State: TCustomDrawState;
    Text, ExtendedText: Widestring);
var
    RightEdge, MaxRight, Arrow, Folder, TextWidth: integer;
    ImgRect, TxtRect, NodeRect, NodeFullRow: TRect;
    MainColor, StatColor, TotalsColor, InactiveColor: TColor;
    IsGroup: boolean;
    Item: IExodusItem;

begin

    Item := nil;
    //Save string width and height for the node text
    TextWidth := CanvasTextWidthW(Canvas, Text);
    //Set group flag based on presence of data attached.
    if (Node.Data = nil) then
       IsGroup := true
    else
    begin
       IsGroup := false;
       Item := IExodusItem(Node.Data);
    end;

    //Get default rectangle for the node
    NodeRect := Node.DisplayRect(true);
    NodeFullRow := NodeRect;
    NodeFullRow.Left := 0;
    NodeFullRow.Right := ClientWidth - 2;
    Canvas.Font.Color := Font.Color;
    Canvas.Brush.Color := Color;
    Canvas.FillRect(NodeFullRow);
    //Shift to the right to support two group icons for all groups
    NodeRect.Left := NodeRect.Left + 2*Indent;
    NodeRect.Right := NodeRect.Right + 2*Indent;
    TxtRect := NodeRect;
    ImgRect := NodeRect;
    RightEdge := nodeRect.Left + TextWidth + 2 + CanvasTextWidthW(Canvas, (ExtendedText + ' '));
    MaxRight := ClientWidth - 2;

    // make sure our rect isn't bigger than the treeview
    if (RightEdge >= MaxRight) then
        TxtRect.Right := MaxRight
    else
        TxtRect.Right := RightEdge;

    ImgRect.Left := ImgRect.Left - (2*Indent);

    Canvas.Font.Style := Self.Font.Style;
    // if selected, draw a solid rect
    if (cdsSelected in State) then
    begin
        Canvas.Font.Color := clHighlightText;
        Canvas.Brush.Color := clHighlight;
        Canvas.FillRect(TxtRect);
    end;

    if (IsGroup) then
    begin
        // this is a group
        if (Node.Expanded) then
        begin
            Arrow := RosterTreeImages.Find(RI_OPENGROUP_KEY);
            Folder := RosterTreeImages.Find(RI_FOLDER_OPEN_KEY);
        end
        else
        begin
            Arrow := RosterTreeImages.Find(RI_CLOSEDGROUP_KEY);
            Folder := RosterTreeImages.Find(RI_FOLDER_CLOSED_KEY);
        end;
        //Groups have two images
        //Draw > image
        frmExodus.ImageList1.Draw(Canvas,
                                  ImgRect.Left,
                                  ImgRect.Top, Arrow);
        //Move to the second image drawing
        ImgRect.Left := ImgRect.Left + Indent;
        //Draw second image
        frmExodus.ImageList1.Draw(Canvas,
                                  ImgRect.Left,
                                  ImgRect.Top, Folder);
    end
    else
        //Draw image for the item
        frmExodus.ImageList1.Draw(Canvas,
                                  ImgRect.Left + Indent,
                                  ImgRect.Top, Item.ImageIndex);


    // draw the text
    if (cdsSelected in State) then
    begin
        // Draw the focus box.
        Canvas.DrawFocusRect(TxtRect);
        MainColor := clHighlightText;
        StatColor := MainColor;
        TotalsColor := MainColor;
        InactiveColor := MainColor;
    end
    else
    begin
        MainColor := Canvas.Font.Color;
        StatColor := _StatusColor;
        TotalsColor := _TotalsColor;
        InactiveColor := _InactiveColor;
    end;

    //Figure out color for the node.
    if (IsGroup) then
       SetTextColor(Canvas.Handle, ColorToRGB(MainColor))
    else
       if (Item.Active) then
           SetTextColor(Canvas.Handle, ColorToRGB(MainColor))
       else
           SetTextColor(Canvas.Handle, ColorToRGB(InactiveColor));

    //Draw basic node text
    CanvasTextOutW(Canvas, TxtRect.Left + 1,  TxtRect.Top, Text, MaxRight);

    //Draw additional node text, if required.
    if (ExtendedText <> '') then begin
        if (IsGroup) then
            SetTextColor(Canvas.Handle, ColorToRGB(TotalsColor))
        else
            SetTextColor(Canvas.Handle, ColorToRGB(StatColor));

        CanvasTextOutW(Canvas, txtRect.Left + TextWidth + 4, TxtRect.Top, ExtendedText, MaxRight);
    end;

end;

procedure TExTreeView.DoubleClick(Sender: TObject);
var
    Item: IExodusItem;
begin
    if (_CurrentNode = nil) then exit;
    Item := IExodusItem(_CurrentNode.Data);
    if (Item.Type_ <> EI_TYPE_CONTACT) then exit;
    StartChat(Item.UID, '', true);
end;

procedure TExTreeView.MouseDown(Sender: TObject; Button: TMouseButton;
                                Shift: TShiftState; X, Y: Integer);
begin
    _CurrentNode := nil;
    if (Button <> mbLeft) then exit;
    _CurrentNode := GetNodeAt(X, Y);
    if (_CurrentNode = nil) then exit;
    if (_CurrentNode.Data = nil) then _currentNode := nil;

end;

end.
