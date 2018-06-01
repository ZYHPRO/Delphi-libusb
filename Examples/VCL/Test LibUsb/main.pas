unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,libusb1,testlibusb;

type
  Tfmmain = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Panel2: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    btn_device: TButton;
    procedure btn_deviceClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
     { Private declarations }
  public
    { Public declarations }
  end;

var
  fmmain: Tfmmain;
  Memo1: TMemo;

implementation

{$R *.dfm}

procedure Tfmmain.btn_deviceClick(Sender: TObject);
begin
   if Edit1.Text= '0' then
   begin
  showmessage('Please enter a Valid Ref ID before processing...');
   exit;
   end
   else
   begin
  Memo1.lines.clear;
  device(strtoint(Edit1.Text), Memo1);
   end;
end;

procedure Tfmmain.FormShow(Sender: TObject);
begin
   Edit1.Text := '0';
   getdevicelist(Memo1,Self);
end;

end.


