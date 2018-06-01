unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,libusb1,libusb1helper,
  FMX.Edit, FMX.TabControl;

 type
  dataArr = array of byte;

type
  Tfmmain = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Edit1: TEdit;
    Label10: TLabel;
    Edit2: TEdit;
    Label12: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    btnWrite: TButton;
    Label2: TLabel;
    Edit5: TEdit;
    btnRead: TButton;
    Memo1: TMemo;
    procedure btnWriteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnReadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmmain: Tfmmain;

implementation

{$R *.fmx}


procedure Tfmmain.btnReadClick(Sender: TObject);
var
r,rc,i,num,fsize,flength:integer;
newcontext: plibusb_context;
devh: plibusb_device_handle;
vendor_id,product_id,ep_in_Addr:uint16_t;
actual_length:pinteger;

OutputData:DataArr ;
begin
memo1.Lines.Clear;

 if (edit1.text = '' ) or (edit2.text = '') then
begin
memo1.Lines.Add('Insufficient data to process - re-enter');
edit1.Text:= '';
edit2.Text:= '';
exit;
end
else
  begin
  vendor_id := strtoint(edit1.Text);
  product_id:= strtoint(edit2.Text);
  num:= strtoint(edit3.Text);
  setlength(Outputdata,4);
  fsize := 512; //max 512 bytes
  flength:=sizeof(outputdata);
  actual_length:=@flength; //set the length of the byte array to a pointer

 // need endpoint addresses which are hard coded in the device

   ep_in_addr := strtoint(edit5.Text);// change this endpoint information as required

   newcontext:= nil;   //declare the pointer to null
   devh:= nil; //create a NULL device handle

   r:= libusb_init(newcontext); //initialize Libusb
   libusb_set_debug(newcontext,3); // add the debugger on max

   if r <> 0  then
   begin
    memo1.Lines.add('Cannot initialize the DLL Device Value '+ inttostr(r)+ 'is less than 0');
     exit;
     end
     else
     begin
     memo1.Lines.add('DLL Initialized and new context Registered ' );
     memo1.Lines.Add('');
     memo1.Lines.add('Opened Device Handle with Vid  '+edit1.text+' /  Pid '+edit2.text );
    //open the device with the vid pid
    devh:= libusb_open_device_with_vid_pid(newcontext,vendor_id,product_id);
    if not (devh = nil)  then
      begin
    memo1.Lines.add('Device Handle created ');
    memo1.Lines.Add('---------------------------------------------------------------------');
      end
      else
      begin
      memo1.Lines.Add('Nil Device Handle found');
      exit;
      end;
     end;

        //need to detach the drivers from all the USB interfaces.
    for i := 0 to 1 do
     begin
       if libusb_kernel_driver_active(devh,i) = 0 then
         begin
           libusb_detach_kernel_driver(devh,i);
        end;
       rc := libusb_claim_interface(devh,i);
        if rc < 0 then
         begin
        memo1.lines.add('Error claiming interface');
        end;
    end;

     { To receive bytes from the device initiate a bulk_transfer to the
     * Endpoint with address ep_in_addr. }
 rc:= libusb_bulk_transfer(devh, ep_in_addr, @outputdata, fsize, @actual_length,1000);

  if outputdata <> nil then
   memo1.Lines.Add('Data read : '+ strpas(pchar(@outputdata)))
  else
   memo1.Lines.Add('No data read !');

    if rc = 7 then //LIBUSB_ERROR_TIMEOUT
    begin
      Memo1.lines.add('Libusb timeout error');
      exit;
    end
 else
 if (rc <> 0)then
  begin
       memo1.lines.add('Error while waiting for data - error_value = '+rc.tostring);
       exit;
    end;
   exit;

   libusb_release_interface(devh, 0);
   libusb_close(devh);
   libusb_exit(newcontext);
   Exit;
  end;
  end;

procedure Tfmmain.btnWriteClick(Sender: TObject);
var
//sendbytes:pbyte;
flength,fsize,r,rc,rd,i,q,num:integer;
newcontext: plibusb_context;
devh: plibusb_device_handle;
vendor_id,product_id,ep_out_Addr:uint16_t;
Newdata:dataArr;
actual_length:pinteger;
begin
memo1.Lines.Clear;
 if (edit1.text = '' ) or (edit2.text = '') then
