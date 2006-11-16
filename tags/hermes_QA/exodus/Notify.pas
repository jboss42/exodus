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
    XMLTag,
    JabberID,
    Presence,
    Dockable,
    Windows, Forms, Contnrs, SysUtils, classes;

type
    TNotifyController = class
    private
        _session: TObject;
        _presCallback: longint;
    published
        procedure Callback (event: string; tag: TXMLTag);
        procedure PresCallback(event: string; tag: TXMLTag; p: TJabberPres);
    public
        constructor Create;
        destructor Destroy; override;
        procedure SetSession(js: TObject);
end;

const
    // image index for tab notification.
    tab_notify = 42;

procedure DoNotify(win: TForm; notify: integer; msg: Widestring; icon: integer;
    sound_name: string); overload;
procedure DoNotify(win: TForm; pref_name: string; msg: Widestring; icon: integer); overload;

implementation
uses
    RosterImages,
    RosterWindow,
    StateForm,
    BaseChat, JabberUtils, ExUtils,  ExEvents, GnuGetText,
    Jabber1, PrefController, RiserWindow,
    Room, NodeItem, Roster, MMSystem, Debug, Session;

const
    sNotifyOnline = ' is now online.';
    sNotifyOffline = ' is now offline.';
    
{---------------------------------------}
constructor TNotifyController.Create;
begin
    //
    inherited;
end;

{---------------------------------------}
destructor TNotifyController.Destroy;
begin
    inherited Destroy;
end;

{---------------------------------------}
procedure TNotifyController.SetSession(js: TObject);
begin
    // Store a reference to the session object
    _session := js;
    with TJabberSession(_session) do begin
        _presCallback := RegisterCallback(PresCallback);
    end;
end;

{---------------------------------------}
procedure TNotifyController.PresCallback(event: string; tag: TXMLTag; p: TJabberPres);
begin
    // getting a pres event
    Callback(event, tag);
end;

{---------------------------------------}
procedure TNotifyController.Callback(event: string; tag: TXMLTag);
var
    idx: integer;
    sess: TJabberSession;
    nick, j, from: Widestring;
    ritem: TJabberRosterItem;
    tmp_jid: TJabberID;
    f: TForm;
begin
    // we are getting some event to do notification on

    // DebugMsg('Notify Callback: ' + BoolToStr(MainSession.IsPaused, true));
    if MainSession.IsPaused then begin
        MainSession.QueueEvent(event, tag, Self.Callback);
        exit;
    end;

    sess := TJabberSession(_session);
    from := tag.GetAttribute('from');
    tmp_jid := TJabberID.Create(from);
    j := tmp_jid.jid;
    if (sess.IsBlocked(j)) then exit;

    ritem := sess.roster.Find(j);
    if ((ritem <> nil) and (ritem.Text <> '')) then
        nick := ritem.Text
    else if (tmp_jid.user <> '') then
        nick := tmp_jid.userDisplay
    else
        nick := '';

    tmp_jid.Free();

    // don't display notifications for rooms, here.
    if (IsRoom(j)) then exit;
    if (nick = '') then exit;

    // someone is coming online for the first time..
    if (event = '/presence/online') then begin
        if (ritem <> nil) then
            idx := ritem.getPresenceImage('available')
        else
            idx := RosterTreeImages.Find('available');
        //Presence notifications should be routed to the parent form of the
        //roster. may be mainform or roster is embedded in a tab
        f := GetRosterWindow();
        if (f <> nil) then
            f := TfrmRosterWindow(f).GetDockParent();
        if (f <> nil) and (not f.inheritsFrom(TfrmDockable)) then
            f := nil; //route to mainform            
        DoNotify(f, 'notify_online', nick + _(sNotifyOnline), idx);
    end

    // someone is going offline
    else if (event = '/presence/offline') then begin
        if (ritem <> nil) then
            idx := ritem.getPresenceImage('offline')
        else
            idx := RosterTreeImages.Find('offline');

        f := GetRosterWindow();
        if (f <> nil) then
            f := TfrmRosterWindow(f).GetDockParent();
        if (f <> nil) and (not f.inheritsFrom(TfrmDockable)) then
            f := nil; //route to mainform            

        DoNotify(f, 'notify_offline', nick + _(sNotifyOffline), idx);
    end

    // don't display normal presence changes
    else if ((event = '/presence/available') or (event = '/presence/error')
        or (event = '/presence/unavailable') ) then
        // do nothing

    // unkown.
    else
        DebugMessage('Unknown notify event: ' + event);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure DoNotify(win: TForm; notify: integer; msg: Widestring; icon: integer;
    sound_name: string);
