object Form3: TForm3
  Left = 300
  Top = 225
  Width = 373
  Height = 220
  Caption = 'Add Stockpoint'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 149
    Top = 16
    Width = 46
    Height = 16
    Caption = 'Name '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 67
    Top = 37
    Width = 128
    Height = 16
    Caption = 'Expected Demand'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 1
    Top = 59
    Width = 194
    Height = 16
    Caption = 'Standard deviation Demand'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 130
    Top = 80
    Width = 65
    Height = 16
    Caption = 'Leadtime'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 121
    Top = 101
    Width = 74
    Height = 16
    Caption = 'Stocknorm'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 88
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 192
    Top = 143
    Width = 75
    Height = 27
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object edtName: TEdit
    Left = 199
    Top = 5
    Width = 121
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnChange = edtNameChange
  end
  object edtED: TEdit
    Left = 199
    Top = 30
    Width = 121
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnKeyDown = edtEDKeyDown
  end
  object edtSD: TEdit
    Left = 199
    Top = 55
    Width = 121
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnKeyDown = edtSDKeyDown
  end
  object edtLeadtime: TEdit
    Left = 199
    Top = 76
    Width = 121
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnKeyDown = edtLeadtimeKeyDown
  end
  object edtStocknorm: TEdit
    Left = 199
    Top = 101
    Width = 121
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnKeyDown = edtStocknormKeyDown
  end
end
