object frmImport: TfrmImport
  Left = 231
  Top = 165
  Width = 417
  Height = 329
  BorderWidth = 4
  Caption = 'Import Jabber Roster'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 262
    Width = 401
    Height = 30
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 401
    end
    inherited Panel1: TPanel
      Left = 241
      inherited btnOK: TButton
        Caption = 'Import'
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        Caption = 'Close'
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object ListView1: TTntListView
    Left = 0
    Top = 0
    Width = 401
    Height = 262
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Nickname'
        Width = 100
      end
      item
        Caption = 'Group'
        Width = 85
      end
      item
        Caption = 'Jabber ID'
        Width = 120
      end>
    SortType = stText
    TabOrder = 1
    ViewStyle = vsReport
  end
  object OpenDialog1: TOpenDialog
    Filter = 'XML Files|*.xml|All Files|*.*'
    Left = 8
    Top = 264
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Roster Files|*.xml|All Files|*.*'
    Left = 40
    Top = 264
  end
end
