object frmInvite: TfrmInvite
  Left = 260
  Top = 178
  Width = 282
  Height = 302
  Caption = 'Conference Invite'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 98
    Width = 274
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 234
    Width = 274
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 274
    end
    inherited Panel1: TPanel
      Left = 114
      Height = 29
      inherited btnOK: TButton
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 274
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object Label1: TLabel
      Left = 3
      Top = 3
      Width = 268
      Height = 13
      Align = alTop
      Caption = 'Invite the following contacts to:'
    end
    object lblJID: TLabel
      Left = 3
      Top = 16
      Width = 268
      Height = 13
      Align = alTop
      Caption = 'foo@conference'
    end
    object Label2: TLabel
      Left = 3
      Top = 29
      Width = 268
      Height = 13
      Align = alTop
      Caption = 'Reason:'
    end
  end
  object memReason: TMemo
    Left = 0
    Top = 49
    Width = 274
    Height = 49
    Align = alTop
    Lines.Strings = (
      'Please join us in this conference room.')
    TabOrder = 2
  end
  object lstJIDS: TListView
    Left = 0
    Top = 101
    Width = 274
    Height = 133
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Nickname'
        Width = 90
      end
      item
        Caption = 'Jabber ID'
        Width = 150
      end>
    SortType = stBoth
    TabOrder = 3
    ViewStyle = vsReport
    OnChange = lstJIDSChange
    OnCompare = lstJIDSCompare
  end
end
