unit MainForm;

interface

uses

  TeeProcs, TeEngine, Chart, Series, Spin, ImgList, Buttons,
  Windows, Messages,SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,WinProcs, Menus, Mask, ExtCtrls, Grids, Outline,
  ComCtrls, printers,
  MAP_Types,
  MAP_GraphicalComponents,
  MAP_GeneralProcedures,
  MAP_UserInterfaceItems;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Save1: TMenuItem;
    SaveDialog1: TSaveDialog;
    lblYear: TLabel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    edtYear: TEdit;
    edtWeek: TEdit;
    edtHorizon: TEdit;
    load1: TMenuItem;
    SpeedButton3: TSpeedButton;
    New1: TMenuItem;
    OpenDialog1: TOpenDialog;
    TreeView1: TTreeView;
    PopupMenu1: TPopupMenu;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    New2: TMenuItem;
    ImageList1: TImageList;
    Close1: TMenuItem;
    SpeedButton4: TSpeedButton;
    UsertoPlanning1: TMenuItem;
    PlanningtoUser1: TMenuItem;
    GroupBox1: TGroupBox;

    procedure FormCreate(Sender: TObject);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    Procedure RefreshConnections(Sender : TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure edtYearKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtWeekKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtHorizonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure load1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure New2Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Close1Click(Sender: TObject);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure SpeedButton4Click(Sender: TObject);
    procedure UsertoPlanning1Click(Sender: TObject);
    procedure PlanningtoUser1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);

    private


    { Private declarations }
  public
  NumItems,
  NumEndProducts,
  NumEndPoints,
  NumComponents,
  NumConnections  : Integer;

  CurrentPeriod,
  CurrentWeek,
  CurrentYear,
  CurrentQuarter,
  CurrentMonth          : Integer;

  Horizon               : Integer;

  CurrentTreeNode,
  Folder1,
  Folder2 : TTreeNode;

  product:              array[1..MaxItems] of TUserProduct;             // to test
  product2:             array[1..MaxItems] of TPlanningsProduct;        // to test
  ListEndProducts,      // User_Model
  ListComponents,       // User_Model
  ListAllProducts,      // User_Model
  ListPlanningsProducts,        // Plannings_Model
  ListHelpProducts: TList;      // Between User and Planning

  id_db: array[1..MaxItems] of integer;  // id_db[id_tool]: gives the id of the database
  // corresponding to the id used in the tool for the same item.

  BOM:  array[1..MaxItems, 1..MaxItems] of integer;     // Bill of Material
  // BOM[i,j]: nr of items with id i in item with id j

   { Public declarations }
  end;


var

//
// Global Variables
//
  Form1  : TForm1;

implementation

