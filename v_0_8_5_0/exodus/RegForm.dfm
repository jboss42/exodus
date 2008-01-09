object frmRegister: TfrmRegister
  Left = 230
  Top = 175
  Width = 312
  Height = 327
  Caption = 'Agent Registration'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 263
    Width = 304
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object pnlBtns: TPanel
      Left = 55
      Top = 0
      Width = 249
      Height = 35
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnPrev: TButton
        Left = 8
        Top = 8
        Width = 75
        Height = 25
        Caption = '< Previous'
        Enabled = False
        TabOrder = 0
        OnClick = btnPrevClick
      end
      object btnNext: TButton
        Left = 88
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Next >'
        Default = True
        Enabled = False
        TabOrder = 1
        OnClick = btnNextClick
      end
      object btnCancel: TButton
        Left = 168
        Top = 8
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        TabOrder = 2
        OnClick = btnCancelClick
      end
    end
  end
  object Tabs: TPageControl
    Left = 0
    Top = 0
    Width = 304
    Height = 263
    ActivePage = tabAgent
    Align = alClient
    MultiLine = True
    Style = tsButtons
    TabOrder = 1
    object tabWelcome: TTabSheet
      Caption = 'tabWelcome'
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 296
        Height = 90
        Align = alTop
        AutoSize = False
        Caption = 
          'This wizard will register you with a service or Agent. Use the N' +
          'ext button to advance through the steps. Use Cancel anytime to c' +
          'ancel this registration.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object lblIns: TLabel
        Left = 0
        Top = 90
        Width = 296
        Height = 137
        Align = alClient
        AutoSize = False
        Caption = 'Waiting for agent instructions.....'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
    end
    object tabAgent: TTabSheet
      Caption = 'tabAgent'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 199
        Width = 296
        Height = 33
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object Panel3: TPanel
          Left = 128
          Top = 0
          Width = 168
          Height = 33
          Align = alRight
          BevelOuter = bvNone
          Caption = 'Panel3'
          TabOrder = 0
          object btnDelete: TButton
            Left = 3
            Top = 3
            Width = 161
            Height = 25
            Caption = 'Delete My Registration'
            TabOrder = 0
            OnClick = btnDeleteClick
          end
        end
      end
    end
    object tabWait: TTabSheet
      Caption = 'tabWait'
      ImageIndex = 4
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 296
        Height = 90
        Align = alTop
        AutoSize = False
        Caption = 'Please wait, Sending your registration to the service....'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
    end
    object tabResult: TTabSheet
      Caption = 'tabResult'
      ImageIndex = 3
      object lblBad: TLabel
        Left = 0
        Top = 90
        Width = 296
        Height = 90
        Align = alTop
        AutoSize = False
        Caption = 
          'Your Registration to this service has Failed! Press Previous to ' +
          'go back and verify that all of the parameters have been filled i' +
          'n correctly. Press Cancel to close this wizard.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
      end
      object lblOK: TLabel
        Left = 0
        Top = 0
        Width = 296
        Height = 90
        Align = alTop
        AutoSize = False
        Caption = 
          'Your Registration to this service has been completed Successfull' +
          'y. Press the '#39'Next'#39' button to Finish.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
      end
    end
  end
end
