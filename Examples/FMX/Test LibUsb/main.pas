unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, libusb1,
  FMX.Edit;

type
  Tfmmain = class(TForm)
    ToolBar1: TToolBar;
    Label5: TLabel;
    Memo1: TMemo;
    ToolBar2: TToolBar;
    Btn_device: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure Btn_deviceClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
     private
  var
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmmain: Tfmmain;
  Memo1: TMemo;

implementation

uses testlibusb;

{$R *.fmx}

procedure Tfmmain.Btn_deviceClick(Sender: TObject);
begin
   if Edit1.Text= '0' then
   begin
  showmessage('Please enter a Valid Ref ID before processing...');
   exit;
   end
   else
   begin
  Memo1.lines.clear;
  device(Edit1.Text.ToInteger, Memo1);
   end;
end;



procedure Tfmmain.FormShow(Sender: TObject);
begin
    Edit1.Text := '0';
   getdevicelist(Memo1,Self);

end;

end.
