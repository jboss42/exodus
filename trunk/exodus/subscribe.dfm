object frmSubscribe: TfrmSubscribe
  Left = 915
  Top = 575
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Subscription Request'
  ClientHeight = 197
  ClientWidth = 258
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 22
    Width = 258
    Height = 26
    Align = alTop
    Caption = 
      'This person or agent would like to see your online presence and ' +
      'add you to their roster.'
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 0
    Top = 20
    Width = 258
    Height = 2
    Align = alTop
  end
  object lblJID: TStaticText
    Left = 0
    Top = 0
    Width = 258
    Height = 20
    Cursor = crHandPoint
    Hint = 'Show contact profile'
    Align = alTop
    Caption = ' foo@jabber.org'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    OnClick = lblJIDClick
  end
  object chkSubscribe: TCheckBox
    Left = 8
    Top = 56
    Width = 217
    Height = 17
    Caption = 'Add this person to my roster'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object boxAdd: TGroupBox
    Left = 24
    Top = 72
    Width = 209
    Height = 81
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 16
      Width = 51
      Height = 13
      Caption = 'Nickname:'
    end
    object Label3: TLabel
      Left = 8
      Top = 48
      Width = 32
      Height = 13
      Caption = 'Group:'
    end
    object txtNickname: TEdit
      Left = 70
      Top = 14
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object cboGroup: TComboBox
      Left = 70
      Top = 44
      Width = 123
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 161
    Width = 258
    Height = 36
    Align = alBottom
    AutoScroll = False
    TabOrder = 3
    inherited Bevel1: TBevel
      Width = 258
    end
    inherited Panel1: TPanel
      Left = 98
      Height = 31
      inherited btnOK: TButton
        Caption = 'Accept'
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        Caption = 'Deny'
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
end
