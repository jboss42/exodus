object frmVCard: TfrmVCard
  Left = 280
  Top = 415
  Width = 450
  Height = 360
  Caption = 'My Profile'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 121
    Top = 0
    Height = 297
  end
  object PageControl1: TPageControl
    Left = 124
    Top = 0
    Width = 318
    Height = 297
    ActivePage = TabSheet3
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'General'
      object Label2: TLabel
        Left = 4
        Top = 72
        Width = 25
        Height = 13
        Caption = 'Nick:'
      end
      object lblEmail: TLabel
        Left = 4
        Top = 95
        Width = 28
        Height = 13
        Cursor = crHandPoint
        Caption = 'Email:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 2
        Top = 6
        Width = 56
        Height = 13
        Caption = 'First (Given)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 2
        Top = 38
        Width = 58
        Height = 13
        Caption = 'Last (Family)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblURL: TLabel
        Left = 4
        Top = 124
        Width = 26
        Height = 13
        Cursor = crHandPoint
        Caption = 'Web:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object txtNick: TTntEdit
        Left = 56
        Top = 69
        Width = 187
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object txtPriEmail: TTntEdit
        Left = 56
        Top = 95
        Width = 187
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object txtFirst: TTntEdit
        Left = 73
        Top = 6
        Width = 168
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object txtLast: TTntEdit
        Left = 73
        Top = 33
        Width = 169
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object txtWeb: TTntEdit
        Left = 56
        Top = 121
        Width = 187
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Personal Info.'
      ImageIndex = 2
      object Label12: TLabel
        Left = 4
        Top = 9
        Width = 58
        Height = 13
        Caption = 'Occupation:'
      end
      object Label6: TLabel
        Left = 4
        Top = 35
        Width = 41
        Height = 13
        Caption = 'Birthday:'
      end
      object Label28: TLabel
        Left = 92
        Top = 56
        Width = 143
        Height = 13
        Caption = 'Typical Format: YYYY-MM-DD'
      end
      object Label8: TLabel
        Left = 1
        Top = 86
        Width = 48
        Height = 13
        Caption = 'Voice Tel:'
      end
      object Label9: TLabel
        Left = 1
        Top = 113
        Width = 38
        Height = 13
        Caption = 'Fax Tel:'
      end
      object Label1: TLabel
        Left = 1
        Top = 137
        Width = 56
        Height = 13
        Caption = 'Description:'
      end
      object cboOcc: TTntComboBox
        Left = 92
        Top = 6
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        TabOrder = 0
        Items.WideStrings = (
          'Accounting/Finance'
          'Computer related (IS, MIS, DP)'
          'Computer related (WWW)'
          'Consulting'
          'Education/training'
          'Engineering'
          'Executive/senior management'
          'General administrative/supervisory'
          'Government/Military'
          'Manufacturing/production/operations'
          'Professional services (medical, legal, etc.)'
          'Research and development'
          'Retired'
          'Sales/marketing/advertising'
          'Self-employed/owner'
          'Student'
          'Unemployed/Between Jobs')
      end
      object txtBDay: TTntEdit
        Left = 92
        Top = 32
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object txtHomeVoice: TTntEdit
        Left = 91
        Top = 83
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object txtHomeFax: TTntEdit
        Left = 91
        Top = 110
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object memDesc: TTntMemo
        Left = 8
        Top = 152
        Width = 289
        Height = 105
        ScrollBars = ssVertical
        TabOrder = 4
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Home'
      ImageIndex = 3
      object Label13: TLabel
        Left = 10
        Top = 139
        Width = 39
        Height = 13
        Caption = 'Country:'
      end
      object Label21: TLabel
        Left = 10
        Top = 85
        Width = 73
        Height = 13
        Caption = 'State / Region:'
      end
      object Label29: TLabel
        Left = 10
        Top = 38
        Width = 50
        Height = 13
        Caption = 'Address 2:'
      end
      object Label30: TLabel
        Left = 10
        Top = 12
        Width = 50
        Height = 13
        Caption = 'Address 1:'
      end
      object Label31: TLabel
        Left = 10
        Top = 61
        Width = 67
        Height = 13
        Caption = 'City / Locality:'
      end
      object Label32: TLabel
        Left = 10
        Top = 111
        Width = 86
        Height = 13
        Caption = 'Zip / Postal Code:'
      end
      object txtHomeCountry: TTntComboBox
        Left = 102
        Top = 137
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        TabOrder = 5
        Text = 'United States  '
        Items.WideStrings = (
          'Afghanistan  '
          'Albania  '
          'Algeria  '
          'American Samoa  '
          'Andorra  '
          'Angola  '
          'Anguilla  '
          'Antarctica  '
          'Antigua and Barbuda  '
          'Argentina  '
          'Armenia  '
          'Aruba  '
          'Australia  '
          'Austria  '
          'Azerbaijan  '
          'Bahamas  '
          'Bahrain  '
          'Bangladesh  '
          'Barbados  '
          'Belarus  '
          'Belgium  '
          'Belize  '
          'Benin  '
          'Bermuda  '
          'Bhutan  '
          'Bolivia  '
          'Bosnia and Herzogovina  '
          'Botswana  '
          'Bouvet Island  '
          'Brazil  '
          'British Indian Ocean Territory  '
          'Brunei Darussalam  '
          'Bulgaria  '
          'Burkina Faso  '
          'Burundi  '
          'Cambodia  '
          'Cameroon  '
          'Canada  '
          'Care Verde  '
          'Cayman Islands  '
          'Central African Republic  '
          'Chad  '
          'Chile  '
          'China  '
          'Christmas Island  '
          'Cocos (Keeling) '
          'Islands  '
          'Colobmia  '
          'Comoros  '
          'Congo (Republic of) '
          'Congo (Democratic Republic of) '
          'Cook Islands  '
          'Costa Rica  '
          'Cote d'#39'Ivoire  '
          'Croatia  '
          'Cuba  '
          'Cyprus  '
          'Czech Republic  '
          'Denmark  '
          'Djibouti  '
          'Dominica  '
          'Dominican Republic  '
          'East Timor  '
          'Ecuador  '
          'Egypt  '
          'El Salvador  '
          'Equatorial Guinea  '
          'Eritrea  '
          'Estonia  '
          'Ethiopia  '
          'Falkland Islands (Malvinas) '
          'Faroe Islands  '
          'Fiji  '
          'Finland  '
          'France  '
          'French Guiana  '
          'French Polynesia  '
          'French Southern Territories  '
          'Gabon  '
          'Gambia  '
          'Georgia  '
          'Germany  '
          'Ghana  '
          'Gibraltar  '
          'Greece  '
          'Greenland  '
          'Grenada  '
          'Guadeloupe  '
          'Guam  '
          'Guatemala  '
          'Guinea  '
          'Guinea-Bissau  '
          'Guyana  '
          'Haiti  '
          'Heard Island and McDonald Islands  '
          'Holy See (Vatican City State) '
          'Honduras  '
          'Hong Kong  '
          'Hungary  '
          'Iceland  '
          'India  '
          'Indonesia  '
          'Iran, Islamic Republic of  '
          'Iraq  '
          'Ireland  '
          'Israel  '
          'Italy  '
          'Jamaica  '
          'Japan  '
          'Jordan  '
          'Kazakhstan  '
          'Kenya  '
          'Kiribati  '
          'Korea, Democratic People'#39's Republic of  '
          'Korea, Republic of  '
          'Kuwait  '
          'Kyrgyzstan  '
          'Lao People'#39's Democratic Republic  '
          'Latvia  '
          'Lebanon  '
          'Lesotho  '
          'Liberia  '
          'Libyan Arab Jamahiriya  '
          'Liechtenstein  '
          'Lithuania  '
          'Luxembourg  '
          'Macau  '
          'Macedonia  '
          'Madagascar  '
          'Malawi  '
          'Malaysia  '
          'Maldives  '
          'Mali  '
          'Malta  '
          'Marshall Islands  '
          'Martinique  '
          'Mauritania  '
          'Mauritius  '
          'Mayotte  '
          'Mexico  '
          'Micronesia, Federated States of  '
          'Moldova, Republic of  '
          'Monaco  '
          'Mongolia  '
          'Montserrat  '
          'Morocoo  '
          'Mozambique  '
          'Myanmar  '
          'Namibia  '
          'Nauru  '
          'Nepal  '
          'Netherlands  '
          'Netherlands Antilles  '
          'New Caledonia  '
          'New Zealand  '
          'Nicaragua  '
          'Niger  '
          'Nigeria  '
          'Niue  '
          'Norfolk Island  '
          'Nothern Mariana Islands  '
          'Norway  '
          'Oman  '
          'Pakistan  '
          'Palau  '
          'Palestinian Territory, Occupied  '
          'Panama  '
          'Papua New Guinea  '
          'Paraguay  '
          'Peru  '
          'Philippines  '
          'Pitcairn  '
          'Poland  '
          'Portugal  '
          'Puerto Rico  '
          'Qatar  '
          'Reunion  '
          'Romania  '
          'Russian Federation  '
          'Rwanda  '
          'Saint Helena  '
          'Saint Kitts and Nevis  '
          'Saint Lucia  '
          'Saint Pierre and Miquelon  '
          'Saint Vincent and the Grenadines  '
          'Samoa  '
          'San Marino  '
          'Sao Tome and Principe  '
          'Saudi Arabia  '
          'Senegal  '
          'Seychelles  '
          'Sierra Leone  '
          'Singapore  '
          'Slovakia  '
          'Slovenia  '
          'Solomon Islands  '
          'Somalia  '
          'South Africa  '
          'South Georgia and the South Sandwich Islands  '
          'Spain  '
          'Sri Lanka  '
          'Sudan  '
          'Suriname  '
          'Svalbard and Jan Mayen Islands  '
          'Swaziland  '
          'Sweden  '
          'Switzerland  '
          'Syrian Arab Republic  '
          'Taiwan, Province of China  '
          'Tajikistan  '
          'Tanzania, United Republic of  '
          'Thailand  '
          'Togo  '
          'Tokelau  '
          'Tonga  '
          'Trinidad and Tobago  '
          'Tunisia  '
          'Turkey  '
          'Turkmenistan  '
          'Turks and Caicos Islands  '
          'Tuvalu  '
          'Uganda  '
          'Ukraine  '
          'United Arab Emirates  '
          'United Kingdom  '
          'United States  '
          'United States Minor Outlying Islands  '
          'Uruguay  '
          'Uzbekistan  '
          'Vanuatu  '
          'Venezuela  '
          'Vietnam  '
          'Virgin Islands, British  '
          'Virgin Islands, U.S.  '
          'Wallis and Futuna  '
          'Western Sahara  '
          'Yemen  '
          'Yugoslavia  '
          'Zambia  '
          'Zimbabwe  ')
      end
      object txtHomeState: TTntEdit
        Left = 102
        Top = 84
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object txtHomeZip: TTntEdit
        Left = 102
        Top = 110
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object txtHomeCity: TTntEdit
        Left = 102
        Top = 58
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object txtHomeStreet2: TTntEdit
        Left = 102
        Top = 32
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object txtHomeStreet1: TTntEdit
        Left = 102
        Top = 6
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Work'
      ImageIndex = 4
      object Label22: TLabel
        Left = 10
        Top = 9
        Width = 78
        Height = 13
        Caption = 'Company Name:'
      end
      object Label23: TLabel
        Left = 10
        Top = 35
        Width = 77
        Height = 13
        Caption = 'Org. Unit (Dept):'
      end
      object Label24: TLabel
        Left = 10
        Top = 61
        Width = 23
        Height = 13
        Caption = 'Title:'
      end
      object Label19: TLabel
        Left = 10
        Top = 91
        Width = 48
        Height = 13
        Caption = 'Voice Tel:'
      end
      object Label20: TLabel
        Left = 10
        Top = 117
        Width = 38
        Height = 13
        Caption = 'Fax Tel:'
      end
      object txtOrgName: TTntEdit
        Left = 102
        Top = 6
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object txtOrgUnit: TTntEdit
        Left = 102
        Top = 32
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object txtOrgTitle: TTntEdit
        Left = 102
        Top = 58
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object txtWorkVoice: TTntEdit
        Left = 102
        Top = 88
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object txtWorkFax: TTntEdit
        Left = 102
        Top = 114
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'TabSheet6'
      ImageIndex = 5
      object Label15: TLabel
        Left = 10
        Top = 83
        Width = 73
        Height = 13
        Caption = 'State / Region:'
      end
      object Label16: TLabel
        Left = 10
        Top = 135
        Width = 39
        Height = 13
        Caption = 'Country:'
      end
      object Label17: TLabel
        Left = 10
        Top = 36
        Width = 50
        Height = 13
        Caption = 'Address 2:'
      end
      object Label18: TLabel
        Left = 10
        Top = 10
        Width = 50
        Height = 13
        Caption = 'Address 1:'
      end
      object Label26: TLabel
        Left = 10
        Top = 59
        Width = 67
        Height = 13
        Caption = 'City / Locality:'
      end
      object Label14: TLabel
        Left = 10
        Top = 108
        Width = 86
        Height = 13
        Caption = 'Zip / Postal Code:'
      end
      object txtWorkCountry: TTntComboBox
        Left = 102
        Top = 133
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        TabOrder = 5
        Text = 'United States  '
        Items.WideStrings = (
          'Afghanistan  '
          'Albania  '
          'Algeria  '
          'American Samoa  '
          'Andorra  '
          'Angola  '
          'Anguilla  '
          'Antarctica  '
          'Antigua and Barbuda  '
          'Argentina  '
          'Armenia  '
          'Aruba  '
          'Australia  '
          'Austria  '
          'Azerbaijan  '
          'Bahamas  '
          'Bahrain  '
          'Bangladesh  '
          'Barbados  '
          'Belarus  '
          'Belgium  '
          'Belize  '
          'Benin  '
          'Bermuda  '
          'Bhutan  '
          'Bolivia  '
          'Bosnia and Herzogovina  '
          'Botswana  '
          'Bouvet Island  '
          'Brazil  '
          'British Indian Ocean Territory  '
          'Brunei Darussalam  '
          'Bulgaria  '
          'Burkina Faso  '
          'Burundi  '
          'Cambodia  '
          'Cameroon  '
          'Canada  '
          'Care Verde  '
          'Cayman Islands  '
          'Central African Republic  '
          'Chad  '
          'Chile  '
          'China  '
          'Christmas Island  '
          'Cocos (Keeling) '
          'Islands  '
          'Colobmia  '
          'Comoros  '
          'Congo (Republic of) '
          'Congo (Democratic Republic of) '
          'Cook Islands  '
          'Costa Rica  '
          'Cote d'#39'Ivoire  '
          'Croatia  '
          'Cuba  '
          'Cyprus  '
          'Czech Republic  '
          'Denmark  '
          'Djibouti  '
          'Dominica  '
          'Dominican Republic  '
          'East Timor  '
          'Ecuador  '
          'Egypt  '
          'El Salvador  '
          'Equatorial Guinea  '
          'Eritrea  '
          'Estonia  '
          'Ethiopia  '
          'Falkland Islands (Malvinas) '
          'Faroe Islands  '
          'Fiji  '
          'Finland  '
          'France  '
          'French Guiana  '
          'French Polynesia  '
          'French Southern Territories  '
          'Gabon  '
          'Gambia  '
          'Georgia  '
          'Germany  '
          'Ghana  '
          'Gibraltar  '
          'Greece  '
          'Greenland  '
          'Grenada  '
          'Guadeloupe  '
          'Guam  '
          'Guatemala  '
          'Guinea  '
          'Guinea-Bissau  '
          'Guyana  '
          'Haiti  '
          'Heard Island and McDonald Islands  '
          'Holy See (Vatican City State) '
          'Honduras  '
          'Hong Kong  '
          'Hungary  '
          'Iceland  '
          'India  '
          'Indonesia  '
          'Iran, Islamic Republic of  '
          'Iraq  '
          'Ireland  '
          'Israel  '
          'Italy  '
          'Jamaica  '
          'Japan  '
          'Jordan  '
          'Kazakhstan  '
          'Kenya  '
          'Kiribati  '
          'Korea, Democratic People'#39's Republic of  '
          'Korea, Republic of  '
          'Kuwait  '
          'Kyrgyzstan  '
          'Lao People'#39's Democratic Republic  '
          'Latvia  '
          'Lebanon  '
          'Lesotho  '
          'Liberia  '
          'Libyan Arab Jamahiriya  '
          'Liechtenstein  '
          'Lithuania  '
          'Luxembourg  '
          'Macau  '
          'Macedonia  '
          'Madagascar  '
          'Malawi  '
          'Malaysia  '
          'Maldives  '
          'Mali  '
          'Malta  '
          'Marshall Islands  '
          'Martinique  '
          'Mauritania  '
          'Mauritius  '
          'Mayotte  '
          'Mexico  '
          'Micronesia, Federated States of  '
          'Moldova, Republic of  '
          'Monaco  '
          'Mongolia  '
          'Montserrat  '
          'Morocoo  '
          'Mozambique  '
          'Myanmar  '
          'Namibia  '
          'Nauru  '
          'Nepal  '
          'Netherlands  '
          'Netherlands Antilles  '
          'New Caledonia  '
          'New Zealand  '
          'Nicaragua  '
          'Niger  '
          'Nigeria  '
          'Niue  '
          'Norfolk Island  '
          'Nothern Mariana Islands  '
          'Norway  '
          'Oman  '
          'Pakistan  '
          'Palau  '
          'Palestinian Territory, Occupied  '
          'Panama  '
          'Papua New Guinea  '
          'Paraguay  '
          'Peru  '
          'Philippines  '
          'Pitcairn  '
          'Poland  '
          'Portugal  '
          'Puerto Rico  '
          'Qatar  '
          'Reunion  '
          'Romania  '
          'Russian Federation  '
          'Rwanda  '
          'Saint Helena  '
          'Saint Kitts and Nevis  '
          'Saint Lucia  '
          'Saint Pierre and Miquelon  '
          'Saint Vincent and the Grenadines  '
          'Samoa  '
          'San Marino  '
          'Sao Tome and Principe  '
          'Saudi Arabia  '
          'Senegal  '
          'Seychelles  '
          'Sierra Leone  '
          'Singapore  '
          'Slovakia  '
          'Slovenia  '
          'Solomon Islands  '
          'Somalia  '
          'South Africa  '
          'South Georgia and the South Sandwich Islands  '
          'Spain  '
          'Sri Lanka  '
          'Sudan  '
          'Suriname  '
          'Svalbard and Jan Mayen Islands  '
          'Swaziland  '
          'Sweden  '
          'Switzerland  '
          'Syrian Arab Republic  '
          'Taiwan, Province of China  '
          'Tajikistan  '
          'Tanzania, United Republic of  '
          'Thailand  '
          'Togo  '
          'Tokelau  '
          'Tonga  '
          'Trinidad and Tobago  '
          'Tunisia  '
          'Turkey  '
          'Turkmenistan  '
          'Turks and Caicos Islands  '
          'Tuvalu  '
          'Uganda  '
          'Ukraine  '
          'United Arab Emirates  '
          'United Kingdom  '
          'United States  '
          'United States Minor Outlying Islands  '
          'Uruguay  '
          'Uzbekistan  '
          'Vanuatu  '
          'Venezuela  '
          'Vietnam  '
          'Virgin Islands, British  '
          'Virgin Islands, U.S.  '
          'Wallis and Futuna  '
          'Western Sahara  '
          'Yemen  '
          'Yugoslavia  '
          'Zambia  '
          'Zimbabwe  ')
      end
      object txtWorkState: TTntEdit
        Left = 102
        Top = 82
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object txtWorkZip: TTntEdit
        Left = 102
        Top = 107
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object txtWorkCity: TTntEdit
        Left = 102
        Top = 56
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object txtWorkStreet2: TTntEdit
        Left = 102
        Top = 30
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object txtWorkStreet1: TTntEdit
        Left = 102
        Top = 4
        Width = 150
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 297
    Width = 442
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 1
    inherited Panel2: TPanel
      Width = 442
      Height = 34
      inherited Bevel1: TBevel
        Width = 442
      end
      inherited Panel1: TPanel
        Left = 282
        Height = 29
        inherited btnOK: TButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 121
    Height = 297
    Align = alLeft
    Indent = 19
    TabOrder = 2
    OnClick = TreeView1Click
    Items.Data = {
      030000001F0000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
      06426173696320260000000000000000000000FFFFFFFFFFFFFFFF0000000001
      0000000D506572736F6E616C20496E666F200000000000000000000000FFFFFF
      FFFFFFFFFF000000000000000007416464726573732200000000000000000000
      00FFFFFFFFFFFFFFFF000000000100000009576F726B20496E666F2000000000
      00000000000000FFFFFFFFFFFFFFFF00000000000000000741646472657373}
  end
end
