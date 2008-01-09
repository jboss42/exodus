unit JabberConst;
{
    Copyright 2002, Peter Millard

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
    SysUtils, XMLTag;

const
    XMLNS_AUTH       = 'jabber:iq:auth';
    XMLNS_ROSTER     = 'jabber:iq:roster';
    XMLNS_REGISTER   = 'jabber:iq:register';
    XMLNS_LAST       = 'jabber:iq:last';
    XMLNS_TIME       = 'jabber:iq:time';
    XMLNS_VERSION    = 'jabber:iq:version';
    XMLNS_IQOOB      = 'jabber:iq:oob';
    XMLNS_BROWSE     = 'jabber:iq:browse';
    XMLNS_AGENTS     = 'jabber:iq:agents';
    XMLNS_SEARCH     = 'jabber:iq:search';
    XMLNS_PRIVATE    = 'jabber:iq:private';
    XMLNS_CONFERENCE = 'jabber:iq:conference';

    XMLNS_BM         = 'storage:bookmarks';
    XMLNS_PREFS      = 'storage:imprefs';

    XMLNS_XEVENT     = 'jabber:x:event';
    XMLNS_DELAY      = 'jabber:x:delay';
    XMLNS_XROSTER    = 'jabber:x:roster';
    XMLNS_XCONFERENCE= 'jabber:x:conference';
    XMLNS_XDATA      = 'jabber:x:data';
    XMLNS_XOOB       = 'jabber:x:oob';

    XMLNS_MUC        = 'http://jabber.org/protocol/muc';
    XMLNS_MUCOWNER   = 'http://jabber.org/protocol/muc#owner';
    XMLNS_MUCADMIN   = 'http://jabber.org/protocol/muc#admin';
    XMLNS_MUCUSER    = 'http://jabber.org/protocol/muc#user';

    XMLNS_DISCO      = 'http://jabber.org/protocol/disco';
    XMLNS_DISCOITEMS = 'http://jabber.org/protocol/disco#items';
    XMLNS_DISCOINFO  = 'http://jabber.org/protocol/disco#info';

var
    XP_MSGXDATA: TXPLite;
    XP_MUCINVITE: TXPLite;
    XP_CONFINVITE: TXPLite;
    XP_JCFINVITE: TXPLite;
    XP_MSGXROSTER: TXPLite;
    XP_MSGXEVENT: TXPLite;
    XP_MSGCOMPOSING: TXPLite;
    XP_MSGDELAY: TXPLite;
    XP_XOOB: TXPLite;
    XP_XDELIVER: TXPLite;
    XP_XDISPLAY: TXPLite;
    XP_XROSTER: TXPLite;

implementation

initialization
    XP_MSGXDATA := TXPLite.Create('/message/x[@xmlns="' + XMLNS_XDATA + '"]');
    XP_MUCINVITE := TXPLite.Create('/message/x[@xmlns="' + XMLNS_MUCUSER + '"]');
    XP_CONFINVITE := TXPLite.Create('/message/x[@xmlns="' + XMLNS_XCONFERENCE + '"]');
    XP_JCFINVITE := TXPLite.Create('/message/x[@xmlns="jabber:x:invite"]');
    XP_MSGXROSTER := TXPLite.Create('/message/x[@xmlns="' + XMLNS_XROSTER + '"]');
    XP_MSGXEVENT := TXPLite.Create('/message/*[@xmlns="' + XMLNS_XEVENT + '"]');
    XP_MSGCOMPOSING := TXPLite.Create('/message/*[@xmlns="' + XMLNS_XEVENT + '"]/composing');
    XP_MSGDELAY := TXPLite.Create('/message/x[@xmlns="' + XMLNS_DELAY + '"]');
    XP_XOOB := TXPLite.Create('/message/x[@xmlns="' + XMLNS_XOOB + '"]');
    XP_XDELIVER := TXPLIte.Create('/message/x[@xmlns="' + XMLNS_XEVENT + '"]/delivered');
    XP_XDISPLAY := TXPLite.Create('/message/x[@xmlns="' + XMLNS_XEVENT + '"]/displayed');
    XP_XROSTER := TXPLite.Create('/message/x[@xmlns="' + XMLNS_XROSTER + '"]');

finalization
    XP_XOOB.Free();
    XP_MSGDELAY.Free();
    XP_MSGCOMPOSING.Free();
    XP_MSGXEVENT.Free();
    XP_MSGXROSTER.Free();
    XP_JCFINVITE.Free();
    XP_CONFINVITE.Free();
    XP_MUCINVITE.Free();
    XP_MSGXDATA.Free();
    

end.
 