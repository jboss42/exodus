object frmVCard: TfrmVCard
  Left = 277
  Top = 215
  Width = 424
  Height = 283
  Caption = 'My Profile'
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
  object Splitter1: TSplitter
    Left = 121
    Top = 0
    Width = 3
    Height = 217
    Cursor = crHSplit
  end
  object PageControl1: TPageControl
    Left = 124
    Top = 0
    Width = 292
    Height = 217
    ActivePage = TabSheet1
    Align = alClient
    Style = tsFlatButtons
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'General'
      object Label2: TLabel
        Left = 4
        Top = 56
        Width = 25
        Height = 13
        Caption = 'Nick:'
      end
      object lblEmail: TLabel
        Left = 4
        Top = 79
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
        Left = 10
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
        Left = 98
        Top = 6
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
        Top = 105
        Width = 36
        Height = 13
        Cursor = crHandPoint
        Caption = 'WWW:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object txtNick: TEdit
        Left = 56
        Top = 53
        Width = 185
        Height = 21
        TabOrder = 2
      end
      object txtPriEmail: TEdit
        Left = 56
        Top = 76
        Width = 185
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object txtFirst: TEdit
        Left = 14
        Top = 22
        Width = 75
        Height = 21
        TabOrder = 0
      end
      object txtLast: TEdit
        Left = 96
        Top = 22
        Width = 89
        Height = 21
        TabOrder = 1
      end
      object txtWeb: TEdit
        Left = 57
        Top = 102
        Width = 184
        Height = 21
        TabOrder = 4
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Personal Info.'
      ImageIndex = 2
      object Label12: TLabel
        Left = 10
        Top = 9
        Width = 58
        Height = 13
        Caption = 'Occupation:'
      end
      object Label6: TLabel
        Left = 10
        Top = 33
        Width = 41
        Height = 13
        Caption = 'Birthday:'
      end
      object Label28: TLabel
        Left = 92
        Top = 54
        Width = 96
        Height = 13
        Caption = 'Format: mm/dd/yyyy'
      end
      object Label8: TLabel
        Left = 7
        Top = 78
        Width = 48
        Height = 13
        Caption = 'Voice Tel:'
      end
      object Label9: TLabel
        Left = 7
        Top = 102
        Width = 38
        Height = 13
        Caption = 'Fax Tel:'
      end
      object cboOcc: TComboBox
        Left = 92
        Top = 6
        Width = 150
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
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
      object txtBDay: TEdit
        Left = 92
        Top = 30
        Width = 150
        Height = 21
        TabOrder = 1
      end
      object txtHomeVoice: TEdit
        Left = 91
        Top = 75
        Width = 150
        Height = 21
        TabOrder = 2
      end
      object txtHomeFax: TEdit
        Left = 91
        Top = 99
        Width = 150
        Height = 21
        TabOrder = 3
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Home'
      ImageIndex = 3
      object Label13: TLabel
        Left = 10
        Top = 129
        Width = 39
        Height = 13
        Caption = 'Country:'
      end
      object Label21: TLabel
        Left = 10
        Top = 79
        Width = 73
        Height = 13
        Caption = 'State / Region:'
      end
      object Label29: TLabel
        Left = 10
        Top = 36
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
        Top = 57
        Width = 67
        Height = 13
        Caption = 'City / Locality:'
      end
      object Label32: TLabel
        Left = 10
        Top = 103
        Width = 86
        Height = 13
        Caption = 'Zip / Postal Code:'
      end
      object txtHomeState: TEdit
        Left = 102
        Top = 78
        Width = 150
        Height = 21
        TabOrder = 3
      end
      object txtHomeZip: TEdit
        Left = 102
        Top = 102
        Width = 150
        Height = 21
        TabOrder = 4
      end
      object txtHomeCity: TEdit
        Left = 102
        Top = 54
        Width = 150
        Height = 21
        TabOrder = 2
      end
      object txtHomeStreet2: TEdit
        Left = 102
        Top = 30
        Width = 150
        Height = 21
        TabOrder = 1
      end
      object txtHomeStreet1: TEdit
        Left = 102
        Top = 6
        Width = 150
        Height = 21
        TabOrder = 0
      end
      object txtHomeCountry: TComboBox
        Left = 102
        Top = 127
        Width = 150
        Height = 21
        ItemHeight = 13
        TabOrder = 5
        Text = 'United States  '
        Items.Strings = (
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
          'Austia  '
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
        Top = 33
        Width = 77
        Height = 13
        Caption = 'Org. Unit (Dept):'
      end
      object Label24: TLabel
        Left = 10
        Top = 57
        Width = 23
        Height = 13
        Caption = 'Title:'
      end
      object Label19: TLabel
        Left = 10
        Top = 87
        Width = 48
        Height = 13
        Caption = 'Voice Tel:'
      end
      object Label20: TLabel
        Left = 10
        Top = 111
        Width = 38
        Height = 13
        Caption = 'Fax Tel:'
      end
      object txtOrgName: TEdit
        Left = 102
        Top = 6
        Width = 150
        Height = 21
        TabOrder = 0
      end
      object txtOrgUnit: TEdit
        Left = 102
        Top = 30
        Width = 150
        Height = 21
        TabOrder = 1
      end
      object txtOrgTitle: TEdit
        Left = 102
        Top = 54
        Width = 150
        Height = 21
        TabOrder = 2
      end
      object txtWorkVoice: TEdit
        Left = 102
        Top = 84
        Width = 150
        Height = 21
        TabOrder = 3
      end
      object txtWorkFax: TEdit
        Left = 102
        Top = 108
        Width = 150
        Height = 21
        TabOrder = 4
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'TabSheet6'
      ImageIndex = 5
      object Label15: TLabel
        Left = 10
        Top = 77
        Width = 73
        Height = 13
        Caption = 'State / Region:'
      end
      object Label16: TLabel
        Left = 10
        Top = 127
        Width = 39
        Height = 13
        Caption = 'Country:'
      end
      object Label17: TLabel
        Left = 10
        Top = 34
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
        Top = 55
        Width = 67
        Height = 13
        Caption = 'City / Locality:'
      end
      object Label14: TLabel
        Left = 10
        Top = 101
        Width = 86
        Height = 13
        Caption = 'Zip / Postal Code:'
      end
      object txtWorkState: TEdit
        Left = 102
        Top = 76
        Width = 150
        Height = 21
        TabOrder = 3
      end
      object txtWorkZip: TEdit
        Left = 102
        Top = 100
        Width = 150
        Height = 21
        TabOrder = 4
      end
      object txtWorkCity: TEdit
        Left = 102
        Top = 52
        Width = 150
        Height = 21
        TabOrder = 2
      end
      object txtWorkStreet2: TEdit
        Left = 102
        Top = 28
        Width = 150
        Height = 21
        TabOrder = 1
      end
      object txtWorkStreet1: TEdit
        Left = 102
        Top = 4
        Width = 150
        Height = 21
        TabOrder = 0
      end
      object txtWorkCountry: TComboBox
        Left = 102
        Top = 125
        Width = 150
        Height = 21
        ItemHeight = 13
        TabOrder = 5
        Text = 'United States  '
        Items.Strings = (
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
          'Austia  '
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
    end
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 217
    Width = 416
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 1
    inherited Bevel1: TBevel
      Width = 416
    end
    inherited Panel1: TPanel
      Left = 256
      inherited btnOK: TButton
        Top = 1
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        Top = 1
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 121
    Height = 217
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
