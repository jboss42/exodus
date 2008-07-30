unit GroupActions;

interface

uses Exodus_TLB, ExActions;

type TAddGroupAction = class(TExBaseAction)
private
    constructor Create(id, caption: Widestring);
public
    destructor Destroy(); override;

    procedure execute(const items: IExodusItemList); override;
end;

implementation

uses ComServ, gnugettext, ExActionCtrl, ExUtils;

constructor TAddGroupAction.Create(id: Widestring; caption: Widestring);
begin
    inherited Create(id);

    set_Caption(caption);
    set_Enabled(true);
end;
destructor TAddGroupAction.Destroy;
begin
    inherited;
end;

procedure TAddGroupAction.execute(const items: IExodusItemList);
var
    base: Widestring;
begin
    if (items.Count = 1) then begin
        base := items.Item[0].UID;
    end;

    promptNewGroup(base);
end;

procedure RegisterActions();
var
    actCtrl: IExodusActionController;
    act: IExodusAction;
begin
    actCtrl := GetActionController();

    act := TAddGroupAction.Create(
            '{000-exodus.googlecode.com}-090-add-group',
            _('New Group'));
    actCtrl.registerAction('{create}', act);

    act := TAddGroupAction.Create(
            '{000-exodus.googlecode.com}-090-add-subgroup',
            _('Create nested group'));
    actCtrl.registerAction('group', act);
    actCtrl.addEnableFilter('group', act.Name, 'selection=single');
end;

initialization;
    RegisterActions();

end.
