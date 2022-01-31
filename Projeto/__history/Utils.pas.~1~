unit FAG.Utils;

interface

const
  KEY: String = 'AOISIOD90AS8DASA9SDAS09DAS092123123ASD';

function StrToSQL(caracter: String): String;
function IntToSQL(valor: Integer): String;
function VirgulaPorPonto(Vlr: string): string;
function DateTimeToSQL(DataTime: TDateTime): String;
function DateToSQL(DataTime: TDateTime): String;
function CryptBD(password: String): String;
function DecryptBD(password: String): String;
function getLastID: String;

implementation

uses
  System.SysUtils, FireDAC.Comp.Client, FAG.DataModule.Conexao;

function StrToSQL(caracter: String): String;
begin
  if caracter <> '' then
    Result := #39 + caracter + #39
  else
    Result := 'NULL';
end;

function IntToSQL(valor: Integer): String;
begin
  if valor <> 0 then
    Result := FormatFloat('0', valor)
  else
    Result := 'NULL';
end;

function VirgulaPorPonto(Vlr: string): string;
var
  I: Integer;
  Str: string;
begin
  Str := Vlr;

  if (Str = '') then
    Result := '0'
  else
  begin
    if Pos(',', Str) > 0 then
    begin
      for I := 1 to 2 do
        if Pos('.', Str) > 0 then
          Delete(Str, Pos('.', Str), 1);

      if Pos(',', Str) > 0 then
        Str[Pos(',', Str)] := '.';
      Result := Str;
    end
    else
      Result := Str;
  end;
end;

function DateTimeToSQL(DataTime: TDateTime): String;
begin
  Result := 'NULL';

  if DataTime <> 0 then
  begin
    Result := #39 + FormatDateTime('yyyy-mm-dd hh:nn:ss', DataTime) + #39
  end;

end;

function DateToSQL(DataTime: TDateTime): String;
begin
  Result := 'NULL';

  if DataTime <> 0 then
  begin
    Result := #39 + FormatDateTime('yyyy-mm-dd', DataTime) + #39
  end;

end;

function CryptBD(password: String): String;
var
  newPassword: String;
begin
  if Trim(password) = '' then
  begin
    Result := 'NULL';
    Exit;
  end;

  newPassword := 'AES_ENCRYPT(' + QuotedStr(password) + ', ' +
    QuotedStr(KEY) + ')';
  Result := newPassword;
end;

function DecryptBD(password: String): String;
var
  newPassword: String;
begin
  if Trim(password) = '' then
  begin
    Result := 'NULL';
    Exit;
  end;

  newPassword := 'AES_DECRYPT(' + QuotedStr(password) + ', ' +
    QuotedStr(KEY) + ')';
  Result := newPassword;
end;

function getLastID: String;
var
  tmp: TFDMemTable;
begin
  tmp := TFDMemTable.Create(nil);
  try
    DataModuleConexao.ExecSQL('SELECT (SELECT LAST_INSERT_ID()) AS id', tmp);
    Result := tmp.FieldByName('id').AsString;
  finally
    FreeAndNil(tmp);
  end;
end;

function EncryptSTR(const InString: string;
  StartKey, MultKey, AddKey: Integer): string;
var
  I: Byte;
begin
  Result :=  '\';
  for I := 1 to Length(InString) do
  begin
    Result := Result + CHAR(Byte(InString[I]) xor (StartKey));
    StartKey := (Byte(Result[I]) + StartKey) * MultKey + AddKey;
  end;
end;

function DecryptSTR(const InString: string;
  StartKey, MultKey, AddKey: Integer): string;

var
  I: Byte;
begin
  Result :=  '\';
  for I := 1 to Length(InString) do
  begin
    Result := Result + CHAR(Byte(InString[I]) xor (StartKey));
    StartKey := (Byte(InString[I]) + StartKey) * MultKey + AddKey;
  end;
end;

end.
