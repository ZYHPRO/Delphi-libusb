
(* Translated to Delphi pascal By Greg Bayes  12/02/2018
  ------------------------------------------------------------
  Original C/C++ Test suite program based of libusb-0.1-compat testlibusb
  * Copyright (c) 2013 Nathan Hjelm <hjelmn@mac.ccom> *)

unit testlibusb;

interface

uses System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, Libusb1, FMX.Memo, FMX.Dialogs;

const
  verbose: integer = 0;

procedure getdevicelist(var Memo: Tmemo;sender:Tobject);
procedure endpoint_comp(ep_comp: plibusb_ss_endpoint_companion_descriptor;
  var Memo: Tmemo);
procedure endpoint(endpoint: plibusb_endpoint_descriptor; var Memo: Tmemo);
procedure usb2_0_ext_cap(usb_2_0_ext_cap: plibusb_usb_2_0_extension_descriptor;
  var Memo: Tmemo);
procedure ss_usb_cap(s_usb_cap: plibusb_ss_usb_device_capability_descriptor;
  var Memo: Tmemo);
procedure bos(handle: plibusb_device_handle; var Memo: Tmemo);
procedure interface_process(inter: plibusb_interface; var Memo: Tmemo);
procedure configuration(config: plibusb_config_descriptor; var Memo: Tmemo);
function device(deviceno: integer; var Memo: Tmemo): integer;
procedure extrainfo(dev: plibusb_device; Memo: Tmemo);
function textload:string;

implementation


procedure getdevicelist(var Memo: Tmemo;sender:Tobject);
var
  count: ssize_t;
s, p, i,rs, r, op: integer;
  context: plibusb_context;
  devhandle: plibusb_device_handle;
  arrdev: array  of plibusb_device;
    devs: pplibusb_device;
  begin
   // List devices
  Memo.lines.clear;
  Memo.lines.add(textload);
  Memo.lines.add
    ('---------------------------------------------------------------------------------------------------------------');
  context := nil; // declare the pointer to null

  r := libusb_init(context);

  if r <> 0 then
  begin
    Memo.lines.add('Cannot initialize the DLL Device Value ' + r.ToString +
      'is less than 0');
    exit;
  end
  else
   begin
    Memo.lines.add('DLL Initialized  - Device connected');
 count := libusb_get_device_list(context,@devs);
   setlength(arrdev,count);
  libusb_free_device_list(devs,1);

  if count < 1 then
  begin
    Memo.lines.add('No devices found ');
   exit;
  end
  else
   begin
    Memo.lines.add('***USB  Activate Devices found :  ' + inttostr(count)
      + ' ***');
    Memo.lines.add('  Device VID / PID     Device extended Information');
    Memo.lines.add('-------------------------------------------------------');
    op := -1;

   rs:= libusb_get_device_list(context,@arrdev);
    if rs > 0 then
   begin
    for i := 0 to count - 1 do
    begin
      Memo.lines.add('USB Device on system - no ' + inttostr(i + 1));
      extrainfo(arrdev[i],Memo);

     op := libusb_open(arrdev[i], @devhandle);
      if op <> 0 then
      begin
        Memo.lines.add('');
        Memo.lines.add('***Device is not Available to open***');
      end
      else
      begin
        Memo.lines.add('');
        Memo.lines.add('***Device ref ID ' + inttostr(i) +
          '  is Open and available to use***');
      end;
      Memo.lines.add('-----------------------------------------------------');
      end;

    end
    else
    begin
    memo.lines.Add('Failed to get device list');
    end;
  end;
  end;
     (*Cannot use the  function free_ device_list with an array of Plibusb_devices
     so have to de_ref each Plibdevice one by one from last to first *)
    // libusb_free_device_list(devs,1);
    for s  := high(arrdev) to low(arrdev) do
       libusb_unref_device(arrdev[s]);

      libusb_exit(context);
 end;

 procedure extrainfo(dev: plibusb_device; Memo: Tmemo);
var
 s, i, r: integer;
  desc: Libusb_device_descriptor;
  config: plibusb_config_descriptor;
  op:integer;
 begin
  r := libusb_get_device_descriptor(dev, @desc);

  if r <> 0 then
  begin
    Memo.lines.add('failed to get device descriptor');
    exit;
  end
  else
  begin
    // format
    Memo.lines.add('    VID : ' + inttostr(desc.idVendor) + '     PID : ' +
      inttostr(desc.idProduct) + '    Bus ' +
      inttostr(libusb_get_bus_number(dev)) + '    Device  ' +
      inttostr(libusb_get_device_address(dev)));
   end;
    end;
