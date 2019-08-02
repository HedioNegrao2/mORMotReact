unit uAutenricacaoJWT;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,  SynCrypto, SynEcc;

type
   ICalculadora = interface(IInvokable)

     ['{9449A826-A62C-4650-9F94-E826CBD72BF6}']
     function Somar(n1,n2: integer): integer;
   end;

   { TCalculadora }

   TCalculadora = class(TInterfacedObject, ICalculadora)
     function Somar(n1,n2: integer): integer;
     function login(usuario, senha: string) : string;
   end;

implementation

{ TCalculadora }

function TCalculadora.Somar(n1, n2: integer): integer;
begin
  result := n1 +n2
end;

function TCalculadora.login(usuario, senha: string): string;
var
j : TJWTHS256;
begin
  j := TJWTHS256.Create('sec',10,[jrcIssuer,jrcExpirationTime,jrcIssuedAt,jrcJWTID],[],60);
  result := j.Compute(['http://example.com/is_root',true],'joe');
end;

end.

