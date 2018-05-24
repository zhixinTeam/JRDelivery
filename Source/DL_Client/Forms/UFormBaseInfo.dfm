inherited fFormBaseInfo: TfFormBaseInfo
  Left = 550
  Top = 270
  Width = 652
  Height = 464
  BorderIcons = [biSystemMenu]
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayout1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 636
    Height = 426
    Align = alClient
    TabOrder = 0
    TabStop = False
    LayoutLookAndFeel = FDM.dxLayoutWeb1
    object InfoTv1: TcxTreeView
      Left = 23
      Top = 36
      Width = 138
      Height = 273
      Align = alClient
      DragMode = dmAutomatic
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
      OnClick = InfoTv1Click
      OnDblClick = InfoTv1DblClick
      OnDragDrop = InfoTv1DragDrop
      OnDragOver = InfoTv1DragOver
      HideSelection = False
      Images = FDM.ImageBar
      ReadOnly = True
      OnChange = InfoTv1Change
      OnDeletion = InfoTv1Deletion
    end
    object InfoList1: TcxMCListBox
      Left = 330
      Top = 36
      Width = 282
      Height = 97
      HeaderSections = <
        item
          DataIndex = 1
          Text = #33410#28857
          Width = 74
        end
        item
          AutoSize = True
          DataIndex = 2
          Text = #22791#27880
          Width = 204
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 1
      OnClick = InfoList1Click
      OnDblClick = InfoTv1DblClick
    end
    object EditText: TcxTextEdit
      Left = 388
      Top = 268
      ParentFont = False
      Properties.MaxLength = 50
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      OnExit = EditTextExit
      Width = 121
    end
    object EditPY: TcxTextEdit
      Left = 388
      Top = 293
      TabStop = False
      ParentFont = False
      Properties.MaxLength = 25
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      Width = 121
    end
    object EditMemo: TcxMemo
      Left = 388
      Top = 318
      ParentFont = False
      Properties.MaxLength = 50
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Height = 63
      Width = 225
    end
    object BtnAdd: TButton
      Left = 417
      Top = 386
      Width = 62
      Height = 22
      Caption = #28155#21152
      TabOrder = 5
      OnClick = BtnAddClick
    end
    object BtnDel: TButton
      Left = 484
      Top = 386
      Width = 62
      Height = 22
      Caption = #21024#38500
      TabOrder = 6
      OnClick = BtnDelClick
    end
    object BtnSave: TButton
      Left = 551
      Top = 386
      Width = 62
      Height = 22
      Caption = #20445#23384
      TabOrder = 7
      OnClick = BtnSaveClick
    end
    object dxLayout1Group_Root: TdxLayoutGroup
      AlignHorz = ahParentManaged
      AlignVert = avParentManaged
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      object dxLayout1Group1: TdxLayoutGroup
        AlignHorz = ahClient
        CaptionOptions.Text = #26641#24418#26174#31034
        ButtonOptions.Buttons = <>
        object dxLayout1Item1: TdxLayoutItem
          AlignVert = avClient
          CaptionOptions.Text = #26641#29366#21015#34920
          CaptionOptions.Visible = False
          Control = InfoTv1
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayout1Group4: TdxLayoutGroup
        AlignHorz = ahRight
        CaptionOptions.Visible = False
        ButtonOptions.Buttons = <>
        Hidden = True
        ShowBorder = False
        object dxLayout1Group2: TdxLayoutGroup
          AlignVert = avClient
          CaptionOptions.Text = #21015#34920#26174#31034
          ButtonOptions.Buttons = <>
          object dxLayout1Item2: TdxLayoutItem
            AlignVert = avClient
            CaptionOptions.Text = 'cxMCListBox1'
            CaptionOptions.Visible = False
            Control = InfoList1
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group3: TdxLayoutGroup
          AlignVert = avBottom
          CaptionOptions.Text = #32534#36753#21306
          ButtonOptions.Buttons = <>
          object dxLayout1Item4: TdxLayoutItem
            CaptionOptions.Text = #33410#28857#20869#23481':'
            Control = EditText
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            CaptionOptions.Text = #25340#38899#31616#20889':'
            Control = EditPY
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            CaptionOptions.Text = #22791#27880#20449#24687':'
            Control = EditMemo
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group5: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              AlignHorz = ahRight
              CaptionOptions.Text = 'Button1'
              CaptionOptions.Visible = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item8: TdxLayoutItem
              AlignHorz = ahRight
              CaptionOptions.Text = 'Button2'
              CaptionOptions.Visible = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item9: TdxLayoutItem
              AlignHorz = ahRight
              CaptionOptions.Text = 'Button3'
              CaptionOptions.Visible = False
              Control = BtnSave
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
    end
  end
end
