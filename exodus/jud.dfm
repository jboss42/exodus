inherited frmJUD: TfrmJUD
  Left = 243
  Top = 142
  Width = 437
  Height = 289
  BorderWidth = 3
  Caption = 'Search for Contacts'
  PixelsPerInch = 96
  TextHeight = 13
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 164
    Height = 249
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      164
      249)
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 164
      Height = 26
      Align = alTop
      Caption = 'Fill in the search criteria to find contacts on.'
      WordWrap = True
    end
    object Button1: TButton
      Left = 2
      Top = 223
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Search'
      TabOrder = 0
    end
    object Button2: TButton
      Left = 82
      Top = 223
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Close'
      TabOrder = 1
    end
  end
  object lstContacts: TListView
    Left = 164
    Top = 0
    Width = 259
    Height = 249
    Align = alClient
    Columns = <>
    TabOrder = 1
  end
end
