object frmInvite: TfrmInvite
  Left = 249
  Top = 148
  AutoScroll = False
  Caption = 'Invite to Conference'
  ClientHeight = 268
  ClientWidth = 449
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 272
    Top = 0
    Width = 3
    Height = 234
    Cursor = crHSplit
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 234
    Width = 449
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 449
    end
    inherited Panel1: TPanel
      Left = 285
      Width = 164
      Height = 29
      inherited btnOK: TButton
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 272
    Height = 234
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 3
      Top = 109
      Width = 266
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object Label1: TLabel
      Left = 3
      Top = 3
      Width = 266
      Height = 13
      Align = alTop
      Caption = 'Invite the following contacts to:'
    end
    object Label2: TLabel
      Left = 3
      Top = 47
      Width = 266
      Height = 13
      Align = alTop
      Caption = 'Reason:'
    end
    object pnl1: TPanel
      Left = 3
      Top = 16
      Width = 266
      Height = 31
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object cboRoom: TComboBox
        Left = 3
        Top = 4
        Width = 214
        Height = 21
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object memReason: TMemo
      Left = 3
      Top = 60
      Width = 266
      Height = 49
      Align = alTop
      Lines.Strings = (
        'Please join us in this conference room.')
      TabOrder = 1
    end
    object lstJIDS: TListView
      Left = 3
      Top = 112
      Width = 266
      Height = 88
      Align = alClient
      Columns = <
        item
          Caption = 'Nickname'
          Width = 90
        end
        item
          Caption = 'Jabber ID'
          Width = 150
        end>
      MultiSelect = True
      SortType = stBoth
      TabOrder = 2
      ViewStyle = vsReport
      OnDragDrop = lstJIDSDragDrop
      OnDragOver = lstJIDSDragOver
    end
    object Panel1: TPanel
      Left = 3
      Top = 200
      Width = 266
      Height = 31
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 3
      object btnRemove: TButton
        Left = 80
        Top = 4
        Width = 75
        Height = 25
        Caption = 'Remove'
        TabOrder = 0
        OnClick = btnRemoveClick
      end
      object btnAdd: TButton
        Left = 0
        Top = 4
        Width = 75
        Height = 25
        Caption = 'Add '
        TabOrder = 1
        OnClick = btnAddClick
      end
    end
  end
  object pnlRight: TPanel
    Left = 275
    Top = 0
    Width = 174
    Height = 234
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 2
    Visible = False
    OnResize = pnlRightResize
    object Label3: TLabel
      Left = 3
      Top = 3
      Width = 168
      Height = 52
      Align = alTop
      Caption = 
        'To add recipients you can select them from the list and press th' +
        'e "Add" button, or drag contacts from your roster into the recip' +
        'ient list.'
      WordWrap = True
    end
    object sgContacts: TStringGrid
      Left = 3
      Top = 55
      Width = 168
      Height = 176
      Align = alClient
      ColCount = 2
      DefaultRowHeight = 16
      FixedCols = 0
      FixedRows = 0
      GridLineWidth = 0
      Options = [goFixedVertLine, goFixedHorzLine, goRangeSelect, goRowSelect, goThumbTracking]
      TabOrder = 0
    end
  end
end
