inherited frmPrefMsg: TfrmPrefMsg
  Left = 282
  Top = 230
  Caption = 'frmPrefMsg'
  ClientHeight = 604
  ClientWidth = 477
  OldCreateOrder = True
  ExplicitWidth = 489
  ExplicitHeight = 616
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Width = 477
    inherited lblHeader: TTntLabel
      Width = 160
      Caption = 'Message Preferences'
      ExplicitWidth = 160
    end
  end
  object pnlContainer: TExBrandPanel
    Left = 0
    Top = 27
    Width = 393
    Height = 577
    Align = alLeft
    TabOrder = 1
    AutoHide = True
    ExplicitHeight = 367
    object gbSubscriptions: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 390
      Height = 133
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      TabOrder = 0
      AutoHide = True
      Caption = 'Incoming subscription request handling:'
      object chkIncomingS10nAdd: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 109
        Width = 387
        Height = 21
        Margins.Left = 0
        Align = alTop
        Caption = 'Add &requestor to default contact list group when accepted'
        TabOrder = 2
        ExplicitTop = 118
      end
      object pnlS10NOpts: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 20
        Width = 387
        Height = 83
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        TabOrder = 1
        AutoHide = False
        object rbAcceptAll: TTntRadioButton
          AlignWithMargins = True
          Left = 0
          Top = 43
          Width = 384
          Height = 17
          Margins.Left = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Auto &accept all requests'
          TabOrder = 2
          TabStop = True
          ExplicitTop = 49
        end
        object rbAcceptContacts: TTntRadioButton
          AlignWithMargins = True
          Left = 0
          Top = 23
          Width = 384
          Height = 17
          Margins.Left = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Auto accept requests from &contacts in my contact list'
          TabOrder = 1
          TabStop = True
          ExplicitTop = 26
        end
        object rbDenyAll: TTntRadioButton
          AlignWithMargins = True
          Left = 0
          Top = 63
          Width = 384
          Height = 17
          Margins.Left = 0
          Align = alTop
          Caption = 'Auto &deny all requests'
          TabOrder = 3
          TabStop = True
          ExplicitTop = 72
        end
        object rbPromptAll: TTntRadioButton
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 384
          Height = 17
          Margins.Left = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = '&Prompt for all requests'
          TabOrder = 0
          TabStop = True
        end
      end
    end
    object pnlOtherPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 142
      Width = 390
      Height = 63
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      TabOrder = 1
      AutoHide = True
      Caption = 'Other message handling options:'
      ExplicitTop = 151
      object chkInviteAutoJoin: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 20
        Width = 387
        Height = 17
        Margins.Left = 0
        Align = alTop
        Caption = 'Automatically &join when receiving a conference invitation'
        TabOrder = 1
      end
      object chkBlockNonRoster: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 43
        Width = 387
        Height = 17
        Margins.Left = 0
        Align = alTop
        Caption = '&Block messages from people not on my contact list'
        TabOrder = 2
      end
    end
    object gbAdvancedPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 217
      Width = 390
      Height = 47
      Margins.Left = 0
      Margins.Top = 9
      Align = alTop
      AutoSize = True
      TabOrder = 2
      AutoHide = True
      Caption = 'Advanced message handling preferences'
      ExplicitTop = 226
      object btnManageKeywords: TTntButton
        Left = 3
        Top = 22
        Width = 161
        Height = 25
        Caption = 'Manage &Keywords...'
        TabOrder = 1
        OnClick = btnManageKeywordsClick
      end
    end
  end
end
