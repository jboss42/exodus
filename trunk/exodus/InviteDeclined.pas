unit InviteDeclined;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ExForm, XMLTag, DisplayName, JabberID,
  StdCtrls,
  TntStdCtrls, ExtCtrls, TntExtCtrls;

type
  TFrmInviteDeclined = class(TExForm)
    lblDeclined: TTntLabel;
    lblReason: TTntLabel;
    TntPanel1: TTntPanel;
    TntButton1: TTntButton;
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure TntButton1Click(Sender: TObject);
  private
    _dnListener: TDisplayNameListener;
    _ToJID: TJabberID;
    _RoomJID: TJabberID;
  public
    procedure InitializeFromPacket(DeclinePacket: TXMLTag);
    procedure OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
  end;

implementation
{$R *.dfm}
uses
    JabberConst;
const
    sDECLINE_DESC1 = 'Your invitation to ';
    sDECLINE_DESC2 = ' to join the room ';
    sDECLINE_DESC3 = ' was declined.';
    sNO_REASON = 'No reason given.';
    sREASON = 'Reason for declining: ';
    
{
  Decline packet via XEP-45
    <message
        from='darkcave@macbeth.shakespeare.lit'
        to='crone1@shakespeare.lit/desktop'>
        <x xmlns='http://jabber.org/protocol/muc#user'>
            <decline from='hecate@shakespeare.lit'>
                <reason>
                    Sorry, I'm too busy right now.
                </reason>
            </decline>
        </x>
    </message>
}
procedure TFrmInviteDeclined.InitializeFromPacket(DeclinePacket: TXMLTag);
var
    ttag: TXMLTag;
begin
    Self.AutoSize := false;
    //if already in the room ignore invite
    ttag := DeclinePacket.QueryXPTag('/message/x[@xmlns="' + XMLNS_MUCUSER + '"]/decline');
    //bail if we somehow got a non muc invite message
    if (ttag = nil) then exit;

    //various labels
    _RoomJID := TJabberID.Create(DeclinePacket.getAttribute('from'));
    _ToJID := TJabberID.Create(ttag.GetAttribute('from'));

    Self.lblDeclined.Caption := sDECLINE_DESC1 + _DNListener.getDisplayName(_toJID) +
                                sDECLINE_DESC2 + _RoomJID.userDisplay + sDECLINE_DESC3;
    Self.lblReason.Caption := ttag.GetBasicText('reason');
    if (Self.lblReason.Caption = '') then
        Self.lblReason.Caption := sNO_REASON;
    Self.lblReason.Caption := sREASON + Self.lblReason.Caption;
end;

procedure TFrmInviteDeclined.TntButton1Click(Sender: TObject);
begin
    inherited;
    Close();
end;

procedure TFrmInviteDeclined.TntFormCreate(Sender: TObject);
begin
    inherited;
    _dnListener := TDisplayNameListener.Create(false); //use this listener to get all DN events
    _dnListener.OnDisplayNameChange := Self.OnDisplayNameChange;
    _ToJID := nil;
    _RoomJID := nil;
end;

procedure TFrmInviteDeclined.TntFormDestroy(Sender: TObject);
begin
    inherited;
    _DNListener.Free();
    if (_ToJID <> nil) then
    begin
        _ToJID.Free();
        _RoomJID.Free();
    end;
end;

procedure TFrmInviteDeclined.OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
begin
    if (_ToJID <> nil) and (_ToJID.jid = bareJID) then
        Self.lblDeclined.Caption := sDECLINE_DESC1 + _DNListener.getDisplayName(_toJID) +
                                    sDECLINE_DESC2 + _RoomJID.userDisplay + sDECLINE_DESC3;

end;

end.
