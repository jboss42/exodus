object frmRoomAdminList: TfrmRoomAdminList
  Left = 247
  Top = 262
  Width = 323
  Height = 329
  BorderWidth = 3
  Caption = 'Room List Modifier'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 150
    Width = 309
    Height = 7
    Cursor = crVSplit
    Align = alTop
    Beveled = True
  end
  object Label1: TTntLabel
    Left = 0
    Top = 157
    Width = 309
    Height = 25
    Align = alTop
    AutoSize = False
    Caption = 'Enter New Jabber ID'#39's for this list:'
    Layout = tlBottom
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 264
    Width = 309
    Height = 30
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Panel2: TPanel
      Width = 309
      Height = 30
      inherited Bevel1: TBevel
        Width = 309
      end
      inherited Panel1: TPanel
        Left = 149
        Height = 25
        inherited btnOK: TTntButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object memNew: TTntMemo
    Left = 0
    Top = 182
    Width = 309
    Height = 82
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object lstItems: TTntListView
    Left = 0
    Top = 0
    Width = 309
    Height = 150
    Align = alTop
    Checkboxes = True
    Columns = <
      item
        Caption = 'Nick'
        Width = 100
      end
      item
        Caption = 'Jabber ID'
        Width = 180
      end>
    TabOrder = 2
    ViewStyle = vsReport
  end
end
