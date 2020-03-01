unit MAP_Types;

interface

uses MAP_GraphicalComponents;

const
  MaxItems    = 70;
  MaxHorizon  = 70;
  MaxTrees    = 20;
  MaxProd     = 40;
  MaxComp     = 70;
  MaxLeadTime = 60;

type
  TExtendedItemArray    = array[0..MaxItems] of Extended;
  TIntegerItemArray     = array[0..MaxItems] of Integer;
  TExtendedHorizonArray = array[0..MaxHorizon] of Extended;
  TIntegerHorizonArray  = array[0..MaxHorizon] of Integer;
  ItemSet               = set of 0..MaxItems;

  PUserProduct = ^TUserProduct;

  // jss: checken wat uit stockpoint weg kan
  PAlgoritmeProduct=^TAlgoritmeProduct;
  TAlgoritmeProduct=record
                  Id,               { Identification }
                  pred,             { Predecessor node}
                  L,                { Leadtime}
                  Leadtime,         { from Item}
                  LLC,              { Low level code }
                  NOS : integer;    { Number of successors }
                  CompSet,          { associated components for this id}
                  ProdSet: Itemset; { associated end-products for this id}
                  h,                { Added values }
                  Cumh,             { Cumulative added values }
                  MTD,              { Mean total demand of ONE review period in sub-echelon }
                  cd2,              { Sq. coefficient of variation of demand in sub-echelon of ONE }
                                    { review period }
                  Mu_ech,           { Mean demand in this subechelon }
                  penalty,          { Penalty cost (only in end-stockpoints!) }
                  Service,          { Fill Rate }
                  Exp_Service,      { Experienced fill rate from supplier}
                  Alfa,             { Non-stockout probability}
                  Beta,             { from mu_ech_sim}
                  Beta_sim,         { from mu_ech_sim}
                  OHS_sim,          { from mu_ech_sim}
                  BL_sim,           { from mu_ech_sim}
                  OHS,              { On-hand-stock }
                  OHS1,
                  IP,               { Inventory-position }
                  Sum_I,            { Sum over inventory pos. of all succes. }
                  S,                { Order-up-to-level}
                  delta,            { sum_j S_j }
                  SS : Extended;    { Safety stock }
                  Stockpoint_S,     { Special order up to levels in order to determine
                                      stock_frac, ( (L+1)order-up-to-levels for
                                      stockpoint from 0 to L, Li=0 or 1)  }
                  pipe : TExtendedHorizonArray; { Pipeline stock }
                  Serv_suc,
                  Dem_suc,
                  p    : TExtendedItemArray;   { Allocation-fractions }
                  local_stock,
                  pipeline_stock,
                  pipeline_cost,
                  backlog,
                  holdcost,
                  pencost,
                  matcost,
                  capinv : Extended;
                  LT_S,
                  LT_Delta,
                  LT_alfa,
                  LT_Service,
                  LT_stock,
                  LT_holdcost,
                  LT_pencost,
                  LT_capinv : Extended;
                  MinValue : Extended;
                  TimeToEndpoint : array[1..MaxItems] of integer;
                  SafetyTimeToEndPoint : array[1..MaxItems] of integer;
                  SafetyTime     : integer;
                  {Cov : array[1..MNOS,1..MNOS] of Extended;}
                  Demand   :  TExtendedItemArray;   {Demand per period for the end-items}
                  Shortage :  TExtendedItemArray;   {Shortage for each period}
                  SchedRec : TExtendedItemArray;  {Scheduled Receipts}
                  PO       : TExtendedItemArray;  {Planned Orders}
                  next   : array[1..MaxItems] of PAlgoritmeProduct; { Successors }
                  pre    : PAlgoritmeProduct;
   end;