uses AddStockPoint;
{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var i: integer;
begin
  for i:=1 to MaxItems do
  begin
    product[i]:=TUserProduct.Create;
    product2[i]:=TPlanningsProduct.Create;
    //ClearProduct(Product[i]);
  end;
  ListPlanningsProducts:=TList.Create;
  ListEndProducts:=TList.Create;
  ListComponents:=TList.Create;
  ListAllProducts:=Tlist.Create;
  ListHelpProducts:=TList.Create;


  NumConnections:=0;
  NumEndPoints:=0;
  CurrentYear:=2001;
  Currentweek:=2;
  Horizon:=26;
end;

// nog niet af!!
procedure MSChangeHelpProducts(var X: TList);

var     i,j,k,l: integer;
        CurrentUserProduct,
        CurrentUserProduct2,
        NextCurrentUserProduct: TUserProduct;
        StillNextStepNeeded, StillMultiSources : Boolean;
        SetBeginComponentIds, SetOtherComponentIds, HelpSet: ItemSet;

procedure Horizontal_Split(var X: TUserProduct; var List: TList);

var     NewUserProduct          : TUserProduct;
        i,j,k,l,nr_sources_ori, nr_parents_ori, last, nr_items_in_ori_List
                                : Integer;
        HelpSet:        ItemSet;
        HelpComponent_id_Parent, HelpMultiplicity_Parent: TIntegerItemArray;


begin
  nr_sources_ori:=X.NumSource;
  nr_parents_ori:=X.NumParents;
  nr_items_in_ori_list:=List.Count;
  for i:=1 to (nr_sources_ori -1) do
  begin
    NewUserProduct:=TUserProduct.Create;
    X.Copy(NewUserProduct);

    For k:=1 to MaxItems do     // clear some elements of NewUserProduct
    begin
      with NewUserProduct do
      begin
        Component_id_parent[k]:=0;
        Id_Components_in_source[k]:=[];
        Multiplicity_parent[k]:=0;
        User_Leadtime[k]:=0;
        User_Compset[k]:=[];
        Yield[k]:=1;
        Location_of_source[k]:='';
        for l:=1 to MaxHorizon do
        User_Pipeline[k, l]:=0;
      end;
    end;

    with NewUserProduct do
    begin
      NumSource:=1;     // no MS Source anymore
      Name:=NewUserProduct.Name + '_' + IntToStr(i); //new name
      id:=List.Count;      // id telling gaat gewoon door
      NumParents:=Round((nr_parents_ori)/(nr_sources_ori));     //new number of parents
    end;


    last:=0;
    // new components_nrs, new component_ids_parents, corresponding multiplicity
    For k:=1 to (List.Count) do
    begin
      if k in X.Id_Components_in_source[i+1] then
      begin
        last:=last+1;
        NewUserProduct.Component_nr_parent[last]:=last;
        NewUserProduct.Component_id_Parent[last]:=k;
        for l:=1 to (nr_parents_ori) do
        begin
          if (X.Component_id_Parent[l]=k) then
          NewUserProduct.Multiplicity_Parent[k]:=X.Multiplicity_Parent[l];
        end;
      end;
    end; // last now equal to NewUserProduct.NumParents


    with NewUserProduct do
    begin
      User_Leadtime[1] :=X.User_Leadtime[i+1];
      User_Compset[1] := X.User_Compset[i+1];
      Yield[1]:=X.Yield[i+1];
      Id_Components_in_source[1] :=X.Id_Components_in_source[i+1];
      Location_of_source[1] :=X.Location_of_source[i+1];
      User_Pipeline[1] :=X.User_Pipeline[i+1];
    end;

    List.Add(NewUserProduct);

  end;

//Change right things in X  (node which keeps the same id as the original Ms node)
  with X do
    begin
      NumSource:=1;     // no MS Source anymore
      Name:=NewUserProduct.Name + '_' + IntToStr(0); //new name
      NumParents:=Round((nr_parents_ori)/(nr_sources_ori));     //new number of parents
    end;

  last:=0;
  HelpSet:=X.Id_Components_in_source[1];
  HelpComponent_id_Parent:=X.Multiplicity_Parent;
  HelpMultiplicity_Parent:=X.Component_id_Parent;

    // new components_nrs, new component_ids_parents, corresponding multiplicity
    For k:=1 to (nr_items_in_ori_list) do
    begin
      if k in HelpSet then
      begin
        last:=last+1;
        X.Component_nr_parent[last]:=last;
        X.Component_id_Parent[last]:=k;
        for l:=1 to (nr_parents_ori) do
        begin
          if (HelpComponent_id_Parent[l]=k) then
          X.Multiplicity_Parent[k]:=HelpMultiplicity_Parent[l];
        end;
      end;
    end; // last now equal to NewUserProduct.NumParents

    with X do
    begin
      for i:=2 to nr_items_in_ori_list do
      User_Leadtime[i] :=0;
      User_Compset[i] := [];
      Yield[i]:=0;
      Id_Components_in_source[i] :=[];
      Location_of_source[i] :='';
      for k:=1 to MaxHorizon do User_Pipeline[i, k] := 0;
    end;



end;  //end Horizontal Split;



begin

  SetBeginComponentIds:=[];
  SetOtherComponentIds:=[];

  // Initialize
  StillNextStepNeeded:=True;
  StillMultiSources:=True;
  for i:=0 to  ((X.Count)-1) do
  begin
    CurrentUserProduct:=X.Items[i];
    if CurrentUserProduct.ProductType=3 then
    SetBeginComponentIds:=SetBeginComponentIds + [CurrentUserProduct.id]
    else
    SetOtherComponentIds:=SetOtherComponentIds + [CurrentUserProduct.id];
  end;
  // end Intialize


  // 1) Check if there are still multisource nodes (begin check with the
  //    beginComponents, go to child until either a multisource node is found
  //    or all nodes are checked.
  // 2) If there is a multisource node found, the horizontal split procedure
  //    generates a number of new (not multi-source) nodes and changes the
  //    original parent(s) of the original multisource node into a multisource node
  //    see procedure horizontal split



  if StillMultiSources then     // there are multisource nodes

  Repeat

    begin
      i:=0;
      while StillNextStepNeeded do
      begin
        CurrentUserProduct:=X.Items[i];
        if ([CurrentUserProduct.id] <= SetBeginComponentIds) then      // start with begin components
        begin
          while ((CurrentUserProduct.NumSource=1) and (CurrentUserProduct.NumChilds>0)) do  // stop if CurrentUserProduct is MS or if CurrentUserProduct is endpoint
            begin
              for j:=0 to (X.Count-1) do
              begin
                NextCurrentUserProduct:=X.Items[j];
                if ( (NextCurrentUserProduct.id = CurrentUserProduct.Component_id_Child[1])
                   and (StillNextStepNeeded= true) ) then
                begin
                  CurrentUserProduct:=NextCurrentUserProduct;
                  StillNextStepNeeded:=false;
                end;
              end;
            end;
        end;
        i:=i+1;
      end;

      i:=0;
      while StillNextStepNeeded do
      begin
        CurrentUserProduct:=X.Items[i];
        if ([CurrentUserProduct.id] <= SetOtherComponentIds) then
        begin
          while ((CurrentUserProduct.NumSource=1) and (CurrentUserProduct.NumChilds>0)) do
          begin
            for j:=0 to (X.Count-1) do
            begin
              NextCurrentUserProduct:=X.Items[j];
              if ( (NextCurrentUserProduct.id = CurrentUserProduct.Component_id_Child[1])
              and (StillNextStepNeeded= true) ) then
              begin
                CurrentUserProduct:=NextCurrentUserProduct;
                StillNextStepNeeded:=false;
              end;
            end;
          end;
        end;
        i:=i+1;
      end;

    end;

  Horizontal_Split(CurrentUserProduct, X);

  for i:=0 to (X.Count-1) do
  begin
    CurrentUserProduct:=X.Items[i];
    if CurrentUserProduct.ProductType=3 then
    SetBeginComponentIds:=SetBeginComponentIds + [CurrentUserProduct.id]
    else
    SetOtherComponentIds:=SetOtherComponentIds + [CurrentUserProduct.id];
  end;

  until (StillMultiSources = false);

end;

// procedure for step 1..4 of the horizontal split algorithm to handle multisourcing: change
// ms network by splitting up the network from the multisource notes in different branches
// not used in current setting, because MS functionality not included.

//end MSChangeHelpProducts



procedure TForm1.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
 (Source as TGraphicalStockPoint).Top:=Y;
 (Source as TGraphicalStockPoint).Left:=X;
    Invalidate;
end;


procedure TForm1.RefreshConnections(Sender : TObject);
begin
 Invalidate;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
 node : TTreeNode;
begin
  Application.CreateForm(TForm3, Form3);
  Form3.Caption:='Add Component';
  try
    if Form3.ShowModal()=mrOK then
    begin
      // include code for adding a new endproduct
     { Inc(NumSP);
      stockpoint[NumSP]:=TGraphicalStockPoint.Create(Self);
      stockpoint[NumSP].parent:=self;
      stockpoint[NumSP].Top:=50;
      stockpoint[NumSP].Left:=50;
      stockpoint[NumSP].Name:=Form3.Name;
      stockpoint[NumSP].Endproduct:=2;
      node:=TreeView1.Items.AddChildObject(Folder2,Form3.name,stockpoint[NumSP]);
      node.ImageIndex:=2;
      node.SelectedIndex:=2;}
    end;
  finally
    Form3.free;
    Form3:=nil;
  end;
end;

procedure TForm1.edtYearKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RETURN then
  begin
    CurrentYear:=StrToInt(edtYear.Text);
  end;
end;

procedure TForm1.edtWeekKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RETURN then
  begin
    CurrentWeek:=StrToInt(edtWeek.Text);
  end;
end;

procedure TForm1.edtHorizonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RETURN then
  begin
    Horizon:=StrToint(edtHorizon.Text);
  end;
end;

procedure TForm1.load1Click(Sender: TObject);
var
  indata                            : TextFile;
  i,j,k,endproduct,x,y, ProductType, idMdl, idDB, idMdlParent, idDBParent : integer;
  ED,SD,service,value,stocknorm, on_hand_stock : extended;
  Node,MyTreeNode2                  : TTreeNode;
  Name, name_stockpoint, name_parent, location_parent: string;
  id_name_stockpoint, mult, comp_numb, Leadt, NumSource_old : integer;
  //id_parent_set                      : ItemSet;
  yield, RLIP: extended;
  character: char;
  demand_forecast, production: array[1..MaxHorizon] of extended;
  AUserProduct, CurrentUserProduct: TUserProduct;
  //id_parent: 1..MaxItems;
  id_parent: integer;
  placed, found: boolean;

Function Find_idMdl(X: integer):integer;
var     i: integer;
        found: boolean;
begin
  if (X=0) then
  Find_idMdl:=0
  else
  begin
    found:=false;
    i:=0;
    repeat
    if (id_DB[i]=X) then
      begin
        Find_idMdl:=i;
        found:=true;
      end;
    i:=i+1;
    until (found=true);
  end;
end;

begin
  if OpenDialog1.Execute then
  begin
    ListEndProducts.Clear();
    ListComponents.Clear();
    ListAllProducts.Clear();
    ListHelpProducts.Clear();
    ListPlanningsProducts.Clear();
    for j:=0 to MaxItems do
    id_db[j]:=0;

    // Delete current stockpoints
    New1Click(Sender);
    // Inlezen nieuwe data
    AssignFile(indata, OpenDialog1.FileName);
    reset(indata);
    readln(indata);readln(indata);readln(indata);
    //
    //1 Read general info of the supply chain
    //
    //
    readln(indata,CurrentPeriod);
    readln(indata,Horizon);
    // init other date variables
    CurrentWeek:=CurrentPeriod mod 100;
    CurrentYear:=CurrentPeriod div 100;
    readln(indata);readln(indata);readln(indata);

    //
    //2 Read General info of items
    //
    //
    //a) First item

    ReadaString(indata, Name);
    readln(indata, idDB
          ,RLIP
          ,value
          ,ProductType
          ,Stocknorm
          ,x
          ,y
          );
    idMdl:=1;
    repeat
      AUserProduct:=TUserProduct.Create;
      AUserProduct.Name:=Name;
      AUserProduct.id:=idMdl;
      AUserProduct.RLIP:=RLIP;
      AUserProduct.value:=Value;
      AUserProduct.ProductType:=ProductType;
      AUserProduct.StockNorm:=StockNorm;
      AUserProduct.NumParents:=0;
      AUserProduct.NumChilds:=0;
      AUserProduct.last_filled_source:=0;
      // configure the graphical representation
      AUserProduct.Picture:=TGraphicalStockPoint.Create(Self);
      AUserProduct.Picture.parent:=self;
      AUserProduct.Picture.top:=y;
      AUserProduct.Picture.left:=x;
      AUserProduct.Picture.Name:=Name;
      AUserProduct.Picture.ProductType:=ProductType;
      if ((ProductType = 1) or (ProductType = 0) and (id_name_stockpoint<>0)) then
      begin
         ListComponents.Add(AUserProduct);
         ListAllProducts.Add(AUserProduct);
         node:=TreeView1.Items.AddChildObject(Folder2,name,AUserProduct);
         node.ImageIndex:=1;
         node.SelectedIndex:=1;
      end else
      if (id_name_stockpoint<>0) then
      begin
         ListEndProducts.Add(AUserProduct);
         ListAllProducts.Add(AUserProduct);
         node:=TreeView1.Items.AddChildObject(Folder1,name,AUserProduct);
         node.ImageIndex:=2;
         node.SelectedIndex:=2;
      end;
      id_DB[idMdl]:=idDB;
      // b) read next item
      ReadaString(indata, Name);
      if (Name<>'last') then
      begin
      readln(indata,
        idDB
        ,RLIP
        ,value
        ,ProductType
        ,Stocknorm
        ,x
        ,y
        );
      end;
      idMdl:=idMdl+1;
    until (name='last');

    NumEndproducts:=ListEndProducts.Count;
    NumComponents:=ListComponents.Count;
    NumItems:=ListAllProducts.Count;

    readln(indata);
    readln(indata); readln(indata); readln(indata);
    //
    // 3) Read Routing Information
    //

    // a) read first routing
    ReadaString(indata, name_stockpoint);
    read(indata, idDB);
    ReadaString(indata, name_parent);
    ReadaString(indata, location_parent);
    readln(indata,
            idDBParent,
            mult,
            comp_numb,
            Leadt,
            yield
           );
    repeat
      id_name_stockpoint:=Find_idMdl(idDB);
      id_parent:=Find_idMdl(idDBParent);
      // adjust info at child-level
      for i:=0 to (ListAllProducts.Count-1) do
      begin
        CurrentUserProduct:=ListAllProducts.Items[i];
        if ((CurrentUserProduct.id = id_name_stockpoint) and (CurrentUserProduct.ProductType<>0)) then
        begin
          placed:=false;
          CurrentUserProduct.NumParents := CurrentUserProduct.NumParents +1;
          CurrentUserProduct.Component_nr_Parent[CurrentUserProduct.NumParents]:=comp_numb;
          CurrentUserProduct.Component_id_Parent[CurrentUserProduct.NumParents]:=id_parent;
          if (CurrentUserProduct.Component_nr_Parent[1]=comp_numb) then
            CurrentUserProduct.NumSource:=CurrentUserProduct.NumSource +1;
          CurrentUserProduct.Multiplicity_Parent[id_parent]:=mult;
          for j:=1 to (CurrentUserProduct.last_filled_source) do   // search in old locations
          begin
            if CurrentUserProduct.Location_of_source[j]='location' then
            begin
              CurrentUserProduct.Id_Components_in_source[CurrentUserProduct.Last_filled_source]:=
              CurrentUserProduct.Id_Components_in_source[CurrentUserProduct.Last_filled_source]
              + [id_parent];
              placed:=true;
            end;
          end;
          if (placed=false) then  // case new location
          begin
            CurrentUserProduct.last_filled_source := CurrentUserProduct.last_filled_source +1;
            CurrentUserProduct.Id_Components_in_Source[CurrentUserProduct.last_filled_source]:=
            [id_parent];
            CurrentUserProduct.Location_of_source[CurrentUserProduct.last_filled_source]:=location_parent;
            CurrentUserProduct.user_leadtime[CurrentUserProduct.last_filled_source]:=leadt;
            CurrentUserProduct.yield[CurrentUserProduct.last_filled_source]:=yield;
          end;
        end
        else  // if BeginComponent then parent is "external source";
        if (CurrentUserProduct.id = id_name_stockpoint) then
        begin
          CurrentUserProduct.NumParents:=1;
          CurrentUserProduct.Location_of_source[1]:=location_parent;
          CurrentUserProduct.Component_id_parent[1]:=0;
          CurrentUserProduct.Multiplicity_parent[1]:=0;
          CurrentUserProduct.NumSource:=1;
          CurrentUserProduct.User_Leadtime[1]:=leadt;
          CurrentUserProduct.Yield[1]:=yield;
          CurrentUserProduct.Location_of_source[1]:=location_parent;
        end;
      end;
      // adjust info at parent-level // only when currentuserproduct is no begincomponent( so not producttype 0)

      for i:=0 to (NumItems-1) do
      begin
        CurrentUserProduct:=ListAllProducts.Items[i];
        if ((CurrentUserProduct.id = id_parent) and (CurrentUserProduct.ProductType <> 0)) then
        begin
          with CurrentUserProduct do
          begin
            NumChilds:=NumChilds+1;
            Component_id_Child[NumChilds]:=id_name_stockpoint;
            Multiplicity_Child[Component_id_Child[NumChilds]]:=mult;
          end;
        end;
      end;

      // b) read next routing info

      ReadaString(indata, name_stockpoint);
      if (name_stockpoint<>'last') then
      begin
        read(indata, idDB);
        ReadaString(indata, name_parent);
        ReadaString(indata, location_parent);
        readln(indata,idDBParent
                     ,mult
                     ,comp_numb
                     ,Leadt
                     ,yield
             );
      end;
    until (name_stockpoint='last');


    //
    // 4) read demand information
    //
    readln(indata); readln(indata); readln(indata); readln(indata);
    for i:=1 to NumEndProducts do
    begin
      ReadaString(indata, name_stockpoint);
      read(indata, idDB);
      id_name_stockpoint:=Find_idMdl(idDB);
      for j:=1 to Horizon do read(indata, demand_forecast[j]);
      readln(indata);
      for j:=0 to (ListEndProducts.Count-1) do
      begin
         CurrentUserProduct:=ListEndProducts.Items[j];
         if (CurrentUserProduct.id = id_name_stockpoint) then
         begin
           for k:=1 to Horizon do
              CurrentUserProduct.Demand[k]:=demand_forecast[k];
         end;
      end;
    end;
    //
    // 5 read WIP and transit information
    //
    readln(indata); readln(indata); readln(indata);
    ReadaString(indata, name_stockpoint);
    read(indata, idDB);
    id_name_stockpoint:=Find_idMdl(idDB);
    ReadaString(indata, location_parent);
    repeat
    begin
      found:=false;
      i:=1;
      for j:=0 to (NumItems-1) do
      begin
        CurrentUserProduct:=ListAllProducts.Items[j];
        if (CurrentUserProduct.id=id_name_stockpoint) then
        begin
          repeat
          if (CurrentUserProduct.Location_of_source[i]=location_parent) then
          begin
            for k:=1 to (CurrentUserProduct.User_Leadtime[i]) do
            Read(indata, CurrentUserProduct.User_Pipeline[i, k]);
            Readln(indata);
            found:=true;
          end;
          i:=i+1;
          until(found=true)
        end;
      end;
      ReadaString(indata, name_stockpoint);
      if (name_stockpoint<>'last') then
      begin
        read(indata, idDB);
        id_name_stockpoint:=Find_idMdl(idDB);
        ReadaString(indata, location_parent);
      end;
    end;
    until (name_stockpoint='last');

readln(indata); readln(indata); readln(indata); readln(indata);
//
// 6  Read OHS
//
//
for i:=1 to (NumItems) do
begin
  ReadaString(indata, name_stockpoint);
  read(indata, idDB);
  id_name_stockpoint:=Find_idMdl(idDB);
  read(indata, on_hand_stock);

  for j:=0 to (ListAllProducts.Count-1) do
    begin
      CurrentUserProduct:=ListAllProducts.Items[j];
      if (CurrentUserProduct.id = id_name_stockpoint) then
      begin
        CurrentUserProduct.OHS:=on_hand_stock;
      end;
    end;
end; //read OHS

//
// 7 read production/delivery plan
//
//
readln(indata); readln(indata); readln(indata); readln(indata);
ReadaString(indata, name_stockpoint);
read(indata, idDB);
id_name_stockpoint:=Find_idMdl(idDB);
ReadaString(indata, location_parent);
repeat
begin
  found:=false;
  i:=1;
  for j:=0 to (NumItems-1) do
  begin
    CurrentUserProduct:=ListAllProducts.Items[j];
    if (CurrentUserProduct.id=id_name_stockpoint) then
    begin
      repeat
      if (CurrentUserProduct.Location_of_source[i]=location_parent) then
      begin
        for k:=1 to (Horizon) do
        Read(indata, CurrentUserProduct.User_PlannedOrders[i, k]);
        Readln(indata);
        found:=true;
      end;
      i:=i+1;
      until(found=true)
    end;
  end;
  ReadaString(indata, name_stockpoint);
  if (name_stockpoint<>'last') then
  begin
    read(indata, idDB);
    id_name_stockpoint:=Find_idMdl(idDB);
    ReadaString(indata, location_parent);
  end;
end;
until (name_stockpoint='last'); // read production/delivery plan


//LAST WEEK INFORMATION

//
// 8 read demand information last week
//
//
readln(indata); readln(indata); readln(indata); readln(indata); readln(indata); readln(indata); readln(indata);

for i:=1 to NumEndProducts do
begin
  ReadaString(indata, name_stockpoint);
  read(indata, idDB);
  id_name_stockpoint:=Find_idMdl(idDB);
  for j:=1 to Horizon do read(indata, demand_forecast[j]);
  readln(indata);

  for j:=0 to (ListEndProducts.Count-1) do
    begin
      CurrentUserProduct:=ListEndProducts.Items[j];
      if (CurrentUserProduct.id = id_name_stockpoint) then
      begin
        for k:=1 to Horizon do
        CurrentUserProduct.Demand_last_week[k]:=demand_forecast[k];
      end;
    end;
end; //read demand information last week

//
// 9 read WIP and transit info last week
//
//

readln(indata); readln(indata); readln(indata);

ReadaString(indata, name_stockpoint);
read(indata, idDB);
id_name_stockpoint:=Find_idMdl(idDB);
ReadaString(indata, location_parent);

repeat

begin

found:=false;
i:=1;

  for j:=0 to (ListAllProducts.Count-1) do
  begin
    CurrentUserProduct:=ListAllProducts.Items[j];
    if (CurrentUserProduct.id=id_name_stockpoint) then
    begin
      repeat
        if (CurrentUserProduct.Location_of_source[i]=location_parent) then
        begin
          for k:=1 to (CurrentUserProduct.User_Leadtime[i]) do
          Read(indata, CurrentUserProduct.User_Pipeline_last_week[i, k]);
          Readln(indata);
          found:=true;
        end;
       i:=i+1;
      until(found=true)
    end;
  end;

  ReadaString(indata, name_stockpoint);
  if (name_stockpoint<>'last') then
  begin
    read(indata, idDB);
    id_name_stockpoint:=Find_idMdl(idDB);
    ReadaString(indata, location_parent);
  end;

end;
until (name_stockpoint='last');  //read pipeline info last week

readln(indata); readln(indata); readln(indata); readln(indata);

//
// 10 Read OHS last week
//
//
for i:=1 to (NumItems) do
begin
  ReadaString(indata, name_stockpoint);
  read(indata, idDB);
  id_name_stockpoint:=Find_idMdl(idDB);
  read(indata, on_hand_stock);

  for j:=0 to (ListAllProducts.Count-1) do
    begin
      CurrentUserProduct:=ListAllProducts.Items[j];
      if (CurrentUserProduct.id = id_name_stockpoint) then
      begin
        CurrentUserProduct.OHS_last_week:=on_hand_stock;
      end;
    end;

end; //read OHS last week

//
// 11 read production/delivery plan last week
//
//

readln(indata); readln(indata); readln(indata); readln(indata);
ReadaString(indata, name_stockpoint);
read(indata, idDB);
id_name_stockpoint:=Find_idMdl(idDB);
ReadaString(indata, location_parent);
repeat
begin
  found:=false;
  i:=1;
  for j:=0 to (NumItems-1) do
  begin
    CurrentUserProduct:=ListAllProducts.Items[j];
    if (CurrentUserProduct.id=id_name_stockpoint) then
    begin
      repeat
      if (CurrentUserProduct.Location_of_source[i]=location_parent) then
      begin
        for k:=1 to (Horizon) do
        Read(indata, CurrentUserProduct.User_PlannedOrders_last_week[i, k]);
        Readln(indata);
        found:=true;
      end;
      i:=i+1;
      until(found=true)
    end;
  end;
  ReadaString(indata, name_stockpoint);
  if (name_stockpoint<>'last') then
  begin
    read(indata, idDB);
    id_name_stockpoint:=Find_idMdl(idDB);
    ReadaString(indata, location_parent);
  end;
end;
until (name_stockpoint='last'); // read production/delivery plan

//vul een array met producten met de informatie uit de 2 lijsten, te beginnen
// met de lijst met eindproducten        TO TEST
  for i:=0 to (NumEndProducts-1) do
    product[i+1]:=ListEndProducts.Items[i];

  for i:=0 to (NumComponents -1) do
    product[i+NumEndProducts+1]:=ListComponents.Items[i];

  //einde vullen producten

  CloseFile(indata);
  end; // OpenDialog1.Execute
invalidate;

end;



procedure TForm1.New1Click(Sender: TObject);
var
  i,j : integer;
begin
  NumConnections:=0;
  NumEndPoints:=0;
  TreeView1.Items.Clear; { remove any existing nodes }
  Folder1:=TreeView1.Items.Add(nil,'End-products');{ Add root node}
  Folder2:=TreeView1.Items.Add(nil,'Components'); { Add root node}
  Invalidate;
end;

procedure TForm1.Copy1Click(Sender: TObject);
begin
  CurrentTreeNode:=TreeView1.Selected;
end;

procedure TForm1.Paste1Click(Sender: TObject);
begin
  if TreeView1.Selected.ImageIndex=0 then
   CurrentTreeNode.MoveTo(TreeView1.Selected,naAddChild)
  else
   CurrentTreeNode.MoveTo(TreeView1.Selected,naInsert);
end;

procedure TForm1.New2Click(Sender: TObject);
var
 Node : TTreeNode;
begin
  Node:=TreeView1.Items.Add(Treeview1.Selected,'New Folder');
  Node.EditText;

end;


// Procedure to show info on item

procedure TForm1.TreeView1DblClick(Sender: TObject);
var
  CurrentProduct : TUserProduct;
  components     : TList;
  SelectedNode   : TTreeNode;
  i,j : integer;
begin
  SelectedNode:=Treeview1.Selected;
  if (SelectedNode.ImageIndex>=1) then
  begin
    CurrentProduct:=Treeview1.Selected.data;
    Application.CreateForm(TPagesDlg, PagesDlg);
    PagesDlg.CurrentComponent:=CurrentProduct;
    PagesDlg.CurrentPeriod:=CurrentPeriod;
    PagesDlg.CurrentWeek:=CurrentWeek;
    PagesDlg.CurrentYear:=CurrentYear;
    PagesDlg.CurrentQuarter:=CurrentQuarter;
    PagesDlg.CurrentMonth:=CurrentMonth;
    PagesDlg.Horizon:=Horizon;
    If CurrentProduct.ProductType=1 then
         PagesDlg.TabSheet1.TabVisible:=False
    else
        PagesDlg.TabSheet1.TabVisible:=True;
    try
      if PagesDlg.ShowModal()=mrOK then
      begin

      end;
    finally
      PagesDlg.free;
      PagesDlg:=nil;
    end;
  end else
  begin
    // collect all the components in this folder
    components:=TList.Create();
    GetAllEndNodes(SelectedNode,components);
    //j:=0;
    //for i:=0 to Components.Count-1 do
    // j:=j+1;

  end;
end;

procedure TForm1.TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  AnItem: TTreeNode;
  AttachMode: TNodeAttachMode;
  HT: THitTests;
begin
  if TreeView1.Selected = nil then Exit;
  HT := TreeView1.GetHitTestInfoAt(X, Y);
  AnItem := TreeView1.GetNodeAt(X, Y);
  if (HT - [htOnItem, htOnIcon, htNowhere, htOnIndent] <> HT) then
  begin
    if (htOnItem in HT) or (htOnIcon in HT) then AttachMode := naAddChild
    else if htNowhere in HT then AttachMode := naAdd
    else if htOnIndent in HT then AttachMode := naInsert;
    if (AnItem.ImageIndex=1) then AttachMode := naInsert;
    TreeView1.Selected.MoveTo(AnItem, AttachMode);
  end;
end;

procedure TForm1.TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
 Accept:=true;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
 Close();
end;

procedure TForm1.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=true;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
var
 node : TTreeNode;
begin
  Application.CreateForm(TForm3, Form3);
  Form3.Caption:='Add End-Product';
  try
    if Form3.ShowModal()=mrOK then
    begin
      {Inc(NumSP);
      stockpoint[NumSP]:=TGraphicalStockPoint.Create(Self);
      stockpoint[NumSP].parent:=self;
      stockpoint[NumSP].Top:=50;
      stockpoint[NumSP].Left:=50;
      stockpoint[NumSP].Name:=Form3.Name;
      stockpoint[NumSP].Endproduct:=1;
      node:=TreeView1.Items.AddChildObject(Folder1,Form3.name,stockpoint[NumSP]);
      node.ImageIndex:=1;
      node.SelectedIndex:=1;}
      end;
  finally
    Form3.free;
    Form3:=nil;
  end;

end;

procedure TForm1.UsertoPlanning1Click(Sender: TObject);
var     i,j,k,l, test: integer;
        CurrentUserProduct,
        CurrentUserProduct2: TUserProduct;
        CurrentPlanningsProduct: TPlanningsProduct;
        MultiSources : Boolean;

begin
  // Copy ListAllProducts to ListHelpProducts
  ListHelpProducts.Clear();

  for i:=0 to (ListAllProducts.Count-1) do
  begin
    CurrentUserProduct:=TUserProduct.Create;
    CurrentUserProduct2:=TUserProduct.Create;
    CurrentUserProduct:=ListAllProducts.Items[i];
    CurrentUserProduct.Copy(CurrentUserProduct2);
    ListHelpProducts.Add(CurrentUserProduct2);
  end;
  // End Copy ListAllComponents to ListHelpProducts

  // hulpstuk
  for i:=0 to (ListHelpProducts.Count-1) do
  product[i+1]:=ListHelpProducts.Items[i];
  //

  for i:=0 to ((ListAllProducts.Count)-1) do
  begin
    CurrentUserProduct:=ListAllProducts.Items[i];
    CurrentUserProduct.Ids_copies[1]:=CurrentUserProduct.Id;
  end;

  for i:=0 to (ListHelpProducts.Count-1) do
  begin
    CurrentUserProduct:=ListHelpProducts.Items[i];
    CurrentUserProduct.id_user:=CurrentUserProduct.Id;
  end;

  // Check if Multiple Sources present
  // If Multiple Sources >> Change ListHelpProducts.

  MultiSources:=false;
  for i:=0 to (ListHelpProducts.Count-1) do
  begin
    CurrentUserProduct:=ListHelpProducts.Items[i];
    if CurrentUserProduct.NumSource>1 then MultiSources:=true;
  end;

 // if MultiSources then
 // MSChangeHelpProducts(ListHelpProducts);    // Change ListHelpProducts
 // if no MultiSources then no change in ListHelpProducts.


  // Translate ListHelpProducts with products of type TUserproduct to
  // a list (ListPlanningsProducts) with products of type TPlanningsProduct
  Invalidate;
  ListPlanningsProducts.Clear();
  for i:=0 to (ListHelpProducts.Count-1) do
  begin
    //CurrentUserProduct:=TUserProduct.Create;
    CurrentUserProduct:=ListHelpProducts.Items[i];
    CurrentPlanningsProduct:=TPlanningsProduct.Create;
    //translate user to planning
    //unchanged elements
    CurrentPlanningsProduct.Name:=CurrentUserProduct.Name;
    CurrentPlanningsProduct.id:=CurrentUserProduct.id;
    CurrentPlanningsProduct.ProductType:=CurrentUserProduct.ProductType;
    CurrentPlanningsProduct.RLIP:=CurrentUserProduct.RLIP;
    CurrentPlanningsProduct.value:=CurrentUserProduct.value;
    CurrentPlanningsProduct.picture:=CurrentUserProduct.Picture;
    CurrentPlanningsProduct.arrows:=CurrentUserProduct.arrows;
    CurrentPlanningsProduct.stocknorm:=CurrentUserProduct.Stocknorm;
    //Y.intree:=Intree;
    CurrentPlanningsProduct.OHS:=CurrentUserProduct.OHS;
    CurrentPlanningsProduct.Total_RestPipeline:=0; // no user rest_pipeline CurrentUserProduct.Total_RestPipeline;
    CurrentPlanningsProduct.Demand:=CurrentUserProduct.Demand;
    CurrentPlanningsProduct.PlannedOnHand:=CurrentUserProduct.PlannedOnHand;
    CurrentPlanningsProduct.id_user:=CurrentUserProduct.id_user;
    //BOM information
    CurrentPlanningsProduct.NumParents:=CurrentUserProduct.NumParents;
    CurrentPlanningsProduct.Multiplicity_Parent:=CurrentUserProduct.Multiplicity_Parent;
    CurrentPlanningsProduct.Component_id_parent:=CurrentUserProduct.Component_id_Parent;
    CurrentPlanningsProduct.NumChilds:=CurrentUserProduct.NumChilds;
    CurrentPlanningsProduct.Multiplicity_child:=CurrentUserProduct.Multiplicity_child;
    CurrentPlanningsProduct.Component_id_Child:=CurrentUserProduct.Component_id_child;

    //changed elements
    CurrentPlanningsProduct.leadtime:=CurrentUserProduct.User_Leadtime[1];
    CurrentPlanningsProduct.CompSet:=CurrentUserProduct.User_CompSet[1];
    CurrentPlanningsProduct.Yield:=CurrentUserProduct.Yield[1];
    for k:=0 to MaxHorizon do
    begin
      CurrentPlanningsProduct.RestPipeline[k]:=0;// no user rest pipeline CurrentUserProduct.User_RestPipeline[1,k];
      CurrentPlanningsProduct.Pipeline[k]:=CurrentUserProduct.User_Pipeline[1,k];
      CurrentPlanningsProduct.PlannedReceipts[k]:=CurrentUserProduct.User_PlannedReceipts[1,k];
      CurrentPlanningsProduct.PlannedOrders[k]:=CurrentUserProduct.User_PlannedOrders[1,k];
    end;

    //elements of TUserProduct, but not in TPlanningsProduct:

    ListPlanningsProducts.Add(CurrentPlanningsProduct);
  end;

  //hulpstuk
  //Fill product arrays 1 and 2;
  for i:=0 to (ListPlanningsProducts.Count-1) do
  product2[i+1]:=ListPlanningsProducts.Items[i];

  for i:=0 to (ListHelpProducts.Count-1) do
  product[i+1]:=ListHelpProducts.Items[i];
  //hulpstuk

  //Invalidate;

  // Build Bill of Material (BOM)

  for i:=1 to MaxItems do
  for j:=1 to Maxitems do
  BOM[i,j]:=0;


  for i:=0 to (ListPlanningsProducts.Count-1) do
  begin
    CurrentPlanningsProduct:=ListPlanningsProducts.Items[i];
    for j:=1 to (CurrentPlanningsProduct.NumParents) do
    BOM[CurrentPlanningsProduct.Component_id_parent[j], CurrentPlanningsProduct.id]:=
    CurrentPlanningsProduct.Multiplicity_Parent[CurrentPlanningsProduct.Component_id_parent[j]];
  end;
  // end build BOM

  //test stukje om te kijken of de planned order goed gekopieerd worden

  for i:=0 to (ListPlanningsProducts.Count-1) do
  begin
    CurrentPlanningsProduct:=ListPlanningsProducts.Items[i];
    for k:=1 to Horizon do
    begin
      CurrentPlanningsProduct.PlannedOrders[k]:=100;
      if (k+CurrentPlanningsProduct.Leadtime)<=Horizon then
      CurrentPlanningsProduct.PlannedReceipts[k+CurrentPlanningsProduct.Leadtime]:=100;
    end;
  end;

  for i:=0 to (ListPlanningsProducts.Count-1) do
  product2[i+1]:=ListPlanningsProducts.Items[i];
  // end test

end;


procedure TForm1.PlanningtoUser1Click(Sender: TObject);

var i,j,k: integer;
    CurrentUserProduct, CurrentUserProduct2: TUserProduct;
    CurrentPlanningsProduct: TPlanningsProduct;
    found, multisources: Boolean;

begin

  // Planning to Help
  for i:=0 to (ListPlanningsProducts.Count-1) do
  begin
    found:=false;
    CurrentPlanningsProduct:= ListPlanningsProducts.Items[i];
    for j:=0 to (ListHelpProducts.Count-1) DO
    begin
      if (found=false) then
      begin
        CurrentUserProduct:=ListHelpProducts.Items[j];
        if (CurrentPlanningsProduct.id = CurrentUserProduct.id) then
        begin
          for k:=1 to MaxHorizon do
          begin
            CurrentUserProduct.User_PlannedOrders[1,k] := CurrentPlanningsProduct.PlannedOrders[k];
            CurrentUserProduct.User_PlannedReceipts[1,k] := CurrentPlanningsProduct.PlannedReceipts[k];
           // CurrentUserProduct.User
          end;
        end;
      end;
     end;
  end;

  // hulpstuk
  for i:=0 to (ListHelpProducts.Count-1) do
  product[i+1]:=ListHelpProducts.Items[i];
  //

  // translate ListHelpProducts to ListAllProducts, in case no Multi sourcing is present.
  // in case of no multisourcing >> ListAllProducts.Count = ListHelpProducts.Count.
  // check if multisourcing by checking this phenomenen.
  // in case of no multisourcing >> copy back planned order and receipts info to ListHelpProducts.

  if (ListAllProducts.Count=ListHelpProducts.Count) then
  MultiSources := false;

  // if multisources then
  // >>>>>> procedure change ListHelpProducts >>>>>>


  // Help to User
  for i:=0 to (ListAllProducts.Count-1) do
  begin
    CurrentUserProduct:=ListAllProducts.Items[i];
    found:=false;
    for j:=0 to (ListHelpProducts.Count-1) do
    begin
    if (found=false) then
      begin
        CurrentUserProduct2:=ListHelpProducts.Items[j];
        if ((CurrentUserProduct.id = CurrentUserProduct2.id_user) AND (found=false)) then
        begin
          for k:=1 to MaxHorizon do
          begin
          CurrentUserProduct.User_PlannedOrders[1,k] := CurrentUserProduct2.User_PlannedOrders[1,k];
          CurrentUserProduct.User_PlannedReceipts[1,k] := CurrentUserProduct2.User_PlannedReceipts[1,k];
          end;
          found:=true;
        end;
      end;
    end;
  end;

  // hulpstuk
  for i:=0 to (ListAllProducts.Count-1) do
  product[i+1]:=ListAllProducts.Items[i];
  //




end;


procedure TForm1.Save1Click(Sender: TObject);
var
 indata    : TextFile;
 i,j,k,l,id, multiplicity_parent : integer;
 CurrentUserProduct, CurrentParent: TUserProduct;
 tab: char;
 x,y: integer;
 source_found, parent_found: boolean;
 set_ids_in_routing: set of 1..255;
 name: string;


begin
 // ChanceEditsInput(Sender);
  if SaveDialog1.Execute then
  begin
    Screen.Cursor:=crHourglass;
    AssignFile(indata, SaveDialog1.FileName);
    rewrite(indata);
    // General info of the supply chain
    writeln(indata,'----------------------------------------------------');
    writeln(indata,'1)  General info of the supply chain');
    writeln(indata,'----------------------------------------------------');
    writeln(indata,CurrentPeriod);
    writeln(indata,Horizon);
    // General info of the items
    writeln(indata,'----------------------------------------------------');
    writeln(indata,'2)  General info of the items');
    writeln(indata,'----------------------------------------------------');
    tab:= #9;
    for i := 0 to (ListAllProducts.Count-1) do
    begin
      CurrentUserProduct:=ListAllProducts.Items[i];
      x:=CurrentUserProduct.Picture.left;
      y:=CurrentUserProduct.Picture.top;
      writeln(indata,CurrentUserProduct.Name
                    ,tab
                    ,Id_DB[(CurrentUserProduct.id)]
                    ,tab
                    ,CurrentUserProduct.RLIP:2:2
                    ,tab
                    ,CurrentUserProduct.Value:7:0
                    ,tab
                    ,CurrentUserProduct.ProductType
                    ,tab
                    ,CurrentUserProduct.Stocknorm:5:0
                    ,tab
                    ,x
                    ,tab
                    ,y
                    ,tab)
    end;

    writeln(indata, 'last');

    // Routing Information
    writeln(indata,'----------------------------------------------------');
    writeln(indata,'3)  Routing Information');
    writeln(indata,'----------------------------------------------------');

    for i := 0 to (ListAllProducts.Count-1) do
    begin
      CurrentUserProduct:=ListAllProducts.Items[ i];
      if CurrentUserProduct.ProductType <> 0 then   // No begin Component
      begin
      for j:=1 to (CurrentUserProduct.NumParents) do
      begin
        parent_found:=false;
        for k:=0 to (ListAllProducts.Count-1) do
        if (parent_found=false) then
        begin
          CurrentParent:=ListAllProducts.Items[k];
          if (CurrentParent.id=CurrentUserProduct.Component_id_parent[j]) then
          begin
            source_found:=false;
            for l:=0 to CurrentUserProduct.NumSource do
            begin
              if (CurrentParent.id in CurrentUserProduct.id_components_in_source[l]) then
              begin
                source_found:=true;
                writeln(indata,CurrentUserProduct.Name
                              ,tab
                              ,id_DB[(CurrentUserProduct.id)]
                              ,tab
                              ,CurrentParent.Name
                              ,tab
                              ,CurrentUserProduct.Location_of_source[l]
                              ,tab
                              ,id_DB[(CurrentParent.id)]
                              ,tab
                              ,CurrentUserProduct.Multiplicity_parent[CurrentParent.id]
                              ,tab
                              ,CurrentUserProduct.Component_nr_Parent[j]
                              ,tab
                              ,CurrentUserProduct.User_Leadtime[l]
                              ,tab
                              ,CurrentUserProduct.Yield[l]:1:2
                              )

              end;
            end;
          end;
        end;
      end;
      end
      else
      begin
        name:='dummy_item_at_external_source';
        id:=0;
        multiplicity_parent:=1;
        writeln(indata,CurrentUserProduct.Name
                      ,tab
                      ,id_DB[(CurrentUserProduct.id)]
                      ,tab
                      ,name
                      ,tab
                      ,CurrentUserProduct.Location_of_source[1]
                      ,tab
                      ,id
                      ,tab
                      ,multiplicity_parent
                      ,tab
                      ,CurrentUserProduct.Component_nr_Parent[1]
                      ,tab
                      ,CurrentUserProduct.User_Leadtime[1]
                      ,tab
                      ,CurrentUserProduct.Yield[1]:1:2
                )
      end;
    end;
    writeln(indata, 'last');
    // Demand Forecast
    writeln(indata,'----------------------------------------------------');
    writeln(indata,'4)  Demand Forecast');
    writeln(indata,'----------------------------------------------------');

    for i:=0 to (ListEndProducts.Count-1) do
    begin
      CurrentUserProduct:=ListEndProducts.Items[i];
      write(indata,CurrentUserProduct.Name
                  ,tab
                  ,id_DB[(CurrentUserProduct.id)]
                  ,tab
                  ) ;
      for j:=1 to Horizon do
      write(indata, CurrentUserProduct.Demand[j]:8:0);
      writeln(indata);
    end;

    // WIP and Transit information (pipeline)
    writeln(indata,'----------------------------------------------------');
    writeln(indata,'5)  WIP and Transit information (pipeline)');
    writeln(indata,'----------------------------------------------------');

    for i:=0 to (ListAllProducts.Count-1) do
    begin
      CurrentUserProduct:=ListAllProducts.Items[i];
      for j:=1 to CurrentUserProduct.NumSource do
      begin
         write(indata,CurrentUserProduct.Name
                     ,tab
                     ,id_DB[(CurrentUserProduct.id)]
                     ,tab
                     ,CurrentUserProduct.Location_of_source[j]
                     ,tab
               );
         for k:=1 to (CurrentUserProduct.User_Leadtime[j]) do
         write(indata, CurrentUserProduct.User_Pipeline[j, k]:8:0);
         writeln(indata);
      end;
    end;
    writeln(indata, 'last');
    // On Hand Stock
    writeln(indata,'----------------------------------------------------');
    writeln(indata,'6)  On Hand Stock');
    writeln(indata,'----------------------------------------------------');

    for i:=0 to (ListAllProducts.Count-1) do
    begin
      CurrentUserProduct:=ListAllProducts.Items[i];
      writeln(indata,CurrentUserProduct.Name
                    ,tab
                    ,id_DB[(CurrentUserProduct.id)]
                    ,tab
                    ,CurrentUserProduct.OHS:8:0
              );
    end;

    // Production/delivery plan
    writeln(indata,'----------------------------------------------------');
    writeln(indata,'7)  Production/delivery plan');
    writeln(indata,'----------------------------------------------------');

   for i:=0 to (ListAllProducts.Count-1) do
    begin
      CurrentUserProduct:=ListAllProducts.Items[i];
      for j:=1 to CurrentUserProduct.NumSource do
      begin
         write(indata,CurrentUserProduct.Name
                     ,tab
                     ,id_DB[(CurrentUserProduct.id)]
                     ,tab
                     ,CurrentUserProduct.Location_of_source[j]
                     ,tab
               );
         for k:=1 to (Horizon) do
         write(indata, CurrentUserProduct.User_PlannedOrders[j, k]:8:0);
         writeln(indata);
      end;
    end;
    writeln(indata, 'last');
    writeln(indata,'====================================================');
    writeln(indata,'                 Information last week ');
    writeln(indata,'====================================================');
    writeln(indata,'----------------------------------------------------');
    writeln(indata,'8) Demand forecast (last week)');
    writeln(indata,'----------------------------------------------------');

    for i:=0 to (ListEndProducts.Count-1) do
    begin
      CurrentUserProduct:=ListEndProducts.Items[i];
      write(indata,CurrentUserProduct.Name
                  ,tab
                  ,id_DB[(CurrentUserProduct.id)]
                  ,tab
                  ) ;
      for j:=1 to Horizon do
      write(indata, CurrentUserProduct.Demand_last_week[j]:8:0);
      writeln(indata);
    end;

    // WIP and Transit information (pipeline) last week
    writeln(indata,'----------------------------------------------------');
    writeln(indata,'9)  WIP and Transit info (last week)');
    writeln(indata,'----------------------------------------------------');

    for i:=0 to (ListAllProducts.Count-1) do
    begin
      CurrentUserProduct:=ListAllProducts.Items[i];
      for j:=1 to CurrentUserProduct.NumSource do
      begin
         write(indata,CurrentUserProduct.Name
                     ,tab
                     ,id_DB[(CurrentUserProduct.id)]
                     ,tab
                     ,CurrentUserProduct.Location_of_source[j]
                     ,tab
               );
         for k:=1 to (CurrentUserProduct.User_Leadtime[j]) do
         write(indata, CurrentUserProduct.User_Pipeline_last_week[j, k]:8:0);
         writeln(indata);
      end;
    end;
    writeln(indata, 'last');
    // On Hand Stock last week
    writeln(indata,'----------------------------------------------------');
    writeln(indata,'10)  On Hand Stock (last week)');
    writeln(indata,'----------------------------------------------------');

    for i:=0 to (ListAllProducts.Count-1) do
    begin
      CurrentUserProduct:=ListAllProducts.Items[i];
      writeln(indata,CurrentUserProduct.Name
                    ,tab
                    ,id_DB[(CurrentUserProduct.id)]
                    ,tab
                    ,CurrentUserProduct.OHS_last_week:8:0
              );
    end;

    // Production/delivery plan last week
    writeln(indata,'----------------------------------------------------');
    writeln(indata,'11)  Production/delivery plan (last week)');
    writeln(indata,'----------------------------------------------------');

    for i:=0 to (ListAllProducts.Count-1) do
    begin
      CurrentUserProduct:=ListAllProducts.Items[i];
      for j:=1 to CurrentUserProduct.NumSource do
      begin
         write(indata,CurrentUserProduct.Name
                     ,tab
                     ,id_DB[(CurrentUserProduct.id)]
                     ,tab
                     ,CurrentUserProduct.Location_of_source[j]
                     ,tab
               );
         for k:=1 to (Horizon) do
         write(indata, CurrentUserProduct.User_PlannedOrders_last_week[j, k]:8:0);
         writeln(indata);
      end;
    end;
    writeln(indata, 'last');
    CloseFile(indata);
    Screen.Cursor:=crDefault;

  end;
end;
 
end.
