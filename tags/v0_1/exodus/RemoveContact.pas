unit RemoveContact;
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

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  buttonFrame, StdCtrls;

type
  TfrmRemove = class(TForm)
    lblJID: TStaticText;
    Label1: TLabel;
    chkRemove1: TCheckBox;
    frameButtons1: TframeButtons;
    chkRemove2: TCheckBox;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRemove: TfrmRemove;

procedure RemoveRosterItem(sjid: string);

implementation
uses
    S10n,
    Session,
    XMLTag;
{$R *.DFM}

procedure RemoveRosterItem(sjid: string);
var
    f: TfrmRemove;
begin
    f := TfrmRemove.Create(Application);
    with f do begin
        lblJID.Caption := sjid;
        Show;
        end;
end;


procedure TfrmRemove.frameButtons1btnOKClick(Sender: TObject);
var
    iq: TXMLTag;
begin
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
    Self.Close;
end;

procedure TfrmRemove.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TfrmRemove.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

end.