TProductGeneral = class
// parents>> we mean all predecessors.
// sources>> in case 4 products assemble to 1, then 4 parents and 1 source.
// in case of absence of Multisourcing, always 1 source.

        Name:   String;   {Name of the product/component}
        id:     integer;  {Identification number}
        ProductType:   integer;        {1:= Component, 2:= End Product}
        RLIP:   Extended;       {Requested Line Item Performance}
        Value:  Extended;

        // Graphical Components

        Picture    : TGraphicalStockPoint;
        Arrows     : array[1..MaxItems] of TArrow;

        //Network information:

        NumParents:     integer;
                {Number of predecessors including different Multi-sourcing sources}
        Multiplicity_Parent:   TIntegerItemArray;
                {Represents the BOM, eg Multiplicity_parent[k]=1 means BOM[k,id]=1}
        Component_id_Parent:   TIntegerItemArray;
                {For i=1..NumParents, Component_id_Parent[i]=k where k is id of the parent i }

        NumChilds:      integer;
                {Number of successors}
        Multiplicity_Child:     TIntegerItemArray;
                {number of items of product needed for 1 item of child, see also Multiplicity Parent}
        Component_id_Child:     TIntegerItemArray;
                {id van child(successor)}

        StockNorm:      Extended;
                {The requested stocknorm (safety leadtime) per item}

        InTree  : integer;
                {InTree indicates the network which includes this endproduct (if endproduct),
                added for Backwards-pegging}

        //Dynamic information

        OHS:    Extended;
                {Onhand Stock}
       // Realisation: Extended;
       // skip 04-2001
                { Realisation of demand/production in this week}

        Demand:       TExtendedHorizonArray;

        //Plannings info
        PlannedOnHand:  TExtendedHorizonArray;
                {The net stock available at the stockpoint}

        Ids_Copies: TIntegerItemArray;
        Id_User: integer;



end;

