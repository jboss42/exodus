unit PrefSubscription;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, StdCtrls, ExtCtrls;

type
  TfrmPrefSubscription = class(TfrmPrefPanel)
    StaticText2: TStaticText;
    optIncomingS10n: TRadioGroup;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

var
  frmPrefSubscription: TfrmPrefSubscription;

implementation
{$R *.dfm}
uses
    Session;

procedure TfrmPrefSubscription.LoadPrefs();
begin
    optIncomingS10n.ItemIndex := MainSession.Prefs.getInt('s10n_auto_accept');
end;

procedure TfrmPrefSubscription.SavePrefs();
begin
    MainSession.Prefs.setInt('s10n_auto_accept', optIncomingS10n.ItemIndex);
end;


end.
