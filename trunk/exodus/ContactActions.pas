unit ContactActions;

interface

uses Exodus_TLB, ExActions;

type
    TAddContactAction = class(TExBaseAction)
    private
        constructor Create;

    public
        procedure execute(const items: IExodusItemList); override;
        
    end;

    TSendContactsAction = class(TExBaseAction)
    private
        constructor Create;

    public
        procedure execute(const items: IExodusItemList); override;
        
    end;
    TBlockContactAction = class(TExBaseAction)
    private
        constructor Create;

    public
        procedure execute(const items: IExodusItemList); override;
        
    end;
    TUnblockContactAction = class(TExBaseAction)
    private
        constructor Create;

    public
        procedure execute(const items: IExodusItemList); override;
        
    end;

implementation

uses Classes, ExActionCtrl, ExUtils, gnugettext, JabberID, SelectItem,
    Session, RosterAdd;

constructor TAddContactAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-000-add-contact');

    Set_Caption(_('Add Contact'));
    Set_Enabled(true);
end;
procedure TAddContactAction.execute(const items: IExodusItemList);
begin
    ShowAddContact();
end;

constructor TSendContactsAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-060-send-contacts');

    Set_Caption(_('Send contacts to...'));
    Set_Enabled(true);
end;

procedure TSendContactsAction.execute(const items: IExodusItemList);
var
    idx: Integer;
    item: IExodusItem;
    subjects: TList;
    target: Widestring;
begin

    target := SelectUIDByType('contact', _('Select Contacts Recipient'));
    if (target <> '') then begin
        subjects := TList.Create;

        for idx := 0 to items.Count - 1 do begin
            item := items.Item[idx];
            subjects.Add(Pointer(item));
        end;

        jabberSendRosterItems(target, subjects);
    end;
end;

{
}
constructor TBlockContactAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-080-block-contact');

    Set_Caption(_('Block'));
    Set_Enabled(true);
end;

procedure TBlockContactAction.execute(const items: IExodusItemList);
var
    idx: Integer;
    item: IExodusItem;
    jid: TJabberID;
begin
    for idx := 0 to items.Count - 1 do begin
        item := items.Item[idx];
        jid := TJabberID.Create(item.UID);
        MainSession.Block(jid);
        jid.Free;
    end;
end;

{
}
constructor TUnblockContactAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-080-unblock-contact');

    Set_Caption(_('Unblock'));
    Set_Enabled(true);
end;

procedure TUnblockContactAction.execute(const items: IExodusItemList);
var
    idx: Integer;
    item: IExodusItem;
    jid: TJabberID;
begin
    for idx := 0 to items.Count - 1 do begin
        item := items.Item[idx];
        jid := TJabberID.Create(item.UID);
        MainSession.UnBlock(jid);
        jid.Free;
    end;
end;

{
}
procedure RegisterActions();
var
    actCtrl: IExodusActionController;
    act: IExodusAction;
begin
    actCtrl := GetActionController();

    //Setup add contact
    act := TAddContactAction.Create() as IExodusAction;
    actCtrl.registerAction('{create}', act);

    //Setup send contacts
    act := TSendContactsAction.Create() as IExodusAction;
    actCtrl.registerAction('contact', act);

    //Setup block contact
    act := TBlockContactAction.Create() as IExodusAction;
    actCtrl.registerAction('contact', act);
    actCtrl.addEnableFilter('contact', act.Name, 'blocked=false');
    actCtrl.addEnableFilter('contact', act.Name, 'selection=single');

    //Setup unblock contact
    act := TUnblockContactAction.Create() as IExodusAction;
    actCtrl.registerAction('contact', act);
    actCtrl.addEnableFilter('contact', act.Name, 'blocked=true');
    actCtrl.addEnableFilter('contact', act.Name, 'selection=single');
end;


initialization
    RegisterActions();

end.
