object frmInvalidRoster: TfrmInvalidRoster
  Left = 223
  Top = 127
  Width = 322
  Height = 271
  Caption = 'Invalid Roster Items'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 205
    Width = 314
    Height = 32
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 314
    end
    inherited Panel1: TPanel
      Left = 154
      inherited btnOK: TButton
        Caption = 'Remove'
        Default = False
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        Caption = 'Close'
        Default = True
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 314
    Height = 205
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Contact ID'
        Width = 100
      end
      item
        Caption = 'Item'
        Width = 80
      end
      item
        Caption = 'Pres. Error'
        Width = 200
      end>
    PopupMenu = popItems
    TabOrder = 1
    ViewStyle = vsReport
  end
  object popItems: TPopupMenu
    Left = 24
    Top = 40
    object oggleCheckboxes1: TMenuItem
      Caption = 'Toggle Checkboxes'
      OnClick = oggleCheckboxes1Click
    end
  end
end
