unit PrefEmote;
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
    Emote, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, PrefPanel, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls,
    ComCtrls, TntComCtrls, ImgList;

type
  TfrmPrefEmote = class(TfrmPrefPanel)
    EmoteOpen: TOpenDialog;
    pageEmotes: TTntPageControl;
    TntTabSheet1: TTntTabSheet;
    TntTabSheet2: TTntTabSheet;
    pnlCustomPresButtons: TPanel;
    btnEmoteAdd: TTntButton;
    btnEmoteRemove: TTntButton;
    btnEmoteClear: TTntButton;
    btnEmoteDefault: TTntButton;
    lstEmotes: TTntListBox;
    Panel2: TPanel;
    btnCustomEmoteAdd: TTntButton;
    btnCustomEmoteRemove: TTntButton;
    Panel3: TPanel;
    TntLabel3: TTntLabel;
    txtCustomEmoteFilename: TTntEdit;
    btnCustomEmoteBrowse: TTntButton;
    XMLDialog1: TOpenDialog;
    lstCustomEmotes: TTntListView;
    imagesCustom: TImageList;
    btnCustomEmoteEdit: TTntButton;
    procedure btnEmoteAddClick(Sender: TObject);
    procedure btnEmoteRemoveClick(Sender: TObject);
    procedure btnEmoteClearClick(Sender: TObject);
    procedure btnEmoteDefaultClick(Sender: TObject);
    procedure btnCustomEmoteBrowseClick(Sender: TObject);
    procedure btnCustomEmoteAddClick(Sender: TObject);
    procedure btnCustomEmoteEditClick(Sender: TObject);
    procedure btnCustomEmoteRemoveClick(Sender: TObject);
    procedure lstCustomEmotesAdvancedCustomDrawItem(
      Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure chkEmoticonsClick(Sender: TObject);
    procedure lstCustomEmotesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
    el: TEmoticonList;

    procedure _addListItem(e: TEmoticon);

  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefEmote: TfrmPrefEmote;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$R *.dfm}
uses
    EmoteProps, 
    XMLTag, XMLParser, GnuGetText, JabberUtils, ExUtils,  Session, PrefController;

{---------------------------------------}
procedure TfrmPrefEmote.LoadPrefs();
var
    path, fn: Widestring;
    i: integer;
    e: TEmoticon;
begin
    inherited;
    el := TEmoticonList.Create();

    MainSession.Prefs.fillStringlist('emoticon_dlls', lstEmotes.Items);

    // load custom emoticons
    fn := MainSession.Prefs.getString('custom_icondefs');
    if (fn = '') then fn := 'custom-icons.xml';
    path := ExtractFilePath(fn);
    if (path = '') then begin
        path := PrefController.getUserDir();
        fn := path + ExtractFileName(fn);
        txtCustomEmoteFilename.Text := fn;
    end;

    if (FileExists(fn)) then begin
        el.AddIconDefsFile(fn);
        for i := 0 to el.ImageCount - 1 do begin
            e := el.Emoticons[i];
            _addListItem(e);
        end;
    end;

    pageEmotes.TabIndex := 0;
    chkEmoticonsClick(Self);
end;

{---------------------------------------}
procedure TfrmPrefEmote.SavePrefs();
var
    fn: Widestring;
begin
    inherited;
    MainSession.Prefs.setStringlist('emoticon_dlls', lstEmotes.Items);

    // Save our custom list.
    fn := txtCustomEmoteFilename.Text;
    el.SaveIconDefsFile(fn);

    // Reload our lists.
    InitializeEmoticonLists();

    // If emote dlls had invalid dlls, this list could have changed.
    // So, reload.
    MainSession.Prefs.fillStringlist('emoticon_dlls', lstEmotes.Items);
end;

{---------------------------------------}
procedure TfrmPrefEmote.btnEmoteAddClick(Sender: TObject);
var
    i: integer;
begin
  inherited;
    if (EmoteOpen.Execute) then begin
        // make sure they don't add dupes.
        i := lstEmotes.Items.IndexOf(EmoteOpen.Filename);
        if (i = -1) then
            lstEmotes.Items.Add(EmoteOpen.Filename);
    end;
end;

{---------------------------------------}
procedure TfrmPrefEmote.btnEmoteRemoveClick(Sender: TObject);
var
    i: integer;
