object frmCustomPres: TfrmCustomPres
  Left = 240
  Top = 168
  BorderStyle = bsDialog
  Caption = 'Custom Presence'
  ClientHeight = 261
  ClientWidth = 313
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
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 75
    Height = 13
    Caption = 'Presence Type:'
  end
  object Label2: TLabel
    Left = 8
    Top = 43
    Width = 33
    Height = 13
    Caption = 'Status:'
  end
  object Label3: TLabel
    Left = 8
    Top = 75
    Width = 31
    Height = 13
    Caption = 'Priority'
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 227
    Width = 313
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 5
    inherited Bevel1: TBevel
      Width = 313
    end
    inherited Panel1: TPanel
      Left = 153
      Height = 29
      inherited btnOK: TButton
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object cboType: TComboBox
    Left = 96
    Top = 8
    Width = 129
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      'Chat'
      'Available'
      'Away'
      'Ext. Away'
      'Do Not Disturb')
  end
  object txtStatus: TTntEdit
    Left = 96
    Top = 40
    Width = 209
    Height = 23
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial Unicode MS'
    Font.Style = []
    ImeMode = imHanguel
    ParentFont = False
    TabOrder = 1
  end
  object txtPriority: TEdit
    Left = 96
    Top = 72
    Width = 33
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object chkSave: TCheckBox
    Left = 8
    Top = 104
    Width = 241
    Height = 17
    Caption = 'Save this presence to my preferences.'
    TabOrder = 3
    OnClick = chkSaveClick
  end
  object boxSave: TGroupBox
    Left = 8
    Top = 128
    Width = 289
    Height = 81
    TabOrder = 4
    object lblTitle: TLabel
      Left = 8
      Top = 18
      Width = 23
      Height = 13
      Caption = 'Title:'
      Enabled = False
    end
    object lblHotkey: TLabel
      Left = 8
      Top = 50
      Width = 38
      Height = 13
      Caption = 'HotKey:'
      Enabled = False
    end
    object txtTitle: TEdit
      Left = 80
      Top = 15
      Width = 193
      Height = 21
      Enabled = False
      TabOrder = 0
    end
    object txtHotkey: THotKey
      Left = 80
      Top = 48
      Width = 193
      Height = 19
      Enabled = False
      HotKey = 32833
      InvalidKeys = [hcNone, hcShift]
      Modifiers = [hkAlt]
      TabOrder = 1
    end
  end
end
