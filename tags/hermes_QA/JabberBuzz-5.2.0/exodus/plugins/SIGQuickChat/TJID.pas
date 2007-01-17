unit TJID;

interface

uses
    SysUtils, Classes, Unicode;

type
    TJID = class(TObject)
    public
         constructor  Create(); overload;
         constructor  Create(jid: WideString; name: WideString); overload;
         function     Same(ojid: TJID): Bool;

         procedure    Copy(ojid: TJID);
         procedure    Clear();
         function     Clone(): TJID;
         function     IsEmpty(): Bool;

         function     GetName(): String;
         procedure    SetName(name: string);
         function     GetJid(): String;
         procedure    SetJid(jid: string);
         Property     Name : string read GetName write SetName;
         Property     Jid : string  read GetJid write SetJid;
    private
        _jid:         Widestring;
        _name:        Widestring;
    end;

implementation

constructor TJID.Create();
begin
   inherited Create();
   self._jid := '';
   self._name:= '';
end;

constructor TJID.Create(jid: WideString; name: WideString);
begin
   inherited Create();
   self._jid := jid;
   self._name:= name;
end;

function TJID.IsEmpty(): Bool;
begin
   if ((self._jid = '') AND (self._name = '')) then
     Result := true
   else
     Result := false;
end;

procedure TJID.Copy(ojid: TJID);
begin
   self._jid := ojid.jid;
   self._name:= ojid.name;
end;

procedure TJID.Clear();
begin
   self._jid := '';
   self._name:= '';
end;

function TJID.Clone(): TJID;
begin
    result := TJID.Create(self.Jid, self.Name);
end;

function TJID.Same(ojid: TJID): Bool;
begin
   if ((self._jid = ojid.Jid) AND (self._name = ojid.Name) ) then
      Result := true
   else
      Result := false;
end;

function TJID.GetName(): String;
begin
    Result := self._name;
end;

procedure TJID.SetName(name: string);
begin
   self._name := name;
end;

function TJID.GetJid(): String;
begin
    Result := self._jid;
end;

procedure TJID.SetJid(jid: string) ;
begin
   self._jid := jid;
end;

end.
