object Form1: TForm1
  Left = -8
  Top = 95
  Width = 1018
  Height = 521
  Caption = 'Generate MAP-Networks'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clNavy
  Font.Height = -13
  Font.Name = 'Times New Roman'
  Font.Style = [fsBold]
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDragDrop = FormDragDrop
  OnDragOver = FormDragOver
  PixelsPerInch = 96
  TextHeight = 15
  object lblYear: TLabel
    Left = 112
    Top = 9
    Width = 32
    Height = 19
    Caption = 'Year'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 232
    Top = 9
    Width = 40
    Height = 19
    Caption = 'Week'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 30
    Top = 8
    Width = 23
    Height = 22
    Glyph.Data = {
      4E010000424D4E01000000000000760000002800000012000000120000000100
      040000000000D800000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      FFFFFF000000FFFFFFFF00FFFFFFFF000000FFFFFFFF00FFFFFFFF000000FFFF
      FFF00CCFFFFFFF000000FFFFFFF00CCFFFFFFF000000FFFFFF00CCCCFFFFFF00
      0000FFFFFF00CCCCFFFFFF000000FFFFF00CCCCCCFFFFF000000FFFFF00CCCCC
      CFFFFF000000FFFF00CCCCCCCCFFFF000000FFFF00CFFFFFCCFFFF000000FFF0
      0CCCCCCCCCCFFF000000FFF00CCFFFFFCCCFFF000000FF00CCCCCCCCCCCCFF00
      0000FF00CCFFFFFFFCCCFF000000F00CCCCCCCCCCCCCCF000000F00CCCCCCCCC
      CCCCCF000000FFFFFFFFFFFFFFFFFF000000}
    OnClick = SpeedButton1Click
  end
  object Label2: TLabel
    Left = 354
    Top = 9
    Width = 52
    Height = 19
    Caption = 'Horizon'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SpeedButton3: TSpeedButton
    Left = 52
    Top = 8
    Width = 23
    Height = 22
    Glyph.Data = {
      4E010000424D4E01000000000000760000002800000012000000120000000100
      040000000000D800000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      FFFFFF000000FFCFFFFFFFFFFFFFFF000000FCCCFFFFFFFFFFFFFF000000FFC0
      000FFFFFFFFFFF000000FFF00FF000FFFFFFFF000000FFF0F0FFFF000FFFFF00
      0000FFF0FF0FFFFFF0009F000000FFFF0FF0FFFFFFF999000000FFFF0FFF0FFF
      FFFF9F000000FFFF0FFFF0FFFFFFFF000000FFFFF0FFFF0FFFFFFF000000FFFF
      F0FFFFF0FFFFFF000000FFFFF0FFFFFF0FFFFF000000FFFFFF0FFFFFF0FFFF00
      0000FFFFFF0FFFFFFF09FF000000FFFFFF09FFFFFF999F000000FFFFFF999FFF
      FFF9FF000000FFFFFFF9FFFFFFFFFF000000}
  end
  object SpeedButton4: TSpeedButton
    Left = 7
    Top = 8
    Width = 23
    Height = 22
    Glyph.Data = {
      4E010000424D4E01000000000000760000002800000012000000120000000100
      040000000000D800000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      FFFFFF000000FFFFFFFF00FFFFFFFF000000FFFFFFFF00FFFFFFFF000000FFFF
      FFF00AAFFFFFFF000000FFFFFFF00AAFFFFFFF000000FFFFFF00AAAAFFFFFF00
      0000FFFFFF00AAAAFFFFFF000000FFFFF00AAAAAAFFFFF000000FFFFF00AAAAA
      AFFFFF000000FFFF00AAAAAAAAFFFF000000FFFF00AFFFFFAAFFFF000000FFF0
      0AAAAAAAAAAFFF000000FFF00AAFFFFFAAAFFF000000FF00AAAAAAAAAAAAFF00
      0000FF00AAFFFFFFFAAAFF000000F00AAAAAAAAAAAAAAF000000F00AAAAAAAAA
      AAAAAF000000FFFFFFFFFFFFFFFFFF000000}
    OnClick = SpeedButton4Click
  end
  object edtYear: TEdit
    Left = 156
    Top = 6
    Width = 49
    Height = 23
    TabOrder = 0
    Text = '2001'
    OnKeyDown = edtYearKeyDown
  end
  object edtWeek: TEdit
    Left = 284
    Top = 6
    Width = 49
    Height = 23
    TabOrder = 1
    Text = '2'
    OnKeyDown = edtWeekKeyDown
  end
  object edtHorizon: TEdit
    Left = 416
    Top = 6
    Width = 49
    Height = 23
    TabOrder = 2
    Text = '26'
    OnKeyDown = edtHorizonKeyDown
  end
  object TreeView1: TTreeView
    Left = 8
    Top = 56
    Width = 209
    Height = 361
    DragMode = dmAutomatic
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    HideSelection = False
    Images = ImageList1
    Indent = 24
    ParentFont = False
    PopupMenu = PopupMenu1
    RightClickSelect = True
    StateImages = ImageList1
    TabOrder = 3
    OnDblClick = TreeView1DblClick
    OnDragDrop = TreeView1DragDrop
    OnDragOver = TreeView1DragOver
  end
  object GroupBox1: TGroupBox
    Left = 256
    Top = 96
    Width = 9
    Height = 9
    Caption = 'GroupBox1'
    TabOrder = 4
  end
  object MainMenu1: TMainMenu
    Left = 496
    object File1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Caption = 'New'
        OnClick = New1Click
      end
      object load1: TMenuItem
        Caption = 'Load'
        OnClick = load1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
      object UsertoPlanning1: TMenuItem
        Caption = 'User to Planning'
        OnClick = UsertoPlanning1Click
      end
      object PlanningtoUser1: TMenuItem
        Caption = 'Planning to User'
        OnClick = PlanningtoUser1Click
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'dat'
    Filter = 'MAP Data Files|*.dat'
    Left = 568
  end
  object OpenDialog1: TOpenDialog
    InitialDir = 'D:\jss\Projecten\E2653-Collaborative Planning III\Delphi'
    Left = 528
  end
  object PopupMenu1: TPopupMenu
    Left = 608
    object New2: TMenuItem
      Caption = 'New Folder'
      OnClick = New2Click
    end
    object Copy1: TMenuItem
      Caption = 'Cut'
      OnClick = Copy1Click
    end
    object Paste1: TMenuItem
      Caption = 'Paste'
      OnClick = Paste1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
    end
  end
  object ImageList1: TImageList
    Height = 21
    Width = 21
    Left = 648
    Bitmap = {
      494C010103000400040015001500FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000054000000150000000100100000000000C80D
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000060000000000000000FF7FE07FFF7F
      000000000000FF7FE07FFF7FE07FFF7FE07FFF7F000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001A1D000000000000
      0000E07FFF7FE07FFF7F0000FF7FE07FFF7FE07FFF7FE07FFF7FE07F00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      840D0000000000000000FF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7F
      E07FFF7F00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000F75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
      F75EF75EF75EF75EF75EF75EF75EF75EF75E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000F75EF75EF75EF75EF75EF75EF75EF75E
      F75EF75EF75EF75EF75EF75EF75EF75EF75EFF7FF75EF75EF75E000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000E003E00300000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001F001F00000000000000000000000000000000000000F75EF75EF75EF75E
      F75EFF7FF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
      F75E0000000000000000FF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7F
      E07FFF7F00000000000000000000000000000000000000000000000000000000
      E003E00300000000000000000000000000000000000000000000000000000000
      000000000000000000001F001F00000000000000000000000000000000000000
      FF7FFF7FFF7FFF5EF75EFF7FFF7FFF7FFF7FFF3DEF3DFF7FFF7FFF7FFF7FFF3D
      EF3DF75EF75EF75EF75E0000000000000000E07FFF7FE07FFF7FE07FFF7FE07F
      FF7FE07FFF7FE07FFF7FE07F0000000000000000000000000000000000000000
      000000000000E003E003E003E003000000000000000000000000000000000000
      000000000000000000000000000000001F001F001F001F000000000000000000
      00000000000000001F7CBC3F783EBF5EF75E70001F7C803F7800BF5EF75E7000
      1F7EBC7F7C3EFF5EF75E70001F7E807F7C000000000000000000FF7FE07FFF7F
      E07F000000000000000000000000FF7FE07FFF7F000000000000000000000000
      0000000000000000000000000000E003E003E003E00300000000000000000000
      0000000000000000000000000000000000000000000000001F001F001F001F00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E07FFF7FE07FFF7F0000FF7FE07FFF7FE07FFF7FE07FFF7FE07F00000000
      0000000000000000000000000000000000000000E003E003E003E003E003E003
      0000000000000000000000000000000000000000000000000000000000001F00
      1F001F001F001F001F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF7FE07FFF7FE07F0000E07FFF7FE07FFF7FE07FFF7F
      E07FFF7F000000000000000000000000000000000000000000000000E003E003
      E003E003E003E003000000000000000000000000000000000000000000000000
      0000000000001F001F001F001F001F001F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E07FFF7F00000000000000000000
      FF7FE07FFF7FE07FFF7FE07F0000000000000000000000000000000000000000
      0000E003E003E003E003E003E003E003E0030000000000000000000000000000
      0000000000000000000000001F001F001F001F001F001F001F001F0000000000
      0000000000000000EF1EEF1EEF1EEF1EEF1E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF7FE07FFF7F
      000000000000FF7FE07FFF7FE07FFF7FE07FFF7F000000000000000000000000
      00000000000000000000E00300000000000000000000E003E003000000000000
      00000000000000000000000000000000000000001F0000000000000000000000
      1F001F0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E07FFF7FE07FFF7F0000FF7FE07FFF7FE07FFF7FE07FFF7FE07F00000000
      00000000000000000000000000000000E003E003E003E003E003E003E003E003
      E003E003000000000000000000000000000000000000000000001F001F001F00
      1F001F001F001F001F001F001F0000000000000000000000EF1EEF1EEF1EEF1E
      EF1EEF1EEF1EEF1EEF1EEF1EEF1EEF1EEF1E0000000000000000000000000000
      00000000000000000000FF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7F
      E07FFF7F0000000000000000000000000000000000000000E003E00300000000
      000000000000E003E003E0030000000000000000000000000000000000000000
      00001F001F00000000000000000000001F001F001F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E003
      E003E003E003E003E003E003E003E003E003E003E00300000000000000000000
      00000000000000001F001F001F001F001F001F001F001F001F001F001F001F00
      0000000000000000070007000700EF1E0700E81EEF1EEF1EEF1EEF1EEF1EEF1E
      EF1EEF1EEF1EEF1EEF1EEF1EEF1EEF1EEF1E00000000000000000000E07FFF7F
      E07FFF7FE07F0000000000000000000000000000000000000000000000000000
      000000000000E003E0030000000000000000000000000000E003E003E0030000
      000000000000000000000000000000001F001F00000000000000000000000000
      00001F001F001F00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000E003E003E003E003E003E003E003E003E003E003
      E003E003E003E00300000000000000000000000000001F001F001F001F001F00
      1F001F001F001F001F001F001F001F001F00000000000000EF1EEF1EEF1EEF1E
      E81E070007000700070007000700EF1E07000700EF1EEF1EEF1EEF1EEF1EEF1E
      EF1E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000E003E003E003E003E003E003
      E003E003E003E003E003E003E003E00300000000000000000000000000001F00
      1F001F001F001F001F001F001F001F001F001F001F001F001F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000EF1EEF1EEF1EEF1EEF1EEF1EEF1EEF1EEF1EEF1EEF1EEF1E
      070007000700070007000700EF1E070007000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424D3E000000
      000000003E0000002800000054000000150000000100010000000000FC000000
      0000000000000000000000000000000000000000FFFFFF00FFFFFFFFFFFFFFFF
      FFFFF000FFFFFFFFFFFFFFFE1F00F000FFFFFFFFFFFFFFFFFFFFF000FFFFFFFC
      FFFFE7FE1F001000FFFFFFFCFFFFE7FE1F001000E0003FF87FFFC3FE1F001000
      E0003FF87FFFC3FFFFFFF000E0003FF03FFF81FE1F001000E0003FF03FFF81FE
      1F001000E0003FE01FFF00FF00000000E0003FE01FFF00FFFFFFF000E0003FC0
      0FFE007FFFFFF000E0003FC7CFFE3E7FFFFFF000E0003F8007FC003FFFFFF000
      E0003F87C7FC3E3FFFFFF000E0007F0003F8001FFFFFF000F01FFF0FE3F87F1F
      FFFFF000F83FFE0001F0000FFFFFF000FFFFFE0001F0000FFFFFF000FFFFFFFF
      FFFFFFFEFFFFF000FFFFFFFFFFFFFFFE00000000000000000000000000000000
      00000000000000000000}
  end
end
