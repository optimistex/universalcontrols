object PaintInfoEditor: TPaintInfoEditor
  Left = 525
  Top = 175
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1089#1082#1080#1085#1072
  ClientHeight = 436
  ClientWidth = 647
  Color = clBtnFace
  Constraints.MinHeight = 450
  Constraints.MinWidth = 550
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlWorkAreaBack: TUcPanel
    Left = 0
    Top = 0
    Width = 465
    Height = 436
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    BackGroundStyle = isOriginal
    ExplicitWidth = 459
    ExplicitHeight = 429
    object Splitter1: TSplitter
      Left = 0
      Top = 213
      Width = 465
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Color = clHighlight
      ParentColor = False
      ExplicitTop = 206
      ExplicitWidth = 459
    end
    object pnlTools: TUcPanel
      Left = 0
      Top = 0
      Width = 465
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      BackGroundStyle = isOriginal
      ExplicitWidth = 459
      DesignSize = (
        465
        26)
      object btStyleAdd: TUcButton
        Left = 420
        Top = 1
        Width = 21
        Height = 21
        Action = actStyleAdd
        Anchors = [akTop, akRight]
        Caption = '+'
        CaptionEx.Strings = (
          '+')
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Images.PosCenter = True
        ExplicitLeft = 414
      end
      object btStyleDelete: TUcButton
        Left = 441
        Top = 1
        Width = 21
        Height = 21
        Action = actStyleDelete
        Anchors = [akTop, akRight]
        Caption = '-'
        CaptionEx.Strings = (
          '-')
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Images.PosCenter = True
        ParentFont = False
        ExplicitLeft = 435
      end
      object UcButton1: TUcButton
        Left = 399
        Top = 1
        Width = 21
        Height = 21
        Hint = #1042#1077#1088#1085#1091#1090#1100' '#1085#1072#1095#1072#1083#1100#1085#1099#1081' '#1089#1090#1080#1083#1100
        Action = actUndo
        Anchors = [akTop, akRight]
        Caption = '<'
        CaptionEx.Strings = (
          '<')
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Images.PosCenter = True
        ParentFont = False
        ExplicitLeft = 393
      end
      object UcLabel1: TUcLabel
        Left = 2
        Top = 1
        Width = 43
        Height = 16
        Caption = #1057#1090#1080#1083#1100':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Version = '12.05.2012'
        WebLink = 'http://optitrex.ru'
      end
      object edCurrentStyle: TEdit
        Left = 51
        Top = 1
        Width = 346
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = edCurrentStyleChange
        ExplicitWidth = 340
      end
    end
    object pnlTarget: TUcPanel
      Left = 0
      Top = 216
      Width = 465
      Height = 220
      Align = alBottom
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      TabOrder = 1
      BackGroundStyle = isOriginal
      ExplicitTop = 209
      ExplicitWidth = 459
      object PreviewStatus: TStatusBar
        Left = 0
        Top = 201
        Width = 465
        Height = 19
        Panels = <
          item
            Text = #1054#1090#1086#1073#1088#1072#1078#1072#1077#1084#1099#1081' '#1088#1072#1079#1084#1077#1088':'
            Width = 170
          end
          item
            Text = 'Width: 200px'
            Width = 100
          end
          item
            Text = 'Height: 100px'
            Width = 100
          end
          item
            Width = 50
          end>
        ExplicitWidth = 459
      end
      object pnlPreviewTabs: TUcPanel
        Left = 0
        Top = 0
        Width = 465
        Height = 26
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        BackGroundStyle = isOriginal
        ExplicitWidth = 459
        DesignSize = (
          465
          26)
        object UcBtn_Select: TUcButton
          Left = 439
          Top = 1
          Width = 24
          Height = 24
          Anchors = [akTop, akRight]
          Caption = ' '
          CaptionEx.Strings = (
            ' ')
          GroupIndex = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          BtnImages = ImgLst
          Images.IndexImgUp = 1
          Images.IndexImgDown = 1
          Images.PosCenter = True
          OnClick = UcBtn_MoveClick
          ShowCaption = False
          ExplicitLeft = 433
        end
        object UcBtn_Move: TUcButton
          Left = 414
          Top = 1
          Width = 24
          Height = 24
          Anchors = [akTop, akRight]
          Caption = ' '
          CaptionEx.Strings = (
            ' ')
          GroupIndex = 1
          Down = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          BtnImages = ImgLst
          Images.IndexImgUp = 0
          Images.IndexImgDown = 0
          Images.PosCenter = True
          OnClick = UcBtn_MoveClick
          ShowCaption = False
          ExplicitLeft = 408
        end
        object ViewTabs: TTabControl
          Left = 1
          Top = 6
          Width = 159
          Height = 20
          Anchors = [akLeft, akBottom]
          TabOrder = 0
          Tabs.Strings = (
            #1058#1077#1082#1091#1097#1080#1081' '#1089#1090#1080#1083#1100
            #1042#1089#1077' '#1089#1090#1080#1083#1080)
          TabIndex = 1
          OnChange = ViewTabsChange
        end
      end
      object pnlPreviewBack: TUcPanel
        Left = 0
        Top = 26
        Width = 465
        Height = 175
        Align = alClient
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 2
        BackGroundStyle = isOriginal
        OnMouseUp = pnlPreviewBackMouseUp
        ExplicitWidth = 459
        DesignSize = (
          465
          175)
        object pnlDestination: TUcPanel
          Left = 32
          Top = 32
          Width = 406
          Height = 121
          Anchors = []
          BevelOuter = bvNone
          TabOrder = 0
          BackGroundImage.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000500000
            00500803000000B9CF029F0000001974455874536F6674776172650041646F62
            6520496D616765526561647971C9653C0000032269545874584D4C3A636F6D2E
            61646F62652E786D7000000000003C3F787061636B657420626567696E3D22EF
            BBBF222069643D2257354D304D7043656869487A7265537A4E54637A6B633964
            223F3E203C783A786D706D65746120786D6C6E733A783D2261646F62653A6E73
            3A6D6574612F2220783A786D70746B3D2241646F626520584D5020436F726520
            352E332D633031312036362E3134353636312C20323031322F30322F30362D31
            343A35363A32372020202020202020223E203C7264663A52444620786D6C6E73
            3A7264663D22687474703A2F2F7777772E77332E6F72672F313939392F30322F
            32322D7264662D73796E7461782D6E7323223E203C7264663A44657363726970
            74696F6E207264663A61626F75743D222220786D6C6E733A786D703D22687474
            703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F2220786D6C6E73
            3A786D704D4D3D22687474703A2F2F6E732E61646F62652E636F6D2F7861702F
            312E302F6D6D2F2220786D6C6E733A73745265663D22687474703A2F2F6E732E
            61646F62652E636F6D2F7861702F312E302F73547970652F5265736F75726365
            526566232220786D703A43726561746F72546F6F6C3D2241646F62652050686F
            746F73686F7020435336202857696E646F7773292220786D704D4D3A496E7374
            616E636549443D22786D702E6969643A35314442453832423744423431314532
            423837444241423938324443463942332220786D704D4D3A446F63756D656E74
            49443D22786D702E6469643A3531444245383243374442343131453242383744
            424142393832444346394233223E203C786D704D4D3A4465726976656446726F
            6D2073745265663A696E7374616E636549443D22786D702E6969643A35314442
            4538323937444234313145324238374442414239383244434639423322207374
            5265663A646F63756D656E7449443D22786D702E6469643A3531444245383241
            374442343131453242383744424142393832444346394233222F3E203C2F7264
            663A4465736372697074696F6E3E203C2F7264663A5244463E203C2F783A786D
            706D6574613E203C3F787061636B657420656E643D2272223F3ED2FCEA560000
            0006504C5445CBCBCBFEFDFEA58CF944000000584944415478DAEDD3B10D0030
            080341D87FE8A461027061C94F83DC5CF75D733DFF1D7703022E4015F40001EF
            DBB814C004D0BF14C004B0C41020E006F42F0530012C310408B801FD4B014C00
            4B0C01026E40FF520003C00F41E46888978F1A1B0000000049454E44AE426082}
          BackGroundStyle = isRepeat
          CaptureFocus = True
          OnDrawBackground = pnlDestinationDrawBackground
          OnClick = pnlSourceClick
          OnKeyDown = pnlDestinationKeyDown
          OnMouseDown = pnlDestinationMouseDown
          OnMouseMove = pnlDestinationMouseMove
          OnMouseUp = pnlSourceMouseUp
          OnResize = pnlDestinationResize
          ExplicitLeft = 29
        end
      end
    end
    object SourcePages: TPageControl
      Left = 0
      Top = 26
      Width = 465
      Height = 187
      ActivePage = tbPicture
      Align = alClient
      TabOrder = 2
      OnChange = SourcePagesChange
      ExplicitWidth = 459
      ExplicitHeight = 180
      object tbPicture: TTabSheet
        Caption = #1050#1072#1088#1090#1080#1085#1082#1072
        OnMouseUp = tbPictureMouseUp
        ExplicitWidth = 451
        ExplicitHeight = 152
        DesignSize = (
          457
          159)
        object pnlSource: TUcPanel
          Left = 94
          Top = 31
          Width = 257
          Height = 110
          Anchors = []
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          BackGroundImage.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000500000
            00500803000000B9CF029F0000001974455874536F6674776172650041646F62
            6520496D616765526561647971C9653C0000032269545874584D4C3A636F6D2E
            61646F62652E786D7000000000003C3F787061636B657420626567696E3D22EF
            BBBF222069643D2257354D304D7043656869487A7265537A4E54637A6B633964
            223F3E203C783A786D706D65746120786D6C6E733A783D2261646F62653A6E73
            3A6D6574612F2220783A786D70746B3D2241646F626520584D5020436F726520
            352E332D633031312036362E3134353636312C20323031322F30322F30362D31
            343A35363A32372020202020202020223E203C7264663A52444620786D6C6E73
            3A7264663D22687474703A2F2F7777772E77332E6F72672F313939392F30322F
            32322D7264662D73796E7461782D6E7323223E203C7264663A44657363726970
            74696F6E207264663A61626F75743D222220786D6C6E733A786D703D22687474
            703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F2220786D6C6E73
            3A786D704D4D3D22687474703A2F2F6E732E61646F62652E636F6D2F7861702F
            312E302F6D6D2F2220786D6C6E733A73745265663D22687474703A2F2F6E732E
            61646F62652E636F6D2F7861702F312E302F73547970652F5265736F75726365
            526566232220786D703A43726561746F72546F6F6C3D2241646F62652050686F
            746F73686F7020435336202857696E646F7773292220786D704D4D3A496E7374
            616E636549443D22786D702E6969643A35314442453832423744423431314532
            423837444241423938324443463942332220786D704D4D3A446F63756D656E74
            49443D22786D702E6469643A3531444245383243374442343131453242383744
            424142393832444346394233223E203C786D704D4D3A4465726976656446726F
            6D2073745265663A696E7374616E636549443D22786D702E6969643A35314442
            4538323937444234313145324238374442414239383244434639423322207374
            5265663A646F63756D656E7449443D22786D702E6469643A3531444245383241
            374442343131453242383744424142393832444346394233222F3E203C2F7264
            663A4465736372697074696F6E3E203C2F7264663A5244463E203C2F783A786D
            706D6574613E203C3F787061636B657420656E643D2272223F3ED2FCEA560000
            0006504C5445CBCBCBFEFDFEA58CF944000000584944415478DAEDD3B10D0030
            080341D87FE8A461027061C94F83DC5CF75D733DFF1D7703022E4015F40001EF
            DBB814C004D0BF14C004B0C41020E006F42F0530012C310408B801FD4B014C00
            4B0C01026E40FF520003C00F41E46888978F1A1B0000000049454E44AE426082}
          BackGroundStyle = isRepeat
          CaptureFocus = True
          OnDrawBackground = pnlSourceDrawBackground
          OnClick = pnlSourceClick
          OnKeyDown = pnlSourceKeyDown
          OnMouseDown = pnlSourceMouseDown
          OnMouseMove = pnlSourceMouseMove
          OnMouseUp = pnlSourceMouseUp
          OnResize = pnlSourceResize
          ExplicitLeft = 91
          ExplicitTop = 27
        end
      end
      object tbEditor: TTabSheet
        Caption = #1056#1077#1076#1072#1082#1090#1086#1088
        ImageIndex = 1
        ExplicitWidth = 451
        ExplicitHeight = 152
        object clbStyles: TCheckListBox
          Left = 0
          Top = 0
          Width = 457
          Height = 159
          OnClickCheck = clbStylesClickCheck
          Align = alClient
          BorderStyle = bsNone
          Columns = 1
          ItemHeight = 13
          TabOrder = 0
          OnClick = clbStylesClick
          ExplicitWidth = 451
          ExplicitHeight = 152
        end
      end
      object tbSource: TTabSheet
        Caption = 'TabSheet1'
        ImageIndex = 2
        ExplicitWidth = 451
        ExplicitHeight = 152
        object Mmo_Source: TMemo
          Left = 0
          Top = 0
          Width = 457
          Height = 159
          Align = alClient
          TabOrder = 0
          OnChange = Mmo_SourceChange
          ExplicitWidth = 451
          ExplicitHeight = 152
        end
      end
    end
  end
  object pnlRight: TUcPanel
    Left = 465
    Top = 0
    Width = 182
    Height = 436
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    BackGroundStyle = isOriginal
    ExplicitLeft = 459
    ExplicitHeight = 429
    DesignSize = (
      182
      436)
    object UcButton4: TUcButton
      Left = 45
      Top = 373
      Width = 100
      Height = 25
      Hint = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1080' '#1074#1099#1081#1090#1080
      Anchors = [akBottom]
      Caption = #1054#1082
      CaptionEx.Strings = (
        #1054#1082)
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ModalResult = 1
      Images.PosCenter = True
      ExplicitTop = 366
    end
    object UcButton5: TUcButton
      Left = 45
      Top = 404
      Width = 100
      Height = 25
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1080' '#1074#1099#1081#1090#1080
      Anchors = [akBottom]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      CaptionEx.Strings = (
        #1054#1090#1084#1077#1085#1072)
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ModalResult = 2
      Images.PosCenter = True
      ParentFont = False
      ExplicitTop = 397
    end
    object grpSource: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 176
      Height = 144
      Align = alTop
      Caption = ' '#1048#1089#1093#1086#1076#1085#1072#1103' '#1082#1072#1088#1090#1080#1085#1082#1072' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      ExplicitLeft = 6
      ExplicitTop = 6
      ExplicitWidth = 169
      DesignSize = (
        176
        144)
      object cbSL: TCheckBox
        Tag = 1
        Left = 6
        Top = 18
        Width = 68
        Height = 17
        Caption = 'Left:'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 0
        OnClick = cbSLClick
      end
      object SL: TSpinEdit
        Left = 118
        Top = 18
        Width = 50
        Height = 19
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxValue = 2000
        MinValue = -2000
        ParentFont = False
        TabOrder = 1
        Value = 0
        OnChange = SLChange
        ExplicitLeft = 111
      end
      object ST: TSpinEdit
        Left = 118
        Top = 38
        Width = 50
        Height = 19
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxValue = 2000
        MinValue = -2000
        ParentFont = False
        TabOrder = 2
        Value = 0
        OnChange = SLChange
        ExplicitLeft = 111
      end
      object cbST: TCheckBox
        Tag = 1
        Left = 6
        Top = 38
        Width = 68
        Height = 17
        Caption = 'Top:'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 3
        OnClick = cbSLClick
      end
      object SR: TSpinEdit
        Left = 118
        Top = 58
        Width = 50
        Height = 19
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxValue = 2000
        MinValue = -2000
        ParentFont = False
        TabOrder = 4
        Value = 0
        OnChange = SLChange
        ExplicitLeft = 111
      end
      object cbSR: TCheckBox
        Tag = 1
        Left = 6
        Top = 58
        Width = 68
        Height = 17
        Caption = 'Right:'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 5
        OnClick = cbSLClick
      end
      object cbSB: TCheckBox
        Tag = 1
        Left = 6
        Top = 78
        Width = 68
        Height = 17
        Caption = 'Bottom:'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 6
        OnClick = cbSLClick
      end
      object SB: TSpinEdit
        Left = 118
        Top = 78
        Width = 50
        Height = 19
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxValue = 2000
        MinValue = -2000
        ParentFont = False
        TabOrder = 7
        Value = 0
        OnChange = SLChange
        ExplicitLeft = 111
      end
      object cbSW: TCheckBox
        Tag = 1
        Left = 6
        Top = 98
        Width = 68
        Height = 17
        Caption = 'Width:'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 8
        OnClick = cbSLClick
      end
      object SW: TSpinEdit
        Left = 118
        Top = 98
        Width = 50
        Height = 19
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxValue = 2000
        MinValue = -2000
        ParentFont = False
        TabOrder = 9
        Value = 0
        OnChange = SLChange
        ExplicitLeft = 111
      end
      object cbSH: TCheckBox
        Tag = 1
        Left = 6
        Top = 118
        Width = 68
        Height = 17
        Caption = 'Height:'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 10
        OnClick = cbSLClick
      end
      object SH: TSpinEdit
        Left = 118
        Top = 118
        Width = 50
        Height = 19
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxValue = 2000
        MinValue = -2000
        ParentFont = False
        TabOrder = 11
        Value = 0
        OnChange = SLChange
        ExplicitLeft = 111
      end
    end
    object grpStyle: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 317
      Width = 176
      Height = 50
      Align = alTop
      Caption = '      '#1057#1090#1080#1083#1100' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1103' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      ExplicitLeft = 6
      ExplicitTop = 310
      ExplicitWidth = 170
      DesignSize = (
        176
        50)
      object pStyle: TComboBox
        Left = 11
        Top = 18
        Width = 155
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemIndex = 5
        TabOrder = 0
        Text = 'repeat-x-stretch-y'
        OnChange = SLChange
        Items.Strings = (
          'original'
          'repeat'
          'repeat-x'
          'repeat-y'
          'stretch'
          'repeat-x-stretch-y'
          'repeat-y-stretch-x')
        ExplicitWidth = 149
      end
      object cbpStyle: TCheckBox
        Left = 11
        Top = 0
        Width = 13
        Height = 17
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = cbSLClick
      end
    end
    object grpDestination: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 167
      Width = 176
      Height = 144
      Align = alTop
      Caption = ' '#1054#1090#1086#1073#1088#1072#1078#1072#1077#1084#1072#1103' '#1082#1072#1088#1090#1080#1085#1082#1072' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      ExplicitLeft = 6
      ExplicitTop = 163
      ExplicitWidth = 169
      DesignSize = (
        176
        144)
      object cbDL: TCheckBox
        Tag = 1
        Left = 6
        Top = 18
        Width = 68
        Height = 17
        Caption = 'Left:'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 0
        OnClick = cbSLClick
      end
      object DL: TSpinEdit
        Left = 119
        Top = 18
        Width = 50
        Height = 19
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxValue = 2000
        MinValue = -2000
        ParentFont = False
        TabOrder = 1
        Value = 0
        OnChange = SLChange
        ExplicitLeft = 112
      end
      object cbDT: TCheckBox
        Tag = 1
        Left = 6
        Top = 38
        Width = 68
        Height = 17
        Caption = 'Top:'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 2
        OnClick = cbSLClick
      end
      object DT: TSpinEdit
        Left = 119
        Top = 38
        Width = 50
        Height = 19
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxValue = 2000
        MinValue = -2000
        ParentFont = False
        TabOrder = 3
        Value = 0
        OnChange = SLChange
        ExplicitLeft = 112
      end
      object cbDR: TCheckBox
        Tag = 1
        Left = 6
        Top = 58
        Width = 68
        Height = 17
        Caption = 'Right:'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 4
        OnClick = cbSLClick
      end
      object DR: TSpinEdit
        Left = 119
        Top = 58
        Width = 50
        Height = 19
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxValue = 2000
        MinValue = -2000
        ParentFont = False
        TabOrder = 5
        Value = 0
        OnChange = SLChange
        ExplicitLeft = 112
      end
      object cbDB: TCheckBox
        Tag = 1
        Left = 6
        Top = 78
        Width = 68
        Height = 17
        Caption = 'Bottom:'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 6
        OnClick = cbSLClick
      end
      object DB: TSpinEdit
        Left = 119
        Top = 78
        Width = 50
        Height = 19
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxValue = 2000
        MinValue = -2000
        ParentFont = False
        TabOrder = 7
        Value = 0
        OnChange = SLChange
        ExplicitLeft = 112
      end
      object cbDW: TCheckBox
        Tag = 1
        Left = 6
        Top = 98
        Width = 68
        Height = 17
        Caption = 'Width:'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 8
        OnClick = cbSLClick
      end
      object DW: TSpinEdit
        Left = 119
        Top = 98
        Width = 50
        Height = 19
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxValue = 2000
        MinValue = -2000
        ParentFont = False
        TabOrder = 9
        Value = 0
        OnChange = SLChange
        ExplicitLeft = 112
      end
      object cbDH: TCheckBox
        Tag = 1
        Left = 6
        Top = 118
        Width = 68
        Height = 17
        Caption = 'Height:'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 10
        OnClick = cbSLClick
      end
      object DH: TSpinEdit
        Left = 119
        Top = 118
        Width = 50
        Height = 19
        Anchors = [akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxValue = 2000
        MinValue = -2000
        ParentFont = False
        TabOrder = 11
        Value = 0
        OnChange = SLChange
        ExplicitLeft = 112
      end
    end
    object UcPanel1: TUcPanel
      AlignWithMargins = True
      Left = 3
      Top = 150
      Width = 176
      Height = 14
      Margins.Top = 0
      Margins.Bottom = 0
      Transparent = True
      Align = alTop
      BevelOuter = bvNone
      Caption = 'UcPanel1'
      TabOrder = 3
      BackGroundStyle = isOriginal
      ShowCaption = False
      ExplicitTop = 153
      object UcBtn_CopySrcToDest: TUcButton
        Left = 45
        Top = 0
        Width = 40
        Height = 14
        Hint = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1085#1080#1079
        Caption = 'vvv'
        CaptionEx.Strings = (
          'vvv')
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Images.PosCenter = True
      end
      object UcBtn_CopyDestToSrc: TUcButton
        Left = 91
        Top = 0
        Width = 40
        Height = 14
        Hint = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1074#1077#1088#1093
        Caption = '^^^'
        CaptionEx.Strings = (
          '^^^')
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Images.PosCenter = True
      end
    end
  end
  object MainActions: TActionList
    Images = ImgLst
    Left = 32
    Top = 296
    object actStyleAdd: TAction
      Category = 'Style'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1090#1080#1083#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1090#1080#1083#1100
      ShortCut = 16429
      OnExecute = actStyleAddExecute
    end
    object actStyleDelete: TAction
      Category = 'Style'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1080#1083#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1080#1083#1100
      ShortCut = 16430
      OnExecute = actStyleDeleteExecute
    end
    object actViewElement: TAction
      Category = 'View'
      Caption = #1069#1083#1077#1084#1077#1085#1090
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1101#1083#1077#1084#1077#1085#1090#1072
    end
    object actViewAll: TAction
      Category = 'View'
      Caption = #1055#1086#1083#1085#1099#1081' '#1074#1080#1076
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1074' '#1082#1086#1084#1087#1083#1077#1082#1089#1077
    end
    object actUndo: TAction
      Category = 'Style'
      Caption = '<'
      ShortCut = 16474
      OnExecute = actUndoExecute
    end
  end
  object ImgLst: TImageList
    Left = 32
    Top = 248
    Bitmap = {
      494C010102000500040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000FF000000FF000000FF000000FF000000000000
      0000000000000000000000000000000000000000000000000081000000E70000
      0000000000E7000000E700000000000000E7000000E700000000000000E70000
      00E700000000000000E700000081000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000FF000000FF000000FF000000FF000000FF000000FF0000
      00000000000000000000000000000000000000000000000000DB000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000DB000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      00000000000000000000000000000000000000000000000000C9000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000C9000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000FF0000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      000000000000000000FF000000000000000000000000000000C5000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000C5000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000FF000000FF0000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      000000000000000000FF000000FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF00000000000000BE000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000BE000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF00000000000000BB000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000BB000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000FF000000FF0000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      000000000000000000FF000000FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000FF0000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      000000000000000000FF000000000000000000000000000000B5000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000B5000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      00000000000000000000000000000000000000000000000000B2000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000B2000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000FF000000FF000000FF000000FF000000FF000000FF0000
      00000000000000000000000000000000000000000000000000AE000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000AE000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000FF000000FF000000FF000000FF000000000000
      0000000000000000000000000000000000000000000000000081000000AC0000
      0000000000AC000000AC00000000000000AC000000AC00000000000000AC0000
      00AC00000000000000AC00000081000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FE7FFFFF00000000FC3F924900000000
      F81FBFFD00000000FE7FFFFF00000000FE7FBFFD00000000DE7BBFFD00000000
      9E79FFFF000000000000BFFD000000000000BFFD000000009E79FFFF00000000
      DE7BBFFD00000000FE7FBFFD00000000FE7FFFFF00000000F81FBFFD00000000
      FC3F924900000000FE7FFFFF0000000000000000000000000000000000000000
      000000000000}
  end
end
