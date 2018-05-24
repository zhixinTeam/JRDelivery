inherited fFormPOrderBase: TfFormPOrderBase
  Left = 495
  Top = 210
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 332
  ClientWidth = 506
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
    Height = 332
    Align = alClient
    TabOrder = 0
    TabStop = False
    OptionsItem.AutoControlAreaAlignment = False
    object EditMemo: TcxMemo
      Left = 84
      Top = 211
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.Edges = [bBottom]
      TabOrder = 11
      Height = 40
      Width = 437
    end
    object BtnOK: TButton
      Left = 350
      Top = 298
      Width = 70
      Height = 23
      Caption = #20445#23384
      TabOrder = 13
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 426
      Top = 298
      Width = 69
      Height = 23
      Caption = #21462#28040
      TabOrder = 14
      OnClick = BtnExitClick
    end
    object EditSalesMan: TcxComboBox
      Left = 84
      Top = 107
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 20
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 3
      OnKeyDown = EditSalesManKeyDown
      Width = 173
    end
    object EditProject: TcxTextEdit
      Left = 84
      Top = 81
      ParentFont = False
      Properties.MaxLength = 0
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      TabOrder = 2
      Width = 183
    end
    object EditArea: TcxButtonEdit
      Left = 323
      Top = 107
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = cxButtonEdit1PropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.ButtonStyle = bts3D
      TabOrder = 4
      Width = 158
    end
    object EditMate: TcxComboBox
      Left = 84
      Top = 55
      ParentFont = False
      Properties.ReadOnly = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 1
      OnKeyPress = EditMateKeyPress
      Width = 145
    end
    object EditProvider: TcxButtonEdit
      Left = 84
      Top = 29
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.ButtonStyle = bts3D
      TabOrder = 0
      OnKeyPress = EditProviderKeyPress
      Width = 398
    end
    object EditValue: TcxTextEdit
      Left = 96
      Top = 133
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      TabOrder = 5
      Text = '0.00'
      Width = 161
    end
    object cxCheckBox1: TcxCheckBox
      Left = 11
      Top = 298
      Caption = #30003#35831#21333#29983#25928
      ParentFont = False
      State = cbsChecked
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      TabOrder = 12
      Width = 121
    end
    object cxLabel1: TcxLabel
      Left = 263
      Top = 133
      Caption = #35746#21333#30003#35831#37327'('#27880#65306'0'#19981#38480#21046#35746#21333')'
      ParentFont = False
    end
    object EditWarnValue: TcxTextEdit
      Left = 96
      Top = 159
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      TabOrder = 7
      Text = '0.00'
      Width = 161
    end
    object EditLimValue: TcxTextEdit
      Left = 96
      Top = 185
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      TabOrder = 9
      Text = '0.00'
      Width = 161
    end
    object cxLabel2: TcxLabel
      Left = 263
      Top = 159
      Caption = #21097#20313#37327#36229#36807#39044#35686#26102#65292#25552#31034#35746#21333#37327#19981#36275
      ParentFont = False
    end
    object cxLabel3: TcxLabel
      Left = 263
      Top = 185
      Caption = #20801#35768#35746#21333#36229#21457#30340#26368#22823#33539#22260
      ParentFont = False
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
          object dxLayoutControl1Item6: TdxLayoutItem
            CaptionOptions.Text = #20379' '#24212' '#21830':'
            Control = EditProvider
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item3: TdxLayoutItem
            CaptionOptions.Text = #21407#26448#26009#21517':'
            Control = EditMate
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item2: TdxLayoutItem
            CaptionOptions.Text = #39033#30446#21517#31216':'
            Control = EditProject
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
            object dxLayoutControl1Item8: TdxLayoutItem
              CaptionOptions.Text = #25152#23646#21306#22495':'
              Control = EditArea
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayoutControl1Group4: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item9: TdxLayoutItem
            CaptionOptions.Text = #35746#21333#37327'('#21544'):'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item7: TdxLayoutItem
            CaptionOptions.Text = #30003#35831#35746#21333#37327','#20540#20026'0'#26102#19981#38480#35746#21333#21457#36865#37327
            CaptionOptions.Visible = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group5: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item12: TdxLayoutItem
            CaptionOptions.Text = #39044#35686#37327'('#21544'):'
            Control = EditWarnValue
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item14: TdxLayoutItem
            CaptionOptions.Visible = False
            Control = cxLabel2
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group6: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item13: TdxLayoutItem
            CaptionOptions.Text = #19978#38480#37327'('#21544'):'
            Control = EditLimValue
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item15: TdxLayoutItem
            CaptionOptions.Text = 'cxLabel3'
            CaptionOptions.Visible = False
            Control = cxLabel3
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Item4: TdxLayoutItem
          CaptionOptions.Text = #22791#27880#20449#24687':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        AlignVert = avBottom
        CaptionOptions.Visible = False
        ButtonOptions.Buttons = <>
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item1: TdxLayoutItem
          CaptionOptions.Text = 'cxCheckBox1'
          CaptionOptions.Visible = False
          Control = cxCheckBox1
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
