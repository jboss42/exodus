unit GroupActions;

interface

uses Exodus_TLB, ExActions;

type TAddGroupAction = class(TExBaseAction)
private
    constructor Create();
public
    destructor Destroy(); override;

    procedure execute(const items: IExodusItemList); override;
end;

implementation

uses ComServ, gnugettext, ExActionCtrl, ExUtils;

constructor TAddGroupAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-090-add-group');

    set_Caption(_('New Group'));
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

    act := TAddGroupAction.Create();
    actCtrl.registerAction('{create}', act);
end;

initialization;
    RegisterActions();

end.
