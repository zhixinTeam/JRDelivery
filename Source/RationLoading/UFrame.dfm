object Frame1: TFrame1
  Left = 0
  Top = 0
  Width = 344
  Height = 460
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 8
    Top = 0
    Width = 332
    Height = 457
    TabOrder = 0
    object ToolBar1: TToolBar
      Left = 8
      Top = 509
      Width = 44
      Height = 0
      Align = alNone
      AutoSize = True
      ButtonHeight = 7
      ButtonWidth = 8
      Caption = 'ToolBar1'
      EdgeInner = esNone
      EdgeOuter = esNone
      ShowCaptions = True
      TabOrder = 0
      object ToolButton2: TToolButton
        Left = 0
        Top = 2
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 1
        Style = tbsSeparator
      end
      object btnPause: TToolButton
        Left = 8
        Top = 2
        Width = 4
        Caption = #26242'  '#20572
        Enabled = False
        ImageIndex = 4
        Style = tbsSeparator
        Visible = False
      end
      object ToolButton9: TToolButton
        Left = 12
        Top = 2
        Width = 8
        Caption = 'ToolButton9'
        ImageIndex = 4
        Style = tbsSeparator
      end
      object ToolButton6: TToolButton
        Left = 20
        Top = 2
        Width = 8
        Caption = 'ToolButton6'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object ToolButton10: TToolButton
        Left = 28
        Top = 2
        Width = 8
        Caption = 'ToolButton10'
        ImageIndex = 4
        Style = tbsSeparator
      end
      object ToolButton1: TToolButton
        Left = 36
        Top = 2
        Width = 8
        Caption = 'ToolButton1'
        ImageIndex = 4
        Style = tbsSeparator
      end
    end
    object GroupBox2: TGroupBox
      Left = 7
      Top = 15
      Width = 316
      Height = 86
      Caption = #21333#20301': '#21544
      TabOrder = 1
      object EditValue: TLEDFontNum
        Left = 6
        Top = 18
        Width = 304
        Height = 63
        OffSetX = 8
        OffSetY = 6
        WordWidth = 32
        WordHeight = 51
        Thick = 5
        Space = 5
        Text = '12345678'
        AutoSize = False
        DrawDarkColor = False
      end
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 134
      Width = 316
      Height = 226
      Caption = #25552#36135#21333#20449#24687
      TabOrder = 2
      object cxLabel4: TcxLabel
        Left = 1
        Top = 104
        Caption = #20132#36135#21333#21495':'
        ParentFont = False
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.TextColor = clBlack
        Style.IsFontAssigned = True
      end
      object EditBill: TcxComboBox
        Left = 103
        Top = 102
        ParentFont = False
        Properties.ItemHeight = 22
        Properties.MaxLength = 15
        Properties.ReadOnly = True
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.LookAndFeel.NativeStyle = True
        Style.IsFontAssigned = True
        StyleDisabled.LookAndFeel.NativeStyle = True
        StyleFocused.LookAndFeel.NativeStyle = True
        StyleHot.LookAndFeel.NativeStyle = True
        TabOrder = 1
        Width = 207
      end
      object cxLabel5: TcxLabel
        Left = 1
        Top = 135
        Caption = #36710#29260#21495#30721':'
        ParentFont = False
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.TextColor = clBlack
        Style.IsFontAssigned = True
      end
      object EditTruck: TcxComboBox
        Left = 103
        Top = 133
        ParentFont = False
        Properties.ItemHeight = 22
        Properties.MaxLength = 15
        Properties.ReadOnly = True
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.LookAndFeel.NativeStyle = True
        Style.IsFontAssigned = True
        StyleDisabled.LookAndFeel.NativeStyle = True
        StyleFocused.LookAndFeel.NativeStyle = True
        StyleHot.LookAndFeel.NativeStyle = True
        TabOrder = 3
        Width = 207
      end
      object cxLabel7: TcxLabel
        Left = 1
        Top = 165
        Caption = #23458#25143#21517#31216':'
        ParentFont = False
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.TextColor = clBlack
        Style.IsFontAssigned = True
      end
      object EditCusID: TcxComboBox
        Left = 103
        Top = 162
        ParentFont = False
        Properties.DropDownRows = 20
        Properties.ImmediateDropDown = False
        Properties.IncrementalSearch = False
        Properties.ItemHeight = 22
        Properties.ReadOnly = True
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.LookAndFeel.NativeStyle = True
        Style.IsFontAssigned = True
        StyleDisabled.LookAndFeel.NativeStyle = True
        StyleFocused.LookAndFeel.NativeStyle = True
        StyleHot.LookAndFeel.NativeStyle = True
        TabOrder = 5
        Width = 207
      end
      object cxLabel8: TcxLabel
        Left = 1
        Top = 194
        Caption = #29289#26009#21517#31216':'
        ParentFont = False
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.TextColor = clBlack
        Style.IsFontAssigned = True
      end
      object EditStockID: TcxComboBox
        Left = 103
        Top = 193
        ParentFont = False
        Properties.DropDownRows = 20
        Properties.ImmediateDropDown = False
        Properties.IncrementalSearch = False
        Properties.ItemHeight = 22
        Properties.ReadOnly = True
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.LookAndFeel.NativeStyle = True
        Style.IsFontAssigned = True
        StyleDisabled.LookAndFeel.NativeStyle = True
        StyleFocused.LookAndFeel.NativeStyle = True
        StyleHot.LookAndFeel.NativeStyle = True
        TabOrder = 7
        Width = 207
      end
      object cxLabel6: TcxLabel
        Left = 1
        Top = 16
        Caption = #38480' '#36733' '#37327':'
        ParentFont = False
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.TextColor = clBlack
        Style.IsFontAssigned = True
      end
      object EditMaxValue: TcxTextEdit
        Left = 103
        Top = 14
        ParentFont = False
        Properties.ReadOnly = True
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.LookAndFeel.NativeStyle = True
        Style.IsFontAssigned = True
        StyleDisabled.LookAndFeel.NativeStyle = True
        StyleFocused.LookAndFeel.NativeStyle = True
        StyleHot.LookAndFeel.NativeStyle = True
        TabOrder = 9
        Text = '0'
        Width = 207
      end
      object cxLabel1: TcxLabel
        Left = 1
        Top = 46
        Caption = #30382'    '#37325':'
        ParentFont = False
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.TextColor = clBlack
        Style.IsFontAssigned = True
      end
      object editPValue: TcxTextEdit
        Left = 103
        Top = 43
        ParentFont = False
        Properties.ReadOnly = True
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.LookAndFeel.NativeStyle = True
        Style.IsFontAssigned = True
        StyleDisabled.LookAndFeel.NativeStyle = True
        StyleFocused.LookAndFeel.NativeStyle = True
        StyleHot.LookAndFeel.NativeStyle = True
        TabOrder = 11
        Text = '0'
        Width = 207
      end
      object cxLabel2: TcxLabel
        Left = 1
        Top = 76
        Caption = #24320' '#21333' '#37327':'
        ParentFont = False
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.TextColor = clBlack
        Style.IsFontAssigned = True
      end
      object editZValue: TcxTextEdit
        Left = 103
        Top = 73
        ParentFont = False
        Properties.ReadOnly = True
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -19
        Style.Font.Name = #24188#22278
        Style.Font.Style = []
        Style.LookAndFeel.NativeStyle = True
        Style.IsFontAssigned = True
        StyleDisabled.LookAndFeel.NativeStyle = True
        StyleFocused.LookAndFeel.NativeStyle = True
        StyleHot.LookAndFeel.NativeStyle = True
        TabOrder = 13
        Text = '0'
        Width = 207
      end
    end
    object editNetValue: TLEDFontNum
      Left = 61
      Top = 102
      Width = 98
      Height = 29
      OffSetX = 3
      OffSetY = 6
      WordWidth = 14
      WordHeight = 19
      Thick = 2
      Space = 5
      Text = '12345'
      AutoSize = False
      DrawDarkColor = False
    end
    object editBiLi: TLEDFontNum
      Left = 217
      Top = 102
      Width = 98
      Height = 29
      OffSetX = 3
      OffSetY = 6
      WordWidth = 14
      WordHeight = 19
      Thick = 2
      Space = 5
      Text = '12345'
      AutoSize = False
      DrawDarkColor = False
    end
    object cxLabel3: TcxLabel
      Left = 8
      Top = 106
      Caption = #20928#37325':'
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -19
      Style.Font.Name = #24188#22278
      Style.Font.Style = []
      Style.TextColor = clBlack
      Style.IsFontAssigned = True
    end
    object cxLabel9: TcxLabel
      Left = 165
      Top = 106
      Caption = #27604#20363':'
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -19
      Style.Font.Name = #24188#22278
      Style.Font.Style = []
      Style.TextColor = clBlack
      Style.IsFontAssigned = True
    end
    object LblWarn: TcxLabel
      Left = 8
      Top = 432
      AutoSize = False
      Height = 17
      Width = 321
    end
  end
  object cxLabel10: TcxLabel
    Left = 17
    Top = 370
    Caption = #25163#21160#21152#37327':'
    ParentFont = False
    Style.Font.Charset = GB2312_CHARSET
    Style.Font.Color = clBlack
    Style.Font.Height = -19
    Style.Font.Name = #24188#22278
    Style.Font.Style = []
    Style.TextColor = clBlack
    Style.IsFontAssigned = True
  end
  object IncTon: TcxSpinEdit
    Left = 107
    Top = 367
    AutoSize = False
    ParentFont = False
    Properties.MaxValue = 100.000000000000000000
    Properties.MinValue = -100.000000000000000000
    Style.BorderStyle = ebsFlat
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'MS Sans Serif'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 2
    Height = 28
    Width = 63
  end
  object BtnStop: TButton
    Left = 98
    Top = 403
    Width = 73
    Height = 30
    Caption = #20572#27490
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #20223#23435
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = BtnStopClick
  end
  object cxLabel11: TcxLabel
    Left = 177
    Top = 367
    Caption = #25163#21160#21152#26102':'
    ParentFont = False
    Style.Font.Charset = GB2312_CHARSET
    Style.Font.Color = clBlack
    Style.Font.Height = -19
    Style.Font.Name = #24188#22278
    Style.Font.Style = []
    Style.TextColor = clBlack
    Style.IsFontAssigned = True
  end
  object IncMin: TcxSpinEdit
    Left = 267
    Top = 367
    AutoSize = False
    ParentFont = False
    Properties.MaxValue = 1500.000000000000000000
    Properties.OnChange = IncMinPropertiesChange
    Style.BorderStyle = ebsFlat
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'MS Sans Serif'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 5
    Height = 28
    Width = 63
  end
  object BtnStart: TButton
    Left = 19
    Top = 403
    Width = 73
    Height = 30
    Caption = #21551#21160#25918#28784
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #20223#23435
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = BtnStartClick
  end
  object BtnClean: TButton
    Left = 257
    Top = 403
    Width = 73
    Height = 30
    Caption = #28165#23631
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #20223#23435
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    Visible = False
    OnClick = BtnCleanClick
  end
  object btnSaveMValue: TButton
    Left = 177
    Top = 403
    Width = 73
    Height = 30
    Caption = #20445#23384#27611#37325
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #20223#23435
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    Visible = False
    OnClick = BtnStartClick
  end
  object ControlTimer: TTimer
    Enabled = False
    OnTimer = ControlTimerTimer
    Left = 248
    Top = 304
  end
end
