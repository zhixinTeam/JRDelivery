inherited fFormGetPOrderBase: TfFormGetPOrderBase
  Left = 401
  Top = 134
  Width = 616
  Height = 384
  BorderStyle = bsSizeable
  Constraints.MinHeight = 300
  Constraints.MinWidth = 445
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 600
    Height = 346
    inherited BtnOK: TButton
      Left = 454
      Top = 313
      Caption = #30830#23450
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 524
      Top = 313
      TabOrder = 6
    end
    object EditProvider: TcxButtonEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object ListQuery: TcxListView [3]
      Left = 23
      Top = 133
      Width = 417
      Height = 145
      Columns = <
        item
          Caption = #30003#35831#21333#32534#21495
          Width = 70
        end
        item
          Caption = #21407#26448#26009
          Width = 90
        end
        item
          AutoSize = True
          Caption = #20379#24212#21830
        end
        item
          Caption = #35746#21333#21097#20313
          Width = 90
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 4
      ViewStyle = vsReport
      OnDblClick = ListQueryDblClick
      OnKeyPress = ListQueryKeyPress
    end
    object cxLabel1: TcxLabel [4]
      Left = 23
      Top = 112
      Caption = #26597#35810#32467#26524':'
      ParentFont = False
      Transparent = True
    end
    object EditMate: TcxButtonEdit [5]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
      Width = 121
    end
    object ck30Days: TcxCheckBox [6]
      Left = 23
      Top = 86
      Caption = #20165#26174#31034#26368#36817'30'#22825
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 2
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        CaptionOptions.Text = #26597#35810#26465#20214
        object dxLayout1Item5: TdxLayoutItem
          CaptionOptions.Text = #20379' '#24212' '#21830':'
          Control = EditProvider
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = #21407' '#26448' '#26009':'
          Control = EditMate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          CaptionOptions.Text = 'cxCheckBox1'
          CaptionOptions.Visible = False
          Control = ck30Days
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          CaptionOptions.Text = 'cxLabel1'
          CaptionOptions.Visible = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          AlignVert = avClient
          CaptionOptions.Text = #26597#35810#32467#26524':'
          CaptionOptions.Visible = False
          Control = ListQuery
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
