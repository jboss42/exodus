object frmProfile: TfrmProfile
  Left = 368
  Top = 225
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Contact Properties'
  ClientHeight = 364
  ClientWidth = 454
  Color = clBtnFace
  DefaultMonitor = dmDesktop
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
    Left = 137
    Top = 0
    Height = 330
  end
  object PageControl1: TTntPageControl
    Left = 140
    Top = 0
    Width = 314
    Height = 330
    ActivePage = TabSheet1
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    object TabSheet1: TTntTabSheet
      Caption = 'General'
      object Label1: TTntLabel
        Left = 4
        Top = 56
        Width = 19
        Height = 13
        Caption = 'JID:'
      end
      object Label2: TTntLabel
        Left = 4
        Top = 80
        Width = 25
        Height = 13
        Caption = 'Nick:'
      end
      object lblEmail: TTntLabel
        Left = 4
        Top = 127
        Width = 28
        Height = 13
        Cursor = crHandPoint
        Caption = 'Email:'
        OnClick = lblEmailClick
      end
      object Label7: TTntLabel
        Left = 10
        Top = 6
        Width = 56
        Height = 13
        Caption = 'First (Given)'
      end
      object Label4: TTntLabel
        Left = 90
        Top = 6
        Width = 34
        Height = 13
        Caption = 'Middle '
      end
      object Label5: TTntLabel
        Left = 154
        Top = 6
        Width = 58
        Height = 13
        Caption = 'Last (Family)'
      end
      object lblUpdateNick: TTntLabel
        Left = 56
        Top = 99
        Width = 168
        Height = 13
        Cursor = crHandPoint
        Caption = 'Update nickname based on names.'
        OnClick = btnUpdateNickClick
      end
      object picBox: TPaintBox
        Left = 56
        Top = 216
        Width = 97
        Height = 81
        OnPaint = picBoxPaint
      end
      object TntLabel1: TTntLabel
        Left = 4
        Top = 215
        Width = 36
        Height = 13
        Cursor = crHandPoint
        Caption = 'Picture:'
        OnClick = lblEmailClick
      end
      object aniProfile: TAnimate
        Left = 248
        Top = 24
        Width = 16
        Height = 16
        CommonAVI = aviFindFile
        StopFrame = 8
        Visible = False
      end
      object txtJID: TTntEdit
        Left = 56
        Top = 53
        Width = 185
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object txtNick: TTntEdit
        Left = 56
        Top = 77
        Width = 185
        Height = 21
        TabOrder = 1
      end
      object txtPriEmail: TTntEdit
        Left = 56
        Top = 124
        Width = 185
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
      object txtFirst: TTntEdit
        Left = 14
        Top = 22
        Width = 75
        Height = 21
        ReadOnly = True
        TabOrder = 4
      end
      object txtMiddle: TTntEdit
        Left = 94
        Top = 22
        Width = 51
        Height = 21
        ReadOnly = True
        TabOrder = 5
      end
      object txtLast: TTntEdit
        Left = 152
        Top = 22
        Width = 89
        Height = 21
        ReadOnly = True
        TabOrder = 6
      end
      object optSubscrip: TTntRadioGroup
        Left = 8
        Top = 152
        Width = 257
        Height = 49
        Caption = 'Subscription Type'
        Columns = 4
        ItemIndex = 0
        Items.Strings = (
          'None'
          'To'
          'From'
          'Both')
        TabOrder = 2
        OnClick = SubscriptionOnClick
      end
    end
    object TabSheet7: TTntTabSheet
      Caption = 'Resources'
      ImageIndex = 6
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 306
        Height = 25
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Online Resources'
        TabOrder = 1
      end
      object Panel2: TPanel
        Left = 201
        Top = 25
        Width = 105
        Height = 274
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 2
        object btnVersion: TTntButton
          Left = 6
          Top = 8
          Width = 85
          Height = 25
          Caption = 'Client Version'
          TabOrder = 0
          OnClick = btnVersionClick
        end
        object btnTime: TTntButton
          Left = 6
          Top = 40
          Width = 85
          Height = 25
          Caption = 'Client Time'
          TabOrder = 1
          OnClick = btnVersionClick
        end
        object btnLast: TTntButton
          Left = 6
          Top = 72
          Width = 85
          Height = 25
          Caption = 'Last Activity'
          TabOrder = 2
          OnClick = btnVersionClick
        end
      end
      object ResListBox: TTntListBox
        Left = 0
        Top = 25
        Width = 201
        Height = 274
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object TabSheet2: TTntTabSheet
      Caption = 'Groups'
      ImageIndex = 1
      object GrpListBox: TTntCheckListBox
        Left = 0
        Top = 0
        Width = 306
        Height = 258
        Align = alClient
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
      end
      object Panel3: TPanel
        Left = 0
        Top = 258
        Width = 306
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel3'
        TabOrder = 1
        DesignSize = (
          306
          41)
        object txtNewGrp: TTntEdit
          Left = 5
          Top = 10
          Width = 210
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
        object btnAddGroup: TTntButton
          Left = 223
          Top = 8
          Width = 75
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Add Group'
          TabOrder = 1
          OnClick = btnAddGroupClick
        end
      end
    end
    object TabSheet3: TTntTabSheet
      Caption = 'Personal Info.'
      ImageIndex = 2
      object lblURL: TTntLabel
        Left = 10
        Top = 9
        Width = 69
        Height = 13
        Cursor = crHandPoint
        Caption = 'Personal URL:'
        OnClick = lblEmailClick
      end
      object Label12: TTntLabel
        Left = 10
        Top = 33
        Width = 58
        Height = 13
        Caption = 'Occupation:'
      end
      object Label6: TTntLabel
        Left = 10
        Top = 57
        Width = 41
        Height = 13
        Caption = 'Birthday:'
      end
      object Label28: TTntLabel
        Left = 92
        Top = 78
        Width = 143
        Height = 13
        Caption = 'Typical Format: YYYY-MM-DD'
      end
      object Label8: TTntLabel
        Left = 7
        Top = 102
        Width = 48
        Height = 13
        Caption = 'Voice Tel:'
      end
      object Label9: TTntLabel
        Left = 7
        Top = 126
        Width = 38
        Height = 13
        Caption = 'Fax Tel:'
      end
      object Label3: TTntLabel
        Left = 9
        Top = 145
        Width = 56
        Height = 13
        Caption = 'Description:'
      end
      object txtWeb: TTntEdit
        Left = 92
        Top = 6
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object cboOcc: TTntComboBox
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
      object txtBDay: TTntEdit
        Left = 92
        Top = 54
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object txtHomeVoice: TTntEdit
        Left = 91
        Top = 99
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
      object txtHomeFax: TTntEdit
        Left = 91
        Top = 123
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 4
      end
      object memDesc: TTntMemo
        Left = 16
        Top = 160
        Width = 281
        Height = 97
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 5
        WantTabs = True
      end
    end
    object TabSheet4: TTntTabSheet
      Caption = 'Home'
      ImageIndex = 3
      object Label13: TTntLabel
        Left = 10
        Top = 129
        Width = 39
        Height = 13
        Caption = 'Country:'
      end
      object Label21: TTntLabel
        Left = 10
        Top = 79
        Width = 73
        Height = 13
        Caption = 'State / Region:'
      end
      object Label29: TTntLabel
        Left = 10
        Top = 36
        Width = 50
        Height = 13
        Caption = 'Address 2:'
      end
      object Label30: TTntLabel
        Left = 10
        Top = 12
        Width = 50
        Height = 13
        Caption = 'Address 1:'
      end
      object Label31: TTntLabel
        Left = 10
        Top = 57
        Width = 67
        Height = 13
        Caption = 'City / Locality:'
      end
      object Label32: TTntLabel
        Left = 10
        Top = 103
        Width = 86
        Height = 13
        Caption = 'Zip / Postal Code:'
      end
      object txtHomeState: TTntEdit
        Left = 102
        Top = 78
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object txtHomeZip: TTntEdit
        Left = 102
        Top = 102
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object txtHomeCity: TTntEdit
        Left = 102
        Top = 54
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object txtHomeStreet2: TTntEdit
        Left = 102
        Top = 30
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
      object txtHomeStreet1: TTntEdit
        Left = 102
        Top = 6
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 4
      end
      object txtHomeCountry: TTntComboBox
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
          'Cape Verde  '
          'Cayman Islands  '
          'Central African Republic  '
          'Chad  '
          'Chile  '
          'China  '
          'Christmas Island  '
          'Cocos (Keeling) Islands  '
          'Columbia  '
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
          'Morocco  '
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
    object TabSheet5: TTntTabSheet
      Caption = 'Work'
      ImageIndex = 4
      object Label22: TTntLabel
        Left = 10
        Top = 9
        Width = 78
        Height = 13
        Caption = 'Company Name:'
      end
      object Label23: TTntLabel
        Left = 10
        Top = 33
        Width = 77
        Height = 13
        Caption = 'Org. Unit (Dept):'
      end
      object Label24: TTntLabel
        Left = 10
        Top = 57
        Width = 23
        Height = 13
        Caption = 'Title:'
      end
      object Label19: TTntLabel
        Left = 10
        Top = 87
        Width = 48
        Height = 13
        Caption = 'Voice Tel:'
      end
      object Label20: TTntLabel
        Left = 10
        Top = 111
        Width = 38
        Height = 13
        Caption = 'Fax Tel:'
      end
      object txtOrgName: TTntEdit
        Left = 102
        Top = 6
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object txtOrgUnit: TTntEdit
        Left = 102
        Top = 30
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object txtOrgTitle: TTntEdit
        Left = 102
        Top = 54
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object txtWorkVoice: TTntEdit
        Left = 102
        Top = 84
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
      object txtWorkFax: TTntEdit
        Left = 102
        Top = 108
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 4
      end
    end
    object TabSheet6: TTntTabSheet
      Caption = 'Address'
      ImageIndex = 5
      object Label15: TTntLabel
        Left = 10
        Top = 77
        Width = 73
        Height = 13
        Caption = 'State / Region:'
      end
      object Label16: TTntLabel
        Left = 10
        Top = 127
        Width = 39
        Height = 13
        Caption = 'Country:'
      end
      object Label17: TTntLabel
        Left = 10
        Top = 34
        Width = 50
        Height = 13
        Caption = 'Address 2:'
      end
      object Label18: TTntLabel
        Left = 10
        Top = 10
        Width = 50
        Height = 13
        Caption = 'Address 1:'
      end
      object Label26: TTntLabel
        Left = 10
        Top = 55
        Width = 67
        Height = 13
        Caption = 'City / Locality:'
      end
      object Label14: TTntLabel
        Left = 10
        Top = 101
        Width = 86
        Height = 13
        Caption = 'Zip / Postal Code:'
      end
      object txtWorkState: TTntEdit
        Left = 102
        Top = 76
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object txtWorkZip: TTntEdit
        Left = 102
        Top = 100
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object txtWorkCity: TTntEdit
        Left = 102
        Top = 52
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object txtWorkStreet2: TTntEdit
        Left = 102
        Top = 28
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
      object txtWorkStreet1: TTntEdit
        Left = 102
        Top = 4
        Width = 150
        Height = 21
        ReadOnly = True
        TabOrder = 4
      end
      object txtWorkCountry: TTntComboBox
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
          'Cape Verde  '
          'Cayman Islands  '
          'Central African Republic  '
          'Chad  '
          'Chile  '
          'China  '
          'Christmas Island  '
          'Cocos (Keeling) Islands  '
          'Columbia  '
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
          'Morocco  '
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
    Top = 330
    Width = 454
    Height = 34
    Align = alBottom
    TabOrder = 1
    TabStop = True
    ExplicitTop = 330
    ExplicitWidth = 454
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 454
      Height = 34
      ExplicitWidth = 454
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 454
        ExplicitWidth = 454
      end
      inherited Panel1: TPanel
        Left = 294
        Height = 29
        ExplicitLeft = 294
        ExplicitHeight = 29
        inherited btnOK: TTntButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object TreeView1: TTntTreeView
    Left = 0
    Top = 0
    Width = 137
    Height = 330
    Align = alLeft
    BevelWidth = 0
    Indent = 19
    ReadOnly = True
    TabOrder = 2
    OnChange = TreeView1Change
    OnClick = TreeView1Click
    Items.NodeData = {
      0104000000230000000000000000000000FFFFFFFFFFFFFFFF00000000010000
      0005420061007300690063002B0000000000000000000000FFFFFFFFFFFFFFFF
      0000000000000000095200650073006F00750072006300650073002500000000
      00000000000000FFFFFFFFFFFFFFFF000000000000000006470072006F007500
      70007300410000000000000000000000FFFFFFFFFFFFFFFF0000000001000000
      1450006500720073006F006E0061006C00200049006E0066006F0072006D0061
      00740069006F006E00270000000000000000000000FFFFFFFFFFFFFFFF000000
      0000000000074100640064007200650073007300390000000000000000000000
      FFFFFFFFFFFFFFFF00000000010000001057006F0072006B00200049006E0066
      006F0072006D006100740069006F006E00270000000000000000000000FFFFFF
      FFFFFFFFFF0000000000000000074100640064007200650073007300}
    Items.Utf8Data = {
      04000000210000000000000000000000FFFFFFFFFFFFFFFF0000000001000000
      08EFBBBF4261736963250000000000000000000000FFFFFFFFFFFFFFFF000000
      00000000000CEFBBBF5265736F7572636573220000000000000000000000FFFF
      FFFFFFFFFFFF000000000000000009EFBBBF47726F7570733000000000000000
      00000000FFFFFFFFFFFFFFFF000000000100000017EFBBBF506572736F6E616C
      20496E666F726D6174696F6E230000000000000000000000FFFFFFFFFFFFFFFF
      00000000000000000AEFBBBF416464726573732C0000000000000000000000FF
      FFFFFFFFFFFFFF000000000100000013EFBBBF576F726B20496E666F726D6174
      696F6E230000000000000000000000FFFFFFFFFFFFFFFF00000000000000000A
      EFBBBF41646472657373}
  end
end
