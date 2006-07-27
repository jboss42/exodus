inherited frmPrefTransfer: TfrmPrefTransfer
  Left = 243
  Top = 168
  Caption = 'frmPrefTransfer'
  ClientHeight = 343
  ClientWidth = 318
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object lblXferPath: TTntLabel [0]
    Left = 0
    Top = 35
    Width = 149
    Height = 13
    Caption = 'File transfer download directory:'
  end
  object lblXferDefault: TTntLabel [1]
    Left = 0
    Top = 320
    Width = 184
    Height = 13
    Cursor = crHandPoint
    Caption = 'Reset all file transfer options to defaults'
    OnClick = lblXferDefaultClick
  end
  object lblXferMethod: TTntLabel [2]
    Left = 0
    Top = 83
    Width = 129
    Height = 13
    Caption = 'Send file using this method:'
  end
  inherited pnlHeader: TTntPanel
    Width = 318
    Caption = 'File Transfer Options'
    TabOrder = 6
  end
  object grpWebDav: TGroupBox
    Left = 8
    Top = 128
    Width = 281
    Height = 178
    TabOrder = 4
    Visible = False
    object lblDavHost: TTntLabel
      Left = 8
      Top = 16
      Width = 51
      Height = 13
      Caption = 'Web Host:'
    end
    object lblDavPort: TTntLabel
      Left = 8
      Top = 56
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object lblDavPath: TTntLabel
      Left = 8
      Top = 80
      Width = 51
      Height = 13
      Caption = 'Web Path:'
    end
    object lblDavPath2: TTntLabel
      Left = 85
      Top = 99
      Width = 131
      Height = 13
      Caption = 'Example: /~foo/public_html'
    end
    object lblDavUsername: TTntLabel
      Left = 8
      Top = 128
      Width = 51
      Height = 13
      Caption = 'Username:'
    end
    object lblDavPassword: TTntLabel
      Left = 8
      Top = 152
      Width = 49
      Height = 13
      Caption = 'Password:'
    end
    object lblDavHost2: TTntLabel
      Left = 85
      Top = 35
      Width = 150
      Height = 13
      Caption = 'Example: http://dav.server.com'
    end
    object txtDavHost: TTntEdit
      Left = 85
      Top = 13
      Width = 180
      Height = 21
      TabOrder = 0
    end
    object txtDavPort: TTntEdit
      Left = 85
      Top = 53
      Width = 180
      Height = 21
      TabOrder = 1
    end
    object txtDavPath: TTntEdit
      Left = 85
      Top = 77
      Width = 180
      Height = 21
      TabOrder = 2
    end
    object txtDavUsername: TTntEdit
      Left = 85
      Top = 125
      Width = 180
      Height = 21
      TabOrder = 3
    end
    object txtDavPassword: TTntEdit
      Left = 85
      Top = 149
      Width = 180
      Height = 21
      PasswordChar = '*'
      TabOrder = 4
    end
  end
  object txtXFerPath: TTntEdit
    Left = 21
    Top = 51
    Width = 188
    Height = 21
    TabOrder = 0
  end
  object btnTransferBrowse: TTntButton
    Left = 214
    Top = 49
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 1
    OnClick = btnTransferBrowseClick
  end
  object grpPeer: TGroupBox
    Left = 8
    Top = 128
    Width = 281
    Height = 113
    TabOrder = 3
    Visible = False
    object lblXferPort: TTntLabel
      Left = 9
      Top = 12
      Width = 160
      Height = 13
      Caption = 'Port to use for HTTP file transfers:'
    end
    object txtXferPort: TTntEdit
      Left = 30
      Top = 29
      Width = 140
      Height = 21
      TabOrder = 0
    end
    object chkXferIP: TTntCheckBox
      Left = 9
      Top = 57
      Width = 249
      Height = 17
      Caption = 'Use a custom IP address for HTTP transfers'
      TabOrder = 1
      OnClick = chkXferIPClick
    end
    object txtXferIP: TTntEdit
      Left = 30
      Top = 77
      Width = 140
      Height = 21
      TabOrder = 2
    end
  end
  object cboXferMode: TTntComboBox
    Left = 8
    Top = 99
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    OnChange = cboXferModeChange
    Items.WideStrings = (
      'Discover a file transfer component using my server.'
      'Always use a specific file transfer component.'
      'Send files directly from my machine to the recipient.'
      'Use a web server to host the files which I send.')
  end
  object grpProxy: TGroupBox
    Left = 8
    Top = 128
    Width = 281
    Height = 79
    TabOrder = 5
    object lbl65Proxy: TTntLabel
      Left = 8
      Top = 16
      Width = 183
      Height = 13
      Caption = 'Jabber Address of File Transfer Server:'
    end
    object txt65Proxy: TTntEdit
      Left = 8
      Top = 32
      Width = 257
      Height = 21
      TabOrder = 0
    end
  end
end
