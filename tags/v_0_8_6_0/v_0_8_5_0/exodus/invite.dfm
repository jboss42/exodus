object frmInvite: TfrmInvite
  Left = 237
  Top = 181
  AutoScroll = False
  Caption = 'Invite to Conference'
  ClientHeight = 268
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 234
    Width = 323
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 0
    inherited Panel2: TPanel
      Width = 323
      Height = 34
      inherited Bevel1: TBevel
        Width = 323
      end
      inherited Panel1: TPanel
        Left = 159
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
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 323
    Height = 234
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 3
      Top = 122
      Width = 317
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object lstJIDS: TListView
      Left = 3
      Top = 125
      Width = 253
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
      Left = 256
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
        Top = 6
        Width = 60
        Height = 25
        Caption = 'Add'
        TabOrder = 1
        OnClick = btnAddClick
      end
    end
    object Panel2: TPanel
      Left = 3
      Top = 3
      Width = 317
      Height = 119
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object Label2: TLabel
        Left = 0
        Top = 44
        Width = 317
        Height = 13
        Align = alTop
        Caption = 'Reason:'
      end
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 317
        Height = 13
        Align = alTop
        Caption = 'Invite the following contacts to:'
      end
      object memReason: TMemo
        Left = 0
        Top = 57
        Width = 317
        Height = 62
        Align = alClient
        Lines.Strings = (
          'Please join us in this conference room.')
        TabOrder = 0
      end
      object pnl1: TPanel
        Left = 0
        Top = 13
        Width = 317
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
end
