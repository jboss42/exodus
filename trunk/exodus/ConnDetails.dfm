inherited frmConnDetails: TfrmConnDetails
  Left = 513
  Top = 170
  BorderStyle = bsDialog
  Caption = 'Connection Details'
  ClientHeight = 354
  ClientWidth = 488
  Constraints.MinWidth = 378
  DefaultMonitor = dmDesktop
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 494
  ExplicitHeight = 386
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TTntPageControl
    Left = 111
    Top = 0
    Width = 379
    Height = 316
    ActivePage = tbsAdvanced
    Anchors = [akLeft, akTop, akRight]
    Style = tsButtons
    TabOrder = 0
    object tbsAcctDetails: TTntTabSheet
      Caption = 'Account Details'
      ImageIndex = -1
      TabVisible = False
      DesignSize = (
        371
        306)
      object lblServerList: TTntLabel
        Left = 215
        Top = 292
        Width = 145
        Height = 12
        Cursor = crHandPoint
        Anchors = [akRight, akBottom]
        Caption = 'Download a list of public servers'
        OnClick = lblServerListClick
      end
      object pnlAccountDetails: TExBrandPanel
        Left = 0
        Top = 0
        Width = 215
        Height = 201
        AutoSize = True
        TabOrder = 0
        TabStop = True
        AutoHide = True
        object btnRename: TTntButton
          AlignWithMargins = True
          Left = 0
          Top = 175
          Width = 119
          Height = 23
          Margins.Left = 0
          Margins.Top = 6
          Margins.Right = 96
          Align = alTop
          Caption = 'Rename this profile...'
          TabOrder = 5
          OnClick = btnRenameClick
        end
        object chkSavePasswd: TTntCheckBox
          AlignWithMargins = True
          Left = 0
          Top = 154
          Width = 215
          Height = 15
          Margins.Left = 0
          Margins.Top = 6
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Save pass&word'
          TabOrder = 4
          OnClick = chkSavePasswdClick
        end
        object chkRegister: TTntCheckBox
          AlignWithMargins = True
          Left = 0
          Top = 132
          Width = 215
          Height = 16
          Margins.Left = 0
          Margins.Top = 6
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = 'This is a new account'
          TabOrder = 3
        end
        object pnlPassword: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 84
          Width = 215
          Height = 36
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          TabOrder = 2
          TabStop = True
          AutoHide = False
          object lblPassword: TTntLabel
            Left = 3
            Top = 0
            Width = 47
            Height = 12
            Caption = 'Password:'
            FocusControl = txtPassword
            Transparent = True
          end
          object txtPassword: TTntEdit
            Left = 0
            Top = 15
            Width = 208
            Height = 20
            PasswordChar = '*'
            TabOrder = 0
          end
        end
        object pnlServer: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 42
          Width = 215
          Height = 36
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          TabOrder = 1
          TabStop = True
          AutoHide = False
          object lblServer: TTntLabel
            Left = 3
            Top = 0
            Width = 34
            Height = 12
            Caption = 'Server:'
            FocusControl = cboServer
          end
          object cboServer: TTntComboBox
            Left = 0
            Top = 15
            Width = 208
            Height = 20
            ItemHeight = 12
            TabOrder = 0
            OnExit = doJidExit
            OnKeyPress = txtUsernameKeyPress
            Items.Strings = (
              'jabber.org'
              'jabber.com')
          end
        end
        object pnlUsername: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 215
          Height = 36
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          TabOrder = 0
          TabStop = True
          AutoHide = False
          object lblUsername: TTntLabel
            Left = 3
            Top = 0
            Width = 48
            Height = 12
            Caption = 'Username:'
            FocusControl = txtUsername
            Transparent = True
          end
          object txtUsername: TTntEdit
            Left = 0
            Top = 15
            Width = 206
            Height = 20
            TabOrder = 0
            OnExit = doJidExit
          end
        end
      end
    end
    object tbsAdvanced: TTntTabSheet
      Caption = 'Advanced'
      TabVisible = False
      object pnlAdvanced: TExBrandPanel
        Left = 0
        Top = 0
        Width = 341
        Height = 246
        AutoSize = True
        TabOrder = 0
        TabStop = True
        AutoHide = True
        object pnlResource: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 341
          Height = 36
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          TabOrder = 0
          TabStop = True
          AutoHide = False
          object Label12: TTntLabel
            Left = 3
            Top = 0
            Width = 45
            Height = 12
            Caption = 'Resource:'
            Transparent = True
          end
          object cboResource: TTntComboBox
            Left = 0
            Top = 15
            Width = 230
            Height = 20
            ItemHeight = 12
            TabOrder = 0
            OnExit = doJidExit
            OnKeyPress = txtUsernameKeyPress
          end
        end
        object pnlRealm: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 42
          Width = 341
          Height = 36
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          TabOrder = 1
          TabStop = True
          AutoHide = False
          object TntLabel2: TTntLabel
            Left = 3
            Top = 0
            Width = 57
            Height = 12
            Caption = 'SASL Realm:'
            Transparent = True
          end
          object txtRealm: TTntEdit
            Left = 0
            Top = 15
            Width = 230
            Height = 20
            TabOrder = 0
          end
        end
        object pnlPriority: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 84
          Width = 341
          Height = 38
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          TabOrder = 2
          TabStop = True
          AutoHide = False
          object Label6: TTntLabel
            Left = 3
            Top = 0
            Width = 37
            Height = 12
            Caption = 'Priority:'
            Transparent = True
          end
          object txtPriority: TExNumericEdit
            Left = 0
            Top = 15
            Width = 94
            Height = 25
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            Text = '0'
            Min = -128
            Max = 127
            DesignSize = (
              94
              25)
          end
        end
        object pnlKerberos: TExCheckGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 140
          Width = 341
          Height = 39
          Margins.Left = 0
          Margins.Top = 12
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          AutoSize = True
          TabOrder = 3
          TabStop = True
          AutoHide = False
          Caption = 'Use Kerberos Authentication'
          Checked = False
          OnCheckChanged = chkWinLoginClick
          object chkWinLogin: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 23
            Width = 341
            Height = 16
            Margins.Left = 0
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alTop
            Caption = 'Use Windows login information'
            TabOrder = 1
            OnClick = chkWinLoginClick
          end
        end
        object pnlx509Auth: TExCheckGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 197
          Width = 341
          Height = 43
          Margins.Left = 0
          Margins.Top = 12
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          AutoSize = True
          TabOrder = 4
          TabStop = True
          AutoHide = True
          Caption = 'Use x.509 Certificate Authentication'
          Checked = False
          OnCheckChanged = chkx509Click
          object pnlx509Cert: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 20
            Width = 341
            Height = 23
            Margins.Left = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            TabOrder = 1
            TabStop = True
            AutoHide = False
            object btnx509browse: TTntButton
              Left = 218
              Top = 0
              Width = 120
              Height = 23
              Caption = 'Select Certificate...'
              Enabled = False
              TabOrder = 0
              OnClick = btnx509browseClick
            end
            object txtx509: TTntEdit
              Left = 0
              Top = 2
              Width = 208
              Height = 20
              Enabled = False
              ReadOnly = True
              TabOrder = 1
            end
          end
        end
      end
    end
    object tbsConnection: TTntTabSheet
      Caption = 'Connection'
      ImageIndex = -1
      TabVisible = False
      object pnlConnection: TExBrandPanel
        Left = 0
        Top = 0
        Width = 222
        Height = 210
        AutoSize = True
        TabOrder = 0
        TabStop = True
        AutoHide = True
        object pnlSRV: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 222
          Height = 38
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          TabOrder = 0
          TabStop = True
          AutoHide = True
          object optSRVManual: TTntRadioButton
            AlignWithMargins = True
            Left = 0
            Top = 19
            Width = 222
            Height = 16
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Align = alTop
            Caption = 'Specify host and port:'
            TabOrder = 0
            OnClick = SRVOptionClick
          end
          object optSRVAuto: TTntRadioButton
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 222
            Height = 16
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Align = alTop
            Caption = 'Automatically discover host and port'
            TabOrder = 1
            OnClick = SRVOptionClick
          end
        end
        object pnlManualDetails: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 38
          Width = 222
          Height = 72
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          AutoSize = True
          TabOrder = 1
          TabStop = True
          AutoHide = True
          object pnlHost: TExBrandPanel
            AlignWithMargins = True
            Left = 20
            Top = 0
            Width = 202
            Height = 36
            Margins.Left = 20
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alTop
            TabOrder = 0
            TabStop = True
            AutoHide = False
            object Label4: TTntLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 24
              Height = 12
              Caption = 'Host:'
              Transparent = True
            end
            object txtHost: TTntEdit
              AlignWithMargins = True
              Left = 0
              Top = 16
              Width = 200
              Height = 20
              TabOrder = 0
            end
          end
          object pnlPort: TExBrandPanel
            AlignWithMargins = True
            Left = 20
            Top = 36
            Width = 202
            Height = 36
            Margins.Left = 20
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alTop
            TabOrder = 1
            TabStop = True
            AutoHide = False
            object Label7: TTntLabel
              Left = 3
              Top = 0
              Width = 23
              Height = 12
              Caption = 'Port:'
              Transparent = True
            end
            object txtPort: TTntEdit
              Left = 0
              Top = 16
              Width = 57
              Height = 20
              TabOrder = 0
              Text = '5222'
            end
          end
        end
        object pnlSSL: TExGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 128
          Width = 222
          Height = 82
          Margins.Left = 0
          Margins.Top = 12
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          TabOrder = 2
          TabStop = True
          AutoHide = True
          Caption = 'SSL modes:'
          object optSSLoptional: TTntRadioButton
            AlignWithMargins = True
            Left = 0
            Top = 20
            Width = 222
            Height = 16
            Margins.Left = 0
            Margins.Right = 0
            Align = alTop
            Caption = 'Encrypt the connection whenever possible'
            TabOrder = 1
            OnClick = optSSLClick
          end
          object optSSLrequired: TTntRadioButton
            AlignWithMargins = True
            Left = 0
            Top = 42
            Width = 222
            Height = 15
            Margins.Left = 0
            Margins.Right = 0
            Align = alTop
            Caption = 'All connections must be encrypted'
            TabOrder = 2
            OnClick = optSSLClick
          end
          object optSSLlegacy: TTntRadioButton
            AlignWithMargins = True
            Left = 0
            Top = 63
            Width = 222
            Height = 16
            Margins.Left = 0
            Margins.Right = 0
            Align = alTop
            Caption = 'Use old SSL port method'
            TabOrder = 3
            OnClick = optSSLClick
          end
        end
      end
    end
    object tbsProxy: TTntTabSheet
      Caption = 'Proxy'
      ImageIndex = -1
      TabVisible = False
      object pnlProxy: TExBrandPanel
        Left = 0
        Top = 0
        Width = 237
        Height = 259
        AutoSize = True
        TabOrder = 0
        TabStop = True
        AutoHide = True
        object pnlSocksType: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 237
          Height = 36
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          TabOrder = 0
          TabStop = True
          AutoHide = False
          object lblSocksType: TTntLabel
            Left = 3
            Top = 0
            Width = 27
            Height = 12
            Caption = 'Type:'
            Transparent = True
          end
          object cboSocksType: TTntComboBox
            Left = 0
            Top = 15
            Width = 234
            Height = 20
            Style = csDropDownList
            ItemHeight = 12
            TabOrder = 0
            OnChange = cboSocksTypeChange
            Items.Strings = (
              'None'
              'Version 4'
              'Version 4a'
              'Version 5'
              'HTTP')
          end
        end
        object pnlSocksHost: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 42
          Width = 237
          Height = 36
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          TabOrder = 1
          TabStop = True
          AutoHide = False
          object lblSocksHost: TTntLabel
            Left = 3
            Top = 0
            Width = 24
            Height = 12
            Caption = 'Host:'
            Transparent = True
          end
          object txtSocksHost: TTntEdit
            Left = 0
            Top = 15
            Width = 234
            Height = 20
            TabOrder = 0
          end
        end
        object pnlSocksPort: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 84
          Width = 237
          Height = 36
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          TabOrder = 2
          TabStop = True
          AutoHide = False
          object lblSocksPort: TTntLabel
            Left = 3
            Top = 0
            Width = 23
            Height = 12
            Caption = 'Port:'
            Transparent = True
          end
          object txtSocksPort: TTntEdit
            Left = 0
            Top = 15
            Width = 82
            Height = 20
            TabOrder = 0
          end
        end
        object pnlSocksAuth: TExCheckGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 146
          Width = 237
          Height = 107
          Margins.Left = 0
          Margins.Top = 20
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          AutoSize = True
          TabOrder = 3
          TabStop = True
          AutoHide = True
          Caption = 'Authentication Required'
          Checked = False
          object pnlSocksUsername: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 23
            Width = 237
            Height = 36
            Margins.Left = 0
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            TabOrder = 1
            TabStop = True
            AutoHide = False
            object lblSocksUsername: TTntLabel
              Left = 3
              Top = 0
              Width = 48
              Height = 12
              Caption = 'Username:'
              Transparent = True
            end
            object txtSocksUsername: TTntEdit
              Left = 0
              Top = 15
              Width = 234
              Height = 20
              TabOrder = 0
            end
          end
          object pnlSocksPassword: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 65
            Width = 237
            Height = 36
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            TabOrder = 2
            TabStop = True
            AutoHide = False
            object lblSocksPassword: TTntLabel
              Left = 3
              Top = 0
              Width = 47
              Height = 12
              Caption = 'Password:'
              Transparent = True
            end
            object txtSocksPassword: TTntEdit
              Left = 0
              Top = 15
              Width = 234
              Height = 20
              PasswordChar = '*'
              TabOrder = 0
            end
          end
        end
      end
    end
    object tbsHttpPolling: TTntTabSheet
      BorderWidth = 2
      Caption = 'HTTP Polling'
      ImageIndex = -1
      TabVisible = False
      object lblNote: TTntLabel
        Left = 0
        Top = 246
        Width = 367
        Height = 56
        Align = alBottom
        AutoSize = False
        Caption = 
          'NOTE: You must use the URL of your jabber server'#39's HTTP tunnelli' +
          'ng proxy. You can not use some "standard" HTTP proxy for this to' +
          ' work. Contact your server administrator for additional informat' +
          'ion.'
        Visible = False
        WordWrap = True
        ExplicitTop = 247
        ExplicitWidth = 368
      end
      object pnlPolling: TExCheckGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 213
        Height = 165
        Margins.Left = 0
        AutoSize = True
        TabOrder = 0
        TabStop = True
        AutoHide = True
        Caption = 'Use HTTP Polling'
        Checked = False
        object pnlURL: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 23
          Width = 213
          Height = 36
          Margins.Left = 0
          Margins.Top = 6
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          TabOrder = 1
          TabStop = True
          AutoHide = False
          object Label1: TTntLabel
            Left = 3
            Top = 0
            Width = 22
            Height = 12
            Caption = 'URL:'
            Transparent = True
          end
          object txtURL: TTntEdit
            Left = 0
            Top = 16
            Width = 208
            Height = 20
            TabOrder = 0
          end
        end
        object pnlTime: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 71
          Width = 213
          Height = 38
          Margins.Left = 0
          Margins.Top = 6
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          TabOrder = 2
          TabStop = True
          AutoHide = False
          object Label2: TTntLabel
            Left = 3
            Top = 0
            Width = 44
            Height = 12
            Caption = 'Poll Time:'
            Transparent = True
          end
          object Label5: TTntLabel
            Left = 91
            Top = 23
            Width = 36
            Height = 12
            Caption = 'seconds'
          end
          object txtTime: TExNumericEdit
            Left = 0
            Top = 16
            Width = 86
            Height = 25
            BevelOuter = bvNone
            TabOrder = 0
            Text = '0'
            Min = 0
            Max = 1000000
            DesignSize = (
              86
              25)
          end
        end
        object pnlKeys: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 121
          Width = 213
          Height = 38
          Margins.Left = 0
          Margins.Top = 6
          Margins.Right = 0
          Margins.Bottom = 6
          Align = alTop
          TabOrder = 3
          TabStop = True
          AutoHide = False
          object Label9: TTntLabel
            Left = 3
            Top = 0
            Width = 76
            Height = 12
            Caption = 'Number of Keys:'
            Transparent = True
          end
          object txtKeys: TExNumericEdit
            Left = 0
            Top = 16
            Width = 86
            Height = 25
            BevelOuter = bvNone
            TabOrder = 0
            Text = '0'
            Min = 0
            Max = 1000000
            DesignSize = (
              86
              25)
          end
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 317
    Width = 488
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    TabStop = True
    object Panel1: TPanel
      Left = 246
      Top = 0
      Width = 242
      Height = 37
      Align = alRight
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      TabStop = True
      object btnOK: TTntButton
        Left = 12
        Top = 7
        Width = 69
        Height = 23
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
        OnClick = frameButtons1btnOKClick
      end
      object btnCancel: TTntButton
        Left = 87
        Top = 7
        Width = 69
        Height = 23
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
        OnClick = btnCancelClick
      end
      object btnConnect: TTntButton
        Left = 162
        Top = 7
        Width = 69
        Height = 23
        Cancel = True
        Caption = 'Connect'
        ModalResult = 6
        TabOrder = 2
        OnClick = btnConnectClick
      end
    end
    object ExGradientPanel1: TExGradientPanel
      Left = 0
      Top = 0
      Width = 488
      Height = 5
      BevelOuter = bvNone
      TabOrder = 1
      GradientProperites.startColor = clTeal
      GradientProperites.endColor = 13681583
      GradientProperites.orientation = gdVertical
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 114
    Height = 316
    BevelInner = bvLowered
    BevelOuter = bvNone
    BorderWidth = 8
    ParentColor = True
    TabOrder = 2
    DesignSize = (
      114
      316)
    object pnlTabs: TExBrandPanel
      Left = 9
      Top = 9
      Width = 94
      Height = 295
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Anchors = [akTop]
      AutoSize = True
      Color = 13681583
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      TabStop = True
      AutoHide = True
      object imgConnection: TExGraphicButton
        AlignWithMargins = True
        Left = 0
        Top = 59
        Width = 94
        Height = 59
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        BorderWidth = 5
        Caption = 'Connection'
        ImageEnabled.Data = {
          89504E470D0A1A0A0000000D4948445200000066000000400806000000E82A02
          490000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C0000126E4944415478DA
          ED9B097455F59DC7BF77794BDECBFA9290C424040811612220B2C822B254C54A
          8B14A5EDB15AC665ACC5AA637BAC16ED383AE0822D5AB1870AAE48D5A1A2C8D2
          8A50179045469648644F58B241F6BCBCBCFBEE3ABFFF5DF26E0247AD679C3E39
          EFCFF971EF7DB9EBFFF3FFADFF7B39C330906C89D7B82498C46C493009DA9260
          12B47D2BC0701CF70F1FE25AF61677731E5EEFB574FFED4BDB37D187E7121867
          27DE5E17EC75D1B5ED8663D8A2DBA2D9A2BBC4D9EF0B5B4282F91AA3F99B68EC
          2678C44130F1B8C4F9CD81C69A034575894CA2B8B6BF12A02498B35CDE5E0AB6
          78990CBAE29AFC0B86978FF0E4148F480DFA47D47A4ACB385ECC9174D1D3AC04
          6068AA2ACAED2DB168B84A6A6DDC173D55BD27B27FEBBEC8AE0DB574BC644B0C
          71480C8EA36167B424985E9746DC4431ADF0F61973656EC9F45BAE189827FC60
          46C6DE4963C5BDBCCC7951A51581377434EB69A88CF5C561B900FB6385503515
          86AE41D63444DB1A774A270F6CE8DCFEF6C6D8C1ED7574BE084917E28098993B
          2B9C6F2D9882C2D27FF8BC46E90FBBD71B3E5A70C6651187C2B42465F83DCF8C
          CE2A1FFFEF426AD6944CAE83BF917F03A3B01B612E0D29D4B79C7D54AD9A8BED
          B1C178AE7D1A24999D2006C188216602D2116D69D829EDFDFB8B91BF2DF9988E
          E820E984A541CCCC393EA847A725C19C09C5C7A08C7BECCDD9E9FDCA7F29FA7C
          FD63F453AE710A3F3396A118B5881216EB201D06C7E3F1F00D3848DA72B97F07
          ED296165EB18B4283EA2DB0985C1510D285267A374F8D3E591D77EFB1A1DDA06
          0B501496F6A8E8A53949307130CC91334D094CFCDD9A3919FDCBE7F11E4F8641
          7F6220C6695B70B3BA0C512E009DEE8FDD23C71BE0E9C80FE58BD0A6053123E5
          63047909DBA36558DA381195913CEA0C090A993545D7A1CA724C3AB2EBE5E88A
          FB5FA0EBB4DA801CD3D6C3AC9DF360EA6B8FBAF30FF7D20DC5315F81098FAFFA
          5168D08887058F2F9DA35E5789579E518F1BA4A528326A20F37E7002670271E2
          310FA741E00C6806C1A27EF5511FEFECEA878575DF415557887A5932C128AA06
          555164F9C0D665D2CA8797D3D14D24ED6781736E82B16138E2CE41DCDB706D33
          6DF10FBD7DC1D8BE53AE5DE809A6950802FDCCF3A6A99AD5B51C1395F7101632
          20084C5BE84001D69263BB59CFABD3E97CBC8AA8EAC5CBA7C7637573393A1401
          AAAE90D690C63030A43DAAD4D5AA7CB2FA49F9FD17DFEB054781ED6FCE39302E
          2802E2B986234E08EC06C3B6FD69C565D9637EFBCAFCD482BE97F11E81008830
          48424613E6B6CD472A1F812678182B326196F0DD7038F34C1CA7532867A041CE
          C0BECE023C5F7F098E44B22C8D2130CCDFA8AA0E8DD6F596BA7DB1358B1ED14E
          541CB4E18461F91CF59C036343E1110F777D974E9D9E3BE98AEF8D2EEA5B3232
          2D2334BCBDBDE3B4750DB21B9AC6A9728C8F767509555C6A49C379170E153C1E
          4E60604402237A90460EFCC68E45E867544116FCF43B4C33C6CC590FAD215326
          12984F3A066049CD141C8D3013A698FE254621B4E567E260C07C4EE587CBA4B7
          1F6326AD81A4055638CD2235FD9B20F3CF04E340F15D3D6B4EC13DF7CD7B3310
          0C5CC886364F9D2CF8284E8ACADDF65B67119324A12DDC894DCD1C1A8574DA8F
          A098600470044713FD98155E86A9F25A7478B2E97772F844C627AAB42F4C53A7
          D35848132534C432F1F303737028DC07E95C3B14CA7314821223182C6C66EB0C
          8A6A8331DA1BABA4758B1ED6AA777F46B7D308CBA4995A73CE8071698BE9C497
          BFB36D69F9B0413353435964E7818A7D35A8D85B85F6B6083A0804D1A14490AC
          0693AC3444070F83E8F39826CC84C3C008020C823A3DF63A466ADB912E761128
          0F5244052A47668D74D227A8F0925F69D132F056C348BC74723CAB02D0B91582
          6190101813CA991AC3EE41D9B97A51ECBD3FBD0D4B6B9A61E538F2B906C674E2
          773CF0ECF7AFB96EC6ABC5FD0BD11056F0D20B1BB079E3E6E670534D05C54E92
          DCD97CDC26C3E99AE22D9979FDA58593A79579441ECCE933202281619AA69346
          8CD6B6622476E05F84FDA44D1C6A8DF3B0AA730A75348F54AE13E5C16AB42A01
          2C3C321D01DA3634326194BBC80442E90663C131C1E87130DA89CF36465FFDF5
          EFE9BE6B60690DF33512F5A1762E81617E2570FBC3CB1F9A3E63EA5D857D0B70
          B0BA094F3DFA8ABA73EDE3F3D4E8E97A58D10F33178A0D323076D1BB0FA61595
          0DF3101481E0F00486272FCF913030697A18A3F81D98E15D873C7F1BDEE99A82
          C74ECF814467107509A5BE1A4CCEDA8BA5551329E38958398B6DBE1C8D511D30
          044B671AA359754C23DC7C32F2CC0D77D3EA099253B0739B730D0C3363C13133
          EFFBF18DFF76E3E2D1A307A3EAD869FCF1F72BDA3E5C71CFBDB0CC047B70362A
          633698B4CB5EDCB3C21B4CCB11784B63443324E64DAFCE6E25A20750C8D7625E
          DAD328F1D7E188D11F4F355C87039122F064B218844CB11D4D91140260D0B66A
          C291F5B88F51ED3C86698BEE9832D65439DAF9C43537D31A69713C08A03E54CE
          3530A929396525B3EF7A74F5F7674C2CCAC9CEC4CA37DEC76BCF3EF64CF3D1F7
          3F80159A3238920D26F3B2E5FB3FA2284C605078BAB6682F61475C8A2E9AE597
          6B83EB313BEB5DF8BD066AB53E7492542CAE9E86BDAD7D4D7F2568B2A911AAE9
          5B2C6D5134DBF1332DD218188D4C9D110743F6AC73C1D57368E518499D0D26FC
          6D0573B6D944C7F1A792648DB87CCE776FFBD5BD4F8E1839181F7EF439FEFCC2
          9F2B76AD997F3FFDEDB4FDF04C635804179AF8CAFEDD42B7F9E2CCA88BB3B585
          9D983D8DAAD3DF29C5181BD88351C1FD98103A80149F8A39BB6FC7D170AE59B4
          B41CBB666A870946B7CC976C9B32260C0CEDD4A364D9B9E0BB4C63AA49D81441
          B30D46FEB680E99DAD3BA1B1B3EC2EAB9064DEF9C0A239D3665D7767B04F1FAC
          5DB30B7F5DB5E6E4BE0DF36F8265C79B6D30CC278526BC5459696A0B03C35970
          2C287132E60C180D724913A8A3794CCCD883D985DB104AE9C2239F4DC79EE602
          88D49792CA748034C3B07317A74EC68011188385C99ADEE3C108CC2D2E304CA3
          3BA90F63890CA6B766082E7166119DA50966FCE4AB8A7E76E7BD770FBAB07CBA
          EC0BE26F1B3FC7C6773FC1816D6F3FD7767CC30A1B0CD318D906191ABFB4A292
          B27DC171F88EB698FF19F6955910C700516EA253E786651FFC5C179E1FF53C5E
          AA1A8BB78F9523D3D389744F18273B53D11AA31C88CC1B4FFC99995375C33CCE
          F22F3D0BC904E6561B4C9D0D269CC860DC66CA29AF38D3BABED9773C7CC10517
          4F9AD9A7B8DF0F3CBE400159113089C534086A0C93C71563C973EF62F3A66D72
          FDE1ED2BDA8EBDBBD27E68A62DCCC7A80E98D18B776C11FD815C06C62CB9D0F5
          0D078E0D863D1267C2314C07CED6DB635E4CC83E882B0BF7615F6B01066536E0
          D2BC6AAC3D36107F3D3900CD92888AD610DA62025238C934853AF917CEDD3F9A
          22753E3E632EBE25A6AC3710737A77FAF5738BC75E39EBDA82E27E33D2B2B286
          885E561FF142A34766731E314543382CA3E9740B766CDC8CA39515F5272ADE5A
          24B71FFD1C5656DD827854C6EC099B7B095DF4C47BCB7D19B997383EC6A97DF5
          2C445BF6CC30D31F4B6B0C1AF95D8A8029F99F5318DD815F0CFE18A99E280C55
          40972CA293B466C167A3F0FEA9F370B03D1D9434D105D59EAFCD74B63444FEF0
          935FC372FEF52E3009E9FCBBA777AFB8EEE6D0E4EF5D3F2B27BF60564161DE44
          5F8A0FCC51B35288A27390E9F6250624A2A0B53582A6E64ED49F0E63FD92059B
          9A0EAD5961689253BD6DB597660267F534FC249943EE5F312FB5E8825B78B3A2
          6C3B7ED3BFB89EC360057DC30663C1D174C34C476ABB52312EE708968C5E45A6
          2C460344A49BD76834A9E88879D0DAE5C5130786E385AA21F0722A3CBCD68D5C
          3B5EB12DBAE2BEC53698840F97BB4BF1373FF8E6E23EB9A189F9C5D9C1920105
          D95E9F97854D34B29913A64C2CAAA2B1B13D5A5D55DBEE0B15E6AB8A8213274E
          C9FF7DDFD83B6C18CDE8A9290C8AF3D06C2A32BD64CEFC99D9232E7F8A2732A6
          B2F096C2BA6310EB912C3F636A0B336924318D43B6B7037FBA7815FAA5B620AA
          794C5D6481020BBE9886A4D0E59A08CE839563F07275393CA2624E0FB06BC8DB
          FFF28AFCF71756D3C64958FE8FDD7394CEAF26221827C20A8E9BFDDCD606044A
          3D9AA6A70AB1B601799EB682BCA09655D027104CCF0C1C3A5059955972D1F99E
          607A86A6A8A441326A4F34482BE74D9C6B3FE8691B8E33E7C11E9865D54E789D
          9E396C7259FEAC5F2EF265E45DCC73AE527EAF666A0BCB685C60C2AA88B9FDB7
          E05783B6A0490E58004D78860948B3CB717E8A35DA252F76B4E4E1AD53A5587D
          6A207C918686D83B0BFFA09DA8D88B7849864D39276C49868161A3396DFC554F
          7D1AC8C82C5004B2D90667B42AAC0665204394BBE4B6EA43D7DD76FB45EC188D
          257332819165D41098B7FE63328B74EA100F8F9D1720DC2F3E98F0494245B7FE
          EE5FD3878CFF0D6F9A313BEA706B0C60476506ABC9939029A3ED88EA31C1DC33
          701B5A951438BE8839798395C358CAC2AA013A8BE365B034E6EEFD93B0B27E30
          FCFBD7AC91D63DBD927664E518E65F5A102F62EA5FD64FFF0C30660D8B24FDB2
          E94FEF0C6585F2FD295E04533C08043C304401AD9430B44763C6D029E338DD2C
          771098984C60C8941DAB89AE9B3FED0658510ED39836FB814D135650586AB88B
          9E241981B251A5B93FBC7FA1372B6F14CF94C9C9635C684C38CC4CB17FB6C6C8
          ACC3B918165FB81EE34327D12EFBCDE965BB466942D1CDF760AC29E7576B07E1
          C12313C0B7D51E57D63EF99C5653B9CFBECF46FB3E13BAECCF426236FC32A7CE
          7C76476E4E283F406002042618648048821E2864B63A8A2F2073A19A4014D296
          D6D60EECFF9F5D8777BDF6F3BB608D42C7F94B04A4DBA1F69A2630B5267BC65D
          9707465EFD1085CE39B697B191B8C0306D60B98CB9B4E044280A9B46CE7F59F9
          7A74E91E330175F21EDD7E39C94F63A25E0AE0A795D350D9921EF5EE78F93579
          EB1B9B6C284E6EC57C60424F948936988C2BAFFDE3CEFE25F9F965A5B99024AB
          9C9E4A5AC340494A0CA7B3FB9BDA227549D4D94DFAA14F37ADDFBFEEB1573435
          760A7167CAB4254660BAED3681312F85B8D6A4936467FFF4D139FE4163E752A2
          E93D4BB46C75B61D9D69765E43412165FD2A6E29DA8B9B8AF6214D901155793B
          F7610F22A34B13F19F472FC1AB754334FFC10D1BA47716FE0596A96DB0078FE9
          5B606975C24E2D3B3E2675C295F36EEB5B32E086A1E5A5A5FD8AB3909EE6A724
          92698886A696300E887968A330B9A1F6F8E9FDEF2D5956B367FD6E58A3CF89C6
          9CB97485C074DB6D1718A6358E866690E466CD79E2564FE9881B395EF4B9EFCB
          0C976D5366D850743B5AEB903DC811A3787DF81A0C0D36A159F6996FCF043919
          5BDB0AF02AF994D58D0375F1F0E60F62ABFEEB757BD030719B30535B12190CEB
          2C9FDD596C2487868D9A39A66CF0C8A9D9D93945A1ACB4CCD4BCC2FCB0E1F71D
          EB84D67078F7D6ED2B7EF3BAD4D9E2445F6DF6D279A9CE7CE391F9965E601C38
          3DEA6C2439693F7AE827E2C0913FE6BD2921E720C371EC3614746B0F05018A07
          B3F20EE0A9F33F304D5990572090E7DFDC5E885F1CFA0E6ADBFD5DBEEAF73F8C
          BDF3C45B360C272861F7EACCF53B2FFE25ECEB4BDD73F7369C345855E3B49C3E
          C539397945D9A1DCBED96149526B8F5636B69C3AE2CC95339315B69711C427C4
          CC07FE0230EEB7301D3821FFD49B2689E593AFE733F3CA9D9D0DA7D3E2611A24
          9D474890F0D290F598945943D1990F55D10C6C6A2DC1D2FA61A83B153EE1A958
          B341DEB6721B2CB3C5C0B4D88387DDE7196F63262A18F7FB5E5E1720BF2D3E62
          E71935FEAAFC4FB6ACABB33B5FB64138D2E3C56D37945E60DC7044F4D4D42CA1
          FFF0019E8BAE9A2A140F99C4A5E5965974EC53D90E5E32443CD26F0BEEEDFB09
          B6759C87D54D03B1B679200E9F92EBB463159F0A9FADDBA19DACACB661B4DAD2
          819E9AD2E3FDE5440603C44BFAEE02A617F16AB25366D410FF0EC5FD3DCA177E
          EAD0FBB2AEEB796D38A936A00CA174D40071C088A17CDE800BF9ACF3CEE752D2
          72207AFCB22EF263336AF140DF6DC6F2BA32E983FACCB69AFAB62ABDEED061EE
          D8A7478CE3BB8FDB10DA1137AF4CA31D137B06944406E37494BBC3DCF32ECEB6
          03C681E364F5DDAF9A7E45286E386E9FE3684FD086C424600BFB9B33E5E0FE70
          C9F940C9F9262682B86965CBDE9F619C0125D1C1F4EE3077C7F1BD7E77BEE472
          6BC7D7BD09F735BA2BDBE8654A71A6E63AD7740608EB7806C001E436AFCE003A
          A73E5CFAB279E7FF8B27729B520790E72CE2D65CE7DACEA77C0E1CB779757F93
          F985F7FA6D04F3FFD97A037220B9A7B5DDFBB1E6C0D170F60F649D7DBEB025C1
          7CC55B72ADF3BD9667FB6AD9BDFEB5CC6B428249B66FA625C124684B8249D096
          0493A02D0926415B124C82B62498046D493009DA926012B425C124684B8249D0
          960493A02D0926415B124C82B62498046D493009DA926012B425C124684B8249
          D0960493A0ED7F01BD407117468119A20000000049454E44AE426082}
        ImageSelected.Data = {
          89504E470D0A1A0A0000000D4948445200000066000000400806000000E82A02
          490000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C0000223E4944415478DA
          ED7C598C64D779DE776BAFEABDA77BB61E92434EF70C49D3B21391942829844C
          CBB10C507600390A4D4B8E9005590C034110E425D1436264710C240AA007C692
          0C2DB44585B014D90C1DD9922DD9A4B9D9222992D290226728CDDA3DDD53BDD6
          7EEFC9FF9FF53FA76A92D73C64C8EAAABA75EB9EE5FBBFEF5FCEB995FDC3CF7F
          FB03BDC6FC2714707F467FC07F54C6FFBB97F6597F480F05C52FE53FF15EB90F
          F93BD1794538554DFAA2BEB23FA4E0BE4F7F72D38FA88DCCF643B651D09B5201
          45E767256E5199BE17E3FD5359D2A67F1D0D461F537137CD717EC1FD2AD9EB15
          76EEE818E898EB83FE7E8ED066A1421FE8391343C832D5CB8AE1975BBB1BFF21
          FBD8E3AFFCEE89632B7FB33ED538A4279EC79C59200A810E4CC3DC016E706C0C
          13265C890186E399ED98781D5030ED727B85F293E02FE327D31E77DFD31D0E83
          757DE157195F27730625AEE5FAAFE4010B8E1DA71EBB3BA5707392189F9B5915
          F7571A198FA5907362FF28DF263C40459EE3E2B9371EC93EFAD8CBFDDB566FAB
          5D1F961D1FE839F313912973447F4D5A9E346D0985121D466CD5CA5AB06B259D
          CC2C7CDDB62B07215A1556A06CFF326BC54A5E84A7C3B52DAFA3E424896BDAD7
          1A6B08B6446C160C52E17AE1908ADA191F430C626448F64577EB7237FBE8975F
          56AB67D6B0D50BC69965CE9A5D07E1E91AA8A7444782C46562C06380F90E2861
          25EE3A62001E24FBDA5AABEF4F3A40FFFD6422ACB54A0B56C2CCFDB10828771D
          15115D254C306A5A041B10D6EF2558216983AF99457D0BF313E6A1B3751904CC
          4B6AEDCC196C76EDAC22743E83608BA5B3D34FF94F7956B98953F0908A4ECAC1
          47548F743C74508D7D299C27A5535927E2C11193A88AC21CCB8B71D9F1FF8CA4
          6659168C2213328BC024075A389005ABB7AA12B34BA8833736560EF7BDD838F8
          4D67F306C04473265F15F06045132BA5455C40C9E3D2FA24DC4A7E2E65450023
          D9E1C149185B141E083E5630106441453E22874CEF8B5C0F204CA2F5A7A59291
          C27209FC1F4A25FD59969522C3080C72D61EFA65DC91F52389748679282070F6
          A0C5F36AC6D365C67CECB197D5A933A7B1D93757C832E761B378620A20B66009
          4526AC5048858A108E2734628E74CA09908924F8A951A24D02A3E04927308A62
          A4C12886437AA6C770845C8343AF357B82FC640C45B9426094E97F7E54017A5F
          2AD1B172D9DA6909C21D06760BBF914676915377C0D9B1791F27A24A0F9C1D6E
          D730867CCCDA696CF59D8349230AD337A387C261433868D97139C92E6048A329
          246D249DF74691306EEC98F51F060C0265D4473E2000065D94473B74C2088DAC
          8B2BEAB0FE46AFA8606BD8A22F8C501FEDD1F3101502AC4E4EAC5129A356ADA2
          5CADA3448F72A50ED0B1128166E35E3B4E6710319BBC5445F226A53C8C29FD2C
          F5991D07CC1A33A657982FFBF0584A984A66574C72E69F2227688ECBCE0B3972
          D004346259BA8183F7FE433930E9FDC830A2180D30EC76D127C99ACDDAF850F3
          29DC577E1183AC8673F909728D05B68A19BCD6BF193F181CC3F7FB2B18D1F714
          9D3FA010B53238C074D1C75CBD827AAD8E4A630AA57A838853238088452C6DBA
          7B5904C6983449DF21E6230C47C5F3118164AED5D9BA647CCCEAE9335ACA0226
          4AE7304A907E9203F71194B0E830CF32AE0FB293D9C8649C11A9054AD94AA4AF
          3083719235EA1320C301FA2441C3FA14E6B18B5F297D19F7E045EC653368A26F
          6489FE5C1A2DE3D9FE1DF8AD9D0FA23720C5A2CFCAAAAF011D10EBAAFD3D1CA6
          6373CD26AAAD6994E97A9A45044EA665AD24E650B02491E5D8B064C4963025CA
          BBCC35BA9B972C634EAF116362498A40C983BBCEA4CE229E3061FC70398B8743
          24141198926E930281D4A1B23F61AE90958F0603E4044A6F44E0D00466B52A4D
          691DCB6A1DFF587D0637E112BA048BC184A3B2127E63EF63789DD8F2338DE7E8
          CC1E1E6FBF0BD78775D4B08F218333A246863D2C91D41D6956519B9A45B53183
          528DC1A96A7F64E2D5F0CF59BD8BB4FCB1D4D8A44A1481557E1EC618B3468C19
          D86FB89242A190C9E8CB812666554A8CF3C7E38961609B4CFEBCA7914EDECAA6
          2F0309D3F360158E29245DCC1402A5989A4356AD68D36020DE933F85BF3FFA0C
          BA598B889FE98026A33195E8BADF1EFC356CE753F885E6D3982AF5F06C770D9F
          BE763F5E3B38426DF63024C0870C3E317169D8C68A03A7358772AD81AC52D391
          5CE6653F916997E8BAD929DCE80AC1A270BE4C30DD09161872FEA76D82197900
          775141538F4EA61B0A052C215B0E7837B991B317F228017357E1A8C96AB53102
          595FB3A09055E743CB149A3CCC2D92B3E6C9CA30420547D4157CACF7699C5017
          3128D14496330D084C148C6A96A34C1DCB6D9E56274B7CA17312BF79F90338D7
          59A4767A1A98E188DA21D08F0EAEE378AB86FACC222ACD199236F23B048EA94B
          C5921C47682A323E339F71E013D71503D342B87C3B4959575AAD7BED324E154D
          903853847B5253859C250D3BE67826F9FCC324819CE617237B2CCF3D50A6F847
          93C512D6A7C91BF6A1E696506E910F289BFC83A5EAC39D2FE2FEE11F63AF4C16
          5ECEB4AFCECAC667F3A3648B8E05F5AC5E1AA13BAAE1F31BEFC5D7B6EEC2EEB0
          8C11456A43EAC7888019515B1919C12DF9160ECDCCA036B360C16912D8365AB3
          42792309935227FDA68B28DDE701CF02BDAD2B040C49D9A9D31C95A9F1928B90
          19653BE0F44CA94CB42D3A222312C4D9B3C0D5CB92B2FE22A7E84AE52607D191
          1631838FFB528696304A18875D0CBA44EF852554170F135BCA0400C9183D16D5
          267E75FBDF61BA74809C729292F1D5FA51F2E0647A1819194095AE7B75308757
          F78FE1B357DE8D370F160C630818F6372332909C5EB7FA3BB8ADDCC5F4EC02AA
          D3CC1C8AD8AA0D134A7BD6485F2A7C70514C18B79C5565882458D6F3524679CC
          B57E21347142D89A38F14C32439E237D4B662D3DCBA2E2A107857AA881A0C768
          D04336A06808032C93522C352BD8E90C3CEB3839CC3924EEF5B05E94B17E6895
          A2A50A3D08188A981439E61972E0BFB2FB5F70529DC3A0CC92032D632C67116B
          A85F1502E6F9DDDBF0C8C507F0D6014BD850FB973EF5C5F899000CB3FA58F72A
          8E4FD5519F2783989A277FD3D4911A54493792465B32990E652251BE51526D64
          69C603C3E13231A603EFF47D78EB9DB0F50F99124E59B2200152E437B1BC05E7
          AF3375960B92A4D2A083074FD4B0325B3759384D72B94E715277E00D817DCB80
          40D9DEDBC737B7325C2BCFD279650B0C454A344979A5810FEF7D063F3D7802BB
          D543749C1C3E4D5ABD320227F32C7505399B994A0F57FBF3F8A7673F8E37F60E
          53DEB38321F56748A0F4090C0E9BF9358332B2C034067B04F82E6609182D69AD
          596A9B5953D2B298966464D8EFE5CDB9D5A4DE169CBFF94EEFBAAD959D5AA5CC
          BF17262F0D7BA3928B6EC016FD64071003162AC192EA56DE0A53C71A0D68F0FD
          03BCB3D1C3FBEF5AC1F4E202E93CF0DD572FE2BB2F9FC3CEF601760908E3F847
          3A63C7C20CBA77FC042AF5AA96300D0E03532E93F196F160FF31DC9D3F8BD94A
          8780AAA259A1503A2359A348B75E1EA1467EE57A3E87AF5EBD1B9FBBF05ECD56
          457E654029C18081D1A08C3386FB70E2E0229667A7D0982570A617C8785ABA8C
          A3BCC2C72941CCA0C4F17B268D7FAFEBAACBCC986B1D5F9A944A163BAD54B232
          670DD237C1EB6CF03B5AFBB4966636DA629FC26C69EC6DE123771DC64DB7AEE0
          EADE109FFBED3FC2B34FFF25B23A597BA5449659D305451D8D91DC356E5DC5D2
          BDF7A34A9FB1D367402A040C33ADA0F3EECDFF0277E339FC58F9FB64D1192EA9
          E3F8CAFE0334D1254C67FBB86BEA3CDAC3167EF3CD07D1A2F72A2709A3DC6540
          D71F7A600C381A98220033DF59C7CDD5119A8B475125D654EB94DF54AB26BA50
          4E90822ADC38520BF316C9BB7DDFBD4ECEFFA38F9970F95A5714B5FC89A1DE12
          D7C2040B52107D5B82694A80693B90E714F27629EBB876113FFFAE55ACDC7C0C
          AF9FDFC4277FE38BC8E706A8CF4D6B1DAFD4EB34EEAAF645798F42C713A7515B
          3E812A8152AE944CF191F30A96140266A6D8C33DA5E7F00BB5FF89238D6DFC7E
          E701FCC78D8F53680D548A1E4ED52FE2A7165EC6A7CFDD4F19CF810E8D4756BE
          1C63460E9822D73538E4C6FFD607FB581D6EA079E818B186A492E58C739BCC54
          A87DE053C4B94D265913E53D6A22AB7A1A982F11636C7559E52A9964518A9149
          934F43A4CCB9D708A02196B1A0A534780A4347DD0EF67F781E3F73C70AEEBDF7
          0E9C7B7B038F7CEA71F4677B946D4F516237478C99D63E47D7B40EF690DFFC63
          3A2A2A970C632A6553A2476642E383A28595D225FCAB99FF8A5B1A97F1A6BA15
          9FBCFAB771F6E0044A24590CC27C65079B074D0240D1FB91066750041F337279
          0C279A4ECAD80593949EDE7D13ADA5636438CBD4BF79943808E0A8D07AFC2010
          21818CE64F84C5DE33C8808119D326607EF9B197D41A3BFF6E1A6B4B5F914419
          08A8A78E6E928E22FD7EC113C245C77DCA72AF61AEBD850FFDDCBBB174681E8F
          7FF94FF1EC6B2F61E6D812EA64959C7573B5974BF883FD5DF48E9E367E85D74F
          08898A7D868DB8864545975F7E71EA497C64E1EB68D4142EE587B18D697CEAFC
          07F172FB66EDAFCAC45866C448FB16C396616E1D3FB38843781DB22B0F0CF7FF
          CCD6AB682EADA0397F181502A6D268E9650225E621DA6CA110820235696E64C1
          D62698CEF9EB70B99BEC625132413421AFA79DBBA84C75EC2759D4B8F2EB38DE
          A294B1C011171F3BFBE8EDB7315CBF8207EFBE137FFDEE3BF0ED3FFB1EBEF2B5
          3F42EBB6C368CC1DD2115099A22D76D0BDDD3676E74F10284EBE321D7565962D
          4E8847144E9730C27DAD9770CFD4F7F1BEC5B368D647F8F88BFF046FED2DEBA2
          A571ECB9668706A630F235B052C60F06069CE48A41AEADBF88D6E113682C1C35
          8C2666B3D4FAB057FA17EFE0C78302095E6ACCBD2D11956D76C34E0B19FE462C
          C0241604FF617DBCA769A1948FC0389B076B769187AA70AF83FEC10E8EA3870F
          DDF70E4C1D3E8C27FEE03BF8E61F7F0B4BEF3C458327D64C2F6AC628AE1E1388
          5BCD25C316062633E01850B2A8CB6CE4BDBC4C135DC2FD732FE1232BCF60B1D9
          C1AFBFF2205EDA3A868A1AA03782A926289BBBD83A19B38581D17DCFC50E140D
          CC77D05A66608E10306434CC984A2D043C2A33DBA6DCAE1A1F2ECBFD0A495D2D
          022EB3C07CC964FED77A45C851A4534252D34AF2145B3533DB84E0EA5C4A8390
          8F2C1034A99CC5175C706450484A7841AB9AF7F0EEA3D378CF9DB760509FC2FF
          FAC6F7F08DAF3F8F1EF980A3EFB81D8DF96502664103938FFAE8EF5CC766654E
          4B9973F88E2D6E9DC41758AD817062BA37A8A39175F0D97B3E8BCF9DBB0FFFE3
          EDBB305FDDC76C750F17F6A7D1EE530E447D2AA1AF656EA46B72CEBF8808D302
          D35C62600EEBBE9579DDA65C8B54225E5616469CB0C4F966F1567F4F4765EC63
          B494F50AD1BE94A9241C4ED65720B2787EADCB26BA7432D440E494CDD7C8220F
          510278D3C22C490A39DD02FAD1EFE728D384FFD47B6EC223BFF5753CFDADE751
          5E2CE3F0EDB792735DD46C61B9E0F5782E5C0EF6DA94F55314C4EB23A59229B9
          704EE5C0095DB3DB999476E0FC7AA75FC3FB0EBD8E9F5D7915AFB68FE1CCFC55
          FC8D23E7F1C4DBABF8C30BB7511E57C177DB8BD8EE97D1CC7A5A0A8B5CE9EFBA
          7FECFC4F5D7BC53066FE08AAD3E4632897C9383811F2EE263FAE9985D0D9930B
          2A040956F6B9FF3D5EC1FC65660C45655B9D228ABA227F138123D9641BD0D665
          248ACB26C560A0277C99F2885B16A6718400A9D4B83E52434E43E6358FFE30C7
          DEDE009B1BD7F1DC37FE1C177E780E332767317D74593B7C4EE06A148E725496
          519E5010C07DCA7936287ACC6BD3DEC7B8DA57D849125BABEE1B4B12194F6758
          C60347BF4761F42E7EED8EA7315DED428DCAE80C2AD827D6FCFB57EEC19FAE1F
          C7EB3BB3A40039EA0C8EB82A2FA2DDBA779EA2B2151D9555A98F155E07E2E436
          5A2C135ED796B80A39A14588D8748D5BEF4308A945B77DD930E6D49AF531C23A
          C6D64964632AACD598AAB02942F202D36236C4B17A09675616506FD6B5A3E652
          C8B0C840EA45F90401723044BB7D80CDAD7D5CD9D8C3F37FF27B585C3D82C6F4
          1CAA533304CABC01A5C9B94C0D5C8F1A0DBA3A2ADBDA3F40AF4A915AD9D4A8B4
          9421F3BB264D17B320AB8501272F944E472E75483A97DEC423F77E85A48CC01E
          56502673A91108BBFD2ADA9D1AFED3D99FC46F9FBB13B56C846A29F7904FEF5C
          C44ABE43C09C408D0313172EFBA84C4CB0087C62F9B240A949CB22E659579735
          30AB6B66FB923FC5252A922D72093434A2AD9142D9115974E5ED0B2025C2D1E3
          F3B8ED2439C77A5597E3B3123B61A0D31D61FDDA0ECEFF701DCDB9233A32BB70
          6103172E3DA5C1A8CF12989C51937C711EC3BEA5A481CDF4FACBE0601FDBDBD7
          B15D99D565774D16BDD862A52C322AD3EFC26E67CAE9D1CF331CAAEDE2BFBDF3
          2B38397D1DDDBCAA278F03050EBE98214D0CB149E07CE2B577E1F3E7EF42B532
          D4CB03DCC6F2B5B3586A5474E65F9F59A270D9D4CBF416282161329F09F23679
          293962903DDFFB180F4C36818E4948ECADC25E84254C278BBD035C7CF279FC68
          579153CF31D7523879BC89C3CB2DCC2D2D608A98F0D6851F616EF9146ACD19F2
          192362D000972E6EE0F2FA0BE44C97293C5E428317A468C015F2459905950309
          0671D8D94367670B577B2C67B3A672EC4AF9C93FB7D14E02B337AAE0576F7D0A
          FFE2CC53D81CB4BCD61785B1EEDC96E31A1860A757C373D78FE0ABEBA7F0B5F5
          55CCF282D92EC92D194FC3956478C9D9AE681602043511887166C4E70665EAE9
          04937DCCDA9A96320780CF44619D68964548CBE080658C97788794935CFCEF7F
          861A452843CA84F78971ED21D7A08085668E4A69073FF7B73EACAFCFBB5A8603
          02867CD1C58BEBD8DC7D0DADC52394B4917F616028042DD7EAB0E1966E889DFF
          90C2EBC11E45663BBB68D716756269CF8819E3E6880D473F0ADEB68083515503
          F3CF579FA1BE35FD38D8C9B32FE01DA69C507260D22270388DF967DF7F3F1EBF
          72076EDA79054B1414341728EBE77EB2D412AB8932F1127C14654DAE2247515B
          94601A4BE9B2943DFC2513951960644C1CD3CDE528D2E9F31F0E89477D9AB0FD
          3DAC7FF569CC92E6369A354C35AB68B5285AA1D0B64D09C34EB78F773CF01E6D
          C1432E83F429CA22A773E14797B05F5C40EBD0718A749668C07366214A2F4259
          A3E0F095375C0CFB181EEC6AD65CEC65E8D7A6CCEE4997C708686CE5476FDC28
          2C63D8485A591F9FFAF127F1DEC50BD819344CB86FDD2B83C260707BBCE4FCE8
          A533F8C49BEFC354F71A8EEDBE8DE9D9791D8DB965E68C8CA79C95C5DD044E54
          C462A18AA330794CA6260144CA63AE5F22C6FCEE8BEAB6B533142E860DC932CE
          E67F8500453B2DB37465A4822D79D0234BDEC6D6132F60B1D5428B8069113053
          530C103DA6AA18D279BB37DDAE83040664486C69B77771EE8D1F606A8542D4C5
          C3A604D36279303B5282B599C88AC119760F283A6BA3BDB38DCB9822E0EB9635
          F18AAA630DB3452B9505E780A2B00F92F3FFCC5D4FA253547502EA26CA80C252
          36C4955E0B7FF7B50FE2ECF62C6E69BF82855A899842010A85F115369EFAB45E
          03CA10AFFD877058857AA26349B22E152A22F15A568FA3B287BFF4A2654C0EB9
          D3324238892A42806676AC8C7A5D5D60DC7EF239DCBC3C8FB553CBE8F54C397D
          9A58C340F5C8DA370EDDAAD9D2EBF470E5F22636AEBD89CAB4222B5C3432C679
          01C983DEECA01D6AA840686BE6E48FD7FBC9D7F477AFE3EA5E071BD579BB7E1C
          11260063079FDBBC828242CAFA47F807275EC6DF3BF12A66CA037447259BFB80
          9CFF009DBC827FF3D6BBF13B97EFC4CACEF7B094EF9B6457AFC3CC6BB618DF52
          B13152169CBE501CB937D9A1137243B94C1FCB9BAE953D4C8C312B9885BFD521
          12EBA811B945D6A2CEEB183D620CF998CED9B730B5BD871F3F7914276F5AC0EC
          4C83924866488ECDEB7B385B39826D0A93AF6D5CA608ED3C4A4DDE7D32AFEB61
          9C45575B1C893575666FB6B5B8583F64F17A2F3233B4B383DEF6162E1FF42D38
          E5D8F9DB1C42EF41B3A014763CBB832A962A5D3CF6937F80774C6D626B50D7BB
          67A6B201FE62FB181E259FF2FBD756B1BCFD031C1E6C6940349B59C2B8D4CF2C
          D56C31D1872A5464AC2E61CC6CCEEE7296C8E8A3954B59F0723E8680E192CC56
          27B78733B3392E8ACAE2D02CBA338B7D86DE78D721FDDF43979CB3BADE265D1E
          60A65AC67CAB8ED98543D8A3D0F4870725ECB42FA2D3BFAA6B4C35CE5938346E
          CEEA5D8F664BAAD9E42D74098EED994E16CDF625C3D26DF4883957F6FB582FCF
          A2D0A511E165AC84B9E4AFB0D67930ACE2C347CEE293A7BFA5A56CAA3444993C
          FF9FEFACE0D7DEF80031B189A3076F6069B8AD0DA646D12267F955620A67FAD0
          1B3D4A88EE759195E2883959581493651AB1C818F922579279F877BE4399FF19
          624C2E90C892356AE9528315C34A04F46AA4018799C3E57C7E26CD4289A4AE4C
          1635A0D3B8B4CE8EB24200549A2D1A2825908D693DD84AADAE4B1B1C7A1A1442
          24E8595398C851D7DF88353A1ADCDFD13E676BBF83CBAA814E7526227C742B21
          EB7751A25CAB87CFDDF924DE3F7F91A2B33ACE75E7F0CDF62DF8F4959F407B7B
          80A3FBE7314B0CAA3318C4922A5722C8784ABC6D89F73297ED863FA4C0C4798C
          7F16F7CCA409A72F1F8963BA88F94B2C65365C8E240B01417F2B5DC220B3D3D3
          548DF5C66E2B3323FBE01547B6EE42EFA8A7288ABFA3D7E96B7AE5AF420FDE40
          A79D3D03522E1B504A62C1AD1026E102017EF04216F9ADBCCFB2B64B6CDDC13E
          5706FA39AE672D741D40B260C83982AAE0D74F3E857F79F3F37866F738BEB6B9
          8A27B65671A10DCC1C6CE01065F68D5A4DEF84E140A43265A2C44AADA56FD1C8
          F416D99248219270780C9C58715421FD4C7017B2C8A919F34BC418BDE6DF2DC6
          B7A52201692C5C36DA6F5855E88D0D0E20DE7DCF3B194D45D9DC97A25719B9F8
          586129207654AB7AF52F2B85CD73694E10F6C589CE172637D1A5160687D9432C
          E55C6AC0E174B7835D02681F1574CA2D0C2B0D145C7D282AB86FEE12FEF5CDCF
          E00B576EC7339B4BD8DE1DA2353CC094EAA155213633834956B56C7120428094
          C88078D38566334A7E334AF0294165C6D82381723B8DDC265655448EDF05209D
          76C2184F3FE536901BB6A4E173B47346C88482B2370799F5177D17975E8329FC
          6A9E56A992B5BC92D9419939AD8EEE3E0E9A6C0072AC756D167EBD87C129B494
          1240BD038C28A4E64A04DF05C00F66ADB24B0ED23FEA3E906168675EAD1989AD
          4F69C96286F0B389108DE1F84A76216E5597CA92F4399D74192EFAE2A80FA703
          930C631E7D51DF1CAB814932D71091856B869A592C75BE17517C5E58A0543CE1
          2577B756B84F5AB2324AC464E7655BDEE7D83BC974659BD9CA0C2230FA7DC326
          0D9AB9BB4CDF87E99D66E60D43B381E555DFB45435372E95EB46BAB856A7D3D8
          2C9226C98C384114A0C8798AD4460607E2737B6D5D927152B6D9C93D3B32474D
          99AE2532E727B550218A76D146BA195D89EF0B6A6B49906D25BA1C281F1B4B74
          D759E1E420D7352F65015223E3DB9C9C6A10C5AD7EFA8F95269E7C66315789FD
          AD16764FADBB61496549DF13438976C04089FDDFB19F896EDCF56A234064E7CF
          79CC4304CC9ADE57968B583C201C8049EA4180B8B75EEA6A6840DE121E5DDC8D
          4DEA7458898B3AEC8B83EE471112C719F22917BC5896EA35FBA1A9DCB2DFB337
          C60AEB307DD47B66CBDE77646EB3B3935579FB492249F18F3D0469B991840585
          11F3988CC91431D9C73CFA1DBD7DC90393385BB9381695B6A52544E72BBD6574
          ACDC1DB14ED25D8D83262C3330DE190930BE2895E8BCFD6E51B8BD07850F4BBD
          B46A0694BCAC2917668ADF4651E95893082F5212C77879637062A8B633222A4B
          FDA9630C49D9438FFE95BE9D5C0333C1AA233ACADA4F34296E30E92DD329900A
          9364319E54F13A4BE81EE9F40D8011838F7EABC5CA4D7ACFFD58748930262395
          2ADC902524359ACCF00302218A7485CC494009999761B2EB739F7DCC435F2429
          BBFD34360E7244EEDD5F28DCD836F63B2D6316112630DAB79C50D5CF86F04FA1
          6421EE3511ED06FB50137EE440B619031AB17C426E2117FD2265506132431B96
          55853816281EAB0104609E61EE6D7C43566A24BA56C68C317B97C3A6B6547252
          50A2739C55B850564668AE8B4212551AF6DAE359A2C1F1844A50E2C82C4C90BC
          CD505AA8E8BF98579F6D172A6A270D364C983F21BC8DAC5E322F6644E4F0832E
          4325DB68E5B38ECA1EFA0231E68CD9BB3CD98AA415245223ADD30F42CAC1384D
          333909089D1F6361E237C69D69CC2E48B0A5A6A7EC88C25767708EC189BF4815
          210A89117EA16942369F3AFA497765A7CFAE3FDAF93FF4C5BF32CEFFA008F7E6
          CB5149ABB32625292E27355884942311BD251D90CF01F064006E023CE37C8311
          E3FCE0230031D6D7226A37DEF49E6EFA96807BB224E7FA53ED92BB09F3959B96
          700D151B9A5BD1829CEF285C2660385CDEE8E6131822275EFC72458609168C98
          3990161783AC440C3AC9F1C7404F70988182410623EB0E3E2CF529FCA788AE27
          7E5644C9CFC4772782218DD59D97302A6584345084EFC4C605F4B7AF38C6AC91
          F32F104436B15E313831C7DE848262257A2D2C461AA1B7D231273DAEF7FE0770
          2263C926322E4D662769BB932BB9A555A110DF81B846ACFF6915D8AF3E4A6388
          24355507CBAC48245217E1A3320B4CC7954E262592934189283F361193A525D6
          FFC99293467A41BDE27EC54E5E58A00F86BC06C2474992A9938CAA700623408E
          1830818589FF92F3E2831F054C0A48E49C38A3EB1B29FB4BB377B993074B0C1E
          DC5B858AF4E2C69D959F07673E01D47400CA772D928FF47A32980861B338A664
          7B424A22A625AC1263513E14966AA1A2318C4DA89046434A253B13032959A90D
          4145BE9D8F5AC658600EF2C9D220DA8C7DCF841FE3892648E636F2773045276E
          287F9322BA248848591B0D5C79E0A4D58E1981CAC68E99DDFA614D380420C217
          F86B0B9F241520012156831BC95F988F7EFBEAFF07E6FF5960FECE175E201F73
          460313562FC3E44C066AB29F88FD4296384BE1BF849404E9111ED13BD0CCFF94
          632C7B08CE78CC794E788EFC502C2D715479033FE7B0506ACC388C0108A0BDE1
          86F761AC32D235421F49B105BFB7ED81B1798CF2971D634CCC00DC78323CAB02
          584E77E3BBCD6250C726457CEE41B0C7AC2C43A942B4238CC98C723C0ABC01DB
          E23E0486477E4FB05AFADFF1C82F398EE0F883714D4A728301196048CA56576D
          54169523E4047941B08313B570D7E80D7EDA2A057BEC5AD179D2AADC8EFD704D
          D9A7781F97648060789423A4F98F98684C024730DA75343CC5139C801A4B6162
          D4E9C68C742D8A4EE8B7D7993104CCDAAA01C637207E51C6BE4F7F23250560D2
          71158F6E8C2DC1A738EBF7AB6C42E2B250AB1A8B86C20552A0FF4FD55C793B62
          EC03108F53823BC938C6F69389FEC8EFA5CA227F8E5210C1CD437F7BDD4AD9DA
          DA18303EA3F6F48FE9974A58BC6E23355D4C94AD202A91674C625288D853DF90
          304F85F3FDD09CDECBC98C000B07A48FF397B537AEA8A40DD86BC72C0AD78C65
          310625026F92EFD37FD8C7EB1F1F45CF39FF53A7D6CCAD7E181F809FF431E684
          358868E0A1A51B466C93EA63E30144ACE92A5D9B4959984484CEA2D363514E92
          B2CEF533EA5E11C61DC9F204238CE64D5C240A38C4E7632A6230D0C07CE4F32F
          181FD30B993FDC6FD8DB4E443F4D2BD922C0700D85E58AFF0BCBA4E51513261A
          A214A3DF5B7615F23A89FEDF403ADC98D388D0257763D561C1A489D9BD60ED78
          C81B1B6A60948AB687C96044CA39CB768FA52C00931631C5207D5020A441BC08
          936D9D59C4AAA05DD2518EFB9F2059482629B22E0D64B8950FD281FA73A5E58A
          DD9242E6E2682CB1E20CBE423CD6EF347D106171B4CD4BC91F48146B3A6E8C51
          B61F070B83EDF51F65FFE8B117FFF34E5E7A98DE1F09763D2E293E1C10BF4CE7
          27229954FDCD3C333FB325AF253E4F83056F0CE6DE74A802020CDB8EFED92E3D
          6B069C88C545CC4E77775CF2A36DA10D152D56018139D2894BC3898CC446A221
          1416529FE479909FB976E48F274A9954D9EBAD6CF06FFF37DE5A16796019B586
          0000000049454E44AE426082}
        OnClick = TabSelect
      end
      object imgProxy: TExGraphicButton
        AlignWithMargins = True
        Left = 0
        Top = 118
        Width = 94
        Height = 59
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        BorderWidth = 5
        Caption = 'Proxy'
        ImageEnabled.Data = {
          89504E470D0A1A0A0000000D4948445200000066000000400806000000E82A02
          490000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C00000ADA4944415478DA
          ED9B697014C71580DFECEAD64A42D7AE168182B905482250A48C88256C27A42A
          951FAE143F924A9CFCC8554EB92A763087931F09C81C068518B08D840442D2EA
          0204C2C5151CC7159210135218303E1004432CA4D5DEB740D2CEE4F531BBB392
          29A8B5AB323FFA49AD99E9E999E9E94FEFBD7EDD3D92A22820447F220930FA14
          0146A722C0E85404189D8AEEC0489234290B930193916FBFA8C898A27C1B7B79
          DDB583EE2A940846DAB8B347B696144E28A5B05F252187FF252724F266B4B115
          5614ECC36EA85BFB032BEE8E61BA876914D3B87AA9EEDA417715D2804128CAB7
          BFB90C724C59096514DEFE743FBEC36140FC387E0504426138F5F6BFA06EDD0F
          CB312380C90F0C5094DD5367EDA0BB0A69C0ECEBF8B35253BD084223632C83FD
          6FC7B443ADBA22C78FD5B372ECBC0299B76E4264C66C686C6A05DBDE4DD598E9
          C5E4C41404A63902CC432B9400E66D045301A1C8684C016210342AA14C306D32
          DF219B8C5BD7E12BBF5B03B77F5F0FBBDEF92782A97B1A1898214C3E605A23C0
          3CB44213C03CB19C8179FFDA7596A9683DB6BA998089F8185E70D18259A83137
          208C1AD3DCD406B6C6BA5578D2030C0CD90A308F54210D9846DBD998C65CFAA0
          1F162F9C0B31132631003257156EB518A498C628602EC80187C30BB2D18860DA
          A1438049B2421A300D040C6A4C10C15CBED60F550BE7807378188ACC660AC641
          F68B2DB4515DC37628349750302ECC2FC432E4D52C0526B0BB89AF97A009C174
          EE136092AB5002983F513081F0285CF9B01F2A17CCA1F98553B2C1E90D5108C5
          535023BC010AC19C6F826177906A8F393F07863D012829CC812157806A5553B3
          0DBA9A5E116092AA9006CCDE7615CC7DB8FCE10DA8448D511DFD64B3C51A5789
          1DB0F32585B908C64F8F9BF6DBA05B8099DCD00F1112D5AB513EE97BC96FB69D
          916B975732301FDD808AF259E072A0C92A2E01D2D24E8DC97239D83E0140CC5A
          81D942015911CC208221659A0FD8A0A769B300431F806094C1DD0F3CAF285130
          94BE6838D9F613CBAA9A9983A9337E9B0F2CB6187DA3EDCCD84A74FEDEE07DF8
          E0E31BB060DE4CDAD8857999E0F485F1E6062829C805BB27408158D0D1137F42
          35A580690AD19841879F3EABB9C506879AB70830F4010F04A37028BF369CEB7D
          6EFAD22ACBE95449294F9BB5913812E2AD83082652FB780578422370159D7FF9
          1C0B54195F857F8FAC07434A1A185352C06030C6CC168126AB41287FAF92A23C
          04E3A31AB3BFA5130EEF171AC31EF039601462A96484326D8DE1E289E7E72D9A
          5F744692A2654A741C32E76E7D1C8BD831B9F71C3C1D5CB1AC1C82BE3B60F49F
          857945FDF056FFF7A0A0A814D2333220E0F782C53A95F5CAD09415901E1ADEDB
          E5704061A199E65BCD797077D84F7D4F4B6B071C161AF3F960889690649CF692
          B1FFAF6BBE5A566A3AA940D4ACC8E3A0444721BB7CE7B7B0D81D4CAE8ECE7DAE
          15B307C024F5C30DBB196E8E7E078C188F4CB3164368240AA9E96930B5389FF5
          BAB8A327668BBCD3540EC46ACE85BB76346F920C070F229803DB04984430180A
          2A3287B2D6F89FBFBFF464A935AB1781E45228F218C898CAAA9B56DB763E5DB5
          7461FEEA54A3521E9565B8E6A884B357F2A88FC9CCCC828CCC6C484B4B07A301
          FB094689069AD4944559AF4C1D3323FBA5C5793030ECA3472DAD5DD07B60AB00
          A38291075FA3A68B4299BECE78E7C2DA67CC85193690C7333CBEC0275B5E3FDF
          BC6DDDF2FA807FC4694C8DA6A719658415C5DE98012E0DAF007BA800FFFBBD50
          55510E23910858ADD3C1809AE3763BD07C99691FCEE5C49E589185F5D0F83E39
          28B5E4C167761F6DF8D63604D322342606263A500FA4A153CAD6A7D82F6D7836
          2F27A5716C7CD4FF97BFDDDCF7CCCF8FBE83C5527D577E7A8669CE38321C8741
          7BF04AEBF92555E50B2A502B32A8B95ABC683EA4A6A64369493EEB7D21106B31
          9A2A078B53D47D6ACA8AA75098A596290C0CD26BB375A3C608303130C0E213A3
          E3FDF5CF9BB28DDB07EE7A3A563FD7DB72F513E77DCC2749F15EFAD165028400
          7CF7C2E0F167D79E6FFBD90B9B7B6BAB9722B64CB83DE0800A8CFC89A6507315
          9D383EA6093865346D7CA26C9A251FC178D04C2AD06EEB81A30705182D18A3E7
          DA86BACC74E9E5DD2DEFAD5ABFE5DD217E9A344A0893C17DF1FB77EF8F8E061B
          3AAFEFD9F4C6B58B98E7F8CD2B8DFFF8C6CAAFC1BD7109FA6F0F60777926C406
          31D50100CD80251DEE978142A17D3FDC9F8EDAF5DF210F0247309D3D70ECE0AB
          020C0763F07FF4F29A21BB7760FE530DE7302B0358644F342582690453BAF3BD
          D5FE5F6EBCF0DDC3A73F238D85D12338B7ECEABAFD54CD52F087D94419E9FA72
          0AF1F91975E85F038828A81AD790CD9D410F2DDFDED10D7DADDB05182203175E
          9CBDF9F5738E06DB2532D492C6B3494B133024C22753BB04560EA629C0148180
          F1EF68381A5A59BD183C81113E16A6F6B6F047269A28F389333E3946CC970C89
          E3676C62804A7BC72138DE2A34863D00350637293CB1D6648B20D4952AC0CFA5
          030347F208B0FBF58D7DD19AE555E0F687C1ED0BB2E94B75B0924350EFA8028B
          CF64C69767E4E698E89EADE3301C6F131AC31EC09C8C3A40A9C08465436A315E
          C6A0392FEF68E8536AAB2BC0E91B01AFD70F8F9559D885140877F4C4AD68EE26
          C7DE8799BB5BB787202F378796EDE84430ED020C7BC0A38F2E4F92ED7B8F292B
          575482C31B018FCF0733A759D1AC8579CF0BB8D6489AE17F1E6082C27551019F
          3F08B9B9267ABF76D49813B61D020C7DC01700B30DC1D4565782CB1B06AF0F35
          667A0978D0ACA97E24DE2B4B9C93510FC88F3F10821C62CA1462CA8EC0894E01
          26B90A69406E7BF32805E3E460D4057CAA93572506483BB21C5B31833E26379B
          5ED7D985603AEA0598A42AA401B3754FAF52F37504E309736DA0F62BDE339B30
          9B494556B8158B6B94FA8A9DDD47E0A400936485346036EF39A2D4A28F71BAC3
          E00B0463E649D6F4BAE20BFF26049EFC1CF9CD3199E8385D67771F9C12A62CC9
          0A69C1EC3ECC34C645C0046046598926A0841828554874AFED2A93834F0786C0
          949D4D73BABA8EC1A92EA131C9554803A66ED721A516C13888C660EF8A3A7F8C
          67624B61B50B3020EE67582F8D0596C16038B6F6B9AB07C174FE418049AA421A
          309B0818D25D7687B077851A83DD65B78F0CADC557F2AB2AA4FA95F84A4D99E6
          5130D9591456CFA13E0126E90A69C1BC7648A9213EC615025FD09FE83FB40BCC
          35DDE4D856BD09EE984C99945937FA98333D024C7215D27E86F1C71E6ACA865D
          CCF1F39891F9968465B17C1D81D6C4693ECF505FB1BB478049BE427130D2F686
          3E79D992B9144C825F2167650538AA8411E6844F34143E05C0AFE9EB3B056FB5
          D1F918B2CA9F8021ABFE23EC529DB583EE2AC427D6D6D61D909FA8AE8214632A
          F8C211F69598128B5EE88066DCC5689CBE7A8827D4C139E0E522917BD0DFFF29
          ECAEFBC50ACC726072039B0F1AD71B195D82D9B0E580327BD663909595C973B5
          8B2CE221BFDA0190203E8B49E1910520719549F82690C0B97CF56368AE7F6109
          B08F9788D6DC5348A0A323D125981FFF6A87E2720E4F3A975055498DF449F34B
          74B652322AA0E18619DCD481C40FD93585C516E87863C332605088D684B11DC6
          FEDFEF9ED00E7A0483928A89041F64E28C4CA091799AE44743270B796932E743
          3EF523FE2622C03CAC427C8D003038C496A5F1E32F5B88E92270C8D4F6983065
          0FAB507C55CD97F96DFF8324F6CDBF70FE421E4904189D8A00A3531160742A02
          8C4E4580D1A908303A150146A722C0E85404189D8A00A3531160742A028C4E45
          80D1A908303A150146A722C0E85404189DCAFF003D32BAEA5AE42E8600000000
          49454E44AE426082}
        ImageSelected.Data = {
          89504E470D0A1A0A0000000D4948445200000066000000400806000000E82A02
          490000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C00001BDE4944415478DA
          ED5C598C1CD775BDD5333D3DFB0C399C4DA42889647327254496145B36E504B6
          8124FA0A1C8796ED00F930F215247080F82B48908F0401B2C01F0612488E2C89
          AB2CC082617891AD008E575832176D8646B624CBDCA6675FBB67865D2F6FBFE7
          BEAA717EF3114A64575757BDE59E7BCEBD6FA9CA3EFBD4F73ED2EA1EFE1B4574
          2AD3FF90F94765E6FF70E83FED8FFAAF22650EF10F7C57E147738FB82EE74B55
          D98DB6E4784A51B85FFFD376ED107564BE1D5847AEBF547252FAFAAC626A54AE
          ED79B17D2A4BEA8CC7A233F69C92CD74E7CD816957C597977BDBE973A4CF8536
          D8FBDBC475E68ADBA03F33E84296A956966F5DEC5D6EFC63F699AFBC7A6ECFE4
          EE8FD5FABA47ACE14D9F330F440EE890ABD834C05458E84389C1157490CF67BE
          6170CC28B87A4D7DB98A4688C54463FAF3E13EDB60EE6C688B39CA4C39597028
          282BB45FE1090F8EEFA7ED7BB8240F36499C2F5856C9F6A29399BEE46813FF8F
          8A755204286FB7E9DADB53FF9E7DFAC2D58D7D07F675CD6F75043EE8CF2C1A22
          53EE8CBD0D3D0F5D1BA150D060925EADBC07875A5263667CBBAF173B01B58217
          28DFBECC7BB1C2428C3942DD588E42234199FED8624DC016C1666090E2F2F894
          12F514FB2041148EE40F9A73379AD9A72F5E55070ED569AEC5CE9965C19B4303
          29D295A9A7A0212C711974B800586C80022F09E540072248FED87B6B6C4FDAC1
          787F6208EFADE8C10ADC3C9E134085729420BA4A98E0D434671F00EF8F12AC28
          A9C3949989B6B17DD80EEB733748037345D50F1DA2D9A6B72A71E33302B6783A
          07FDC43F2AB22A184E5184141A899D1754173ACE0D54859BF83A944EE58348EA
          BDEC38DE08DBC90E1A0E99AB94005901687C2263AFF7AA22D905EA109DCD2847
          B84F3A87F9B23EBB0D30C266789453044B1816A5050A50781EBD0FE156F83BCA
          0A07636378D5BE4D798EE0248CC54E22F8DEA142AB6D80AC98205901F03C1AB9
          6C6B4C0682410513F966178E7C1C49A493ED9013E01C41937675FD691AC67CE6
          C255B5FFD0419ADD7025645988B02862DC39C48AA10886A1782F063761802408
          A6999042A0F43F7B5F7B9126274624454587D3B6A8101C9D47FA26DC9A9EA337
          C68E51A5A3932AD51A659D55AA641D367188C9882AB62BE29EB36709D945F647
          0021A807E07CDF628C83AC3202E7EB6E3AC6E818533F48731B21C02432937BE7
          CA93804D10A03330121AD9539BD26C8A923A92C607A7D8FBEA77E9F73FFA000D
          F4F74A58A2611267C9946026C2B6BCBA46DFF8CE4FE94AEF1EAAF60EEABFFD0E
          A04A87485F314E29005AC488C0CED4B9A2244999128E1E63AC12E0868E99C3F5
          004CDD30A695BB9B637A8C12C6A15ACABE8AA008698A24C2C673C5D1A48C06B0
          851389871A97E9D4078ED36A730B2B8DEC88C5E789F77AFF0B0CED79FB17B47E
          F701FA8FC79FA2C65DF753AD7F88BA0647A8DAD3475947553A5959A027E595AE
          0846419A3076803DD8F64ADA4380E4CA5A9FBBEE62CC818387AC943126CA8E61
          A2C79482C246CA62FD0AEC8C0196A52EF35E27BC895210DD6F0FCD18604ED0EA
          FA26B73B80202116D29647A089BADF7E93EEFADBBFA277FFEE9FE90B2FFE986E
          4C1EA35ADF1075EF98A06ADF007574760947136935B62B06F612E0700C246266
          704606432414319960F39A6FCDD9EB9E3107EB9A3124244980D2E6709DA5DE0A
          C604E78F5E16E18001850013E996240206980FBDDF0173F9B53725FB40AE0A30
          C148F4F8D1FD9A316FD19A66CC138F3F4D37260E53D7C0B006669CBAFA87A9A3
          DA9504EA22730A314700C6D29429EEA752AA783FAA44CEAD56495DCC98BA66CC
          A6BF234C29E46EA0193D3B80065665032988B929BDD94838F84BE5289EF169AD
          B9F4C1C6A5C8984BAF4ED17DC70EF23D992B3B4F2425065F6F9CB19D03D4682C
          50DED1A18179C6025333C00C8F53557F1AC688F15A349297444571F02AE381F9
          3F2FCA744C38027DC3E5B9B89707B372806BFE786074F03FE80798C2EF42A140
          D3884EE61BC5F9B5882F443CC726680FF2888081E7B1E76A606634309A312B1A
          982BAF4DD1BDC7EA34333D4DBBC6C66CE10D733C3A6EEF9B9DBE45236313B6FC
          597D7E445F63CA18DFD94FB7E6966D9B1FD7C0DC9C3C6C99D2333CA681D96119
          5336AEC15900190351863089493334190B55403995C0849D325D3EACA5AC895E
          1B8EC3883314981C27DA8E5215E5AC4C163264121A83E2E8CE1C3ED8F8990566
          796D93AEBE3E45278FD6EDB523C37D34B3B06ACB1F1DD68C5858B6F78FEDE8A7
          E9B9157BEFD88E019A9E5FA6899101BA39BB6C2B78FC893374EB8E2316986E0D
          4C97654C0D244525C11AC64C18238892B9BCED250CA54E486FAEC064587E4EAD
          B99B1A182D65FB0F9AAC4C15A75C4066DC21EB995219D40D0DC18C042729414F
          85D795047F9B3EEBE21F9CBEE481D9A02BAFBF452735634AC70C81AC4A32D77C
          9B1819D4C02CD9EF8F7FE90C4D5B60865C8CE9D3C07475D97EA7B30C91292A8E
          304A930319F431ADF63FE779B1DF51DEDCB5B922B01D6960AEF3386666C35F2D
          D892C600F68C0C9981D7606CF1A36995654212D2ACC78C69F3BC6DEB369F7690
          AB47E80FE818F3C8FB4F3A60DE788B4E1CD94FB30D2D59A313B68C1990ACD986
          3B36F51B59DB39366EEB9BD4C0DCD0C0986B9EF8CF33D4D0C0543520BD1A982A
          047F312E09090A0C508335318E60304FB32D743A8A2CCA8ACE13EE01F56971BA
          AC19B34E31E8C7F436C489101F3215E791240B1220617C23E52D09FED1EBDBD4
          9DAFD3170E9FA53FBD749A2A3A20573A3BE981D9ABF4611DFC175636E8D59FBF
          45470FEDB3658D0CF5D0CCE29A056F62E720DD9A5FB6658DEB406FE28965CA4E
          C714C3981B8D255BFB134F9EA1993B8E4629AB7A2943F6A2C4B2AD1316242969
          4810704A06E34F94B758B49C6FE3E0EFEE69CDFBB9B2FD07F4C8BFC5C64BD35E
          31E5622B70C867D8009280C54C278E5912790BBF695006F225FA8BBBBE417BBA
          E6E8B1FF7E540FFCFAEDC8FCA1C5D7E991DF3E41F3AB4D7A4507FF23F571BAB7
          E39FE8E5E6E72D781D1ABC8A1EB9A39CE4B17E57DFC4AE210DCCA2ADFE4B4F9E
          A3D93D8E313D3A2BEB1A18D2E5D44A8CC4533138035C08EE183350110A99699A
          0425CC4BEE6B86D965C39899752552461E5342D04A252B0BDE80B109B22BF004
          4335E759DCD85CFFB743CDD3E7F67E9D46AA8B76A2F213DF3C65F5BF36B0931E
          5AFA393DFCC0115A59FC15752CBD4087764DD1D7A64ED3CE5DBBA9D6DD4DCB4B
          0B343E7987CBCAB494ED34199A2E73B6D1A09191317B7E726C88AE4F2FD9263C
          F9D4599AD58CA99A186380D19F1DD56E525E8F8481A3C4940016FA28E2511024
          5685ED3335B65B41DE4D5636AF83FFA72FB87479A609935AF1429E6F917361C0
          8214C45817300D329B90ABE5F96D9AAC34E82FEFFC3AF577E80C4B7F57ED4DFA
          C3AF3E447D637BA936B8931EBDFD3D7AF8C035EACFA6E8AD5B63F48BCD47A943
          8F47F64C8ED26AB34DD55A17DD31BAC3655D3ED01BD9329DBEC30332393648D7
          6F6979CB72FAF297CFD2CC9EE33AE87B603C6344FC8C06A624BD95D99A4D0A84
          A7C31C5A4E02D0B08654988E21096E6055CB02735E33C6CF2EABB64A8C0C5331
          6980CC1824CEC4B26296023216F1D120DCDDF11EFDF9DE6F518DD61D28F99606
          6B8B3EFEDCFBE8A3475AF4B13BA66877ED16B57556F35AE324BD7075C8C6989E
          9E5EEAEEE9A3AEAE1A7598E9FB8E8CE5B2CD638FD0A2DDA343746D7AD17E7BF2
          A9F334B7FBA80DFA3D9E316622B3103FD0D0510E9819CC2490A8785F10081E40
          0AFB45F270B6C6C079C62C68603E75E18AAA9BE0DF4C736D8C154996418C7A1A
          E8CA741459A474D675B4EB97F4D9DDDFA6AADAA0A9F91A7DF127E3F42F1F7995
          6E2E56A856DDA481CE757BDDF25A852E4D3F4CB756776AEF5FA07B4F1CA1E6FA
          3A4D4EDE4915CD9CB9B98696AF31EBA1B3333A13DB35EE32347F6CBEEC1E1FA2
          5FDF5AB4067AEA690DCC9E63161813FC6BFAD30213023DAF9015A5AB24586FB7
          5C20365B28E2A44095D92649BDAD94851863D2E566B28B4505D1F18DC9B282EE
          621212454A54EEB3B9407D1D43DED7F306FDC9E47FD1CA464667DED8432FBE3B
          42F9D6163DFBE8773C736EDBEBAE4C0FD3377F384A478E9ED0ACE8B67275DFF1
          C354D586DC3DB1C3655FBAC993A35AAA1A6E9C128EAD948D0E5B30778F0F3B60
          B4799E3E738166771F73E398E1092B651D1D35295D302B8EDE1E2388DFA4E164
          9EBD5E8C6FD2F8549214883A12676ECD415636DBE49D1698FE0A16244C499301
          1FE39358E3686B767F7CB0F732FDD1F8F7E9856B7BE9D937F7D2FAA6CED0B524
          999A9E7CE8490B8861CA85D777D3F3EF9EA0231BD3F4C807EE279DA6D1BBD71A
          74428FFC0D536CDFDBE9FC18786B9EF9D905457BC6776860E6EDEAE733672E5A
          C618405CF01FB6D99D603D0052182CA64941CCD8903D6EFE2EEC5308E5A06449
          D028012EF3C09C7723FF9956CE63942450A774C584C0CF9A254C81153B6BC4DB
          F47B433FA43FD8F953FAFCA58FD2B5E54E7B6F67570F7576F7DAD1F117EBFF40
          CB1B15FAC24BC7E895F949EA1EDA45F7B56ED0473EFC20B56E6734F5EE359D2E
          EF135E1935DC7FE64AF13623D32E7D7CA766D77B37E7EDF8EC99731769DE00D3
          1F669743BA4C71B6372ED6D964C03302D68D8421938C0C9D24DA2C997F439684
          D80C5FED7D362B3331C64A592BA412920122CEC4BBE552B29C5AC120449601BF
          33F812DD5CA9D1CB3363D4DE6CD991BDD1F6CE5AB7664C8F96B20DFAB7C9BFA6
          CFBDFC719DB6EBA05ED3017E7817DDBF3845BF7BEA7E5A5A730B6526F5159220
          58899D9659E3AF6ECCDBEB9F397B8116EE3C6E81A9ED18B353329C95150DEA4A
          CA1CE0912D985DC9809F5E930E441502174245BC5FC5D5DE9659C1FC94618CCE
          CAE6D673917541790938099D939458DCA3FFDD5959A0F956176DB6B6E8F6ED4D
          FB9B19D51B8398CF2CEBB0606D355769637581CC3AB6619159FEBDAF71598FFC
          EFA3F9E526B16D82D6DBD15F9C77B2C6F31BF5C4FC19CF7469609EA5C53B438C
          71533216181B43154FD1977836299C332BB24582C50E1E2684733468CE195BE6
          99A9C08ECD851B8E31FBEB3EC670D048E6C8E4F75860000C650517BDFC1C98DD
          E172BBEDA67B345B321D27CC5FEB8FFA54BBBD45EDAD4DCD9C4D7BAE52355332
          553A79FDA774EAFDF7D2DCD21ACD2DAE909F6D74DE18774B52DC2882F34D20CA
          3438D06F8FCE9CFD0A2DEC3D6E57306B761233A4CB14677BA3F6A381E3D6A774
          5A46CA2AA1813D0344DC0270C260BB6C19DBCE2E5B600ED4DDF6A578890B62A8
          A36221093CA72C1910D999999854ED388593659590EB31BDF3DC798DFECC2A95
          2821C77FFD131DFC4FD0CC6293161696E89EBDE33E1E50DC05E31D30FEC915F6
          83E8ED776FD2D0E080BDF6EC390DCC5D3CC0ACDA917F0D82BAEB449EF6572401
          C5B8524C10CAE48D47F60A6D870CF2D7C7181381C95452211610BEE76C58C5BA
          8912882C2B064A18BA163AE527033DEB8EBFF723FAF0C327A9B1B04EF38B8BB4
          6FCFA496B5359F7991674D606E546AD66BFDB9B8B4428383FD5ECABE42CB779F
          F0C08CF9D9E55A095BC0D972E709BC690FEA606BFAEA246325104566C86BD966
          2D3BC03431A65EB752164C1847A2E447B05926904EB3340606AF41A303C35230
          644122561D7DEFC79A31276976618D16163563EE9CA0792D6B218E705656E208
          5E4E96965769C048993252F61C2DDF73C2C79831C798CEEEF2B4181C2F029E4C
          A9C48F92E995504EF9C0146D88034CD78EA691B2C7CEBBACCC0103464AE8E640
          E2636E04AEDBC88E6430B31CEE8FE56187EC619A962B0DCC8F2C30331E9838F1
          17E20BF0534E2A32CD0D190607FBEC7DE7CE6B60EE3E4955BB4B669766CE0E3F
          F2F71246A8FB4539C272790346D22772F14A382B4A9F501A74480E21ADF9EB9A
          31E72EAB7DF54334D7E20DC9221BA128E91483968FB88A92E50000137791208D
          315908FFE6215910AC213AF2CE0FE9D4073530F36B9E0D7EEF1BFC4769A77396
          95D08E50DEB90BCFD1CA5D27FDEC3203A3C06B52B688A9A642C04FEA4706284E
          18629F6088C1D78678CEF7B54C56F6D8F9CB9E316DC29D96A2B3022C542ACC38
          605733CAA04C46405B79DD8787B1B2A38734308FE8183333B7468BCB2B916161
          CD258A6121284B6F1CE8EF27B3EE73EEC2F3B4728F0EFEBDC39631D53EB71923
          1617DB5732ED541812607C0D33D3E9980EE39412C0C499FB602F90373B57F698
          668C5BC1CCE3A30E4223481A3F0D62B1FDC9C85294932B989E408F214A198746
          3EFCCE0F1C63660D30CB74F7DE09394A06298C1222A458D13BD76E527F5F9F3D
          73FEFC57353021C68C6AE6EC70DB97FCBDE81C2C8FC924A308DE8AEB05670D42
          98E511EF58562C07E3313229C6180D8C9992995B6FFBD376AC5BDA98027BFCEF
          413A82C0B13317192729CD8D149EE83F0FBEFD037A4403D3308CD1D9950DFE7A
          3C8312A3A02CB19EE29F5D5959598B7B9FCF5FD4C0E8ACCC30C54A990626CC95
          15261583D5442A9B3034EE0A8D1DE3FEC51B329053904B58648C80FA6B6CBAFC
          D8D94B7AE47F4833A60D96CAC460516450C432E40266061B3392D417AE676980
          8786B83F0589307FEA6F7FDF4A59636E5567579A313A5D9E5B5CA510E083112C
          2963F93172D9731698BE5E5BFAC5679FF7C018291BE5291931B6C0E481E7C670
          F36321D5158C9752A87CE3C4BD890388B51BF2B3CB9F3452E6D365BE21C9B4D0
          F8D0B098024460381950DEDBE0C90F061CC08D83D9F07416574FF55F7E9F4E99
          1833BB4A8B2B4B327E08A394783C30B2BFBFC7967B41C798B5FD275C5666D2E5
          3E9C5D4EB3CD449654BAA93CFC1E752F616ED15EF66BB28720ADCFFCB18CF9A4
          668C5DF36FC2EC32C611B1FB451A237E433A0643171890C426C56782F7891903
          FDFF010D8C91B2E9D9150AE96C34423282E6EDAAD23391F1172E3E4FABFB4EB8
          D9E5A1513F5716A40CC76F606C61D86DC63AE07405F6205061A751D8C4AA7211
          F843C6BABE9030860D193690FB3C2B499F236089460AF30BB0C0A098C5C44697
          4882F6AC93375FA2077EEBA00546C4152B0F8A14C9CD74F8C85DCCD06067E7F3
          CF7F83E6771FA66ACFA095B26AAF1E60767597B33A911D313ECBE151755416F4
          94288325BF05270B8D57B2ED8E31672EDB87632D30895744338387675464024E
          57A4CF5E2AA89C8D571697C098DA93265FF9367DE803F75267479516D7D6BDDC
          C5D18B943E60094A9BDCB9A33D71BD455353EFD0D5CA30D50647DC6EFFEE5EAA
          649D7C1DD337B62FCF797D49D683AC2C8EFE859D4AE3A812FD0E65DB29992065
          B3EBEDC88E2C784E223FA23141E2E2726CD403B1F7B9D851A636972D6708F6BC
          FA2D3AB0FF1EEAEDED4173F962E44A2BE72838B0C3C7F7708B8F03E7CA2B3FA7
          5F0EDF6D77E2547B87ED6CB67B5B42518270AC25DA1E01824D1B0026DB800D2E
          6221C61511B3C86DF83BAD81A9DB7D656D1130319048E301A583068BA7C2B802
          7C245C141EFA863ACD2B7154F9EE599A9D99A6F48F181BF99723B8D09239AFEE
          50E25D045673C8FDEEBEBA7B4646C7E9C6785D07FF419732D77A352E9D91F50A
          1DAA2C488391A57AF1F5AAF4FA080997C79A16EFB323FF4F9EB964B72F456094
          BC500CBA0A810F826CBCDEA5D0C0E5924125D25D15406BDFDEA2DB1B4DDA5C59
          A4CDE6AA5BA7811896C600A1EBF8E8766C26A431FEA459A4EBACF5DB7853A9F5
          D86731CB6263D9A3126952A0F80252F86070E2A8CE9150C2E11A500CBBAFECF4
          999FD9C7C92D30255E2DE888733F424FC3FA4AFAC8740AA4A232592CC498FC36
          B5B7CCDFA65D4053ED76E271546C03C1675C21CC61493CD4EF80332BA7995949
          AD76DB279929CB8491E35EB5F820158C9D5263F20B04786D284C649601853151
          811DBCAD364C8C39FD8C96B2C307A9B1D6A6425CB017662503C5E89B894730A0
          62DF7242D5881AC4278E3B595C38B3AB9FF6985176C64A1D03EB2478543B496F
          0BED37CFFC6776F10E9316BE376DBB8A2BA605C6A7E32002C022C3C257F9E480
          74323F576618E3F62EC7370A14242705455C0301168321067719A04346064623
          9F7A8A4EA1411114A8038D46F898217A28B41FEC1A47DBB912F5942D218767F5
          A3CB0B1953B28D092344C067EA86557200943F6D5676FA69CD98436EEF72E9E0
          4C78011C878098A59D403928D254A69DE871090B2136950753CFAE44260B9A9E
          1851A6AFC1E102839378912A82488989DFD054329A4F037DD953D9E967688F0D
          FEA79FF9990BFE6B79F2008E644B8406A65528312A7B040C2009B2B7A401F8C9
          80271D0806888C8B150AC6C5CE0B00A9D0D65CD49BECF0495257043C9225B936
          5EEA97DCAD73E1C42730189D8B277CC1DE225DD6C09874B9D16C9730040D0F59
          4D46251E4C9239841E274166292A0E2E0B81B1441E581114CBA0F06E8E611853
          C2975C9407AF1551F81B0E56CBC040670DD7258C4A19810E4A7C8F742EA28DC5
          9B8131751DFC7362914DBC173A07368E2EC48A95E835780C3A61F4D242902EEA
          7D7C018E7096AC9471E960B64CDBE54B147C59F058B81CF449FD4F6781E3EA23
          3A8390D4541D3CB38448A4212266651E9875BFAFAC7420590E8AA07CC110E5D2
          22F5BF5C72D24C8FD54BB64B0679F0C0980C450DA498252153CB9C4A6C8D2A93
          CC121626F10BED12931F45549690A04D82D36D38297BD9ED5D5E6FB32772048F
          5EA1845E6CDF58FC9D837909A86907546C9A908FB43C4C26386D86730AEB0329
          114C4B58057DE1F7D2A05A283954480D0AD2E848A9B031124864A575042562BB
          39EB19E381596B974B03D429634FF254337AAF6046621030C6F6F25796D12549
          44CA5AD171158143AF2D3801CCA3C9DDFABC26CC0908C4825876B2FF4025EC0E
          4D136AB09DFCB13D36166EFD3F30FF6781F9E3A75FD231E6900586572FD938E5
          4095C7091917B2245842FC022961E98188180368165FE528658F3818178267C9
          A78843525A6456B94D9C0B582855700EE7000074745CFECE7DC54CD709BD9062
          0F7E6B3102E3C7312A165B608C64006D6F8CC82A062BE86EFA0CCD6F0CFEF07B
          04C19FF3B24C61C305256D718779A19C52E72AB481192EE21EB01AE36F31F34B
          CE13077E76AEB2412E3B9003464BD981033E2B13D31168A02808BE73F02AA650
          E936AFB64AC12E9425AE43AF4A1EEF4E40DB6E6B51D96C7059821299AC4ACA4D
          191D1ACA1FD2C009A8520A13A74E3766246B51E6828D8569C3180D4CFD800326
          56006F94F1DFD3FDBD290065E795EC5D812D1C5382F7F3738D2C7119CF5515B2
          212E2005FA37CDE63A0FC6E72723EF643F11DC32E728EC2783F6E07DA9B2E0EB
          288108C10E1B8BD35ECAEAF5023071441DE92FE9974A985CB7414D0743856759
          609C51C624CED8D3D890304FF1F5B16B41EFD19802303E81312E16EB1F5C5149
          1DE4CB962CE232A52C4A50047865B1CFFE6362BC7DF928B542F0DFBFBFEE1EF5
          A36207A2D10BCCE13508D171AE69DB8CAD6C7EAC9840484D57304B20D9A70AC6
          4D83299E1363929475A19DA27939F75BC87289130ABB412122E180DF0B2AE230
          B0C07CE2A9975C8C69F1C89FC23BEC7D23C4AB69912D0046A888972BFE1796A1
          E7E5258626988AB1DF3DBB722C27D1FF6DA423F439CD08C3E0AE303B0C4C2A1D
          DD036B8B29AF7454669412DBC33019413937B2DD3252C6C0A49398D0C9981480
          34C0011BDB0733C12AD62E0C94C5F8C392458991E452B28A2F522DA6E1E15AF4
          5CF9CA76760A2C3FF1E28CE20C71A1DDE9F001D262B1CD4BE10B12614D27F451
          8CF665B2B0B938FD5EF667172EFFEB52BBF298FE3ECE7E5D9494980EE07375C1
          108951ED9DEDCCBD660BCB82DFD364213A83550EFFD0AB8833CABFB62BF31BBB
          B284C5B96467D84F96BCB48DEB5062B18A88609FB2080C224E30239478BD64D0
          16B1520ACA21D68EC2339D68B7C01E95BDD99B6DFEFDFF00F8A0226A121C70EB
          0000000049454E44AE426082}
        OnClick = TabSelect
      end
      object imgHttpPolling: TExGraphicButton
        AlignWithMargins = True
        Left = 0
        Top = 177
        Width = 94
        Height = 59
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        BorderWidth = 5
        Caption = 'HTTP Polling'
        ImageEnabled.Data = {
          89504E470D0A1A0A0000000D4948445200000066000000400806000000E82A02
          490000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C00000BE64944415478DA
          ED9B7B70546715C0CFBE37AF929064F3682084342184084A2929199CD22A4546
          C571EA54A6D5516AB5F25707063A888ACE541DB523A08C38DA4110D0B10CCE50
          9211DA201DB42D0569A8B421292121C96693DDEC6E1EFBBE7B1FEB39DFBD77B3
          799087D4CE9DEC3D707277EFE3BBDF7EBF7BCE77CEF9760D89440274D19E1874
          30DA141D8C464507A351D1C1685474301A154D8031A0E0C6846A56B6C6595E9A
          48D94AA8A2A252CAB1398B26C644139D3018CC1EAFCF4F7D4135CC783EAA2449
          094192F8C0C870683410F05FB97CF97C7373F3F173E7CE0DE0610E95DFB46993
          74E1C2051045714EFDD1C49868A21306833D180C46DD6E37582C16900D68DAF3
          E5170C24528873C0711C747777BF77E6CC99178F1C39F22F3C1A428D9B4C2651
          07F3BF76C260C84630418FC7332B30535C0FC3C3C3108BC5C0E170F84E9F3EFD
          B35DBB76BD828702A83154612EED69624C34D109832127140A05060707C16C36
          4F3C369BEB1914A7D309C5C5C5505050106D6C6CFCCDF6EDDBFF8096E4C35322
          20CF3DB3FAB09A18134D744201E3F57A191815C66CFB46E793BBEAEFEF876834
          0AF5F5F5B44FDCBD7BF71F0F1F3EFC0B6C478543963363A39A18134D74E22E60
          E6E2D2E8730C0C0C80CFE783DADA5A282D2D059C5F123B77EE3C7AF0E0C19FE2
          297E98251C4D8C89263AA180F1FBFD935CD914E74E3970B49F5C614F4F0FAC58
          B102CACBCB594060B7DB459C6F4E209C176196703431269AE8C40430739DFC95
          3680AEEFE8E880A54B97C2CA952B995BC3B01AAC56ABB867CF9E13FBF7EF57E1
          84619A39471363A2894E209870387CCF6028326B6F6F8792921236CF905050C0
          F33C457BC2DEBD7B4F1C3870E02730031C4D8C89263A910286C2E5298E4F7B3D
          7D063A67646404DADADA286486868686E47172690407E79C385ACED143870EBD
          84D77861CCAD4DBAA5A2C95BC0C76C5D9A02333434448337E53C92BA6FE26B55
          47474799C5141616C2EAD5AB93C7A94D7269A4E832A3C78E1D3BB46FDFBEDFE3
          3D094E1426C3A192905A1E4A2DF57C6CD6A51930914884590C0DA2FA81550013
          C367F6F84A98F5839CF9AB30C3A120747575D1E0E33E33442261E61AF3F2F228
          B781ECEC6CF61AAD328861F4CFD1B59DC4A6861438A9E501325B1BD7B62D685B
          7E341F5FC7414E5427C1490B30AAC54C0586B612F5956D718444D902088ED168
          64E744235170B95CA84EE8C36493000982C0CE23C9CDCD85A2A222A8ABAB2348
          5E8CD6F636A3E0A11165F025A54B56D40C04E3A13708A71437C1A9E0A4159854
          0BA1D7EAC012189E17712BE1808B202AFB8D46F91A9E8F03957586FD3E190ACE
          2B093C97CE9330012548F1789CB55B5D5D4D51DCAD1D3B76BC802EB04D1978D5
          A5591430B7D53EDE0D4E5A80A1A86AE21CA3549C99CB8AE340F30242110578B3
          AD1F7A0683D0EB0B2567E94505D9509C6381CA85468482001008B6342961A52A
          01DE0FAAAAAAE0E2D95FFA1E59158B2D2ECDC9C8C93267592C46FBDDFA39159C
          B400435195EACA54212B91D06DC57981E9E06818CE5CB903368B111E28BE0FEA
          16E525C1B5DCF1C14DE73058CC46F8C2274B21D36602ABD904462500202ECC25
          4A12B31EDAD7FA9FB7E20BC5267FD5921CBB233F23C36E33D9A7EB2BC2712870
          E272F7E639184C06C78151FB454F37590959CBC050084EBDD5C180345417B180
          569E7612684522350426D4A616277078CD338FD582CD6601ABC58C4180296959
          2A1C0AA1C9E5B55E7CDE535BB5C076BF23CB9E95699E16CC80B31D963C7E390B
          64AB99FF6030116460D4895C9DEC692E89C579CC457838FA8F56B400236C5953
          CE8E0F063878E796075C43611C7C19E8B60DD51088C4E16FFFEE860DB58B60DD
          F252B0592DA8E31357F57393E5BC7E72EBE0CAEA3C5B596996F5BE6C6BC60C50
          D2CB62080CE52104461D3809C32F8EA0E0937DFDB6079ADEED8627EA2BA07081
          1DBADC0168BEE182476A8BA1A62C8F01EA1A0CC153EB2B5912D2F86E2F64A0B5
          3CB97E1964D8ADE8FACC93AC519593BF5AE7A9A9C8B49615D9337232C75C59C9
          A29A8950D26F8E4905A35A0CB9A7181787588C879397DA99FBD9FCA93288A39B
          FAEBDB5DB0A22C17D62D2B666DBCF1413F04233C6C595BCEFCDB3B1D83D03714
          816737D6811D0165DA6D0C4CEAE755A33ECC71BE8E6F290273835CAA191795DD
          0D8ADAC6BC078392B418121EDD5834C6A1C6E160D375A8295E000F5616C08D5E
          3F5CEB1A82A73FFD002CC8A0154F23BC8AAE2B075F3F5A57CAE61202E30DC4E0
          6B8F2E47CBB1821DDD995AB94E8DF814304FE2DB0F51FB95C14FE631D341492B
          30A9EE86C044A2311809C5E0D74DEFC19AA50BA1AE6C21BC862E6C28C4C1B71E
          AB610100455D7FBA740B2A1D39D050235B50E3B55E285998059F7BB002E72533
          9B6728006049A932F9D396EEE770389EC04B2897E95300B0CCBFFBF575418492
          DE993FC771816030386E8E19031385838D04261F5696E7C3D96B3D108CF2F0ED
          CFD6B2CC9F9EFA979B6FC2AA25F9F050A58359CAA9CB9DB0ED332BA0A2389745
          65A42414E591E6FFFDFBE0DEF8635A12A06AF45714304EBC6FD04026A8D7CAC6
          C084C3E16441520543AE2C8C7AE0D516A828CC86F568116F7EE88176D7086C79
          A802EC188DB57479E1B67B141EAE72C032B4A8732D3D508BDB0DABCAD1855999
          A518951C862ACD85E77FC8EEDBD9B09B16D268FDE6697C7B13B517648B99AAB2
          9CFA5DB5F471650486B2F1D490569DFC23510E8E5F6C859108075B1B2A71F24F
          C085F7FBA0CF1F86C58539F0C53515F0CF5617BC8F734F6EA615EA6B4AE1E165
          25CC7D592D1606855C179563542824D7EB9E83CCCC4C5A547B16148B51C0A810
          48554B9152F6AB35B5F91F95E1A04D02232A197F049FF2960E379CBDDA89E171
          09D42DCE07B3C90816744F46831152976B68CEA09C868058D97103AB97119482
          733F98B61F989484442931248809AF204903A82E4C6EFB300AECE345A92F1217
          5CBE50CCFBF84BE7874181F3FF22A36930C90413934B7269C7DF6885C1912846
          5EF7B3DCC58C100810990401404460C204D462B620341358F018B521621299D7
          F4BD19FB8120C208650421F862BCE84128FDB8EDE304D1198E0BCE508CEF778F
          46DDDF78F9D29002469AF760789E0FD032F0C4EC9CB9208283B94C0C9FFA1317
          3F801E6F10AA4BF3A01EDD15B93296FBE0BFB7DBFBE18E7B04BEFBF9D508C7C4
          F6D3F581FD5F82E2F2CA19FB814022A8A308C2CFF1A2371A17FBA3BCD017E6C4
          DE30C7BB86239CD3E90F0FEC7EE52A2D4D8B690146108400558DC983B362230D
          353DEDF4E945B9AEC5C54584C4C38DCE41E81C1886EB773C72B10C2FC8CBB6C3
          27963860E3EA4AB82FCBC60A99B45FE445084742C0FDF6AB33C22130E8B60204
          2616170711CA00B9AF1027F44638C11988C59DBDBEB0E7855357E97B6A425A80
          C11036204AA23CB51AD4CEC9EE2CC1B652B2E44FEE4D5E2493CF31A0CB62AE0C
          5D9A15DD9B915C1C81C133240C1422B108044631473AFACD7170DC3D9DE3FA21
          4809B498C4685C94FC9C2079A33CBA3241EC8BF112BA3211C1082E77901BF8D1
          F94E02931E1683031D20CB182B01E37F03B0F51456410679395964257B82222A
          E57E03B33072817279DF0826A389CD3B063A9F267E8AEC2261F69D808C3F7F27
          09E735C797D9973F366FDE4C51C11D54FAA5405019741EE4C452554ED947CAAC
          256DC08CEF8B01C6D205F93503C16AFD52B2DCCFEC2601CC5AE89F5A0930C80D
          CB5FC210291F8A01E549545DC8FCCB730CCE95EA6D2C8F59BB76EDF32097645C
          30162EAB49A590B2555FABA1F3FC8FCA080C1B7E1A5BF90F24BB26AF70817A9C
          4942C5A5FE65B635B16576945C24C1A1E022148E605E1406CBB16720B4F5772C
          F3AFAAAA9A2E8F9126687AE53134C7D052B03165CDFFA314B21C2AC5D0B73329
          FBA7BC86DEDB6C36FA85C053208351337F92C414DBB4CBFCB3F0696E454DE060
          99701067FB53BF3989B2A46CA0C53182429F3D3B3B3BA3A8A8884A321D20CF31
          E1B9B439DFC1D0E2542E6A89B2B5DF5B8BD3DF4E51153E7DA78C327982428963
          6C2E8DCD773054C92518D9CAD6746F2DCE7CCB94D73499130C75BD4513BF3ED3
          0A98D45F2DD393FCD14F32771775325723AE390DC8BC06A3CB64D1C168547430
          1A151D8C464507A351D1C1685474301A151D8C464507A351D1C1685474301A15
          1D8C464507A351D1C1685474301A151D8C464507A351D1C1685474301A95FF02
          56FC5CF91F07F4020000000049454E44AE426082}
        ImageSelected.Data = {
          89504E470D0A1A0A0000000D4948445200000066000000400806000000E82A02
          490000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C00001D584944415478DA
          ED5C69901D5775FEFA6DB34BB368C63363C9B2341A8D908549CC62503960830D
          98C5C19002614C554C0C2645922A42E5472A40A5A8540845D8E2B0388017595E
          802289974008C1408A35D892178C6584646459DB6836CDF2D6797D73F77BCEED
          1E3B54F2233FF2A437EFBD7EDD7D6F9FEF7CDF39E7DEDB2F79F76DDFBFBCDED9
          FF2101BC3C917FA0FE8844FD776FEDABFE523E05847A4B1FE4B3705FAA63D87E
          69D855E41DA8CFEC3709B8E3E59FB6E9076B23B1FDA06DA4F243218590FB2705
          D5A2307D4FB3FD1349D4A67FCF2E466F13BC9B66BB7AA3FA55B0E74BADEDE436
          C86DAE0FFAF836429BA9087D90AF09B9842411F5246D7DA57B71FAA3C93BBFF6
          D89D1BC7CE7D75474FE79036BCBAE6C402911274601A561D500D66AE21C7E082
          5C60D89ED88E91F70105D3AE6A2F15DE08FE34DE9876BB3B4E77385CACEB8B7A
          97A8F324CEA1C8B95CFF05DD60C1B1D7A9AFDDED923A9B44CEE72C2B787FA993
          A96B49A94DEC1FE1DB8407286DB7F1CC915F7E21B9F6EE471A5BB76DADCCB58A
          8E0FF235F1864884D9A20FA39E475D9B42214887C1BD5A580F76ADC4C64CC2E1
          B65D7A11A455E205C2F62FB15E2CE84994395CDBF43C821A899CD3BED75883B0
          85B199304884F3854D82B593BD060E227324FBA6367BA2965CFB9547C4B6A949
          CCD683732689F366D74178BA06EA09D291207109B9E00C60BE038278893B0FB9
          000F927D6FBDD5F727BE407F7C6408EBADD483057173BF8D01E5CE2318D145C4
          04A3A669F001E2FD5E8205A236D43913D6B7609F6087EAEC0948601E16935353
          98A959AB22743E01618BA5B3D34FFA109E55CE70021E52D2497AF18CEA4CC743
          0745E6A0B01F954E618348ECBDC171AC11D6921D6A38CA5C2118C88280163624
          C1EBADAA70761175F0CEA694C31DC79D437DA8CEAC010CB3197D97C283C50C4B
          A5859C40D0EDD4FB28DC827E4F65850043D9E1C189184B2F12D1F12942AFA94D
          69DB3A7EF0BEFA64C019943131F4CB84231B4722E90C76484170F6A071BB9AEB
          A929C6BCF3EE47C4C4D476CC34CC1992C445D8841B2625171AC7156F18F86369
          7023B6E5003AE3A5A9FCDF964C6CCBE0B72A3B9A7206452079392281138582EC
          7B51BE4AA6EBEC84112D48B20806084614A41DD22FE704AAA9347816935DCA7E
          0F603857E280B3ED78872059A507CEB65D338C913166723B661B2EC04432A3E5
          CB4A010DD820013A6C266F9CD1E1030F8F3DA18D74B5850FBFA0A02F9EB304B9
          0F93750A342490B3F36731B358C38F8E9CC133A511A4955E144A1D484AA590C4
          B0804C7AC7807160F1ACCE3B298D1182F49380182489CB1473741F63050397AA
          42D50133A918534FCDC13E3DA612164235977DE14161D2E449443B1F1AF686B1
          A0B51B757CE6925E9C3A750AE572D9B276ED87FFDE7A60A3D940A3D1C0C3BF9E
          C6774E498DEE1A45A9BB07856249EE5CA41D8EC008D246B3C04CA087B04A9705
          23234D3476107B04DB0B6E0F0692395775F6B88931DBB64F69290B98085DC378
          8FC905C5771D896F5FF8F7215E70A94BACD7518F69D55670E32BFA71FAF4E9FF
          16307940CDCFCFA35EAFA37768045FFAE1111C4D0750E9EE4551B247FEF1868A
          0D93499D7301B47BA42429A0C0D11A88C54CE78CA14D9650F8642298577DAACD
          1CB78CD93E29190326490C947608D7492C03C48312F0E35DCA1B8A4A10809C5D
          1430CBF8EC6583989E9E46494A502E3B9E031805CAB163C7303A3A8AF5831B70
          D3033FC763CB5D28F7F6A3D8D165E24E92300370165199E1CCC9C41C065890A6
          4484EB1442648F272A0122DB226A2B30665232A6E9740526254E4DA1E92FC081
          46AC1AE45AF8989F2D0C03DB68F1E77D4EBE69552530AF1CC499336734300E0C
          7AF1CF054C5BC69B13274EA056ABE1E28B2FD66EF2FE1BEFC0F4E04E74F40DA1
          58E9927941C18E025000487DC400316DA702BE78E5F140FD4FB332ED0A5D1F40
          DDEE293B962621826C530F0B8C0CFEDB6D81C922803B29CD8A1C3A89ED54C8AF
          597C01C2181BA33D91470258730D607E134953ED9C3C7912333333D8B97327C6
          C7C7658C29E27D1FBF1927FB9F27C11944418123B337E1A5D5F5215BD7D05100
          3A42E1AF976461F9199A60CE271CCA84AD7C5C31B411D2E51D52CA6A1E0E3BE8
          E7A8413A16BFF70D300B913866A52FEE444299242C6386303B3B9B91B23C76E4
          31496D575278F4E8515C70C105D8BC79B34E082A1D9DF8934FDC8A131A9C012B
          6B459A9C45F18706EB48E628386C2C6F6D09F3DB588C1624FDE6714F15CBF5D9
          931218296513DB555626B2432EA4F7E66DD0332112D236E908CD48E82025D153
          E675C802F39B067F078C3AFED0A143D8BA752B2EBCF0422D6BA9AC894AE50ADE
          FFE9BD38BE7E87664EB1D229E5BAE8692D32351AA93784AF307293031EF4695A
          6DBF4EC9A884BB6E2F6F66DFD429A775EABA973259C79C69D8BD195BE2A192E0
          1909650677BF009CADA64592304988B39E5519FC3FF7AA0DFF6360546676F0E0
          418C8D8DE938A31E2A2968B55A32312BE30332E61C5F37854AEF20CA92393A95
          F6A3255C5604426C319744A72D084029426940258D38233C8BC8F08DAF7B1C44
          E1733DA4CB923155F8A0EFD35B17275C7C48841F47E22C888024F58DEF18058E
          9C4368C62CE1F3970F6B6054BA9C67F4677B083B62B1B0B080279E7802232323
          D8BD7BB7FF5E499A024748203E70E39D3829C1E958679893144AC4515C01996A
          4909350E78C61AA5A42E41A0433234FE7879F3EACDC7DB42F037C7D4E7EC58D9
          C43659F9D783F1E2B4970DB9E8060CF209ED0038603ED3F1354B246F24636BAD
          4860AE18C6DCDC1C8A3260E7C511BA2D7EEF9E67CF9ED58C191E1EC645175DE4
          BF57E74CF5B04F8AF9C5257CE29E9FE0C9E600CA2AE694559D53E49952DA46BA
          DA961FDB3A0556B2971412B031429A3A538744646CCFA028F053E645C7D5DCE8
          B262CC99AA602963A82949D08A252B71DE4063134F379D2728B7339E453A6B0F
          6A4AC6DC74C588668C322265817BA59E6A8C1786E61D982BCB4B3872E4089697
          97E5B612AAD5152D8D030303D8B061037A7B7BF5FB7652C25FFFE38FF1547BBD
          94B50114640C52CC71E753434469B389AFBCF413F8BD1FFC91C4A52CF7E930FD
          A1C33C2C1E39410AAAB076A616EC9691779595CDC9E07FEDDD265D3E5323835A
          7EC730DEC2C7C2080B62107D5B846924B371B91A2D409B2BCBB8E9D5239E3179
          C0A8D7D48AB702B8DD360C50C717F40066825AB586E3C78FCBE7313C238B4D05
          D0EAEAAADE4F3DFAFBFB71CE39E760D7AE5D2874F5E16FBEF1085607B6A0D2B3
          0E8552056E06B7BDDAC46AB38EAFBFFC73FAB8ABBF7B3D4A1D7614A150F0D79B
          324F276368296184B396086086EFE2B864CE57D7C0DC2519634797455B444626
          433171804C024821134BC27E318019A97327818E315F20C05086A8F7CEB0CA10
          AD969419A9FFAB526ADA767BA1608E69B59A7A58677E76C680A2E28ADC57EDA7
          A66C15484DC90475DEED52258E2DD4F1B52757D03D721E4A9DBD3217281B0758
          6D48609AB8F7357BBD945EFDC0F532D536E0685973A3083903A03E71A0CCA231
          07262DF69181260C8A31F3129877DCFDB09854C1BF16E7DA345644590602EA41
          D9789E4E3D03F1F19EF646DA5481A918A3B2AA38C6B8C0A93E36A5A15BAB1294
          F62A7EF0C4091C9D5EC2D333CB7E1A69D3865E8CF69531315890A03475AAAAC5
          272A58D52841B55AC5E4E424FEED1B9FC54B2E68E3FCD13286FA80EE32993F8F
          1E6FFA8E624E8F95B5024B686832C3165BB8743B079C507A9008A1A5CCC51895
          2ED7A2552CC2898EA59DF510CF9B68D4D48B146BDC66736CC798CE66484601A3
          B22A2765EEA158924AD96AB656F573FAEC0AFEF9A74FA1A35CC0B6D175D8B569
          C003B7FFA919FCE2D83CCAA502DEF05BE3E8EE28A2522AA2601380C4C644C540
          C51EB5EDB1477F8C9EF6F730B9A90BE31B8AE8EBE44947069C076E40A9AB5BB2
          AB12E61569DA4BE38BBBC69CA480312D72E6FA2CC9CA666AC15368FACB58803C
          1670638781CB28B363C18F785062A4EC1F5E33CA80711D56DEAD58A2D872726E
          195FFDE1210DC8EEEDE7841A44D542EDB6CE168BF279FFFE6368C863DEF5CA9D
          E8E828A3522EC924A0480C69C05129B492BC87BEF741EC3CBF07E78D95D1DFFD
          ECA9F9C96307F1C74F7F1E89628D763A6A3373417AD9945B55E3D365BA5E211A
          578B629501E62E53F99FA9A7A1468902754C579A10D851B3882964C6CE234427
          D96826672AFF2FBE764C03E302B90BF62A96D49B2D598BB470CB771E970C28E0
          AA176DD6DF4F2F36F0935F9EC6F1B915697C03E875976EC762B589AFFFECD7B8
          74E726BCEC79E3E8A894E59317AECE188A39F7DDF91E3C7F5B2F368F5630B4AE
          F0ACA0FCE1A14FC958D32D9385B2ED672C51D9D1EAA05A9C252E36938FFA389D
          95A918A3A5AC9E7A7630209811B991E9F78858425C89EB6ACEB9D5B0FF972430
          AA0E51C004AF16682850A4671FF8D569DCFFD0AFF1968BB760787D278E9C5AC4
          B71F3D8E57EC1CC58E8D031AA023D3CBB8E692093DE17ADF434FA34BB2E5AD97
          4CA1ABB322A5AF9461A37BDCF299D761FBA632368F2418E809CA31B6690703E5
          BD073FAE930495C1E9184346D9A9BCBB36E2425450E05CA8F0C70B3FDB5B5733
          98EF508C9159D96C35655917395F040E651310A7C4EC98E09ED904819CB7555B
          C297AE1CF7C038C62879AA379AA8D75BD8F7FD835A7EAEFCED8D684A99BAFB47
          4770C1C67EBC6C6A549FEFBB3F3F81A56A0B57BD64B33EF94F0E4DE399B92AAE
          BF62173A2540DD9D1D1A98781E45B575E5876F45EFD8F9E858372C837BB7CCCA
          9A68CB74F9DE2BF705A648500A9D3DBA2035733B60061639D7A83FD921AE941A
          340D199B9E5AD1CBA0821D6BF3270C6326266D8C619D26EC893EFB133AC07C08
          21D4F272473231C1E0F2594BD302B3B8B8E819A31E2D2963B57A433E9BF8F4FD
          07B063743D5E38B1018F3E3D8B078FCCE11DBFB30DEBBBCADA50F748E9EA93EF
          2FDB35AEBBA08039B358C7B5973D4F32A7824E29676EE49A654D129837FCD55D
          E81DDD82AE815114A5F1535DC7D4F04F97DEE4412976A954B96296A126D160A5
          F75562605FCFC4F265817276CB047F6146973530DB26CDF225BF4BA831025B48
          46C1D25EAA9DE10C6C8C8DD32433C2AC2AFF2FBFCE0043E5460153ADD5B1B05C
          C767EE7F182FDA3A885D1B07F12D296173CB0DFCC12B7768F055D675DBF77F89
          89913EECDE611874DF834F636CB007AF7DA12C2025201D1A183334E382BF7A55
          ED5DF5D1AF61DDF804BA06C7A55475EBB8235A0DFCDD79EFC5FB0EDF28333029
          8365070A670A55140F40AEBC85CA5E50DB5106D9FD7D8CF1C024226A909EC07D
          4E5D121DB28A480229CBB2934BA474B53D5475CCCDAF3F174B4B4B2CC604606A
          F8F47D0A98215CB87908F73E78144BB516DE7DF94EE30412982F7EFB1778C1F9
          4378F1C48866CA577F7C18D7BDEA026C19EDD759997AAA87CAF2D473E81B7F81
          5357FC252A950AAEFED8D7D177EE360F8C2A60850227D5D3B926692814C33553
          49770CA0929D0B4496197CDF60B3BA2E30558C999CD452E64C4817C625BE86E1
          F18366699411240F209EC4E58C7998CDCA14302B2B2B7E40D201A3A46C453E3F
          75CF7E6C19EEC52592113F78F2340E1E5FC0552FDE824E998DED3F7206BF3A75
          162F9D1CC19464D437F71FC54EF97AE90B364B09AB68A614ACACAA91E6E17FFD
          906EFBF0EE3F43676727F67CF21E09CC56740D6D94C0F4F83914E644850249F1
          E9BA6BB75F3E7BF2469159D646F67754AC2929BBE62E93951960684ECCE9E66A
          944C80F78BFB381066FF3024E38E67999CEDB8CACA6E7EFD465D8DD394D605FF
          6AAD81BD0F3C8E856A037B764FC8E02FF0EF8F3D8367665770DE701FDEF8A22D
          F88FC78FE331197BFABB2BB878C7385E3A35A6E5AB522E6B509474A9E118078A
          7A1CD87503BABBBB71DDDFFF0BFAC6B6A273680C659975E908AAEBE9C48C8D69
          700A7033BA3A2313745A240284AE8FF38395C86C6359AA0821A43E775C32E6CE
          0362EBE41466EB614132CDB3D523DC9160839659E641025DD837380811C0B87E
          A19D928F8664CCAD6FC802D3B6157F557AF9FE43A770EF7F1E96E9F118769D37
          8452B180B29427B5C0824ED7A898A16A1A0548457F6FB21E05CA866F7E10CFF6
          A88A3216452716441766D18319D183D9A44FBEEFC37CB20E0B492F960A3DA8A2
          5303951D1FA4E9B008E389025CD6D8BE2E9E87E3EA2A2BBBE6AE0396316DD095
          960C610616552A9A719055CD5406A3D49B4E1EB97EABACECD6376ECA00E30B4C
          595C2A49DBFBDDC731BD509399D7B9BA7629491014408A120A000991CC9C2460
          B2F82B4B70CAF23B758EB68C1703F7FF399EEBB19296243015CCB73B2528121C
          D12B4151CF75982FACC3590D4C1FAAC56ECB1D5BCBF829F4B8A6B3AF7E510BAD
          FDE8343D97373D56768D648C99C14CFDAD0E018DB8115EBDD3648B2D8C2304B2
          1626C313D463CC8E4D2965B75D759E9E068EAB732D410A1C59CBD4A5D7DFFEC0
          CF71F4CC12B68F0FE06229574ACA74ED23FFFDE8E0093C756A01EF7DFD45129C
          A2DEAE8E5FFCE4EF6274F3C47303D32E62312D63AEDD81D9B413671463243833
          8A2D05F55C8F65094CBDD863D6482B7B2846A68239AB4B0E12B740D0D98F950E
          74E6920E78B9182381514332B3D5B6DDAC9AE36BA078D114CB147C46E2042E64
          7459C6714A9BE355BABCF74D9BF5A8B1FAECF45D314E09AC1AC454E35A8D665B
          82D4C2A387A771F8E43C0E3C75DAD64BB262EFEDC4F3CF1FC115174D605D4F87
          1EC854DBDBAD3656A454363EFBB6E704270053C199B6624CB7648E654C513246
          0153EC454D3E139D0C149C9231EFE7CC49FC58198D277492D1036AF7D1E9F235
          77EC9795FF94644C3B58CAAD280C2B8C024B1064487D91BABBB93C45032609D9
          3FE4F4E4A621BB496565B75F7D3EDA2A3D756910E0D70B0BFD9AFA217F256F66
          92CCEC9348C9D25226BDB822E54DAD272B95CCFD88A94C14AAF52A16CFCA1AE9
          96DF67E09C3A7A98015393316649C68F7974EB78A2E46BAE388085D20016CB83
          58AA0CA05AEA47BDDC67EF288881E1758C7F25F7CCC405A789B964EE067674F9
          ED4ACA6CBA1C0E88322D6A7CC2209F0278604232206CE144EEFC088013704DBA
          BC827D6FDEA299C1EED14978EAAE24A3AD87EC55AB6DEB71268352126886F70B
          2816ECED186A7F15F8556627DB50433E5D77BCC783F3AD91ABF5E28F3FFDF2B7
          D033BC111DFDC366C24C1D5B28EB45E9891AAC2CA971B60E33F7AFB6A9051C89
          91B2CCCD50197022D94F23278E6A1EED208A316F978CD173FE3532BA4CE3085B
          FD4278435944E908CA8A98D6647F929929C6EC7BF3D6687091DDCF0B57849904
          25F571CD4967C16BBE19093031D9CC7EAAD9CB9A8C5FAA4E52A30BDD77DEA0C1
          F9E9F6EB741D73FD8DF7A267740BBA074750ECE831464F8A86150A0415C30A26
          6689C4CDB09258489C2EC31E0A945B69E416B1FAEB08E0280CAAF311638221DD
          02729B6745E9734813E3E2289BD3B3A2D30117AD5C54C0DCF196ADC6FC89A97F
          4013115BD0B9EF5D4361993B5967CD1E062025910A1C955C2CAF54655DB482F2
          ADEFC2F29ECFEBCAFFAD1FFB2A7AC727D03D740E4A1D7DD6E84688133712A172
          BE82D95690B125051F2FA40A435990FB9D10E13E639F4E072619C6EC3BA06F8E
          D5C0B0931033130F4F729810EE31247B3076D10C2E92469821192565AAE22E90
          39FFFFCD87628E1A8A51AB3355F5AFEA1AF5B9A3A3036FFCC89DE81D9B40D786
          71143BBB8D13B84930B5BA27B5D3D24191B3B55B4EF5CFEC14D923A808F9DECA
          9E1E92715236536D7B76248E9A91FCB0CE38794945C8A25DB6415673BACA9F2B
          5EC828D4F7ABD2587F7BF9A8AC571AFA763F21D69E77F70F9E28AEBD53048EBA
          A5B0258BD6B46D62D4C0FA3EBCFD53F7A17B6433BAD60FEBB5CD993818076D7F
          3DC129D90A1808628360709F91D9EBF636A3200266C1DF1E09CCA45E57D66629
          2CAB61285004F9706F7D008C0D54FACE531B857AC64F1F37EAB2FA3F2BF3F7D3
          68AE2C60B5D9C8809961328B533C858F6BAAA02022DC9762C157935EA5EEF5E8
          EC1F41B967BD1EDA17D4A1F28234313257AFB0BFC8DDDF4312CE97F2EB338398
          2AC6ECDBAF972F796004DF914E8ED1C139E6096C7F93426786BB19EB4847D43F
          5999B75B0D3D66D696A0E81B64293B49C6E20DCCB21DCA6D72EB764E8262C049
          E13449C590A45C314B93D4D07E3C8A1CC995FF8EB220EC40C60EB38E6A684BB3
          32B28F3B1E765DD99E7D0FE9DBC93530395ECDBC8E8EFD303D753121BE653A06
          52204F16750A994A70D4B25465349BAD843B7B638F8B0DCE074FF90C61E84F7C
          CFBDEFA41E6F2BD8E9E2C45F934BF9FD0D597488891A33E4CCF077577866E600
          8560439A26BB3E37548CD973BB94B21DDB31BDD246262EE81D939C42D1FB66FE
          E09C88D62D4754F50621F129C41D92B1315D2760A45950429B1C50C6F29CDA82
          CE25316510C198A10DE18A37C678501B10B9A2F700515F10D19D03DCD1ED5899
          628C59BBEC7F5120233931286C1FE715960D3C430B5EE1EB7DE132323AC06967
          3CD94551835250481BD468A0B719520F25FD2776F5D5762A583B7E810569DFDD
          ABEF5D3E0296FF660067040BF8DE80C2DE9343010DAF3A2BDBB3573266CAAC5D
          CEF722EA05E4BD0B88497C1101B03C9A26D408548E62165279CA0DA69C5DA060
          534D8FD9C1D257E7708EC151BC881581A5C408BFD09453CDC7813E7BA36DF6D5
          F54707FF3DB73F6482FF4A1ADD80C3D9E2A121C32A888C1A3C82CA11BD01280A
          C2E01DA65A4C1D84DE81C57EC5823249D0BE478C237D4D59BBD10A9F2875A580
          7BB244FBFA5DED94BB762E3A874F18CC2A7CB8015F626F962E4B6054BA3C5D6B
          E730841A3E2CE20B4A92970E3A66508FE32007298AAAE6BCC098230F41114490
          41E6DD2186C53145FD492339F63F2B22E877E4D85C30A8B3BAFD2246C58CA00E
          8A700C772EA0B170D231665206FF9042FAD392DA206314E24241B122BD261E43
          9DD07B69264867F5DEFF000E739624977171319BA7EDFC4714ECB9C86DE1BCE8
          E3FA1F8F02FBD947EA0C4C526375B0CC62221187089F955960AA765D596E2199
          0F0AA37CC610F9D2C2F53F5F72E24C2FA817EF170FF2C4037D32E435103E4BA2
          4CCD73AAD4390C01993120878551FCA276F1C98F00F212126A13E7740D23650F
          9AB5CBD576F0C410C1BD5708A6176B77967E1F82790EA8F10508DF35261FF1F9
          683211D266B24DD0F6889430A645AC22D7227C2A4CD542F0522136289146434A
          413BC381A4ACD48E20586C575B2D632C302BED7C69206DF2D813DDD54CBD9731
          23320831C6DAF29797D1454944CC5A76E1C20347BD36E30422C96C33ABF5C39C
          704840482CF0E72631892A4004025783B5E42FD8A3317FEAFF81F93F0BCCDBF6
          FE4CC698290D4C98BD0CC6C9072A3F4EF0B89044C192C42F2225417A4844F401
          34F13FE5C8650F2118678267CE2B8B435C5A7856B9469C73580891710EE30004
          68EFB8E173B8569AE91AA167526CC1AF2F78606C1D23FC69338CE10CC0DAC6F0
          AC0A6039DD8DEFA179D6E04FBEF720D86D569621444ADA21CE64AE329B05AEC1
          36DE87C07016F708AB69FCCD667ED17684C01F9C2BAFC80D0E64809152B66D9B
          CDCAD87004359017047B716C6535DCAAC46C721024C6F73B3E17DB8F7A15991D
          CC018DAFE3A20C200C6735425CFF1043230F1CC268D7D1F0C20D1C81CAA53072
          EA786146B45A55EDD0983FAD18238199DC6680F10D905F94B19F45D4911880BC
          ED825F5D862D21A638EFF7B36C44E292305695C986C20962A09F6D34D77870B8
          6B383B97431816A7B6148CCC7A32D21F7A5CAC2CF4E72809119C1D1A0BA7AD94
          4D4E6680F115B5A73FA75F2C617CDE866A3A31941D4114A4CEC86352C8D8E3D8
          10314F84FDFDA539BDA7C66480850D34C6F9D3DA1B5744D406ECB9398BC239B9
          2C7250187879B14FFF51315EFFF828EA2EF84F4C4C9A5BFD90BD006FF40C73C2
          1C04BBF0D0D29A195BDEF8583681E09A2EE2B99998855146E83C3ADEC66A9298
          75AE9FAC7B69B86E26CB394EC8EC464EC2120EF27D46450C061A98B7DEF63313
          63EAA1F287FB0D7BDB095F24C66C2160B886C274C573B08C7A5E9A636890A118
          FDD9B22BA5E789F47F0DE970D71C6784AEB8CB8C0E1326E556F784B5D994973B
          6A609460CBC3683242E55CC9765D495900261EC42417E99302220DE44D30B60D
          668C5541BB68A0CCC69F2059888CC4BC4B03E912034F27227B22920CB2C68DC8
          1CCFC6222F56BE990396C8D8C0B5C5672943261AF60B71D27ECFAA7D9E2C3417
          4E3F9DDC70F7814F9E6D17AE919FCF097E9D95149F0E905FA6F386888CAA8F6C
          27E667B6E8B9C8F771B2E09D412B476A5E599C11F667BBB4D50C388CC52967A7
          5BC41EFD685B6843B0C92A00E4963B1618589C088C10ECE7259DB6B09952A21C
          6CEEC8FD9C3DB59B638F489EEC4E9A1FF92F3B03E04CF814100A000000004945
          4E44AE426082}
        OnClick = TabSelect
      end
      object imgAdvanced: TExGraphicButton
        AlignWithMargins = True
        Left = 0
        Top = 236
        Width = 94
        Height = 59
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        BorderWidth = 5
        Caption = 'Advanced'
        ImageEnabled.Data = {
          89504E470D0A1A0A0000000D4948445200000066000000400806000000E82A02
          490000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C00000E244944415478DA
          ED5C09505457167DBDD2DDD06CCD66032220B288A2080603EE42D4E0122626C6
          C4B84EC6548CC9C41A632A8E4EACA4ACA849190D194BA52A26EE3A26A2854A0C
          E5024A14508400CABEC9D64DD30B4D030DCC79BD488B1D93C954A5DBCABF55AF
          7EFFED71FF3DFFDE7BEE7BEFC31A1818208CD89FB01860EC531860EC549E1A60
          582CD623BBA6C636EDF7A30D98DA23F2B43CDF63CFFBB4286E010CFDC1214650
          B8A6637A6204A78F0C01E76979BEC79EF76951DC048CD94BB857AF5E1D191111
          11470F969494E44E9932A5820C02F4F0A19E96E77BEC799F16C52D80E17EF8E1
          87AE6BD6AC99DCDDDD4D41200E0E0EECBD7BF75EFBE4934F3A88111C0698FF5B
          814743D45019AA1C0D61BCD2D2D25880E1B26EDDBA3C7A70F7EEDD310049191E
          1E7E0BBBBD6488D7FC5ADFB6B68155BBD85A290B4FE090C1A46E4EE49649DDE0
          2D1F7FFCB1DBAA55ABA615161616CD9E3DBB8EDE7CE1C285E151515163D2D2D2
          2EA7A6A676343535F55ADC630E7F43FB7E988F6C6D03AB76B1B5522C2332064F
          387DFAF4306F6F6FA7BB77EFCAAE5CB9A23976EC988E18C1A1CD004C5E5E5E24
          AEF13B7AF4E84F1B366C68A77D6CDFBEDD7DF1E2C5CFB4B6B636E05859565616
          BD8F3E1805848D7382A953A73A8D1D3BD6A3A5A545939292D2448C9E6500C7D6
          36B06A175B2B055CA8F1F8454545137C7D7D23954A652BF6F51A8DA61DBF5509
          090995C49837A870ABAAAA26F741162D5A947BE7CE1D0A0019376E9CE0F8F1E3
          93B85C2E0780DDDEB46993921881E164676707BBB8B8383B3939B9D3FBF1DBAB
          B1B1B178CC9831F9D8EF41EBB7B50DACDAC5D64A01184A79F93299EC1500A180
          810B67CE9CE92591489C8542A1B8B3B3B3FDC68D1BE5CB962DA3899D555D5D3D
          4B2E97372426261629148A6EDA879B9B9B4346464614B67EF0B6AA975E7AA9EA
          ABAFBE729D356B5690A3A3A37B5757971AF7A87EFCF1C7D6975F7E390AE0B879
          78781C254660F4B6B68155BBD85A293330F5F5F573737272CA1076EA11AAFA3E
          FAE823B18F8F8F736C6CEC58E8A8AFADAD6D5FB97265D999336766C2F8F9307E
          2D311A960AFFE0C18381D1D1D1310D0D0D0A0E87A31D3972A41B656BB76EDDBA
          DBDCDCACDAB2658B1A618C83F0E81F1F1F1FE6EFEF9F4118609EA0008B45F30B
          1F212A41ABD5EADF7DF7DD824B972E3DCC119F7DF6992BF243A0A7A767684747
          47278C2E0108993B76EC68C6799DA91B01EE932E5DBA34099E361C1E520130EE
          15141494AF5FBF9E7A9A2147C18304BB76ED8A168944DCA0A0A06C6204A6CFD6
          36B06A175B2B65CA31DCDCDCDCF08080801078442E6A149A67FA4C9770424242
          F830BC5F5252D23362B1783C42DBA9F7DE7BAF04614D4B2F183162840835CC58
          00F802057AFFFEFDFBD0EA904BB496FDA0D6F15AB060411CBCAF3C2E2EAE9498
          0A525BDBC0AA5D6CAD9489957111BADC56AF5E3D195ED1B670E1C282F2F272EA
          0DD4A886F36842D064293C600988412BCE57EEDCB9B3582010F482428721EC8D
          42E8F2C3B9669081E3B85E438C1E6120010057F0FDF7DF47BBBABA7A1E3870E0
          1A429B82988A515BDBC0AA5D6CAD94A98E31D06530A8D051A34645A22EB9FEFA
          EBAF3F20464ACB4A4D0A0B099688D73BF0397375FD1C81CE4952C98B792E5F2D
          722F8407E9902F7800AA0AE10E914CC28F8C8C4CC77D5DC46878FA0778DF7CF3
          8D1475CFB3F7EFDF2F06D3BB4706E93253C75855C062A805A14808034E051BEE
          7FF1C517B3912374A949A1C1A3A51E5B7CBD248B089BC55229D5A455DE411E10
          614DC4DF36573AFBF83521FCA5EDDBB7AFFCDB6FBF1D0DCAED81FC4181317B1C
          17A44074EAD4A904E4273600478974C50C1A53605A80F0D8613258F9F3919C87
          8199258179DD464E29BBF84AECCE20FF612BDD3CBC70059BC86532D2DAD641D8
          011144C61357353AFB9F3C77EE1CD87246C3A1438722020303A5605D17D017A5
          D2D42BD899999921282EC78391652257D1E2D290F4891D4F15D81218F35089B9
          714C8D07438F193F7EFCE83D7BF6FC34BBF94ABAD4C74BEAE6E96DB0A0A24303
          50C2895AA521D7BF3BACFE272B68F7D84D9B5F70F2F48E0810F0890BAE4AAFAE
          262DD59599CA3367BEFCEBC810F53BEFBC33AEB4B4B410B9AB900C8630DAFA2D
          9A5D8D9DD902184B403848DCCE73E6CC198EE250C2E3F1443A9D4E80A2928F7C
          1186DFDCF2ADCB56790A796E4EEE28DC790E44181A4374BA6E529C7E84D456D6
          74ED7F635B71D8737362DD848EC41B3D8A7A7BC8D9EA1AA2552BC908796BDE5A
          A9DFCDE1C387D391843B48FC3A90055D6F6FAF16C5A9FCFCF9F3759B366D520D
          01C92EC8C01F0D8C396471DE7FFF7DF1F2E5CBC361AC617ABDBE1B2068613C15
          EA1905C2580F4012A2EE98AE38B37F757F79FE78471737E233711A61039CF2CC
          D344595F450A1A55B539072EB8F80606BBBA08856418EC4A8149AFAA264D0A19
          D1A0B00C3F72740BFEC6CF285A1BE6CE9DDB87FCE3E6E4E4E40C80445C2ED701
          2CB0E9EBAFBF2EFDF4D34FD52680FAEC01993F1A18F3245708724128DEDC6EB0
          A4AADBB76FB7FFF0C30F5DD8F6E24D362BC443080A99131DF186E2FA85393E5E
          1EC3C5AE12527F2D83685B9B489B42DD79A85177A9EFF8C529DEBE7E6E22BE03
          F163B3892BC039535D455A95ED44D5DCA4EE5CF7F7CDE8EB261A9D4853C13359
          0893BCC4C44421B6EE60814178091C5013DD9B32654A39318E04F4FFD9807938
          2E8637B51D89F806F2097D532DE750CC8D87E6B271E3C68494D989EBE4C57941
          E527F64AFA157276BD5AD77A45DE939FAF2645BE3B76CCF51C373E56E4202023
          4442E2C9E522C75412855A4D540579157DBBF6EC463FB968D4E8346C594E05F0
          929393C5201C93E055EEE6F1333A04C400631D182A5CE406F1B66DDBA6060404
          CCEAEAEA12A7A6A6D6F20772474C8BF78A957A737D941D5A555E6D7F43A6D75F
          427AA56192911E9EC4DF5144BE83C770EAEA641EF9F9D9359997CEE25E3A8146
          C7D6340C30D681F9ADA1CC5014A6A7A78705070747A33EB9EF074145FF4C6FC7
          BE1502B64CC862F7136D979A74B4B793DCB2CEA6ACFE6847FEA8D9FC000F4FF6
          7F6EFDD43EA2A6E6E795D1314D25C5C5D9A88D2EA3BF16341D13CAAC036335F9
          5380F0566B552A95BAACAC4C999F9FDF0B2F717DFEF9E727D28A1EDB220A2892
          F4CC699306D23A95C5A4530DE6A5E9200A451B91B7B591B20A4DC3ADB2E86BA8
          5744A0D977504CCAD7AE5DEB08C6C7BF7CF9F215B55ADD141717C7090B0B7371
          7676160B854211058449FEE4C974D9C5C545827D27B03311E8B2D0DFDF7F4C4F
          4F8FBAA2A2A2004656777777EB0B0A0AC4C989DCEFBC7C22485B633E696FAF22
          DACE0EA2527410A54AA72B6D7C3603C0E801EC4D1F1F9F4E894442A64D9B1602
          1626686C6C2CC4B60B6C8C0E6C6A944A2543978700F3709702E3E5E5C54608E1
          4745453946444448F126FB848686C6393A3AD299C6BB0E0E0E6AFC3618ECDEBD
          7B6E2EDC4BA9AE1EA38893584A9A1BEF1085BC96E8BA3A8956DBA793E9265F1D
          3D7AB406E130472A95AA00A8BEBFBF5F08EF8B02D82DB83F179ED95C5252F2A0
          B0B0B01321B5A7B5B5F5B1F5687F7660CCE050312FDE13200C05A0DE48387CF8
          70CEE6CD9B1B8969FA97180DE77DF4DFA32B591C0171F308232EAEC1A4FADE65
          525379BBBFAC425BA362CDBF909494D4FAE69B6F1EC6B5726234387FEBD6ADBE
          AFBEFA6A7C464646F6DB6FBF4D49001D4733AF4123C40E1709DA1A18B3188059
          B264893358D88CF6F6762512F30DF2E89816BDC66BCFBFA457050276A07EA00F
          C08C24AEEEE17DD9D74B1ACE67FD7C2B7A624AD5F4E9D3E5AFBDF69A25308631
          38108B49EEEEEE2E1F7CF041D691234768F8B204E61161801914C3181972C818
          84A0E063C78E65834A1B166590C16548B4AE71FF72E7F27FB07AEE27EBB49552
          B9ACA347DD1BDCE8EC3DBBBEA797538DBCD481B0D5BC60C1023A1F43672E7B4D
          F7724189BD162F5E9CF0E0C183CAE8E8E8226231EC3F54FE74C05855C0345146
          D78B81A5C5B7B4B43C983061C25D3258DB187211F28CE0F3CF3F8F443E5A0A6A
          DDF4C5175FB4575656F271AE27262686AC5CB9D2232121C10F24A12E3E3E7E3F
          8803F50ACB654C3C9082B1DEDEDE52B0B01C247D66A2EC890A986A1B3A4986DA
          26E4ECD9B337D7AC59D3464CB397F000EE5B6FBDE50AAA1B0A8F8880E17D376E
          DC7811D775F6F5F5514FA3E0F52E5CB8500C70E7A14874BF79F3E6896BD7AE95
          9D387142565B5B6BF63A3AB5EC396FDEBC89A859CA4D9365CCD4F22F2A605A57
          8642339E1A7AF5EAD5793939393A00328090C3DFB06143100019A1D7EB4578E3
          AB69619A9696969D9A9A4ADF7833CDE522E17BAC58B1221E9E4569771B6A148D
          5C2EAFDCBE7D7B1542640F0062C19304070E1C88015BEB436199439875654F50
          607095CC0C14983D070F1E2CC331FDA2458B7CC462B113E8F47050DA3A784033
          8C2F47F87A0E54B7202525E591E54B870E1D0A44489B5057572703807560679E
          00D48FDE8BE25273F2E4C9663C2B77D9B265612830F941414159845925F30405
          8C1E43178A4F4441180C4336A396E142083CA817354755727232A5CD8631AEFA
          FAFA44994CD63863C68C4716FC5DBC78712C58971FAEAF9C3F7F7E150EF79F3B
          776E186AA32078080F1E4750C3E801B40FF5A4F0F0703AE26CC863B6B68155BB
          D85A2973F2477892C0D863B45A2D1D44A480341617176B5083D0A1123309E0FD
          DA1259E495DBA0C49491D130C7462D248E8C8C740240BEF8533C9148C4CFCACA
          2A5AB56A15A5D34CF2FF45058CC0587E2566E6D443A77D0DC0FC0F8BCACD605A
          4E5F1332F815C1C3397F5BDBC0AA5D6CAD94C5F899E596CAC090EDEFF90CE337
          F56D6B1B58B58BAD957A42D1694D7EEF874B4F145BDBC0AA5DEC5129AB8A329F
          FAD9A7301FC7DAA9309F93DBA930FF808111BB1006183B1506183B1506183B15
          06183B1506183B1506183B1506183B1506183B1506183B1506183B1506183B15
          06183B1506183B1506183B1506183B1506183B1506183B1506183B95FF02D7D0
          1EF931D0D0730000000049454E44AE426082}
        ImageSelected.Data = {
          89504E470D0A1A0A0000000D4948445200000066000000400806000000E82A02
          490000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C00001ED84944415478DA
          ED5C499065C7553DF9E7FAF5AB6BAE1ED5630DDD922C0B2CE331181CB6811DB0
          C0926CEFC0E0151BC2ACD8B0218285172C08AF00DBC292C311180B708481088F
          386CCB92BA2DB935B4D4D5ED560F358F7FFEEF2537335F66DECCF7CA6C5950B6
          FA57FDFF86CC3B9C73EECD7C5FFCF117BFFBD15E63EA2F25F0EB82FE81FA470A
          F57FFB6BF6AA3FA4FF24A4FA95FFB0BFA5FD509D131C97FA4365D189FACAEE2D
          097B3EFD93987104F710D938F83D52FAA39442D2F1A2A4EE28CDD8D3FCF8A488
          EEE97E0F26A3DF93E130CDFBEA1735AE5276BD34B31DBD077ACF8E419F9FC0DF
          33957E0CF42AD81484903D910EBFDADC5FFF6BF1E9AFBDF29533274F7FBC3EDE
          98D586577316992352E61D981BAB01A81BE6E6506070C926E8DF17D9C0D8EFDE
          0BE6BEEA7EA97446709771C6CCDEB7E7E901FBC9DAB1A8DF84BA8EB001C5AE65
          C72FF91B9973B279EAB9DB43526B9328F8AC6565385E1E646A2E29B749F68F74
          F78473509A2478E7E69B5F109F7AEE5AFFE2E2C5DAF6B06CF3815E85338490E6
          1D7D1A8F3C1EDADC15920D186154CB2C82ED5D62630A7F7A765F3E0976571605
          321B9FC8A258F28B2873D87BF3EB486E2476CDEC77ED6BB06C09B2996590F4D7
          F36FC9E03EF939844E0C0229FBA5BB75AF2B3EF5D56B727165095B3D1F9C42D8
          68B603844B579F7A920DC4439C6013CE39CC0D40B228B1D76113704ECA7ECFA2
          D58DC7C201618439BB945D2D8AC82C5A79044B16E6EEBDC051D6703248741965
          8241D3D4C7008B7E07C112D13DD4354530366F1F6F87CED63D9063AECAA59515
          6C76A59D9B1BBC00CB962C9D2D7EF21FE9B22A335CE62C1E654166457C12F296
          1FA0CC9D649D9250CAA73AED4D20D158CBE5CC4121ED38D8D190166606378633
          1CCF5C2903274BE634FF86F0519FA14A985D0C1D5CB029E4B0E785C1A1FEE86C
          1EE198C066FCB714CE59816139B4B00B48FE3E8F3EEE6EC93FE7B0C21CC3D33E
          4D908C12CCD6259667EBFABD37B70694F174CD7289AE5B329CC2CF4FE147CD6D
          CAEFADF9231CAB1303D6A04126FA71193ACA7824824E6F8714CCCFCE69A15D8D
          83BA2A633EFDDC35796965199B7D7305212CC38AD030299B68CC2B594478A730
          B20D6D1B3A50B2C947111E6490358C8AFA6484B21CE2F26C03A3A1C9987249E0
          35720E7D427F94CD1C22EC76B391DE00DE8892DD271C97456A99FAC80A609767
          BF73202375EBB8EC3E2E2098AA748ECBEEDD3519431CB3B48CADBE2598585164
          089146840D46D08219921B394B6DC46A0AD13DD4E033E9A85F5D50304653974A
          474887439C3B56C25859E0F5F5B6FE6C657E1CDD91C4ADFD21654D95658D8DC8
          545F27954E680563E6F23570A8B3B657929A232C04C5C1E5202984A920D01DC7
          1E2126E8A5631DB3A432A6979A939D3CE6102623EB32230BF71290A0799F0FDE
          DFD8B92DB5D1986A2257BCE1F054BD902E37C3C9263A1AA22A47B83257C7ED9D
          3EC197D6AE981E2BE1FC541DD7D77B1852D64841995352923BD58ED6F74DA483
          13512AE92013820D37C8B0BC6030489777460E9A3877307B78DBCBD01E8193CC
          B53A5B770DC72C2EAF6828F33E91BA86711153E814377408777FE97EF77C1142
          9DC8A2CE474F9AF1C610C72A408378627F30C240DF9F52B52C74CAAA09A4C42D
          27C62466C72AB8B1DD475FEA0A0E5502B1A5993AB63A23AC7514602BE7943478
          4B3A4790ACAB926899A895D11B24D81B283EAA18C783CF89F148944D9ED80B1C
          C76BA0188A39C107109A97D4567E7437EF6619B3BC441913A537774AE2E9DA8A
          52193929748A8F32E70E565070672A659526433CD4147868B28ADDEE100939A5
          3D4CD12178DAE88E28F8CBFA841119F9F234B98132E1E6DE90AAEE6A960D235C
          9AACE82459DD1D90534B06DB290BE79B658C554A685585FE7CBA59C3ADED1E6E
          1DD075E97C51121151E73327C73981C33C3409290258CC9DCF50C2508377223F
          D667CC1265CC203BC3B614525368BA34B34E6356F5FC2C1DE7E70B439F6DBCF8
          B33197925193C110EF3FDDC0417F88B7373A981EAF91212BA8D74A68F74678D0
          4E7040592409EA1E5B18C34E2FC1BD368DB75233971BF6716A4C60AA5EC2BDFD
          1E29CC04E3F50A4E4ED4294B4AE89093DBFD11B60E7BB834378E63CD2ABEBF7A
          8052B546D9548AC4011303C67EAE780DF9408F3E0FD3B6D0658A309B69D80061
          2244B2F7D44FE61822FFE5ACC00C18C05E94A5A9F38EC806E58120E017C0F7D8
          82B467F068951B3966448E796CA18ADB5B5D6CF7138A648A725257B5728AF3D3
          75CA1060B74D51BEDDC5E3275BB8BD3FC2EEB08472A5A2AF9D0C0638561EE12C
          61A13A2E259E996E3548AD95716BA70B45451D82300585B3C44767A79B78F97E
          871C53D77C5354D7F02E00EF50B8F9321556ACD0BC4A7566898BDDA0AFE8EFE1
          E5F26582B2AE7347D6F4B3A9C10616FFEE6E00FFC3DB1316FAE241085601AB8C
          217E5924A38EC803B70F0606A214E1D367753A76B651C2895619EDEE008D8AC4
          2BEB0457258A76CA181D8B833E6A490FEF2251303F51C34647E2FEE150C3B372
          8A509C43F02748669F9FACA142CE787DAB8F5225CB1830C307642D4398E3CE09
          7A79474318873ACFD192C9EF501028CEED6DDD27C710945D5A56AA4CE65B2E1E
          ABB25F3D9E49C95A205C157045C29B940C4F79D4A92A5E8E4698AD499C98A8E0
          ADCD3E19938C55299B21244A1C0C312E88E0A71B384B5CF2C3DB0744F2740995
          315A140CB1501FE143E726B5A1BFF5C616DA828C4ECEA3B431F7A17B3428AB2E
          CF3571777FA0458228550CC7E46A34566F485761148A8390F4B9ACCE3E4ED3FC
          BC1DBC996353C96D47C1E4A08CEA988D7ECA30D12BB1B055E22343F0CCE0C770
          6EC9AA692377F981FEBAA91A38A9B24A3AC00A158D7B44FEB789984545D52365
          0D998A8746DD2E6A690F1F3ADBC21EA9AF079411770F5394C8F0A7284B4E8C57
          48360B6CB787F8F1FD1ED1CF589651C2387F38C0391217938D32AEAF75311415
          ADDEBC640E61C549683725BE6CC11C64257FA4B678310D9745AC7DE3EA1E9743
          EEEF9E97CB94312A024BD2D72C527A9EB0FC20A4EB238559103992D53721BC45
          E42F6D5A139C51153F5F97383B55C3EB1B3DB495B22A5574A43476EFE25DAFFD
          0B2EACBF8401F1C4E6DC0A0E1FFB1D6C361750AE36D01A1FC7FD831E5A24871B
          D52AAE12D4956B75725A591B2E1D0D304E7C7565A189DBA4C8D6BA265B502A85
          19128815EE94280B22496A05026FC970FE71F0E62E1DF6DB3CF99B737ADB59AF
          ECD2E2B2EE3559E3C5B23768B9E81B18CF0B3E00840E734AC7D52C11BC3123A8
          7497249B156429399CD24C5FDF1EE83A63FCE03EDEF7FAD7F0C1FE1B1A76F6F7
          0EB0BEB58B9BE3E7B0F0D49F239D5AC0B76FB6B13D12589C6D618AE4F08BF7BB
          28D56A26E328DB941CBF32D7D072F9FA4617A992C971B60446F2AD18DE01CE1D
          CB398323424E99C62228CABCE8BCAEED2EAB8C5184C925A3AF291969C590256C
          34706E0AE5A68D04956ABE25920D36EB41E9581B2526B24B89565E6F9142BBBB
          D7C387AFFD233E36F839A6E716345F6C6D6E627D6317A5730FE3D6F8195C9F7F
          0F6E76ABE88A062ECC3431DFAAE327BFD825C5468A8B384891E999A93A96E7C7
          F1D33B07688F54D1EAB3C5C865834781811DC41438CCCE31E0230B481E158E56
          6ADE6E397857AA6C9BC8FF53CF19B9BCD1654D2D77A0EFB784BD309605B113DD
          BD58A6316563B55A4AC610AA6542FC92EAE66462208D88FC34F1C5C5B931BC74
          6B0BBFFF5F9FC32265D1F4FC717DFACEEE2139E50A0EF60FF1837FFF3A9E79CF
          6731F1D127D0989FC2B9460D9374D4F3ABAB18DEDBC7A9C331120BF3F8D50BC7
          B1BADDC79D43D34BD3F57E56B4DA57E320C90C8C48DE866A4D8B8220D2590F2D
          45E050D7D58EDB31B1D4CEAED7D38E79963226EB2EEB7E526064D68A89095278
          277925C6DAEDB103ADCBDD7A4AA2159792C3AAD7D5A242B0A65A5CCA51E49C33
          9375FD3AF985CFE054A58FD6CC0C4075C7D8CA13E8F5FA78F5F9AFE0D69DFB78
          F64FFF160FFDC6FBE81AE3384E49D02492FFD7D55BE81CECE122D5301F99BD80
          C9A969120A090415942417D01B491C5091BAD919920214A61B2D4C575AC68676
          70107595AD1D0A1AA04E38F0CCE29C0364596AE39E090695313BE4984F3E7755
          2E29F2EFC65A9B7345A432E0BD1E135D118EBA17D5BB524EA17A85AA169CA4CC
          9819AB60400EEA5175DEA3F7F7A942EF53954F0761E95819677EF8F798BCF64D
          8C4F4EE3C4AFFDA62E0A6FFCC73F63EFCE4DFCA4338E17FEE68B3879918C3F36
          86936476E598E76FAEE2FECE263AEB9B78FF3B40E3C479D426E6D19C68E97E59
          A3A2FE13140842F7D7DED9EDEB360E1538BA33CDE727A33905BD2D8F61A19861
          CE32DB048A9D138B0A7BCDAE257F2D97BBD12E166941271B4CB6F8C471978B10
          0752C1CD333567FFD6243FC44CD5D42C4372C4DAE108EDA1C4C07666B3FB2744
          DA63C3033C2EEFA1F9A3AFE2021D3F31358B3BDFFF2619FC3ED6DA09BE31FD04
          DA7FF139CC9D3E8926A9B033C41B5364866FACDEC4FADE363A6B1BB8F4F22666
          961E476B819C435965942605062901D53F3B315E45851CA46A9B0D55DBE8E6A6
          087984495ABB49C3C0BC8FFAA0BE89F9A9401404991605736F8BA9B2CDAEDF69
          C1E56F900551A6C46220E3F8886BD84DC929AAFDF2813354AF108CBCBEDE4142
          8628917455DD600329D018ADD65EFAED7D4C0DB7F1DBA7AA90375EC09DAFFD1D
          D29D0DDCC638AE1E5BC1CEC98731FCC0A3685C398766BD81F3CD31CC13E13FBF
          FA36760E0E20AFBF8D8B1B02734BEF41EBE405549B2D634B95B58ADFA8E82CC9
          111E3DD1A28CABE1BBB7F64817D4ECBEA37CB1188B02A7D878F608B36DCAEEAA
          7172D94356E834448E1399639E3595FF462FF5354A44D471BA72419075CDA24C
          612B76CE43423B46372CC931BBE4983736C831A5B2EEF2CA52B4F63254B54D17
          A7AB3D2C4F9674A3F2BF7EF8022A073FC27BCF3EC099E943323E7075630EDF69
          FE0A7A04578B73F37868BC89AF53C634EEAEE3DCFD03B2F11C26492C8C2D3C84
          6AA36954A0CA5C996A0E2B91931E21C74C35AAF80E39A6621DA3657D96117E09
          323464A4C83C94B1608DFA6F3C4B2C37B33FF5795A95298ED150D64B5D76048E
          E03CC38C1C37E91065090B2537E8348632E29635AAF2557B7F905A7434D09790
          745EA80B9C3F56C1F53B1B38564EB0727C1C17DA9F47ABF4806C97A2D33DC0EE
          F636FEFBED3A7E30BA82CAE26FE1ECEC1CFEEDE56B583E48F0D1CB8FE24EA782
          DDEA0CC6489D09DD1B3363AA5031DD224E3931514355411949F375E259512A3B
          8566662ADC621BA2CC714B01DC36EC98B81095DC71962ADCF9D2ADF6F6D40AE6
          2755C6902ADBEAA481EA0AF826704E94CE91240ECEF1D898458F5914532B9515
          8AD453AD32A6C60CD7F4A88EE99200D8EF92521A0E51438287175A7867AF8BB7
          373BFABCA516F0D9C75E417BEF55B40F48791DEE6287A06D6B6303D7DF99C06B
          9D3FC0B93327F183576FA14E62E1F1471FC1E285F378637B887EA5A17968A251
          C15855917F0955FA6FAB3D34E4AF573433A704F0E4C79F226FE880F0231104CB
          4919AA38E3A45EB1892C3325B36377E79EC9984B4B19C7B03671D8230BFF7617
          B40E738285A596833BA6DCAC73B4834C0FACA1E472832A7C259755CB476D494A
          077ADD44B5EA6F6CB49108955D090E7777F0D9E5EF62E1C4C3D8B8FB22B6B76F
          A2D3DEC5FECE2E76F7135CED3F8573E72EE08DCD2EC65AC730D66CE2E18716D0
          6A367063ED9054571529199E841FA9BF443BA5ABE5B2822EC371528820CB61B9
          844B66C6294C9819D599AB6762F8CA1C65ED96237F69BACBDA318B4B66FB923B
          C4162A3C5B98A2E0F50CF31A27FBA0C706167936004DCB979C237513B34A19D2
          2CA70453291667EB98695671438903A1D65DAAA6B977B08B8FD5FF015373CB68
          4D9CC283BB57B1B3751BBD6E1B076D8955FC1E4E9DBB84DB6D61F8449D4B2CBC
          BC700C3B877DBC469C76989470300046B26CA2D8AEFFB3258E349E6F20028E5E
          8BF13057046FBEB297DC763C83B2E31DC738C70819DD905FC0FE9D5A11EDC930
          82409E6579A264A56B6A2568AA17B14644F053E5111E2632FED9DD3DEC0FC96E
          65C30B6AFDBFBBB3864F247F4492B681E9B9CB54385EC2EA1BDFC1AD9B57F1DA
          8369B44FFF1996AF3C869F1DD6D0684D6B124F9201266B02EF3E3D8557EEED63
          6F50D299A316E35476847D416E3869A78B6C7BBAD3C58E1398344E03C82E7244
          3E33C263BDCD7ABAC0541CB3B4A4A1CC9A906F8C13AE8609F983AB349E114C07
          0451C6E12C8830F53FBDAB728832FDF7C85C432F23DFD81918222E95CD8808CA
          7AFB5BF8F0FA673021D728E21372CC228ECD5CC1F75E5AC38F7F51C7D9777D1C
          E72E5DC1CFF62B688C1BC7286E1A91F45E99A9A355AFE2DAFD43CAC2B296E8BA
          AB290BD650B86A627C19B754DC4B417BC55EA7B830E536E405A619475741D9D3
          CF1A55661CC33571986EC649FE773F08BE6E134E44B0CEB23D3F5072562EAA5D
          32248F4F8D53C1D7AAEA6D486AB14C5432A728782141D03FDCC1CAE805CCEC7C
          0B72F7456CEDB6B15F792FEA277F97C8FD1826668FA341EAEBDA3611FB788BB2
          ADAA5673CC2219BD3E4AAAEEDE410F77888F4A6546F4D9589CECB78E8AE028DE
          24E8213B7208DB68C15B39F17B9219D93B91EA98EDBB94315F79595E5C5AC156
          CF6F480ED408E006EC482BAB0225A2E500E64CBE8B84A731170B367CD4EE979A
          1C6279A6866DAA6FEE1C26BAD073CF93A8E5E7E10033E5213E4835D02B6FAEE2
          856B3FC7CEF6965E283BBE70028F5D59C423171ED27BCDBE7DBB4D1C338E1229
          31992DD6A9CEF51992E8B3CD1A5E23EE525B9F4AA2EC17F158319883E92309DF
          C359AE8E915E30B82C612546A8E6C2B5AC9E52654F3FFB72963109F84ECBC0C3
          81B3385271C5C1763573180CC508C3D66CE7656A0ABDF93A746D7363B3474AC9
          6CD8D38B7604593522F0F986D0861DC708FFF9F3DBD8DBEF6888525CA13AC653
          CD3A3E72E534E6A7C6F1BDB7B6B1DE2F910426C3ABCF953AA2AC1C2371B1343F
          867BBB03AA592810D5D2B2F06D203FBE82B653AE24E0FC6A97D0E39A8EF3940C
          1CE33AF7D65E0CDE74AFEC69CA18B38299BA471DBC37E29BF02DB23C924292E7
          0964524EB2F6048F1868EE50C5E4A56365EDD4B7B6FA484B46BA2AC7CE8F95B0
          305ED5EAEA9DEDB6EE6DA988EF50ED234846EB6B9073C72A092ECF8E61B25ED2
          CA4BED635E6F8FB0469238956699A144F7528E51E7A88DE87A3B6DE618B35D8B
          473E2263E733C30B84B066B3402852E76F772D0F148C127826398E21C7A896CC
          5627C9DED6B56EE16072D9937D6E15890538AFE8F21917A6B471CC8860EACA4C
          157DE2993BBB5DDD9E9919ABEA5D99CA296B6AC74BA78FBDCE004F9C3E86552A
          0877FB34CE6AC504C56080896A828B53356C1D76B14173999F68E2F8B13AD60F
          FAE80E527DBE7ABAECEC741D3582C957D73A7A974CD0B08CC79993B236DAB3D7
          34CCA0803BDD09C2F5CA389FF045460E9DDA314A2E3FFD4F2F51E5BF4203B71C
          23BD52F1CBDF60437030640853B08D1961DF47B0E33D34B08786942313D34C3C
          3F21B040C4BF45F586DA5EA4969113AA711E50C46F13ECA81230A1CC78F7F126
          FD3DC2DD839196BD7A7CE4D8532D722615AA77F706DA312965E84CA34AF05845
          25EBE8A9FD0273AD3AEEEDF7C9B923A3F804DF57C671DFCF8717D48552378675
          365FFDCA9E99890B4EC3B94CF521EB2E3FA5A02C93CB0164050A4B849BAEB39B
          3809E01CE3C580CCA28D3DF9C1A429E318BDBF3845438C3487F4E97795BB3B34
          9E1E396D44B0A49E7B497563738895B9BA76D00D0D45D9F6A544ED5DAEE927E1
          56090AFB30EB2AEADA4A97D5C8C9B36365B5328D2AFD736BC7A83EBD7A194150
          90151C9664BCA9DC7E1EC9E19C7322D88FF610C4F7533F3A639EA28CD16BFE5D
          D65DE63C12EC7EE111C2B288A7237856C4691D2B193D523D5895396A114DEDD0
          D76B263059936655B9DEC6445077B229F4A6F23749242865A58C5027305F9A35
          9BCAEFB5D5E3C21536EED4EC4DCB5A41FAE22A23CD7A7280BA5EB8306307863D
          A2D6614197CB1EEE28BBD3C86E62956940FC56B17676A28CF186B41BC8339D15
          C967E7B0082303F307CE028B2AA662ECA06D078011A4050F6B60FD84867A0C83
          68FD9185265677BAD82472573F2A1B2ECC908CBEDF212556CAD49685FDD4242E
          7F8CDB5D3B528B3CAB23D809EAB3943DAACE9185F148ACB682CFB29AC9D98D8B
          01CB314F3DF3B27E38563B268A8A406149476505F2D1B72BE2672FB9EC74932C
          E4A5230A31767E9A3DAE7161B24A2A0C78EDC1813EE1F2F109DD997E7B77A42B
          7AC3E782A9A1826877E38B20D692871BB25449ECD6971C0FB160F4868D9CC2ED
          14D9C3A308FB3CBBB66EC95828DBEC242E3B841D6C043FC1602C54A4D2AB68AB
          36D86ECEFC44116506BB5784CB3EE53D09ABF59CB21CE1E1B931AA6312FD99DA
          3C7E9D24F440960DEFF816776020CE05F12385C198221EF4F50A3BCE39886DDA
          60CEF43660C126110480B359C059301BFE9E24C72CE97D6589331C9887F3C663
          296D0DC63A819C34F923E1C1C5EDDC384EFB95B860C0AE39A86AAC443AE7CC52
          C1B942CE513F6A89DAAED7F38231CEBCE0995016E1928D1BD295C90E2A7224CD
          8C1CA2170B86C2E37996720786D0A72BFFA79E79496F5F728E91E18141D19523
          3E367977BC91D02C5473456598EE32EF3416999C9FECBD15A4E9C234311C532A
          95FCF6A34CFE72FE936C2E6E35D28A942083F2DC58F4A8442C0AA43F00923F18
          1C05AAFE095419CF5A3F5FBDAFECC9675ED48F936BC7144475908EBCF713E0A9
          5DBB891F998E1D194629A281E5225344E92EFD84EC0E4E7F1F61B7B5452B841C
          EB391F864161141BC3088B10D92299B0E7FBA9E49CA1F9C88EC736328B1C057F
          7F2E93ED98FB8A639EFC3241D9E565AC2B9919F3823E5014148AB0E81A458437
          60B06F394A55670DC64F1EE323228E204866F896235AE9E52E7768CC2101CC05
          70172183F4C6F4F7B0695790F1711D04E6309761F6CFF0C981384874AF4C658C
          D9BBECBE51200739B1538263024888155A082376B0C21ECB8C2D220CCE2B28EB
          14760F6E34F0C70C7984B2F133BBBA6A3B95C17D8A9690EDB3FA2EE423C786CB
          0161460484EF71397B26873BD4BF6A55F6E497286356CCDEE5E228E25110410D
          8F4E37090E07F9340D65278FB8280B1937159369985DE0CEE6981E6747205F6D
          C0D90C8EF82246844012C37F435341351F137DFE41DBFCAB1D8F26FF27BFFCA2
          21FF761A3D8013668B730DD3FC888CEA2382C3117F00281C007FF50E8F26600D
          E032CEDD30C83837F9C081C88D350DEE1BEDF089A42B77B84B96E8587768B6E4
          6E64BE2B57FD35641868BEE1CBEC1DC865728C92CB7A7D229721DCF0ACC81228
          88608499031E71A1933D14E58BCB1C3116C0834704E96130886ECF6131A7A87F
          D2088EDDD78A48FE193BB7D0193C58ED715146C519C10314FE9C30B880FEEE7D
          9B314B44FE293CC846D1CB26C76CEC42C8235684D72C627810BA28CD91741EEF
          DD17E004C1220A332E2E668BB03DFC1285EC5AECB1F04005BAF9B2BA2DCEF6DC
          579870488DD121CBAC0024628A70AA2C734CC76E852C2A248B9D12A47CCE10C5
          D012E27F31E4C44ACFA35738AE90E459043A31E430104E25F14C2D0A2AB7699C
          3939C880822C8CF88BDBC5891F091409126E131B747D03653F357B973B898F44
          CFE02E2A648017470F967FEEC9BCC0A9F104A41B5A001FF1F5B898F0B299BD27
          F9FD189404991665159B8B5BFC0AD0420673C8199441A3494AC907133A9267A5
          0E041970BB7A37CB98CC31EDA4181AD83D43EE899E6AE6D11B64466410668CA3
          E1AF48D1452222CEDA60E2D2398E476D2E08A4C8BD6776EBFB35612F401817B8
          6B334EE2081039214483A3E0CFDBA3BFF3E0FF1DF37FD6319FF8D20BC4312BDA
          317EF5D21BA7D851C53C11F28288C892F11783120F3D8C111D810AF7558E21EC
          C193718E3C0B5E031E0AA125549547F09CF58594B9E03001C01CED02D7FFEDE7
          CA95AE01FA008A33E7F7769D63B23A46BACBE63226CC001C6D0C9755DE591677
          E367687E29F9B3CF9D13B2F73258869429BB0F0B2633CBBC0A3C22DBC231F80C
          0F788F6535E7DFBCF28BDE87277E1F5C4545AE0F20E31882B2C5C54C9505ED08
          6E200708D9E4D85731D99BF25DFE7CA091B373D70A8EE351153DDE1D39EDA8AD
          4545DDE02281E23259165C37CE683B50FF121A38726A08855150C71B33E2B528
          3AA0BFB3A632861CB3B4681CE36EC0BFF2D0FC5DD416E70E287A5F86B3CB658B
          E7141BFDFEB9460F71C2F7AA726AC85F2076F42FEBE69A08E6CF4FBABC0BE7C9
          9D5B141CB9FD646C3CFCBC1859F8D751B244B076E8EFAE6550B6B494738CABA8
          5DFA87E9174358B86EC3319D192AEB204A566714659257EC3137449927FDF16E
          6A16EFB9310387F93738C7B9CB660FAEC8E81EC8AE1D6691BF66088BA15302E7
          15719FFE4771BCFEF251F42CF95FBAB4641EF5437E02CEE8B9CCF16B10C1C4FD
          9D8E546C45FDB1BC8008315DC66B337116468AD04674FC5E5093C45967C7190C
          2FF5F30E60B9200803BBB18B0482837D9E4311E303ED983FFCE20B86637ABEF2
          87FD0EFB6C10C157D3F26C61CEB037F2CB15FF4B96F1C84B0B0C0DD68AD17F67
          D995F2EB44F87F0474D839C78AD01677B9EE30CBA4C2EA9E656D5EF28681EA33
          4A06DBC3B818E170AE60BBA7A0CC3B266E62B2493A51C0A081FDE28D9D915990
          551EBB3851E6F9C74316222385DB89A4FB22D5BC0CB7C7F2C80DBFB2DD0705BF
          7E14C52A360B9C257336B0F70A5729BD12F5C7799ECC3E0FAAFD502C0C76D77E
          21FEE4B9973FBF97949EA6BF8FFBB8CE438A9303EC9BE99C2122A3EA331361BE
          668B5F8B7D1E8B05170C1A39D2EC797C8406D75FDB25B28D5D22CAE234CC4EBB
          893DFAD2367F0F192C560160FB9403620878C267840CBE5ED2624BB052CA9023
          583BB2CF7472BBD9EC91E28DA618FCD5FF005822127971336C52000000004945
          4E44AE426082}
        OnClick = TabSelect
      end
      object imgAcctDetails: TExGraphicButton
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 94
        Height = 59
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        BorderWidth = 5
        Caption = 'Account Details'
        ImageEnabled.Data = {
          89504E470D0A1A0A0000000D4948445200000066000000400806000000E82A02
          490000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C0000134F4944415478DA
          ED9B099C14D599C0BFAEABEFEE999E8399E11C600011E432288707A2181595E8
          C27A225EA88B66C1D5C45BD94DA2B28912578DA82846D1F54C34A21114817088
          0232200C3733C330CCF45C7D56D75DF9BEAA6E7A20E84636FC3233F61BDEAFAA
          5E57BDAA7AFFFACEF77098A609B9D2F18A2307A663961C980E5A72603A68C981
          E9A02507A683964E0FE6BA8B07FC5DE73DF7C606D6C13A8C5BA68DFABB5FF895
          3FEDFAA7BD57A705E37038ACEDF4C915C7FC7DF469674E9012D22825952A07CD
          08E2E9A6D3E9AD6339BE21100C55057BF4D8A6318EF0876F3EABE1E9C71C841C
          98E379F06F01336CE0C851E103BB66F19CFB6CDDD07B2A8ACE9978AA8B678165
          19D035C3D40CBD5151F5E7E33AB7583523FBF1B263C2C981399E073F069810E3
          1EC780F99F6EAFF71C5D3721A5A8104DC810F0BA2094E706C330118C0E1A5655
          D34C559597C9BAF10B89D5BFC4CB15380A4E0ECCF13CF85160820E57B920F08F
          B30C3355554D50741D92B20A2CC34269811F9C28319AA681A61B0845075DD508
          8EAE68DA1F6553FB2F9D872AEC4685767072608EE7C1DB81F11B4201AAA9DB78
          4178100C53D0513234070BBAA943C8E70637CFE3BE013AC2D2118C054845A951
          5550753DA9E8DA7C8D37FFC7641CCDD8A59EB94797069319C0A39BB132ED2A15
          333D28061C43DF1FFD9C997E6F3B7FA08365B90982537892E7F8A168481C0C6B
          DB130661F00C2A37FC235804C6300C5B95D91263EFEBFA46CDA1DF633A9975D8
          A598B9FF0F098C05E477B70E990D90EACE8272360FC650D359CADDF0DB0D85F8
          9B04B6AEFF1B63FC6D601EBDED6226116DB947D7B539BCDB53E8F679C1EBF743
          B4A11141A06632CCC3D76B243108C6D0090CA934D502833586601E3159C77B20
          3007D3F7FF4181615EFCD9252F5F71D7D48B9C1EA7578C27BFF4798C118C29FA
          173DFA295CFFF8FBDDF19C18D614B45329DF05E60F2F3E5AB679F5C72FE1789F
          9557D2CDD57B603FF0787C50BDAD0A6A77EF054992804E5535C3525F2435742D
          CF33D4A9656FB01A9AA92F42D97DD5E1E1D683FD81983F043019D5252CBCFB92
          6F663C7275EF43079BDEED31E0F6C70F6CB96F6EF762EE82579EAC6411CC103C
          A7350D47065BAD19DF05E6D527EE9DB87DC3F2A7F2BB150F2C1F34880D151582
          DF1F000555D5BEAA9D106E0843A4A50D1445B6FA309160229604551281631C18
          E2A42548D757A0C42C647DFC87D86D1CABDED5C1D008722FFFFC52C51A605455
          33EE9F2C18726BB2A1BEE58B9202E134D668F62D7AE650E612A3726FD36DF3DF
          59FB461A0EA915E3DBC0BC3CEF9E73F6EF5AF76CEF8A7E037AF4E9ED080643E0
          F5FA80416F4C46E39E88C7404C26419225305075A908A8B5A5057655EE84D6C6
          6632499643A0EADA1607CFBCC0FA84B7B0DB36AC6A9703938671584A104A72C6
          C357E2378876554FE22BE307A9C54097459985B8131414123D81EDF89B26C163
          CF7876DCBB70EDC5786D142B365A76E7B0F4B42FB7DE746D5945717C7579BFBE
          E5F9A142F0F98220385D1618138D3FD9150D0129AA8C2EB2627962722A0135FB
          6A60C3EACD783B093F16CB85DE87609EE303CED7B1DB26BA675704C33C78CDF8
          C739D671177943E5650530E39E735173A35D4D560324C2F8DA38DE128142A1C0
          AF18741C7BFC72C1C9C1AC795E5079747371BFBE35F1C0B2CAFAA7A3D1B87468
          C1828B0EB446D4E1B3672D11DC3E0B92C7C515FE6AF6855BFB9D7C52495E5E08
          04C10D1CBAC70C7A630EFC3368D8D1FB322976C17B280827951221166D83F57F
          D9080D358750BD99A4CAF6B34EF66904F33676DBD855C17073AF3B43BDE2571F
          A0C7A3423291800D0B6E837834812A454697152C5D4FFA9DEE4F1139196216DD
          5C2F46E903CFBD168A4F1A03454545F0C2DD97C3DB5FD6F7FBC3D4693383D1D8
          9D5B9AC3DB87FFF4A7D3FA4D3C37336A458FCE3E7FED906183FB07434520F04E
          60580ED067B644965C65D3403759B7DD631D25469292108FC560CFCE7DF0CDA6
          5D609024E9C676DECDFF96F70B1FE165E1AE0AC68960A42B110C794132AA8B44
          328E606220CB29A24267019376D8325BD28018B983DBEB06BFCF0FC1601E3C3D
          7B328CBFF9A1E70733CE99F117164255C321BD74DAB4AB26DD71C7DB60BBD4DD
          EE9E31E69D53470E1D57D4BDD4C1B12E6039D6526506DD83B41FD91043053D03
          268560E209A83F588F60768348CE8061AC70E7B91E639DDC66ECB305ABD615C1
          B8104CEAAAC73EB0248206445550CFA3B4506C6173B0C1381C3610AB8D21480C
          7028394EB4136E97001B97BC0889F2FEE6C1B65607B76E97DC5CB9E5BFAB7D9E
          A717BFFB1ED901225C74FDE493E78D1F33F4CA9E7DCA9DBC0B2506A37ED4A658
          4D2B8C21E9340D8482555114FC5052108D46A125DC027B771C80A686163965C2
          AFF38BBDEFE0B35483ED151A5D118C7BEE75E3C5AB1FFBD03AB6DC54D3B0540A
          7DE38CC3B4C064A0308EF43EB14189A163DC001F59051E0C16BFA931E1B5554B
          A0A5AA76D9E285EFDC0EB671A6C1A3582774D6C81ED3CE1D3FE8E7C34E19DCC7
          E5F58003C13A4C8243AA12D2EA52B33F109498942842A4AD156271119D807AB5
          A6B6795D5C377ED1BBCCBF03D26A8C1EFBF71FEEFECEF73C911EED0903F3F0F4
          F1E2F4794BB26D0087079F6319C8843759A9610E9F436D667819E487F2217E70
          25ACF8BC1A56ACD9FEF9FC37D7DD8DA7905F4DEEAC1504620D78DDFCE09F4CA8
          B8F3C249A74D0DE405D1567187FBB76C8C15BF9896F1972574A1133188B6C520
          9E10617F75E3FEAF7736CEC3DB7F3EA47FA80EECE0D6722CBA289871E28C791F
          B56F4B0300B423B69464DA2D38F4C7D85B33BC14F20BF2416C58039FFD692554
          6E8FC3C38BD6A05B07B558EBDB4161B1BAB1F6EAD7ABF0ACE95346FCECA401BD
          7AB95CAEB4D450C786E55C5010A9A11A15932934FC098492847073545C5F7960
          E1D63D2DAFE7075CBB7A977AA37DCAFCD924A63C074CBC934334AD68CA5139AB
          F38379E8DAF1E20DBFC982C91A7894188669675BB22A8DB666E352C84349911A
          57C3A716940441B9062FA5CFB71AECCC00F52660750EBBE8BA72575EF1703915
          FF5109131E3BA1BF31A05769D0E9740A089AB15499A1DBA91819DDF204AAAF44
          3C893626A97FBDBD6EE58A4DF52F498ABE19E11D806C2AC89C3EB9C2EC9A60AE
          1927DEF4E4C7D936682F314C1A54564AA83D52B3027A95B8414428CB97AC862D
          2829DBF7B5C09BAB765C8E276F075B8D29053DFAF94F9E32739CB7E7C0C94241
          C108CEEDED21C72241A9A1960B346F710CF7D63A7A861874209C96ADD2681A40
          D52099C4F8251287D6A864541DE29A773670EB23ADCDCBE2CD35EBA554AC01EC
          60369348B50019673C6B7629300F5C3356BC75FE2747B76725861AC80BA33D53
          87BAAF17C18081FD416AD9042B084A5514CEBEF13178FEE15B60F1F2EDA4C6F6
          614D8C9A36BB4FC1C8336FE24A7A5C2078F3CA789E6739EA8C82D47023A80DB5
          C045774399B907CAFC29F039EDF79324195A631234C519A853CBA1C539185821
          2499C01F5263AD9B22FBBF5A5ABDF9BDAF643941F68B7265243D3471A69BA39E
          31BA0E98ABC78AFFF6D4D2766D58514CC821E358C76135460DB51B1642C5203F
          98B17A58F6FE1AA8DCD606136FF90D040341987FE73458F8C9D671D84578D455
          770F0A8DB9F001AEA86434879D0868470484CC61CC42C6C689F623186D0525D9
          005A6B15B0B13DE0D25B813793202A0E481A3ED07DBD410D9C0CAAB30454A618
          92AA0B1D02D458B170B3DCB07D6DF3CEA57FACDEF6E146B01D8C0CA063CE1375
          4A30F75F3546BCFDE94FB36D4C7A460C81505637A3BE1A0FEE0523BA134ABDB5
          B0E2A3A508250A136F4628E85D151616C023379C070B96548EEF3D7A92AFEF65
          B73FC4F7AE186BC5391C634D82090885B61CF6CEE1ABE4A714F0E3784AC92688
          B785D1354E582919B23782CB0DBE403E24CD7C68887B20A5BBC040608AA2A3C0
          19187CEA20450ED4C5F6AD7A6FFF97CFBDA3C80972342260AB38F568389D12CC
          7D578E11FFFD77EDC08023ED8199A8F71D967B4C6992DACD9F42BE5903AB3E5B
          06FB6A5B51529E40490920944208F87DF01F534F87173FDD75DEC8EB1EB9D83B
          FA9C594EAF8FE5D1DD76221C546240FB020694A41E79ECD3AF3AA01B6FA2548A
          20C65B414C44AC8C32B9D082CB0351C583EACC05A22600AD0DD01008815125DD
          0644558CA6A4FAF5CB6BBF7AE6B964A46E2F3E3E4D39C7D3700E7B6D9D12CC3D
          579C2EDEB960F91160088A9D76B1216DDDB8167EFDCBFB61CA590341E83E16BA
          970F46373904850585100C06AC0CC01D978C82D737B54D1D7CC32FEFF3560C1E
          E1C4AF9E248467100A8F834DD2C3A4C120248FE6805294A6409E80D7D334B282
          26CCB0B240075A14A869A4409326CE200B44C6AD82C1274252098C8AB0A49426
          D5AD5A5EBDEEF1A754394EF68D02CF046425A79382F9D7D3C5BB5E38124CC62D
          66AD08D284D52B3F03C6502158D4DD4A60FA7C5E08854296C450BE8B6CFAAC8B
          47C1BB55DAF503AE7D68AE13A3159E77DA60F07C0FBAC482C0A3A4A0AD614962
          1016BE4E08E3979202525B4E6BEE9F5EB1BE29053B6B62684F0C6BBEDF565F36
          189900E1BE46C7AAADD668ABC94925B1FBAD376BBF5EF00AD8AE3A490EAD09D0
          6C2E9D10CC5D53478BF7BDB4B25D1BA48DBDED9519860EC9781C22D1A81563F8
          BC1EF0F9FDE071A7D3F6364DB8E582E1F0FE6E98D977CA9C39AE7E279DC4B202
          C2342C57D88BD7B870EBE4C8CED895C31BF935134AFC4E943EEA8B0551D2A072
          4F14449126CA4C90118C4680504A084E466214F4D11402A2D8C7D6428D684DB8
          E5EB279E6C0D6F5E89BA97025C8AA3ACD9D54E09E6CE7F192D3EB86855B60DB2
          EE32490CAD56915229FC32154B25B94945119074DE2623613311CCDB9BA3D3FB
          9C37F32AE790B13FE6589410BCDEEDF1803FE007B7D305BCE508B09614B17891
          5737A1CC2B40A8D06381A94249696A532C35A51308D5AEAA253164636C40742C
          934A53D01140B8D63227FC41DCF7D69F2335CBDE48B4EDDB04762C452A4DEB94
          60E65CF623F19157571F0106D279304A548269E7B0289B45CB8DEC892D3BB999
          F1DEC895BEF9C7C3E0B5757597F51871E1E9C1532FBD950F15050404E8F3A174
          05BCE0160494180E81D85E1A5D1FC06E7A0649623C90C441DEBA3B9A5E8C6158
          83AF50FA9F20A0F15765CD8223CB0A2829D59AA2201B64180E4081214066AAF1
          2F3B62BBFFF7A568782B7D6935909E7A3E91BAECC481F9C9A9E2DCD7D664DB98
          B4D4E01FCDB33B32C9FFC3D2614349FFB37366B873D3F9A7C0E2B5B517B90B7A
          E4753FF5F26B0223264E727A3DAC0725C6ED712114DE32FA0486C34A7843D869
          2F5463C1901BAA1B44A83924A216220930ED857EA4A694AC17A6A10A2320A944
          C29ADD34118CE910F0C3E110100352F3FA9AB66DCFBF186FDD4D60325E9AD219
          C1B8E64C19159EBB78ADFFFF0BE6C6F387C26B2BF79EEDF4179842A0A847F984
          99B3F2869E7E9A0BE1081C67A92F2E0306B150A0D90DD5579F121F085E1E2A77
          45209A506D30E89DE98A617B5F283D9AA262C5AD6C5A6A3589AE752A11B36C0B
          CBBA51B43D684818881FF8E09BC8CED75F9393E12FD2609A3A2B18E7CD170CBF
          57E099D938BC416B4EC44ABF67E666C05665F60632BF1F6EB3F6ED947D6B42FE
          FD075F55CFE7787712E1793CC1D28AFE9366CD0C0D3B639CD317700B24251460
          5A6A12ED0C5EDFC72F40AFEE0130B0FD8BCA26CBFDB517941B96FDD0145B7268
          813941A27D5952408A4730F689E0B1020E0463B25E309598DCBAF5C98F130D1B
          FEAC1B6A25D8AA8C66383BA52AE3A65C323994929482CF57AC60154571427629
          ECF729142F9007944C57128890E0F2F7AD9878E3D4C253CE9BE42BEB5B4CD932
          96A405E1F8D0431B80D2525AEA83704486CA1D6D280186B544D6409BA25B9292
          59269B8684FB8A84F6458C8194885AAB6A0C8735136A240EBCBFA369FBABEF99
          BA4253CE34A5492B35E36930278ACB895B25831BFA785D60A7E73948DBFFEF59
          E8E12866A06CAF9AEEC38B9596D39615F73FEDD4EE232FBD30AFEFC821FEC29E
          4186E5995274934FEE13843C34FC1BB7B540EDA1A4155C922A3309906EDA8E80
          62A7602C50782C913726A5D001485A339D9A12D752E135D56D3BDEFA44955A08
          CA4EC84A0B65A0F5CE0826B3AE8CBE70063266E3F8C064169BA78D900599E0E4
          632D165CBE9EA13E2387170F3A6B6C5ED9E08A01834E29EADBAB88737B9DB079
          470BB4C555EB6A0263E81937D8F6D02CBBA318E96384214BA69C6AD393AD3B62
          A9832B76C4EA56AFD75411A5C4DC03F6241DD9960474E200F3843D2FD8A03333
          973EAC21B025A828AF6440BF9E43268C2C1F72E6307F41B75063ABE6D4583F86
          3D1C86373C63EAA683961D58FF4D838060B4A9298AA12A29434A8425255A1D49
          356FAE8B1EFCB24A4D34EEC7B1A9C3F1CFCC9A92A41094CCE2C34E999239610F
          9C2E1938A42E33800258F3D235DF8D64FCC515BD5CFEE26246C8CBE73D054186
          F3B80DD3C1D2A2101DA34D4D492ABA1C4FC9B1036D52ACBE498CD41E424344D9
          E41693A4C334293F46AE31B5512AE6880C73A703F30F7BB8EF06DC5E5D5AD3CC
          60432235E74B576FBABAD3BF0B9055AF546890492D91834176831C0C32ECB402
          8796E726203BABF93773323930FFC769900594819401E5822C10A1DD39EDC1D0
          8067E06400A5DA1D6B90B57147941C98EF71091CF93FD5B87465DB6DDB77DADE
          B9C80050D3FB9945ECDF3A403930C77979BB2D73D471FB9219800C0413BE03C6
          1117FE50C1FC904B0E4C072D39301DB4E4C074D09203D3414B0E4C072D39301D
          B4E4C074D09203D3414B0E4C072D39301DB4E4C074D09203D3414B0E4C072D39
          301DB4E4C074D0F257E8F9092694F8820D0000000049454E44AE426082}
        ImageSelected.Data = {
          89504E470D0A1A0A0000000D4948445200000066000000400806000000E82A02
          490000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C0000225F4944415478DA
          ED7C6B90655779DD3AF7FDECDBDDD3DDD33DA37969A67B26281210C9C428C656
          40D8A6EC60CB024512E0600C260E4EE222C6491CBB8CA92250AA802917AE9860
          14816449B62B55B609A4222145221286A0D7488CA4D1CCC89A11F3E8F7E3BE5F
          67E7DB8FB3F7B7F7BDEDFCC89FFC484B3DF7DED3E7B1CF5EDF5ADFFAF6DEE746
          1FF9EAE337770A93BF23801F8FE81FC87F4424FF4FDE9A57F547FA1510F22DFF
          619F45F247798CB75FEC7615E30E5467B69B0492E3E99FA16E87778DC8B4835F
          23A60FA91882F68F52F28A42B73D1E6D9F88826BDAF7DECDA86DC26FA6DE2EDF
          C876A5CCF962D377B40DB42D69833A7E0877CD58B836D06BC46E218A44278AFB
          7F5ADA59F94CF4813F7FE1FEAB16F6FF64BE5CD8A33A5EDE73648088193AD017
          960D90171CB987311D2ED80DBAED9169187BEF50D0D795D78B85ED047B1ADB99
          667B729C6AB0BBD9A42DF25D24CF132501C5CE95B45FF00D061C739FEADE935D
          E2A44F82E04B7A56F8EDE54126EF25E67D62FE11F69AB000C5C3217EF8EA2B7F
          14BDFFC193DDAB8F5D9DDBE8A7133ED06B643B22127A8B3A8C471E0F6D0E8560
          0D861FD5C244707295B0332377B8B92EBF0976551605C2B42F32512CF8496477
          24D7E6E711BC93D839CD7B8535185B3C36330609773EB74978D719BD071F442F
          90CC9BF6FAA576F4FE3F3D298E1D5FC47AC705671425D19C341096AE8E7A8235
          C4495CC46E780430DB00C1A224390FBB010B92796FA2D5B627BC417B7CD01126
          5A79040B16E6769B0754721EE1115D044CD06A1ABB1860D16F255820B8863C67
          E4B5CDF58FEB87D6FA251030CF89C5E3C7B1D636BD0AD7F8088C2D86CE897EF2
          1F615995749C8085943592DFBC47754FC75D03C5C8416E3F2E9DC22491307A5D
          E0984ED84D7678C771E60AE1812C18686E43E4A2DEA88ACF2EA60E36D8A47224
          C7F9C1213FB4D67601C6EB33FE2E8605CBEB582E2DEC04826FE7D1C7E116FCEF
          5C5618309C1D169C80B1FC26111C1FC3B59AF729BFB6CA1F7E5BAD19483AD463
          A26B974E47268F04D2E9FA2106C3D982E6F7ABBE9FB664CC071E3C298E1E5FC2
          5A579F218A920C1BF91D13B31B0DF38AED18D8637972637DEB0328D8CD0711EE
          3128609895230E560846A0DD69EAF898C9286F9B352362B45D16F7D8459627BB
          BC6D164077AE2801CE5CC706047395163873EDB6660CE598C525AC77930413C8
          8C922F23053C618325E8887524EF64436D846E0AC13582C6DBA00818376E9BD7
          59ACD3AA8D73C86F5D40AA7E05A94E4B9D3C2ECF6198AFA15FDD8F76650E5DE4
          E9BA113308620CC8A63D3C4724EC0C83CB4A922F535EA0DBE0101EB83C985A09
          308B92319D581F6CED31973011F42EEBE4C8BE7849506FE78D67519C74A64383
          456E34B6B1F6BD186D03FF7BB1FE3AB2CFFF39CA6B6710D597D1EBF6D4ED14B2
          69A4D3290C0702DD5C051B87DF89F6D5371182731478699B57C6267A08A374A3
          608C4813CF1DAC3FDCED08BF3F3C90F4B95AEB17758E39B6745C4999C344A81A
          C646CC58506CD36DDFDADCE1E50B5FEA221375A3D11FDE3482CEF95BFE668ECD
          2CFF00A5FFF555D4B6CF603824ADEEF5B1DDE862A25CC0F464113105D87030C4
          807EFBF4BB33FB0634AEBB0362EE04A274C6CB8B1E8B9286C5CC1484D70F64D9
          0F2C770F9EA11080CF507D8EF6DA45C398A545628C2F491E284397AE23040D67
          1DC682DF4699858315141E989C6EE38C4098505934F21B939255F9FEDD285DF8
          0EFA7D811E156ACD6E1F6962C3C29E2AF2C498C16080C13056A00CFB03DA27C6
          F6FE1F41FB4DEF436AFA2015CE692F418B710C1901CC495324DC7D8A84DDFC78
          AE12B17F1F7C5FC79845624CCF1C910C29C4BAD0B4119A80C67A954B48928F47
          0B43C7365EFCD998E3491E5A36ED30100BBD30926D31289BD3DE46EED4D731F1
          C29F01833E86748E4194A6781A62BA5244319BA5F731B18800213014407D624D
          BF8F6E94C5E6897723BEF616A44A35BAB5141B99D0462DB28004B58DA1906F40
          9821502748768FBD635D31EB17B8F2C70043C97FC914985E06484ECA686AD189
          4CA39CBFF6F20BE03AD7A37D0274AC018887F4ABDD88728351CAB8C2C87684C3
          784CB49A0E4CBFFE0CB1E52B945F2E5250A52865E87C92A2EB64E9B3BCA6044B
          0213C7B19632624C5F0244EF9B9357A3F1960F21B3700D52D93C4BF08E95A1AC
          ED3622C06B1C1E7C22413994C0809DBE5D3E4152D6E6519BBC8F58070411CC64
          86B1DA63922D3BAD0E0B05C4DEB37F866CFB326AABDFC3C4D6CB406E0E8FFEF8
          0348670BD43119EADB8C1EDFE21D2292B883035FE8C6564FFD17944EFD050AA9
          018A9532CAD52AB6AF2C13107D569B108B2463E8FA723CAADF9792D657C074A3
          3C76AE7F3F70F46D4897672838D201A3831C01046379BB4B18973A9E1B9DFDF6
          0D812C963BEB97091892B2A34BD29589D121172633FAADD3332122766DD610EE
          48F820A53A26C6D117FE18BF74DB21542B199C5EC961697A03A5541DF77CE65B
          78E8CD9F46B658452647514B516FB58A45A89FDF040AC3266A4F7E01F9951731
          353B8D43C78FA254AAE0B5532FE1C29973E8743A6A8CB33F88957C49D6485666
          B329D556996FFA32D71C7B27C4899B919E27D664B296353AE7B3FC3856D24400
          106B63CC46259256C7BC57757DC559D6B1524675CC6AD7ECEDB125CC012E3222
          CE0CBE0FCF2DA69A969BA4840C7B3DDCF0DDDFC6AFFCE64FE291B345FCD15F57
          F06B37BC8A9B0EFC10F7FEFEB3F8FAD14F203731855CB182289B434A0E634751
          205F7EBE996E5D40FAD1BB3057ECE3EA134B989E9D41B53A811E49D5AB2F9DC6
          CA95156CAD6FA2D7EBEAC8A57634769AE8536D934945181806D5E7AEC5E09A9F
          41FAEA1BE9DA452DAB82C990E0D3160CA018AE34E092C6A4D8DA7C3E7C63EB1E
          CB21FBB9E3EC3231866AB024E95B7B6B93B0C90F91F0FCBEE54B587FB0FA4615
          8F2419FFE0918F68DC49267EE9B7DE85767B074F5D28E086BDAB28E10AEEF9C3
          CBE6C6237C6FDF7BD13A7423456E8E6C6C3A99D818936704261BAFA3F4D79FC7
          E2BE12AE3A7C08B5DA34CAE50AC9611A5D4AEE8DFA0E5ACD263ADD8E6A479F00
          DA585FC72B274F6363798D7251A40C41AB7608BD6B7F16D1E2CDC814CA5ACE3C
          03322EC7C1467C3824C3F38F95B7C40705E36D2EF9EB633A1B66ACECE831AAFC
          3B2E5985B6D71B725117D0C847BC011C2B0AA3588D7F485BDAC7DB1EFB557CF0
          77EF20C747E893F4A05F27F7B4836E876AEF680BE86DD0F6066DA7BF0D3AF8D4
          D796F0C275BF816C8964AD582270B2C61C3863A0EC876C03017CE2D45D3871A0
          86A9E919542A35E4F205058C944E995706D4865EBF4B6DE96927D66EE0FCABE7
          F1D413CFD1E53A2A73B54B7304CC2D884EBC93E4B446419A61B69631817728CF
          1982775AE84C431314302F38AE9D8C2E4BC6ACB6ECD02457323F6985921525D1
          C073939EECA93E75376A2FFEA5724347F6EDC107FFCDCDC451724DCDD780C60A
          814120C8A1926197DED3EFB047BFA40BF90C3E7657197D929322BD5FFBBBB723
          F5E65F4044ECB976B086666F88D76A57290991D7EB6E6FE0475EFE0C4E2CEDC3
          E4E43472B92232648F53E4C6A4DD97511C93FB12B276A16BF4089C76BB859DED
          4D7CEF7F3E8D2BE72F2B9550C0BCF956A496DE4E01314524CDB8DC1A5861CB9A
          20FF2523C7616E1C756AAEDF78B24A3EB73728F9BFFF416D9757DB6C50CBEEE8
          C65BFCB1B0C4F68A5110E967481D71E0DE5B70FBBFFF2B723D7D341B0D3CF5A5
          5F457DBB4192D285CC8752EBA5BECB066A7691ED25D92A53957EFCE60F60EEEF
          BC15B3B3B3F8F2276EC5C59FFB12DEBE791A37FDE0517C6798C1F3B7FE6BAC89
          BC3AA6B3BD8E6B4E7D16D72FCDA2363D8B1CD9DD1455F1B258B4B32E64CBE3A1
          B6C792C19D4E13F59D1D9C3DFD2A7EF0CC2B882558B583E8FFBDDB9039722332
          A549408E0478F69645BA79137B91CEC6D0627880469C359C2DA1D536E7EB2860
          1E20C698D16531144127B3A118D6F126E558909C13D353D3837E0707FFE43DB8
          8380912EA84B72D168D6091892AF6E1B49C64C19379EBC4AB94A53A417CB4572
          6D55CA1793F8E2AFFF2C0E7CF88B78577A1BF52F7F052F2E2FE3DCC73E87D74A
          FBF54D6CAD62DF735FC08D873398DDB7804CBA407D9A565216AB7231564CECC7
          7D15300A983601536FE0D2C54B04CC19B4C80C3417DE88F8477F11D9D945CA31
          552D655E6E089CA13522DCD2B3A29715905EFF315B6C3303370C92319B04CCFB
          1E7C4E2CCAE4DF0EBDB643928F7F3131E389C83B76D02360EE7F2FEEFCEC5FA9
          86C90EE9F748E7892DB2B648A6D452266D4840D4B6149413CB1073F294278A85
          1C9EFEC61FA371E4182E6E6E20FDDDB3F89BEC016CBF91AC2D256879407B6B0D
          E567EFC68FCDAEE2D0C103C816883194B82355AC9AA17EC9CC9840A1DF1E39C3
          6EA78DEDED6DACAFACE3DCCBAF6375B54EE7BC1D996BDE8EFCC402D553255B47
          79B93648D6BB4D17788B2D12BB3D069CD05424E76C27C95FD9E576B08AC59C24
          4A68174541B4706ABBC6CB86F48915871E782FDEF7D9FFCAF4345692220F4899
          A9EB04945464DECBAE9695BBDC462065B7BE8D12158B3F382F70DFB7BF81F5F5
          129A877F1A858919929B8AAAF2BB3B5BE89F7E04D7759FC40D8B7328944BCAC9
          454282135B8988253032408831ED560B5B04F44EBD85F3AF2DE37C6F1E9DB7FC
          1394668F205B9E54A3CDFE42119BE2ED220D2DF32EEABDFA26E8A7709C708469
          8129E8AC3357B6D6762B2DB8FD058F988029A119D014D6C01C20607EF1AE6FD8
          732A3F653A3F934E99F284B32665F791DBC4CAC3E4B2A650BFF8381EFB1FAFE1
          E1B329BC76F45614A7F622479D97A65C227F7AAD3A762E9EC6F4DF7C133F73AC
          8B89C91AE5AA8C3D7F12C1420DC948B690856EEC607B7307F5460BE756225CD8
          F72E148E5C8FC2D43C29587E84116313BE7C89FD649E68BC5A3695ACAAB17699
          AF5708C6D5825CA581794057FEAB9DD8D5283C2931801C9B9C2130A366ACDE91
          C090943DF01E7CF0AE6F3A601256D06F3AA559926C57E0C8FF52FA55AC3C84A9
          3D53685D79128F7CFD719C7CB18E2716FF052AB357A1383DAFC6B3E49E32A10F
          49361B2BAFA373FE39BC35FD14AE3B5846A15030AC89D44A0E692EA4531C908C
          B69A6D4AFC0D02A589E5CD0E4EA5DE84E1D537A1B2F72859732A6C5329B862D0
          3082CD1B791D19383227652C58791087636E26377B437F30AE4CE61825659DD8
          B2C30382E7197BB43F95EC0D38CAE44FC01CA01CF3A1CF39605C8227C6A4522C
          B73849536AB9FC102689299DE527F02D054A030FCFDC81897D4750DD7B0819AA
          53643297C5E280F2C5A0D742B7BE89C6F20554569FC3DB66AFE0F0DE12E5A89C
          E9646DDF9509215BDE20F96AD49BD8AEB7F1FCF60CD6F71228078FA3B8671F01
          4E80A6223D7C8FC47046DA7DF1015A2118182EE187FB8485A8E0C025A9C21E2F
          EC6C6F47CE60BE4F32865CD97A2BF65C97976F3C70023A832749BD4D166D07EE
          7F0F3EFCFBFF8D4919674CCA00E55822B76F9D7F0C07E78B6811288F7EE3093C
          4F4C79F1D5755CF9B14F60F2E0124A5373AA9E199054F628810F286745990CD5
          2D19F4EA1BE85C3E8FDADA49BCA97C0107A653044E5EE5AA819C06E80FD06C52
          FDB255C7C64E0F2F6E4EE152EE3872F304F83C998689296472650227A70BDA94
          196D480653051F331B658B0F16CBBA66882BE61D1A3BC71619660AD68FEDCD4B
          9A3147174D8E61C3C423F324FC62C2CDD528C0AC61D1E84960F6DF7F2BFEE917
          FE3BF84FC20AC5184523F9BF6CD0103F7CF61E2C1D3F46FAFA0C1E93A0BCB48D
          9B7EF9B3F84FBFFB51ACBCFD93A8CC1FA28ABC4C099CEC2E2570419D9E2D1691
          CB649191279345EACA32FA572E20B37D06FBC459ECABB651C99BDAA0D325403A
          58ADA7F0C3FE11ACE7DF8074610E90D6382390CA0F90AD16949C650A150FA0C8
          2C191E3724C48C99D2BCD17A26942F0354D26F23C95FE8D16505CCB145BD7CC9
          EE92142A9C2D7C0A94DB64AE9D7AB34CFE57511DF3CFFEE021060A8C4CC8E41F
          5919931B2E3CF5152C9EA842EC5CC2C37FF9244E9EDAC43B3EFA39D4266AF8C2
          C76FC3C5777C1A85C93D749F697428B1A7CA6564A956C9511EC951C765C84549
          1F95A7FC51DBDE40AF7905838D9790DE398BC2700359D144AB17A1195730AC1C
          427FE21AF4F3F3E8A7E6D0EC17C81050C26D6F6028D6C8EDF591AF55C8604C10
          701535158148B737C9B7BBCDC538991B276FE3A7923D0699FD6D8EB1C04463E8
          1858621B1549F20A80923F526AF6DD772B7EED8BDF72C0A4F4621B7993725437
          91AFE58BE7106F9FC602C9CF63DF7C8840D9C63B3E42A090BB9A99D9834F7EE8
          9D38FF13BF47115D46973A293D35A3EB9C4C4A4D82E50814F94A70C9C0C754BB
          872AEAE8345751DF5C216BDC50433232F27385222A24594D31852BF512DAC302
          6202ACD71B12E1622A3E6362D61592C73514F66450A8D1B58AE4F2889D8A3D76
          629DD7355CAA92843F0E885166F8FBBAE0EEA80253E698C545256509007C615C
          646B187F602E2CAA2C5026C74860FEE57F64C020320E8C6443024348495775E1
          B96F614A9CC7B71F7918AF5ED820A67C9E983241A0CC60A25AC1BF7AEF8FE2DC
          5B7F1B71B688E1CC5E14A87EC992DDCE133859628F7C9FA38252CA6396CE59ED
          47D89B15045E0B2DCA3BADC6961A5196163A572861BB5722392BA035C8A9B501
          03024402D3EF0C35400AA406B5F8024A33310A7298A73A45EC29EB619E64122D
          705BBBB1677C61CAFBD09F2E57AE4C4AD99D0F6857A681E19ED8A75B52A3380F
          9E3482CFDB08E3CADA98BFF7567CFC4B8F7AC04850F4B08B06E985A7BF83FFF0
          E97F879FFF094AC2FB6FC4FE236F209B3C8D993D33A8D5261433FEF9BBAFC799
          BFFF9BE8166AC8CF2D204F512F19924D112894F4A59CE553061802A93488B040
          6C9A98CCD1F1721AB947292C5649F8F5F51ECE2FCB42534E9CC101D2A5D71E15
          9F04525F02236737E5D011CEA13C1F93639B47BE3A43CC29AAC14D19546E0186
          EF5EB5A8083F58B9F4794AC300122E8574362E1263EE7F565CBD781CEB1DB720
          D99F530762068A4A5A7A3C9C253A96604C1D33FFB55FC06F7CD90726B1C5E994
          3EEE89C71F412AEEA336BB5F0D60562A654C4F4F2BC6C8F12E79958FFDA3EBF1
          CAF51F47AF348DDCEC028191D7C0D0FE25B2C4B95C969822F38D640C8145D79F
          A69B9BDF23652BAFE6FE65D32EADB671FABC9C6A88D57CBF668606A62B01A2F7
          03F9B9AF654DBEF6C98A67322FA2BABF8C12B5315B21E6E40A8A35DEDAEC7175
          8C99CFF2E48D9518BE9BF3E7B23AD295DDF9C0B3863143F095961EC21E58DC0D
          72C7E15635F749CA66EEB905BF75F7E37EF2872EFD6574C764759BF53AB6B6B7
          558D51299750A956512A9A617B8D263EFAAE37E1EC0DBF4EF9A546C048007304
          66ACAC70998E29D06B3E23F38CFECDD085AA0381F96A9ED827CF9546AB33C0C9
          B3DB68B5E444994097801948808825129C8431BD8E20B610403DFD59AE0718F4
          2EA3543B8FEA5554DC4ECD235BAEA9D9D5C8CC0BD9F1E324E97B359D48D2B2D5
          30C72E3E4DEFCB9B1A2BBB9318A3673063FBA8834323BC085F22CB8B29BF1A96
          05E6F47FBE05BF73CFB719639C5D968C9153CD9D769B22B3A724A928254A0262
          C66D1286FD0A0173E67A02466411D7AE22792286D0F1C55209D5892A8AF90239
          B4940646AE8EA183CA43817DE51CA6674A0A98978829AB9B3D25534309445FFF
          F61563648ED100C9CF5D2969BD58ADD8D4CB9CBA88E267307155852CFB01E427
          E790C997D4389DED0B3634E31C99199649CC82EB7D265DF68F8E4936C7103072
          4866BD35349BCDF492E7CA7C6BC617BB25052BCC8CA6143899FCA7EFFE797CF2
          DE273C6060C6C152E6A6743D24D472233DB1A5C14FDC9BD4CF8FFCF41B71EE2D
          9F40B7DD27D64C939C4C224700562AC4AE89328AB91C312643806897268F9FA0
          D31CA849C694D0A44E7EE1CCB6598C11ABCEEFC9E17F090225FF7E77A0C0E976
          7BE8C96B50DB650E8AE30844180D50F77954E6DA04CE413204FB9453936DF69E
          75F1EA1ACE9CC84D8AB17CC22719BD5C046397EFFC9367A8F23F4E8C19322422
          360FC18176EC49469DE3E4692E96001563BEF273F8BDFB9E74C0A40C6BE83F39
          CF9E58CFC8B2C3303272FBC9FBFEF04F5D87F337FE5BBDFEAB4EEC9A3D863C49
          588918532C150894AC4AFA12980CFD4A78A7E9A40749C66AD345BC76A585F397
          5BE4002503845EE82765AAE75CD880244C02D26E34D4ECA618C82EC8D1BD6408
          A01401770AE5A9554C1C3C8CF2EC012A44A72890B2AEAE09659DCF789A24EDD9
          642E732298BB81195DBE434A99B1CB9E6471A7C53B9F31C85A000B8C96BA01D9
          D3C97B6EC3A7EE79E4FF1A985FFEA96B71F11F7E4AD5119D3A25EF7E16A58545
          2565B94C46C957260186609169792FC9D7E17959246671F2952D6C37FA1A98A1
          5CA9136BF745EC19F4E4781BBD768592D52659EB76634705413A5D246A97C8EC
          1030ADEFA03AD341F5E03194E70E22579956EDF1243D9836C698FEF2652F9822
          100E5CC5983B88316ACEBF1D8F2E4B4500D2885D0E8B516DF9E432A5CC530F20
          F7C25F20D56B7883777CAE3B698B4DA27C40CFACDAAC1FBE09AD6BDE4DBA5E54
          1370EDB565CA0324650B4BC897AA54C3A4940C66944C529EA1E30F577338B87F
          02316DFFEEC955657FF582F258E58F414F33472E309720C9F7DD4E8F80DFA2DA
          678B3EF7A8E38B10E93215A775B2998F6362FF2C49D922159EFB08F02955D320
          62C32F22589AE4B122310666A551B28855C470A9C70D6FB53603C658FA896401
          B9F159817D76D3C86171A4318AE50A48AA0306AD1D929F6D55E0E9897E1E553C
          BA3CA1B48A2A6F3C9DC9A9E54469AAFC05897F978AC6C6EA25F4C861E5260EA0
          BAE7A0AA77D2922DD4A40A39B42562CBC242052B5B5D9C7C79931810AB452131
          E594A1624AB24CD68044EF7B1DCA2FD4DE4E635BADAA89A3BCB2C5FDD6F72897
          6D922B5BA29AE6909AB391839D48A7DD73A25E61E9179A63FF26847BCED8DA69
          77FF9A31F73DAB1E8E55C00495AB7364EE9C6ECCCC973AD70A394C3EA44E9073
          256D35E82887E8F9525511E6A5116AB31F390E96C9AA65B314F7A4F76D74B7D7
          A9F157E8778376A71A63F2102AB579EAAB2C16C8265F73B886494AFC4F9F5AC7
          85CB4D6557A5940909D0506823209D97648D04873E77A41BA373F7DA4DB336A0
          4112F7120A852B28CD1F24477604C5E905CD16321F6A9673C46505A0F07EF2D4
          869B03F67703B41A9249A46CAD35B4EC88989470B9F20AC944E262E15C74E236
          D4631BB1AAB863D52B215B043CF609B7EA86EB72249FD131936A09F86AB54BA7
          891E31B1B3BD86F6E60AB1A849D14D354D79014B879770F4C00C8AE53C9E7B79
          1D9BF5BE7A824102130F131BAC1D9ACA3BBDD87C1E28D3D26D6F11735E45DC3B
          43B9A48FF2CC7E9428AFC809BA5C758FAEFEA3940D51375CCFFA0882ADFFF6F3
          0C1F4DB67DC64194C95FD631B713308B6A5DD9101E51780DE3751E13B36468C1
          7B2ACC5D803F12EE9D3CC92B7C26CFCDC4790DB68383B2C61ABAB503B2130714
          DD1D92B6DECEA602A9D76C2247097B86E4AD4CB67A6DAB4F9894A8EBA42DC82A
          B6C86507EA310D55ABC8DAA647EC20405A1B946F2E43F4A853D23BC8538D5498
          DA4B80EC55B58B9CCE56F54BB2F830A84542CB3C4EC29CC2B07E749A668F5395
          FF1DF73DA3962F596084BF239F1CF3E722582478FB6B0B3D32DCEDB18ED35D8C
          82C613A60D1496C3E4E31B6A16B3A701EA342817D409981DFD2BF3048126734A
          3CA016C532C2E57474569900A11EC790E7E8D16B97FEDE20691A90640A351F93
          A3EA3E3F31AD6C718E00CE966A7AF83F95366C81D776DB32969FC59840553F9E
          2B63FB30C550EBCA6EBFEF69F538B902664C547B74E4633F9E9E267337E123D3
          219002E364D11F2667EFA380EE5CA7D5D78018B91C7495139439ADDF6D91E968
          A845E303FA1DCACFE4E6E4A23EB944562F653261AA56E3A4D51A6939319696AB
          38C968648AF27702A9BC1CD221E9CAE5CD1A85644E26E84CF70502B04F572403
          99E38062358D08824EEED79539E6F67B49CA4E2C61A5398497DEED8922539187
          D4656B9CC3C139113C6B1950D5A2C6F293CB3BEC5913765DCF9EF32F3990EBA4
          85CE1F88F582BE78D8538B34863D0D98FA2C41190ECDC352263BA849A2488D18
          4BF717499391C9ABC51E0A2C295B6AC54DE4DCA92EDE46191F4C8B0830C0F868
          B2FAE83F39E007BA192B938CD16B97ED370A8C484E088AB74F1215860DBE4373
          516197AB8AC491B1617298E173EFA6B00B28EC1A1C700969ACCD86628592AB81
          5EB76C96C8CA4519F6B97BA1E79954DBCC3C8B022AA397D7EA756F299B4B47EC
          AD17F5AC8D0123BC84CF9D58B08C96BF2A5776FBD78831C7F5DAE570D8602427
          F0F789EC447E278ECC4F04348D58670BB8C68FB090E5A6F1C9D4671738D8824B
          87D04025321AC79E2D4FDAA013BA962BFE8CA9A7089E2586FB86A631D57C98E8
          C73D951DBE26ED55C9FFF67B9FD6C9BF19070FE0F86CB1D0B0277311746A3870
          673F592AFB0DE0AF0EF05163C19FC0F296A5722609DEF68071ACADB177DD6085
          4F605D39E0962CC1BE765733E5AE6D7E3282E15826841F68C97016787F7B7699
          80917679A53D1CC310DEF1EC9B2B228C8960F8CC018F381F64274541D53C2E31
          8E9107A708C2C9A017DD2E87F19C987C880339E6F2E6FEC68E1D0B060FD664BF
          805121237880C21DE30717D0DDBA9C306691927F0C9B2FC01AC2C8335293304B
          2B82CE67ED7372C62383CBA05709B3E3CDF2607F69A9CFDA71CFE2BB7E18D576
          FF4B14CCB9D863E17ED1E7EB7F380A6C671F793078921AAA8361962712618AB0
          AECC00D332EBCAC61692E341F1283FD211E3A5C5F3F442F8FB82EDCB9C9E532F
          BF5D7E2E611168CD90D5405897C4993A2EA8ECA27106B2C780312C6441E16ED9
          31C1D4C723C1142E364F82AEABA5EC29BD76B9357491E832B88D0AE1E9C5EE8D
          E57F77C97C0CA8E10D08DB344F3EC2F37133E16C33DB26F8F59894784C0B58C5
          EE45582BCCD542F8A542D8A14C1A3529056F8C0F2467A50A04E1E576B9D530C6
          00D31C8E9706764D3FF78CF9321EAF83786DC3BF0793356257F91BE7E8021311
          B2D6BB716181E3513B1204221AD9A657EBBB39616740582EB0E76639892B4000
          82AF06BBC99FEB8FEEE695FF0FCCFFB3C0FCE3AF7D9F72CC71058C9BBD749D33
          1EA8F179C2CF0B51902C59FE6252E2A48765449B40CD0AE9209F25EA130512E3
          0225747BBE847069F15DE52E792EC1428891E0D001C080B681CB2B7F1EAC82DD
          6330CA62C0EF6C59604C1D23EC694718E33300BB77866595032BD15DFE0C8D6D
          28CF65BC53D8DF2D08669B91650811B3EBB060D27739EA0277619BDF06C7702F
          EF3156F3FC3BEAFC82ED7089DF05D7A86BE381A78121293B76CCB8326F453BEF
          202B08E6E6D857312517DDE5ABAD42B047CEE5EDC7A3CA3D4D8031A0F9EBB838
          0318C3BD1A21AC7F5847631C388CD14943DD8BDFC101A8BE1406411D2ECC08E7
          A26887EEE6B2640C01B3784C03632FC0BE51C67C0E1F7B0B0118B75DF87737C2
          16975392E877CF353A898BDC58D5881B72270881FEDB46737504F3E7272DEFFC
          FBE4E08E0B8E91F564AC3DFCB85059F8D751322224FDD0DD5A3652B6B838028C
          ADA82DFD7DFA8512E6CFDB704D671D65466605AB33C631C939F6303704CC136E
          7F7B6B89DEF3CEF400731B788EB3A7350FAE88E01A30E7F659E4CEE9CBA20F8A
          07DEB8DCA7FE91395E7DF9283A49F23F7A74513FEA87D11BB09D3EC21C3707E1
          DDB8BBD2AE8E6DDCF8D8A881F0355D847333210B0347984474B8CDAB4942D625
          EDF49A17BBFBF664794C107AFDC64EE2190EF6F71115D11828606EFBEAF7758E
          E9B8CA1FC977D89B46D82231640B0323B9909BAEF83FB08C475E3CA6A3C18662
          D467C3AE989F27D0FF5DA423B9E7D01126C5DDC8E83063D2D8EA9EB176D4F2FA
          81EA1825BCE561DC8C703997B2DD9152E680090731D94D5A53C0A481BD719D6D
          9299C72AA75D3C518EE61F2759083AC98B2E05A47B4C1C3C81DA7D79E4B2D592
          4CE67C371644B17AD879142C31D207C9B5FC594AE744DD7E2E4F9ABF7BD5BE6F
          167A5BCB17A28F3EF8ECE7B787A93BE9F35E17D7A39262ED00FB663ADB1141A7
          AA238791FE9A2D7E2EF6F7D02CD86050CAA19F67E111A9AEA3BEB64B3F22AEC0
          F158ECCFB3D8A7E3822F6D73D710DE641500F6C89D9718BC3CE11821BCAF974C
          B4C55BABC094C39B3B4ABECE9EF75BC21E119D2E45BD4FFD6F09638A6A6056FA
          030000000049454E44AE426082}
        OnClick = TabSelect
      end
    end
  end
end
