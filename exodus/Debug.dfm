object frmDebug: TfrmDebug
  Left = 335
  Top = 439
  Width = 351
  Height = 320
  Caption = 'Debug'
  Color = clBtnFace
  DragKind = dkDock
  DragMode = dmAutomatic
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
  object Panel1: TPanel
    Left = 0
    Top = 258
    Width = 343
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object chkDebugWrap: TCheckBox
      Left = 8
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Word Wrap'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = chkDebugWrapClick
    end
    object Panel3: TPanel
      Left = 158
      Top = 0
      Width = 185
      Height = 31
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnSendRaw: TButton
        Left = 90
        Top = 2
        Width = 89
        Height = 25
        Caption = 'Send Server'
        TabOrder = 0
        OnClick = btnSendRawClick
      end
      object btnClearDebug: TButton
        Left = 8
        Top = 2
        Width = 75
        Height = 25
        Caption = 'Clear Debug'
        TabOrder = 1
        OnClick = btnClearDebugClick
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 343
    Height = 258
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = 'Panel2'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 4
      Top = 209
      Width = 335
      Height = 5
      Cursor = crVSplit
      Align = alBottom
    end
    object MsgDebug: TRichEdit
      Left = 4
      Top = 4
      Width = 335
      Height = 205
      Align = alClient
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object MemoSend: TMemo
      Left = 4
      Top = 214
      Width = 335
      Height = 40
      Align = alBottom
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      PopupMenu = PopupMenu1
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 16
    Top = 16
    object popMsg: TMenuItem
      Caption = 'Message'
      OnClick = popMsgClick
    end
    object popIQGet: TMenuItem
      Caption = 'IQ Get'
      OnClick = popMsgClick
    end
    object popIQSet: TMenuItem
      Caption = 'IQ Set'
      OnClick = popMsgClick
    end
    object popPres: TMenuItem
      Caption = 'Presence'
      OnClick = popMsgClick
    end
  end
end
