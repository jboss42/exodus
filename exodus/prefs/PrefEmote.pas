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
  Dialogs, PrefPanel, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls;

type
  TfrmPrefEmote = class(TfrmPrefPanel)
    pnlCustomPresButtons: TPanel;
    btnEmoteAdd: TTntButton;
    btnEmoteRemove: TTntButton;
    btnEmoteClear: TTntButton;
    btnEmoteDefault: TTntButton;
    lstEmotes: TTntListBox;
    Panel1: TPanel;
    chkEmoticons: TTntCheckBox;
    Label1: TTntLabel;
    EmoteOpen: TOpenDialog;
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
    Emote, GnuGetText, ExUtils, Session, PrefController;

{---------------------------------------}
procedure TfrmPrefEmote.LoadPrefs();
begin
    inherited;
    MainSession.Prefs.fillStringlist('emoticon_dlls', lstEmotes.Items);
end;

{---------------------------------------}
procedure TfrmPrefEmote.SavePrefs();
begin
    inherited;
    MainSession.Prefs.setStringlist('emoticon_dlls', lstEmotes.Items);

    // Reload our lists.
    InitializeEmoticonLists();
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
