unit XMLVCard;
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
    SysUtils, Classes;

type
    TXMLVCardAddress = class
    public
        work: boolean;
        home: boolean;

        Street: string;
        ExtAdr: string;
        Locality: string;
        Region: string;
        PCode: string;
        Country: string;

        procedure Parse(tag: TXMLTag);
        procedure fillTag(tag: TXMLTag);
    end;

    TXMLVCardTel = class
    public
        work: boolean;
        home: boolean;
        voice: boolean;
        fax: boolean;
        number: string;

        procedure Parse(tag: TXMLTag);
        procedure fillTag(tag: TXMLTag);
    end;

    TXMLVCard = class
    public
        GivenName: string;
        FamilyName: string;
        email: string;
        bday: string;
        url: string;
        role: string;

        OrgName: string;
        OrgUnit: string;
        OrgTitle: string;

        Home: TXMLVCardAddress;
        Work: TXMLVCardAddress;

        HomePhone: TXMLVCardTel;
        HomeFax: TXMLVCardTel;
        WorkPhone: TXMLVCardTel;
        WorkFax: TXMLVCardTel;

        constructor Create;
        destructor Destroy; override;

        procedure Parse(tag: TXMLTag);
        procedure fillTag(tag: TXMLTag);
    end;


implementation

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TXMLVCardAddress.Parse(tag: TXMLTag);
var
    element: TXMLTag;
begin
    // parse a <ADR> tag
    work := false;
    home := false;
    Street := '';
    ExtAdr := '';
    Locality := '';
    Region := '';
    PCode := '';
    Country := '';

    if (tag.GetFirstTag('WORK') <> nil) then
        work := true
    else
        home := true;

    element := tag.GetFirstTag('STREET');
    if element <> nil then Street := element.Data;
    element := tag.GetFirstTag('EXTADR');
    if element <> nil then ExtAdr := element.Data;
    element := tag.GetFirstTag('LOCALITY');
    if element <> nil then Locality := element.Data;
    element := tag.GetFirstTag('REGION');
    if element <> nil then Region := element.Data;
    element := tag.GetFirstTag('PCODE');
    if element <> nil then PCode := element.Data;
    element := tag.GetFirstTag('COUNTRY');
    if element <> nil then Country := element.Data;

end;

{---------------------------------------}
procedure TXMLVCardAddress.fillTag(tag: TXMLTag);
begin
    //
    tag.Name := 'ADR';
    if Street <> '' then
        tag.AddBasicTag('STREET', Street);
    if ExtAdr <> '' then
        tag.AddBasictag('EXTADR', ExtAdr);
    if Locality <> '' then
        tag.AddBasicTag('LOCALITY', Locality);
    if Region <> '' then
        tag.AddBasicTag('REGION', Region);
    if PCode <> '' then
        tag.AddBasicTag('PCODE', PCode);
    if Country <> '' then
        tag.AddBasicTag('COUNTRY', Country);

    if work then tag.AddTag('WORK');
    if home then tag.AddTag('HOME');
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TXMLVCardTel.Parse(tag: TXMLTag);
begin
    // parse a <TEL> tag
    work := false;
    home := false;
    fax := false;
    voice := false;
    number := '';
    
    if tag.GetFirstTag('WORK') <> nil then work := true;
    if tag.GetFirstTag('HOME') <> nil then home := true;

    if tag.GetFirstTag('FAX') <> nil then fax := true else voice := true;

    number := tag.Data;
end;

{---------------------------------------}
procedure TXMLVCardTel.fillTag(tag: TXMLTag);
begin
    //
    if work then tag.AddTag('WORK');
    if home then tag.AddTag('HOME');
    if fax then tag.AddTag('FAX');
    if voice then tag.AddTag('VOICE');

    tag.AddCData(number)
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TXMLVCard.Create;
begin
    inherited;

    GivenName := '';
    FamilyName := '';
    email := '';
    bday := '';
    url := '';
    role := '';
    OrgName := '';
    OrgUnit := '';
    OrgTitle := '';

    Home := TXMLVCardAddress.Create();
    Work := TXMLVCardAddress.Create();

    HomePhone := TXMLVCardTel.Create();
    HomeFax := TXMLVCardTel.Create();
    WorkPhone := TXMLVCardTel.Create();
    WorkFax := TXMLVCardTel.Create();
