unit fGeneric;
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
    Unicode, XMLTag,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, TntCheckLst, TntStdCtrls;

type
  TframeGeneric = class(TFrame)
    lblLabel: TTnTLabel;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    value: Widestring;
    fld_type: string;
    fld_var: Widestring;
    frm_type: string;
    req: boolean;
    c: TControl;
    opts_vals: TStringList;

    function getValues: TWideStringList;
    procedure JidFieldDotClick(Sender: TObject);
  public
    { Public declarations }
    procedure render(tag: TXMLTag);
    function isValid: boolean;
    function getXML: TXMLTag;
    function getLabelWidth: integer;
    procedure setLabelWidth(val: integer);
    
    property FormType: string read frm_type write frm_type;
  end;

resourcestring
    sRequired = '(Required)';

implementation

{$R *.dfm}
uses
    Jabber1,
    JabberID,
    SelContact,
    ExUtils, CheckLst;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TframeGeneric.render(tag: TXMLTag);
var
    t: Widestring;
    opts: TXMLTagList;
    idx, i: integer;
    dot : TButton;
begin
    // take a x-data field tag and do the right thing
    Self.BorderWidth := 1;
    AssignDefaultFont(Self.Font);

    fld_var := tag.GetAttribute('var');
    t := tag.GetAttribute('type');
    req := tag.TagExists('required');
    value := tag.GetBasicText('value');
    Self.Hint := tag.GetBasicText('desc');

    if (req) then begin
       if (Self.Hint = '') then
          Self.Hint := sRequired
       else
          Self.Hint := Self.Hint + ''#13#10 + sRequired;
   end;

    lblLabel.Caption := tag.GetAttribute('label');
    if (lblLabel.Caption = '') then
        lblLabel.Caption := tag.GetAttribute('var');

    if (lblLabel.Caption = '') then
        lblLabel.Width := 0
    else begin
        lblLabel.Caption := lblLabel.Caption + ':';
        if (req) then
           lblLabel.Caption := '* ' + lblLabel.Caption;
    end;

    if ((t = 'text-multi') or (t = 'jid-multi')) then begin
        lblLabel.Layout := tlTop;
        c := TTntMemo.Create(Self);
        c.Parent := Self;
        opts := tag.QueryTags('value');
        with TTntMemo(c) do begin
            Lines.Clear();
            for i := 0 to opts.Count - 1 do
                Lines.Add(opts[i].Data);
            Align := alClient;
        end;
        Self.Height := Self.Height * 3;
    end

    else if (t = 'list-multi') then begin
        lblLabel.Layout := tlTop;
        c := TTntCheckListbox.Create(self);
        c.Parent := Self;
        opts_vals := TStringList.Create();
        opts := tag.QueryTags('option');
        with TTntCheckListbox(c) do begin
            Align := alClient;
            for i := 0 to opts.Count - 1 do begin
                Items.Add(opts[i].GetAttribute('label'));
                opts_vals.Add(opts[i].GetBasicText('value'));
            end;
        end;

        opts := tag.QueryTags('value');
        for i := 0 to opts.Count - 1 do begin
            idx := opts_vals.IndexOf(opts[i].Data);
            TTntCheckListbox(c).Checked[idx] := true;
        end;

        if (TTntCheckListbox(c).Items.Count < 6) then
            i := TTntCheckListbox(c).Items.Count
        else
            i := 5;
        Self.Height := (TTntCheckListbox(c).ItemHeight * i) + 5;
        TTntCheckListbox(c).TopIndex := 0;
        TTntCheckListbox(c).Repaint();
    end
    else if (t = 'list-single') then begin
        lblLabel.Layout := tlTop;
        c := TTntCombobox.Create(self);
        c.Parent := Self;
        opts_vals := TStringList.Create();
        opts := tag.QueryTags('option');
        with TTntCombobox(c) do begin
            Style := csDropDownList;
            Align := alClient;
            for i := 0 to opts.Count - 1 do begin
                Items.Add(opts[i].GetAttribute('label'));
                opts_vals.Add(opts[i].GetBasicText('value'));
            end;
            ItemIndex := opts_vals.IndexOf(value);
        end;
    end

    else if (t = 'boolean') then begin
        Self.AutoSize := true;
        lblLabel.Layout := tlTop;
        c := TTntCheckbox.Create(Self);
        with TTntCheckbox(c) do begin
            Align := alClient;
            Caption := '';
            Checked := (value = '1');
        end;
    end
    else if (t = 'fixed') then begin
        c := lblLabel;
        self.AutoSize := true;
        with lblLabel do begin
            AutoSize := true;
            Layout := tlTop;
            WordWrap := true;
            Caption := value;
            Align := alTop;
        end;
    end

    else if ((t = 'hidden') and (frm_type <> 'submit')) then begin
        Self.Height := 0;
        c := nil;
    end

    else if ((t = 'jid') or (t = 'jid-single')) then begin
        c :=  TTntEdit.Create(Self);
        with TTntEdit(c) do begin
            Text := value;
            // Anchors := [akLeft, akTop, akBottom, akRight];
            Parent := Self;
            Align := alClient;
        end;

        dot := TButton.Create(Self);
        with TButton(dot) do begin
            Caption := '...';
            OnClick := JidFieldDotClick;
            Top := 1;
            Parent := Self;
            Visible := true;
            Width := c.Height - 2;
            Align := alRight;
        end;

        c.Width := Self.ClientWidth - lblLabel.Width - dot.Width - 10;
    end
    else begin  // 'text-single', 'text-private', or unknown
        lblLabel.Layout := tlCenter;
        c := TTntEdit.Create(Self);
        with TTntEdit(c) do begin
            Text := value;
            Align := alClient;
            if (t = 'text-private') then
                PasswordChar := '*';
        end;
    end;

    if (c <> nil) then begin
        c.Parent := Self;
        c.Visible := true;
        c.Left := lblLabel.Width + 5;
        c.Top := 1;
        Self.ClientHeight := c.Height + (2 * Self.BorderWidth);
    end;

    fld_type := t;
    if (frm_type = 'submit') then
        c.Enabled := false;