TUserProduct= Class(TProductGeneral)
        //Network information:

        Component_nr_Parent:   TIntegerItemArray;
                {gives new number (starting from 1) if component not exchangeable with a
                previous numbered item, else same number as other multi-source item}

        NumSource:     integer;
                {Number of Multi-Source Sources, if no MS, then NumSources :=1
                # that (Component_nr_Parent = 1)}

        User_Leadtime: TIntegerItemArray;
                {Leadtimes in usermodel, User_Leadtime per source}

        User_CompSet: Array[1..MaxItems] of ItemSet;
                {Set of Components, not clear where to use exactly, maybe equal to parentset}

        Yield:  TExtendedItemArray;
                {yield depending on source}

        Id_Components_in_source: array[1..MaxItems] of ItemSet;


        Location_of_source:     array[1..MaxItems] of string;


        Last_filled_source:     integer;

        //Dynamic information

        User_Pipeline:       Array [1..MaxItems, 0..MaxHorizon] of extended;
                {Pipeline [i,j]: orders from (Num)Source i that will arrive in j periods}
     //   User_RestPipeline:   Array [1..MaxItems, 0..MaxHorizon] of extended;
                {Orders in the pipeline that are not used in the underlying networks!,
                {  hence, this quantity should be adjusted with PO's from planning!!!}

        //Plannings info

        User_PlannedReceipts: Array [1..MaxItems, 0..MaxHorizon] of Extended;
                {User_PlannedReceipts [i,j]: planned receipts from (Num)Source i
                that are planned to arrive in j periods}
        User_PlannedOrders: Array [1..MaxItems, 0..MaxHorizon] of Extended;
                {User_PlannedOrders [i,j]: planned order release to (Num)Source i
                in period j}

        //Compare info
        OHS_last_week:  Extended;
        User_Pipeline_last_week:      Array [1..MaxItems, 0..MaxHorizon] of Extended;
        Demand_last_week: TExtendedHorizonArray;
        User_PlannedOrders_last_week: Array [1..MaxItems, 0..MaxHorizon] of Extended;

        public

        procedure Copy(var Y : TUserProduct);

end;

TPlanningsProduct = Class(TProductGeneral)

        //Network information:

        Leadtime:       integer;        {Leadtime in planningsmodel}
        CompSet:        ItemSet;
        yield:          extended;
        //Dynamic information

        Pipeline:       TExtendedHorizonArray ; {Pipeline [j]: orders that will arrive in j periods}
        RestPipeline:   TExtendedHorizonArray;  {Orders in the pipeline that are not used in the underlying networks!,
                              {  hence, this quantity should be adjusted with PO's from planning!!!}
        Total_RestPipeline: Extended;
        //Plannings info
        PlannedReceipts: TExtendedHorizonArray;
        PlannedOrders: TExtendedHorizonArray;



end;

TNetworkArray = Array[1..MaxTrees] of PAlgoritmeProduct;

procedure Dispose_Multi_ech(var Node : PAlgoritmeProduct);

//procedure ClearProduct(var p : TProduct);

implementation

procedure TUserProduct.Copy(var Y: TUserProduct);
Begin
  Y.Name:= Name;
  Y.id:=id;
  Y.ProductType:=ProductType;
  Y.RLIP:=RLIP;
  Y.Value:=Value;
  Y.NumParents:=NumParents;
  Y.Multiplicity_Parent:=Multiplicity_Parent;
  Y.Component_id_Parent:=Component_id_Parent;
  Y.NumChilds:=NumChilds;
  Y.Component_id_Child:=Component_id_Child;
  Y.Multiplicity_Child:=Multiplicity_Child;
  Y.StockNorm:=StockNorm;
  Y.InTree:=InTree;
  Y.OHS:=OHS;
 // Y.Realisation:=Realisation;
 // Y.Total_RestPipeline:=Total_RestPipeline;
  Y.Demand:=Demand;
  Y.PlannedOnHand:=PlannedOnHand;
  Y.Component_nr_parent:=Component_nr_parent;
  Y.NumSource:=NumSource;
  Y.User_Leadtime:=User_Leadtime;
  Y.User_CompSet:=User_CompSet;
  Y.Yield:=Yield;
  Y.Id_Components_in_source:=Id_Components_in_source;
  Y.Location_of_source:=Location_of_Source;
  Y.User_Pipeline:=User_Pipeline;
//  Y.User_RestPipeline:=User_RestPipeline;
  Y.User_PlannedReceipts:=User_PlannedReceipts;
  Y.User_PlannedOrders:=User_PlannedOrders;
end;


procedure Dispose_Multi_ech(var Node : PAlgoritmeProduct);
var i : integer;
begin
  for i:=1 to Node^.NOS do Dispose_Multi_Ech(Node^.next[i]);
  dispose(Node);
end;


//uitgeschakeld 13-3-2001
{Procedure ClearProduct(var p: Tproduct);
var
 i,j,k : integer;
begin
 with p do
 begin
   Name:='';
   Id:=0;
   Value:=0;
   ProductType:=0;
   RLIP:=0;
{new}



{   for i:=1 to MaxItems do
   begin
      Component_Leadtime[i]:=0;
   end;
   Leadtime:=0;

   ED:=0.0;
   ED_dak:=0.0;
   SD:=0.0;
   SD_dak:=0.0;
   StockNorm:=0.0;
   OHS:=0.0;
   OHS_last_week:=0.0;
   Realisation:=0.0;
   CumPhys:=0.0;
   NormPhys:=0.0;
   for k:=1 to MaxTrees do
     NormTreePhys[k]:=0.0;
   P1:=0.0;
   P2:=0.0;
   S:=0.0;
   SS:=0.0;
   Delta:=0.0;
   mu_ech:=0.0;
   BL:=0.0;
   Xcoord:=0;
   Ycoord:=0;
   for i:=0 to MaxHorizon do
   begin
      PipeLine[i]:=0.0;
      PipeLine_last_week[i]:=0.0;
      Demand[i]:=0.0;
      Shortage[i]:=0.0;
      Demand_last_week[i]:=0.0;
      PlannedOnHand[i]:=0.0;
      PlannedReceipts[i]:=0.0;
      PlannedOrders[i]:=0.0;
      PlannedOrders_last_week[i]:=0.0;
    end;
   // CompSet:=[];}


{
   end;
  end;
end.
}//extra bijgezet 13-03-21001
begin
end.




