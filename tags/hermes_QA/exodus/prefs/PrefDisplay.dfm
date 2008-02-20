inherited frmPrefDisplay: TfrmPrefDisplay
  Left = 400
  Top = 120
  ActiveControl = cbRosterFont
  Align = alLeft
  Caption = 'frmPrefFont'
  ClientHeight = 934
  ClientWidth = 514
  OldCreateOrder = True
  Position = poDesigned
  ShowHint = True
  OnClose = FormClose
  ExplicitWidth = 526
  ExplicitHeight = 946
  PixelsPerInch = 96
  TextHeight = 13
  object pnlContainer: TExBrandPanel [0]
    AlignWithMargins = True
    Left = 0
    Top = 29
    Width = 505
    Height = 905
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
      Width = 505
      Height = 154
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
        Left = 3
        Top = 21
        Width = 86
        Height = 13
        Margins.Left = 0
        Caption = '&Background color:'
        FocusControl = cbRosterBG
      end
      object lblRosterFG: TTntLabel
        Left = 3
        Top = 74
        Width = 52
        Height = 13
        Margins.Left = 0
        Caption = '&Font color:'
        FocusControl = cbRosterFont
      end
      object lblRosterPreview: TTntLabel
        Left = 171
        Top = 21
        Width = 42
        Height = 13
        Caption = '&Preview:'
        FocusControl = colorRoster
      end
      object cbRosterBG: TColorBox
        Left = 3
        Top = 41
        Width = 154
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
        Left = 3
        Top = 97
        Width = 154
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
        Left = 3
        Top = 130
        Width = 69
        Height = 21
        Margins.Left = 0
        Caption = 'F&ont...'
        TabOrder = 3
        OnClick = btnRosterFontClick
      end
      object colorRoster: TTntTreeView
        Left = 171
        Top = 44
        Width = 178
        Height = 85
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
      Top = 160
      Width = 505
      Height = 204
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
        Left = 171
        Top = 21
        Width = 42
        Height = 13
        Caption = 'Pre&view:'
        FocusControl = colorChat
      end
      object Label5: TTntLabel
        Left = 173
        Top = 145
        Width = 266
        Height = 13
        Caption = 'Elements can also be directly selected from the preview'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblChatBG: TTntLabel
        Left = 3
        Top = 21
        Width = 86
        Height = 13
        Margins.Left = 0
        Caption = 'B&ackground color:'
        FocusControl = cbChatBG
      end
      object lblChatWindowElement: TTntLabel
        Left = 3
        Top = 73
        Width = 129
        Height = 13
        Margins.Left = 0
        Caption = 'Choose &element to format:'
        FocusControl = cboChatElement
      end
      object lblChatFG: TTntLabel
        Left = 15
        Top = 125
        Width = 52
        Height = 13
        Caption = 'Font &color:'
        FocusControl = cbChatFont
      end
      object colorChat: TExRichEdit
        Left = 171
        Top = 41
        Width = 316
        Height = 98
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
        Left = 3
        Top = 41
        Width = 154
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
        Left = 3
        Top = 93
        Width = 154
        Height = 21
        Margins.Left = 0
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        OnChange = cboChatElementChange
      end
      object btnChatFont: TTntButton
        AlignWithMargins = True
        Left = 15
        Top = 181
        Width = 67
        Height = 20
        Caption = 'Fo&nt...'
        TabOrder = 4
        OnClick = btnFontClick
      end
      object cbChatFont: TColorBox
        Left = 15
        Top = 147
        Width = 142
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
      Top = 370
      Width = 502
      Height = 148
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
        Width = 496
        Height = 21
        Hint = 'Send and display messages with different fonts, colors etc.'
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Enable &rich text formatting'
        TabOrder = 0
        OnClick = chkRTEnabledClick
      end
      object pnlTimeStamp: TExBrandPanel
        AlignWithMargins = True
        Left = 3
        Top = 106
        Width = 496
        Height = 42
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 4
        AutoHide = True
        object lblTimestampFmt: TTntLabel
          Left = 26
          Top = 25
          Width = 38
          Height = 13
          Caption = 'Forma&t:'
          FocusControl = txtTimestampFmt
        end
        object chkTimestamp: TTntCheckBox
          Left = 0
          Top = 0
          Width = 496
          Height = 21
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Show timestamp &with messages'
          TabOrder = 0
        end
        object txtTimestampFmt: TTntComboBox
          Left = 77
          Top = 21
          Width = 177
          Height = 21
          ItemHeight = 13
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
        Top = 85
        Width = 496
        Height = 21
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Show &message priority in chat windows'
        TabOrder = 3
      end
      object chkChatAvatars: TTntCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 39
        Width = 496
        Height = 21
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Show avatars in chat windows'
        TabOrder = 1
      end
      object pnlEmoticons: TExBrandPanel
        AlignWithMargins = True
        Left = 3
        Top = 60
        Width = 496
        Height = 25
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
          Width = 164
          Height = 18
          Margins.Left = 0
          Caption = 'Auto &detect emoticons'
          TabOrder = 0
          OnClick = chkEmoticonsClick
        end
        object btnEmoSettings: TTntButton
          Left = 170
          Top = 1
          Width = 78
          Height = 24
          Caption = 'Settings...'
          TabOrder = 1
          OnClick = btnEmoSettingsClick
        end
      end
    end
    object gbAdvancedPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 524
      Width = 502
      Height = 381
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
      object pnlAdvancedLeft: TExBrandPanel
        AlignWithMargins = True
        Left = 3
        Top = 70
        Width = 342
        Height = 308
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        AutoHide = True
        object gbRTIncludes: TExGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 339
          Height = 85
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
            Width = 336
            Height = 16
            Margins.Left = 0
            Align = alTop
            Caption = 'Multip&le fonts'
            TabOrder = 0
            OnClick = chkAllowFontFamilyClick
          end
          object chkAllowFontSize: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 43
            Width = 336
            Height = 16
            Margins.Left = 0
            Align = alTop
            Caption = 'Different si&zed text'
            TabOrder = 1
            OnClick = chkAllowFontFamilyClick
          end
          object chkAllowFontColor: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 65
            Width = 336
            Height = 17
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
          Top = 91
          Width = 339
          Height = 155
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
            Width = 339
            Height = 19
            Align = alTop
            Caption = 'Warn when trying to close busy chat windows'
            TabOrder = 1
          end
          object chkEscClose: TTntCheckBox
            Left = 0
            Top = 37
            Width = 339
            Height = 18
            Align = alTop
            Caption = 'Use ESC key to close chat windows'
            TabOrder = 2
          end
          object pnlChatHotkey: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 58
            Width = 336
            Height = 41
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
              Width = 235
              Height = 13
              Caption = 'Use this hotkey sequence to close chat windows:'
            end
            object txtCloseHotkey: THotKey
              Left = 0
              Top = 20
              Width = 158
              Height = 21
              HotKey = 57431
              InvalidKeys = []
              Modifiers = [hkShift, hkCtrl, hkAlt]
              TabOrder = 0
            end
          end
          object pnlChatMemory: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 111
            Width = 336
            Height = 41
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
              Width = 336
              Height = 13
              Align = alTop
              Caption = 
                'Minutes to keep displayed chat history (0 to destroy immediately' +
                '):'
              ExplicitWidth = 317
            end
            object trkChatMemory: TTrackBar
              Left = -5
              Top = 20
              Width = 150
              Height = 21
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
              Left = 151
              Top = 15
              Width = 62
              Height = 25
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              Text = '60'
              Min = 0
              Max = 360
              OnChange = txtChatMemoryChange
              DesignSize = (
                62
                25)
            end
          end
        end
      end
      object pnlSnapTo: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 21
        Width = 499
        Height = 46
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        AutoHide = True
        object chkSnap: TTntCheckBox
          Left = 3
          Top = 0
          Width = 300
          Height = 19
          Caption = 'Make the main window snap to screen edges'
          TabOrder = 1
          OnClick = chkSnapClick
        end
        object trkSnap: TTrackBar
          Left = 20
          Top = 24
          Width = 150
          Height = 22
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
          Left = 176
          Top = 20
          Width = 61
          Height = 25
          BevelOuter = bvNone
          Enabled = False
          ParentColor = True
          TabOrder = 0
          Text = '15'
          Min = 10
          Max = 120
          OnChange = txtSnapChange
          DesignSize = (
            61
            25)
        end
      end
    end
  end
  inherited pnlHeader: TTntPanel
    Width = 514
    ExplicitWidth = 514
    inherited lblHeader: TTntLabel
      Width = 151
      Height = 17
      Caption = 'Display Preferences'
      ExplicitWidth = 151
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
