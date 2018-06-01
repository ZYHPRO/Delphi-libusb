program VCLVersion;

uses
  Vcl.Forms,
  vclmain in 'vclmain.pas' {fmvclmain},
  libusb1 in '..\..\..\Src\libusb1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfmvclmain, fmvclmain);
  Application.Run;
end.
