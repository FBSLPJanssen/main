unit MAP_UserInterfaceItems;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ComCtrls, ExtCtrls,
  MAP_Types, Grids, TeEngine, Series, TeeProcs, Chart;

type
  TPagesDlg = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    sgSalesData: TStringGrid;
    rbWeeklyDemand: TRadioButton;
    rbMonthlyDemand: TRadioButton;
    rbQuarterlyDemand: TRadioButton;
    Bevel2: TBevel;
    Chart1: TChart;
    Series2: TBarSeries;
    Series1: TBarSeries;
    procedure sgSalesDataDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet1Refresh;
    procedure FormCreate(Sender: TObject);
    procedure rbWeeklyDemandClick(Sender: TObject);
    procedure rbMonthlyDemandClick(Sender: TObject);
    procedure rbQuarterlyDemandClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     CurrentComponent     : TUserProduct;
     AbsoluteBounds       : Boolean;
     LowerBound,UpperBound: extended;

     CurrentPeriod,
     CurrentWeek,
     CurrentYear,
     CurrentQuarter,
     CurrentMonth          : Integer;

     Horizon               : Integer;
     Month                 : Array[1..12] of string;
     WeekToMonth           : Array[1..52] of integer;
  end;

var
  PagesDlg: TPagesDlg;

implementation

{$R *.DFM}




// sheet1

procedure TPagesDlg.sgSalesDataDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
        x,y : extended;
 GiveSignal : integer;
begin
  if (ACol>0) and (ARow = 4) then
  begin
    x:=0;
    y:=0;
    GiveSignal:=0;
    // avoid reading errors
    if (sgSalesData.Cells[ACol,ARow]<>'') then
      x:=StrToFloat(sgSalesData.Cells[ACol,ARow]);
    if (sgSalesData.Cells[ACol,ARow-1]<>'') then
      y:=StrToFloat(sgSalesData.Cells[ACol,ARow-1]);
    if (AbsoluteBounds) then
    begin
      if (x<-LowerBound) then
        GiveSignal:=-1
      else if (x>UpperBound) then
        GiveSignal:=1;
    end else
    begin
      if (x*100<-LowerBound*y) then
        GiveSignal:=-1
      else if (x*100>UpperBound*y) then
        GiveSignal:=1;
    end;

    if (GiveSignal<>0) then
    begin
      with sgSalesData.Canvas do
      begin
        Pen.Color:=clBlack;
        Pen.Width:=2;
        Brush.Style:=bsSolid;
        if GiveSignal<0 then
           Brush.Color:=clRed
        else
           Brush.Color:=clBlue;
        Font.Color:=clWhite;
        TextRect(Rect,Rect.left,Rect.Top,sgSalesData.Cells[acol,arow]);
      end;
    end;
  end;
end;

procedure TPagesDlg.TabSheet1Show(Sender: TObject);
begin
  TabSheet1Refresh
end;



procedure TPagesDlg.TabSheet1Refresh;
Const
  MaxMonthsShown = 20;
  MaxQuartersShown = 10;
