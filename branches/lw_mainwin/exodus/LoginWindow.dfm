inherited frmLoginWindow: TfrmLoginWindow
  Caption = ''
  ClientHeight = 478
  ClientWidth = 254
  Color = clWhite
  Font.Height = -13
  Padding.Left = 6
  Padding.Top = 6
  Padding.Right = 6
  Padding.Bottom = 6
  OnCreate = FormCreate
  ExplicitWidth = 262
  ExplicitHeight = 512
  PixelsPerInch = 96
  TextHeight = 16
  object lblStatus: TTntLabel
    AlignWithMargins = True
    Left = 9
    Top = 9
    Width = 236
    Height = 16
    Align = alTop
    Caption = 'You are currently disconnected.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 180
  end
  object lblConnect: TTntLabel
    AlignWithMargins = True
    Left = 9
    Top = 31
    Width = 236
    Height = 16
    Align = alTop
    Caption = 'Click a profile to connect:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 145
  end
  object lstProfiles: TTntListView
    AlignWithMargins = True
    Left = 9
    Top = 53
    Width = 236
    Height = 73
    Align = alTop
    BorderStyle = bsNone
    Columns = <
      item
        AutoSize = True
      end>
    HotTrackStyles = [htHandPoint, htUnderlineHot]
    ParentColor = True
    ShowColumnHeaders = False
    SmallImages = frmExodus.ImageList2
    TabOrder = 0
    ViewStyle = vsReport
    ExplicitLeft = 8
    ExplicitTop = 48
    ExplicitWidth = 241
  end
  object pnlMetadata: TPanel
    AlignWithMargins = True
    Left = 6
    Top = 368
    Width = 242
    Height = 104
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object imgLogo: TImage
      Left = 0
      Top = 0
      Width = 242
      Height = 57
      Align = alTop
      ExplicitLeft = 16
      ExplicitTop = 8
      ExplicitWidth = 217
    end
  end
end