////////////////////////////////////////////////////////////////////////////
procedure endpoint_comp(ep_comp: plibusb_ss_endpoint_companion_descriptor;
  var Memo: Tmemo);
begin
  Memo.lines.add('   USB 3.0 Endpoint Companion');
  Memo.lines.add('---------------------------------------');
  Memo.lines.add('');
  Memo.lines.add('   bMaxBurst            : ' + inttostr(ep_comp.bMaxBurst));
  Memo.lines.add('   bmAttributes        : ' + inttostr(ep_comp.bmAttributes));
  Memo.lines.add('   wBytesPerInterval : ' + inttostr(ep_comp.wBytesPerInterval));
end;

procedure endpoint(endpoint: plibusb_endpoint_descriptor; var Memo: Tmemo);
var
  i, extra, ret: integer;
  ep_comp: plibusb_ss_endpoint_companion_descriptor;
  context: plibusb_context;
begin
  if endpoint <> nil then
     begin
     if endpoint.bEndpointAddress > 0 then
   begin

  Memo.lines.add('   Endpoint information');
  Memo.lines.add('---------------------------------------');
  Memo.lines.add('    bEndpointAddress:  ' + inttostr(endpoint.bEndpointAddress));
  Memo.lines.add('    bmAttributes:          ' + inttostr(endpoint.bmAttributes));
  Memo.lines.add('    wMaxPacketSize:     ' + inttostr(endpoint.wMaxPacketSize));
  Memo.lines.add('    bInterval:                 ' + inttostr(endpoint.bInterval));
  Memo.lines.add('    bRefresh:                 ' + inttostr(endpoint.bRefresh));
  Memo.lines.add('    bSynchAddress:       ' + inttostr(endpoint.bSynchAddress));
  Memo.lines.add('    bextra_length:         ' + endpoint.extra_length.ToString);
  Memo.lines.add('    extra:                       ' + inttostr(endpoint.extra));

   if endpoint.extra_length > 0 then
  begin
    for i := 0 to endpoint.extra_length - 1 do
    begin
      if LIBUSB_DT_SS_ENDPOINT_COMPANION = endpoint.extra then
      begin
        ret := libusb_get_ss_endpoint_companion_descriptor(context, endpoint,
          @ep_comp);
        if ret <> 0 then
        begin
          Memo.lines.add('-----------------------------');
          endpoint_comp(ep_comp, Memo);
          libusb_free_ss_endpoint_companion_descriptor(ep_comp);
        end;
      end
      else
      begin
        Memo.lines.add(' Not a USB 3.0 Endpoint Companion');
      end;
    end;
  end
  else
  begin
    Memo.lines.add('-----------------------------');
    Memo.lines.add('    Endpoint - ExtraPoint is not available');
    Memo.lines.add('-----------------------------');
    end
    end
    else
    Memo.lines.add(' No Endpoint Descriptions found for the Interface');
 end
 else
 begin
   Memo.lines.add(' No Endpoint found for the Interface');
 end;



end;

procedure altsetting(inter: plibusb_interface_descriptor; var Memo: Tmemo);
var
  i: integer;
begin
  if inter <> nil then
  begin
    Memo.lines.add('    Interface:');
    Memo.lines.add('    bInterfaceNumber:    ' + inttostr(inter.bInterfaceNumber));
    Memo.lines.add('    bAlternateSetting:     ' +
      inttostr(inter.bAlternateSetting));
    Memo.lines.add('    bNumEndpoints:       ' + inttostr(inter.bNumEndpoints));
    Memo.lines.add('    bInterfaceClass:         ' +
      inttostr(inter.bInterfaceClass));
    Memo.lines.add('    bInterfaceSubClass:   ' +
      inttostr(inter.bInterfaceSubClass));
    Memo.lines.add('    bInterfaceProtocol:    ' +
      inttostr(inter.bInterfaceProtocol));
    Memo.lines.add('    iInterface:                   ' +
      inttostr(inter.iInterface));
   memo.lines.add('');
    memo.lines.add('Interface.Bnumpoints : '+inttostr(inter.bNumEndpoints));

    if ((inter.bNumEndpoints > 0 ) and (inter.bNumEndpoints < 10)) then
    begin

      for i := 1 to inter.bNumEndpoints do
        endpoint(@inter.endpoint[i], Memo)

    end;
  end
  else
  begin
    Memo.lines.add('   No Endpoint Interface available');
  end;
