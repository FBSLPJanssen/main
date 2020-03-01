unit AddStockPoint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    edtName: TEdit;
    Label2: TLabel;
    edtED: TEdit;
    Label3: TLabel;
    edtSD: TEdit;
    Label4: TLabel;
    edtLeadtime: TEdit;
    Label5: TLabel;
    edtStocknorm: TEdit;
    procedure edtEDKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtSDKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtLeadtimeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtStocknormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    Name : String;
    ED : Double;
    SD : double;
    Leadtime : integer;
    Stocknorm : integer;
    EndProduct : integer;
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

procedure TForm3.edtEDKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_RETURN then
  begin
    ED:=StrToFloat(edtED.Text);
  end;
end;

procedure TForm3.edtSDKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RETURN then
  begin
    SD:=StrToFloat(edtSD.Text);
  end;
end;

procedure TForm3.edtLeadtimeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RETURN then
  begin
    Leadtime:=StrToInt(edtLeadtime.Text);
  end;
end;

procedure TForm3.edtStocknormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then
  begin
    StockNorm:=StrToInt(edtStockNorm.Text);
  end;
end;

procedure TForm3.edtNameChange(Sender: TObject);
begin
  Name:=edtName.Text;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  edtName.Text:='Stockpoint 1';
  edtED.Text:='0';
  edtSD.Text:='0';
  edtLeadtime.Text:='1';
  edtStocknorm.text:='1';
  endProduct:=1;
  ED:=0;
  SD:=0;
  Leadtime:=1;
  StockNorm:=1;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StockNorm:=StrToInt(edtStockNorm.Text);
  Leadtime:=StrToInt(edtLeadtime.Text);
  ED:=StrToFloat(edtED.Text);
  SD:=StrToFloat(edtSD.Text);
end;

end.