end;

{---------------------------------------}
function TframeGeneric.isValid: boolean;
begin
    Result := (not req) or (getValues().Count > 0);

    if (fld_type = 'jid') then
        // make sure we have a valid JID
        Result := isValidJID(TEdit(c).Text);

    if (Result) then
       lblLabel.Font.Color := clWindowText
    else
       lblLabel.Font.Color := clRed;
end;

{---------------------------------------}
function TframeGeneric.getXML: TXMLTag;
var
    vals: TWideStringlist;
    i: integer;
begin
    // Return the xml for this field
    vals := getValues();

    if (vals.Count = 0) then begin
        vals.Free();
        Result := nil;
        exit;
    end;

    Result := TXMLTag.Create('field');
    Result.setAttribute('var', fld_var);

    for i := 0 to vals.Count - 1 do
        Result.AddBasicTag('value', vals[i]);

    vals.Free();
end;

{---------------------------------------}
function TframeGeneric.getValues: TWideStringList;
var
    tmps: WideString;
    i: integer;
begin
    Result := TWideStringlist.Create();
    if (c = lblLabel) then exit;

    if (c is TTntEdit) then begin
        tmps := Trim(TTntEdit(c).Text);
        if (tmps <> '') then
            Result.Add(TTntEdit(c).Text);
    end
    else if (c is TTntMemo) then begin
        tmps := Trim(TTntMemo(c).Text);
        if (tmps <> '') then with TTntMemo(c) do begin
            for i := 0 to Lines.Count - 1 do
                Result.Add(Lines[i]);
        end;
    end
    else if (c is TTntCheckListbox) then with TTntCheckListbox(c) do begin
        for i := 0 to Items.Count - 1 do begin
            if Checked[i] then
                Result.Add(opts_vals[i]);
        end;
    end
    else if (c is TTntCombobox) then begin
        i := TTntCombobox(c).ItemIndex;
        if (i <> -1) then
            Result.Add(opts_vals[i]);
    end
    else if (c is TTntCheckbox) then begin
        if (TTntCheckbox(c).checked) then
            Result.Add('1')
        else
            Result.Add('0');
    end
    else if (c = nil) then
        Result.Add(value);
end;

{---------------------------------------}
procedure TframeGeneric.JidFieldDotClick(Sender: TObject);
var
    fsel: TfrmSelContact;
begin
    fsel := TfrmSelContact.Create(Application);
    fsel.frameTreeRoster1.treeRoster.MultiSelect := false;

    frmExodus.PreModal(fsel);

    if (fsel.ShowModal = mrOK) then begin
        TEdit(c).Text := fsel.GetSelectedJID();
    end;

    frmExodus.PostModal();
end;

{---------------------------------------}
procedure TframeGeneric.FrameResize(Sender: TObject);
begin
    if (c = lblLabel) then with TTntLabel(c) do begin
        AutoSize := false;
        AutoSize := true;
    end;
end;

{---------------------------------------}
function TframeGeneric.getLabelWidth: integer;
var
    p : TForm;
begin
    if ((lblLabel = nil) or (lblLabel.Width = 0) or (lblLabel = c)) then
        result := 0
    else begin
        p := TForm(Self.Owner);
        result := p.Canvas.TextWidth(lblLabel.Caption);
    end;
end;

{---------------------------------------}
procedure TframeGeneric.setLabelWidth(val: integer);
begin
    if ((lblLabel.Width <> 0) and (lblLabel <> c)) then
        lblLabel.Width := val;
end;


end.
