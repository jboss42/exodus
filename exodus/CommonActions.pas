unit CommonActions;

interface

uses Exodus_TLB, ExActions;

type
    TRenameItemAction = class(TExBaseAction)
    private
        constructor Create();

    public
        destructor Destroy(); override;

        procedure execute(const items: IExodusItemList); override;

    end;

implementation

uses DisplayName, ExActionCtrl, gnugettext, GroupParser, InputPassword,
        Session, SysUtils;

const
    sRenameTitle: Widestring = 'Rename %s';
    sRenameText: Widestring = 'New name for this %s: ';

constructor TRenameItemAction.Create();
begin
    inherited Create('{000-exodus.googlecode.com}-090-rename');

    Set_Caption(_('Rename...'));
    Set_Enabled(true);
end;
destructor TRenameItemAction.Destroy;
begin
    inherited;
end;

procedure TRenameItemAction.execute(const items: IExodusItemList);
var
    parser: TGroupParser;
    dnc: TDisplayNameCache;
    idx: Integer;
    itemCtrl: IExodusItemController;
    subitems: IExodusItemList;
    item, grp: IExodusItem;
    name, path: Widestring;
begin
    if items.Count <> 1 then exit;

    item := items.Item[0];
    if (item.Type_ = 'group') then begin
        //This is effectively a group move
        parser := TGroupParser.Create(MainSession);
        name := parser.GetGroupName(item.UID);

        if not InputQueryW(
                WideFormat(_(sRenameTitle), [item.Type_]),
                WideFormat(_(sRenameText), [item.Type_]),
                name) then
            exit;
                
        path := parser.GetGroupParent(item.UID) + parser.Separator + name;
        itemCtrl := MainSession.ItemController;
            
        //move subitems to new group
        subitems := itemCtrl.GetGroupItems(item.UID);
        for idx := 0 to subitems.Count - 1 do begin
            itemCtrl.MoveItem(subitems.Item[idx].UID, item.UID, path);
        end;

        //delete group
        itemCtrl.RemoveItem(item.UID);
    end
    else begin
        //This updates the displayname cache
        name := item.value['Name'];

        if not InputQueryW(
                WideFormat(_(sRenameTitle), [item.Type_]),
                WideFormat(_(sRenameText), [item.Type_]),
                name) then
            exit;

        dnc := getDisplayNameCache();
            
        item.value['Name'] := name;
        dnc.UpdateDisplayName(item);
    end;
end;

procedure RegisterActions();
var
    actCtrl: IExodusActionController;
    act: IExodusAction;
begin
    actCtrl := GetActionController();

    act := TRenameItemAction.Create();
    actCtrl.registerAction('', act);
    actCtrl.addEnableFilter('', act.Name, 'selection=single');
end;

initialization
    RegisterActions();

end.
