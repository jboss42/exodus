inherited frmPrefAway: TfrmPrefAway
  Left = 252
  Top = 255
  Caption = 'frmPrefAway'
  ClientHeight = 604
  ClientWidth = 496
  OldCreateOrder = True
  ExplicitWidth = 508
  ExplicitHeight = 616
  PixelsPerInch = 120
  TextHeight = 16
  object pnlContainer: TExBrandPanel [0]
    Left = 0
    Top = 27
    Width = 367
    Height = 577
    Align = alLeft
    TabOrder = 1
    TabStop = True
    AutoHide = False
    object chkAutoAway: TExCheckGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 6
      Width = 367
      Height = 123
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      TabOrder = 0
      TabStop = True
      AutoHide = True
      Caption = 'Enable Auto Away'
      Checked = False
      OnCheckChanged = chkAutoAwayCheckChanged
      object pnlAwayTime: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 20
        Width = 364
        Height = 29
        Margins.Left = 0
        Margins.Bottom = 0
        Align = alTop
        TabOrder = 1
        TabStop = True
        AutoHide = False
        object lblAwayTime: TTntLabel
          AlignWithMargins = True
          Left = 21
          Top = 4
          Width = 277
          Height = 22
          Margins.Left = 20
          AutoSize = False
          Caption = 'Minutes to wait before setting status to Away:'
        end
        object txtAwayTime: TExNumericEdit
          Left = 303
          Top = 0
          Width = 61
          Height = 29
          Align = alRight
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          Text = '5'
          Min = 1
          Max = 600
          DesignSize = (
            61
            29)
        end
      end
      object chkAAReducePri: TTntCheckBox
        AlignWithMargins = True
        Left = 21
        Top = 49
        Width = 343
        Height = 22
        Margins.Left = 21
        Margins.Top = 0
        Align = alTop
        Caption = 'Reduce priority to 0 when Away'
        TabOrder = 2
      end
      object chkAwayAutoResponse: TTntCheckBox
        AlignWithMargins = True
        Left = 21
        Top = 74
        Width = 343
        Height = 22
        Margins.Left = 21
        Margins.Top = 0
        Align = alTop
        Caption = 'Send auto response message when away'
        TabOrder = 3
      end
      object ExBrandPanel2: TExBrandPanel
        Left = 0
        Top = 99
        Width = 367
        Height = 24
        Align = alTop
        AutoSize = True
        TabOrder = 4
        TabStop = True
        AutoHide = True
        object lblAwayStatus: TTntLabel
          Left = 21
          Top = 3
          Width = 99
          Height = 16
          Caption = 'Away status text:'
        end
        object txtAway: TTntEdit
          Left = 182
          Top = 0
          Width = 182
          Height = 24
          TabOrder = 0
        end
      end
    end
    object chkAutoXA: TExCheckGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 141
      Width = 367
      Height = 75
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      TabOrder = 1
      TabStop = True
      AutoHide = True
      Caption = 'Enable Auto Extended Away'
      Checked = False
      object ExBrandPanel3: TExBrandPanel
        AlignWithMargins = True
        Left = 3
        Top = 17
        Width = 361
        Height = 31
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        TabOrder = 1
        TabStop = True
        AutoHide = True
        object lblXATime: TTntLabel
          Left = 18
          Top = 5
          Width = 248
          Height = 16
          Caption = 'Minutes to wait before setting status to XA:'
        end
        object txtXATime: TExNumericEdit
          Left = 300
          Top = 0
          Width = 61
          Height = 31
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          Text = '30'
          Min = 1
          Max = 600
          DesignSize = (
            61
            31)
        end
      end
      object ExBrandPanel4: TExBrandPanel
        AlignWithMargins = True
        Left = 3
        Top = 48
        Width = 361
        Height = 24
        Margins.Top = 0
        Align = alTop
        AutoSize = True
        TabOrder = 2
        TabStop = True
        AutoHide = True
        object lblXAStatus: TTntLabel
          Left = 18
          Top = 3
          Width = 155
          Height = 16
          Caption = 'Extended Away status text:'
        end
        object txtXA: TTntEdit
          Left = 179
          Top = 0
          Width = 182
          Height = 24
          TabOrder = 0
        end
      end
    end
    object chkAutoDisconnect: TExCheckGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 228
      Width = 367
      Height = 51
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      AutoSize = True
      TabOrder = 2
      TabStop = True
      AutoHide = True
      Caption = 'Enable Auto Disconnect'
      Checked = False
      object lblDisconnectTime: TTntLabel
        Left = 21
        Top = 25
        Width = 214
        Height = 16
        Caption = 'Minutes to wait before disconnecting:'
      end
      object txtDisconnectTime: TExNumericEdit
        Left = 303
        Top = 20
        Width = 61
        Height = 31
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        Text = '60'
        Min = 1
        Max = 600
        DesignSize = (
          61
          31)
      end
    end
  end
  inherited pnlHeader: TTntPanel
    Width = 496
    ExplicitWidth = 496
    inherited lblHeader: TTntLabel
      Width = 174
      Caption = 'Auto Away Preferences'
      ExplicitWidth = 174
    end
  end
end
