unit fProfile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, TntStdCtrls;

type
  TframeProfile = class(TFrame)
    lblName: TTntLabel;
    lblModify: TTntLabel;
    lblDelete: TTntLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
