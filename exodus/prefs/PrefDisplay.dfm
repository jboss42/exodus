inherited frmPrefDisplay: TfrmPrefDisplay
  Left = 400
  Top = 120
  Caption = 'frmPrefFont'
  ClientHeight = 709
  ClientWidth = 418
  OldCreateOrder = True
  Position = poDesigned
  ShowHint = True
  OnClose = FormClose
  ExplicitWidth = 526
  ExplicitHeight = 884
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlHeader: TTntPanel
    Width = 418
    ExplicitWidth = 418
    inherited lblHeader: TTntLabel
      Left = 5
      Width = 43
      Caption = 'Display'
      ExplicitLeft = 5
      ExplicitWidth = 43
    end
  end
  object TntScrollBox1: TTntScrollBox
    Left = 0
    Top = 23
    Width = 418
    Height = 686
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 1
    object pnlContainer: TExBrandPanel
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 398
      Height = 517
      Margins.Left = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      AutoHide = True
      ExplicitTop = 2
      ExplicitWidth = 401
      ExplicitHeight = 511
      object gbContactList: TExGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 3
        Width = 398
        Height = 161
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
        ExplicitWidth = 401
        object lblRosterBG: TTntLabel
          Left = 3
          Top = 24
          Width = 86
          Height = 13
          Margins.Left = 0
          Caption = '&Background color:'
          FocusControl = cbRosterBG
        end
        object lblRosterFG: TTntLabel
          Left = 3
          Top = 76
          Width = 52
          Height = 13
          Margins.Left = 0
          Caption = '&Font color:'
          FocusControl = cbRosterFont
        end
        object lblRosterPreview: TTntLabel
          Left = 171
          Top = 24
          Width = 42
          Height = 13
          Caption = '&Preview:'
          FocusControl = colorRoster
        end
        object cbRosterBG: TColorBox
          Left = 3
          Top = 43
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
          Top = 99
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
          Top = 132
          Width = 69
          Height = 22
          Margins.Left = 0
          Caption = 'F&ont...'
          TabOrder = 3
          OnClick = btnRosterFontClick
        end
        object colorRoster: TTntTreeView
          Left = 171
          Top = 46
          Width = 178
          Height = 86
          BevelWidth = 10
          Indent = 19
          ReadOnly = True
          ShowButtons = False
          ShowLines = False
          TabOrder = 4
        end
        object btnManageTabs: TTntButton
          AlignWithMargins = True
          Left = 171
          Top = 137
          Width = 82
          Height = 21
          Margins.Left = 0
          Caption = '&Manage Tabs...'
          TabOrder = 5
          OnClick = btnManageTabsClick
        end
      end
      object gbActivityWindow: TExGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 167
        Width = 398
        Height = 200
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
        ExplicitTop = 166
        ExplicitWidth = 401
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
          Width = 307
          Height = 14
          Caption = 'Elements can also be directly selected from the preview'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lblChatWindowElement: TTntLabel
          Left = 3
          Top = 21
          Width = 129
          Height = 13
          Margins.Left = 0
          Caption = 'Choose &element to format:'
          FocusControl = cboChatElement
        end
        object lblChatFG: TTntLabel
          Left = 15
          Top = 73
          Width = 52
          Height = 13
          Caption = 'Font &color:'
          FocusControl = cbChatFont
        end
        object lblChatBG: TTntLabel
          Left = 3
          Top = 158
          Width = 86
          Height = 13
          Margins.Left = 0
          Caption = 'B&ackground color:'
          FocusControl = cbChatBG
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
        object cboChatElement: TTntComboBox
          Left = 3
          Top = 41
          Width = 154
          Height = 24
          Margins.Left = 0
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 2
          OnChange = cboChatElementChange
        end
        object btnChatFont: TTntButton
          AlignWithMargins = True
          Left = 15
          Top = 129
          Width = 67
          Height = 20
          Caption = 'Fo&nt...'
          TabOrder = 3
          OnClick = btnFontClick
        end
        object cbChatFont: TColorBox
          Left = 15
          Top = 95
          Width = 142
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
          Left = 3
          Top = 178
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
          TabOrder = 5
          OnChange = cbChatBGChange
        end
      end
      object gbOtherPrefs: TExGroupBox
        AlignWithMargins = True
        Left = 0
        Top = 373
        Width = 395
        Height = 144
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
        ExplicitTop = 367
        ExplicitWidth = 399
        object chkRTEnabled: TTntCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 15
          Width = 389
          Height = 21
          Hint = 'Send and display messages with different fonts, colors etc.'
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Enable &rich text formatting'
          TabOrder = 0
          OnClick = chkRTEnabledClick
          ExplicitLeft = 2
          ExplicitWidth = 395
        end
        object pnlTimeStamp: TExBrandPanel
          AlignWithMargins = True
          Left = 3
          Top = 102
          Width = 389
          Height = 42
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 4
          AutoHide = True
          ExplicitLeft = 2
          ExplicitWidth = 395
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
            Width = 389
            Height = 21
            Margins.Top = 0
            Margins.Bottom = 0
            Align = alTop
            Caption = 'Show timestamp &with messages'
            TabOrder = 0
            ExplicitWidth = 394
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
          Top = 81
          Width = 389
          Height = 21
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Show &message priority in chat windows'
          TabOrder = 3
          ExplicitLeft = 2
          ExplicitWidth = 395
        end
        object chkChatAvatars: TTntCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 36
          Width = 389
          Height = 21
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = '&Show avatars in chat windows'
          TabOrder = 1
          ExplicitLeft = 2
          ExplicitWidth = 395
        end
        object pnlEmoticons: TExBrandPanel
          AlignWithMargins = True
          Left = 3
          Top = 57
          Width = 389
          Height = 24
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
          AutoHide = True
          ExplicitLeft = 2
          ExplicitWidth = 395
          object chkEmoticons: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 2
            Width = 164
            Height = 18
            Margins.Left = 0
            Caption = 'Auto &detect emoticons'
            TabOrder = 0
            OnClick = chkEmoticonsClick
          end
          object btnEmoSettings: TTntButton
            Left = 170
            Top = 0
            Width = 78
            Height = 24
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
      Top = 526
      Width = 398
      Height = 326
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
      ExplicitTop = 515
      ExplicitWidth = 401
      object pnlAdvancedLeft: TExBrandPanel
        AlignWithMargins = True
        Left = 3
        Top = 72
        Width = 343
        Height = 251
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        AutoHide = True
        ExplicitLeft = 2
        ExplicitTop = 71
        ExplicitHeight = 252
        object gbRTIncludes: TExGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 340
          Height = 79
          Margins.Left = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'Messages may include:'
          ParentColor = True
          TabOrder = 0
          AutoHide = True
          ExplicitTop = 2
          object chkAllowFontFamily: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 17
            Width = 337
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
            Top = 38
            Width = 337
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
            Top = 59
            Width = 337
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
          Top = 85
          Width = 340
          Height = 156
          Margins.Left = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          Caption = 'Chat Preferences'
          ParentColor = True
          TabOrder = 1
          AutoHide = True
          ExplicitTop = 84
          ExplicitHeight = 153
          object chkBusy: TTntCheckBox
            Left = 0
            Top = 15
            Width = 340
            Height = 19
            Align = alTop
            Caption = 'Warn when trying to close busy chat windows'
            TabOrder = 1
          end
          object chkEscClose: TTntCheckBox
            Left = 0
            Top = 34
            Width = 340
            Height = 18
            Align = alTop
            Caption = 'Use ESC key to close chat windows'
            TabOrder = 2
          end
          object pnlChatHotkey: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 55
            Width = 337
            Height = 41
            Margins.Left = 0
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 3
            AutoHide = True
            ExplicitTop = 54
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
            Top = 108
            Width = 337
            Height = 45
            Margins.Left = 0
            Margins.Top = 9
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 4
            AutoHide = True
            ExplicitTop = 105
            object lblMem1: TTntLabel
              Left = 0
              Top = 0
              Width = 317
              Height = 13
              Align = alTop
              Caption = 
                'Minutes to keep displayed chat history (0 to destroy immediately' +
                '):'
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
            end
          end
        end
      end
      object pnlSnapTo: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 18
        Width = 395
        Height = 51
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        AutoHide = True
        ExplicitTop = 17
        ExplicitWidth = 399
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
          Height = 26
          BevelOuter = bvNone
          Enabled = False
          ParentColor = True
          TabOrder = 0
          Text = '15'
          Min = 10
          Max = 120
          OnChange = txtSnapChange
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
