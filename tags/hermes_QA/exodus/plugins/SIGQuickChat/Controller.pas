unit Controller;

interface

uses
  Windows, SysUtils, Classes;

type
   // An interface definition
   IController = Interface(IInterface)
      procedure Search(searchString: String);
      procedure PopulateControlWithSearchResults();
      procedure Selected(selectString: String);
      procedure ExodusDebug(level: Integer; msg: String);
      procedure RestoreQuickChatList();
      procedure ClearQuickChat();
   end;

implementation
end.