end;

destructor TXMLVCard.Destroy;
begin
    Home.Free;
    Work.Free;

    HomePhone.Free;
    HomeFax.Free;
    WorkPhone.Free;
    WorkFax.Free;

    inherited destroy;
end;

procedure TXMLVCard.Parse(tag: TXMLTag);
var
    vtag, t1, t2: TXMLTag;
    a: TXMLVCardAddress;
    t: TXMLVCardTel;
    tags: TXMLTagList;
    i: integer;
begin
    //
    vtag := tag.GetFirstTag('vcard');
    if (vtag = nil) then
        vtag := tag.GetFirstTag('VCARD');
    if (vtag = nil) then
        vtag := tag.GetFirstTag('vCard');
    if vtag = nil then exit;

    // Parse the name
    t1 := vtag.GetFirstTag('N');
    if t1 <> nil then begin
        t2 := t1.GetFirstTag('GIVEN');
        if t2 <> nil then GivenName := t2.Data;
        t2 := t1.GetFirstTag('FAMILY');
        if t2 <> nil then FamilyName := t2.Data;
        end;

    // get primary email addy
    t1 := vtag.GetFirstTag('EMAIL');
    if t1 <> nil then Email := t1.Data;

    // get personal info
    t1 := vtag.GetFirstTag('URL');
    if t1 <> nil then url := t1.Data;
    t1 := vtag.GetFirstTag('ROLE');
    if t1 <> nil then role := t1.Data;
    t1 := vtag.GetFirstTag('BDAY');
    if t1 <> nil then bday := t1.Data;
    t1 := vtag.GetFirstTag('TITLE');
    if t1 <> nil then OrgTitle := t1.Data;

    t1 := vtag.GetFirstTag('ORG');
    if t1 <> nil then begin
        t2 := t1.GetFirstTag('ORGNAME');
        if t2 <> nil then OrgName := t2.Data;
        t2 := t1.GetFirstTag('ORGUNIT');
        if t2 <> nil then OrgUnit := t2.Data;
        end;

    tags := vtag.QueryTags('ADR');
    for i := 0 to tags.Count - 1 do begin
        a := TXMLVCardAddress.Create();
        a.parse(tags[i]);

        if a.work then
            work.parse(tags[i])
        else
            home.parse(tags[i]);
        end;

    tags := vtag.QueryTags('TEL');
    for i := 0 to tags.Count - 1 do begin
        t := TXMLVCardTel.Create();
        t.parse(tags[i]);

        if (t.work) then begin
            if t.fax then
                WorkFax.parse(tags[i])
            else
                WorkPhone.Parse(tags[i]);
            end
        else begin
            if t.fax then
                HomeFax.Parse(tags[i])
            else
                HomePhone.Parse(tags[i]);
            end;
        end;


end;

{---------------------------------------}
procedure TXMLVCard.fillTag(tag: TXMLTag);
var
    vtag, t1: TXMLTag;
begin
    //
    vtag := tag.AddTag('VCARD');
    vtag.PutAttribute('xmlns', 'vcard-temp');

    t1 := vtag.AddTag('N');
    t1.AddBasicTag('GIVEN', GivenName);
    t1.AddBasicTag('FAMILY', FamilyName);

    vtag.AddBasicTag('EMAIL', email);
    vtag.AddBasicTag('URL', url);
    vtag.AddBasicTag('ROLE', role);
    vtag.AddBasicTag('BDAY', bday);
    vtag.AddBasicTag('TITLE', OrgTitle);

    t1 := vtag.AddTag('ORG');
    t1.AddBasicTag('ORGNAME', OrgName);
    t1.AddBasicTag('ORGUNIT', OrgUnit);

    t1 := vtag.AddTag('ADR');
    Home.fillTag(t1);
    t1 := vtag.AddTag('ADR');
    Work.fillTag(t1);

    t1 := vtag.AddTag('TEL');
    HomePhone.fillTag(t1);
    t1 := vtag.AddTag('TEL');
    HomeFax.fillTag(t1);
    t1 := vtag.AddTag('TEL');
    WorkPhone.fillTag(t1);
    t1 := vtag.AddTag('TEL');
    WorkFax.fillTag(t1);

end;

{---------------------------------------}

end.
