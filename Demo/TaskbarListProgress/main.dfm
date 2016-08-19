object MainForm: TMainForm
  Left = 503
  Top = 206
  BorderStyle = bsToolWindow
  Caption = 'TaskbarListProgress_DEMO'
  ClientHeight = 332
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Bottom = 40
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    408
    332)
  PixelsPerInch = 96
  TextHeight = 12
  object UcLabel1: TUcLabel
    Left = 8
    Top = 6
    Width = 137
    Height = 13
    Cursor = crHandPoint
    Caption = #1052#1086#1081' '#1089#1072#1081#1090': http://optitrex.ru'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Version = '01.10.2011'
    WebLink = 'http://optitrex.ru'
    Style = ulsWebLink
  end
  object RG_Style: TRadioGroup
    Left = 5
    Top = 94
    Width = 396
    Height = 59
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Anchors = [akLeft, akTop, akRight]
    Caption = 'TProgressBarStyle'
    ItemIndex = 0
    Items.Strings = (
      'pbstNormal'
      'pbstMarquee')
    TabOrder = 0
    OnClick = RG_StyleClick
  end
  object ProgressTrack: TTrackBar
    Left = 9
    Top = 265
    Width = 392
    Height = 34
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Anchors = [akLeft, akTop, akRight]
    Max = 140
    Min = 80
    Position = 90
    TabOrder = 1
    OnChange = ProgressTrackChange
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 304
    Width = 393
    Height = 17
    Cursor = crHourGlass
    Anchors = [akLeft, akTop, akRight]
    Min = 80
    Max = 140
    Position = 90
    MarqueeInterval = 80
    TabOrder = 2
  end
  object RG_State: TRadioGroup
    Left = 5
    Top = 157
    Width = 396
    Height = 76
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Anchors = [akLeft, akTop, akRight]
    Caption = 'TProgressBarState'
    ItemIndex = 0
    Items.Strings = (
      'pbsNormal'
      'pbsError'
      'pbsPaused')
    TabOrder = 3
    OnClick = RG_StateClick
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 238
    Width = 325
    Height = 17
    Caption = 'FShowProgressOnTaskbar'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = CheckBox1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 24
    Width = 392
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      #1042#1085#1080#1084#1072#1085#1080#1077'! '#1069#1090#1086#1090' '#1087#1088#1080#1084#1077#1088' '#1087#1088#1077#1076#1085#1072#1079#1085#1072#1095#1077#1085' '#1076#1083#1103' Windows Vista/7. '
      #1042' '#1073#1086#1083#1077#1077' '#1088#1072#1085#1085#1080#1093' '#1074#1077#1088#1089#1080#1103' Windows '#1085#1080#1095#1077#1075#1086' '#1085#1086#1074#1086#1075#1086' '#1042#1099' '#1085#1077' '#1091#1074#1080#1076#1080#1090#1077'.'
      ''
      
        '"'#1055#1086#1076#1077#1088#1075#1072#1081#1090#1077'" '#1085#1080#1078#1077' '#1087#1088#1080#1074#1077#1076#1077#1085#1085#1099#1077' '#1082#1086#1085#1090#1088#1086#1083#1099' '#1076#1083#1103' '#1087#1088#1086#1089#1084#1086#1090#1088#1072' '#1076#1077#1084#1086#1085#1089#1090#1088#1072#1094#1080 +
        #1080'.')
    ParentColor = True
    ParentFont = False
    TabOrder = 5
  end
end
