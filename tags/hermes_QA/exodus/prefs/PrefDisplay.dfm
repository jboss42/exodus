inherited frmPrefDisplay: TfrmPrefDisplay
  Left = 400
  Top = 120
  ActiveControl = cbRosterFont
  Align = alLeft
  Caption = 'frmPrefFont'
  ClientHeight = 987
  ClientWidth = 528
  OldCreateOrder = True
  Position = poDesigned
  ShowHint = True
  ExplicitWidth = 540
  ExplicitHeight = 999
  PixelsPerInch = 120
  TextHeight = 16
  object pnlContainer: TExBrandPanel [0]
    AlignWithMargins = True
    Left = 0
    Top = 30
    Width = 513
    Height = 957
    Margins.Left = 0
    Margins.Bottom = 0
    Align = alLeft
    AutoScroll = True
    AutoSize = True
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    TabStop = True
    AutoHide = True
    object gbContactList: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 513
      Height = 145
      Margins.Left = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      TabOrder = 0
      TabStop = True
      AutoHide = True
      Caption = 's'
      object pnlContactLeft: TExBrandPanel
        Left = 0
        Top = 17
        Width = 166
        Height = 128
        AutoSize = True
        Color = 13681583
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        TabStop = True
        AutoHide = True
        object pnlBackColor: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 163
          Height = 44
          Margins.Left = 0
          Margins.Top = 0
          Align = alTop
          AutoSize = True
          Color = 13681583
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          TabStop = True
          AutoHide = True
          object lblRosterBG: TTntLabel
            Left = 0
            Top = 0
            Width = 103
            Height = 16
            Margins.Left = 0
            Caption = '&Background color:'
            FocusControl = cbRosterBG
          end
          object cbRosterBG: TColorBox
            Left = 0
            Top = 22
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
            TabOrder = 0
            OnChange = cbRosterBGChange
          end
        end
        object pnlRosterFG: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 50
          Width = 163
          Height = 44
          Margins.Left = 0
          Align = alTop
          AutoSize = True
          TabOrder = 1
          TabStop = True
          AutoHide = True
          object lblRosterFG: TTntLabel
            Left = 0
            Top = 0
            Width = 62
            Height = 16
            Margins.Left = 0
            Caption = '&Font color:'
            FocusControl = cbRosterFont
          end
          object cbRosterFont: TColorBox
            Left = 0
            Top = 22
            Width = 154
            Height = 22
            Margins.Left = 0
            DefaultColorColor = clBlue
            Selected = clBlue
            Style = [cbStandardColors, cbExtendedColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
            DropDownCount = 12
            ItemHeight = 16
            TabOrder = 0
            OnChange = cbRosterFontChange
          end
        end
        object pnlContactFontBtn: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 97
          Width = 163
          Height = 28
          Margins.Left = 0
          Margins.Top = 0
          Align = alTop
          AutoSize = True
          TabOrder = 2
          TabStop = True
          AutoHide = True
          object btnRosterFont: TTntButton
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 68
            Height = 22
            Margins.Left = 0
            Caption = 'F&ont...'
            TabOrder = 0
            OnClick = btnRosterFontClick
          end
        end
      end
      object pnlContactRight: TExBrandPanel
        Left = 172
        Top = 17
        Width = 335
        Height = 131
        AutoSize = True
        TabOrder = 2
        TabStop = True
        AutoHide = True
        object pnlRosterPreview: TExBrandPanel
          AlignWithMargins = True
          Left = 3
          Top = 0
          Width = 329
          Height = 128
          Margins.Top = 0
          Align = alTop
          TabOrder = 0
          TabStop = True
          AutoHide = True
          object lblRosterPreview: TTntLabel
            Left = 14
            Top = 0
            Width = 50
            Height = 16
            Caption = '&Preview:'
            FocusControl = colorRoster
          end
          object colorRoster: TTntTreeView
            Left = 14
            Top = 22
            Width = 201
            Height = 100
            BevelWidth = 10
            Indent = 19
            ReadOnly = True
            ShowButtons = False
            ShowLines = False
            TabOrder = 0
          end
        end
      end
    end
    object grpActivityWindow: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 151
      Width = 513
      Height = 191
      Margins.Left = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      TabOrder = 1
      TabStop = True
      AutoHide = True
      Caption = 'Activity window:'
      object pnlActivityLeft: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 17
        Width = 169
        Height = 174
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alLeft
        AutoSize = True
        TabOrder = 1
        TabStop = True
        AutoHide = True
        object pnlChatBG: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 166
          Height = 42
          Margins.Left = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          Color = 13681583
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          TabStop = True
          AutoHide = True
          object lblChatBG: TTntLabel
            Left = 0
            Top = 0
            Width = 103
            Height = 16
            Margins.Left = 0
            Caption = 'B&ackground color:'
            FocusControl = cbChatBG
          end
          object cbChatBG: TColorBox
            Left = 0
            Top = 20
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
            TabOrder = 0
            OnChange = cbChatBGChange
          end
        end
        object pnlChatElement: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 48
          Width = 166
          Height = 46
          Margins.Left = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          TabOrder = 1
          TabStop = True
          AutoHide = True
          object lblChatWindowElement: TTntLabel
            Left = 0
            Top = 0
            Width = 154
            Height = 16
            Margins.Left = 0
            Caption = 'Choose &element to format:'
            FocusControl = cboChatElement
          end
          object cboChatElement: TTntComboBox
            Left = 0
            Top = 22
            Width = 154
            Height = 24
            Margins.Left = 0
            Style = csDropDownList
            ItemHeight = 16
            TabOrder = 0
            OnChange = cboChatElementChange
          end
        end
        object pnlChatFont: TExBrandPanel
          AlignWithMargins = True
          Left = 0
          Top = 97
          Width = 166
          Height = 75
          Margins.Left = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          TabOrder = 2
          TabStop = True
          AutoHide = True
          object pnlChatFG: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 163
            Height = 44
            Margins.Left = 0
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            TabOrder = 0
            TabStop = True
            AutoHide = True
            object lblChatFG: TTntLabel
              Left = 25
              Top = 0
              Width = 62
              Height = 16
              Caption = 'Font &color:'
              FocusControl = cbChatFont
            end
            object cbChatFont: TColorBox
              Left = 25
              Top = 22
              Width = 129
              Height = 22
              DefaultColorColor = clBlue
              Selected = clBlue
              Style = [cbStandardColors, cbExtendedColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
              DropDownCount = 12
              ItemHeight = 16
              TabOrder = 0
              OnChange = cbChatFontChange
            end
          end
          object pnlChatFontBtn: TExBrandPanel
            AlignWithMargins = True
            Left = 3
            Top = 53
            Width = 160
            Height = 22
            Margins.Top = 6
            Margins.Bottom = 0
            Align = alTop
            AutoSize = True
            TabOrder = 1
            TabStop = True
            AutoHide = True
            object btnChatFont: TTntButton
              Left = 25
              Top = 0
              Width = 68
              Height = 22
              Caption = 's'
              TabOrder = 0
              OnClick = btnFontClick
            end
          end
        end
      end
      object pnlChatPreview: TExBrandPanel
        AlignWithMargins = True
        Left = 172
        Top = 17
        Width = 328
        Height = 174
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alLeft
        TabOrder = 2
        TabStop = True
        AutoHide = True
        object lblChatPreview: TTntLabel
          Left = 17
          Top = 3
          Width = 50
          Height = 16
          Caption = 'Pre&view:'
          FocusControl = colorChat
        end
        object Label5: TTntLabel
          Left = 17
          Top = 142
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
        object colorChat: TExRichEdit
          Left = 17
          Top = 26
          Width = 312
          Height = 108
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
          TabOrder = 0
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
      end
    end
    object gbOtherPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 348
      Width = 510
      Height = 168
      Margins.Left = 0
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      TabOrder = 2
      TabStop = True
      AutoHide = True
      Caption = 'Other display preferences:'
      object chkRTEnabled: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 20
        Width = 507
        Height = 18
        Hint = 'Send and display messages with different fonts, colors etc.'
        Margins.Left = 0
        Align = alTop
        Caption = 'Enable &rich text formatting'
        TabOrder = 0
        OnClick = chkRTEnabledClick
      end
      object pnlTimeStamp: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 117
        Width = 507
        Height = 48
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        TabOrder = 4
        TabStop = True
        AutoHide = True
        object lblTimestampFmt: TTntLabel
          Left = 23
          Top = 27
          Width = 46
          Height = 16
          Caption = 'Forma&t:'
          FocusControl = txtTimestampFmt
        end
        object chkTimestamp: TTntCheckBox
          Left = 0
          Top = 0
          Width = 209
          Height = 18
          Caption = 'Show timestamp &with messages'
          TabOrder = 0
        end
        object txtTimestampFmt: TTntComboBox
          Left = 75
          Top = 24
          Width = 198
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
        Left = 0
        Top = 93
        Width = 507
        Height = 18
        Margins.Left = 0
        Align = alTop
        Caption = 'Show &message priority in chat windows'
        TabOrder = 3
      end
      object chkChatAvatars: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 44
        Width = 507
        Height = 18
        Margins.Left = 0
        Align = alTop
        Caption = '&Show avatars in chat windows'
        TabOrder = 1
      end
      object pnlEmoticons: TExBrandPanel
        Left = 0
        Top = 65
        Width = 510
        Height = 25
        Align = alTop
        AutoSize = True
        TabOrder = 2
        TabStop = True
        AutoHide = True
        object chkEmoticons: TTntCheckBox
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 160
          Height = 18
          Margins.Left = 0
          Caption = 'Auto &detect emoticons'
          TabOrder = 0
          OnClick = chkEmoticonsClick
        end
        object btnEmoSettings: TTntButton
          Left = 175
          Top = 0
          Width = 75
          Height = 25
          Caption = 'Settings...'
          TabOrder = 1
          OnClick = btnEmoSettingsClick
        end
      end
    end
    object gbAdvancedPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 522
      Width = 510
      Height = 346
      Margins.Left = 0
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      TabOrder = 3
      TabStop = True
      AutoHide = True
      Caption = 'Advanced display preferences:'
      object pnlAdvancedLeft: TExBrandPanel
        AlignWithMargins = True
        Left = 3
        Top = 76
        Width = 382
        Height = 267
        Align = alLeft
        AutoScroll = True
        AutoSize = True
        TabOrder = 1
        TabStop = True
        AutoHide = True
        object gbRTIncludes: TExGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 379
          Height = 89
          Margins.Left = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          TabOrder = 0
          TabStop = True
          AutoHide = True
          Caption = 'Messages may include:'
          object chkAllowFontFamily: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 20
            Width = 376
            Height = 18
            Margins.Left = 0
            Align = alTop
            Caption = 'Multip&le fonts'
            TabOrder = 0
            OnClick = chkAllowFontFamilyClick
          end
          object chkAllowFontSize: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 44
            Width = 376
            Height = 18
            Margins.Left = 0
            Align = alTop
            Caption = 'Different si&zed text'
            TabOrder = 1
            OnClick = chkAllowFontFamilyClick
          end
          object chkAllowFontColor: TTntCheckBox
            AlignWithMargins = True
            Left = 0
            Top = 68
            Width = 376
            Height = 18
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
          Top = 95
          Width = 379
          Height = 169
          Margins.Left = 0
          Align = alTop
          AutoSize = True
          TabOrder = 1
          TabStop = True
          AutoHide = True
          Caption = 'Chat Preferences'
          object chkBusy: TTntCheckBox
            Left = 0
            Top = 17
            Width = 379
            Height = 21
            Align = alTop
            Caption = 'Warn when trying to close busy chat windows'
            TabOrder = 1
          end
          object chkEscClose: TTntCheckBox
            Left = 0
            Top = 38
            Width = 379
            Height = 20
            Align = alTop
            Caption = 'Use ESC key to close chat windows'
            TabOrder = 2
          end
          object pnlChatHotkey: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 61
            Width = 376
            Height = 45
            Margins.Left = 0
            Align = alTop
            AutoSize = True
            TabOrder = 3
            TabStop = True
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
              Top = 22
              Width = 177
              Height = 23
              HotKey = 57431
              InvalidKeys = []
              Modifiers = [hkShift, hkCtrl, hkAlt]
              TabOrder = 0
            end
          end
          object pnlChatMemory: TExBrandPanel
            AlignWithMargins = True
            Left = 0
            Top = 118
            Width = 376
            Height = 48
            Margins.Left = 0
            Margins.Top = 9
            Align = alTop
            AutoSize = True
            TabOrder = 4
            TabStop = True
            AutoHide = True
            object lblMem1: TTntLabel
              Left = 0
              Top = 0
              Width = 376
              Height = 16
              Align = alTop
              Caption = 
                'Minutes to keep displayed chat history (0 to destroy immediately' +
                '):'
              ExplicitWidth = 377
            end
            object trkChatMemory: TTrackBar
              Left = -5
              Top = 22
              Width = 168
              Height = 24
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
              Left = 169
              Top = 17
              Width = 70
              Height = 31
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              Text = '60'
              Min = 0
              Max = 360
              OnChange = txtChatMemoryChange
              DesignSize = (
                70
                31)
            end
          end
        end
      end
      object pnlSnapTo: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 20
        Width = 507
        Height = 53
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        TabOrder = 2
        TabStop = True
        AutoHide = True
        object chkSnap: TTntCheckBox
          Left = 0
          Top = 0
          Width = 336
          Height = 21
          Caption = 'Make the main window snap to screen edges'
          TabOrder = 1
          OnClick = chkSnapClick
        end
        object trkSnap: TTrackBar
          Left = 23
          Top = 27
          Width = 168
          Height = 24
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
          Left = 197
          Top = 22
          Width = 70
          Height = 31
          BevelOuter = bvNone
          Enabled = False
          ParentColor = True
          TabOrder = 0
          Text = '15'
          Min = 10
          Max = 120
          OnChange = txtSnapChange
          DesignSize = (
            70
            31)
        end
      end
    end
  end
  inherited pnlHeader: TTntPanel
    Width = 528
    ExplicitWidth = 528
    inherited lblHeader: TTntLabel
      Width = 151
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
