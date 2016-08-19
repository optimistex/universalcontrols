object Form1: TForm1
  Left = 192
  Top = 114
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Text Analyzer'
  ClientHeight = 446
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 464
    Top = 48
    Width = 42
    Height = 13
    Caption = #1057#1090#1088#1086#1082': 0'
  end
  object Label2: TLabel
    Left = 464
    Top = 72
    Width = 63
    Height = 13
    Caption = #1057#1080#1084#1074#1086#1083#1086#1074': 0'
  end
  object Label3: TLabel
    Left = 464
    Top = 96
    Width = 140
    Height = 13
    Caption = #1053#1077#1087#1088#1086#1073#1077#1083#1100#1085#1099#1093' '#1089#1080#1084#1074#1086#1083#1086#1074': 0'
  end
  object Label4: TLabel
    Left = 464
    Top = 120
    Width = 37
    Height = 13
    Caption = #1057#1083#1086#1074': 0'
  end
  object Label5: TLabel
    Left = 464
    Top = 144
    Width = 82
    Height = 13
    Caption = #1055#1088#1077#1076#1083#1086#1078#1077#1085#1080#1081': 0'
  end
  object Memo1: TMemo
    Left = 8
    Top = 40
    Width = 449
    Height = 401
    ScrollBars = ssBoth
    TabOrder = 0
    OnChange = Memo1Change
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 336
    Top = 16
    Width = 121
    Height = 17
    Caption = #1055#1077#1088#1077#1085#1086#1089' '#1087#1086' '#1089#1083#1086#1074#1072#1084
    TabOrder = 2
    OnClick = CheckBox1Click
  end
  object OpenDialog1: TOpenDialog
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt'
    Left = 24
    Top = 48
  end
  object XPManifest1: TXPManifest
    Left = 56
    Top = 48
  end
end
