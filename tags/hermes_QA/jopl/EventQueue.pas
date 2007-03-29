unit EventQueue;

interface

uses ExEvents, LibXMLParser, XMLTag;

type
  {
    JJF added roster rendering for "PGM" layout.
  }
  TEventMsgQueue = class(TObjectList)
  private
    { Private declarations }
    //_queue          : TObjectList;
    _updatechatCB   : integer;
    _connectedCB    : Integer; //session connected callback ID
    _disconnectedCB : Integer; //session disconnected callback ID
    _currSpoolFile  : Widestring; //current spool file we are reading/writing
    _documentDir    : Widestring; //path to My Documents/Exodus-Logs
  public
    constructor Create();
    destructor Destroy; override;
    procedure SaveEvents();
    procedure LoadEvents();
    procedure setSpoolPath(connected : boolean);
    procedure LogEvent(e: TJabberEvent; msg: string; img_idx: integer);
    procedure RemoveEvents(jid: WideString);
    //function FindChatEvent(jid: Widestring): TJabberEvent;
    //procedure UpdateChat(tag: TXMLTag);
    procedure SetSession(s: TObject);

  published
    procedure SessionCallback(event: string; tag: TXMLTag);
  end;
const

    SE_UPDATE = '/session/gui/update-events';
    SE_CONNECTED = '/session/authenticated';
    SE_DISCONNECTED = '/session/disconnected';

    CB_UNASSIGNED = -1; //unassigned callback ID
    sDefaultSpool = 'default_spool.xml';
    
implementation

uses Session, XMLParser, ChatController, SysUtils, XmlUtils, JabberID,
     Classes, JabberUtils, Dialogs, GnuGetText, ChatWin, DisplayName;

constructor TEventMsgQueue.Create();
begin
    inherited Create();
    _updatechatCB := CB_UNASSIGNED;
    _disconnectedCB := CB_UNASSIGNED;
    Self.OwnsObjects := true; //frees on remove, delete, destruction etc

end;

{---------------------------------------}
destructor TEventMsgQueue.Destroy;
begin
    // Unregister the callback and remove us from the chat list.
   if (MainSession <> nil)  then begin
        if (_updateChatCB <>CB_UNASSIGNED) then
            MainSession.UnRegisterCallback(_updateChatCB);
        if (_connectedCB <>CB_UNASSIGNED) then
            MainSession.UnRegisterCallback(_connectedCB);
        if (_disconnectedCB <>CB_UNASSIGNED) then
            MainSession.UnRegisterCallback(_disconnectedCB);
    end;
    
    inherited;   //owns refs, frees them here
end;

{---------------------------------------}
procedure TEventMsgQueue.SetSession(s: TObject);
begin
    _connectedCB   := TJabberSession(s).RegisterCallback(SessionCallback, SE_CONNECTED);
end;

{---------------------------------------}
procedure TEventMsgQueue.LoadEvents();
var
    m,i,d: integer;
    p: TXMLTagParser;
    cur_e, s: TXMLTag;
    msgs, dtags, etags: TXMLTagList;
    e: TJabberEvent;
    c: TChatController;
begin
    if (not FileExists(_currSpoolFile)) then exit;

    //_loading := true;

    p := TXMLTagParser.Create();
    p.ParseFile(_currSpoolFile);

    if p.Count > 0 then begin
        s := p.popTag();
        etags := s.ChildTags();

        for i := 0 to etags.Count - 1 do begin
            cur_e := etags[i];
            e := TJabberEvent.Create();
            Add(e);
            e.eType := TJabberEventType(SafeInt(cur_e.GetAttribute('etype')));
            e.from := cur_e.GetAttribute('from');
            e.from_jid := TJabberID.Create(e.from);
            e.id := cur_e.GetAttribute('id');
            try
                e.Timestamp := StrToDateTime(cur_e.GetAttribute('timestamp'));
            except
                on EConvertError do
                    e.Timestamp := Now();
            end;
            try
                e.edate := StrToDateTime(cur_e.GetAttribute('edate'));
            except
                on EConvertError do
                    e.edate := Now();
            end;
            e.str_content := cur_e.GetAttribute('str_content');
            if (e.str_content = '') then
                // check data_type for backwards compat.
                e.str_content := cur_e.getAttribute('data_type');
            e.elapsed_time := SafeInt(cur_e.GetAttribute('elapsed_time'));
            e.msg := cur_e.GetAttribute('msg');
            e.caption := cur_e.GetAttribute('caption');
            e.img_idx := SafeInt(cur_e.GetAttribute('img'));

            dtags := cur_e.QueryTags('data');
            for d := 0 to dtags.Count - 1 do
                e.Data.Add(dtags[d].Data);
            dtags.Free();

            // create a new chat controller for this event and populate it
            msgs := cur_e.QueryTags('message');
            if (msgs.Count > 0) then begin
                c := MainSession.ChatList.FindChat(e.from_jid.jid, e.from_jid.resource, '');
                if (c = nil) then
                    c := MainSession.ChatList.AddChat(e.from_jid.jid, e.from_jid.resource);
                c.AddRef();
                for m := 0 to msgs.Count - 1 do
                    c.PushMessage(msgs[m], true);
            end;
            msgs.Free();
        end;
        etags.Free();
        s.Free();
    end;
    p.Free();

    //_loading := false;
end;

