unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, libusb1,
  FMX.Edit, FMX.Layouts;

type
  Tfmmain = class(TForm)
    ToolBar1: TToolBar;
    Label5: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Layout1: TLayout;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmmain: Tfmmain;

implementation

{$R *.fmx}

procedure Tfmmain.FormCreate(Sender: TObject);
var
  libusbversion: Plibusb_version;
  dllv: string;
  Driverv: string;
begin
  libusbversion := libusb_get_version();
  // get Dll version information
{$IFDEF WIN64}
  dllv := ' 64 bit Dll version ';
  Driverv := '64 bit Driver version';
{$ENDIF}
{$IFDEF WIN32}
  dllv := ' 32 bit Dll version ';
  Driverv := '32 bit Driver version';
{$ENDIF}
  // show Dll info
  Label2.Text := dllv + inttostr(libusbversion.major) + '.' +
  inttostr(libusbversion.minor) + '.' + inttostr(libusbversion.micro) + '.' +
  inttostr(libusbversion.nano);
  Label4.Text := inttostr(ord(libusbversion.describe));
  Label7.Text := inttostr(ord(libusbversion.rc));
end;

end.
