unit Notify;
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
    XMLTag, Presence, Forms, AppEvnts;
type
    TPresNotifier = class
    private
        _presCallback: longint;
    public
        constructor Create;
        destructor Destroy; override;

        procedure PresCallback(event: string; tag: TXMLTag; p: TJabberPres);
    end;

const
    // image index for tab notification.
    tab_notify = 42;

procedure DoNotify(win: TForm; notify: integer; msg: Widestring; icon: integer;
    sound_name: string); overload;
procedure DoNotify(win: TForm; pref_name: string; msg: Widestring; icon: integer); overload;

procedure StartFlash(win: TForm);
procedure StopFlash(win: TForm);

implementation
uses
    Windows, MMSystem,
    Sysutils, 
    Exodus_TLB, COMExodusItem,
    JabberConst, JabberID, Dockable, RosterImages,StateForm, DisplayName,
    ExUtils, GnuGetText, Jabber1, PrefController, RiserWindow, Debug, Session;

const
    sNotifyOnline = ' is now online.';
    sNotifyOffline = ' is now offline.';

    IE_PROP_IMAGEPREFIX = 'ImagePrefix';
    
    SOUND_OPTIONS = SND_FILENAME or SND_ASYNC or SND_NOWAIT or SND_NODEFAULT;

{---------------------------------------}
constructor TPresNotifier.Create();
begin
    inherited;
    _presCallback := MainSession.RegisterCallback(PresCallback);
end;

{---------------------------------------}
destructor TPresNotifier.Destroy;
begin
    MainSession.UnRegisterCallback(_presCallback);
    inherited;
end;

{---------------------------------------}
procedure TPresNotifier.PresCallback(event: string; tag: TXMLTag; p: TJabberPres);
var
    ImageIndex: integer;
    nick, notifyMessage, notifyType: Widestring;
    tjid: TJabberID;
    Item: IExodusItem;
begin
    //bail if we have not yet received a roster
    
    //bail if the event is one we are notifying about
    if ((event <> '/presence/online') and
        (event <> '/presence/offline')) then
        exit;

    tjid := TJabberID.Create(tag.GetAttribute('from'));
    try
        //bail if blocked
        if (MainSession.IsBlocked(tjid.jid)) then exit;

        Item := MainSession.ItemController.GetItem(tjid.jid);
        //bail if not in roster or not a contact
        if (Item = nil) or (Item.Type_ <> EI_TYPE_CONTACT) then exit;

        nick := DisplayName.getDisplayNameCache().getDisplayName(tjid);
    finally
        tjid.Free();
    end;

    // someone is coming online for the first time..
    if (event = '/presence/online') then
    begin
        ImageIndex := GetPresenceImage('available', Item.value[IE_PROP_IMAGEPREFIX]);
        notifyMessage := sNotifyOnline;
        notifyType := 'notify_online';
    end
    else begin// someone is going offline
        ImageIndex := GetPresenceImage('offline', Item.value[IE_PROP_IMAGEPREFIX]);
        notifyMessage := sNotifyOffline;
        notifyType := 'notify_offline';
    end;
    //notify to the roster window (mainform)
    DoNotify(Application.MainForm, notifyType, nick + _(notifyMessage), ImageIndex);
end;


procedure StartFlash(win: TForm);
var
    fi: TFlashWInfo;
    tf: TCustomForm;
begin
    tf := Forms.GetParentForm(win, true);
    
    if (not tf.Visible) then
    begin
        tf.WindowState := wsMinimized;
        tf.Visible := true;
        ShowWindow(tf.Handle, SW_SHOWMINNOACTIVE);
    end;

    fi.hwnd:= tf.Handle;
    //fi.dwFlags := FLASHW_TIMERNOFG + FLASHW_TRAY;
    fi.dwFlags := FLASHW_TIMER + FLASHW_ALL;
    fi.dwTimeout := 0;
    fi.cbSize:=SizeOf(fi);
    FlashWindowEx(fi);
end;

procedure StopFlash(win: TForm);
var
    fi: TFlashWInfo;
begin
    fi.hwnd:= win.Handle;
    fi.dwFlags := FLASHW_STOP;
    fi.dwTimeout := 0;
    fi.cbSize:=SizeOf(fi);
    FlashWindowEx(fi);
end;

procedure HandleNotifications(win: TForm;
                              notify: integer;
                              msg: Widestring;
                              icon: integer;
                              prefKey: string);
var
    sndFN: string;
begin
    if ((notify and notify_toast) <> 0) then
        ShowRiserWindow(win, msg, icon);

    if ((notify and notify_front) <> 0) then
    begin
        if ((not win.Visible) or (win.WindowState = wsMinimized))then
        begin
            win.WindowState := wsNormal;
            win.Visible := true;
        end;
        ShowWindow(win.Handle, SW_SHOWNORMAL);
        ForceForegroundWindow(win.Handle);
    end
    //tray and flash alert only if not bringtofront
    else begin
        if ((notify and notify_tray) <> 0) then
            StartTrayAlert();

        if ((notify and notify_flash) <> 0) then
            StartFlash(win);
    end;

    if ((notify and notify_sound) <> 0) and
        (MainSession.prefs.getBool('notify_sounds')) then
    begin
        sndFN := MainSession.Prefs.GetSoundFile(prefKey);
        if (sndFN <> '') then
            PlaySound(pchar(sndFN), 0, SOUND_OPTIONS);
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure DoNotify(win: TForm;
                   notify: integer;
                   msg: Widestring;
                   icon: integer;
                   sound_name: string);
var
    tn: integer;
begin
    //map nil windows back to the main window
    if (win = nil) then
        win := Application.MainForm;
        
    //if we have no notifications, we are done
    if (notify = 0) then exit;

    //check active prefs if app is active and we are not bring to front
    if (((notify and notify_front) = 0) and Application.Active) then
    begin
        //notify active app, we are active app -> notify
        //notify active app, we are not active app -> notify
        //do not notify active app, we are not active app -> notify
        //do not notify active app, we are active app -> bail (no notify)
        if (not MainSession.prefs.getBool('notify_active')) then exit;

        //notify active window, we are active window -> notify
        //notify active window, we are not active window -> notify
        //don't notify active window, we aren't active window -> notify
        //don't notify active window, we are active window -> bail (no notify)
        if (not MainSession.prefs.getBool('notify_active_win')) then begin
            if (GetForegroundWindow() = win.handle) then begin
                exit
            end;
            if ((GetDockManager().isActive) and
               (GetDockManager().GetTopDocked() = win) and
               (GetForegroundWindow() = GetDockManager().getHWND())) then begin
                exit;
            end;
        end;
    end;

    //pass off bring to front and flash to better handlers if we can
    tn := notify - ((notify and notify_front) or (notify and notify_flash));

    if (win is TfrmState) then
        TfrmState(win).OnNotify(notify)
    else if (win.Handle = GetDockManager().getHWND) then
        GetDockManager().OnNotify(win, notify)
    else tn := notify;  //include front and flash if not handled elsewhere

    HandleNotifications(win, tn, msg, icon, sound_name);
end;


{---------------------------------------}
procedure DoNotify(win: TForm; pref_name: string; msg: Widestring; icon: integer);
begin
    DoNotify(win, MainSession.Prefs.getInt(pref_name), msg, icon, pref_name);
end;

end.
