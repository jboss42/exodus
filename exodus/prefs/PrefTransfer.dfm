inherited frmPrefTransfer: TfrmPrefTransfer
  Left = 243
  Top = 168
  VertScrollBar.Range = 0
  AutoScroll = False
  Caption = 'frmPrefTransfer'
  OldCreateOrder = True
  PixelsPerInch = 120
  TextHeight = 16
  object lblXferPath: TTntLabel [0]
    Left = 0
    Top = 43
    Width = 187
    Height = 16
    Caption = 'File transfer download directory:'
  end
  object lblXferDefault: TTntLabel [1]
    Left = 0
    Top = 394
    Width = 228
    Height = 16
    Cursor = crHandPoint
    Caption = 'Reset all file transfer options to defaults'
    OnClick = lblXferDefaultClick
  end
  object lblXferMethod: TTntLabel [2]
    Left = 0
    Top = 102
    Width = 160
    Height = 16
    Caption = 'Send file using this method:'
  end
  inherited pnlHeader: TTntPanel
    Caption = 'File Transfers'
    TabOrder = 6
    ExplicitWidth = 391
  end
  object grpWebDav: TGroupBox
    Left = 10
    Top = 158
    Width = 346
    Height = 219
    TabOrder = 4
    Visible = False
    object lblDavHost: TTntLabel
      Left = 10
      Top = 20
      Width = 60
      Height = 16
      Caption = 'Web Host:'
    end
    object lblDavPort: TTntLabel
      Left = 10
      Top = 69
      Width = 28
      Height = 16
      Caption = 'Port:'
    end
    object lblDavPath: TTntLabel
      Left = 10
      Top = 98
      Width = 60
      Height = 16
      Caption = 'Web Path:'
    end
    object lblDavPath2: TTntLabel
      Left = 105
      Top = 122
      Width = 159
      Height = 16
      Caption = 'Example: /~foo/public_html'
    end
    object lblDavUsername: TTntLabel
      Left = 10
      Top = 158
      Width = 63
      Height = 16
      Caption = 'Username:'
    end
    object lblDavPassword: TTntLabel
      Left = 10
      Top = 187
      Width = 60
      Height = 16
      Caption = 'Password:'
    end
    object lblDavHost2: TTntLabel
      Left = 105
      Top = 43
      Width = 182
      Height = 16
      Caption = 'Example: http://dav.server.com'
    end
    object txtDavHost: TTntEdit
      Left = 105
      Top = 16
      Width = 221
      Height = 24
      TabOrder = 0
    end
    object txtDavPort: TTntEdit
      Left = 105
      Top = 65
      Width = 221
      Height = 24
      TabOrder = 1
    end
    object txtDavPath: TTntEdit
      Left = 105
      Top = 95
      Width = 221
      Height = 24
      TabOrder = 2
    end
    object txtDavUsername: TTntEdit
      Left = 105
      Top = 154
      Width = 221
      Height = 24
      TabOrder = 3
    end
    object txtDavPassword: TTntEdit
      Left = 105
      Top = 183
      Width = 221
      Height = 24
      PasswordChar = '*'
      TabOrder = 4
    end
  end
  object txtXFerPath: TTntEdit
    Left = 26
    Top = 63
    Width = 231
    Height = 24
    TabOrder = 0
  end
  object btnTransferBrowse: TTntButton
    Left = 263
    Top = 60
    Width = 93
    Height = 31
    Caption = 'Browse'
    TabOrder = 1
    OnClick = btnTransferBrowseClick
  end
  object grpPeer: TGroupBox
    Left = 10
    Top = 158
    Width = 346
    Height = 139
    TabOrder = 3
    Visible = False
    object lblXferPort: TTntLabel
      Left = 11
      Top = 15
      Width = 198
      Height = 16
      Caption = 'Port to use for HTTP file transfers:'
    end
    object txtXferPort: TTntEdit
      Left = 37
      Top = 36
      Width = 172
      Height = 24
      TabOrder = 0
    end
    object chkXferIP: TTntCheckBox
      Left = 11
      Top = 70
      Width = 307
      Height = 21
      Caption = 'Use a custom IP address for HTTP transfers'
      TabOrder = 1
      OnClick = chkXferIPClick
    end
    object txtXferIP: TTntEdit
      Left = 37
      Top = 95
      Width = 172
      Height = 24
      TabOrder = 2
    end
  end
  object cboXferMode: TTntComboBox
    Left = 10
    Top = 122
    Width = 346
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 2
    OnChange = cboXferModeChange
    Items.Strings = (
      'Discover a file transfer component using my server.'
      'Always use a specific file transfer component.'
      'Send files directly from my machine to the recipient.'
      'Use a web server to host the files which I send.')
  end
  object grpProxy: TGroupBox
    Left = 10
    Top = 158
    Width = 346
    Height = 97
    TabOrder = 5
    object lbl65Proxy: TTntLabel
      Left = 10
      Top = 20
      Width = 227
      Height = 16
      Caption = 'Jabber Address of File Transfer Server:'
    end
    object txt65Proxy: TTntEdit
      Left = 10
      Top = 39
      Width = 316
      Height = 24
      TabOrder = 0
    end
  end
  object gbProxy: TExGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 416
    Width = 388
    Height = 243
    Margins.Left = 0
    AutoSize = True
    TabOrder = 7
    TabStop = True
    AutoHide = True
    Caption = 'Proxy type:'
    object rbIE: TTntRadioButton
      AlignWithMargins = True
      Left = 0
      Top = 20
      Width = 385
      Height = 17
      Margins.Left = 0
      Align = alTop
      Caption = 'Use IE settings'
      TabOrder = 1
      OnClick = rbIEClick
      ExplicitWidth = 387
    end
    object rbNone: TTntRadioButton
      AlignWithMargins = True
      Left = 0
      Top = 43
      Width = 385
      Height = 17
      Margins.Left = 0
      Align = alTop
      Caption = 'No HTTP proxy'
      TabOrder = 2
      ExplicitWidth = 387
    end
    object rbCustom: TTntRadioButton
      AlignWithMargins = True
      Left = 0
      Top = 66
      Width = 385
      Height = 17
      Margins.Left = 0
      Align = alTop
      Caption = 'Custom proxy'
      TabOrder = 3
      ExplicitWidth = 387
    end
    object pnlProxyInfo: TExBrandPanel
      AlignWithMargins = True
      Left = 6
      Top = 95
      Width = 379
      Height = 54
      Margins.Left = 6
      Margins.Top = 9
      Align = alTop
      AutoSize = True
      TabOrder = 4
      TabStop = True
      AutoHide = True
      ExplicitWidth = 381
      object lblProxyHost: TTntLabel
        Left = 0
        Top = 3
        Width = 64
        Height = 16
        Caption = 'Proxy host:'
        Transparent = False
      end
      object lblProxyPort: TTntLabel
        Left = 0
        Top = 33
        Width = 63
        Height = 16
        Caption = 'Proxy port:'
        Transparent = True
      end
      object txtProxyHost: TTntEdit
        Left = 70
        Top = 0
        Width = 184
        Height = 24
        TabOrder = 0
      end
      object txtProxyPort: TTntEdit
        Left = 72
        Top = 30
        Width = 53
        Height = 24
        TabOrder = 1
      end
    end
    object pnlAuthInfo: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 161
      Width = 385
      Height = 79
      Margins.Left = 0
      Margins.Top = 9
      Align = alTop
      AutoSize = True
      TabOrder = 5
      TabStop = True
      AutoHide = True
      ExplicitWidth = 387
      object lblProxyUsername: TTntLabel
        Left = 27
        Top = 28
        Width = 67
        Height = 16
        Caption = 'User name:'
        Transparent = False
      end
      object lblProxyPassword: TTntLabel
        Left = 27
        Top = 58
        Width = 60
        Height = 16
        Caption = 'Password:'
        Transparent = False
      end
      object chkProxyAuth: TTntCheckBox
        Left = 6
        Top = 0
        Width = 214
        Height = 21
        Caption = 'Authentication requested'
        Enabled = False
        TabOrder = 0
        OnClick = chkProxyAuthClick
      end
      object txtProxyUsername: TTntEdit
        Left = 100
        Top = 25
        Width = 160
        Height = 24
        TabOrder = 1
      end
      object txtProxyPassword: TTntEdit
        Left = 100
        Top = 55
        Width = 160
        Height = 24
        PasswordChar = '*'
        TabOrder = 2
      end
    end
  end
end
