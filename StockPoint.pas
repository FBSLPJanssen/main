unit StockPoint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,stdctrls;

type
  PStockPoint = ^TStockPoint;

  TStockPoint = class(TImage)

  private
    { Private declarations }
    FName      : String;
    FLabel     : TLabel;
    FLeadtime  : integer;
    FStockNorm : integer;
    FED        : double;
    FSD        : double;
    FEndproduct: integer;
    FService   : double;
    Fprice     : double;
    FSelected  : integer; // 0 not selected
                          // 1 end point
                          // 2 starting point

    procedure SetName(Value : string);
    procedure SetEndproduct(Value : integer);
    procedure EndDrop(Sender, Source : TObject; X,Y:integer);
    procedure DragDrop(Sender, Source : TObject; X,Y:integer);
    procedure MouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X,Y : Integer);
    procedure Paint;

  protected
    { Protected declarations }
  public
    { Public declarations }
     procedure Edit;
    constructor Create(AOwner:TComponent); override;

  published
    { Published declarations }
    property Name : String read Fname write SetName;
    property ED  : double read FED write FED;
    property SD  : double read FSD write FSD;
    property Leadtime  : integer read FLeadtime write FLeadtime;
    property StockNorm : integer read FStockNorm write FStockNorm;
    property Service  : double read FService write FService;
    property Price  : double read FPrice write FPrice;
    property Endproduct  : integer read FEndProduct write SetEndproduct;
    property Selected : Integer read FSelected write FSelected;
  end;

procedure Register;

implementation

uses AddStockPoint;

procedure TStockpoint.SetEndProduct(value : integer);
begin
  FEndproduct:=Value;
  Paint;
end;

procedure TStockpoint.SetName(Value : String);
begin
 Flabel.Caption:=Value;
 Flabel.Top:=Top-14;
 Flabel.left:=left;
 Fname:=Value;

end;

constructor TStockPoint.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Height:=20;
  Width:=20;

  Hint:='SHOW=mbRight   MOVE=mbLeft';
  Showhint:=True;
  // init values
  FName:='';
  FService:=0.95;
  FPrice:=10;
  FLeadtime:=0;
  FStockNorm:=0;
  FED:=0.0;
  FSD:=0.0;
  FEndproduct:=0;
  FSelected:=0;
  // specificeren van events
  OnMouseDown :=MouseDown;
  OnEndDrag :=EndDrop;
  OnDragDrop :=DragDrop;
  DragMode :=dmManual;
  //OnDragOver :=Dragover;
   Paint;
   FLabel := TLabel.Create(Self);
   FLabel.Width       := 50;
   FLabel.Height      := 14;
   FLabel.Font.Name   := 'New Times Roman';
   FLabel.Font.Height := 10;
   FLabel.Caption     := FName;
   FLabel.Parent:=AOwner as TWinControl ;


end;

procedure TStockPoint.Paint;
begin
 with Canvas do
  begin
    Case  FSelected of
      1 : Brush.Color := clYellow;
      2 : Brush.Color := clRed;
    else
      Brush.Color := clSilver;
    end;
    FillRect(Rect(0,0,20,20));

    Pen.Color:=clBlack;
    Pen.Width:=1;
    Case FEndproduct of
      1: Brush.Color := clLime;
      2: Brush.Color := clBlue;
    else
      Brush.Color := clRed;
    end;
    Polygon([Point(0, 0), Point(20, 0),
    Point(10, 20)]);

  end;
end;



procedure TStockPoint.Edit;
begin
  Application.CreateForm(TForm3, Form3);
  Form3.Caption:='Edit component';
  Form3.edtName.Text:=FName;
  Form3.edtED.Text:=FloatToStrF(FED,ffFixed,8,1);
  Form3.edtSD.Text:=FloatToStrF(FSD,ffFixed,8,1);;
  Form3.edtLeadtime.Text:=FloatToStrF(FLeadtime,ffFixed,8,0);;
  Form3.edtStockNorm.Text:=FloatToStrF(FStockNorm,ffFixed,8,0);
  try
    if Form3.ShowModal()=mrOK then
    begin
      FName:=Form3.Name;
      Flabel.Caption:=FName;
      FED:=Form3.ED;
      FSD:=Form3.SD;
      FLeadtime:=Form3.Leadtime;
      FStockNorm:=Form3.StockNorm;
    end;
  finally
    Form3.free;
    Form3:=nil;
  end;

end;

procedure TStockPoint.MouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X,Y : Integer);
begin
 if (Button=mbLeft) then
 begin
   BeginDrag(False);
 end else if (Button=mbRight) then
 begin
   Edit;
 end;
 if ((ssCtrl in Shift) and (Button = mbLeft)) then
 begin
   FSelected:=(FSelected+1) mod 3;
   Paint;
 end;
end;

procedure TStockPoint.EndDrop(Sender, Source : TObject; X,Y:integer);
begin
 Flabel.Top:=Top-14;
   Flabel.left:=left;
end;

procedure TStockPoint.DragDrop(Sender, Source : TObject; X,Y:integer);
begin

end;

procedure Register;
begin
  RegisterComponents('Samples', [TStockPoint]);
end;

end.
