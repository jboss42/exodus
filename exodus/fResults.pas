unit fResults;

interface

uses
    XMLTag, Unicode, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, TntComCtrls;

type
  TframeResults = class(TFrame)
    lstResults: TTntListView;
  private
    { Private declarations }
    _cols: TWidestringlist;
    
  public
    { Public declarations }
    procedure parse(x: TXMLTag);
  end;

implementation

{$R *.dfm}

procedure TframeResults.parse(x: TXMLTag);
var
    i: integer;
    tmps: Widestring;
    tags: TXMLTagList;
    r, f, item: TXMLTag;
    col: TTntListColumn;
    cols: TWidestringlist;
    new_itm: TTntListItem;
begin
    //
    _cols := nil;
    r := x.GetFirstTag('reported');
    if (r <> nil) then begin
        // setup the columns.
        cols := TWidestringlist.Create();

        tags := r.QueryTags('field');
        for i := 0 to tags.count - 1 do begin
            f := tags[i];
            cols.AddObject(f.getAttribute('var'), Pointer(i));
            col := lstResults.Columns.Add();
            tmps := f.getAttribute('label');
            if (tmps = '') then tmps := f.GetAttribute('var');
            col.Caption := tmps;
        end;
    end;

    tags := x.QueryTags('item');
    for i := 0 to tags.count - 1 do begin
        new_itm := lstResults.Items.Add();
        if (cols <> nil) then begin
            // walk all of the columns
        end
        else begin
            // walk all of the children..
        end;
    end;

    
end;

end.
