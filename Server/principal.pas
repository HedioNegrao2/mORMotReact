unit Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ZConnection,
  mORMotSQLite3, mORMot, mORMotHttpServer, SynCommons,SynSQLite3Static,
  SynDB, SynDBZeos;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCriarBase: TButton;
    btnIniciarServidor: TButton;
    ZConnection1: TZConnection;
    procedure btnCriarBaseClick(Sender: TObject);
    procedure btnIniciarServidorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
     FModeloDados: TSQLModel;
     FBaseDados: TSQLRestServerDB;
     FServidorHTTP: TSQLHttpServer;

     procedure ConfigurarLog;
     procedure InicializarBancoDeDados;
     procedure InicializarServidorHTTP;




  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

uses
  DAO;

procedure TForm1.btnIniciarServidorClick(Sender: TObject);
begin
 InicializarServidorHTTP;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
//  fConnection: TSQLDBZEOSConnectionProperties;
  iRows: ISQLDBRows;
  Row: Variant;
  intRowCount: integer;
  PropsPostgreSQL : TSQLDBZEOSConnectionProperties;
begin
  PropsPostgreSQL := TSQLDBZEOSConnectionProperties.Create(
   TSQLDBZEOSConnectionProperties.URI(dPostgreSQL,'localhost:15432'),
   'momot','postgres','Postgres2019!');

 {

 Props := TOleDBMSSQL2005ConnectionProperties.Create('.\SQLEXPRESS', 'TestDatabase', 'UserName', 'Password');
 Model := TSQLModel.Create([TMovie, TBook]);
VirtualTableExternalRegister(Model, [TMovie, TBook], Props);
 // Usual connection method
  //fConnection := TSQLDBZEOSConnectionProperties.Create('postgres', 'sakila dvdrental', 'postgres', 'password');
  // URI method
  fConnection := TSQLDBZEOSConnectionProperties.Create(TSQLDBZEOSConnectionProperties.URI(dPostgreSQL, 'localhost:5432'),
                  'sakila dvdrental', 'postgres', 'password');
  //
  try
    //
    intRowCount := 0;
    //
    iRows := fConnection.Execute(cboQueries.Text, [], @Row);
    //
    while iRows.Step do
    begin
      Inc(intRowCount);
      //
      ShowMessage('ID : ' + IntToStr(Row.Actor_id) + LineEnding +
                  'FirstName : ' + Row.First_Name + LineEnding +
                  'LastName : ' + Row.Last_Name + LineEnding +
                  'LastUpdate : ' + DateTimeToStr(Row.Last_Update));
      //
      if intRowCount = 5 then break;
    end;
  finally
    fConnection.Free;
  end;
          }
end;

procedure TForm1.btnCriarBaseClick(Sender: TObject);
begin
   ConfigurarLog;
  InicializarBancoDeDados;
end;

procedure TForm1.ConfigurarLog;
begin
  TSQLLog.Family.Level :=  [TSynLogInfo.sllTrace];
end;

procedure TForm1.InicializarBancoDeDados;
begin
    // Cria o modelo da base de dados contendo a classe/tabela
    // TSQLPessoa
 FModeloDados := TSQLModel.Create([TSQLGrupo,TSQLProduto]);
  VirtualTableExternalRegister(FModeloDados, [TSQLGrupo, TSQLProduto], Props);

 FBaseDados := TSQLRestServerDB.Create(FModeloDados, 'BasededadosSQLite.db3');
   // Atualizará o esquema da base de dados de acordo
   // com o modelo.
  FBaseDados.CreateMissingTables(0);
end;

procedure TForm1.InicializarServidorHTTP;
begin
 // TOleDBMSSQL2005ConnectionProperties;
  FServidorHTTP := TSQLHttpServer.Create('8080', [FBaseDados]);
end;

end.

