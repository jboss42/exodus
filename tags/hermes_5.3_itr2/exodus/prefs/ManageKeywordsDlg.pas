unit ManageKeywordsDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExForm,
  Dialogs, StdCtrls, TntStdCtrls, TntForms, ExFrame, ExBrandPanel;

type
  TManageKeywordsDlg = class(TExForm)
    pnlVerbiage: TExBrandPanel;
    TntLabel1: TTntLabel;
    chkRegex: TTntCheckBox;
    Label1: TTntLabel;
    ExBrandPanel1: TExBrandPanel;
    memKeywords: TTntMemo;
    btnOK: TTntButton;
    btnCancel: TTntButton;
    procedure btnOKClick(Sender: TObject);
    procedure memKeywordsKeyPress(Sender: TObject; var Key: Char);
    procedure TntFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure loadPrefs();
    procedure savePrefs();
  end;

implementation

{$R *.dfm}
uses
    PrefController, PrefFile, Session, JabberUtils, GnuGetText, RegExpr,
    Keywords, ExUtils;

procedure TManageKeywordsDlg.TntFormCreate(Sender: TObject);
begin
    inherited;
    AssignUnicodeFont(memKeywords.Font, 10);
    AssignUnicodeFont(Self);
    TranslateComponent(Self);

    loadPrefs();
end;

procedure TManageKeywordsDlg.btnOKClick(Sender: TObject);
begin
    inherited;
    savePrefs();
end;

procedure TManageKeywordsDlg.loadPrefs();
var
    s: TPrefState;
begin
    // load prefs from the reg.
    with MainSession.Prefs do begin
        s := getPrefState('regex_keywords');
        // Keywords
        fillStringList('keywords', memKeywords.Lines);

        chkRegex.Checked := getBool('regex_keywords');
        chkRegex.Visible := (s <> psInvisible);
        chkRegex.Enabled := (s <> psReadOnly);
   end;
end;

procedure TManageKeywordsDlg.memKeywordsKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
    if ((Key = '(') or (Key = ')') or (Key = '[') or
        (Key = ']') or (Key = '*') or (Key = '+') or
        (Key = '\') or (Key = '?') or (Key = '.') or
        (Key = '"')) then  begin
           MessageDlgW(_('The following characters should not be used: ( ) [ ] * + \ ?.'), mtError, [mbOK], 0);
           Key := #0;
         end;

end;

procedure TManageKeywordsDlg.savePrefs();
var
  kw_expr : TRegExpr;
begin
    with (MainSession.Prefs) do begin
        setStringList('keywords', memKeywords.Lines);
        setBool('regex_keywords', chkRegex.Checked);
        kw_expr := CreateKeywordsExpr(true); //Try to create/compile Keyword expression
        FreeAndNil(kw_expr);
    end;
end;

end.
