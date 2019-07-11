unit DAO;

{$mode objfpc}{$H+}

interface

uses
  SynCommons,
  mORMot;


type

 TSQLGrupo = class(TSQLRecord)
  private
   FCodigo: RawUTF8;
  published
    property Codigo:RawUTF8 read FCodigo write FCodigo;
  end;


  TSQLProduto = class(TSQLRecord)
  private
   FCodigo: RawUTF8;
   FDescricao: RawUTF8;
   FGrupo: TSQLGrupo;
  published
    property Grupo: TSQLGrupo read FGrupo write FGrupo;
    property Codigo:RawUTF8 read FCodigo write FCodigo;
    property Descricao: RawUTF8 read FDescricao write FDescricao;

  end;


implementation

end.

