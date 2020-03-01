program GenNetwork;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  MAP_Types in 'MAP_Types.pas',
  MAP_GeneralProcedures in 'MAP_GeneralProcedures.pas',
  MAP_UserInterfaceItems in 'MAP_UserInterfaceItems.pas' {PagesDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'MAP II';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
