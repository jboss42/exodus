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
    StdCtrls;

type
  TframeGeneric = class(TFrame)
    lblLabel: TLabel;
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
    ExUtils;

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

    if (t = 'text-multi') then begin
        c := TMemo.Create(Self);
        with TMemo(c) do begin
            Text := value;
            Width := Self.ClientWidth - 5 - lblLabel.Width;
            Align := alClient;
            end;
        Self.Height := Self.Height * 3;
        end
    else if (t = 'list-multi') then begin
        c := TListbox.Create(self);
        c.Parent := Self;
        opts_vals := TStringList.Create();
        opts := tag.QueryTags('option');
        with TListbox(c) do begin
            IntegralHeight := true;
            Align := alClient;
            MultiSelect := true;
            for i := 0 to opts.Count - 1 do begin
                Items.Add(opts[i].GetAttribute('label'));
                opts_vals.Add(opts[i].GetBasicText('value'));
                end;
            end;

        opts := tag.QueryTags('value');
        for i := 0 to opts.Count - 1 do begin
            idx := opts_vals.IndexOf(opts[i].Data);
            TListbox(c).Selected[idx] := true;
            end;

        if (TListbox(c).Items.Count < 6) then
            i := TListbox(c).Items.Count
        else
            i := 5;
        Self.Height := Self.Height * i;
        TListbox(c).TopIndex := 0;
        end
    else if (t = 'list-single') then begin
        c := TCombobox.Create(self);
        c.Parent := Self;
        opts_vals := TStringList.Create();
        opts := tag.QueryTags('option');
        with TCombobox(c) do begin
            Style := csDropDownList;
            Width := Self.ClientWidth - 5 - lblLabel.Width;
            Anchors := [akLeft, akTop, akRight];
            for i := 0 to opts.Count - 1 do begin
                Items.Add(opts[i].GetAttribute('label'));
                opts_vals.Add(opts[i].GetBasicText('value'));
                end;
            ItemIndex := opts_vals.IndexOf(value);
            end;
        end
    else if (t = 'boolean') then begin
        c := TCheckbox.Create(Self);
        with TCheckbox(c) do begin
            Caption := '';
            Checked := (value = '1');
            end;
        end
    else if (t = 'fixed') then begin
        c := lblLabel;
        lblLabel.AutoSize := true;
        lblLabel.WordWrap := true;
        lblLabel.Caption := value;
        lblLabel.Align := alClient;
        end
    else if ((t = 'hidden') and (frm_type <> 'submit')) then begin
        Self.Height := 0;
        c := nil;
        end
    else if (t = 'jid') then begin
        dot := TButton.Create(Self);
        with TButton(dot) do begin
            Caption := '...';
            OnClick := JidFieldDotClick;
            Top := 5;
            Left := Self.ClientWidth - 20;
            Width := 20;
            Height := 20;
            Anchors := [akTop, akRight];
            Parent := Self;
            Visible := true;
            end;
        c :=  TEdit.Create(Self);
        with TEdit(c) do begin
            Text := value;
            Width := Self.ClientWidth - lblLabel.Width - dot.Width - 10;
            Anchors := [akLeft, akTop, akRight];
            end;
        end
    else begin  // 'text-single', 'text-private', or unknown
        c := TEdit.Create(Self);
        with TEdit(c) do begin
            Text := value;
            Width := Self.ClientWidth - 5 - lblLabel.Width;
            Anchors := [akLeft, akTop, akRight];

            if (t = 'text-private') then
                PasswordChar := '*';
            end;
        end;

    if (c <> nil) then begin
        c.Parent := Self;
        c.Visible := true;
        c.Left := lblLabel.Width + 5;
        c.Top := 5;
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
    //
    vals := getValues();

    if (vals.Count = 0) then begin
        Result := nil;
        exit;
        end;

    Result := TXMLTag.Create('field');
    Result.PutAttribute('var', fld_var);

    for i := 0 to vals.Count - 1 do
        Result.AddBasicTag('value', vals[i]);
end;

{---------------------------------------}
function TframeGeneric.getValues: TWideStringList;
var
    tmps: WideString;
    i: integer;
begin
    Result := TWideStringlist.Create();
    if (c = lblLabel) then exit;

    if (c is TEdit) then begin
        tmps := Trim(TEdit(c).Text);
        if (tmps <> '') then
            Result.Add(TEdit(c).Text);
        end
    else if (c is TMemo) then begin
        tmps := Trim(TMemo(c).Text);
        if (tmps <> '') then
            Result.Add(TMemo(c).Text);
        end
    else if (c is TListbox) then with TListbox(c) do begin
        for i := 0 to Items.Count - 1 do begin
            if Selected[i] then
                Result.Add(opts_vals[i]);
            end;
        end
    else if (c is TCombobox) then
        Result.Add(opts_vals[TCombobox(c).ItemIndex])
    else if (c is TCheckbox) then begin
        if (TCheckbox(c).checked) then
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

end.
