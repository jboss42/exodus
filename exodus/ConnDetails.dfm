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
    ActivePage = tbsAcctDetails
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
          TabOrder = 0
          OnClick = btnRenameClick
          ExplicitTop = 171
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
          TabOrder = 1
          OnClick = chkSavePasswdClick
          ExplicitTop = 150
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
          TabOrder = 2
          ExplicitTop = 128
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
          TabOrder = 3
          TabStop = True
          AutoHide = False
          object lblPassword: TTntLabel
            Left = 3
            Top = 0
            Width = 47
            Height = 12
            Caption = 'Password:'
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
          TabOrder = 4
          TabStop = True
          AutoHide = False
          ExplicitTop = 40
          object lblServer: TTntLabel
            Left = 3
            Top = 0
            Width = 34
            Height = 12
            Caption = 'Server:'
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
          TabOrder = 5
          TabStop = True
          AutoHide = False
          object lblUsername: TTntLabel
            Left = 3
            Top = 0
            Width = 48
            Height = 12
            Caption = 'Username:'
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
        Height = 242
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
          Height = 36
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
            Height = 23
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            Text = '0'
            Min = -128
            Max = 127
            DesignSize = (
              94
              23)
          end
        end
        object pnlKerberos: TExCheckGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 138
          Width = 341
          Height = 38
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
          ExplicitTop = 136
          object chkWinLogin: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 22
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
          Top = 194
          Width = 341
          Height = 42
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
            Top = 19
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
        Height = 209
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
          Height = 81
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
          ExplicitTop = 130
          object optSSLoptional: TTntRadioButton
            AlignWithMargins = True
            Left = 0
            Top = 19
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
            Top = 41
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
            Top = 62
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
        Height = 258
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
          Height = 106
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
            Top = 22
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
            Top = 64
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
        Height = 160
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
          Top = 22
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
          Top = 70
          Width = 213
          Height = 36
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
            Height = 23
            BevelOuter = bvNone
            TabOrder = 0
            Text = '0'
            Min = 0
            Max = 1000000
            DesignSize = (
              86
              23)
          end
        end
        object pnlKeys: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 118
          Width = 213
          Height = 36
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
            Height = 23
            BevelOuter = bvNone
            TabOrder = 0
            Text = '0'
            Min = 0
            Max = 1000000
            DesignSize = (
              86
              23)
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
      object imgConnection: TExGraphicLabel
        Left = 0
        Top = 59
        Width = 94
        Height = 59
        Margins.Left = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        BorderWidth = 5
        Caption = 'Connection'
        Key = 'imgProfileConnection'
        OnClick = TabSelect
      end
      object imgProxy: TExGraphicLabel
        Left = 0
        Top = 118
        Width = 94
        Height = 59
        Margins.Left = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        BorderWidth = 5
        Caption = 'Proxy'
        Key = 'imgProfileProxy'
        OnClick = TabSelect
      end
      object imgHttpPolling: TExGraphicLabel
        Left = 0
        Top = 177
        Width = 94
        Height = 59
        Margins.Left = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        BorderWidth = 5
        Caption = 'HTTP Polling'
        Key = 'imgProfileHttpPolling'
        OnClick = TabSelect
      end
      object imgAdvanced: TExGraphicLabel
        Left = 0
        Top = 236
        Width = 94
        Height = 59
        Margins.Left = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        BorderWidth = 5
        Caption = 'Advanced'
        Key = 'imgProfileAdvanced'
        OnClick = TabSelect
      end
      object imgAcctDetails: TExGraphicLabel
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
        Key = 'imgProfileAccountDetails'
        OnClick = TabSelect
      end
    end
  end
end
