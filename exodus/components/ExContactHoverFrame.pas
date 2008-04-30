unit ExContactHoverFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExFrame, StdCtrls, ExtCtrls, ExGraphicButton, Exodus_TLB, ActnList,
  ExBrandPanel, ExGroupBox, TntStdCtrls, Avatar;

type
  TExContactHoverFrame = class(TExFrame)
    lblDisplayName: TTntLabel;
    lblUID: TTntLabel;
    lblPhoneNumber: TTntLabel;
    btnRename: TExGraphicButton;
    btnDelete: TExGraphicButton;
    btnChat: TExGraphicButton;
    imgPresence: TImage;
    lblPresence: TTntLabel;
    Separator2: TExGroupBox;
    Separator1: TExGroupBox;
    imgAvatar: TPaintBox;
    procedure TntFrameMouseLeave(Sender: TObject);
    procedure TntFrameMouseEnter(Sender: TObject);
    procedure InitControls(Item: IExodusItem);
    procedure btnChatClick(Sender: TObject);
    procedure TntFrameMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgAvatarMouseEnter(Sender: TObject);
    procedure imgAvatarMouseLeave(Sender: TObject);
    procedure lblPhoneNumberMouseLeave(Sender: TObject);
    procedure imgPresenceMouseEnter(Sender: TObject);
    procedure imgPresenceMouseLeave(Sender: TObject);
    procedure lblDisplayNameMouseEnter(Sender: TObject);
    procedure lblDisplayNameMouseLeave(Sender: TObject);
    procedure lblPresenceMouseEnter(Sender: TObject);
    procedure lblUIDMouseEnter(Sender: TObject);
    procedure lblUIDMouseLeave(Sender: TObject);
    procedure lblPhoneNumberMouseEnter(Sender: TObject);
    procedure lblPresenceMouseLeave(Sender: TObject);
    procedure btnChatMouseEnter(Sender: TObject);
    procedure btnChatMouseLeave(Sender: TObject);
    procedure btnRenameMouseEnter(Sender: TObject);
    procedure btnRenameMouseLeave(Sender: TObject);
    procedure btnDeleteMouseEnter(Sender: TObject);
    procedure btnDeleteMouseLeave(Sender: TObject);
    procedure imgAvatarPaint(Sender: TObject);
  private
    { Private declarations }
    _Items: IExodusItemList;
    _Avatar: TAvatar;
    _UnknownAvatar: TBitmap;
    _TypedActs: IExodusTypedActions;
    _ActMap: IExodusActionMap;
    
    //
    procedure _BuildActions();
    procedure _GetAvatar();
    procedure _GetPresence();
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;

  end;


implementation
uses ExItemHoverForm, ExForm, Session, Jabber1, Presence, COMExodusItemList,
     ExActionCtrl;

{$R *.dfm}

constructor TExContactHoverFrame.Create(AOwner: TComponent);
begin
    inherited;
    _Items := TExodusItemList.Create();
    _UnknownAvatar := TBitmap.Create();
    _TypedActs := nil;
    _ActMap := nil;
end;

procedure TExContactHoverFrame.InitControls(Item: IExodusItem);
begin
    _Items.Clear();
    _Items.Add(Item);
    
    Separator1.Caption := '';
    Separator2.Caption := '';
    lblDisplayName.Caption := Item.Text;
    lblUID.Caption := Item.UID;

    _GetAvatar();
    _GetPresence();
    _BuildActions();


end;

procedure TExContactHoverFrame._GetPresence();
var
    Pres: TJabberPres;
    Item: IExodusItem;
begin
    lblPresence.Caption := '';
    Item := _Items.Item[0];
    frmExodus.ImageList1.GetIcon(Item.ImageIndex, imgPresence.Picture.Icon);
    try
        lblPresence.Caption := DecodeShowDisplayValue(Item.value['show']);
    except
    end;
    Pres := MainSession.ppdb.FindPres(Item.uid, '');
    if (Pres <> nil) then
    begin
        if (MainSession.prefs.getBool('inline_status')) then
            lblPresence.Caption := lblPresence.Caption + ' - ' + Item.ExtendedText;
    end;
end;

procedure TExContactHoverFrame._BuildActions();
var
    Item: IExodusItem;
    Act: IExodusAction;
