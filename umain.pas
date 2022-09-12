unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, fphttpclient, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls, Types;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnSend1: TButton;
    btnSend2: TButton;
    btnSend3: TButton;
    eGroupName1: TEdit;
    ePhone2: TEdit;
    eURL1: TEdit;
    ePhone1: TEdit;
    eGroupID1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    mLog: TMemo;
    mMsg1: TMemo;
    mMsg2: TMemo;
    mMsg3: TMemo;
    PageControl1: TPageControl;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure btnSend1Click(Sender: TObject);
    procedure btnSend2Click(Sender: TObject);
    procedure btnSend3Click(Sender: TObject);
  private
  public

  end;

var
  frmMain: TfrmMain;

const
  API_URL= 'http://localhost:7456';
  API_KEY= '123456789';

implementation

{$R *.lfm}

{ TfrmMain }

function requestdata(Url: string; Params: string): string;
var
  Client: TFPHttpClient;
  Response: TStringStream;
begin
   Client := TFPHttpClient.Create(nil);
   Client.AddHeader('Content-Type', 'application/x-www-form-urlencoded');
   Client.AddHeader('API-KEY', API_KEY);
   Client.AddHeader('Accept', 'application/json');
   Client.RequestBody := TRawByteStringStream.Create(Params);
   Response := TStringStream.Create('');
   try
     try
       Client.Post(Url, Response);
       Result := Response.DataString;
       //Writeln('Response Code: ' + IntToStr(Client.ResponseStatusCode)); // better be 200
     except on E: Exception do
       Result := E.Message;
       //Writeln('Something bad happened: ' + E.Message);
     end;
   finally
     Client.RequestBody.Free;
     Client.Free;
     Response.Free;
   end;
end;

procedure TfrmMain.btnSend1Click(Sender: TObject);
var
  Data: string;
  Params: string;
begin
   Params := 'number=' + EncodeURLElement(ePhone1.Text) + '&' +
              'message=' + EncodeURLElement(mMsg1.Text);
   Data := requestdata(API_URL + '/send-message', Params);
   mLog.Lines.Add('log send message: ' + Data);
end;

procedure TfrmMain.btnSend2Click(Sender: TObject);
var
  Data: string;
  Params: string;
begin
   Params := 'id=' + EncodeURLElement(eGroupID1.Text) + '&' +
              'name=' + EncodeURLElement(eGroupName1.Text) + '&' +
              'message=' + EncodeURLElement(mMsg2.Text);
   Data := requestdata(API_URL + '/send-group-message', Params);
   mLog.Lines.Add('log send group message: ' + Data);
end;

procedure TfrmMain.btnSend3Click(Sender: TObject);
var
  Data: string;
  Params: string;
begin
   Params := 'number=' + EncodeURLElement(ePhone2.Text) + '&' +
              'file=' + EncodeURLElement(eURL1.Text)  + '&' +
              'caption=' + EncodeURLElement(mMsg3.Text);
   Data := requestdata(API_URL + '/send-image', Params);
   mLog.Lines.Add('log send image: ' + Data);
end;

end.

