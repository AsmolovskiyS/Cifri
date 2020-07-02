object Form3: TForm3
  Left = 600
  Top = 120
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1086#1088#1081#1082#1080
  ClientHeight = 152
  ClientWidth = 199
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 105
    Caption = #1056#1072#1079#1084#1077#1088' '#1103#1095#1077#1081#1082#1080
    TabOrder = 0
    object Min: TSpeedButton
      Left = 9
      Top = 56
      Width = 73
      Height = 25
      Caption = #1059#1084#1077#1085#1100#1096#1080#1090#1100
      OnClick = MinClick
    end
    object Plus: TSpeedButton
      Left = 9
      Top = 24
      Width = 73
      Height = 25
      Caption = #1059#1074#1077#1083#1080#1095#1080#1090#1100
      OnClick = PlusClick
    end
    object Panel1: TPanel
      Left = 91
      Top = 11
      Width = 88
      Height = 88
      BevelOuter = bvLowered
      BiDiMode = bdLeftToRight
      BorderWidth = 1
      Ctl3D = True
      DragKind = dkDock
      ParentBiDiMode = False
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 0
      object Image1: TImage
        Left = 13
        Top = 16
        Width = 60
        Height = 60
      end
    end
  end
  object Button1: TButton
    Left = 8
    Top = 120
    Width = 185
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
end
