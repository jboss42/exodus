inherited frmPrefTransfer: TfrmPrefTransfer
  Left = 249
  Top = 172
  Caption = 'frmPrefTransfer'
  ClientHeight = 343
  ClientWidth = 318
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label15: TTntLabel
    Left = 0
    Top = 35
    Width = 149
    Height = 13
    Caption = 'File transfer download directory:'
  end
  object Label2: TTntLabel
    Left = 0
    Top = 320
    Width = 184
    Height = 13
    Cursor = crHandPoint
    Caption = 'Reset all file transfer options to defaults'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label2Click
  end
  object grpWebDav: TGroupBox
    Left = 16
    Top = 130
    Width = 281
    Height = 178
    TabOrder = 5
    object Label3: TTntLabel
      Left = 8
      Top = 16
      Width = 51
      Height = 13
      Caption = 'Web Host:'
    end
    object Label4: TTntLabel
      Left = 8
      Top = 56
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object Label5: TTntLabel
      Left = 8
      Top = 80
      Width = 51
      Height = 13
      Caption = 'Web Path:'
    end
    object Label6: TTntLabel
      Left = 85
      Top = 99
      Width = 131
      Height = 13
      Caption = 'Example: /~foo/public_html'
    end
    object Label7: TTntLabel
      Left = 8
      Top = 128
      Width = 51
      Height = 13
      Caption = 'Username:'
    end
    object Label8: TTntLabel
      Left = 8
      Top = 152
      Width = 49
      Height = 13
      Caption = 'Password:'
    end
    object Label9: TTntLabel
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
  object optPeer: TTntRadioButton
    Left = 0
    Top = 88
    Width = 281
    Height = 17
    Caption = 'Send files directly from my machine to the recipient'
    Checked = True
    TabOrder = 2
    TabStop = True
    OnClick = optWebDavClick
  end
  object grpPeer: TGroupBox
    Left = 16
    Top = 130
    Width = 281
    Height = 113
    TabOrder = 3
    object Label1: TTntLabel
      Left = 16
      Top = 19
      Width = 160
      Height = 13
      Caption = 'Port to use for HTTP file transfers:'
    end
    object txtPort: TTntEdit
      Left = 37
      Top = 36
      Width = 140
      Height = 21
      TabOrder = 0
    end
    object chkIP: TTntCheckBox
      Left = 16
      Top = 64
      Width = 249
      Height = 17
      Caption = 'Use a custom IP address for HTTP transfers'
      TabOrder = 1
      OnClick = chkIPClick
    end
    object txtIP: TTntEdit
      Left = 37
      Top = 84
      Width = 140
      Height = 21
      TabOrder = 2
    end
  end
  object optWebDav: TTntRadioButton
    Left = 0
    Top = 110
    Width = 281
    Height = 17
    Caption = 'Use a Web server to host the files which I send'
    TabOrder = 4
    OnClick = optWebDavClick
  end
  object StaticText4: TTntPanel
    Left = 0
    Top = 0
    Width = 318
    Height = 24
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'File Transfer Options'
    Color = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 6
  end
end
