unit DockContainer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Dockable, ExtCtrls, ComCtrls, ToolWin, OleCtrls, SHDocVw, gnugettext;

type
  TfrmDockContainer = class(TfrmDockable)
    Panel1: TPanel;
    WebBrowser1: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TntFormShow(Sender: TObject);
  private
    _id: widestring;

    procedure sendEvent(event: widestring);
  public
    procedure OnDocked();override;
    procedure OnFloat();override;

    property UID: Widestring read _id write _id;
  end;

implementation
uses
  XMLTag,
  Session;

{$R *.dfm}

procedure TfrmDockContainer.sendEvent(event: widestring);
var
  ttag: TXMLtag;
begin
  ttag := TXMLTag.Create('dockcontainer');
  ttag.setAttribute('title', Self.Caption);
  ttag.setAttribute('id', _id);
  Session.MainSession.FireEvent(event, ttag);
  ttag.Free();
end;

procedure TfrmDockContainer.TntFormShow(Sender: TObject);
begin
  inherited;
  sendEvent('/session/dockcontainer/onshow');
end;

procedure TfrmDockContainer.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  sendEvent('/session/dockcontainer/onclose');
  inherited;
end;

procedure TfrmDockContainer.OnDocked();
begin
  inherited;
  sendEvent('/session/dockcontainer/ondocked');
end;

procedure TfrmDockContainer.OnFloat();
begin
  inherited;
  Application.ProcessMessages();
  sendEvent('/session/dockcontainer/onfloat');
end;

procedure TfrmDockContainer.FormCreate(Sender: TObject);
begin
  TP_GlobalIgnoreClassProperty(TWebBrowser,'StatusText');
  inherited;
end;

initialization
end.
