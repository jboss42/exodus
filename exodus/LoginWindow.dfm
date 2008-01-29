inherited frmLoginWindow: TfrmLoginWindow
  BorderStyle = bsNone
  Caption = ''
  ClientHeight = 527
  ClientWidth = 237
  Color = clWhite
  Font.Height = -13
  Padding.Left = 6
  Padding.Top = 6
  Padding.Right = 6
  Padding.Bottom = 6
  OnCreate = FormCreate
  ExplicitWidth = 237
  ExplicitHeight = 527
  PixelsPerInch = 96
  TextHeight = 16
  object lblStatus: TTntLabel
    AlignWithMargins = True
    Left = 9
    Top = 41
    Width = 219
    Height = 16
    Margins.Top = 0
    Margins.Bottom = 0
    Align = alTop
    Caption = 'You are currently disconnected.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 180
  end
  object lblConnect: TTntLabel
    AlignWithMargins = True
    Left = 9
    Top = 57
    Width = 219
    Height = 16
    Margins.Top = 0
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Click a profile to connect:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 145
  end
  object lstProfiles: TTntListView
    AlignWithMargins = True
    Left = 6
    Top = 85
    Width = 225
    Height = 73
    Margins.Left = 0
    Margins.Top = 12
    Margins.Right = 0
    Margins.Bottom = 12
    Align = alTop
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Columns = <
      item
        AutoSize = True
      end>
    HotTrackStyles = [htHandPoint, htUnderlineHot]
    ParentColor = True
    PopupMenu = popProfiles
    ShowColumnHeaders = False
    SmallImages = frmExodus.ImageList2
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lstProfilesClick
    OnDblClick = lstProfilesClick
  end
  object pnlProfileActions: TPanel
    AlignWithMargins = True
    Left = 6
    Top = 467
    Width = 225
    Height = 48
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 6
    Align = alBottom
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object pnlNewUser: TPanel
      Left = 0
      Top = 0
      Width = 225
      Height = 24
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object Image1: TImage
        Left = 1
        Top = 0
        Width = 24
        Height = 24
        AutoSize = True
        Picture.Data = {
          0A54504E474F626A65637489504E470D0A1A0A0000000D494844520000001800
          0000180806000000E0773DF80000000467414D410000AFC837058AE900000019
          74455874536F6674776172650041646F626520496D616765526561647971C965
          3C000004E04944415478DAAD950B50545518C7BFBBBBC022CB2BB70582951142
          3065100A091891AC9C31C60121B324671AC391C6897C645352802193134E6093
          158F72CAB2144424131479680386BC5F63A23C434060EF73DF7B776FE72EBBCD
          0ACBE04C7D33DFDC39E73BE7FFFBCE771E17E3380E6C6D5DD48B30CFB0796D6E
          917EB0370E9B0F58304A897198845B4A6CB1E4FE5F4071E6C2618F00EC892D06
          B0D7BF24C0DEC4C5A04579F091C1086D19F950CF77F1F65880A5CAC2C7BE3906
          4776EFCDCB3B733AFFEBAA46F2E3CB7F8012E9B076013087B75B530C19FA082C
          0E2606F40559E0171818F2D5D6C4B4A4AB3517DAAA6A6E657C7B01BA50585B74
          04B8C70658C445870B2AF57C3BFF4092147DF4C7DF85E736C52794443C1B17D8
          D6DA3475FA97AA8345157005C5940860B40B40993D4210B89A33368B7FBE3FD1
          DCF741E1251EE29FB91B5E4ADDB1AB3024E68CEB7CB192CF16DE0D7B7536671E
          FFC6317DC3D94C73C7944209439304545EEF007573D2179987DE3FE0EEEA8C09
          515ED9F9856715A4B25CEE05020F09AC33CDA58AB146683D7C127EC7EC8BE7E2
          91EB43257CF6130A06462649B83F3A03F746A740A737407A5803B84B1CC1D911
          A0ABB79754AB294A22163A86063CEDC319F5C019F470B3BBADB5B97F241D9B27
          2EDCF87A6E4B64E41A2F9A564A7142E574684F020C98C51FC2F0E804949DFA14
          5A7EDE0C320F2790380B4084B166418E9D7392224C751DBD7FB6DC992C469B7F
          C916208CDB71B4242222C48F66543E048100B3848762161727256F86A1D14928
          47E297BF8C05A9BB03023882C4092D1710C09275E7DD41F2BBEACEEF1935B45F
          6C801B4893B602041BB667EF0D8F08F6A728660541307EB88294218027AD9871
          532A1E8AD5D4309466061B03E452A1D44D041ECB30108B4C20301900270853C5
          CD9EAEBA8EA95FC7A7A1B57B0006F953855CCD03B0B8D7B223434303E42449FB
          235FA19825E5244E7A530A85544D4C7B68E831D7357E63796F25ADDDF77254A8
          8F873312773081D0C402187570FBCE307DA2ACEFF8D55BF01BD2C3F9CC91EB90
          B3586C4AA65BE8DA954FE20AC297A418244CC94982943338E1A32267645AFA6F
          A95E3DBEE7CD2DB02D6367C27BBECB2502B11089730624CED75D0B2AB50A4E54
          769C3B5F6FC89998810924ACE24F3F7FF1CC2B484CCBF1A429958CA4E8A76892
          F66510404BCDF86A94935E06F583DCB870F04ADD22CFDA1AFB7CAC93C0083443
          996A6EFF7537EE19EF206F579188637550DB337EBFB26DF6E0B95A68E40148DC
          643D39E6E76075CC764F8DC62853D18CB796C67DB5CA495F8366E23C8A19F7EF
          84B8948D9105ABFD7C96CFE238FB537D776D532F5319B1CA213E355A9E2C7713
          398DCE90BA92E6E94FD0AD2E45731804606D2F9A192295477B6A352A994E35ED
          65D04CF5F181B02010A66D5B96F56ACC86740581EB7EACEBA9E8BAA7ABBAD602
          1D299B40EEF50484EF8A94E6AC74C3243F74E217ABDB8D1F36B6C318BF07D612
          D9DE0381C849EAC9EA66D5963697B70FC2A25605164B5D5CFC4BAFF51C1D7A00
          FD579AA0DF724AF46F2742A09B0B44BF1224CED1B1ACB67A80CD385506D7AD8F
          9FBD9B2CB0299DB98EB9EFC07AA31182FB06A1BFBC0E46F8C916E71F3741F20B
          200BF083688D16F4373AA0158D237938BF0F8BBD45F34D88DCC102E74559CB97
          B3BE00FC136389F37D063E6E6F058B9975556011B0BA6D5298ED987F4FD1523F
          FDFF6AFF00FFBE81D53A4850CA0000000049454E44AE426082}
        Stretch = True
        OnClick = clickCreateProfile
      end
      object TntLabel1: TTntLabel
        Left = 28
        Top = 4
        Width = 147
        Height = 16
        Caption = 'Run the New User Wizard'
        OnClick = clickCreateProfile
      end
    end
    object pnlCreateProfile: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 24
      Width = 225
      Height = 24
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object Image2: TImage
        Left = 0
        Top = 0
        Width = 24
        Height = 24
        AutoSize = True
        Center = True
        Picture.Data = {
          0A54504E474F626A65637489504E470D0A1A0A0000000D494844520000001800
          0000180806000000E0773DF80000000467414D410000AFC837058AE900000019
          74455874536F6674776172650041646F626520496D616765526561647971C965
          3C000004D74944415478DADD947F6C535514C7BFEFF5B5DDD6B7755BBB8E31D6
          59AA634E27DB80C99824CA062A28F8238464A04C4D662026801862827F9868D0
          28327F203F06A221204413A6D1A98CE958045736375960EC57BB6584EE076C7B
          A35DFBFAFA7E5C6F274C97113018FEF126F7BD9373EF3D9F73EE39F7308410DC
          C9C1FC7F00155B99298B6119291C87B941114D9B3F447F44979595C52C7DFE85
          A8585549E0585DA206D6306E0844523545F0EB382123D12C969595915B021415
          4F163FBAE6C0E95FAB8E9C6C10B61EAC42900248E5AB6D9B0299CBB6474EA872
          184A3800FDC59677577EE0789B89D285E1F7AB1E8F47BB25400A63DDAA924D1F
          9DA9AF3D555D7776C3BE6F8DEED3358B7C7A83899BC1DA61B4CEFB6BDF5023DA
          076B2153D84997F6C0E12A933BC87392D7E5D26E0688D2E9E3DF5FBB76CB2BF5
          F5B53D5F1EABD9B8A6B4E0B354BD6CB5CC7C09FAD88C499B655F277CEDBBD12E
          06B0F93D3E559055815755691240565044C57C55458C46C0CC74CE2E7CBCF8A9
          873BDA5BC78EFC58F38D7D86794DBA3901A9B38A614BB91B7C5C2218EA1713F9
          503362DF0934B96BD0DCC6AEDD5719F37D088A7F02B0EB75C6999139674F61E1
          8A223DA767882AA3ABA375CC694FE783011F8606AF2025D104120EC2DD7B11B0
          65C199990D8E636982698AA919551C81D0F216CE05A66B1BCA6D77699C3A3C01
          A05E303B3661714C8C7945C18345AB329D99164D0983C8216892480D8BE8F37A
          71A16F10E6D474A4A7D961494A80C1A007CB10104D85121AC6987B3FEABDD3F0
          DAA729F712A8039300F4C7AE5F097B9401858B0AE6BEF1C8BC79B3881484268B
          E8705F44A3C745BDBE0FCE7B72618E3320968F06A7D7452A8556930439D085D0
          603D4E77F1EAC65D69391AB4BE493978791B582A726F96A1E499A2259F389293
          F8919161CDACD7588D9662C5292F8A1718909AE680D942BD3799C07211804A13
          2040B9EAC1F1DF09CE77476FD95B297D47C83F22B85E45A37E58526DD6F2E585
          45CF75F5748FEDF8BA717F7E8675E1B37949731A3C026CCE68DC9F6B039F9C02
          5DAC99C64C7D528380EF0A3D3C846A97828A2A7EE91F6DF20585C1D01480A6E1
          A11C67F6E7A190C41EADED2CBFD083B6E956A4E53A0C4F2F76C63CD6A14F373C
          B12C1E31D32CD0C59922B74AE7556AFC327EA80CA0B97BFABA6327865C3EBF7C
          89E854DF1440B717D1661EF3051F8C5FD5A0B5B71FA108B77439936989E7F22D
          69F38D4B16F2EFE42C88A21170E34D02B48BD41C0DE14C877DFDB19F2E350644
          79405588101861425300340F114117C9C535F7224F5E8DC82653BC213E29DEB4
          B3E250BF4CEF7D605880CFEF83284A68EB72A3F55475812C9301C260184156EC
          E969566FF892AF41AE2B26DAADD56A65618C331C387838E870A4439265889234
          3EF77C7108674F1ECFA5E6FA558D151CC9B1725D5D1DB9692FBAD1D856359BDB
          595E213B1C76349D6F45DFC020C668BB6DEBECC2D95F8EE7D06AF72A7A6DB4B7
          A54599D4EC6EDAD399BFE18EBC3CEEE3EDBBC701A170782282BD0769043F57CF
          D618CD0BA3EE6A4F73F3ED019CF9F9DC8BAB4BF39A3A7BCF4C28A90963C85FDA
          E0FAAD99A6CC0B3ECAE76968B83D802D3B5BC7AB2C4FC026D30E944055866B4B
          619A35816199013F94C0E573E7D4DB02AC2E29E1E6143E4C0B944921D02C0C4B
          A209B5CA68AC488157F40CD32F8505FFE868F0DF03FECBB8E3803F019C057530
          27E670310000000049454E44AE426082}
        OnClick = clickCreateProfile
      end
      object TntLabel2: TTntLabel
        Left = 28
        Top = 4
        Width = 118
        Height = 16
        Caption = 'Create a New Profile'
        OnClick = clickCreateProfile
      end
    end
  end
  object pnlAnimate: TGridPanel
    AlignWithMargins = True
    Left = 6
    Top = 6
    Width = 225
    Height = 35
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = aniWait
        Row = 0
      end>
    ParentColor = True
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 2
    Visible = False
    DesignSize = (
      225
      35)
    object aniWait: TAnimate
      Left = 98
      Top = 3
      Width = 28
      Height = 28
      Anchors = []
    end
  end
  object pnlInfomercial: TPanel
    AlignWithMargins = True
    Left = 6
    Top = 295
    Width = 225
    Height = 160
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 12
    Align = alBottom
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    ExplicitTop = 307
    object imgLogo: TImage
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 225
      Height = 71
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      Center = True
      Transparent = True
      Visible = False
      ExplicitLeft = -8
      ExplicitTop = -8
    end
    object txtDisclaimer: TExRichEdit
      AlignWithMargins = True
      Left = 0
      Top = 71
      Width = 225
      Height = 89
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoURLDetect = adDefault
      CustomURLs = <
        item
          Name = 'e-mail'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'http'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'file'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'mailto'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'ftp'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'https'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'gopher'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'nntp'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'prospero'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'telnet'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'news'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'wais'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end>
      LangOptions = [loAutoFont]
      Language = 1033
      ParentColor = True
      ScrollBars = ssVertical
      ShowSelectionBar = False
      TabOrder = 0
      URLColor = clBlue
      URLCursor = crHandPoint
      InputFormat = ifRTF
      OutputFormat = ofRTF
      SelectedInOut = False
      PlainRTF = False
      UndoLimit = 0
      AllowInPlace = False
    end
  end
  object popProfiles: TTntPopupMenu
    Left = 16
    Top = 160
    object mnuModifyProfile: TTntMenuItem
      Caption = 'Modify Profile'
      OnClick = mnuModifyProfileClick
    end
    object mnuRenameProfile: TTntMenuItem
      Caption = 'Rename Profile'
      OnClick = mnuRenameProfileClick
    end
    object mnuDeleteProfile: TTntMenuItem
      Caption = 'Delete Profile'
      OnClick = mnuDeleteProfileClick
    end
  end
end
