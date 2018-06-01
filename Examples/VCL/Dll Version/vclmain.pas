unit vclmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,libusb1;

type
  Tfmvclmain = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmvclmain: Tfmvclmain;

implementation

{$R *.dfm}

procedure Tfmvclmain.FormCreate(Sender: TObject);
var
 libusbversion: Plibusb_version;
 dllv:string;
 Driverv:string;
 begin
  libusbversion:= libusb_get_version();
  //get Dll version information
  {$IFDEF WIN64}
   dllv:= ' 64 bit Dll version ';
   Driverv:= '64 bit Driver version' ;
  {$ENDIF}
   {$IFDEF WIN32}
   dllv:= ' 32 bit Dll version ';
   DriverV:= '32 bit Driver version';
  {$ENDIF}
  //show Dll info
  label4.caption:= dllv +
  inttostr(libusbversion.major)+ '.'+
  inttostr(libusbversion.minor) +'.'+
  inttostr(libusbversion.micro) +'.'+
  inttostr(libusbversion.nano)   ;
  label5.caption:=  inttostr(ord(libusbversion.describe));
  label6.caption:=  inttostr(ord(libusbversion.rc));
   end;

end.