begin
    Item := _Items.Item[0];
    _ActMap := GetActionController().buildActions(_Items);
    _TypedActs := _ActMap.GetActionsFor('');
    
    Act := _TypedActs.GetActionNamed('{000-exodus.googlecode.com}-000-start-chat');
    btnChat.Tag := Integer(Pointer(Act));
    btnChat.Enabled := Act <> nil;
    if (Act <> nil) then btnChat.Caption := Act.Caption;
    btnChat.Caption := '     ' + btnChat.Caption;
    Act := _TypedActs.GetActionNamed('{000-exodus.googlecode.com}-150-rename');
    btnRename.Tag := Integer(Pointer(Act));
    btnRename.Enabled := Act <> nil;
    if (Act <> nil) then btnRename.Caption := Act.Caption;
    btnRename.Caption := '     ' + btnRename.Caption;
    Act := _TypedActs.GetActionNamed('{000-exodus.googlecode.com}-190-delete');
    btnDelete.Tag := Integer(Pointer(Act));
    btnDelete.Enabled := Act <> nil;
    if (Act <> nil) then btnDelete.Caption := Act.Caption;
    btnDelete.Caption := '     ' + btnDelete.Caption;

end;

procedure TExContactHoverFrame._GetAvatar();
var
    Avatar: TAvatar;
begin
    if (_UnknownAvatar.Empty) then
        frmExodus.bigImages.GetBitmap(0, _UnknownAvatar);
    _Avatar := nil;
    Avatar := Avatars.Find(_Items.Item[0].uid);
    if ((Avatar <> nil) and (Avatar.isValid())) then
    begin
        if (Avatar.Height >= 0) then
        begin
            _Avatar := Avatar;
            if (_Avatar.Height > 48) then
                imgAvatar.Width := Trunc((48 / _avatar.Height) * (_avatar.Width))
            else
                imgAvatar.Width := _avatar.Width;
        end;
    end;
end;

procedure TExContactHoverFrame.btnChatClick(Sender: TObject);
var
    act: IExodusAction;
begin
  act := IExodusAction(Pointer(btnChat.Tag));
  act.Execute(_Items);
end;

procedure TExContactHoverFrame.btnChatMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExContactHoverFrame.btnChatMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExContactHoverFrame.btnDeleteMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExContactHoverFrame.btnDeleteMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExContactHoverFrame.btnRenameMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExContactHoverFrame.btnRenameMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExContactHoverFrame.imgAvatarMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExContactHoverFrame.imgAvatarMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExContactHoverFrame.imgAvatarPaint(Sender: TObject);
var
    Rect: TRect;
begin
    inherited;
    if (_Avatar <> nil) then
    begin
        if (_Avatar.Height > imgAvatar.Height) then begin
            Rect.Top := 1;
            Rect.Left := 1;
            Rect.Bottom := imgAvatar.Height;
            Rect.Right := imgAvatar.Width;
            _Avatar.Draw(imgAvatar.Canvas, Rect);
        end
        else
            _Avatar.Draw(imgAvatar.Canvas);
    end
    else begin
        Rect.Top := 1;
        Rect.Left := 1;
        Rect.Bottom := 49;
        Rect.Right := 49;
        imgAvatar.Canvas.StretchDraw(Rect, _UnknownAvatar);
    end;
end;

procedure TExContactHoverFrame.imgPresenceMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExContactHoverFrame.imgPresenceMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExContactHoverFrame.TntFrameMouseEnter(Sender: TObject);
begin
  //inherited;
  //OutputDebugString(PChar('Contact MouseEnter'));
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExContactHoverFrame.TntFrameMouseLeave(Sender: TObject);
begin
   //OutputDebugString(PChar('Contact MouseLeave'));
   TExItemHoverForm(Parent).CancelHover();
end;

procedure TExContactHoverFrame.TntFrameMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  //OutputDebugString(PChar('Contact Mouse Move'));
end;


procedure TExContactHoverFrame.lblDisplayNameMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExContactHoverFrame.lblDisplayNameMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExContactHoverFrame.lblPhoneNumberMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExContactHoverFrame.lblPhoneNumberMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;


procedure TExContactHoverFrame.lblPresenceMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExContactHoverFrame.lblPresenceMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;

procedure TExContactHoverFrame.lblUIDMouseEnter(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).SetHover();
end;

procedure TExContactHoverFrame.lblUIDMouseLeave(Sender: TObject);
begin
  inherited;
  TExItemHoverForm(Parent).CancelHover();
end;


end.
