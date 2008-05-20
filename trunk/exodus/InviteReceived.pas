unit InviteReceived;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Dockable, ComCtrls, ToolWin, ExtCtrls, StdCtrls, TntStdCtrls,
  ExForm,
  XMLTag,
  JabberID,
  Session,
  DisplayName,
  TntExtCtrls, ExBrandPanel, ExGroupBox;

type
  TfrmInviteReceived = class(TExForm)
    pnlHeader: TFlowPanel;
    lblInvitor: TTntLabel;
    lblFiller1: TTntLabel;
    lblRoom: TTntLabel;
    TntLabel1: TTntLabel;
    TntPanel4: TTntPanel;
    btnAccept: TTntButton;
    btnDecline: TTntButton;
    btnIgnore: TTntButton;
    ExGroupBox1: TExGroupBox;
    lblInviteMessage: TTntLabel;
    ExGroupBox2: TExGroupBox;
    txtReason: TTntEdit;
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
    procedure btnIgnoreClick(Sender: TObject);
    procedure btnDeclineClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure lblInvitorClick(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);

    procedure WMNCActivate(var msg: TMessage); message WM_NCACTIVATE;
  private
    _dnListener: TDisplayNameEventListener;
    _InvitePacket: TXMLTag;
    _FromJID: TJabberID;
    _RoomJID: TJabberID;
    
    procedure InitializeFromTag(InvitePacket: TXMLTag);
  published
    procedure OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
  end;

    procedure OnSessionStart(Session: TJabberSession);
    procedure OnSessionEnd();

implementation

{$R *.dfm}
uses
    GnuGetText,
    Room,
    Unicode,
    JabberConst,
    Notify,
    ExUtils,
    ChatWin,
    Contnrs;
const
    LEFT_OFFSET = 30;
    TOP_OFFSET = 30;

    sDEFAULT_DECLINE_REASON = 'Sorry, I am not interested in joining right now.';

type

    TDisconnectEvent = procedure(ForcedDisconnect: boolean; Reason: WideString) of object;
    TAuthenticatedEvent = procedure () of object;

    TFrmDecline = class(TExForm)

    end;


    {------------------------ TSessionListener --------------------------------}
    TSessionListener = class
    private
        _OnAuthEvent: TAuthenticatedEvent;
        _OnDisconnectEvent: TDisconnectEvent;
        _Session: TJabberSession;

        _ReceivedError: WideString;
        _Authenticated: Boolean;

        _SessionCB: integer;
    protected
        procedure SetSession(JabberSession: TJabberSession);virtual;
        procedure FireAuthenticated(); virtual;
        procedure FireDisconnected(); virtual;
    public
        Constructor Create(JabberSession: TJabberSession);
        Destructor Destroy(); override;

        procedure SessionListener(event: string; tag: TXMLTag);

        property OnAuthenticated: TAuthenticatedEvent read _OnAuthEvent write _OnAuthEvent;
        property OnDisconnected: TDisconnectEvent read _OnDisconnectEvent write _OnDisconnectEvent;
        property Session: TJabberSession read _Session write SetSession;
    end;


    TInvitePos = class
        _Left: integer;
        _Top: integer;
        _Frm: TForm;
    end;

    TWindowPosHelper = class
    private
        _TrackedWindows: TObjectList; //of TInvitePos
        _InitialPos: TPoint;
                
        function IndexOf(frm: TForm): integer;
    public
        Constructor Create();
        Destructor Destroy; override;

        function GetNextPos(frm: TForm): TPoint;
        procedure AddWindow(frm: TForm);
        procedure RemoveWindow(frm: TForm);
        procedure SetInitialPosition(p: TPoint);
    end;

    TInviteHandler = class
    private
        _Session: TJabberSession;   //current session
        _OpenReceivedList: TWideStringList; //list of open invites by room
        _ReceivedPosHelper: TWindowPosHelper;

        _SessionListener: TSessionListener;

        _InviteCB: Integer;

        procedure OnAuthenticated();
        procedure OnDisconnected(ForcedDisconnect: boolean; Reason: WideString);

        procedure SetSession(JabberSession: TJabberSession);

        procedure ShowInviteReceived(InvitePacket: TXMLTag);
        
        function IndexOfForm(frm: TForm): integer;
    public
        Constructor Create(JabberSession: TJabberSession);
        Destructor Destroy(); override;

        procedure AddWindow(frm: TForm);
        procedure RemoveWindow(frm: TForm);

        property Session: TJabberSession read _Session write SetSession;

        procedure InviteCallback(event: string; InvitePacket: TXMLTag);

        //invite form event handlers
        procedure OnFormClose(Sender: TObject; var Action: TCloseAction);
    end;


