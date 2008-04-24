unit GroupParser;



interface

uses RegExpr, Unicode;

type
   TGroupParser = class
   private
       _NestedGroups : TRegExpr;
       _GroupSeparator: WideString;
       _Session: TObject;
   public
       constructor Create(Session: TObject);
       destructor Destroy(); override;
       function GetNestedGroups(Group: WideString): TWideStringList;
       function GetGroupName(Group: WideString): WideString;
       function GetGroupParent(Group: WideString): WideString;
       function ParseGroupName(Group: WideString): TWideStringList;
       function BuildNestedGroupList(Groups: TWideStringList): TWideStringList;

       property Separator: Widestring read _GroupSeparator;
   end;

implementation
uses Session;

{---------------------------------------}
constructor TGroupParser.Create(Session: TObject);
var
    sep: Widestring;
begin
   _Session := Session;
   //Spaces are no longer word boundaries, but group separators are.
   sep := TJabberSession(_Session).Prefs.getString('group_seperator');
   if (sep <> '') then begin
       _GroupSeparator := sep;
       _NestedGroups := TRegExpr.Create();
       _NestedGroups.SpaceChars :=  PWideChar(sep)^;
       _NestedGroups.WordChars := _NestedGroups.WordChars + chr(32) + chr(45);
       _NestedGroups.Expression := '\b\w+';
       _NestedGroups.Compile();
   end;
end;

{---------------------------------------}
destructor TGroupParser.Destroy();
begin
    _NestedGroups.Free;
end;

{---------------------------------------}
function TGroupParser.GetNestedGroups(Group: WideString): TWideStringList;
var
    Groups: TWideStringList;
begin
    Groups := ParseGroupName(Group);
    Result := BuildNestedGroupList(Groups);
    Groups.Free;
end;

{---------------------------------------}
//This function will use regular expression to parse group strings in
//format a/b/c or /a/b/c or /a/b/c/  and will return node with the name
//matching the passed string in the above format.
function TGroupParser.ParseGroupName(Group: WideString): TWideStringList;
var
    Found: Boolean;
begin
   Result := TWideStringList.Create();
   if (_NestedGroups = nil) then begin
       Result.Add(Group);
       exit;
   end;

   Found := _NestedGroups.Exec(Group);
   //Continue while finding tokens separated by /
   while (Found) do
   begin
       Result.Add(_NestedGroups.Match[0]);
       Found := _NestedGroups.ExecNext();
   end;
end;

{---------------------------------------}
//Builds the list of all nested subgroups for the group
//Takes list in the format 'a','b','c' and builds '/a','/a/b','/a/b/c'
function TGroupParser.BuildNestedGroupList(Groups: TWideStringList): TWideStringList;
var
    i: Integer;
    GroupName: WideString;
begin
   Result := TWideStringList.Create();
   for i := 0 to Groups.Count - 1 do
   begin
       if (i <> 0) then
         GroupName :=  GroupName + _GroupSeparator;
       GroupName := GroupName + Groups[i];
       Result.Add(GroupName);
   end;
end;

{---------------------------------------}
//Returns groups name based on UID
//For uid "/a/b/c" name would be "c"
function TGroupParser.GetGroupName(Group: WideString): WideString;
var
    Groups: TWideStringList;
begin
    Groups := ParseGroupName(Group);
    Result := Groups[Groups.Count -1];
    Groups.Free();
end;

{---------------------------------------}
//Returns groups name based on UID
//For uid "/a/b/c" name would be "c"
function TGroupParser.GetGroupParent(Group: WideString): WideString;
var
    Groups, GroupList: TWideStringList;
begin
    Result := '';
    Groups := ParseGroupName(Group);
    Groups.Delete(Groups.Count -1 );
    GroupList := BuildNestedGroupList(Groups);
    if (GroupList.Count > 0) then
       Result := GroupList[GroupList.Count - 1];

    Groups.Free();
    GroupList.Free();
end;
end.
