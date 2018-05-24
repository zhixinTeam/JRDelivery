inherited fFormSaleContract: TfFormSaleContract
  Left = 460
  Top = 64
  Width = 522
  Height = 607
  BorderIcons = [biSystemMenu, biMinimize]
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 506
    Height = 569
    Align = alClient
    TabOrder = 0
    TabStop = False
    LayoutLookAndFeel = FDM.dxLayoutWeb1
    OptionsItem.AutoControlAreaAlignment = False
    object EditMemo: TcxMemo
      Left = 81
      Top = 211
      Hint = 'T.C_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Edges = [bBottom]
      TabOrder = 12
      Height = 40
      Width = 437
    end
    object BtnOK: TButton
      Left = 351
      Top = 535
      Width = 70
      Height = 23
      Caption = #20445#23384
      TabOrder = 19
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 426
      Top = 535
      Width = 69
      Height = 23
      Caption = #21462#28040
      TabOrder = 20
      OnClick = BtnExitClick
    end
    object EditID: TcxButtonEdit
      Left = 81
      Top = 36
      Hint = 'T.C_ID'
      HelpType = htKeyword
      HelpKeyword = 'NU'
      ParentFont = False
      Properties.Buttons = <
        item
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 15
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      Width = 175
    end
    object StockList1: TcxMCListBox
      Left = 23
      Top = 338
      Width = 473
      Height = 172
      HeaderSections = <
        item
          DataIndex = 1
          Text = #27700#27877#31867#22411
          Width = 74
        end
        item
          Alignment = taCenter
          DataIndex = 2
          Text = #25968#37327'('#21544')'
          Width = 70
        end
        item
          Alignment = taCenter
          DataIndex = 3
          Text = #21333#20215'('#20803'/'#21544')'
          Width = 82
        end
        item
          Alignment = taCenter
          DataIndex = 4
          Text = #37329#39069'('#20803')'
          Width = 80
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 17
      OnClick = StockList1Click
    end
    object EditSalesMan: TcxComboBox
      Left = 81
      Top = 86
      Hint = 'T.C_SaleMan'
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 20
      Properties.OnEditValueChanged = EditSalesManPropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 2
      OnKeyDown = EditSalesManKeyDown
      Width = 145
    end
    object cxTextEdit1: TcxTextEdit
      Left = 81
      Top = 61
      Hint = 'T.C_Project'
      ParentFont = False
      Properties.MaxLength = 50
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 1
      Width = 121
    end
    object EditCustomer: TcxComboBox
      Left = 289
      Top = 86
      Hint = 'T.C_Customer'
      ParentFont = False
      Properties.DropDownRows = 25
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 20
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 3
      OnKeyDown = EditSalesManKeyDown
      OnKeyPress = EditCustomerKeyPress
      Width = 121
    end
    object cxTextEdit2: TcxTextEdit
      Left = 289
      Top = 111
      Hint = 'T.C_Addr'
      ParentFont = False
      Properties.MaxLength = 50
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Width = 121
    end
    object cxTextEdit3: TcxTextEdit
      Left = 289
      Top = 136
      Hint = 'T.C_Delivery'
      ParentFont = False
      Properties.MaxLength = 50
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 7
      Width = 121
    end
    object EditPayment: TcxComboBox
      Left = 81
      Top = 161
      Hint = 'T.C_Payment'
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 20
      Properties.MaxLength = 20
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 8
      Width = 145
    end
    object cxTextEdit4: TcxTextEdit
      Left = 289
      Top = 161
      Hint = 'T.C_Approval'
      ParentFont = False
      Properties.MaxLength = 30
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 9
      Width = 121
    end
    object EditName: TcxTextEdit
      Left = 57
      Top = 288
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 13
      Width = 120
    end
    object EditMoney: TcxTextEdit
      Left = 216
      Top = 313
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 16
      OnExit = EditValueExit
      Width = 120
    end
    object EditPrice: TcxTextEdit
      Left = 57
      Top = 313
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 15
      OnExit = EditValueExit
      Width = 120
    end
    object EditValue: TcxTextEdit
      Left = 216
      Top = 288
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 14
      OnExit = EditValueExit
      Width = 120
    end
    object EditDate: TcxButtonEdit
      Left = 81
      Top = 111
      Hint = 'T.C_Date'
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 20
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 4
      Width = 145
    end
    object cxButtonEdit1: TcxButtonEdit
      Left = 81
      Top = 136
      Hint = 'T.C_Area'
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = cxButtonEdit1PropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 6
      Width = 145
    end
    object Check1: TcxCheckBox
      Left = 11
      Top = 537
      Caption = #34394#25311#21512#21516': '#21150#29702#32440#21345#26102#20801#35768#21464#26356#19994#21153#21592#21644#23458#25143#21517#31216'.'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 18
      Transparent = True
      Width = 300
    end
    object EditDays: TcxTextEdit
      Left = 81
      Top = 186
      Hint = 'T.C_ZKDays'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 10
      Text = '1'
      Width = 145
    end
    object cxLabel1: TcxLabel
      Left = 231
      Top = 186
      AutoSize = False
      Caption = #22825'  '#27880':'#29992#25143#38656#35201#22312#25351#23450#26102#38271#20869#23558#27700#27877#25552#23436'.'
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 20
      Width = 268
      AnchorY = 196
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahParentManaged
      AlignVert = avParentManaged
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        CaptionOptions.Text = #22522#26412#20449#24687
        ButtonOptions.Buttons = <>
        object dxLayoutControl1Group9: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayoutControl1Item1: TdxLayoutItem
            CaptionOptions.Text = #21512#21516#32534#21495':'
            Control = EditID
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item2: TdxLayoutItem
            CaptionOptions.Text = #39033#30446#21517#31216':'
            Control = cxTextEdit1
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Group3: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item5: TdxLayoutItem
              CaptionOptions.Text = #19994#21153#20154#21592':'
              Control = EditSalesMan
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item6: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #23458#25143#21517#31216':'
              Control = EditCustomer
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayoutControl1Group7: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item19: TdxLayoutItem
            CaptionOptions.Text = #31614#35746#26102#38388':'
            Control = EditDate
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item7: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #31614#35746#22320#28857':'
            Control = cxTextEdit2
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group10: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item8: TdxLayoutItem
            CaptionOptions.Text = #25152#23646#21306#22495':'
            Control = cxButtonEdit1
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item9: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #20132#36135#22320#28857':'
            Control = cxTextEdit3
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group6: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item12: TdxLayoutItem
            CaptionOptions.Text = #20184#27454#26041#24335':'
            Control = EditPayment
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item13: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #25209' '#20934' '#20154':'
            Control = cxTextEdit4
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group11: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item20: TdxLayoutItem
            AlignHorz = ahLeft
            CaptionOptions.Text = #25552#36135#26102#38271':'
            Control = EditDays
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item21: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = 'cxLabel1'
            CaptionOptions.Visible = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Item4: TdxLayoutItem
          CaptionOptions.Text = #22791#27880#20449#24687':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group5: TdxLayoutGroup
        AlignVert = avClient
        CaptionOptions.Visible = False
        ButtonOptions.Buttons = <>
        Hidden = True
        ShowBorder = False
        object dxLayoutControl1Group2: TdxLayoutGroup
          AlignVert = avClient
          CaptionOptions.Text = #21512#21516#26126#32454
          ButtonOptions.Buttons = <>
          object dxLayoutControl1Group8: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            ShowBorder = False
            object dxLayoutControl1Group4: TdxLayoutGroup
              CaptionOptions.Visible = False
              ButtonOptions.Buttons = <>
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayoutControl1Item14: TdxLayoutItem
                CaptionOptions.Text = #31867#22411':'
                Control = EditName
                ControlOptions.ShowBorder = False
              end
              object dxLayoutControl1Item17: TdxLayoutItem
                CaptionOptions.Text = #25968#37327':'
                Control = EditValue
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayoutControl1Group13: TdxLayoutGroup
              CaptionOptions.Visible = False
              ButtonOptions.Buttons = <>
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayoutControl1Item16: TdxLayoutItem
                CaptionOptions.Text = #21333#20215':'
                Control = EditPrice
                ControlOptions.ShowBorder = False
              end
              object dxLayoutControl1Item15: TdxLayoutItem
                CaptionOptions.Text = #37329#39069':'
                Control = EditMoney
                ControlOptions.ShowBorder = False
              end
            end
          end
          object dxLayoutControl1Item3: TdxLayoutItem
            AlignVert = avClient
            CaptionOptions.Text = #21015#34920':'
            CaptionOptions.Visible = False
            Control = StockList1
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group12: TdxLayoutGroup
          AlignVert = avBottom
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item18: TdxLayoutItem
            AlignVert = avBottom
            CaptionOptions.Text = 'cxCheckBox1'
            CaptionOptions.Visible = False
            Control = Check1
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item10: TdxLayoutItem
            AlignHorz = ahRight
            CaptionOptions.Text = 'Button3'
            CaptionOptions.Visible = False
            Control = BtnOK
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item11: TdxLayoutItem
            AlignHorz = ahRight
            CaptionOptions.Text = 'Button4'
            CaptionOptions.Visible = False
            Control = BtnExit
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
