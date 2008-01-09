object frmAutoUpdateStatus: TfrmAutoUpdateStatus
  Left = 234
  Top = 563
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  BorderWidth = 5
  Caption = 'Auto Update'
  ClientHeight = 88
  ClientWidth = 218
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 6
    Width = 178
    Height = 26
    Caption = 
      'A new version of Exodus is available.  Would you like to install' +
      ' it?'
    WordWrap = True
  end
  object Image1: TImage
    Left = 3
    Top = 3
    Width = 32
    Height = 32
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 56
    Width = 218
    Height = 32
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 218
    end
    inherited Panel1: TPanel
      Left = 58
      Height = 27
      inherited btnOK: TButton
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 39
    Width = 218
    Height = 17
    Align = alBottom
    Max = 1
    TabOrder = 1
    Visible = False
  end
  object HttpClient: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    OnWork = HttpClientWork
    OnWorkBegin = HttpClientWorkBegin
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = 0
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 6
    Top = 57
  end
end
