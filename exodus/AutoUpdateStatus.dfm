object frmAutoUpdateStatus: TfrmAutoUpdateStatus
  Left = 236
  Top = 562
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  BorderWidth = 5
  Caption = 'Auto Update'
  ClientHeight = 108
  ClientWidth = 217
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
  object Label1: TTntLabel
    Left = 40
    Top = 0
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
  object TntLabel1: TTntLabel
    Left = 40
    Top = 37
    Width = 64
    Height = 13
    Cursor = crHandPoint
    Caption = 'What'#39's New?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = TntLabel1Click
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 76
    Width = 217
    Height = 32
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Panel2: TPanel
      Width = 217
      Height = 32
      inherited Bevel1: TBevel
        Width = 217
      end
      inherited Panel1: TPanel
        Left = 57
        Height = 27
        inherited btnOK: TTntButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 59
    Width = 217
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
    Top = 73
  end
end