end;

procedure usb2_0_ext_cap(usb_2_0_ext_cap: plibusb_usb_2_0_extension_descriptor;
  var Memo: Tmemo);
begin
  Memo.lines.add('    USB 2.0 Extension Capabilities:');
  Memo.lines.add('------------------------------------------------');
  Memo.lines.add('');
  Memo.lines.add('    bDevCapabilityType: ' +
    inttostr(usb_2_0_ext_cap.bDevCapabilityType));
  Memo.lines.add('    bmAttributes:       ' +
    inttostr(usb_2_0_ext_cap.bmAttributes));
end;

procedure ss_usb_cap(s_usb_cap: plibusb_ss_usb_device_capability_descriptor;
  var Memo: Tmemo);
begin
  Memo.lines.add('    USB 3.0 Capabilities:');
  Memo.lines.add('------------------------------------------------');
  Memo.lines.add('');
  Memo.lines.add('    bDevCapabilityType: ' +
    inttostr(s_usb_cap.bDevCapabilityType));
  Memo.lines.add('    bmAttributes:       ' +
    inttostr(s_usb_cap.bmAttributes));
  Memo.lines.add('    wSpeedSupported:    ' +
    inttostr(s_usb_cap.wSpeedSupported));
  Memo.lines.add('    bFunctionalitySupport: ' +
    inttostr(s_usb_cap.bFunctionalitySupport));
  Memo.lines.add('    bU1devExitLat:      ' +
    inttostr(s_usb_cap.bU1DevExitLat));
  Memo.lines.add('    bU2devExitLat:      ' +
    inttostr(s_usb_cap.bU2DevExitLat));
end;

procedure bos(handle: plibusb_device_handle; var Memo: Tmemo);
var
  ret, ret2: integer;
  fbos: plibusb_bos_descriptor;
  usb_2_0_extension: plibusb_usb_2_0_extension_descriptor;
  dev_cap: plibusb_ss_usb_device_capability_descriptor;
begin
  ret := libusb_get_bos_descriptor(handle, @fbos);

  if ret < 0 then
  begin
    exit;
  end
  else
  begin
    Memo.lines.add('    Binary Object Store (BOS):');
    Memo.lines.add('    wTotalLength:       ' + inttostr(fbos.wTotalLength));
    Memo.lines.add('    bNumDeviceCaps:     ' + inttostr(fbos.bNumDeviceCaps));
  end;

  if fbos.dev_capability[0].bDevCapabilityType = LIBUSB_BT_USB_2_0_EXTENSION
  then
  begin
    ret := libusb_get_usb_2_0_extension_descriptor(0, fbos.dev_capability[0],
      @usb_2_0_extension);
    if 0 > ret then
    begin
      exit;
    end
    else
    begin
      usb2_0_ext_cap(usb_2_0_extension, Memo);
      libusb_free_usb_2_0_extension_descriptor(usb_2_0_extension);
    end;
  end;

  if fbos.dev_capability[0].bDevCapabilityType = LIBUSB_BT_SS_USB_DEVICE_CAPABILITY
  then
  begin
    ret := libusb_get_ss_usb_device_capability_descriptor(0,
      fbos.dev_capability[0], @dev_cap);
    if 0 > ret then
    begin
      exit;
    end
    else
    begin
      ss_usb_cap(dev_cap, Memo);
      libusb_free_ss_usb_device_capability_descriptor(dev_cap);
    end;
  end;
  libusb_free_bos_descriptor(fbos);
end;

procedure interface_process(inter: plibusb_interface; var Memo: Tmemo);
var
  i: integer;