var
    _InviteHandler : TInviteHandler;

{Event fired indicating session object is created and ready}
procedure OnSessionStart(Session: TJabberSession);
begin
    if (_InviteHandler <> nil) then
    begin
        _InviteHandler.free();
        _InviteHandler := nil;
    end;
    if (Session <> nil) then
        _InviteHandler := TInviteHandler.create(Session);
end;

{Session object is being destroyed. Still valid for this call but not after}
procedure OnSessionEnd();
begin
    if (_InviteHandler <> nil) then
    begin
        _InviteHandler.free();
        _InviteHandler := nil;
    end;
end;

procedure TSessionListener.SetSession(JabberSession: TJabberSession);
begin
    if (_Session <> nil) then
    begin
        if (_SessionCB <> -1) then        begin
            _Session.UnRegisterCallback(_SessionCB);
            _SessionCB := -1;
        end;
    end;
    _Session := JabberSession;
    if (_Session <> nil) then
    begin
        _SessionCB := _Session.RegisterCallback(SessionListener, '/session');
        _Authenticated := _Session.Authenticated;
    end;
end;

procedure TSessionListener.FireAuthenticated();
begin
    if (Assigned(_OnAuthEvent)) then
        _OnAuthEvent();
end;

procedure TSessionListener.FireDisconnected();
begin
    if (Assigned(_OnDisconnectEvent)) then
        _OnDisconnectEvent((_ReceivedError <> ''), _ReceivedError);
end;

procedure TSessionListener.SessionListener(event: string; tag: TXMLTag);
begin
    if (event = '/session/authenticated') then
    begin
        _Authenticated := true;
        _ReceivedError := '';
        FireAuthenticated();
    end
    else if ((event = '/session/disconnected') and _Authenticated) then
    begin
        FireDisconnected();
        _Authenticated := false;
    end
    else if (event = '/session/commerror') then
    begin
        _ReceivedError := 'Comm Error';
    end;
end;

Constructor TSessionListener.Create(JabberSession: TJabberSession);
begin
    _Authenticated := false;
    _ReceivedError := '';
    _SessionCB := -1;
    SetSession(JabberSession);
end;

Destructor TSessionListener.Destroy();
begin
    SetSession(nil);
end;

procedure TWindowPosHelper.SetInitialPosition(p: TPoint);
begin
    _InitialPos := p;
end;

function TWindowPosHelper.IndexOf(frm: TForm): integer;
begin
    for Result := 0 to _TrackedWindows.Count - 1 do
    begin
        if (TInvitePos(_TrackedWindows[Result])._Frm = frm) then
            exit;
    end;
    Result := -1;
end;

Constructor TWindowPosHelper.Create();
begin
    _TrackedWindows := TObjectList.create();
    _InitialPos.X := 0;
    _InitialPos.Y := 0;
end;

Destructor TWindowPosHelper.Destroy;
begin
    _TrackedWindows.free();
end;

function TWindowPosHelper.GetNextPos(frm: TForm): TPoint;
var
    oneTI: TInvitePos;
