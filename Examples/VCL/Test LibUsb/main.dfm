object fmmain: Tfmmain
  Left = 0
  Top = 0
  Width = 684
  Height = 472
  AutoScroll = True
  Caption = 'LibusbTestusb Example'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 668
    Height = 43
    Align = alTop
    BevelOuter = bvNone
    Caption = 'LibUSB 1.0 TestLibUSB'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 0
    Top = 81
    Width = 668
    Height = 352
    Align = alClient
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 1
    ExplicitLeft = -8
    ExplicitTop = 80
  end
  object Panel2: TPanel
    Left = 0
    Top = 43
    Width = 668
    Height = 38
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label1: TLabel
      Left = 13
      Top = 10
      Width = 85
      Height = 13
      Caption = 'Set Device Ref ID'
    end
    object Edit1: TEdit
      Left = 104
      Top = 6
      Width = 49
      Height = 25
      TabOrder = 0
      Text = 'Edit1'
    end
    object btn_device: TButton
      Left = 184
      Top = 6
      Width = 273
      Height = 25
      Caption = 'Process Device'
      TabOrder = 1
      OnClick = btn_deviceClick
    end
  end
end
