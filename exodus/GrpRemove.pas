unit GrpRemove;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, buttonFrame, StdCtrls;

type
  TfrmGrpRemove = class(TForm)
    frameButtons1: TframeButtons;
    optMove: TRadioButton;
    cboNewGroup: TComboBox;
    optNuke: TRadioButton;
    chkUnsub: TCheckBox;
    chkUnsubed: TCheckBox;
    procedure frameButtons1btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ct_list: TList;
  end;

var
  frmGrpRemove: TfrmGrpRemove;

procedure RemoveGroup(grp: string; contacts: TList = nil);

implementation

{$R *.dfm}
uses
    XMLTag, IQ, Session, S10n;

procedure RemoveGroup(grp: string; contacts: TList = nil);
var
    f: TfrmGrpRemove;
begin
    // Either remove a grp, or a bunch of contacts

    f := TfrmGrpRemove.Create(nil);

    with f do begin
        if (contacts <> nil) then begin
            optMove.Enabled := false;
            cboNewGroup.Enabled := false;
            optNuke.Checked := true;
            end
        else begin
            cboNewGroup.Items.Assign(MainSession.Roster.GrpList);
            cboNewGroup.Items.Delete(cboNewGroup.Items.IndexOf(grp));
            end;
        ct_list.Assign(contacts);
        Show();
        end;
end;

procedure TfrmGrpRemove.frameButtons1btnOKClick(Sender: TObject);
var
    iq: TXMLTag;
begin
    {
    if (optNuke.Checked) then begin
        // Remove the people from my roster

        if (chkRemove1.Checked) and (chkRemove2.Checked) then begin
            // send a subscription='remove'
            iq := TXMLTag.Create('iq');
            with iq do begin
                PutAttribute('type', 'set');
                PutAttribute('id', MainSession.generateID);
                with AddTag('query') do begin
                    PutAttribute('xmlns', XMLNS_ROSTER);
                    with AddTag('item') do begin
                        PutAttribute('jid', lblJID.Caption);
                        PutAttribute('subscription', 'remove');
                        end;
                    end;
                end;
            MainSession.SendTag(iq);
            end
        else if chkRemove1.Checked then begin
            // send an unsubscribe
            SendUnSubscribe(lblJID.Caption, MainSession);
            end
        else if chkRemove2.Checked then begin
            // send an unsubscribed
            SendUnSubscribed(lblJID.Caption, MainSession);
            end;
        end
    else begin
        // Move all contacts in this group to the new group
        end;
    Self.Close;
    }
end;

end.
