inherited ExCheckGroupBox: TExCheckGroupBox
  inherited pnlTop: TTntPanel
    inherited lblCaption: TTntLabel
      Left = 20
      Margins.Left = 3
      ExplicitLeft = 20
    end
    inherited pnlBevel: TTntPanel
      Left = 87
      Width = 233
      ExplicitLeft = 87
      ExplicitWidth = 233
      inherited TntBevel1: TTntBevel
        Width = 227
        ExplicitWidth = 227
      end
    end
    object chkBox: TTntCheckBox
      Left = 0
      Top = 0
      Width = 17
      Height = 17
      Align = alLeft
      TabOrder = 1
      OnClick = chkBoxClick
    end
  end
end
