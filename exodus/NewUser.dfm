inherited frmNewUser: TfrmNewUser
  Left = 216
  Top = 120
  Caption = 'New User Registration Wizard'
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 416
  ExplicitHeight = 390
  PixelsPerInch = 96
  TextHeight = 13
  inherited TntPanel1: TTntPanel
    ParentColor = True
    inherited Panel3: TPanel
      ParentColor = True
      inherited btnBack: TTntButton
        OnClick = btnBackClick
      end
      inherited btnNext: TTntButton
        Left = 90
        Top = 6
        OnClick = btnNextClick
        ExplicitLeft = 90
        ExplicitTop = 6
      end
      inherited btnCancel: TTntButton
        OnClick = btnCancelClick
      end
    end
  end
  inherited Panel1: TPanel
    ParentColor = True
    inherited lblWizardTitle: TTntLabel
      Width = 99
      Caption = 'New User Wizard'
      ExplicitWidth = 99
    end
    inherited lblWizardDetails: TTntLabel
      Caption = 'This wizard will create a new jabber account for you.'
    end
  end
  inherited Tabs: TPageControl
    inherited TabSheet1: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 27
      ExplicitWidth = 402
      ExplicitHeight = 226
      object TntLabel1: TTntLabel
        Left = 0
        Top = 0
        Width = 402
        Height = 39
        Align = alTop
        Caption = 
          'You must select a server to use for your jabber account. This se' +
          'rver may be a local server provided by your internet service pro' +
          'vider, or you may use one of the public jabber servers.'
        WordWrap = True
        ExplicitWidth = 392
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
      object optServer: TTntRadioButton
        Left = 16
        Top = 60
        Width = 321
        Height = 17
        Caption = 'Select a Jabber Server'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
      object optPublic: TTntRadioButton
        Left = 16
        Top = 124
        Width = 321
        Height = 17
        Caption = 'Get a list of public Jabber Servers'
        TabOrder = 2
      end
    end
    object tbsUser: TTabSheet
      Caption = 'tbsUser'
      ImageIndex = 5
      object lblUsername: TTntLabel
        Left = 16
        Top = 64
        Width = 143
        Height = 13
        Caption = 'Enter your desired username:'
        Visible = False
      end
      object lblPassword: TTntLabel
        Left = 16
        Top = 121
        Width = 142
        Height = 13
        Caption = 'Enter your desired password:'
        Visible = False
      end
      object txtUsername: TTntEdit
        Left = 41
        Top = 80
        Width = 248
        Height = 21
        TabOrder = 0
        Visible = False
      end
      object txtPassword: TTntEdit
        Left = 41
        Top = 137
        Width = 248
        Height = 21
        PasswordChar = '*'
        TabOrder = 1
        Visible = False
      end
      object optNewAccount: TTntRadioButton
        Left = 16
        Top = 8
        Width = 305
        Height = 17
        Caption = 'I need to create a new Jabber account'
        Checked = True
        TabOrder = 2
        TabStop = True
        OnClick = optExistingAccountClick
      end
      object optExistingAccount: TTntRadioButton
        Left = 16
        Top = 32
        Width = 305
        Height = 17
        Caption = 'I already have a Jabber account'
        TabOrder = 3
        OnClick = optExistingAccountClick
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
        ExplicitWidth = 66
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
      inline xData: TframeXData
        Left = 0
        Top = 0
        Width = 402
        Height = 226
        Align = alClient
        Color = 13681583
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
        ExplicitWidth = 402
        ExplicitHeight = 226
        inherited Panel1: TPanel
          Width = 402
          Height = 226
          ExplicitWidth = 402
          ExplicitHeight = 226
          inherited ScrollBox1: TScrollBox
            Width = 392
            Height = 216
            ExplicitWidth = 392
            ExplicitHeight = 216
          end
        end
      end
    end
    object tbsReg: TTabSheet
      Caption = 'tbsReg'
      ImageIndex = 3
    end
    object tbsFinish: TTabSheet
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
          'Your Registration to this service has Failed! Press Back and ver' +
          'ify that all of the parameters have been filled in correctly. Pr' +
          'ess Cancel to close this wizard.'
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
          'y. You can now add contacts to your Contact List by selecting To' +
          'ols | Contacts from the main menu.'
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
