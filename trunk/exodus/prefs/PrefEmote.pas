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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls,
  ComCtrls, TntComCtrls;

type
  TfrmPrefEmote = class(TfrmPrefPanel)
    Panel1: TPanel;
    chkEmoticons: TTntCheckBox;
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
    lstCustomEmote: TTntListBox;
    Panel2: TPanel;
    btnCustomEmoteAdd: TTntButton;
    btnCustomEmoteRemove: TTntButton;
    btnCustomEmoteClear: TTntButton;
    Panel3: TPanel;
    TntLabel1: TTntLabel;
    txtEmoteFilename: TTntEdit;
    TntLabel2: TTntLabel;
    txtEmoteText: TTntEdit;
    TntLabel3: TTntLabel;
    txtCustomEmoteFilename: TTntEdit;
    btnCustomEmoteBrowse: TTntButton;
    XMLDialog1: TOpenDialog;
    procedure btnEmoteAddClick(Sender: TObject);
    procedure btnEmoteRemoveClick(Sender: TObject);
    procedure btnEmoteClearClick(Sender: TObject);
    procedure btnEmoteDefaultClick(Sender: TObject);
  private
    { Private declarations }
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
    XMLTag, XMLParser, Emote, GnuGetText, ExUtils, Session, PrefController;

{---------------------------------------}
procedure TfrmPrefEmote.LoadPrefs();
var
    i: integer;
    mt, path, fn: Widestring;
    parser: TXMLTagParser;
    o, t, icon, doc: TXMLTag;
    icons: TXMLTagList;
begin
    inherited;
    MainSession.Prefs.fillStringlist('emoticon_dlls', lstEmotes.Items);

    // XXX: load custom emoticons
    fn := txtCustomEmoteFilename.Text;
    path := ExtractFilePath(fn);
    if (path = '') then begin
        path := PrefController.getUserDir();
        fn := path + ExtractFileName(fn);
        txtCustomEmoteFilename.Text := fn;
    end;

    pageEmotes.TabIndex := 0;

    {
    /// XXX: finish custom emotes
    try
        parser := TXMLTagParser.Create();
        parser.ParseFile(fn);
        doc := parser.popTag();
        if (doc = nil) then exit;

        icons := doc.QueryTags('icon');
        for i = 0 to icons.Count - 1 do begin
            icon := icons[i];
            o := icon.GetFirstTag('object');
            t := icon.GetFirstTag('text');
            if ((o <> nil) and (t <> nil)) then begin
                mt := o.getAttribute('mime');

                // image/gif
                // image/x-ms-bmp
                // image/jpeg
                // image/png
                if ((mt = 'image/gif') or (mt = 'image/x-ms-bmp')) then begin
                    // these are ok.

                end;

            end;
        end;

    finally
        if (doc <> nil) then doc.Free();
        parser.Free();
    end;
    }

end;

{---------------------------------------}
procedure TfrmPrefEmote.SavePrefs();
begin
    inherited;
    MainSession.Prefs.setStringlist('emoticon_dlls', lstEmotes.Items);

    // Reload our lists.
    InitializeEmoticonLists();

    // XXX: save custom emoticons
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
    lstEmotes.Items.Add('msn_emoticons.dll');
    lstEmotes.Items.Add('yahoo_emoticons.dll');
end;

end.
