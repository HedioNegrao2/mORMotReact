unit DAO;

{$mode objfpc}{$H+}

interface

uses
  SynCommons,
  mORMot;


type

 { TSQLGrupo }

 TSQLGrupo = class(TSQLRecord)
  private
    FAtivo: Boolean;
   FCodigo: RawUTF8;
   procedure SetAtivo(AValue: Boolean);
  published
    property Codigo:RawUTF8 read FCodigo write FCodigo;
    property Ativo: Boolean read FAtivo write SetAtivo;
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

{ TSQLGrupo }

procedure TSQLGrupo.SetAtivo(AValue: Boolean);
begin
  if FAtivo=AValue then Exit;
  FAtivo:=AValue;
end;

end.