begin
  if inter.num_altsetting > -1 then
  begin
    Memo.lines.add('');
    if inter.num_altsetting < 50 then
      Memo.lines.add('    Alt Setting  number:  ' + inter.num_altsetting.ToString)
    else
      Memo.lines.add('    Alt Setting  number:  ' + inter.num_altsetting.ToString +
        ' is out of bounds and not a valid to process');
    Memo.lines.add('-----------------------------');

    if inter.num_altsetting < 20 then
    // if the item is an abnormal large number ??
    begin
      for i := 0 to inter.num_altsetting - 1 do
      begin
        Memo.lines.add('    Interface Alt Setting no : ' + i.ToString);
        Memo.lines.add('-------------------------------');
        altsetting(@inter.altsetting[i], Memo);
        Memo.lines.add('--------------------------------');
      end;
    end;
  end
  else
  begin
    Memo.lines.add('    No alternate interface found');
    Memo.lines.add('--------------------------------');
  end;
end;

procedure configuration(config: plibusb_config_descriptor; var Memo: Tmemo);
var
  i: integer;
  inter: plibusb_interface;
begin
  Memo.lines.add('   Configuration ');
  Memo.lines.add('------------------------------------------------');
  Memo.lines.add('   wTotalLength:               ' +
    inttostr(config.wTotalLength));
  Memo.lines.add('   bNumInterfaces:            ' +
    inttostr(config.bNumInterfaces));
  Memo.lines.add('   bConfigurationValue:     ' +
    inttostr(config.bConfigurationValue));
  Memo.lines.add('   iConfiguration:               ' +
    inttostr(config.iConfiguration));
  Memo.lines.add('   bmAttributes:                 ' +
    inttostr(config.bmAttributes));
  Memo.lines.add('   MaxPower:                     ' +
    inttostr(config.MaxPower));

  if config.bNumInterfaces > 0 then
  begin
    for i := 0 to config.bNumInterfaces - 1 do
    begin
      interface_process(@config.&interface[i], Memo);
    end;
  end
  else
  begin
    Memo.lines.add('    No Alternate Settings Found');
  end;
end;

procedure Descripinfo(dev: plibusb_device; Memo: Tmemo);
var
  r: integer;
  desc: Libusb_device_descriptor;
begin
  r := libusb_get_device_descriptor(dev, @desc);

  if r < 0 then
  begin
    Memo.lines.add('   failed to get device descriptor');
    exit;
  end
  else
  begin
    Memo.lines.add('    device descriptor connected');
  end;
end;

function device(deviceno: integer; var Memo: Tmemo): integer;
var
 s, i, r,rs, op, ret, ret1, ret2: integer;
  devs: pplibusb_device;
  dev:plibusb_device;
  desc: Libusb_device_descriptor;
  config: plibusb_config_descriptor;
  devhandle: plibusb_device_handle;
  arrdev1: array of plibusb_device;
  description: array [0 .. 254] of byte;
  str: array [0 .. 254] of byte;
  count: ssize_t;
  context: plibusb_context;
  extract:string;
