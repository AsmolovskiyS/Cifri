object Form1: TForm1
  Left = 230
  Top = 117
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1062#1080#1092#1088#1099
  ClientHeight = 283
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Pole: TImage
    Left = 1
    Top = 1
    Width = 200
    Height = 200
    Align = alCustom
    OnClick = PoleClick
    OnMouseMove = PoleMouseMove
  end
  object Label4: TLabel
    Left = 0
    Top = 0
    Width = 252
    Height = 264
    Align = alClient
    Alignment = taCenter
    Caption = #1061#1086#1076#1086#1074' '#1085#1077#1090'!'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    Visible = False
  end
  object VerPolosa: TImage
    Left = 0
    Top = 0
    Width = 1
    Height = 200
    Align = alCustom
  end
  object GorPolosa: TImage
    Left = 0
    Top = 0
    Width = 200
    Height = 1
    Align = alCustom
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 264
    Width = 252
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = '0:00'
        Width = 45
      end
      item
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 184
    object N1: TMenuItem
      Caption = #1048#1075#1088#1072
      object N2: TMenuItem
        Caption = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
        OnClick = N2Click
      end
      object N5: TMenuItem
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
        OnClick = N5Click
      end
    end
    object N3: TMenuItem
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #1055#1072#1091#1079#1072
      OnClick = N4Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 216
    Top = 232
  end
end
