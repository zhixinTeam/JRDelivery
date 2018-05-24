inherited fFormPurchaseOrder: TfFormPurchaseOrder
  Left = 451
  Top = 243
  ClientHeight = 334
  ClientWidth = 477
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 477
    Height = 334
    OptionsItem.AutoControlTabOrders = False
    inherited BtnOK: TButton
      Left = 331
      Top = 301
      Caption = #24320#21333
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 401
      Top = 301
      TabOrder = 10
    end
    object EditValue: TcxTextEdit [2]
      Left = 279
      Top = 236
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 7
      Text = '0.00'
      OnKeyPress = EditLadingKeyPress
      Width = 138
    end
    object EditMate: TcxTextEdit [3]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.MaxLength = 15
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 1
      OnKeyPress = EditLadingKeyPress
      Width = 125
    end
    object EditID: TcxTextEdit [4]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.MaxLength = 100
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 0
      OnKeyPress = EditLadingKeyPress
      Width = 125
    end
    object EditProvider: TcxTextEdit [5]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      OnKeyPress = EditLadingKeyPress
      Width = 121
    end
    object EditSalesMan: TcxTextEdit [6]
      Left = 81
      Top = 111
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      OnKeyPress = EditLadingKeyPress
      Width = 121
    end
    object EditProject: TcxTextEdit [7]
      Left = 81
      Top = 161
      ParentFont = False
      Properties.ReadOnly = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      OnKeyPress = EditLadingKeyPress
      Width = 121
    end
    object EditArea: TcxTextEdit [8]
      Left = 81
      Top = 136
      ParentFont = False
      Properties.ReadOnly = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      OnKeyPress = EditLadingKeyPress
      Width = 121
    end
    object EditTruck: TcxButtonEdit [9]
      Left = 81
      Top = 236
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 6
      OnKeyPress = EditLadingKeyPress
      Width = 135
    end
    object EditCardType: TcxComboBox [10]
      Left = 81
      Top = 261
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        'L=L'#12289#20020#26102#21345
        'G=G'#12289#38271#26399#21345)
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 13
      Width = 121
    end
    object cxLabel1: TcxLabel [11]
      Left = 221
      Top = 261
      Caption = #27880':'#20020#26102#21345#20986#21378#26102#22238#25910';'#22266#23450#21345#20986#21378#26102#19981#22238#25910
      ParentFont = False
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxGroupLayout1Group2: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #30003#35831#21333#21495':'
            Control = EditID
            ControlOptions.ShowBorder = False
          end
          object dxlytmLayout1Item3: TdxLayoutItem
            CaptionOptions.Text = #20379' '#24212' '#21830':'
            Control = EditProvider
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item9: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #21407' '#26448' '#26009':'
            Control = EditMate
            ControlOptions.ShowBorder = False
          end
        end
        object dxlytmLayout1Item6: TdxLayoutItem
          CaptionOptions.Text = #19994' '#21153' '#21592':'
          Control = EditSalesMan
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item8: TdxLayoutItem
          CaptionOptions.Text = #25152#23646#21306#22495':'
          Control = EditArea
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item7: TdxLayoutItem
          CaptionOptions.Text = #39033#30446#21517#31216':'
          Control = EditProject
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AlignVert = avClient
        CaptionOptions.Text = #25552#21333#20449#24687
        ButtonOptions.Buttons = <>
        LayoutDirection = ldHorizontal
        object dxLayout1Group2: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxlytmLayout1Item12: TdxLayoutItem
            CaptionOptions.Text = #25552#36135#36710#36742':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item3: TdxLayoutItem
            CaptionOptions.Text = #21345#29255#31867#22411':'
            Control = EditCardType
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayout1Item8: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #21150#29702#21544#25968':'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            CaptionOptions.Text = 'cxLabel1'
            CaptionOptions.Visible = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
