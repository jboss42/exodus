unit Importer;

interface

uses
    ExodusCOM_TLB, 
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmImport = class(TForm)
    Label1: TLabel;
    txtFilename: TEdit;
    btnFileBrowse: TButton;
    btnImport: TButton;
    ListView1: TListView;
    Label2: TLabel;
    txtGateway: TEdit;
    btnGatewayBrowse: TButton;
    Label3: TLabel;
    btnAdd: TButton;
    btnCancel: TButton;
    OpenDialog1: TOpenDialog;
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFileBrowseClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    exodus: IExodusController;
  end;

var
  frmImport: TfrmImport;

implementation

{$R *.dfm}

uses
    StrUtils; 

procedure TfrmImport.btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TfrmImport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmImport.btnFileBrowseClick(Sender: TObject);
begin
    with OpenDialog1 do begin
        if (Execute) then begin
            txtFilename.Text := FileName;
        end;
    end;
end;

procedure TfrmImport.btnImportClick(Sender: TObject);
var
    jid, cur_grp, tmps, fn: String;
    itms, sl: TStringList;
    i, j, n: integer;
    li: TListItem;
begin
    // Import the list..
    fn := txtFilename.Text;
    if (FileExists(fn)) then begin
        sl := TStringlist.Create();
        sl.LoadFromFile(fn);
    end
    else begin
        MessageDlg('The file you specified does not exist.', mtError,
            [mbOK], 0);
        exit;
    end;

    if (sl.Count <= 0) then begin
        MessageDlg('The file you specified is empty.', mtError, [mbOK], 0);
        sl.Free();
        exit;
        end;

    // find the "list {" line...
    for i := 0 to sl.Count - 1 do begin
        if (AnsiContainsStr(sl[i], 'list {')) then begin
            // we hit the Buddy List.
            itms := TStringList.Create;
            j := i;
            repeat
                inc(j);
                if (j < sl.Count) then begin
                    tmps := Trim(sl[j]);
                    if (tmps <> '}') then begin
                        // this is a valid entry.
                        itms.Delimiter := ' ';
                        itms.DelimitedText := tmps;
                        if (itms.Count > 1) then begin
                            cur_grp := itms[0];
                            for n := 1 to itms.Count - 1 do begin
                                li := ListView1.Items.Add();
                                li.Caption := cur_grp;
                                li.SubItems.Add(itms[n]);
                                jid := itms[n] + '@' + txtGateway.Text;
                                li.SubItems.Add(jid);
                                li.Checked := true;
                            end;
                        end;
                    end;
                end;
            until ((tmps = '}') or (j >= sl.Count));
            itms.Free();
            break;
        end;
    end;
    sl.Free();
    MessageDlg('Finished importing buddies. Use the Add button to add them to your jabber account.',
        mtInformation, [mbOK], 0);

end;

procedure TfrmImport.btnAddClick(Sender: TObject);
var
    li: TListItem;
    i: integer;
begin
    // Add each item to the roster.
    for i := 0 to ListView1.Items.Count - 1 do begin
        li := ListView1.Items[i];

        // this sets up implicit registration for this transport.
        if (i = 0) then
            exodus.monitorImplicitRegJID(li.SubItems[1], false);

        exodus.AddRosterItem(li.SubItems[1], li.SubItems[0], li.Caption);
    end;

    Self.Close();
end;

end.
