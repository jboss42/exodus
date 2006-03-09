unit Generate;
{$M+}

interface

uses
    TypInfo,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    status: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    known_classes: TStringlist;
    uber_idl: TStringlist;

    function getIName(o: TClass): string;
    function getCOMName(o: TClass): string;
    function getClassName(o: TClass): string;
    procedure addClass(o: TClass);
    procedure idlHeader(idl: TStringlist; idl_name, iname: string);
    procedure generateCOM(o: TClass);
    function addUse(new_unit, uses_str: string): string;

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
  Form1: TForm1;

implementation

{$R *.dfm}

uses
    ComCtrls, ExtCtrls, Menus, StrUtils;

constructor TClassContainer.Create(cname: string; cls: TClass);
begin
    name := cname;
    c := cls;
end;

procedure TForm1.addClass(o: TClass);
begin
    known_classes.AddObject(Lowercase(o.ClassName), TClassContainer.Create(o.ClassName, o));
end;

procedure TForm1.Button1Click(Sender: TObject);
var
    cc: TClassContainer;
    i: integer;
begin
    // generate code
    uber_idl.Clear();
    idlHeader(uber_idl, 'ExodusControls', 'IExodusControls');

    for i := 0 to known_classes.Count - 1 do begin
        cc := TClassContainer(known_classes.Objects[i]);
        generateCOM(cc.c);
    end;

    uber_idl.Add('  };');
    uber_idl.Add('');
    uber_idl.Add('};');
    uber_idl.SaveToFile(Edit1.Text + '\' + 'controls.idl');
end;

function TForm1.getIName(o: TClass): string;
begin
    Result := MidStr(o.ClassName, 2, length(o.classname) - 1);
    Result := 'IExodusControl' + Result;
end;

function TForm1.getCOMName(o: TClass): string;
begin
    Result := MidStr(o.ClassName, 2, length(o.classname) - 1);
    Result := 'COMEx' + Result;
end;

function TForm1.getClassName(o: TClass): string;
begin
    Result := MidStr(o.ClassName, 2, length(o.classname) - 1);
    Result := 'TExControl' + Result;
end;

procedure TForm1.idlHeader(idl: TStringlist; idl_name, iname: string);
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

function TForm1.addUse(new_unit, uses_str: string): string;
begin
    if (Pos(new_unit, uses_str) = 0) then
        Result := new_unit + ', ' + uses_str
    else
        Result := uses_str;
end;

procedure TForm1.generateCOM(o: TClass);
var
    info: PTypeInfo;
    data: PTypeData;
    props: PPropList;
    ptype: PPTypeInfo;
    pinfo: TPropInfo;
    pkind: TTypeKind;
    mdata: PTypeData;
    mrecord: PParamRecord;

    use_idx: integer;
    use_str: string;

    idl_cur, e, cidx, i: integer;
    class_fn, class_name, class_iname, class_cname: string;
    cc: TClassContainer;

    idl, impl, f: TStringlist;
    id_str, getter, setter, pname, com, cname, iname, idl_name, idl_fn, fn: string;
    idl_getter, idl_setter: string;
    param_cur: integer;
    meth_define: string;
    meth_return: ^ShortString;
    param_type: ^ShortString;
    unit_name, enum_name: string;
begin
    //
    com := getCOMName(o);
    iname := getIName(o);
    cname := getClassName(o);
    idl_name := MidStr(iname, 2, Length(iname) - 1);

    // get all the props
    info := o.ClassInfo;
    if (info^.Kind <> tkClass) then exit;
    data := GetTypeData(info);

    fn := Edit1.Text + '\' + com + '.pas';
    idl_fn := Edit1.Text + '\' + com + '.idl';

    // add an import to our uber IDL.
    uber_idl.Add('   import ' + com + '.idl;');

    status.Lines.Add('Generating code for ' + o.ClassName + ' to: ' + iname + ' File: ' + fn);

    // use this for our output
    f := TStringlist.Create();
    impl := TStringlist.Create();
    idl := TStringlist.Create();

    idl_cur := 1;

    // IDL HEADER
    idlHeader(idl, idl_name, iname);

    // PAS HEADER
    f.Add('unit ' + com + ';');
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
    f.Add('uses');

    use_str := 'ComObj, ActiveX, ExodusCOM_TLB, Forms, Classes, Controls, StdCtrls, StdVcl;';
    use_idx := f.Add(use_str);

    // add in the unit name for our embedded control
    unit_name := data^.UnitName;
    use_str := addUse(unit_name, use_str);

    f.Add('');
    f.Add('type');
    f.Add('    ' + cname + ' = class(TAutoObject, ' + iname + ')');
    f.Add('    public');
    f.Add('        constructor Create(control: ' + o.ClassName + ');');
    f.Add('');

    f.Add('    private');
    f.Add('        _control: ' + o.ClassName + ';');
    f.Add('');

    f.Add('    protected');

    // walk props
    new(props);
    GetPropInfos(info, props);
    for i := 0 to data^.PropCount - 1 do begin
        pinfo := props^[i]^;
        pname := pinfo.Name;
        ptype := pinfo.PropType;
        pkind := ptype^.Kind;

        {
          TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
            tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
            tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray);
        }

        getter := '';
        setter := '';
        idl_getter := '';
        idl_setter := '';

        case pkind of

        // these we can deal with
        tkInteger: begin
            getter := 'Get_' + pname + ': Integer;';
            setter := 'Set_' + pname + '(Value: Integer);';

            f.Add('        function ' + getter + ' safecall;');
            f.Add('        procedure ' + setter + ' safecall;');

            idl_getter := 'HRESULT _stdcall ' + pname + '([out, retval] long *Value );';
            idl_setter := 'HRESULT _stdcall ' + pname + '([in] long Value );';
            end;

        tkFloat: begin
            // XXX
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

            for e := mdata^.MinValue to mdata^.MaxValue do begin
                enum_name := GetEnumName(ptype^, e);
                impl.Add('   if (Value = ' + IntToStr(e) + ') then _control.' + pname + ' := ' + enum_name + ';');
            end;
            impl.Add('end;');
            impl.Add('');

            getter := '';
            setter := '';

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

            cidx := known_classes.IndexOf(class_name);
            if (cidx >= 0) then begin

                // This is a class we are building an interface for
                cc := TClassContainer(known_classes.Objects[cidx]);
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

                getter := '';

                idl_getter := 'HRESULT _stdcall ' + pname + '([out, retval] ' + class_iname + ' ** Value );';

            end
            else if ((class_name = 'tstrings') or
                (class_name = 'tstringList') or
                (class_name = 'twidestrings') or
                (class_name = 'twidestringlist')) then begin
                // Special handling for TStrings

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



            (*
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

        // these we can't
        tkUnknown, tkVariant, tkRecord, tkInterface, tkInt64, tkDynArray: begin
            end;
        end;

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

        if ((idl_getter <> '') or (idl_setter <> '')) then
            inc(idl_cur);
    end;

    f.Add('    end;');

    f.Add('');
    f.Add('');
    f.Add('{---------------------------------------}');
    f.Add('{---------------------------------------}');
    f.Add('{---------------------------------------}');
    f.Add('implementation');
    f.Add('');
    f.Add('');
    f.Add('constructor ' + cname + '.' + 'Create(control: ' + o.ClassName + ');');
    f.Add('begin');
    f.Add('     _control := control; ');
    f.Add('end;');
    f.Add('');

    f.AddStrings(impl);

    f.Add('');
    f.Add('');
    f.Add('');

    f.Add('end.');

    // fixup our uses clause
    f[use_idx] := '    ' + use_str;

    idl.Add('  };');
    idl.Add('');
    idl.Add('};');

    // put the output into the status box for now
    //status.Lines.AddStrings(f);

    // Save our PAS and IDL
    f.SaveToFile(fn);
    idl.SaveToFile(idl_fn);

    // cleanup
    impl.Free();
    f.Free();

end;


procedure TForm1.FormCreate(Sender: TObject);
begin
    known_classes := TStringlist.Create();
    uber_idl := TStringlist.Create();

    addClass(TFont);
    addClass(TPanel);
    addClass(TMenuItem);
    addClass(TPopupMenu);
    addClass(TButton);
    addClass(TLabel);
    addClass(TEdit);
    addClass(TCheckBox);
    addClass(TRadioButton);
    addClass(TListBox);
    addClass(TComboBox);
    addClass(TRichEdit);

end;

end.
