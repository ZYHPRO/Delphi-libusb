program LibusbTestusb;

uses
  System.StartUpCopy,
  FMX.Forms,
  main in 'main.pas' {fmmain},
  testlibusb in 'testlibusb.pas',
  libusb1 in '..\..\..\Src\libusb1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfmmain, fmmain);
  Application.Run;
end.