{---------------------------------------}
procedure TEventMsgQueue.SaveEvents();
var
    t, i, d: integer;
    s, e: TXMLTag;
    event: TJabberEvent;
    ss: TStringList;
    c: TChatController;
    tl: TXMLTagList;
begin
    // save all of the events in the listview out to a file
    if (MainSession = nil) then exit;
    //if (_loading) then exit;

    s := TXMLTag.Create('spool');
    for i := 0 to Count - 1 do begin
        event := TJabberEvent(Items[i]);
        e := s.AddTag('event');
        with e do begin
            e.setAttribute('img', IntToStr(event.img_idx));
            e.setAttribute('caption', event.caption);
            e.setAttribute('msg', event.msg);
            e.setAttribute('timestamp', DateTimeToStr(event.Timestamp));
            e.setAttribute('edate', DateTimeToStr(event.edate));
            e.setAttribute('elapsed_time', IntToStr(event.elapsed_time));
            e.setAttribute('etype', IntToStr(integer(event.eType)));
            e.setAttribute('from', event.from);
            e.setAttribute('id', event.id);
            e.setAttribute('str_content', event.str_content);
            for d := 0 to event.Data.Count - 1 do
                e.AddBasicTag('data', event.Data.Strings[d]);

            // spool out queued chat messages to disk.
            if (event.eType = evt_Chat) then begin
                c := MainSession.ChatList.FindChat(event.from_jid.jid, event.from_jid.resource, '');
                if (c <> nil) then begin
                    tl := c.getTags();
                    for t := 0 to tl.Count - 1 do
                        e.AddTag(tl[t]);
                    tl.Free();
                end;
            end;
        end;
    end;

    ss := TStringlist.Create();
    try
        ss.Add(UTF8Encode(s.xml));
        if (not DirectoryExists(_documentDir)) then begin
            CreateDir(_documentDir);
        end;
        ss.SaveToFile(_currSpoolFile);
    except
        MessageDlgW(WideFormat(_('There was an error trying to write to the file: %s'), [_currSpoolFile]),
            mtError, [mbOK], 0);
    end;

    MainSession.FireEvent(SE_UPDATE, nil);
    ss.Free();
    s.Free();
end;

{---------------------------------------}
procedure TEventMsgQueue.LogEvent(e: TJabberEvent; msg: string; img_idx: integer);
var
    tmp_jid: TJabberID;
begin
    // display this item
    e.img_idx := img_idx;
    e.msg := msg;

    tmp_jid := TJabberID.Create(e.from);
    e.caption := DisplayName.getDisplayNameCache().getDisplayName(tmp_jid);
    tmp_jid.Free();
    // NB: _queue now owns e... it needs to free it, etc.
    Add(e);
    SaveEvents();
end;

{---------------------------------------}
procedure TEventMsgQueue.RemoveEvents(jid: WideString);
var
 i: Integer;
begin
      i := 0;
      while i < Count do begin
        if ((TJabberEvent(Items[i]).from_jid.jid = jid) and
            (TJabberEvent(Items[i]).eType = evt_Chat)) then begin
              Delete(i);
              continue;
        end;
        inc(i);
      end;

      Self.SaveEvents();
end;


//{---------------------------------------}
//function TEventMsgQueue.FindChatEvent(jid: Widestring): TJabberEvent;
//var
// i: Integer;
//begin
//      Result := nil;
//      i := 0;
//      while i < Count do begin
//        if ((TJabberEvent(Items[i]).from_jid.jid = jid) and
//            (TJabberEvent(Items[i]).eType = evt_Chat)) then begin
//              Result := TJabberEvent(Items[i]);
//              exit;
//        end;
//        inc(i);
//      end;
//end;

{---------------------------------------}
//procedure  TEventMsgQueue.UpdateChat(tag: TXMLTag);
//var
// tmp_jid: TJabberID;
//begin
//   if (tag <> nil) then begin
//         SaveEvents();
//         //If user is available, event tag is not delayed
//         //start chat window
//         if ((MainSession.Show <> 'away') and
//             (MainSession.Show <> 'xa') and
//             (MainSession.Show <> 'dnd') and
//             (tag.QueryXPTag('/message/x[@xmlns="jabber:x:delay"]') = nil)) then begin
//              tmp_jid := TJabberID.Create(tag.getAttribute('from'));
//              StartChat(tmp_jid.jid, tmp_jid.resource, true);
//              tmp_jid.Free;
//         end;
//   end;
//end;

{---------------------------------------}
procedure TEventMsgQueue.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = SE_CONNECTED) then begin
        _documentDir := MainSession.Prefs.getString('log_path');
        setSpoolPath(true);
        loadEvents();
        _disconnectedCB   := MainSession.RegisterCallback(SessionCallback, SE_DISCONNECTED);
    end
    else if (event = SE_DISCONNECTED) then
        Clear();

end;

{---------------------------------------}
{*
    Set the path used for the spool file based on session. If disconnected, a
    global spool.xml file is used (for offline events? not sure what would
    ever be in a spool file when disconnected but might as well leave
    the option open). If connected a jid_spool file will be used.
*}
procedure TEventMsgQueue.setSpoolPath(connected : boolean);
begin
    if (connected) then begin
        _currSpoolFile := _documentDir + '\' + MungeName(mainSession.BareJid) + '_spool.xml';
    end
    else begin
        _currSpoolFile := _documentDir + '\' + sDefaultSpool;
    end;
end;

end.
