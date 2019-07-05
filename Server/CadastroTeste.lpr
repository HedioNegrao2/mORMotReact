program CadastroTeste;

{$mode objfpc}{$H+}

uses
  {$ifdef Linux}
  cthreads,
  {$endif}
  Interfaces, // this includes the LCL widgetset
  mORMot,
  mORMotSQLite3, SynSQLite3Static,
  Forms, zcomponent, Principal, DAO, SynCrtSock
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

