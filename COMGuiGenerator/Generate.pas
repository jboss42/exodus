unit Generate;
{
    Copyright 2006, Peter Millard

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

{$M+}
{$METHODINFO ON}

interface

uses
    TypInfo,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls;

type
  TfrmGen = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    status: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    known_classes: TStringlist;
    vcl_classes: TStringlist;
    uber_cl: TStringlist;
    uber_idl: TStringlist;
    files: TStringlist;
    uber_uses: string;

    function getIName(o: TClass): string;
    function getCOMName(o: TClass): string;
    function getClassName(o: TClass): string;
    procedure addClass(o: TClass);
    procedure idlHeader(idl: TStringlist; idl_name, iname: string);
    procedure pasHeader(f: TStringlist; unit_name: string);
    procedure generateCOM(o: TClass);
    function addUse(new_unit, uses_str: string): string;
    procedure addFile(new_unit: string);
    function stripClassName(class_name: string): string;

  public
    { Public declarations }

  end;

  PParamRecord = ^TParamRecord;
  TParamRecord = record
    Flags:     TParamFlags;
    ParamName: ShortString;
    TypeName:  ShortString;
  end;

  TClassContainer = class
  public
    name: string;
    c: TClass;
    constructor Create(cname: string; cls: TClass);
  end;


var
  frmGen: TfrmGen;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    TntMenus, TntClasses, TntControls, TntStdCtrls, TntGraphics, TntExtCtrls,
    ComCtrls, ExtCtrls, Menus, StrUtils;

{---------------------------------------}
constructor TClassContainer.Create(cname: string; cls: TClass);
begin
    name := cname;
    c := cls;
end;

{---------------------------------------}
procedure TfrmGen.addClass(o: TClass);
var
    cc: TClassContainer;
    vcl_name, cname: string;
begin
    vcl_name := 'T' + stripClassName(o.Classname);

    cname := Lowercase(o.Classname);
    cc := TClassContainer.Create(o.ClassName, o);
    known_classes.AddObject(cname, cc);

    if (o.Classname <> vcl_name) then
        vcl_classes.AddObject(Lowercase(vcl_name), cc);
end;

{---------------------------------------}
procedure TfrmGen.Button1Click(Sender: TObject);
var
    uses_str: string;
    uses_idx: integer;
    cc: TClassContainer;
    i: integer;
begin
    // generate code
    uber_cl.Clear();
    uber_idl.Clear();

    idlHeader(uber_idl, 'ExodusControls', 'IExodusControls');
    pasHeader(uber_cl, 'COMExControls');
    uber_cl.Add('uses');

    uber_uses := 'ComObj, ActiveX, ExodusCOM_TLB, Forms, Classes, Controls, StdCtrls, StdVcl;';
    uber_cl.Add(uber_uses);

    uber_cl.Add('');
    uber_cl.Add('function getCOMControl(o: TObject): IExodusControl;');
    uber_cl.Add('');
    uber_cl.Add('implementation');
    uber_cl.Add('uses');
    uses_idx := uber_cl.Add('');
    uber_cl.Add('');

    uber_cl.Add('function getCOMControl(o: TObject): IExodusControl;');
    uber_cl.Add('begin');


    for i := 0 to known_classes.Count - 1 do begin
        cc := TClassContainer(known_classes.Objects[i]);
        generateCOM(cc.c);
    end;

    uber_cl.Add('end;');
    uber_cl.Add('');
    uber_cl.Add('end.');

    uber_idl.Add('  };');
    uber_idl.Add('');
    uber_idl.Add('};');

    // fixup uses for COMExControls.pas
    uses_str := '';
    for i := 0 to files.Count - 1 do begin
        uses_str := uses_str + files[i];
        if (i = (files.Count - 1)) then
            uses_str := uses_str + ';'
        else
            uses_str := uses_str + ',';
    end;
    uber_cl[uses_idx] := '    ' + uses_str;

    // save our uber files
    uber_idl.SaveToFile(Edit1.Text + '\controls.idl');
    uber_cl.SaveToFile(Edit1.Text + '\COMExControls.pas');
end;

{---------------------------------------}
function TfrmGen.stripClassName(class_name: string): string;
begin
    if (UpperCase(MidStr(class_name, 1, 4)) = 'TTNT') then
        Result := MidStr(class_name, 5, length(class_name) - 4)
    else
        Result := MidStr(class_name, 2, length(class_name) - 1);
end;

{---------------------------------------}
function TfrmGen.getIName(o: TClass): string;
begin
    Result := 'IExodusControl' + stripClassName(o.ClassName);
end;

{---------------------------------------}
function TfrmGen.getCOMName(o: TClass): string;
begin
    Result := 'COMEx' + stripClassName(o.ClassName);
end;

{---------------------------------------}
function TfrmGen.getClassName(o: TClass): string;
begin
    Result := 'TExControl' + stripClassName(o.ClassName);
end;

{---------------------------------------}
procedure TfrmGen.idlHeader(idl: TStringlist; idl_name, iname: string);
var
    gstr: string;
    g: TGUID;
begin
    CreateGUID(g);
    gstr := GUIDToString(g);
    gstr := MidStr(gstr, 2, Length(gstr) - 2);
    idl.Add('[');
    idl.Add('  uuid(' + gstr + '),');
    idl.Add('  version(1.0),');
    idl.Add(']');
    idl.Add('');
    idl.Add('library ' + idl_name);
    idl.Add('{');
    idl.Add('   importlib("stdole2.tlb");');

    CreateGUID(g);
    gstr := GUIDToString(g);
    gstr := MidStr(gstr, 2, Length(gstr) - 2);
    idl.Add('[');
    idl.Add('  uuid(' + gstr + '),');
    idl.Add('  version(1.0),');
    idl.Add('  helpstring("Dispatch interface for ' + idl_name + ' Object"),');
    idl.Add('  dual,');
    idl.Add('  oleautomation');
    idl.Add(']');
    idl.Add('');
    idl.Add('interface ' + iname + ': IDispatch');
    idl.Add('{');
end;

{---------------------------------------}
procedure TfrmGen.pasHeader(f: TStringlist; unit_name: string);
begin
    f.Add('unit ' + unit_name + ';');
    f.Add('{');
    f.Add('    Copyright 2006, Peter Millard');
    f.Add('');
    f.Add('    This file is part of Exodus.');
    f.Add('');
    f.Add('    Exodus is free software; you can redistribute it and/or modify');
    f.Add('    it under the terms of the GNU General Public License as published by');
    f.Add('    the Free Software Foundation; either version 2 of the License, or');
    f.Add('    (at your option) any later version.');
    f.Add('');
    f.Add('    Exodus is distributed in the hope that it will be useful,');
    f.Add('    but WITHOUT ANY WARRANTY; without even the implied warranty of');
    f.Add('    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the');
    f.Add('    GNU General Public License for more details.');
    f.Add('');
    f.Add('    You should have received a copy of the GNU General Public License');
    f.Add('    along with Exodus; if not, write to the Free Software');
    f.Add('    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA');
    f.Add('}');
    f.Add('');
    f.Add('');
    f.Add('{-----------------------------------------------------------------------------}');
    f.Add('{-----------------------------------------------------------------------------}');
    f.Add('{ This is autogenerated code using the COMGuiGenerator. DO NOT MODIFY BY HAND }');
    f.Add('{-----------------------------------------------------------------------------}');
    f.Add('{-----------------------------------------------------------------------------}');
    f.Add('');
    f.Add('');
    f.Add('{$WARN SYMBOL_PLATFORM OFF}');
    f.Add('');
    f.Add('interface');
end;

{---------------------------------------}
function TfrmGen.addUse(new_unit, uses_str: string): string;
begin
    if (Pos(new_unit, uses_str) = 0) then
        Result := new_unit + ', ' + uses_str
    else
        Result := uses_str;

    addFile(new_unit);
end;

{---------------------------------------}
procedure TfrmGen.addFile(new_unit: string);
begin
    if (Pos(new_unit, uber_uses) = 0) then begin
        if (files.IndexOf(new_unit) = -1) then
            files.Add(new_unit);
    end;
end;

{---------------------------------------}
procedure TfrmGen.generateCOM(o: TClass);
var
    info: PTypeInfo;
    data: PTypeData;
    props: PPropList;
    ptype: PPTypeInfo;
    pinfo: TPropInfo;
    pkind: TTypeKind;
    mdata: PTypeData;

    // method stuff we aren't using
    {
    mrecord: PParamRecord;
    param_cur: integer;
    meth_define: string;
    meth_return: ^ShortString;
    param_type: ^ShortString;
    }

    use_idx: integer;
    use_str: string;

    idl_cur, e, vidx, cidx, i: integer;
    class_fn, class_name, class_iname, class_cname: string;
    cc: TClassContainer;

    idl, impl, f: TStringlist;
    id_str, getter, setter, pname, com, cname, iname, idl_name, idl_fn, fn: string;
    idl_getter, idl_setter: string;
    unit_name, enum_name: string;
begin
    // generate various names
    com := getCOMName(o);
    iname := getIName(o);
    cname := getClassName(o);
    idl_name := stripClassName(o.ClassName);

    // get all the props
    info := o.ClassInfo;
    if (info^.Kind <> tkClass) then exit;
    data := GetTypeData(info);

    // add this filename to our files list and a clause into COMExControls.pas
    addFile(com);
    uber_cl.Add('    if (o is ' + o.ClassName + ') then begin ');
    uber_cl.Add('        Result := IExodusControl(' + cname + '.Create(' + o.ClassName + '(o)));');
    uber_cl.Add('        exit;');
    uber_cl.Add('    end;');

    // generate our filenames
    fn := Edit1.Text + '\' + com + '.pas';
    idl_fn := Edit1.Text + '\' + com + '.idl';

    // add an import to our uber IDL.
    uber_idl.Add('   import ' + com + '.idl;');

    status.Lines.Add('');
    status.Lines.Add('-------------------------');
    status.Lines.Add('Generating code for ' + o.ClassName + ' to: ' + iname + ' File: ' + fn);

    // our outputs
    f := TStringlist.Create();          // MAIN PAS header + class def
    impl := TStringlist.Create();       // PAS implementations
    idl := TStringlist.Create();        // IDL output

    // counter for our IDL id's
    idl_cur := 1;

    // IDL HEADER
    idlHeader(idl, idl_name, iname);

    // PAS HEADER
    pasHeader(f, com);
    f.Add('uses');

    // setup our USES clause
    use_str := 'ComObj, ActiveX, ExodusCOM_TLB, Forms, Classes, Controls, StdCtrls, StdVcl;';
    use_idx := f.Add(use_str);

    // add in the unit name for our embedded control
    unit_name := data^.UnitName;
    use_str := addUse(unit_name, use_str);

    // Generate our Class Header for our AutoObject
    f.Add('');
    f.Add('type');
    f.Add('    ' + cname + ' = class(TAutoObject, IExodusControl, ' + iname + ')');
    f.Add('    public');
    f.Add('        constructor Create(control: ' + o.ClassName + ');');
    f.Add('');

    // each class has an embedded control
    f.Add('    private');
    f.Add('        _control: ' + o.ClassName + ';');
    f.Add('');

    // all of our COM stuff is protected
    f.Add('    protected');

    // IExodusControl implementation
    f.Add('        function Get_ControlType: ExodusControlTypes; safecall;');
    impl.Add('function ' + cname + '.Get_ControlType: ExodusControlTypes;');
    impl.Add('begin');
    impl.Add('    Result := ' + MidStr(iname, 2, Length(iname) - 1) + ';');
    impl.Add('end;');
    impl.Add('');


    // Walk all of our properties and process them
    new(props);
    GetPropInfos(info, props);
    for i := 0 to data^.PropCount - 1 do begin

        // Do mad derefs and stuff to get info about this property
        pinfo := props^[i]^;
        pname := pinfo.Name;
        ptype := pinfo.PropType;
        pkind := ptype^.Kind;

        getter := '';
        setter := '';
        idl_getter := '';
        idl_setter := '';

        case pkind of

        tkInteger: begin
            getter := 'Get_' + pname + ': Integer;';
            setter := 'Set_' + pname + '(Value: Integer);';

            f.Add('        function ' + getter + ' safecall;');
            f.Add('        procedure ' + setter + ' safecall;');

            idl_getter := 'HRESULT _stdcall ' + pname + '([out, retval] long *Value );';
            idl_setter := 'HRESULT _stdcall ' + pname + '([in] long Value );';
            end;

        tkFloat: begin
            status.Lines.Add('FLOAT: ' + pname);
            end;

        tkString, tkChar, tkLString, tkWChar, tkWString: begin
            getter := 'Get_' + pname + ': Widestring;';
            setter := 'Set_' + pname + '(const Value: Widestring);';

            f.Add('        function ' + getter + ' safecall;');
            f.Add('        procedure ' + setter + ' safecall;');

            idl_getter := 'HRESULT _stdcall ' + pname + '([out, retval] BSTR *Value );';
            idl_setter := 'HRESULT _stdcall ' + pname + '([in] BSTR Value );';
            end;

        tkEnumeration: begin
            mdata := GetTypeData(ptype^);

            {
            basedata := GetTypeData(mdata^.BaseType^);
            unit_name := basedata^.EnumUnitName;
            use_str := addUse(unit_name, use_str);
            }

            getter := 'Get_' + pname + ': Integer;';
            setter := 'Set_' + pname + '(Value: Integer);';

            f.Add('        function ' + getter + ' safecall;');
            f.Add('        procedure ' + setter + ' safecall;');

            // getter
            impl.Add('function ' + cname + '.' + getter);
            impl.Add('begin');
            for e := mdata^.MinValue to mdata^.MaxValue do begin
                enum_name := GetEnumName(ptype^, e);
                impl.Add('    if (_control.' + pname + ' = ' + enum_name + ') then Result := ' + IntToStr(e) + ';');
            end;
            impl.Add('end;');
            impl.Add('');

            // setter
            impl.Add('procedure ' + cname + '.' + setter);
            impl.Add('begin');

            // walk each ENUM value between MIN and MAX and add a bit
            // into our implementation
            for e := mdata^.MinValue to mdata^.MaxValue do begin
                enum_name := GetEnumName(ptype^, e);
                impl.Add('   if (Value = ' + IntToStr(e) + ') then _control.' + pname + ' := ' + enum_name + ';');
            end;
            impl.Add('end;');
            impl.Add('');

            // reset so we don't get default implementations
            getter := '';
            setter := '';

            // IDL stuff
            idl_getter := 'HRESULT _stdcall ' + pname + '([out, retval] long *Value );';
            idl_setter := 'HRESULT _stdcall ' + pname + '([in] long Value );';
        end;

        tkSet: begin
            status.Lines.Add('SET PROP: ' + pname);
        end;

        tkArray: begin
            status.Lines.Add('ARRAY PROP: ' + pname);
        end;

        tkClass: begin
            // we care about some classes
            class_name := LowerCase(ptype^.Name);

            cc := nil;
            cidx := known_classes.IndexOf(class_name);
            if (cidx >= 0) then
                cc := TClassContainer(known_classes.Objects[cidx])
            else begin
                vidx := vcl_classes.IndexOf(class_name);
                if (vidx >= 0) then
                    cc := TClassContainer(vcl_classes.Objects[vidx]);
            end;

            if (cc <> nil) then begin
                // This is a class we are building an interface for
                class_iname := getIName(cc.c);
                class_cname := getClassName(cc.c);
                class_fn := getCOMName(cc.c);

                // add this filename to our uses clause
                use_str := addUse(class_fn, use_str);

                getter := 'Get_' + pname + ': ' + class_iname + ';';
                f.Add('        function ' + getter + ' safecall;');

                // getter impl
                impl.Add('function ' + cname + '.' + getter);
                impl.Add('begin');
                impl.Add('      Result := ' + class_cname + '.Create(' + '_control.' + pname + ');');
                impl.Add('end;');
                impl.Add('');

                // reset, we don't want our default impl
                getter := '';

                // IDL stuff
                idl_getter := 'HRESULT _stdcall ' + pname + '([out, retval] ' + class_iname + ' ** Value );';

            end
            else if ((class_name = 'tstrings') or
                (class_name = 'tstringList') or
                (class_name = 'twidestrings') or
                (class_name = 'ttntstrings') or
                (class_name = 'twidestringlist')) then begin

                // Special handling for TStrings and related classes

                // first output a Get_FooCount property
                getter := 'Get_' + pname + 'Count: integer;';
                f.Add('        function ' + getter + ' safecall;');
                impl.Add('function ' + cname + '.' + getter);
                impl.Add('begin');
                impl.Add('    Result := _control.' + pname + '.Count;');
                impl.Add('end;');
                impl.Add('');

                // IDL stuff for Get_FooCount
                idl.Add('   [');
                idl.Add('   propget,');
                id_str := Format('%8.8x', [idl_cur]);
                idl.Add('   id(0x' + id_str + ')');
                idl.Add('   ]');
                idl.Add('   HRESULT _stdcall ' + pname + 'Count([out, retval] long *Value );');
                inc(idl_cur);


                // next output a Get_Foo() and Set_Foo() props
                getter := 'Get_' + pname + '(Index: integer): Widestring;';
                setter := 'Set_' + pname + '(Index: integer; const Value: Widestring);';

                f.Add('        function ' + getter + ' safecall;');
                f.Add('        procedure ' + setter + ' safecall;');

                // getter
                impl.Add('function ' + cname + '.' + getter);
                impl.Add('begin');
                impl.Add('   if ((Index >= 0) and (Index < _control.' + pname + '.Count)) then');
                impl.Add('      Result := _control.' + pname + '[Index]');
                impl.Add('   else ');
                impl.Add('      Result := '#39#39';');
                impl.Add('end;');
                impl.Add('');

                // setter impl
                impl.Add('procedure ' + cname + '.' + setter);
                impl.Add('begin');
                impl.Add('   if ((Index >= 0) and (Index < _control.' + pname + '.Count)) then');
                impl.Add('      _control.' + pname + '[Index] := Value;');
                impl.Add('end;');
                impl.Add('');

                idl_getter := 'HRESULT _stdcall ' + pname + '([in] long Index, [out, retval] BSTR *Value );';
                idl_setter := 'HRESULT _stdcall ' + pname + '([in] long Index, [in] BSTR Value );';

                getter := '';
                setter := '';
            end
            else
                status.Lines.Add('SKIPPING CLASS: ' + ptype^.Name + ' for prop: ' + pname);
        end;

        tkMethod: begin
            {
              TMethodKind = (mkProcedure, mkFunction, mkConstructor, mkDestructor,
                mkClassProcedure, mkClassFunction,
                mkSafeProcedure, mkSafeFunction);
            }
            // skip 'onFoo' events
            if (MidStr(UpperCase(pname), 0, 2) = 'ON') then
                continue;

            status.Lines.Add('METHOD: ' + pname);

            // This code works, but is incomplete
            (*
            mdata := GetTypeData(ptype^);
            mrecord := @(mdata^.ParamList);

            meth_define := '';
            case mdata^.MethodKind of
            mkProcedure: meth_define := 'procedure ';
            mkFunction: meth_define := 'function ';
            end;

            if (meth_define <> '') then begin
                meth_define := meth_define + pname;

                param_cur := 1;
                while (param_cur <= mdata^.ParamCount) do begin
                    if (param_cur = 1) then
                        meth_define := meth_define + '(';

                    if (pfVar in mrecord.Flags) then
                        meth_define := meth_define + 'var ';
                    if (pfConst in mrecord.Flags) then
                        meth_define := meth_define + 'const ';
                    if (pfArray in mrecord.Flags) then
                        meth_define := meth_define + 'array of ';
                    if (pfOut in mrecord.Flags) then
                        meth_define := meth_define + 'out ';

                    param_type := Pointer(Integer(@mrecord^.ParamName) +
                        Length(mrecord^.ParamName) + 1);

                    meth_define := Format('%s%s: %s', [meth_define, mrecord^.ParamName,
                        param_type^]);

                    // goto the next parameter
                    inc(param_cur);

                    mrecord := PParamRecord(Integer(mrecord) + sizeof(TParamFlags) +
                        Length(mrecord^.ParamName) + 1 + Length(param_type^) + 1);

                    if (param_cur <= mdata^.ParamCount) then
                        meth_define := meth_define + '; '
                    else
                        meth_define := meth_define + ')';
                end;

                if (mdata^.MethodKind = mkFunction) then begin
                    meth_return := Pointer(mrecord);
                    meth_define := Format('%s: %s;', [meth_define, meth_return^]);
                end
                else
                    meth_define := meth_define + ';';

                status.Lines.Add('METHOD: ' + meth_define);

                // XXX: IDL for methods
            end;



            case (mdata^.MethodKind) of
            mkProcedure: begin
                f.Add('     procedure ' + pname + ' ' + ';');
                end;
            mkFunction: begin
                f.Add('     function ' + pname + ';');
                end;
            end;

            *)

            end;

        // these we can't handle
        tkUnknown, tkVariant, tkRecord, tkInterface, tkInt64, tkDynArray: begin
            status.Lines.Add('UNHANDLED: ' + pname);
            end;
        end;


        // if we have a getter + setter, output default implementations
        if (getter <> '') then begin
            // getter impl
            impl.Add('function ' + cname + '.' + getter);
            impl.Add('begin');
            impl.Add('      Result := _control.' + pname + ';');
            impl.Add('end;');
            impl.Add('');
        end;

        if (setter <> '') then begin
            // setter impl
            impl.Add('procedure ' + cname + '.' + setter);
            impl.Add('begin');
            if (pkind = tkChar) then
                impl.Add('      _control.' + pname + ' := string(Value)[1];')
            else
                impl.Add('      _control.' + pname + ' := Value;');
            impl.Add('end;');
            impl.Add('');
        end;

        // if we have IDL info, output the real IDL
        if (idl_getter <> '') then begin
            idl.Add('   [');
            idl.Add('   propget,');
            id_str := Format('%8.8x', [idl_cur]);
            idl.Add('   id(0x' + id_str + ')');
            idl.Add('   ]');
            idl.Add('   ' + idl_getter);
        end;

        if (idl_setter <> '') then begin
            idl.Add('   [');
            idl.Add('   propput,');
            id_str := Format('%8.8x', [idl_cur]);
            idl.Add('   id(0x' + id_str + ')');
            idl.Add('   ]');
            idl.Add('   ' + idl_setter);
        end;

        // if we had either IDL get/set, then goto the next ID
        if ((idl_getter <> '') or (idl_setter <> '')) then
            inc(idl_cur);
    end;

    // Finish the class definition
    f.Add('    end;');

    f.Add('');
    f.Add('');
    f.Add('{---------------------------------------}');
    f.Add('{---------------------------------------}');
    f.Add('{---------------------------------------}');
    f.Add('implementation');
    f.Add('');
    f.Add('');

    // Output the constructor
    f.Add('constructor ' + cname + '.' + 'Create(control: ' + o.ClassName + ');');
    f.Add('begin');
    f.Add('     _control := control; ');
    f.Add('end;');
    f.Add('');

    // Insert all of our implemenations
    f.AddStrings(impl);

    f.Add('');
    f.Add('');
    f.Add('');

    // fixup our uses clause
    f[use_idx] := '    ' + use_str;

    // Finish up the file
    f.Add('end.');

    idl.Add('  };');
    idl.Add('');
    idl.Add('};');

    // Save our PAS and IDL
    f.SaveToFile(fn);
    idl.SaveToFile(idl_fn);

    // cleanup
    impl.Free();
    f.Free();
end;

{---------------------------------------}
procedure TfrmGen.FormCreate(Sender: TObject);
begin
    known_classes := TStringlist.Create();
    vcl_classes := TStringlist.Create();
    uber_idl := TStringlist.Create();
    uber_cl := TStringlist.Create();
    files := TStringlist.Create();

    addClass(TFont);
    addClass(TTntPanel);
    addClass(TTntMenuItem);
    addClass(TTntPopupMenu);
    addClass(TTntButton);
    addClass(TTntLabel);
    addClass(TTntEdit);
    addClass(TTntCheckBox);
    addClass(TTntRadioButton);
    addClass(TTntListBox);
    addClass(TTntComboBox);
    addClass(TRichEdit);

end;

end.
