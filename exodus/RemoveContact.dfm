object frmRemove: TfrmRemove
  Left = 275
  Top = 146
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Remove Contact'
  ClientHeight = 149
  ClientWidth = 299
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
    Width = 299
    Height = 13
    Align = alTop
    Caption = 'You are about to remove this person from your Roster. '
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 0
    Top = 20
    Width = 299
    Height = 2
    Align = alTop
  end
  object lblJID: TStaticText
    Left = 0
    Top = 0
    Width = 299
    Height = 20
    Align = alTop
    Caption = ' foo@jabber.org'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clHighlightText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
  end
  object chkRemove1: TCheckBox
    Left = 8
    Top = 56
    Width = 217
    Height = 17
    Caption = 'Remove this person from my roster.'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 115
    Width = 299
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 2
    inherited Bevel1: TBevel
      Width = 299
    end
    inherited Panel1: TPanel
      Left = 139
      inherited btnOK: TButton
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object chkRemove2: TCheckBox
    Left = 8
    Top = 80
    Width = 265
    Height = 17
    Caption = 'Force this person to remove me from their roster'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
end
