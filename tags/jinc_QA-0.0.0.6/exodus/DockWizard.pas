unit DockWizard;
{
    Copyright 2003, Peter Millard

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
    Dockable,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, ComCtrls;

type
  TfrmDockWizard = class(TfrmDockable)
    TntPanel1: TTntPanel;
    Bevel1: TBevel;
    btnBack: TTntButton;
    btnNext: TTntButton;
    btnCancel: TTntButton;
    Panel1: TPanel;
    Bevel2: TBevel;
    lblWizardTitle: TTntLabel;
    lblWizardDetails: TTntLabel;
    Image1: TImage;
    Tabs: TPageControl;
    TabSheet1: TTabSheet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDockWizard: TfrmDockWizard;

implementation

{$R *.dfm}

end.
