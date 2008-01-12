inherited frmPrefMsg: TfrmPrefMsg
  Left = 282
  Top = 230
  Caption = 'frmPrefMsg'
  ClientHeight = 463
  ClientWidth = 404
  OldCreateOrder = True
  ExplicitWidth = 416
  ExplicitHeight = 475
  PixelsPerInch = 120
  TextHeight = 16
  inherited pnlHeader: TTntPanel
    Width = 404
    ExplicitWidth = 404
    inherited lblHeader: TTntLabel
      Width = 230
      Caption = 'Message Handling Preferences'
      ExplicitWidth = 230
    end
  end
  object pnlContainer: TExBrandPanel
    Left = 0
    Top = 27
    Width = 393
    Height = 436
    Align = alLeft
    TabOrder = 1
    TabStop = True
    AutoHide = True
    object gbSubscriptions: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 390
      Height = 142
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      TabOrder = 0
      TabStop = True
      AutoHide = True
      Caption = 'Incoming subscription request handling:'
      object chkIncomingS10nAdd: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 118
        Width = 387
        Height = 21
        Margins.Left = 0
        Align = alTop
        Caption = 'Add requestor to default contact list group when accepted'
        TabOrder = 1
      end
      object pnlS10NOpts: TExBrandPanel
        AlignWithMargins = True
        Left = 0
        Top = 20
        Width = 387
        Height = 92
        Margins.Left = 0
        Align = alTop
        AutoSize = True
        TabOrder = 2
        TabStop = True
        AutoHide = False
        object rbAcceptAll: TTntRadioButton
          AlignWithMargins = True
          Left = 0
          Top = 49
          Width = 384
          Height = 17
          Margins.Left = 0
          Align = alTop
          Caption = 'Auto accept all requests'
          TabOrder = 0
        end
        object rbAcceptContacts: TTntRadioButton
          AlignWithMargins = True
          Left = 0
          Top = 26
          Width = 384
          Height = 17
          Margins.Left = 0
          Align = alTop
          Caption = 'Auto accept requests from contacts in my contact list'
          TabOrder = 1
        end
        object rbDenyAll: TTntRadioButton
          AlignWithMargins = True
          Left = 0
          Top = 72
          Width = 384
          Height = 17
          Margins.Left = 0
          Align = alTop
          Caption = 'Auto deny all requests'
          TabOrder = 2
        end
        object rbPromptAll: TTntRadioButton
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 384
          Height = 17
          Margins.Left = 0
          Align = alTop
          Caption = 'Prompt for all requests'
          TabOrder = 3
        end
      end
    end
    object pnlOtherPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 151
      Width = 390
      Height = 63
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      TabOrder = 1
      TabStop = True
      AutoHide = True
      Caption = 'Other message handling options:'
      object chkInviteAutoJoin: TTntCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 20
        Width = 387
        Height = 17
        Margins.Left = 0
        Align = alTop
        Caption = 'Automatically join when receiving a conference invitation'
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
        Caption = 'Block messages from people not on my contact list'
        TabOrder = 2
      end
    end
    object gbAdvancedPrefs: TExGroupBox
      AlignWithMargins = True
      Left = 0
      Top = 226
      Width = 390
      Height = 47
      Margins.Left = 0
      Margins.Top = 9
      Align = alTop
      AutoSize = True
      TabOrder = 2
      TabStop = True
      AutoHide = True
      Caption = 'Advanced message handling preferences'
      object btnManageKeywords: TTntButton
        Left = 3
        Top = 22
        Width = 161
        Height = 25
        Caption = 'Manage Keywords...'
        TabOrder = 1
        OnClick = btnManageKeywordsClick
      end
    end
  end
end
