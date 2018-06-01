program Bulk_Transfer;

uses
  Vcl.Forms,
  main in 'main.pas' {fmmain},
  libusb1 in '..\..\..\Src\libusb1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfmmain, fmmain);
  Application.Run;
end.
