program bulktransfer;

uses
  System.StartUpCopy,
  FMX.Forms,
  main in 'main.pas' {fmmain},
  libusb1 in '..\..\..\Src\libusb1.pas',
  libusb1helper in '..\..\..\Src\libusb1helper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfmmain, fmmain);
  Application.Run;
end.
