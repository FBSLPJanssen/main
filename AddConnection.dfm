object Form2: TForm2
  Left = 370
  Top = 162
  Width = 398
  Height = 352
  Caption = 'Add Connection'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 34
    Top = 54
    Width = 132
    Height = 16
    Caption = 'Source Component'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 202
    Top = 54
    Width = 129
    Height = 16
    Caption = 'Target Component'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cbSource: TComboBox
    Left = 31
    Top = 76
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'cbSource'
    OnChange = cbSourceChange
  end
  object cbTarget: TComboBox
    Left = 200
    Top = 78
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'cbTarget'
    OnChange = cbTargetChange
  end
  object Button1: TButton
    Left = 104
    Top = 272
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 192
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
