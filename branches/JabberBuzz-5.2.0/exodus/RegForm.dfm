inherited frmRegister: TfrmRegister
  Left = 246
  Top = 361
  Caption = 'Service Registration'
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inherited TntPanel1: TTntPanel
    inherited btnBack: TTntButton
      OnClick = btnPrevClick
    end
    inherited btnNext: TTntButton
      OnClick = btnNextClick
    end
    inherited btnCancel: TTntButton
      OnClick = btnCancelClick
    end
  end
  inherited Tabs: TPageControl
    ActivePage = TabSheet4
    ExplicitWidth = 494
    ExplicitHeight = 324
    inherited TabSheet1: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 27
      ExplicitWidth = 486
      ExplicitHeight = 293
      object Label1: TTntLabel
        Left = 0
        Top = 0
        Width = 486
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
        ExplicitWidth = 408
      end
      object lblIns: TTntLabel
        Left = 0
        Top = 90
        Width = 486
        Height = 203
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
        ExplicitWidth = 408
        ExplicitHeight = 135
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object formBox: TScrollBox
        Left = 0
        Top = 0
        Width = 486
        Height = 261
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
      end
      object Panel2: TPanel
        Left = 0
        Top = 261
        Width = 486
        Height = 32
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object btnDelete: TTntButton
          Left = 243
          Top = 3
          Width = 161
          Height = 25
          Caption = 'Delete My Registration'
          TabOrder = 0
          OnClick = btnDeleteClick
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      object Label2: TTntLabel
        Left = 0
        Top = 0
        Width = 486
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
        ExplicitWidth = 408
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
      object lblOK: TTntLabel
        Left = 0
        Top = 0
        Width = 486
        Height = 90
        Align = alTop
        AutoSize = False
        Caption = 
          'Your Registration to this service has been completed Successfull' +
          'y. Press the '#39'Finish'#39' button to Finish.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
        ExplicitWidth = 408
      end
      object lblBad: TTntLabel
        Left = 0
        Top = 90
        Width = 486
        Height = 90
        Align = alTop
        AutoSize = False
        Caption = 
          'Your Registration to this service has Failed! Press Back to go b' +
          'ack and verify that all of the parameters have been filled in co' +
          'rrectly. Press Cancel to close this wizard.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
        ExplicitWidth = 408
      end
    end
  end
  inherited pnlDockTop: TPanel
    ExplicitWidth = 494
    inherited tbDockBar: TToolBar
      ExplicitLeft = 445
    end
    inherited Panel1: TPanel
      ExplicitWidth = 442
      inherited lblWizardDetails: TTntLabel
        Width = 75
        Height = 13
        AutoSize = True
        ExplicitWidth = 75
        ExplicitHeight = 13
      end
      inherited Image1: TImage
        Picture.Data = {00}
      end
    end
  end
end
