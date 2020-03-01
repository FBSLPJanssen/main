unit MAP_GeneralProcedures;


interface

uses
  Windows, Messages,SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,WinProcs, Buttons, Menus, Mask, ExtCtrls, Grids, Outline,
  ComCtrls, ImgList;

procedure ReadaString (var text: TextFile ; var S: string);
Procedure MRPCalculation;

procedure GetAllEndNodes(Node : TTreeNode;var list :TList);


implementation


procedure ReadaString(var text: TextFile ; var S: string);
var character: char;
begin
 // character:=' ';
  S:='';
    repeat
      read(text, character);
    until character <> #9;

    repeat
      begin
        if ( (character <> ' ') and (character <> #9) ) then S:=S + character;
        read(text, character);
      end;
      until ((character =#9) or (EOLN(text) ));

    if EOLN(text) then
      begin
      if ( (character<>' ') and (character <> #9) )then
        S:=S+character;
      end;
end;



procedure MRPCalculation;
var
  i,n,l,k : integer;
begin
{
 // Compute the Gross requirements at the components
 for n:=NumEndProducts+1 to NumItems do
 begin
  for i:= 1 to Horizon do
  begin
    product[n].Demand[i]:=0;
    for k:=1 to NumItems do
      product[n].Demand[i]:=product[n].Demand[i]+BOM[n][k]*product[k].PlannedOrders[i];
  end;
 end;

 // Determine the planned-on-hand and planned receipts

 for n:=1 to Numitems do
 begin
   l:=product[n].Leadtime;
   for i:=1 to l do product[n].PlannedReceipts[i]:=0;
   product[n].PlannedOnHand[0]:=product[n].OHS;
   for i:=1 to Horizon do
   begin
      product[n].PlannedOnHand[i]:=product[n].PlannedOnHand[i-1]-product[n].Demand[i]+product[n].PlannedReceipts[i]+product[n].Pipeline[i];
     { if ((n>NumEndProducts) and (product[n].PlannedOnHand[i]<-1)) then
      mmInfeasibilitie.Lines.Add('week'+IntToStr (1+(CurrentPeriod mod 100 + i-2) mod 52 + 'product' + product[n]. Name);}
{
      product[n].PlannedReceipts[i+L]:=product[n].PlannedOrders[i];
   end;
 end;
}
end;



procedure GetAllEndNodes(Node : TTreeNode;var list :TList);
var
 i : integer;
begin
  for i:=0 to Node.Count-1 do
  begin
    if Node.Item[i].ImageIndex=0 then
      GetAllEndNodes(Node.Item[i],list)
    else
      list.Add(Node.Item[i].Data);
  end;
end;

end.
