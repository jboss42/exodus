inherited frmNewUser: TfrmNewUser
  Left = 216
  Top = 120
  Caption = 'New User Registration Wizard'
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited TntPanel1: TTntPanel
    inherited Panel3: TPanel
      inherited btnBack: TTntButton
        OnClick = btnBackClick
      end
      inherited btnNext: TTntButton
        OnClick = btnNextClick
      end
      inherited btnCancel: TTntButton
        OnClick = btnCancelClick
      end
    end
  end
  inherited Panel1: TPanel
    inherited lblWizardTitle: TTntLabel
      Width = 99
      Caption = 'New User Wizard'
    end
    inherited lblWizardDetails: TTntLabel
      Caption = 'This wizard will create a new jabber account for you.'
    end
  end
  inherited Tabs: TPageControl
    inherited TabSheet1: TTabSheet
      object TntLabel1: TTntLabel
        Left = 0
        Top = 0
        Width = 402
        Height = 39
        Align = alTop
        Caption = 
          'You must select a server to use for your jabber account. This se' +
          'rver may be a local server provided by you internet server provi' +
          'der, or you may use one of the public jabber servers.'
        WordWrap = True
      end
      object TntLabel2: TTntLabel
        Left = 16
        Top = 64
        Width = 108
        Height = 13
        Caption = 'Select a Jabber Server'
      end
      object cboServer: TTntComboBox
        Left = 40
        Top = 80
        Width = 249
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        Text = 'jabber.org'
      end
    end
    object tbsUser: TTabSheet
      Caption = 'tbsUser'
      ImageIndex = 5
      object TntLabel4: TTntLabel
        Left = 16
        Top = 16
        Width = 142
        Height = 13
        Caption = 'Select your desired username:'
      end
      object TntLabel5: TTntLabel
        Left = 16
        Top = 73
        Width = 90
        Height = 13
        Caption = 'Select a password:'
      end
      object txtUsername: TTntEdit
        Left = 41
        Top = 32
        Width = 248
        Height = 21
        TabOrder = 0
      end
      object txtPassword: TTntEdit
        Left = 41
        Top = 89
        Width = 248
        Height = 21
        TabOrder = 1
      end
    end
    object tbsWait: TTabSheet
      Caption = 'tbsWait'
      ImageIndex = 1
      object lblWait: TTntLabel
        Left = 0
        Top = 0
        Width = 402
        Height = 13
        Align = alTop
        Caption = 'Please wait...'
        WordWrap = True
      end
      object aniWait: TAnimate
        Left = 0
        Top = 13
        Width = 402
        Height = 50
        Align = alTop
        CommonAVI = aviFindFolder
        StopFrame = 29
      end
    end
    object tbsXData: TTabSheet
      Caption = 'tbsXData'
      ImageIndex = 2
      inline frameXData1: TframeXData
        Left = 0
        Top = 0
        Width = 402
        Height = 226
        Align = alClient
        TabOrder = 0
        inherited Panel1: TPanel
          Width = 402
          Height = 226
          inherited ScrollBox1: TScrollBox
            Width = 392
            Height = 216
          end
        end
      end
    end
    object tbsReg: TTabSheet
      Caption = 'tbsReg'
      ImageIndex = 3
    end
    object tbsProfile: TTabSheet
      Caption = 'tbsFinish'
      ImageIndex = 4
      object lblBad: TTntLabel
        Left = 0
        Top = 65
        Width = 402
        Height = 90
        Align = alTop
        AutoSize = False
        Caption = 
          'Your Registration to this service has Failed! Press Previous to ' +
          'go back and verify that all of the parameters have been filled i' +
          'n correctly. Press Cancel to close this wizard.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
      end
      object lblOK: TTntLabel
        Left = 0
        Top = 0
        Width = 402
        Height = 65
        Align = alTop
        AutoSize = False
        Caption = 
          'Your Registration to this service has been completed Successfull' +
          'y.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
      end
    end
  end
end
