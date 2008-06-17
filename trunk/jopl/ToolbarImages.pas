unit ToolbarImages;

interface
uses
    Unicode,
    ExodusImageList;

type

    TContactToolbarImages = class(TExodusImageList)
    protected
        procedure createDefaultIDs();override;
    end;

const
    IMAGE_LIST_ID_CONTACT_TOOLBAR   : WideString = 'contact_toolbar';

{$IFDEF EXODUS}
    CTI_CONNECT_ENABLED_KEY     : Widestring = 'connect';
    CTI_CONNECT_ENABLED_INDEX   : Integer = 0;
    CTI_DISCONNECT_ENABLED_KEY  : Widestring = 'disconnect';
    CTI_DISCONNECT_ENABLED_INDEX: Integer = 1;
    CTI_ADDITEM_ENABLED_KEY     : Widestring = 'addcontact';
    CTI_ADDITEM_ENABLED_INDEX   : Integer = 2;
    CTI_JOINROOM_ENABLED_KEY    : Widestring = 'joinroom';
    CTI_JOINROOM_ENABLED_INDEX  : Integer = 3;
    CTI_SEARCH_ENABLED_KEY      : Widestring = 'search';
    CTI_SEARCH_ENABLED_INDEX    : Integer = 4;
    CTI_VIEW_EABLED_KEY         : Widestring = 'showonline';
    CTI_VIEW_ENABLED_INDEX      : Integer = 5;
    CTI_SENDFILE_ENABLED_KEY    : Widestring = 'folder_closed';
    CTI_SENDFILE_ENABLED_INDEX  : Integer = 6;
    CTI_OPTIONS_ENABLED_KEY     : Widestring = 'prefs';
    CTI_OPTIONS_ENABLED_INDEX   : Integer = 7;
    CTI_ACTIVITY_ENABLED_KEY    : Widestring = 'show_activity_window';
    CTI_ACTIVITY_ENABLED_INDEX  : Integer = 8;
{$ENDIF}
var
    MainbarImages : TContactToolbarImages;

implementation

procedure TContactToolbarImages.createDefaultIDs;
var
    ids: TWideStringList;
begin
{$IFDEF EXODUS}
    ids := TWideStringList.Create();
    ids.Insert(CTI_CONNECT_ENABLED_INDEX, CTI_CONNECT_ENABLED_KEY);
    ids.Insert(CTI_DISCONNECT_ENABLED_INDEX, CTI_DISCONNECT_ENABLED_KEY);
    ids.Insert(CTI_ADDITEM_ENABLED_INDEX, CTI_ADDITEM_ENABLED_KEY);
    ids.Insert(CTI_JOINROOM_ENABLED_INDEX, CTI_JOINROOM_ENABLED_KEY);
    ids.Insert(CTI_SEARCH_ENABLED_INDEX, CTI_SEARCH_ENABLED_KEY);
    ids.Insert(CTI_VIEW_ENABLED_INDEX, CTI_VIEW_EABLED_KEY);
    ids.Insert(CTI_SENDFILE_ENABLED_INDEX, CTI_SENDFILE_ENABLED_KEY);
    ids.Insert(CTI_OPTIONS_ENABLED_INDEX, CTI_OPTIONS_ENABLED_KEY);
    ids.Insert(CTI_ACTIVITY_ENABLED_INDEX, CTI_ACTIVITY_ENABLED_KEY);

    setDefaultIDs(ids);
{$ENDIF}
end;

initialization
    MainbarImages := TContactToolbarImages.Create(IMAGE_LIST_ID_CONTACT_TOOLBAR);

finalization
    MainbarImages.Free();

end.
