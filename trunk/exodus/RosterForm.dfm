inherited RosterForm: TRosterForm
  BorderStyle = bsNone
  Caption = ''
  ClientHeight = 236
  ClientWidth = 343
  Color = clBtnFace
  ParentFont = False
  OnClose = TntFormClose
  ExplicitWidth = 343
  ExplicitHeight = 236
  PixelsPerInch = 96
  TextHeight = 13
  object _PageControl: TTntPageControl
    Left = 0
    Top = 0
    Width = 343
    Height = 236
    Align = alClient
    OwnerDraw = True
    RaggedRight = True
    TabHeight = 26
    TabOrder = 0
    TabPosition = tpBottom
    TabWidth = 26
    OnDrawTab = _PageControlDrawTab
  end
end
