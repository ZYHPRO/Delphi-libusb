object fmmain: Tfmmain
  Left = 0
  Top = 0
  Width = 684
  Height = 472
  AutoScroll = True
  Caption = 'LibusbList Devices Example'
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 668
    Height = 43
    Align = alTop
    BevelOuter = bvNone
    Caption = 
      'LibUSB 1.0  List Devs - libusb example program to list devices o' +
      'n the bus'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 0
    Top = 43
    Width = 668
    Height = 390
    Align = alClient
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 1
    ExplicitTop = 81
    ExplicitHeight = 352
  end
end
