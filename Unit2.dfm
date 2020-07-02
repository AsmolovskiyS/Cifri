object Form2: TForm2
  Left = 260
  Top = 173
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1086#1074#1072#1103' '#1080#1075#1072#1088
  ClientHeight = 189
  ClientWidth = 232
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 9
    Top = 8
    Width = 216
    Height = 73
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1103#1095#1077#1077#1082' ('#1086#1090' 5'#1093'5 '#1076#1086' 25'#1093'25)'
    TabOrder = 0
    object Colon: TLabeledEdit
      Left = 10
      Top = 40
      Width = 89
      Height = 21
      EditLabel.Width = 81
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1080
      TabOrder = 0
      Text = '15'
    end
    object Rows: TLabeledEdit
      Left = 115
      Top = 40
      Width = 89
      Height = 21
      EditLabel.Width = 70
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1086' '#1074#1077#1088#1090#1080#1082#1072#1083#1080
      TabOrder = 1
      Text = '12'
    end
  end
  object BitBtn1: TBitBtn
    Left = 10
    Top = 160
    Width = 93
    Height = 25
    Caption = #1053#1072#1095#1072#1090#1100' '#1085#1086#1074#1091#1102
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 124
    Top = 160
    Width = 101
    Height = 25
    Caption = #1042#1077#1088#1085#1091#1090#1089#1103' '#1074' '#1080#1075#1088#1091
    TabOrder = 2
    OnClick = BitBtn2Click
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 88
    Width = 217
    Height = 65
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1094#1080#1092#1088
    Items.Strings = (
      #1062#1080#1092#1088#1099' '#1087#1086' '#1087#1086#1088#1103#1076#1082#1091
      #1062#1080#1092#1088#1099' '#1074' '#1088#1072#1079#1073#1088#1086#1089)
    TabOrder = 3
  end
end