begin
    Result.X := -1;
    Result.Y := -1;
    if (_TrackedWindows.Count = 0) then
    begin
        Result := _InitialPos;//(frm.Monitor.Width div 2) - (frm.Width div 2);
        //Result.Y := (frm.Monitor.Height div 2) - (frm.Height div 2);
    end
    else begin
        oneTI := TInvitePos(_TrackedWindows[_TrackedWindows.Count - 1]);
        Result.X := oneTI._Left + LEFT_OFFSET;
        Result.Y := oneTI._Top + TOP_OFFSET;
    end;

    if (((Result.X + frm.Width) > frm.Monitor.Width) or
        ((Result.Y + frm.Height) > frm.Monitor.Height)) then
    begin
        Result.X := _InitialPos.X + LEFT_OFFSET;
        Result.Y := _InitialPos.Y;
    end;
end;

procedure TWindowPosHelper.AddWindow(frm: TForm);
var
    ti : TInvitePos;
    i: integer;
begin
    i := IndexOf(frm);
    if (i = -1) then begin
        ti := TInvitePos.Create();
        ti._Frm := frm;
        ti._Left := frm.Left;
        ti._Top := frm.Top;
        _TrackedWindows.Add(ti)
    end;
end;

procedure TWindowPosHelper.RemoveWindow(frm: TForm);
var
    i: integer;
begin
    i := IndexOf(frm);
    if (i <> -1) then
        _TrackedWindows.Delete(i);
end;

procedure TInviteHandler.OnAuthenticated();
begin

end;

procedure TInviteHandler.OnDisconnected(ForcedDisconnect: boolean; Reason: WideString);
var
    i: Integer;
begin
    for i := _OpenReceivedList.Count - 1 downto 0 do
        TForm(_OpenReceivedList.Objects[i]).Close();
end;


