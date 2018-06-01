(* Example ListDevs translated to Delphi by Greg Bayes
  *   Version 1
  *
  libusb example program to list devices on the bus
  * Copyright © 2007 Daniel Drake <dsd@gentoo.org> *)
unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, libusb1;

type
  Tfmmain = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    procedure getdev(dev: plibusb_device);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmmain: Tfmmain;
  Memo1: TMemo;

implementation

{$R *.dfm}

procedure TfmMain.getdev(dev: plibusb_device);
var
  i, j, k, r, s: integer;
  desc: libusb_device_descriptor;
  config: plibusb_config_descriptor;
  inter: plibusb_interface;
  interdesc: plibusb_interface_descriptor;
  epdesc: plibusb_endpoint_descriptor;
  path: array [0 .. 8] of byte;
begin
  r := libusb_get_device_descriptor(dev, @desc);
  if r <> 0 then
  begin
    Memo1.lines.add('failed to get device descriptor');
    exit;
  end
  else
  begin
    Memo1.lines.add('No of possible configurations : ' +
      inttostr(desc.bNumConfigurations) + '  Device Class : ' +
      inttostr(desc.bDeviceClass));
    Memo1.lines.add('Bus : ' + inttostr(libusb_get_bus_number(dev)) +
      '  Device : ' + inttostr(libusb_get_device_address(dev)) +
      '   Vender ID : ' + inttostr(desc.idVendor) + '  Product ID : ' +
      inttostr(desc.idProduct));
    r := libusb_get_port_numbers(dev, @path, sizeof(path));
    if r > 0 then
    begin
      for j := 1 to r - 1 do
      begin
        Memo1.lines.add('path:  ' + path[j].tostring);
      end;
    end;
    Memo1.lines.add
      ('----------------------------------------------------------------');
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
  i, count: ssize_t;
  r: integer;
  devs: pplibusb_device;
  arrdev: array of plibusb_device;
  context: plibusb_context;
begin
  // List devices
  Memo1.lines.clear;
  context := nil; // declare the pointer to null
  r := libusb_init(context);
  if r <> 0 then
  begin
    Memo1.lines.add('Cannot initialize the DLL Device Value ' + r.tostring +
      'is less than 0');
    exit;
  end
  else
  begin
    Memo1.lines.add('DLL Initialized  - Device is connected');
  end;

  Memo1.lines.add('');
  count := libusb_get_device_list(context, @devs);
  //set the array's size to the count
//  setlength(arrdev, count);
 // libusb_free_device_list(devs, 1); // we now know how many devices there are

  if count < 1 then
  begin
    Memo1.lines.add('No devices found ');
    exit;
  end
  else
  begin

   // libusb_get_device_list(context, @arrdev); // set new devicelist with dev

    Memo1.lines.add('USB Devices found : ' + inttostr(count));
    Memo1.lines.add('');
    Memo1.lines.add('Bus   Device   VID id   PID id   Paths');
    Memo1.lines.add
      ('-------------------------------------------------------------------');
    for i := 0 to count - 1 do
    begin
      Memo1.lines.add('USB device on system no :  ' + inttostr(i + 1));
      getdev(devs^);
     // getdev(arrdev[i]);
    end;
    (*Cannot use the  function free_ device_list with an array of Plibusb_devices
     so have to de_ref each Plibdevice one by one from last to first *)

     libusb_free_device_list(devs,1);
   // for I  := high(arrdev) to low(arrdev) do
   // libusb_unref_device(arrdev[i]);
    libusb_exit(context);
  end;
end;

end.
