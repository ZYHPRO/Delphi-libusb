object fmmain: Tfmmain
  Left = 0
  Top = 0
  Caption = 'fmmain'
  ClientHeight = 405
  ClientWidth = 522
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 58
    Width = 17
    Height = 13
    Caption = 'VID'
  end
  object Label2: TLabel
    Left = 16
    Top = 85
    Width = 17
    Height = 13
    Caption = 'PID'
  end
  object Label3: TLabel
    Left = 16
    Top = 144
    Width = 36
    Height = 13
    Caption = 'EP OUT'
  end
  object Label4: TLabel
    Left = 288
    Top = 139
    Width = 26
    Height = 13
    Caption = 'EP IN'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 522
    Height = 41
    Align = alTop
    Caption = 'Libusb 1.0Bulk Transfer'
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
    Top = 194
    Width = 522
    Height = 211
    Align = alBottom
    ParentShowHint = False
    ScrollBars = ssVertical
    ShowHint = False
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 104
    Top = 55
    Width = 145
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 104
    Top = 82
    Width = 145
    Height = 21
    TabOrder = 3
    Text = 'Edit2'
  end
  object Edit3: TEdit
    Left = 104
    Top = 136
    Width = 145
    Height = 21
    TabOrder = 4
    Text = 'Edit3'
  end
  object Edit4: TEdit
    Left = 344
    Top = 136
    Width = 155
    Height = 21
    TabOrder = 5
    Text = 'Edit4'
  end
  object Edit5: TEdit
    Left = 104
    Top = 109
    Width = 30
    Height = 21
    TabOrder = 6
    Text = 'Edit5'
  end
  object Edit6: TEdit
    Left = 140
    Top = 109
    Width = 30
    Height = 21
    TabOrder = 7
    Text = 'Edit6'
  end
  object Edit7: TEdit
    Left = 176
    Top = 109
    Width = 30
    Height = 21
    TabOrder = 8
    Text = 'Edit7'
  end
  object Edit8: TEdit
    Left = 219
    Top = 109
    Width = 30
    Height = 21
    TabOrder = 9
    Text = 'Edit8'
  end
  object btnwrite: TButton
    Left = 38
    Top = 163
    Width = 211
    Height = 25
    Caption = 'Bulk Transfer Out'
    TabOrder = 10
    OnClick = btnwriteClick
  end
  object btnread: TButton
    Left = 288
    Top = 163
    Width = 211
    Height = 25
    Caption = 'Bulk Transfer In'
    TabOrder = 11
    OnClick = btnreadClick
  end
end
