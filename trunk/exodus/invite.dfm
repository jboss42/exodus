object frmInvite: TfrmInvite
  Left = 233
  Top = 153
  AutoScroll = False
  Caption = 'Invite to Conference'
  ClientHeight = 268
  ClientWidth = 510
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
    Left = 317
    Top = 0
    Width = 3
    Height = 234
    Cursor = crHSplit
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 234
    Width = 510
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Bevel1: TBevel
      Width = 510
    end
    inherited Panel1: TPanel
      Left = 346
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
    Width = 317
    Height = 234
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 3
      Top = 122
      Width = 311
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object lstJIDS: TListView
      Left = 3
      Top = 125
      Width = 247
      Height = 106
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
      RowSelect = True
      SortType = stBoth
      TabOrder = 0
      ViewStyle = vsReport
      OnDragDrop = lstJIDSDragDrop
      OnDragOver = lstJIDSDragOver
    end
    object Panel1: TPanel
      Left = 250
      Top = 125
      Width = 64
      Height = 106
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnRemove: TButton
        Left = 4
        Top = 34
        Width = 60
        Height = 25
        Caption = 'Remove'
        TabOrder = 0
        OnClick = btnRemoveClick
      end
      object btnAdd: TButton
        Left = 4
        Top = 4
        Width = 60
        Height = 25
        Caption = 'More >>'
        TabOrder = 1
        OnClick = btnAddClick
      end
    end
    object Panel2: TPanel
      Left = 3
      Top = 3
      Width = 311
      Height = 119
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 2
      object Label2: TLabel
        Left = 0
        Top = 44
        Width = 311
        Height = 13
        Align = alTop
        Caption = 'Reason:'
      end
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 311
        Height = 13
        Align = alTop
        Caption = 'Invite the following contacts to:'
      end
      object memReason: TMemo
        Left = 0
        Top = 57
        Width = 311
        Height = 62
        Align = alClient
        Lines.Strings = (
          'Please join us in this conference room.')
        TabOrder = 0
      end
      object pnl1: TPanel
        Left = 0
        Top = 13
        Width = 311
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object cboRoom: TComboBox
          Left = 3
          Top = 4
          Width = 214
          Height = 21
          ItemHeight = 13
          TabOrder = 0
        end
      end
    end
  end
  object pnlRight: TPanel
    Left = 320
    Top = 0
    Width = 190
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
      Width = 184
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
      Width = 184
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
