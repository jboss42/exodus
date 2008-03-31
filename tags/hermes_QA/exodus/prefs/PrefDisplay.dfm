inherited frmPrefDisplay: TfrmPrefDisplay
  Left = 400
  Top = 120
  Caption = 'frmPrefFont'
  ClientHeight = 873
  ClientWidth = 514
  OldCreateOrder = True
  Position = poDesigned
  ShowHint = True
  OnClose = FormClose
  ExplicitWidth = 526
  ExplicitHeight = 885
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Width = 514
    ExplicitWidth = 514
    inherited lblHeader: TTntLabel
      Width = 56
      Caption = 'Display'
      ExplicitLeft = 6
      ExplicitWidth = 56
    end
  end
  object TntScrollBox1: TTntScrollBox
    Left = 0
    Top = 28
    Width = 514
    Height = 845
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 1
    object pnlContainer: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 490
      Height = 630
      Margins.Left = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      AutoHide = True
      object gbContactList: TExGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 3
        Width = 490
        Height = 200
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
          Top = 30
          Width = 103
          Height = 16
          Margins.Left = 0
          Caption = '&Background color:'
          FocusControl = cbRosterBG
        end
        object lblRosterFG: TTntLabel
          Left = 4
          Top = 94
          Width = 62
          Height = 16
          Margins.Left = 0
          Caption = '&Font color:'
          FocusControl = cbRosterFont
        end
        object lblRosterPreview: TTntLabel
          Left = 210
          Top = 30
          Width = 50
          Height = 16
          Caption = '&Preview:'
          FocusControl = colorRoster
        end
        object cbRosterBG: TColorBox
          Left = 4
          Top = 53
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
          Top = 122
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
          Top = 162
          Width = 85
          Height = 28
          Margins.Left = 0
          Caption = 'F&ont...'
          TabOrder = 3
          OnClick = btnRosterFontClick
        end
        object colorRoster: TTntTreeView
          Left = 210
          Top = 57
          Width = 220
          Height = 105
          BevelWidth = 10
          Indent = 19
          ReadOnly = True
          ShowButtons = False
          ShowLines = False
          TabOrder = 4
        end
        object btnManageTabs: TTntButton
          AlignWithMargins = True
          Left = 210
          Top = 169
          Width = 101
          Height = 28
          Margins.Left = 0
          Caption = '&Manage tabs...'
          TabOrder = 5
          OnClick = btnManageTabsClick
        end
      end
      object gbActivityWindow: TExGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 206
        Width = 490
        Height = 241
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
        ExplicitTop = 203
        object lblChatPreview: TTntLabel
          Left = 210
          Top = 26
          Width = 50
          Height = 16
          Caption = 'Pre&view:'
          FocusControl = colorChat
        end
        object Label5: TTntLabel
          Left = 213
          Top = 178
          Width = 362
          Height = 18
          Caption = 'Elements can also be directly selected from the preview'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lblChatWindowElement: TTntLabel
          Left = 4
          Top = 26
          Width = 154
          Height = 16
          Margins.Left = 0
          Caption = 'Choose &element to format:'
          FocusControl = cboChatElement
        end
        object lblChatFG: TTntLabel
          Left = 18
          Top = 90
          Width = 62
          Height = 16
          Caption = 'Font &color:'
          FocusControl = cbChatFont
        end
        object lblChatBG: TTntLabel
          Left = 4
          Top = 194
          Width = 103
          Height = 16
          Margins.Left = 0
          Caption = 'B&ackground color:'
          FocusControl = cbChatBG
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
        object cboChatElement: TTntComboBox
          Left = 4
          Top = 50
          Width = 189
          Height = 24
          Margins.Left = 0
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 2
          OnChange = cboChatElementChange
        end
        object btnChatFont: TTntButton
          AlignWithMargins = True
          Left = 18
          Top = 159
          Width = 83
          Height = 24
          Caption = 'Fo&nt...'
          TabOrder = 3
          OnClick = btnFontClick
        end
        object cbChatFont: TColorBox
          Left = 18
          Top = 117
          Width = 175
          Height = 22
          DefaultColorColor = clBlue
          Selected = clBlue
          Style = [cbStandardColors, cbExtendedColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
          DropDownCount = 12
          ItemHeight = 16
          TabOrder = 4
          OnChange = cbChatFontChange
        end
        object cbChatBG: TColorBox
          Left = 4
          Top = 219
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
          TabOrder = 5
          OnChange = cbChatBGChange
        end
      end
      object gbOtherPrefs: TExGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 453
        Width = 487
        Height = 177
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
        ExplicitTop = 450
        ExplicitHeight = 175
        object chkRTEnabled: TTntCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 18
          Width = 481
          Height = 26
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
          Top = 127
          Width = 481
          Height = 50
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 4
          AutoHide = True
          ExplicitTop = 125
          object lblTimestampFmt: TTntLabel
            Left = 32
            Top = 31
            Width = 46
            Height = 16
            Caption = 'Forma&t:'
            FocusControl = txtTimestampFmt
          end
          object chkTimestamp: TTntCheckBox
            Left = 0
            Top = 0
            Width = 481
            Height = 26
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
          Top = 101
          Width = 481
          Height = 26
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Show &message priority in chat windows'
          TabOrder = 3
          ExplicitTop = 99
        end
        object chkChatAvatars: TTntCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 44
          Width = 481
          Height = 26
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = '&Show avatars in chat windows'
          TabOrder = 1
        end
        object pnlEmoticons: TExBrandPanel
          AlignWithMargins = True
          Left = 3
          Top = 70
          Width = 481
          Height = 31
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
            Height = 23
            Margins.Left = 0
            Caption = 'Auto &detect emoticons'
            TabOrder = 0
            OnClick = chkEmoticonsClick
          end
          object btnEmoSettings: TTntButton
            Left = 209
            Top = 1
            Width = 96
            Height = 30
            Caption = 'Settings...'
            TabOrder = 1
            OnClick = btnEmoSettingsClick
          end
        end
      end
    end
    object gbAdvancedPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 639
      Width = 490
      Height = 401
      Margins.Left = 0
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'Advanced display preferences:'
      ParentColor = True
      TabOrder = 1
      AutoHide = True
      ExplicitTop = 638
      object pnlAdvancedLeft: TExBrandPanel
        AlignWithMargins = True
        Left = 3
        Top = 81
        Width = 422
        Height = 317
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        AutoHide = True
        ExplicitTop = 87
        ExplicitHeight = 311
        object gbRTIncludes: TExGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 419
          Height = 96
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
            Width = 416
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
            Width = 416
            Height = 19
            Margins.Left = 0
            Align = alTop
            Caption = 'Different si&zed text'
            TabOrder = 1
            OnClick = chkAllowFontFamilyClick
          end
          object chkAllowFontColor: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 72
            Width = 416
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
          Top = 102
          Width = 419
          Height = 187
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
            Width = 419
            Height = 24
            Align = alTop
            Caption = 'Warn when trying to close busy chat windows'
            TabOrder = 1
          end
          object chkEscClose: TTntCheckBox
            Left = 0
            Top = 42
            Width = 419
            Height = 22
            Align = alTop
            Caption = 'Use ESC key to close chat windows'
            TabOrder = 2
          end
          object pnlChatHotkey: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 67
            Width = 416
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
            Width = 416
            Height = 50
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
              Width = 416
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
              Height = 25
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
              Top = 18
              Width = 76
              Height = 38
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              Text = '60'
              Min = 0
              Max = 360
              OnChange = txtChatMemoryChange
              DesignSize = (
                76
                38)
            end
          end
        end
      end
      object pnlSnapTo: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 21
        Width = 487
        Height = 57
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
          Top = 30
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
          Left = 217
          Top = 25
          Width = 75
          Height = 38
          BevelOuter = bvNone
          Enabled = False
          ParentColor = True
          TabOrder = 0
          Text = '15'
          Min = 10
          Max = 120
          OnChange = txtSnapChange
          DesignSize = (
            75
            38)
        end
      end
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
