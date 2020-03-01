unit AddConnection;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm2 = class(TForm)
    cbSource: TComboBox;
    cbTarget: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbSourceChange(Sender: TObject);
    procedure cbTargetChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Source : integer;
    Target : integer;
  end;

var
  Form2: TForm2;

implementation

uses MainForm;
{$R *.DFM}

procedure TForm2.FormCreate(Sender: TObject);
var
 i : integer;
begin
  Source:=1;
  with cbSource do
  begin
    clear();
    for i:=1 to Form1.NumSP do
       Items.Add(IntToStr(i)+'  '+ Form1.StockPoint[i].Name);
       ItemIndex:=0;
    end;
  Target:=1;
  with cbTarget do
  begin
    clear();
    for i:=1 to Form1.NumSP do
       Items.Add(IntToStr(i)+'  '+ Form1.StockPoint[i].Name);
       ItemIndex:=0;
    end;


end;

procedure TForm2.cbSourceChange(Sender: TObject);
var
 hulp : string;
begin
  hulp:=copy(cbSource.Text,1,2);
  if hulp[2]=' ' then hulp:=copy(hulp,1,1);
  Source:=StrToInt(hulp);
end;

procedure TForm2.cbTargetChange(Sender: TObject);
var
 hulp : string;
begin
  hulp:=copy(cbTarget.Text,1,2);
  if hulp[2]=' ' then hulp:=copy(hulp,1,1);
  Target:=StrToInt(hulp);

end;

end.