begin
  inherited;
    i := lstEmotes.ItemIndex;
    if (i = -1) then exit;
    if (MessageDlgW(_('Remove this emoticon set?'), mtConfirmation, [mbYes, mbNo], 0) = mrNo) then exit;

    lstEmotes.Items.Delete(i);
end;

{---------------------------------------}
procedure TfrmPrefEmote.btnEmoteClearClick(Sender: TObject);
begin
  inherited;
    if (MessageDlgW(_('Remove all emoticon sets?'), mtConfirmation, [mbYes, mbNo], 0) = mrNo) then exit;
    lstEmotes.Items.Clear();
end;

{---------------------------------------}
procedure TfrmPrefEmote.btnEmoteDefaultClick(Sender: TObject);
begin
  inherited;
    if (MessageDlgW(_('Reset emoticon sets back to defaults?'), mtConfirmation,
        [mbYes, mbNo], 0) = mrNo) then exit;
    lstEmotes.Items.Clear();
    MainSession.Prefs.fillStringlist('emoticon_dlls', lstEmotes.Items, pkDefault);
end;

{---------------------------------------}
procedure TfrmPrefEmote.btnCustomEmoteBrowseClick(Sender: TObject);
begin
    if (XMLDialog1.Execute) then
        txtCustomEmoteFilename.Text := XMLDialog1.FileName;
end;

{---------------------------------------}
procedure TfrmPrefEmote._addListItem(e: TEmoticon);
var
    li: TListItem;
begin
    li := lstCustomEmotes.Items.Add();
    li.Caption := el.getText(e);
    li.imageIndex := 0;
    li.Data := e;
end;

{---------------------------------------}
procedure TfrmPrefEmote.btnCustomEmoteAddClick(Sender: TObject);
var
    f: TfrmEmoteProps;
    e: TEmoticon;
    ms, txt, ffn, fn, key: Widestring;
    valid: boolean;
begin
  inherited;
    // make sure they don't add dupes.
    f := TfrmEmoteProps.Create(Self);

    valid := false;
    while (valid = false) do begin
        if (f.ShowModal = mrCancel) then begin
            f.Free();
            exit;
        end;

        fn := f.txtFilename.Text;
        txt := f.txtText.Text;
        ffn := txtCustomEmoteFilename.Text;

        // validate the text matches our regex.
        if (emoticon_regex.Exec(txt)) then begin
            // we have a match
            ms := emoticon_regex.Match[2];
            if (ms = txt) then valid := true;
        end;

        if (valid = false) then begin

            if (MessageDlgW(_('The text you entered is not a valid emoticon string. Try (foo), or ::foo::'),
                mtError, [mbOK, mbCancel], 0) = mrCancel) then begin
                f.Free();
                exit;
            end;

        end;
    end;

    f.Free();

    if (not FileExists(fn)) then begin
        MessageDlgW(_('The emoticon file specified does not exist.'),
            mtError, [mbOK], 0);
        exit;
    end;

    key := ffn + '/' + fn;
    e := el.getKey(key);
    if (e = nil) then begin
        // Create the new emoticon.
        e := el.loadObject(txt, ffn, fn);
        if (e = nil) then begin
            MessageDlgW(_('The file you specified has an unknown mime type.'),
                mtError, [mbOK], 0);
            exit;
        end;
        _addListItem(e);
    end;

end;

{---------------------------------------}
procedure TfrmPrefEmote.btnCustomEmoteEditClick(Sender: TObject);
var
    li: TListItem;
    e: TEmoticon;
    f: TfrmEmoteProps;
    fn, txt, ms: Widestring;
    i: integer;
    valid: boolean;    