begin
  // List devices
  Memo.lines.clear;
  Memo.lines.add(textload);
  Memo.lines.add('---------------------------------------------------------------------------------------------------------------');
  context := nil; // declare the pointer to null

  r := libusb_init(context);
  if r <> 0 then
  begin
    Memo.lines.add('Cannot initialize the DLL Device Value ' + r.ToString +
      'is less than 0');
    exit;
  end
  else
  begin
    Memo.lines.add('DLL Initialized  - Device connected');
  end;
  count := libusb_get_device_list(context, @devs);

  // uses the referenced pointer
  setlength(arrdev1, count);
  libusb_free_device_list(devs, 1); // we now know how many devices there are

  if count < 1 then
  begin
   Memo.lines.add('No devices found ');
   exit;
  end
  else
  begin
  libusb_get_device_list(context, @arrdev1); // set new devicelist with dev

  rs := libusb_get_device_descriptor(arrdev1[deviceno], @desc);

  op := -1;
  if rs = 0 then
  begin
    op := libusb_open(arrdev1[deviceno], @devhandle);
    if op <> 0 then
    begin
      Memo.lines.add('');
      Memo.lines.add('***Device is not Available to open***');
    end
    else
    begin
      Memo.lines.add('***Device ref ID ' + inttostr(deviceno) +
        '  is Open and available to use***');
      Memo.lines.add('------------------------------------------------------');
      Memo.lines.add('');

      if op = 0 then
      begin
        if desc.iManufacturer > 0 then
        begin
          ret := libusb_get_string_descriptor_ascii(devhandle, desc.iManufacturer,
            @str, sizeof(str));
          if ret > 0 then
        Memo.lines.add('    Description  ->  ' + TEncoding.ANSI.GetString(str))
          else
            Memo.lines.add('    Description  ->  Max Bytes[' + sizeof(description)
              .ToString + ']+  ' + inttostr(desc.idVendor) +
              '    No Descriptive info');

          Memo.lines.add('    Id Vendor  ->  Max Bytes[' + sizeof(description)
            .ToString + ']  ID: ' + inttostr(desc.idVendor));
          Memo.lines.add('    Id PID        ->  Max Bytes[' + sizeof(description)
            .ToString + ']  ID: ' + inttostr(desc.idProduct));
        end;

        if desc.iProduct > 0 then
        begin
          ret := libusb_get_string_descriptor_ascii(devhandle, desc.iProduct, @str,
            sizeof(str));
          if ret > 0 then
            Memo.lines.add('    Description  ->  Max Bytes[' + sizeof(description)
              .ToString + ']+  ' + TEncoding.ANSI.GetString(str))
          else
            Memo.lines.add('    Description        ->  Max Bytes[' +
              sizeof(description).ToString + ']  ID: ' +
              inttostr(desc.idProduct) + ' No Descriptive info');
        end;

        Memo.lines.add('    Bus No     ->  ' +
          inttostr(libusb_get_bus_number(arrdev1[deviceno])));
        Memo.lines.add('    Device      ->  ' +
          inttostr(libusb_get_device_address(arrdev1[deviceno])));
        if ((devhandle <> nil) and (verbose = 0)) then
        begin
          if desc.iSerialNumber = 0 then
          begin
            ret1 := libusb_get_string_descriptor_ascii(devhandle,
              desc.iSerialNumber, @str, sizeof(str));
            if (ret1 <> 0) then
              Memo.lines.add('    iSerialnumber  level * 2 :' +
                inttostr(desc.iSerialNumber) + '     ' +
                TEncoding.ANSI.GetString(str));
          end;
        end;
        if verbose = 0 then
        begin
         memo.lines.add('    Desc.BnumConfigurations    -> '+  inttostr(desc.bNumConfigurations));
          for i := 0 to desc.bNumConfigurations - 1 do
            begin
            ret2 := libusb_get_config_descriptor(arrdev1[deviceno], i, @config);
            if ret2 <> 0 then
            begin
              Memo.lines.add('   Could not retrieve descriptors');
            end
            else
            begin
              Memo.lines.add('');
             configuration(config, Memo);
              libusb_free_config_descriptor(config);
            end;

            // gives details on the usb 3.0 device
            if ((devhandle <> nil) and (desc.bcdUSB >= 513)) then
            begin
              Memo.lines.add('-------------------------------------');
              bos(devhandle, Memo);
            end
            else
            begin
              Memo.lines.add('-------------------------------------');
              Memo.lines.add
                ('    The Binary Device Object Store (BOS) descriptor information of the USB 2.0  or USB 3.0 not available for this device');
              Memo.lines.add('-------------------------------------');
            end;
          end;
        end;
      end;
    end;
  end;
  (*Cannot use the  function free_ device_list with an array of Plibusb_devices
     so have to de_ref each Plibdevice one by one from last to first *)
    for s  := high(arrdev1) to low(arrdev1) do
       libusb_unref_device(arrdev1[i]);

      libusb_exit(context);
  end;
 end;

 function textload:string;
begin
result:=
('The device must show open and available to use before trying to ' +
    'enter the device id number else the device' + #13#10 +
    ' will fail to open. ' +
    'Just because you have a reference to a device does not mean it is ' +
    'necessarily usable.' + #13#10 +
    ' The device may have been unplugged,you may not have ' +
    'permission to operate such device,or another' + #13#10 +
    ' program or driver may be ' + 'using the device. ' +
    'When you have found a device that you would like to operate,' + #13#10 +
    ' you must ask ' +
    'libusb to open the device using the libusb_open() function. Assuming ' +
    'success,libusb then ' + #13#10 + 'returns you a device handle ' +
    '(a \ref libusb_device_handle pointer). All "real" I/O operations then ' +
    'operate' + #13#10 +
    ' on the handle rather than the original device pointer.)' + #13#10 + '');
 end;


 end.
