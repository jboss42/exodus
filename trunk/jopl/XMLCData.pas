unit XMLCData;
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
    XMLNode;

type
  TXMLCData = class(TXMLNode)
  private
    fData: string;
  protected
    { Protected declarations }
    function Get_Text: string;
    procedure Set_Text(const Value: string);
  public
    constructor Create; overload; override;
    constructor Create(content: string); reintroduce; overload; 
    destructor Destroy; override;

    // pgm_virt
    function XML: string; override;
    property Data: string read Get_Text write Set_Text;
  end;

  TXML_CData = TXMLCData;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    XMLConstants,
    XMLUtils,
    SysUtils;

{---------------------------------------}
constructor TXMLCData.Create;
begin
    inherited Create;

    Name := '#TEXT';
    NodeType := xml_CDATA;
    fData := '';
end;

{---------------------------------------}
constructor TXMLCData.Create(content: string);
begin
    inherited Create;

    Name := '#TEXT';
    NodeType := xml_CDATA;
    fData := '';

    Set_Text(content);
end;

{---------------------------------------}
destructor TXMLCData.Destroy;
begin
    fData := '';

    inherited Destroy;
end;

{---------------------------------------}
function TXMLCData.Get_Text: string;
begin
    //Result := XML_UnescapeChars(fData);
    Result := fData;
end;

{---------------------------------------}
procedure TXMLCData.Set_Text(const Value: string);
var
    p1: integer;
    tmps: string;
begin
    // set text into the data prop..
    // deal w/ <![CDATA[   ---   ]]> here

    // pgm 2/28/01 - DON'T TRIM THIS!!
    // tmps := Trim(Value);
    tmps := Value;
    p1 := Pos('<![CDATA[', Uppercase(tmps));
    if p1 > 0 then begin
        // we have cdata... remove the CDATA tags
        Delete(tmps, p1, 9);
        p1 := Pos(']]>', tmps);
        if p1 > 0 then
            Delete(tmps, p1, 3);
        Name := '#CDATA';
        end
    else
        tmps := tmps;
    fData := tmps;
end;

{---------------------------------------}
function TXMLCData.XML: string;
var
    tmps: string;
begin
    // Return the XML string
    // Build and return the element xml text..
    if Name = '#CDATA' then
        tmps := '<![CDATA[ ' + fData + ' ]]>'
    else
        tmps := XML_EscapeChars(fData);
    Result := tmps;
end;

end.
