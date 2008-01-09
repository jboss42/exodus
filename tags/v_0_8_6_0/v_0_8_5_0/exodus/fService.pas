unit fService;
{
    Copyright 2002, Peter Millard

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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TframeObjectActions = class(TFrame)
    pRegister: TPanel;
    lblRegister: TLabel;
    pSearch: TPanel;
    lblSearch: TLabel;
    pConf: TPanel;
    lblConf: TLabel;
    pnlTop: TPanel;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
