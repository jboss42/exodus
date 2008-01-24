inherited frmPrefDisplay: TfrmPrefDisplay
  Left = 400
  Top = 120
  ActiveControl = cbRosterFont
  Align = alLeft
  Caption = 'frmPrefFont'
  ClientHeight = 1149
  ClientWidth = 633
  Font.Height = -13
  OldCreateOrder = True
  Position = poDesigned
  ShowHint = True
  ExplicitWidth = 645
  ExplicitHeight = 1161
  PixelsPerInch = 120
  TextHeight = 16
  object pnlContainer: TExBrandPanel [0]
    AlignWithMargins = True
    Left = 0
    Top = 31
    Width = 621
    Height = 1118
    Margins.Left = 0
    Margins.Bottom = 0
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    AutoHide = True
    object gbContactList: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 621
      Height = 193
      Margins.Left = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Contact list:'
      ParentColor = True
      TabOrder = 0
      AutoHide = True
      object lblRosterBG: TTntLabel
        Left = 4
        Top = 26
        Width = 103
        Height = 16
        Margins.Left = 0
        Caption = '&Background color:'
        FocusControl = cbRosterBG
      end
      object lblRosterFG: TTntLabel
        Left = 4
        Top = 95
        Width = 62
        Height = 16
        Margins.Left = 0
        Caption = '&Font color:'
        FocusControl = cbRosterFont
      end
      object lblRosterPreview: TTntLabel
        Left = 210
        Top = 26
        Width = 50
        Height = 16
        Caption = '&Preview:'
        FocusControl = colorRoster
      end
      object cbRosterBG: TColorBox
        Left = 4
        Top = 50
        Width = 189
        Height = 22
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        DefaultColorColor = clBlue
        Selected = clBlue
        Style = [cbStandardColors, cbExtendedColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        DropDownCount = 12
        ItemHeight = 16
        TabOrder = 1
        OnChange = cbRosterBGChange
      end
      object cbRosterFont: TColorBox
        Left = 4
        Top = 123
        Width = 189
        Height = 22
        Margins.Left = 0
        DefaultColorColor = clBlue
        Selected = clBlue
        Style = [cbStandardColors, cbExtendedColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        DropDownCount = 12
        ItemHeight = 16
        TabOrder = 2
        OnChange = cbRosterFontChange
      end
      object btnRosterFont: TTntButton
        AlignWithMargins = True
        Left = 4
        Top = 164
        Width = 84
        Height = 26
        Margins.Left = 0
        Caption = 'F&ont...'
        TabOrder = 3
        OnClick = btnRosterFontClick
      end
      object colorRoster: TTntTreeView
        Left = 210
        Top = 54
        Width = 220
        Height = 105
        BevelWidth = 10
        Indent = 19
        ReadOnly = True
        ShowButtons = False
        ShowLines = False
        TabOrder = 4
      end
    end
    object gbActivityWindow: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 199
      Width = 621
      Height = 259
      Margins.Left = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Activity window:'
      ParentColor = True
      TabOrder = 1
      AutoHide = True
      object lblChatPreview: TTntLabel
        Left = 210
        Top = 26
        Width = 50
        Height = 16
        Caption = 'Pre&view:'
        FocusControl = colorChat
      end
      object Label5: TTntLabel
        Left = 210
        Top = 177
        Width = 415
        Height = 21
        Caption = 'Elements can also be directly selected from the preview'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -17
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblChatBG: TTntLabel
        Left = 4
        Top = 26
        Width = 103
        Height = 16
        Margins.Left = 0
        Caption = 'B&ackground color:'
        FocusControl = cbChatBG
      end
      object lblChatWindowElement: TTntLabel
        Left = 4
        Top = 99
        Width = 154
        Height = 16
        Margins.Left = 0
        Caption = 'Choose &element to format:'
        FocusControl = cboChatElement
      end
      object lblChatFG: TTntLabel
        Left = 18
        Top = 162
        Width = 62
        Height = 16
        Caption = 'Font &color:'
        FocusControl = cbChatFont
      end
      object colorChat: TExRichEdit
        Left = 210
        Top = 50
        Width = 389
        Height = 121
        AutoURLDetect = adNone
        CustomURLs = <
          item
            Name = 'e-mail'
            Color = clWindowText
            Cursor = crDefault
            Underline = True
          end
          item
            Name = 'http'
            Color = clWindowText
            Cursor = crDefault
            Underline = True
          end
          item
            Name = 'file'
            Color = clWindowText
            Cursor = crDefault
            Underline = True
          end
          item
            Name = 'mailto'
            Color = clWindowText
            Cursor = crDefault
            Underline = True
          end
          item
            Name = 'ftp'
            Color = clWindowText
            Cursor = crDefault
            Underline = True
          end
          item
            Name = 'https'
            Color = clWindowText
            Cursor = crDefault
            Underline = True
          end
          item
            Name = 'gopher'
            Color = clWindowText
            Cursor = crDefault
            Underline = True
          end
          item
            Name = 'nntp'
            Color = clWindowText
            Cursor = crDefault
            Underline = True
          end
          item
            Name = 'prospero'
            Color = clWindowText
            Cursor = crDefault
            Underline = True
          end
          item
            Name = 'telnet'
            Color = clWindowText
            Cursor = crDefault
            Underline = True
          end
          item
            Name = 'news'
            Color = clWindowText
            Cursor = crDefault
            Underline = True
          end
          item
            Name = 'wais'
            Color = clWindowText
            Cursor = crDefault
            Underline = True
          end>
        LangOptions = [loAutoFont]
        Language = 1033
        ReadOnly = True
        ScrollBars = ssBoth
        ShowSelectionBar = False
        TabOrder = 1
        URLColor = clBlue
        URLCursor = crHandPoint
        WordWrap = False
        OnMouseDown = colorChatMouseDown
        InputFormat = ifRTF
        OutputFormat = ofRTF
        SelectedInOut = False
        PlainRTF = False
        UndoLimit = 0
        AllowInPlace = False
      end
      object cbChatBG: TColorBox
        Left = 4
        Top = 50
        Width = 189
        Height = 22
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        DefaultColorColor = clBlue
        Selected = clBlue
        Style = [cbStandardColors, cbExtendedColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        DropDownCount = 12
        ItemHeight = 16
        TabOrder = 2
        OnChange = cbChatBGChange
      end
      object cboChatElement: TTntComboBox
        Left = 4
        Top = 123
        Width = 189
        Height = 24
        Margins.Left = 0
        Style = csDropDownList
        ItemHeight = 16
        TabOrder = 3
        OnChange = cboChatElementChange
      end
      object btnChatFont: TTntButton
        AlignWithMargins = True
        Left = 18
        Top = 231
        Width = 83
        Height = 25
        Caption = 'Fo&nt...'
        TabOrder = 4
        OnClick = btnFontClick
      end
      object cbChatFont: TColorBox
        Left = 18
        Top = 190
        Width = 175
        Height = 22
        DefaultColorColor = clBlue
        Selected = clBlue
        Style = [cbStandardColors, cbExtendedColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        DropDownCount = 12
        ItemHeight = 16
        TabOrder = 5
        OnChange = cbChatFontChange
      end
    end
    object gbOtherPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 464
      Width = 618
      Height = 191
      Margins.Left = 0
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Other display preferences:'
      ParentColor = True
      TabOrder = 2
      AutoHide = True
      object chkRTEnabled: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 18
        Width = 612
        Height = 31
        Hint = 'Send and display messages with different fonts, colors etc.'
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Enable &rich text formatting'
        TabOrder = 0
        OnClick = chkRTEnabledClick
      end
      object pnlTimeStamp: TExBrandPanel
        Left = 0
        Top = 141
        Width = 618
        Height = 50
        Margins.Top = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        AutoHide = True
        object lblTimestampFmt: TTntLabel
          Left = 32
          Top = 31
          Width = 46
          Height = 16
          Caption = 'Forma&t:'
          FocusControl = txtTimestampFmt
        end
        object chkTimestamp: TTntCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 0
          Width = 612
          Height = 31
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Show timestamp &with messages'
          TabOrder = 0
        end
        object txtTimestampFmt: TTntComboBox
          Left = 95
          Top = 26
          Width = 218
          Height = 24
          ItemHeight = 16
          TabOrder = 1
          Text = 'h:mm am/pm'
          Items.Strings = (
            'm/d/y h:mm am/pm'
            'mm/dd/yy hh:mm:ss'
            'h:mm am/pm'
            'hh:mm:ss')
        end
      end
      object chkShowPriority: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 110
        Width = 612
        Height = 31
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Show &message priority in chat windows'
        TabOrder = 3
      end
      object chkChatAvatars: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 49
        Width = 612
        Height = 31
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Show avatars in chat windows'
        TabOrder = 1
      end
      object pnlEmoticons: TExBrandPanel
        AlignWithMargins = True
        Left = 3
        Top = 80
        Width = 612
        Height = 30
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        AutoHide = True
        object chkEmoticons: TTntCheckBox
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 202
          Height = 22
          Margins.Left = 0
          Caption = 'Auto &detect emoticons'
          TabOrder = 0
          OnClick = chkEmoticonsClick
        end
        object btnEmoSettings: TTntButton
          Left = 209
          Top = 0
          Width = 96
          Height = 30
          Caption = 'Settings...'
          TabOrder = 1
          OnClick = btnEmoSettingsClick
        end
      end
    end
    object gbAdvancedPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 661
      Width = 618
      Height = 468
      Margins.Left = 0
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Advanced display preferences:'
      ParentColor = True
      TabOrder = 3
      AutoHide = True
      ExplicitTop = 664
      object pnlAdvancedLeft: TExBrandPanel
        AlignWithMargins = True
        Left = 3
        Top = 94
        Width = 420
        Height = 371
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        AutoHide = True
        ExplicitTop = 85
        ExplicitHeight = 380
        object gbRTIncludes: TExGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 417
          Height = 97
          Margins.Left = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'Messages may include:'
          ParentColor = True
          TabOrder = 0
          AutoHide = True
          object chkAllowFontFamily: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 21
            Width = 414
            Height = 20
            Margins.Left = 0
            Align = alTop
            Caption = 'Multip&le fonts'
            TabOrder = 0
            OnClick = chkAllowFontFamilyClick
          end
          object chkAllowFontSize: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 47
            Width = 414
            Height = 20
            Margins.Left = 0
            Align = alTop
            Caption = 'Different si&zed text'
            TabOrder = 1
            OnClick = chkAllowFontFamilyClick
          end
          object chkAllowFontColor: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 73
            Width = 414
            Height = 21
            Margins.Left = 0
            Align = alTop
            Caption = 'Different colored te&xt'
            TabOrder = 2
            OnClick = chkAllowFontFamilyClick
          end
        end
        object gbChatOptions: TExGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 103
          Width = 417
          Height = 196
          Margins.Left = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'Chat Preferences'
          ParentColor = True
          TabOrder = 1
          AutoHide = True
          object chkBusy: TTntCheckBox
            Left = 0
            Top = 18
            Width = 417
            Height = 24
            Align = alTop
            Caption = 'Warn when trying to close busy chat windows'
            TabOrder = 1
          end
          object chkEscClose: TTntCheckBox
            Left = 0
            Top = 42
            Width = 417
            Height = 22
            Align = alTop
            Caption = 'Use ESC key to close chat windows'
            TabOrder = 2
          end
          object pnlChatHotkey: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 67
            Width = 414
            Height = 50
            Margins.Left = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 3
            AutoHide = True
            object lblClose: TTntLabel
              Left = 0
              Top = 0
              Width = 279
              Height = 16
              Caption = 'Use this hotkey sequence to close chat windows:'
            end
            object txtCloseHotkey: THotKey
              Left = 0
              Top = 25
              Width = 194
              Height = 25
              HotKey = 57431
              InvalidKeys = []
              Modifiers = [hkShift, hkCtrl, hkAlt]
              TabOrder = 0
            end
          end
          object pnlChatMemory: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 129
            Width = 414
            Height = 64
            Margins.Left = 0
            Margins.Top = 9
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 4
            AutoHide = True
            object lblMem1: TTntLabel
              Left = 0
              Top = 0
              Width = 414
              Height = 16
              Align = alTop
              Caption = 
                'Minutes to keep displayed chat history (0 to destroy immediately' +
                '):'
              ExplicitWidth = 377
            end
            object trkChatMemory: TTrackBar
              Left = -6
              Top = 25
              Width = 184
              Height = 26
              Max = 120
              PageSize = 15
              Frequency = 15
              Position = 60
              TabOrder = 1
              ThumbLength = 15
              TickStyle = tsNone
              OnChange = trkChatMemoryChange
            end
            object txtChatMemory: TExNumericEdit
              Left = 186
              Top = 19
              Width = 76
              Height = 45
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              Text = '60'
              Min = 0
              Max = 360
              OnChange = txtChatMemoryChange
              DesignSize = (
                76
                45)
            end
          end
        end
      end
      object pnlSnapTo: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 21
        Width = 615
        Height = 70
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        AutoHide = True
        object chkSnap: TTntCheckBox
          Left = 4
          Top = 0
          Width = 369
          Height = 23
          Caption = 'Make the main window snap to screen edges'
          TabOrder = 1
          OnClick = chkSnapClick
        end
        object trkSnap: TTrackBar
          Left = 25
          Top = 29
          Width = 184
          Height = 27
          Enabled = False
          Max = 120
          Min = 10
          PageSize = 15
          Frequency = 15
          Position = 15
          TabOrder = 2
          ThumbLength = 15
          TickStyle = tsNone
          OnChange = trkSnapChange
        end
        object txtSnap: TExNumericEdit
          Left = 216
          Top = 25
          Width = 76
          Height = 45
          BevelOuter = bvNone
          Enabled = False
          ParentColor = True
          TabOrder = 0
          Text = '15'
          Min = 10
          Max = 120
          OnChange = txtSnapChange
          DesignSize = (
            76
            45)
        end
      end
    end
  end
  inherited pnlHeader: TTntPanel
    Width = 633
    ExplicitTop = 2
    ExplicitWidth = 633
    inherited lblHeader: TTntLabel
      Left = 6
      Width = 169
      Height = 19
      Caption = 'Display Preferences'
      ExplicitWidth = 169
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = []
    Left = 453
    Top = 51
  end
end
