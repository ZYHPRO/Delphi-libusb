program LibusbListDevs;

uses
  System.StartUpCopy,
  FMX.Forms,
  main in 'main.pas' {fmMain},
  libusb1 in '..\..\..\Src\libusb1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
