inherited frmPrefTransfer: TfrmPrefTransfer
  Left = 249
  Top = 172
  Caption = 'frmPrefTransfer'
  ClientHeight = 471
  ClientWidth = 441
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label15: TLabel
    Left = 0
    Top = 35
    Width = 149
    Height = 13
    Caption = 'File transfer download directory:'
  end
  object Label2: TLabel
    Left = 8
    Top = 448
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
  object StaticText7: TStaticText
    Left = 0
    Top = 0
    Width = 441
    Height = 20
    Align = alTop
    Alignment = taCenter
    Caption = 'File Transfer Options'
    Color = clHighlight
    Font.Charset = ANSI_CHARSET
    Font.Color = clCaptionText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    Transparent = False
  end
  object txtXFerPath: TEdit
    Left = 21
    Top = 51
    Width = 188
    Height = 21
    TabOrder = 1
  end
  object btnTransferBrowse: TButton
    Left = 214
    Top = 49
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 2
    OnClick = btnTransferBrowseClick
  end
  object optPeer: TRadioButton
    Left = 0
    Top = 88
    Width = 281
    Height = 17
    Caption = 'Send files directly from my machine to the recipient'
    Checked = True
    TabOrder = 3
    TabStop = True
    OnClick = optWebDavClick
  end
  object grpPeer: TGroupBox
    Left = 16
    Top = 104
    Width = 281
    Height = 113
    TabOrder = 4
    object Label1: TLabel
      Left = 16
      Top = 19
      Width = 160
      Height = 13
      Caption = 'Port to use for HTTP file transfers:'
    end
    object txtPort: TEdit
      Left = 37
      Top = 36
      Width = 140
      Height = 21
      TabOrder = 0
    end
    object chkIP: TCheckBox
      Left = 16
      Top = 64
      Width = 249
      Height = 17
      Caption = 'Use a custom IP address for HTTP transfers'
      TabOrder = 1
      OnClick = chkIPClick
    end
    object txtIP: TEdit
      Left = 37
      Top = 84
      Width = 140
      Height = 21
      TabOrder = 2
    end
  end
  object optWebDav: TRadioButton
    Left = 0
    Top = 230
    Width = 281
    Height = 17
    Caption = 'Use a Web server to host the files which I send'
    TabOrder = 5
    OnClick = optWebDavClick
  end
  object grpWebDav: TGroupBox
    Left = 16
    Top = 248
    Width = 281
    Height = 177
    TabOrder = 6
    object Label3: TLabel
      Left = 8
      Top = 16
      Width = 51
      Height = 13
      Caption = 'Web Host:'
    end
    object Label4: TLabel
      Left = 8
      Top = 56
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object Label5: TLabel
      Left = 8
      Top = 80
      Width = 51
      Height = 13
      Caption = 'Web Path:'
    end
    object Label6: TLabel
      Left = 72
      Top = 99
      Width = 131
      Height = 13
      Caption = 'Example: /~foo/public_html'
    end
    object Label7: TLabel
      Left = 8
      Top = 128
      Width = 51
      Height = 13
      Caption = 'Username:'
    end
    object Label8: TLabel
      Left = 8
      Top = 152
      Width = 49
      Height = 13
      Caption = 'Password:'
    end
    object Label9: TLabel
      Left = 72
      Top = 35
      Width = 150
      Height = 13
      Caption = 'Example: http://dav.server.com'
    end
    object txtDavHost: TEdit
      Left = 72
      Top = 13
      Width = 193
      Height = 21
      TabOrder = 0
    end
    object txtDavPort: TEdit
      Left = 72
      Top = 53
      Width = 193
      Height = 21
      TabOrder = 1
    end
    object txtDavPath: TEdit
      Left = 72
      Top = 77
      Width = 193
      Height = 21
      TabOrder = 2
    end
    object txtDavUsername: TEdit
      Left = 72
      Top = 125
      Width = 193
      Height = 21
      TabOrder = 3
    end
    object txtDavPassword: TEdit
      Left = 72
      Top = 149
      Width = 193
      Height = 21
      PasswordChar = '*'
      TabOrder = 4
    end
  end
end
