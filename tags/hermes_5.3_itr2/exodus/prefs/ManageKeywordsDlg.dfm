inherited ManageKeywordsDlg: TManageKeywordsDlg
  BorderStyle = bsDialog
  Caption = 'Manage Keywords'
  ClientHeight = 376
  ClientWidth = 556
  OnCreate = TntFormCreate
  ExplicitWidth = 562
  ExplicitHeight = 414
  PixelsPerInch = 120
  TextHeight = 16
  object pnlVerbiage: TExBrandPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 550
    Height = 82
    Align = alTop
    AutoSize = True
    TabOrder = 0
    TabStop = True
    AutoHide = True
    object TntLabel1: TTntLabel
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 547
      Height = 32
      Margins.Left = 0
      Align = alTop
      Caption = 
        'You can be notified when a keyword appears in conference room. E' +
        'nter in the keywords that you want to look for in messages.'
      WordWrap = True
      ExplicitTop = 89
      ExplicitWidth = 554
    end
    object Label1: TTntLabel
      AlignWithMargins = True
      Left = 0
      Top = 63
      Width = 547
      Height = 16
      Margins.Left = 0
      Align = alTop
      Caption = 'The following characters should not be used: ( ) [ ] * + \ ?.'
      ExplicitLeft = 2
      ExplicitTop = 105
      ExplicitWidth = 341
    end
    object chkRegex: TTntCheckBox
      AlignWithMargins = True
      Left = 0
      Top = 41
      Width = 547
      Height = 16
      Margins.Left = 0
      Align = alTop
      Caption = 'Use Regular Expressions for Keyword matches'
      TabOrder = 0
      ExplicitLeft = 2
      ExplicitTop = 105
      ExplicitWidth = 297
    end
  end
  object ExBrandPanel1: TExBrandPanel
    AlignWithMargins = True
    Left = 3
    Top = 91
    Width = 550
    Height = 246
    Align = alTop
    TabOrder = 1
    TabStop = True
    AutoHide = True
    object memKeywords: TTntMemo
      Left = 0
      Top = 0
      Width = 550
      Height = 246
      Align = alClient
      TabOrder = 0
      OnKeyPress = memKeywordsKeyPress
      ExplicitLeft = -12
      ExplicitTop = -23
      ExplicitWidth = 568
      ExplicitHeight = 121
    end
  end
  object btnOK: TTntButton
    Left = 392
    Top = 344
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TTntButton
    Left = 473
    Top = 344
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
