object frmProfile: TfrmProfile
  Left = 259
  Top = 184
  Width = 459
  Height = 279
  Caption = 'Contact Properties'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 121
    Top = 0
    Width = 3
    Height = 211
    Cursor = crHSplit
  end
  object PageControl1: TPageControl
    Left = 124
    Top = 0
    Width = 317
    Height = 211
    ActivePage = TabSheet1
    Align = alLeft
    Style = tsFlatButtons
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'General'
      object Label1: TLabel
        Left = 4
        Top = 56
        Width = 19
        Height = 13
        Caption = 'JID:'
      end
      object Label2: TLabel
        Left = 4
        Top = 80
        Width = 25
        Height = 13
        Caption = 'Nick:'
      end
      object lblEmail: TLabel
        Left = 4
        Top = 103
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
      object Label4: TLabel
        Left = 90
        Top = 6
        Width = 34
        Height = 13
        Caption = 'Middle '
      end
      object Label5: TLabel
        Left = 154
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
      object txtJID: TEdit
        Left = 56
        Top = 53
        Width = 185
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object txtNick: TEdit
        Left = 56
        Top = 77
        Width = 185
        Height = 21
        TabOrder = 1
      end
      object optSubscrip: TRadioGroup
        Left = 8
        Top = 128
        Width = 257
        Height = 49
        Caption = 'Subscription Type'
        Columns = 4
        ItemIndex = 0
        Items.Strings = (
          'None'
          'From'
          'To'
          'Both')
        TabOrder = 2
      end
      object txtPriEmail: TEdit
        Left = 56
        Top = 100
        Width = 185
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
      end
      object txtFirst: TEdit
        Left = 14
        Top = 22
        Width = 75
        Height = 21
        ReadOnly = True
        TabOrder = 4
      end
      object txtMiddle: TEdit
        Left = 94
        Top = 22
        Width = 51
        Height = 21
        ReadOnly = True
        TabOrder = 5
      end
      object txtLast: TEdit
        Left = 152
        Top = 22
        Width = 89
        Height = 21
        ReadOnly = True
        TabOrder = 6
      end
      object aniProfile: TAnimate
        Left = 248
        Top = 24
        Width = 16
        Height = 16
        Active = False
        CommonAVI = aviFindFile
        StopFrame = 8
        Visible = False
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'TabSheet7'
      ImageIndex = 6
      object ResListBox: TListBox
        Left = 0
        Top = 25
        Width = 161
        Height = 155
        Align = alLeft
        ItemHeight = 13
        TabOrder = 0
      end
      object Button2: TButton
        Left = 168
        Top = 32
        Width = 75
        Height = 25
        Caption = 'Client Version'
        TabOrder = 1
      end
      object Button3: TButton
        Left = 168
        Top = 64
        Width = 75
        Height = 25
        Caption = 'Client Time'
        TabOrder = 2
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 309
        Height = 25
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Online Resources'
        TabOrder = 3
      end
      object Button4: TButton
        Left = 168
        Top = 96
        Width = 75
        Height = 25
        Caption = 'Last Activity'
        TabOrder = 4
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Groups'
      ImageIndex = 1
      DesignSize = (
        309
        180)
      object GrpListBox: TCheckListBox
        Left = 8
        Top = 8
        Width = 299
        Height = 131
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        TabOrder = 0
      end
      object txtNewGrp: TEdit
        Left = 8
        Top = 149
        Width = 211
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 1
      end
      object Button1: TButton
        Left = 224
        Top = 147
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Add Group'
        TabOrder = 2
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Personal Info.'
      ImageIndex = 2
      object lblURL: TLabel
        Left = 10
        Top = 9
        Width = 69
        Height = 13
        Cursor = crHandPoint
        Caption = 'Personal URL:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 10
        Top = 33
        Width = 58
        Height = 13
        Caption = 'Occupation:'
      end
      object Label6: TLabel
        Left = 10
        Top = 57
        Width = 41
        Height = 13
        Caption = 'Birthday:'
      end
      object Label28: TLabel
        Left = 92
        Top = 78
        Width = 96
        Height = 13
        Caption = 'Format: mm/dd/yyyy'
      end
      object Label8: TLabel
        Left = 7
        Top = 102
        Width = 48
        Height = 13
        Caption = 'Voice Tel:'
      end
      object Label9: TLabel
        Left = 7
        Top = 126
        Width = 38
        Height = 13
        Caption = 'Fax Tel:'
      end
      object txtWeb: TEdit
        Left = 92
        Top = 6
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object cboOcc: TComboBox
        Left = 92
        Top = 30
        Width = 150
        Height = 21
        Enabled = False
        ItemHeight = 13
        TabOrder = 1
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
        Top = 54
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object txtHomeVoice: TEdit
        Left = 91
        Top = 99
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
      object txtHomeFax: TEdit
        Left = 91
        Top = 123
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 4
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
        ReadOnly = True
        TabOrder = 0
      end
      object txtHomeZip: TEdit
        Left = 102
        Top = 102
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object txtHomeCity: TEdit
        Left = 102
        Top = 54
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object txtHomeStreet2: TEdit
        Left = 102
        Top = 30
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
      object txtHomeStreet1: TEdit
        Left = 102
        Top = 6
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 4
      end
      object txtHomeCountry: TComboBox
        Left = 102
        Top = 127
        Width = 150
        Height = 21
        Enabled = False
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
        ReadOnly = True
        TabOrder = 0
      end
      object txtOrgUnit: TEdit
        Left = 102
        Top = 30
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object txtOrgTitle: TEdit
        Left = 102
        Top = 54
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object txtWorkVoice: TEdit
        Left = 102
        Top = 84
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
      object txtWorkFax: TEdit
        Left = 102
        Top = 108
        Width = 150
        Height = 21
        ReadOnly = True
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
        ReadOnly = True
        TabOrder = 0
      end
      object txtWorkZip: TEdit
        Left = 102
        Top = 100
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object txtWorkCity: TEdit
        Left = 102
        Top = 52
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object txtWorkStreet2: TEdit
        Left = 102
        Top = 28
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
      object txtWorkStreet1: TEdit
        Left = 102
        Top = 4
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 4
      end
      object txtWorkCountry: TComboBox
        Left = 102
        Top = 125
        Width = 150
        Height = 21
        Enabled = False
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
    Top = 211
    Width = 451
    Height = 34
    Align = alBottom
    AutoScroll = False
    TabOrder = 1
    inherited Bevel1: TBevel
      Width = 451
    end
    inherited Panel1: TPanel
      Left = 291
      Height = 29
      inherited btnOK: TButton
        OnClick = frameButtons1btnOKClick
      end
      inherited btnCancel: TButton
        OnClick = frameButtons1btnCancelClick
      end
    end
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 121
    Height = 211
    Align = alLeft
    Indent = 19
    TabOrder = 2
    OnClick = TreeView1Click
    Items.Data = {
      040000001F0000000000000000000000FFFFFFFFFFFFFFFF0000000001000000
      06426173696320220000000000000000000000FFFFFFFFFFFFFFFF0000000000
      000000095265736F75726365731F0000000000000000000000FFFFFFFFFFFFFF
      FF00000000000000000647726F757073260000000000000000000000FFFFFFFF
      FFFFFFFF00000000010000000D506572736F6E616C20496E666F200000000000
      000000000000FFFFFFFFFFFFFFFF000000000000000007416464726573732200
      00000000000000000000FFFFFFFFFFFFFFFF000000000100000009576F726B20
      496E666F200000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
      0741646472657373}
  end
end
