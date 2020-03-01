unit MAP_GraphicalComponents;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,stdctrls, Math;

type
  TGraphicalStockPoint = class(TImage)

  private
    { Private declarations }
    FName       : String;
    FLabel      : TLabel;
    FProductType: integer;
    FSelected   : integer; // 0 not selected
                           // 1 end point
                           // 2 starting point

    procedure SetProductType(Value : integer);
    procedure SetName(Value : string);
    procedure EndDrop(Sender, Source : TObject; X,Y:integer);
    procedure MouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X,Y : Integer);

    procedure Paint;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;

  published
    { Published declarations }
    property Name : String read Fname write SetName;
    property ProductType  : integer read FProductType write SetProductType;
    property Selected : Integer read FSelected write FSelected;
  end;


TArrowQuadrant = (aqFirst,aqSecond,aqThird,aqFourth);
  TArrow = class(TGraphicControl)
  private
    { Private declarations }
    FPen             : TPen;
    FBrush           : TBrush;
    FQuadrant        : TArrowQuadrant;
    FPointAngle      : double; // in Radians
    FPointLength     : integer;
    FAngle           : double;
    function ArrowQuadrant(Bx,By,Ex,Ey:integer):TArrowQuadrant;
   protected
    { Protected declarations }
      procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent;Bx,By,Ex,Ey:integer);
    destructor Destroy;

  published
    { Published declarations }
  end;



procedure Register;

implementation


procedure TGraphicalStockPoint.SetProductType(value : integer);
begin
  FProductType:=Value;
  Paint;
end;

procedure TGraphicalStockPoint.SetName(Value : String);
begin
 Flabel.Caption:=Value;
 Flabel.Top:=Top-14;
 Flabel.left:=left;
 Fname:=Value;

end;

constructor TGraphicalStockPoint.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Height:=20;
  Width:=20;

  Hint:='SHOW=mbRight   MOVE=mbLeft';
  Showhint:=True;
  // init values
  FName:='';
  FProductType:=0;
  FSelected:=0;
  // specificify events
  OnMouseDown :=MouseDown;
  OnEndDrag :=EndDrop;
  DragMode :=dmManual;

   Paint;
   FLabel := TLabel.Create(Self);
   FLabel.Width       := 50;
   FLabel.Height      := 14;
   FLabel.Font.Name   := 'New Times Roman';
   FLabel.Font.Height := 10;
   FLabel.Caption     := FName;
   FLabel.Parent:=AOwner as TWinControl ;


end;

procedure TGraphicalStockPoint.Paint;
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
    Case FProductType of
      1: Brush.Color := clLime;
      2: Brush.Color := clBlue;
    else
      Brush.Color := clRed;
    end;
    Polygon([Point(0, 0), Point(20, 0),
    Point(10, 20)]);

  end;
end;



procedure TGraphicalStockPoint.MouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X,Y : Integer);
begin
 if (Button=mbLeft) then
 begin
   BeginDrag(False);
 end;

 if ((ssCtrl in Shift) and (Button = mbLeft)) then
 begin
   FSelected:=(FSelected+1) mod 3;
   Paint;
 end;
end;

procedure TGraphicalStockPoint.EndDrop(Sender, Source : TObject; X,Y:integer);
begin
   Flabel.Top:=Top-14;
   Flabel.left:=left;
end;



///
///  Implementation of Arrow
///

function TArrow.ArrowQuadrant(Bx,By,Ex,Ey:integer):TArrowQuadrant;
begin
 if ((Bx<=Ex) and (By<=Ey)) then
    ArrowQuadrant:=aqFirst
 else if ((Bx>Ex) and (By<=Ey)) then
    ArrowQuadrant:=aqSecond
 else if ((Bx>Ex) and (By>Ey)) then
    ArrowQuadrant:=aqThird
 else
    ArrowQuadrant:=aqFourth;
end;

destructor TArrow.Destroy;
begin
 FPen.Free;
 FBrush.Free;
 inherited Destroy;
end;



constructor TArrow.Create(AOwner:TComponent;Bx,By,Ex,Ey:integer);
begin
  inherited Create(AOwner);
  Height:=abs(By-Ey);
  Width:=abs(Bx-Ex);
  FQuadrant:=ArrowQuadrant(Bx,By,Ex,Ey);
  case FQuadrant of
   aqFirst:
      begin
        Left:=Bx;
        Top:=By;
      end;
   aqSecond:
      begin
        Left:=Ex;
        Top:=By;
      end;
   aqThird:
      begin
        Left:=Ex;
        Top:=Ey;
      end;
   aqFourth:
      begin
        Left:=Bx;
        Top:=Ey;
      end;
   end;//case
  FAngle:=arctan((Height-1)/(Width-1));
  // init values

  FPointAngle:=Pi/4;
  // Point angle must not go out of the canvas
  if (FAngle>Pi/4) then
   FPointAngle:=min(Pi/2-FAngle,FPointAngle)
  else
   FPointAngle:=min(FAngle,FPointAngle);

  FPointLength:=10;
  FPen:=TPen.Create;
  FBrush:=TBrush.Create;
  // specificeren van events
end;


procedure TArrow.Paint;
var
 x,y,x1,x2,y1,y2 : integer;
 l : double;
begin

 l:=FPointLength*tan(FPointAngle);
 y:=(Height-1);
 x:=(Width-1);


 begin
   with Canvas do
   begin
     pen:=Fpen;
     brush:=FBrush;
     case FQuadrant of
      aqFirst:
       begin
        x1:=round(x-l*cos(FAngle+FPointAngle));
        y1:=round(y-l*sin(FAngle+FPointAngle));
        x2:=round(x-l*cos(FAngle-FPointAngle));
        y2:=round(y-l*sin(FAngle-FPointAngle));
        MoveTo(0,0);
        LineTo(x,y);
        Polygon([Point(x,y),Point(x1,y1),Point(x2,y2)]);
       end;
      aqSecond:
       begin
        x1:=round(l*cos(FAngle+FPointAngle));
        y1:=round(y-l*sin(FAngle+FPointAngle));
        x2:=round(l*cos(FAngle-FPointAngle));
        y2:=round(y-l*sin(FAngle-FPointAngle));
        MoveTo(x,0);
        LineTo(0,y);
        Polygon([Point(0,y),Point(x1,y1),Point(x2,y2)]);
    end;
   aqThird:
    begin
        x1:=round(l*cos(FAngle+FPointAngle));
        y1:=round(l*sin(FAngle+FPointAngle));
        x2:=round(l*cos(FAngle-FPointAngle));
        y2:=round(l*sin(FAngle-FPointAngle));
        MoveTo(0,0);
        LineTo(x,y);
        Polygon([Point(0,0),Point(x1,y1),Point(x2,y2)]);
    end;
   aqFourth:
    begin
        x1:=round(x-l*cos(FAngle+FPointAngle));
        y1:=round(l*sin(FAngle+FPointAngle));
        x2:=round(x-l*cos(FAngle-FPointAngle));
        y2:=round(l*sin(FAngle-FPointAngle));
        MoveTo(0,y);
        LineTo(x,0);
        Polygon([Point(x,0),Point(x1,y1),Point(x2,y2)]);

    end;
 end;//case
   end;
 end;
end;



procedure Register;
begin
  RegisterComponents('Samples', [TGraphicalStockPoint]);
  RegisterComponents('Samples', [TArrow]);
end;



end.
