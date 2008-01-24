inherited ExCheckGroupBox: TExCheckGroupBox
  inherited pnlTop: TTntPanel
    inherited pnlBevel: TTntPanel
      Left = 84
      Width = 236
      ExplicitLeft = 84
      ExplicitWidth = 236
      inherited TntBevel1: TTntBevel
        Width = 230
        ExplicitWidth = 227
      end
    end
    inherited pnlLabel: TTntPanel
      Left = 17
      ExplicitLeft = 17
      inherited lblCaption: TTntLabel
        FocusControl = chkBox
      end
    end
    object chkBox: TTntCheckBox
      Left = 0
      Top = 0
      Width = 17
      Height = 17
      Align = alLeft
      TabOrder = 2
      OnClick = chkBoxClick
    end
  end
end