{ Invite packet via XEP-45:
    <message
        from='darkcave@macbeth.shakespeare.lit'
        to='hecate@shakespeare.lit'>
      <x xmlns='http://jabber.org/protocol/muc#user'>
        <invite from='crone1@shakespeare.lit/desktop'>
          <reason>
            Hey Hecate, this is the place for all good witches!
          </reason>
        </invite>
        <password>cauldronburn</password>
      </x>
    </message>

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

procedure TInviteHandler.SetSession(JabberSession: TJabberSession);
begin
    //reassigning session, remove any existing listeners
    if (_Session <> nil) then
    begin
        if (_InviteCB <> -1) then
        begin
            _Session.UnRegisterCallback(_InviteCB);
            _InviteCB := -1;
        end;
    end;

    _Session := JabberSession;
    
    if (_Session <> nil)  then
    begin
        _InviteCB := _Session.RegisterCallback(InviteCallback,
                                               '/packet/message/x[@xmlns="' + XMLNS_MUCUSER + '"]/invite');
                                               
    end;
    _SessionListener.Session := JabberSession;
end;

Constructor TInviteHandler.Create(JabberSession: TJabberSession);
begin
    _InviteCB := -1;

    _OpenReceivedList := TWideStringList.Create();

    _ReceivedPosHelper := nil;

    _SessionListener := TSessionListener.create(nil);
    _SessionListener.OnAuthenticated := Self.OnAuthenticated;
    _SessionListener.OnDisconnected := Self.OnDisconnected;

    Self.Session := JabberSession;
end;


Destructor TInviteHandler.Destroy();
begin
    _OpenReceivedList.Free();
    _ReceivedPosHelper.Free();
    
    Session := nil;
    _SessionListener.Free();
end;

procedure JoinRoom(InvitePacket: TXMLTag);
var
    pw: WideString; //password if it exists
    RoomName: WideString;
    ttag: TXMLTag;
begin
    ttag := InvitePacket.QueryXPTag('/message/x[@xmlns="' + XMLNS_MUCUSER + '"]/invite');
    //bail if we somehow got a non muc invite message
    if (ttag = nil) then exit;
    RoomName := InvitePacket.getAttribute('from');
    //password
    ttag := InvitePacket.QueryXPTag('/message/x[@xmlns="' + XMLNS_MUCUSER + '"]');
    pw := ttag.GetBasicText('password');
    //jid, nick, pw, presence, default config, registered nick, bring to front
    StartRoom(RoomName, '', pw, True, False, True, True);
end;


procedure TInviteHandler.InviteCallback(event: string; InvitePacket: TXMLTag);
begin
    if (Session.prefs.getBool('auto_join_on_invite')) then
        JoinRoom(InvitePacket)
    else
        ShowInviteReceived(InvitePacket);
end;

procedure TInviteHandler.ShowInviteReceived(InvitePacket: TXMLTag);
var
    from: widestring;
    frm: TfrmInviteReceived;
    p: TPoint;
begin

    from := InvitePacket.getAttribute('from');
    //only one invite per room should be shown
    if (_OpenReceivedList.IndexOf(from) = -1) then begin
        frm := TfrmInviteReceived.Create(Application);
        _OpenReceivedList.AddObject(from, frm);
        if (_ReceivedPosHelper = nil) then
        begin
            _ReceivedPosHelper := TWindowPosHelper.create();
            p.X := (frm.Monitor.Width div 2) - (frm.Width div 2);
            p.Y := (frm.Monitor.Height div 2) - (frm.Height div 2);
            _ReceivedPosHelper.SetInitialPosition(p);
        end;
        p := _ReceivedPosHelper.GetNextPos(frm);
        frm.Left := p.X;
        frm.Top := P.Y;
        frm.OnClose := Self.OnFormClose;
    end
    else
        frm := TfrmInviteReceived(_OpenReceivedList.Objects[_OpenReceivedList.IndexOf(from)]);
    frm.InitializeFromTag(InvitePacket);
    frm.Show();
    _ReceivedPosHelper.AddWindow(frm);
    Notify.DoNotify(Application.Mainform, 'notify_invite', 'You have received an invitation to join ' + frm.lblRoom.Caption, 0);
end;

procedure TInviteHandler.OnFormClose(Sender: TObject; var Action: TCloseAction);
begin
    if (Sender is TForm) then
        RemoveWindow(TForm(Sender));
    inherited;
end;

function TInviteHandler.IndexOfForm(frm: TForm): integer;
begin
    if (frm is TFrmInviteReceived) then
    begin
        for Result  := 0 to _OpenReceivedList.Count - 1 do
        begin
            if (_OpenReceivedList.Objects[Result] = frm) then
                exit;
        end;
    end;
    Result := -1;
end;

procedure TInviteHandler.AddWindow(frm: TForm);
begin
end;

procedure TInviteHandler.RemoveWindow(frm: TForm);
var
    i: integer;
begin
    if (frm is TFrmInviteReceived) then begin
        _ReceivedPosHelper.RemoveWindow(frm);
        i := IndexOfForm(frm);
        if (i <> -1) then
            _OpenReceivedList.Delete(i);
    end
end;

procedure TfrmInviteReceived.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    inherited;
    Action := caFree;
end;

procedure TfrmInviteReceived.TntFormCreate(Sender: TObject);
begin
    inherited;
    _dnListener := TDisplayNameEventListener.Create(); 
    _dnListener.OnDisplayNameChange := Self.OnDisplayNameChange;
    _FromJID := nil;
    _InvitePacket := nil;
    _RoomJID := nil;
    URLLabel(Self.lblInvitor);
end;

procedure TfrmInviteReceived.TntFormDestroy(Sender: TObject);
begin
    inherited;
    _DNListener.Free();
    if (_InvitePacket <> nil) then
        _InvitePacket.Free();
    if (_FromJID <> nil) then
        _FromJID.free();
    if (_RoomJID <> nil) then
        _RoomJID.free();
end;

procedure TfrmInviteReceived.WMNCActivate(var msg: TMessage);
begin
    if (Msg.WParamLo <> WA_INACTIVE) then
        StopFlash(Application.MainForm);
    inherited;
end;

procedure TfrmInviteReceived.TntFormShow(Sender: TObject);
begin
    inherited;
    //force some alignment
    Self.lblInviteMessage.AutoSize := false;
    Self.lblInviteMessage.AutoSize := true;
    Self.ExGroupBox1.AutoSize := false;
    Self.ExGroupBox1.AutoSize := true;
    Self.AutoSize := false;
    Self.AutoSize := true;
end;

procedure TfrmInviteReceived.btnAcceptClick(Sender: TObject);
begin
    JoinRoom(_InvitePacket);
    inherited;
    Close();
end;

{ decline packet via XEP-45
<message
    from='hecate@shakespeare.lit/broom'
    to='darkcave@macbeth.shakespeare.lit'>
  <x xmlns='http://jabber.org/protocol/muc#user'>
    <decline to='crone1@shakespeare.lit'>
      <reason>
        Sorry, I'm too busy right now.
      </reason>
    </decline>
  </x>
</message>
}

procedure TfrmInviteReceived.btnDeclineClick(Sender: TObject);
var
    mTag: TXmlTag;
    tTag: TXMLTag;
    reason: Widestring;
begin
    inherited;
    // send back a decline message.
    mTag := TXmlTag.Create('message');
    mTag.setAttribute('to', _RoomJID.jid);
    tTag := mTag.AddTag('x');
    tTag.setAttribute('xmlns', XMLNS_MUCUSER);
    tTag := tTag.AddTag('decline');
    tTag.setAttribute('to', _FromJID.jid);
    reason := Self.txtReason.Text;
    if (reason = '') then
        reason := sDEFAULT_DECLINE_REASON;
    tTag.AddBasicTag('reason', reason);

    MainSession.SendTag(mTag); //frees mTag

    Close();
end;

procedure TfrmInviteReceived.btnIgnoreClick(Sender: TObject);
begin
    inherited;
    Close();
end;

procedure TfrmInviteReceived.OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
begin
    Self.lblInvitor.Caption := DisplayName;
    //force some alignment
    Self.lblInviteMessage.AutoSize := false;
    Self.lblInviteMessage.AutoSize := true;
    Self.ExGroupBox1.AutoSize := false;
    Self.ExGroupBox1.AutoSize := true;
    Self.AutoSize := false;
    Self.AutoSize := true;
end;

procedure TfrmInviteReceived.InitializeFromTag(InvitePacket: TXMLTag);
var
    tJID: TJabberID;
    inviteMessage: widestring;
    ttag: TXMLTag;
begin
    Self.AutoSize := false;
    //if already in the room ignore invite
    ttag := InvitePacket.QueryXPTag('/message/x[@xmlns="' + XMLNS_MUCUSER + '"]/invite');
    //bail if we somehow got a non muc invite message
    if (ttag = nil) then exit;

    if (_invitePacket <> nil) then
        _InvitePacket.Free(); //in case we received a second invite to this room
    if (_FromJID <> nil) then
        _FromJID.free();

    _InvitePacket := TXMLTag.Create(InvitePacket); //copy for later use

    //various labels
    _RoomJID := TJabberID.Create(InvitePacket.getAttribute('from'));
    Self.lblRoom.Caption := DisplayName.getDisplayNameCache.getDisplayName(_RoomJID);
    Self.lblRoom.Hint := _RoomJID.getDisplayJID();
    Self.lblRoom.font.Style := Self.lblRoom.font.Style + [fsBold];

    tJID := TJabberID.Create(ttag.GetAttribute('from'));
    _FromJID := TJabberID.Create(tJID.jid); //bare JID
    Self.lblInvitor.Hint := tJID.getDisplayFull();
    _dnListener.UID := tJID.jid; //listen for DN changes from this JID only
    tJID.free();

    inviteMessage := ttag.GetBasicText('reason');
    if (InviteMessage <> '') then
        Self.lblInviteMessage.Caption := InviteMessage;
    Self.lblInvitor.Caption := DisplayName.getDisplayNameCache.getDisplayName(_FromJID);
end;

procedure TfrmInviteReceived.lblInvitorClick(Sender: TObject);
begin
    inherited;
    StartChat(_FromJID.jid, '', true);
end;

initialization
    _InviteHandler := nil;

finalization
    OnSessionEnd();
end.





