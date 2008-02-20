inherited frmGrpManagement: TfrmGrpManagement
  Left = 255
  Top = 165
  Caption = 'Group Management'
  ClientHeight = 209
  ClientWidth = 359
  DefaultMonitor = dmDesktop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    359
    209)
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 173
    Width = 359
    Height = 36
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    TabStop = True
    ExplicitTop = 173
    ExplicitWidth = 359
    ExplicitHeight = 36
    inherited Panel2: TPanel
      Width = 359
      Height = 36
      ExplicitWidth = 359
      ExplicitHeight = 36
      inherited Bevel1: TBevel
        Width = 359
        ExplicitWidth = 359
      end
      inherited Panel1: TPanel
        Left = 199
        Height = 31
        ExplicitLeft = 199
        ExplicitHeight = 31
        inherited btnOK: TTntButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object optMove: TTntRadioButton
    Left = 16
    Top = 8
    Width = 329
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Move the selected contacts to the following group:'
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object optCopy: TTntRadioButton
    Left = 16
    Top = 32
    Width = 329
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Copy the selected contacts to the following group:'
    TabOrder = 2
  end
  object lstGroups: TTntListBox
    Left = 32
    Top = 56
    Width = 313
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    ExtendedSelect = False
    ItemHeight = 13
    Sorted = True
    TabOrder = 3
  end
end