begin
  inherited;
    // Edit
    if (lstCustomEmotes.SelCount > 1) then begin
        MessageDlgW(_('Select a single emoticon to edit.'),
            mtError, [mbOK], 0);
        exit;
    end;

    li := lstCustomEmotes.Selected;
    if (li = nil) then exit;

    e := TEmoticon(li.Data);
    assert(e <> nil);
    fn := e.Filename;
    txt := el.getText(e);

    // Setup the props form
    f := TfrmEmoteProps.Create(Self);
    f.txtFilename.Enabled := false;
    f.btnBrowse.Enabled := false;
    f.txtFilename.Text := fn;
    f.txtText.Text := txt;

    valid := false;
    while (valid = false) do begin
      if (f.ShowModal = mrOK) then begin
        // validate the text matches our regex.
        if (emoticon_regex.Exec(f.txtText.Text)) then begin
            // we have a match
            ms := emoticon_regex.Match[2];
            if (ms = f.txtText.Text) then valid := true;
        end;

        if (valid = false) then begin
            if (MessageDlgW(_('The text you entered is not a valid emoticon string. Try (foo), or ::foo::'),
                mtError, [mbOK, mbCancel], 0) = mrCancel) then begin
                f.Free();
                exit;
            end;
        end;
      end
      //Canceled 
      else begin
       f.Free();
       exit;
      end;
    end;


    // replace text for this emoticon
    i := el.indexOfText(txt);
    if (i >= 0) then begin
         el.setText(i, f.txtText.Text);
         li.Caption := f.txtText.Text;
    end;

    f.Free();
end;

{---------------------------------------}
procedure TfrmPrefEmote.btnCustomEmoteRemoveClick(Sender: TObject);
var
    e: TEmoticon;
    li: TListItem;
    i: integer;
begin
  inherited;
    if (MessageDlgW(_('Remove all selected emoticons?'), mtConfirmation,
        [mbYes, mbNo], 0) = mrNo) then exit;

    // Remove all selected entries
    for i := lstCustomEmotes.Items.Count - 1 downto 0 do begin
        li := lstCustomEmotes.Items[i];
        if (li.Selected) then begin
            e := TEmoticon(li.Data);
            li.Free();
            el.Remove(e);
        end;
    end;

    lstCustomEmotes.Arrange(arDefault);
end;

{---------------------------------------}
procedure TfrmPrefEmote.lstCustomEmotesAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
    box_r, lbl_r, icon_r: TRect;
    e: TEmoticon;
    txt: string;
    tw, w: integer;
begin
  inherited;
    // draw this item
    if (Item.Data = nil) then exit;

    e := TEmoticon(Item.Data);
    icon_r := Item.DisplayRect(drIcon);
    lbl_r := Item.DisplayRect(drLabel);

    with lstCustomEmotes do begin

        Canvas.Pen.Width := 1;
        box_r := Item.DisplayRect(drBounds);

        if (cdsSelected in State) then begin
            Canvas.Brush.Color := clHighlight;
            Canvas.Brush.Style := bsFDiagonal;
        end
        else begin
            Canvas.Brush.Style := bsSolid;
            Canvas.Brush.Color := clWindow;
        end;
        Canvas.Pen.Color := Canvas.Brush.Color;
        Canvas.Rectangle(box_r);

        // draw the bmp
        e.Draw(canvas, icon_r);

        // Center text
        txt := el.GetText(e);
        tw := canvas.TextWidth(txt);
        w := ((lbl_r.Right - lbl_r.left) - tw) div 2;
        canvas.TextOut(lbl_r.left + w, lbl_r.Top, txt);
    end;
    DefaultDraw := false;

end;

procedure TfrmPrefEmote.lstCustomEmotesSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  inherited;
    btnCustomEmoteRemove.Enabled := Selected;

    if (lstCustomEmotes.SelCount = 1) then
        btnCustomEmoteEdit.Enabled := true
    else
        btnCustomEmoteEdit.Enabled := false;
    
end;

procedure TfrmPrefEmote.chkEmoticonsClick(Sender: TObject);
begin
  inherited;
  {
    btnEmoteAdd.Enabled := chkEmoticons.Checked;
    btnEmoteRemove.Enabled := chkEmoticons.Checked;
    btnEmoteClear.Enabled := chkEmoticons.Checked;
    btnEmoteDefault.Enabled := chkEmoticons.Checked;
    pageEmotes.Enabled := chkEmoticons.Checked;

    btnCustomEmoteAdd.Enabled := chkEmoticons.Checked;
    if (not chkEmoticons.Checked) then begin
        btnCustomEmoteRemove.Enabled := chkEmoticons.Checked;
        btnCustomEmoteEdit.Enabled := chkEmoticons.Checked;
    end;
    txtCustomEmoteFilename.Enabled := chkEmoticons.Checked;
    }
end;

end.
