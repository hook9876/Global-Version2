object Global: TGlobal
  Left = 637
  Top = 298
  Width = 1142
  Height = 656
  Caption = 'Global'
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
  object MemoCode: TMemo
    Left = 16
    Top = 24
    Width = 409
    Height = 369
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ButtonLoadFromFileCode: TButton
    Left = 464
    Top = 80
    Width = 121
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1076
    TabOrder = 1
    OnClick = ButtonLoadFromFileCodeClick
  end
  object ButtonMake: TButton
    Left = 464
    Top = 112
    Width = 121
    Height = 25
    Caption = #1057#1076#1077#1083#1072#1090#1100
    TabOrder = 2
    OnClick = ButtonMakeClick
  end
  object MemoResult: TMemo
    Left = 616
    Top = 24
    Width = 409
    Height = 369
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object OpenDialogCode: TOpenDialog
    Left = 560
    Top = 32
  end
end
