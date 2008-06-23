inherited frmInvalidRoster: TfrmInvalidRoster
  Left = 223
  Top = 127
  Caption = 'Invalid Contact List Items'
  ClientHeight = 237
  ClientWidth = 314
  ExplicitWidth = 322
  ExplicitHeight = 271
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlDockTop: TPanel
    Width = 314
    TabOrder = 2
    ExplicitWidth = 314
    inherited tbDockBar: TToolBar
      Left = 265
      ExplicitLeft = 265
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 205
    Width = 314
    Height = 32
    Align = alBottom
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
    ExplicitTop = 205
    ExplicitWidth = 314
    ExplicitHeight = 32
    inherited Panel2: TPanel
      Width = 314
      Height = 32
      ExplicitWidth = 314
      ExplicitHeight = 32
      inherited Bevel1: TBevel
        Width = 314
        ExplicitWidth = 314
      end
      inherited Panel1: TPanel
        Left = 154
        Height = 27
        ExplicitLeft = 154
        ExplicitHeight = 27
        inherited btnOK: TTntButton
          Caption = 'Remove'
          Default = False
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          Caption = 'Close'
          Default = True
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object ListView1: TTntListView
    Left = 0
    Top = 33
    Width = 314
    Height = 172
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
  object popItems: TTntPopupMenu
    Left = 24
    Top = 40
    object oggleCheckboxes1: TTntMenuItem
      Caption = 'Toggle Checkboxes'
      OnClick = oggleCheckboxes1Click
    end
  end
end