var
i,j,k,l : integer;
TWMonthDemand,
LWMonthDemand,
TWQuartDemand,
LWQuartDemand  : TExtendedHorizonArray;
begin
   //
   //  Weekly information is shown
   //
  if rbWeeklyDemand.Checked then
   with sgSalesData do
    begin
      ColCount:=Horizon+1;
      RowCount:=5;
      fixedCols:=1;
      fixedRows:=2;
      Height:=RowCount*24+30;
      for j:=2 to Horizon+1 do begin
          Cells[j-1,0]:=IntToStr((CurrentPeriod div 100) + ((CurrentPeriod mod 100+j-3) div 52));
          Cells[j-1,1]:='wk ' + IntToStr(1+(CurrentPeriod mod 100 + j-3) mod 52) ;
      end;
      Cells[0,2]:='Current';
      Cells[0,3]:='Last week';
      Cells[0,4]:='Difference';
      for k:=2 to Horizon do
      begin
        Cells[k-1,2]:=FloatToStrF(CurrentComponent.Demand[k-1],ffFixed,8,0);
        Cells[k-1,3]:=FloatToStrF(CurrentComponent.Demand_last_week[k],ffFixed,8,0);
        Cells[k-1,4]:=FloatToStrF(CurrentComponent.Demand[k-1]-CurrentComponent.Demand_last_week[k],ffFixed,8,0);
      end;
      Cells[Horizon,2]:=FloatToStrF(CurrentComponent.Demand[Horizon],ffFixed,8,0);
      with series2 do
      begin
         clear();
         for i:=1 to Horizon do
            add(CurrentComponent.Demand[i],IntToStr(1+(CurrentPeriod mod 100 + i-2) mod 52));
      end;
      with series1 do
      begin
         clear();
         for i:=1 to Horizon do
            add(CurrentComponent.Demand_last_week[i],IntToStr(1+(CurrentPeriod mod 100 + i-2) mod 52));
      end;

    end;
   //
   //  Quarterly information is shown
   //
   if rbQuarterlyDemand.Checked then
    with sgSalesData do
    begin
      ColCount:=1+MaxQuartersShown;
      RowCount:=5;
      fixedCols:=1;
      fixedRows:=2;
      Height:=RowCount*24+30;
      for j:=1 to MaxQuartersShown do begin
          Cells[j,0]:=IntToStr(CurrentYear + ((j-1) div 4));
          Cells[j,1]:='Qrt ' + IntToStr(1+(CurrentQuarter+j-2) mod 4) ;
      end;
      Cells[0,0]:='Year';
      Cells[0,1]:='Quarter';
      Cells[0,2]:='Current';
      Cells[0,3]:='Last week';
      Cells[0,4]:='Difference';

      // Calculate quarterly demand
      for i:=1 to MaxQuartersShown do
      begin
        TWQuartDemand[i]:=0;
        LWQuartDemand[i]:=0;
      end;
      for i:=1 to Horizon do
      begin
         k:=((CurrentWeek+i-2) div 13) + 1;
         j:=((CurrentWeek+i-3) div 13) + 1;
         TWQuartDemand[k]:=TWQuartDemand[k]+CurrentComponent.Demand[i];
         LWQuartDemand[j]:=LWQuartDemand[j]+CurrentComponent.Demand_last_week[i];
      end;
       for i:=1 to MaxQuartersShown do
      begin
        Cells[i,2]:=FloatToStrF(TWQuartDemand[i],ffFixed,8,0);
        Cells[i,3]:=FloatToStrF(LWQuartDemand[i],ffFixed,8,0);
        Cells[i,4]:=FloatToStrF(TWQuartDemand[i]-LWQuartDemand[i],ffFixed,8,0);
      end;
      with series1 do
      begin
         clear();
         for i:=1 to MaxQuartersShown do
            add(LWQuartDemand[i],'Qrt ' + IntToStr(1+(CurrentQuarter+j-2) mod 4));
      end;
       with series2 do
      begin
         clear();
         for i:=1 to MaxQuartersShown do
            add(TWQuartDemand[i],'Qrt ' + IntToStr(1+(CurrentQuarter+j-2) mod 4));
      end;
   end;
   //
   //  Monthly information is shown
   //
   if rbMonthlyDemand.Checked then
    with sgSalesData do
    begin
      ColCount:=1+MaxMonthsShown;
      RowCount:=5;
      fixedCols:=1;
      fixedRows:=2;
      Height:=RowCount*24+30;
      CurrentMonth:=WeekToMonth[CurrentWeek];
      for j:=1 to MaxMonthsShown do begin

          Cells[j,0]:=IntToStr(CurrentYear + (CurrentMonth+j-2) div 12 );
          Cells[j,1]:=Month[(1+(CurrentMonth+j-2) mod 12)] ;
      end;
      Cells[0,0]:='Year';
      Cells[0,1]:='Quarter';
      Cells[0,2]:='Current';
      Cells[0,3]:='Last week';
      Cells[0,4]:='Difference';

      // Calculate quarterly demand
      for i:=1 to MaxMonthsShown do
      begin
        TWMonthDemand[i]:=0;
        LWMonthDemand[i]:=0;
      end;
      l:=WeekToMonth[CurrentWeek]-1;
      for i:=1 to Horizon do
      begin
         k:=((CurrentWeek+i-2) div 52)*12+WeekToMonth[((CurrentWeek+i-2) mod 52)+1]-l;
         j:=((CurrentWeek+i-3) div 52)*12+WeekToMonth[((CurrentWeek+i-3) mod 52)+1]-l;
         TWMonthDemand[k]:=TWMonthDemand[k]+CurrentComponent.Demand[i];
         LWMonthDemand[j]:=LWMonthDemand[j]+CurrentComponent.Demand_last_week[i];
      end;
       for i:=1 to MaxMonthsShown do
      begin
        Cells[i,2]:=FloatToStrF(TWMonthDemand[i],ffFixed,8,0);
        Cells[i,3]:=FloatToStrF(LWMonthDemand[i],ffFixed,8,0);
        Cells[i,4]:=FloatToStrF(TWMonthDemand[i]-LWMonthDemand[i],ffFixed,8,0);
      end;
       with series1 do
      begin
         clear();
         for i:=1 to MaxMonthsShown do
            add(LWMonthDemand[i],Month[(1+(CurrentMonth+j-2) mod 12)]);
      end;
       with series2 do
      begin
         clear();
         for i:=1 to MaxMonthsShown do
            add(TWMonthDemand[i],Month[(1+(CurrentMonth+j-2) mod 12)]);
      end;
   end;

end;

procedure TPagesDlg.FormCreate(Sender: TObject);
var
  i : integer;
begin

  // inititing values for the Calender
  for i:=1 to 4 do WeekToMonth[i]:=1;
  for i:=5 to 8 do WeekToMonth[i]:=2;
  for i:=9 to 13 do WeekToMonth[i]:=3;
  for i:=14 to 17 do WeekToMonth[i]:=4;
  for i:=18 to 21 do WeekToMonth[i]:=5;
  for i:=22 to 26 do WeekToMonth[i]:=6;
  for i:=27 to 30 do WeekToMonth[i]:=7;
  for i:=31 to 34 do WeekToMonth[i]:=8;
  for i:=35 to 39 do WeekToMonth[i]:=9;
  for i:=40 to 43 do WeekToMonth[i]:=10;
  for i:=44 to 47 do WeekToMonth[i]:=11;
  for i:=48 to 52 do WeekToMonth[i]:=12;
  Month[1]:='Jan';
  Month[2]:='Feb';
  Month[3]:='Mar';
  Month[4]:='Apr';
  Month[5]:='May';
  Month[6]:='Jun';
  Month[7]:='Jul';
  Month[8]:='Aug';
  Month[9]:='Sep';
  Month[10]:='Oct';
  Month[11]:='Nov';
  Month[12]:='Dec';
end;

procedure TPagesDlg.rbWeeklyDemandClick(Sender: TObject);
begin
  TabSheet1Refresh;
end;

procedure TPagesDlg.rbMonthlyDemandClick(Sender: TObject);
begin
  TabSheet1Refresh;
end;

procedure TPagesDlg.rbQuarterlyDemandClick(Sender: TObject);
begin
 TabSheet1Refresh;
end;

end.

