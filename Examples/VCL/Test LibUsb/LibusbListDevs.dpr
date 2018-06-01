program LibusbListDevs;

uses
  Vcl.Forms,
  main in 'main.pas' {fmmain},
  libusb1 in '..\..\..\Src\libusb1.pas',
  libusb1helper in '..\..\..\Src\libusb1helper.pas',
  testlibusb in 'testlibusb.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfmmain, fmmain);
  Application.Run;
end.
