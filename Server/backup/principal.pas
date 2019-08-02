unit Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ZConnection,
  mORMotSQLite3, mORMot, mORMotHttpServer, SynCommons,SynSQLite3Static,
  SynDB, SynDBZeos, SynOleDB, mORMotDB, Types;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCriarBase: TButton;
    btnCriarBase1: TButton;
    btnIniciarServidor: TButton;
    Button1: TButton;
    Memo1: TMemo;
    ZConnection1: TZConnection;
    procedure btnCriarBase1Click(Sender: TObject);
    procedure btnCriarBase1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure btnCriarBaseClick(Sender: TObject);
    procedure btnIniciarServidorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
     FModeloDados: TSQLModel;
     ModeloServicos:TSQLModel;
     FBaseDados: TSQLRestServerDB;
     FServidorHTTP: TSQLHttpServer;
     ServidorServicos: TSQLRestServer;


     procedure ConfigurarLog;
     procedure InicializarBancoDeDados;
     procedure InicializarServidorHTTP;
     procedure InicializarServicos;




  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

uses
  DAO,SynCrypto, SynEcc, uAutenricacaoJWT;

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
   TSQLDBZEOSConnectionProperties.URI(dPostgreSQL,'localhost:5432'),
   'budega','postgres','postgres!');

  FModeloDados := TSQLModel.Create([TSQLGrupo,TSQLProduto]);
  VirtualTableExternalRegister(FModeloDados, [TSQLGrupo, TSQLProduto], PropsPostgreSQL);
  FBaseDados := TSQLRestServerDB.Create(FModeloDados, ':memory:');

   // Atualizará o esquema da base de dados de acordo
   // com o modelo.
  FBaseDados.CreateMissingTables(0);

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
  InicializarServicos;
end;

procedure TForm1.btnCriarBase1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.btnCriarBase1Click(Sender: TObject);
var j: TJWTAbstract;
    jwt: TJWTContent;
begin
  j := TJWTHS256.Create('secret',0,[jrcSubject],[]);
  try
  j.Verify('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibm'+
    'FtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeF'+
    'ONFh7HgQ',jwt); // reference from jwt.io
  Memo1.Lines.Add((jwt.result=jwtValid).ToString());
  Memo1.Lines.Add((jwt.reg[jrcSubject]='12345678901').ToString());
  Memo1.Lines.Add((jwt.data.U['name']='John Doe').ToString());
  Memo1.Lines.Add((jwt.data.B['admin']).ToString());
 finally
  j.Free;
 end;

end;

procedure TForm1.ConfigurarLog;
begin
  TSQLLog.Family.Level :=  [TSynLogInfo.sllTrace];
end;

procedure TForm1.InicializarBancoDeDados;
var
   Props :  TOleDBMSSQL2012ConnectionProperties ;
begin
    // Cria o modelo da base de dados contendo a classe/tabela
    // TSQLPessoa
 Props := TOleDBMSSQL2012ConnectionProperties.Create(  'NEGRAO-DEV', 'mORMot', 'sa', '');
 FModeloDados := TSQLModel.Create([TSQLGrupo,TSQLProduto]);
 VirtualTableExternalRegister(FModeloDados, [TSQLGrupo, TSQLProduto], Props);
 FBaseDados := TSQLRestServerDB.Create(FModeloDados, ':memory:');
// FBaseDados := TSQLRestServerDB.Create(FModeloDados, 'mormot.db3');

   // Atualizará o esquema da base de dados de acordo
   // com o modelo.
  FBaseDados.CreateMissingTables(0);
end;

procedure TForm1.InicializarServidorHTTP;
begin
 // TOleDBMSSQL2005ConnectioçProperties;

  FServidorHTTP := TSQLHttpServer.Create('8081', [FBaseDados]);
end;

procedure TForm1.InicializarServicos;
begin
  ModeloServicos := TSQLModel.Create([],'services');
  ServidorServicos := TSQLRestServerFullMemory.Create(ModeloServicos);
  ServidorServicos.ServiceRegister(TCalculadora,[TypeInfo(ICalculadora)], sicShared);
end;

end.