begin
memo1.Lines.Add('Insufficient data to process - re-enter');
edit1.Text:= '';
edit2.Text:= '';
exit;
end
else
  begin
  setlength(NewData,4);
  NewData[0] := strtoint(edit9.Text);
  NewData[1] := strtoint(edit10.Text);
  NewData[2] := strtoint(edit11.Text);
  NewData[3] := strtoint(edit12.Text);
  fsize:= 512; //max bytes
 // sendbytes:=@NewData;
  vendor_id := strtoint(edit1.Text);
  product_id:= strtoint(edit2.Text);
  num:= strtoint(edit3.Text);
  flength:=sizeof(NewData);
  actual_length:=@flength; //set the length of the byte array to a pointer

 // need endpoint addresses which are hard coded in the device
   ep_out_Addr := 0;// endpoint

   newcontext:= nil;   //declare the pointer to null
   devh:= nil; //create a NULL device handle

   r:= libusb_init(newcontext); //initialize Libusb
   libusb_set_debug(newcontext,3); // add the debugger on

   if r < 0  then
   begin
    memo1.Lines.add('Cannot initialize the DLL Device Value '+ r.ToString+ 'is less than 0');
     exit;
     end
     else
     begin
     memo1.Lines.add('DLL Initialized and new context Registered ' );
     memo1.Lines.Add('');
     memo1.Lines.add('Opened Device Handle with Vid  '+edit1.text+' /  Pid '+edit2.text );
    //open the device with the vid pid
    devh:= libusb_open_device_with_vid_pid(newcontext,vendor_id,product_id);
    if not (devh = nil)  then
      begin
    memo1.Lines.add('Device Handle created ');
    memo1.Lines.Add('---------------------------------------------------------------------');
      end
      else
      begin
      memo1.Lines.Add('Nil Device Handle found');
      exit;
      end;
     end;

    for i:= 0 to num do
      begin
      if libusb_kernel_driver_active(devh,num) = 0 then
      begin
        libusb_detach_kernel_driver(devh,num);
        rc:= libusb_claim_interface(devh,num);
          if rc <> 0 then
       begin
       memo1.Lines.add('Cannot Claim an Interface ');
       libusb_error_name(rc);
       end;
      end;

      (*Optional change to: var  NewData [0..255] array of byte  - could be 512 depending on
     the usb device then use the Tencoding -> Tencoding.ansi.getstring();  *)
          rc:= libusb_bulk_transfer(devh,ep_out_addr,@NewData,fsize,actual_length,1000);

    if rc <> 0 then
     begin
      memo1.lines.add('Error during control transfer');
    end;

    end;
    { We can now start sending or receiving data to the device}
     if (libusb_bulk_transfer(devh,ep_out_addr,@NewData,fsize,actual_length,1000) < 0) then
      memo1.lines.add( 'Error while sending data ')
     else
     (*Optional change to: var  NewData [0..255] array of byte  - could be 512 depending on
     the usb device then use the Tencoding -> Tencoding.ansi.getstring();  *)
      memo1.lines.add( 'Data sent : '+ strpas(pchar(@NewData)));

  end;
   libusb_release_interface(devh, 0);
   libusb_close(devh);
   libusb_exit(newcontext);
   Exit;
  end;

procedure Tfmmain.FormCreate(Sender: TObject);
begin
  memo1.Lines.Clear;
  //Please use own addreses and values
  memo1.lines.add('This presents an example using an array of bytes to send and receive.'+#13#10+' This can be adapted to match the USB device input and output methods.' );

  edit1.Text:= '3468';  // enter id vid
  edit2.Text:= '261';   // enter id pid
  edit3.text:= '0';    // enter ep out
  edit5.Text:= '139';  // enter ep in

  edit9.Text:= '30';
  edit10.Text:= '15';
  edit11.Text:= '10';
  edit12.Text:= '5';
end;



end.
