object frmSelectItem: TfrmSelectItem
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Select Item'
  ClientHeight = 322
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlInput: TPanel
    Left = 0
    Top = 0
    Width = 281
    Height = 291
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object pnlSelect: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 275
      Height = 256
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
    end
    object pnlEntry: TPanel
      Left = 0
      Top = 262
      Width = 281
      Height = 29
      Align = alBottom
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object lblJID: TTntLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 47
        Height = 23
        Align = alLeft
        Caption = 'Jabber ID'
        FocusControl = txtJID
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object txtJID: TTntEdit
        AlignWithMargins = True
        Left = 56
        Top = 3
        Width = 222
        Height = 23
        Align = alClient
        TabOrder = 0
        ExplicitHeight = 21
      end
    end
  end
  object pnlActions: TPanel
    Left = 0
    Top = 291
    Width = 281
    Height = 31
    Align = alBottom
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object btnCancel: TTntButton
      AlignWithMargins = True
      Left = 203
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object btnOK: TTntButton
      AlignWithMargins = True
      Left = 122
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 1
    end
  end
  object popSelected: TTntPopupMenu
    Left = 56
    Top = 88
    object mnuShowOnline: TTntMenuItem
      Caption = 'Show Online Only'
      OnClick = mnuShowOnlineClick
    end
  end
end