begin
    //bail if paused
    if (MainSession.IsPaused) then exit;

    //If "bring to front" notification selected, skip the following section
    // and perform notification code following this section
    if ((notify and notify_front) = 0) then begin
        //check "notify if app active" and "notify if window active" prefs.
        if (Application.Active) then begin
            //check active app notify
            if (not MainSession.prefs.getBool('notify_active')) then exit;
            //check active form notify
            if (not MainSession.prefs.getBool('notify_active_win')) then begin
                //if notify directed at dock manager (win = nil) and
                //any active child means main window is active (Application.Active)
                if (win = nil) then exit;
                if (GetForegroundWindow() = win.handle) then exit;
                //if dock manager is active and win is top docked, it is active
                if ((GetDockManager().GetTopDocked() = win) and GetDockManager().isActive) then exit;
            end;
        end;
    end;

    if ((notify and notify_toast) > 0) then
        ShowRiserWindow(win, msg, icon); // Show toast

    if (win is TfrmState) then
        TfrmState(win).OnNotify(notify)
    else if (win <> nil) then begin  //handle flash and front ourselves
        if ((notify and notify_flash) > 0) then
            FlashWindow(win.Handle, true);
        if ((notify and notify_front) > 0) then begin
            if ((not win.Visible) or (win.WindowState = wsMinimized))then begin
            win.WindowState := wsNormal;
            win.Visible := true;
        end;
        ShowWindow(win.Handle, SW_SHOWNORMAL);
        ForceForegroundWindow(win.Handle);
        end;
    end;
    GetDockManager().OnNotify(win, notify);

{    if ((notify and notify_flash) > 0) then begin
        // flash or show img
        if (w = frmExodus) then begin
            // The window is the main window
//JJF Fix this!            if frmExodus.Tabs.ActivePage <> frmExodus.tbsRoster then
//                frmExodus.tbsRoster.ImageIndex := tab_notify;
            if ((active_win <> frmExodus.Handle) and (not Application.Active)) then
                frmExodus.Flash();
        end
        else
            if d.Docked then begin
                if (frmExodus.getTopDocked() <> d) then begin
                    d.TabSheet.ImageIndex := tab_notify;
                    frmExodus.Tabs.Repaint();
                end;
                if ((active_win <> frmExodus.Handle) and (not Application.Active)) then
                    frmExodus.Flash();
            end
            else if (w is TfrmBaseChat) then
                TfrmBaseChat(w).Flash()
            else begin
                FlashWindow(w.Handle, true);
                FlashWindow(w.Handle, true);
            end;
        end
        else begin
            // it's something else
            FlashWindow(w.Handle, true);
            FlashWindow(w.Handle, true);
        end;
    end;

    if ((notify and notify_front) > 0) then begin
        // pop the window to the front
        if (w is TfrmDockable) then begin
            d := TfrmDockable(w);
            if (d.Docked) then begin
                frmExodus.doRestore();
                frmExodus.BringDockedToTop(d);
                //invoke the onchange event so tab is updated correctly
                frmExodus.Tabs.onChange(nil);
                w := frmExodus;
            end;
        end
        else if (w = frmExodus) then
            frmExodus.doRestore()
        else if ((not w.Visible) or (w.WindowState = wsMinimized))then begin
            w.WindowState := wsNormal;
            w.Visible := true;
        end;
        ShowWindow(w.Handle, SW_SHOWNORMAL);
        ForceForegroundWindow(w.Handle);
    end;
}
    if (MainSession.prefs.getBool('notify_sounds')) then
        PlaySound(pchar(PrefController.getAppInfo().ID + '_' + sound_name), 0,
                  SND_APPLICATION or SND_ASYNC or SND_NOWAIT or SND_NODEFAULT);
end;


{---------------------------------------}
procedure DoNotify(win: TForm; pref_name: string; msg: Widestring; icon: integer);
begin
    DoNotify(win, MainSession.Prefs.getInt(pref_name), msg, icon, pref_name);
end;

end.
