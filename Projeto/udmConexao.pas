unit udmConexao;

interface

uses
  System.SysUtils, System.Classes, Data.DBXMSSQL, Data.DB, Data.SqlExpr,
  FireDAC.Phys.MSSQLDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Comp.Client, FireDAC.Comp.UI,
  FireDAC.Comp.DataSet;

type
  TdmConexao = class(TDataModule)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDMemTable1: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
      function ExecSQL(strSQL: string; const ZQueryParam: TFDQuery = nil)
      : Boolean;
  end;

var
  dmConexao: TdmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmConexao.DataModuleCreate(Sender: TObject);
begin
  FDConnection1.DriverName := 'MSSQL';
  FDConnection1.FetchOptions.Mode := fmAll;
  FDConnection1.Connected := False;
  FDConnection1.LoginPrompt := False;
  FDConnection1.Params.Clear;
  FDConnection1.Params.Add('Server=localhost\SQLEXPRESS');
  FDConnection1.Params.Add('DriverID=MSSQL');
  FDConnection1.Params.Add('Database=TESTE_VISUALSOFTWARE');
  FDConnection1.Params.Add('Port=1433');
  FDConnection1.Params.Add('User_Name=sa');
  FDConnection1.Params.Add('Password=root');
  FDConnection1.Connected := True;

end;


function TdmConexao.ExecSQL(strSQL: string;
  const ZQueryParam: TFDQuery): Boolean;
var
  vs_SQL: String;
begin
  result := False;
  if not FDConnection1.Connected then
    Exit;
  vs_SQL := Trim(strSQL);
  try
    if ZQueryParam <> nil then
    begin
      ZQueryParam.Connection := FDConnection1;
      ZQueryParam.Close;
      ZQueryParam.SQL.Clear;
      ZQueryParam.SQL.Add(vs_SQL);
      if (pos('SELECT', Trim(UpperCase(vs_SQL))) in [1, 2]) then
        ZQueryParam.Open;
    end
    else
    begin
      FDQuery1.Connection := FDConnection1;
      FDQuery1.Close;
      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add(vs_SQL);
      FDQuery1.ExecSQL;
    end;
    result := True;
  except
    on E: Exception do
    begin
      E.Message := ' (ExecSQL):' + E.Message + #13#10 + vs_SQL;
      Raise
    end;
  end;
end;
end.
