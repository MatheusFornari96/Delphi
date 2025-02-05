unit consPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.Mask,
  RxToolEdit, RxCurrEdit;

type
  TForm_consultaPedidos = class(TForm)
    DBGrid1: TDBGrid;
    DataSource_Pedidos: TDataSource;
    BitBtn_atualizar: TBitBtn;
    BitBtn_Sair: TBitBtn;
    panel1: TPanel;
    FDQuery_Pedidos: TFDQuery;
    Splitter1: TSplitter;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    FDQuery_PedidosItens: TFDQuery;
    DataSource_PedidosItens: TDataSource;
    FDQuery_PedidosItensPedItm_ID: TSmallintField;
    FDQuery_PedidosItensPed_Numero: TSmallintField;
    FDQuery_PedidosItensPro_Descricao: TStringField;
    FDQuery_PedidosItensPro_Codigo: TIntegerField;
    FDQuery_PedidosItensPedItm_PercDesc: TFloatField;
    FDQuery_PedidosItensPedItm_Qtde: TFloatField;
    FDQuery_PedidosItensPro_CstVenda: TFloatField;
    FDQuery_PedidosItensPro_Liquido: TFloatField;
    FDQuery_PedidosItensPedItm_Status: TStringField;
    FDQuery_Pedidosped_numero: TSmallintField;
    FDQuery_Pedidoscli_nome: TStringField;
    FDQuery_PedidosCli_Cidade: TStringField;
    FDQuery_PedidosCli_Uf: TStringField;
    FDQuery_PedidosVlr_Total: TFloatField;
    FDQuery_PedidosPed_Situacao: TStringField;
    Panel3: TPanel;
    Label_pedido: TLabel;
    ComboBox_Sit: TComboBox;
    Label_situacao: TLabel;
    Edit_cidade: TEdit;
    Label1: TLabel;
    Label_UF: TLabel;
    Edit_cliNome: TEdit;
    BitBtn_consultaCli: TBitBtn;
    Edit_cliCod: TEdit;
    Label_dadosCliente: TLabel;
    Edit_estado: TEdit;
    Edit_pedNum: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn_atualizarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn_SairClick(Sender: TObject);
    procedure BitBtn_consultaCliClick(Sender: TObject);
    procedure Edit_cliCodExit(Sender: TObject);
    procedure Edit_cliCodKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_pedNumKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    SQL_Consulta: String;
    SQLPedidos : String;
    SQLPedidoItens : String;
    procedure loadTela(id: string);
    function existe_cliente(codigo: string): Boolean;
  public
    { Public declarations }
  end;

var
  Form_consultaPedidos: TForm_consultaPedidos;

implementation

uses
  udmConexao, pesCliente;

{$R *.dfm}

function StrToSQL(caracter: String): String;
begin
  if caracter <> '' then
    Result := #39 + caracter + #39
  else
    Result := 'NULL';
end;

procedure TForm_consultaPedidos.loadTela(id: string);
var
  carrega: TFDQuery;
begin
  carrega := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL('SELECT Cli_Codigo, Cli_Nome As Nome, Cli_Cpf As Doc, Cli_Cidade As Cidade, Cli_Uf As Estado FROM clientes WHERE Cli_Codigo = '
      + id, carrega);
    Edit_cliCod.Text := carrega.FieldByName('Cli_Codigo').AsString;
    Edit_cliNome.Text := carrega.FieldByName('Nome').AsString;
  finally
    FreeAndNil(carrega);
  end;
end;

procedure TForm_consultaPedidos.BitBtn_atualizarClick(Sender: TObject);
begin
SQLPedidos :=' SELECT P.ped_numero ,C.cli_nome,C.Cli_Cidade,C.Cli_Uf,'+
  ' cast(Sum(P.ped_vlrfrete + (( ( PDI.peditm_qtde * PRO.pro_cstvenda ) - ((PDI.peditm_qtde*PRO.pro_cstvenda)*(PDI.peditm_percdesc/100))))) as float) AS Vlr_Total, P.Ped_Situacao'+
  ' FROM pedidos P INNER JOIN clientes C ON C.cli_codigo = P.cli_codigo'+
  ' INNER JOIN pedidos_itens PDI ON PDI.ped_numero = P.ped_numero'+
  ' INNER JOIN produtos PRO ON PDI.pro_codigo = PRO.pro_codigo'+
  ' WHERE P.ped_numero > 0 ';

  case ComboBox_sit.ItemIndex of
  1: SQLPedidos :=  SQLPedidos +' AND P.Ped_Situacao = '+StrToSQL('Pendente');
  2: SQLPedidos :=  SQLPedidos +' AND P.Ped_Situacao = '+StrToSQL('Faturado');
  3: SQLPedidos :=  SQLPedidos +' AND P.Ped_Situacao = '+StrToSQL('Cancelado');
  end;

  if Edit_cliCod.Text <> '' then
  SQLPedidos :=  SQLPedidos +' AND C.Cli_Codigo = '+Edit_cliCod.Text;

  if Edit_cidade.Text <> '' then
  SQLPedidos :=  SQLPedidos +' AND C.Cli_Cidade LIKE '+'''%' + Edit_cidade.Text + '%''';

  if Edit_estado.Text <> '' then
  SQLPedidos :=  SQLPedidos +' AND C.Cli_Uf LIKE '+'''%' + Edit_estado.Text + '%''';

  if Edit_pedNum.Text <> '' then
  SQLPedidos :=  SQLPedidos +' AND P.ped_numero = '+Edit_pedNum.Text;

  SQLPedidos :=  SQLPedidos+' GROUP  BY P.ped_numero, C.cli_nome, C.Cli_Cidade, C.Cli_Uf, P.Ped_Situacao ORDER BY P.ped_numero DESC';

 dmConexao.ExecSQL(SQLPedidos,FDQuery_Pedidos);
 dmConexao.ExecSQL(SQLPedidoItens, FDQuery_PedidosItens);
end;

procedure TForm_consultaPedidos.BitBtn_consultaCliClick(Sender: TObject);
begin
  Form_pesCli := TForm_pesCli.Create(Application);
  try
    if Form_pesCli.ShowModal = mrOk then
      loadTela(Form_pesCli.FDQuery1.FieldByName('Cli_Codigo').AsString);
  finally
    FreeAndNil(Form_pesCli);
  end;
end;

procedure TForm_consultaPedidos.BitBtn_SairClick(Sender: TObject);
begin
  Form_consultaPedidos.Close;
end;

function TForm_consultaPedidos.existe_cliente(codigo: string): Boolean;
var
  excist: TFDQuery;
begin
  excist := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL
      ('SELECT * FROM clientes WHERE Cli_Codigo =  ' +
      StrToSQL(codigo), excist);
    Result := not excist.IsEmpty;
  finally
    FreeAndNil(excist);
  end;
end;

procedure TForm_consultaPedidos.Edit_cliCodExit(Sender: TObject);
var
  carrega: TFDQuery;
  sql: String;
begin
  carrega := TFDQuery.Create(Self);
  if Edit_cliCod.Text <> '' then
  if existe_cliente(Edit_cliCod.Text)then
  begin
  try
    sql := 'SELECT Cli_Codigo, Cli_Nome, Cli_Cpf, Cli_Cidade, Cli_Uf FROM clientes WHERE Cli_Codigo = '+Edit_cliCod.Text;
    dmConexao.ExecSQL(sql, carrega);

    Edit_cliNome.Text := carrega.FieldByName('Cli_Nome').AsString;
    finally
    FreeAndNil(carrega);
  end;
  end else
  begin
  ShowMessage('Cliente n�o encontrado.');
  Edit_cliCod.Clear;
  Edit_cliNome.Clear;
  Edit_cliCod.SetFocus;
  end;
end;

procedure TForm_consultaPedidos.Edit_cliCodKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'..'9',#8]) then Abort;
end;

procedure TForm_consultaPedidos.Edit_pedNumKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'..'9',#8]) then Abort;
end;

procedure TForm_consultaPedidos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := CaFree;
  Release;
  Form_consultaPedidos := nil;
end;

procedure TForm_consultaPedidos.FormCreate(Sender: TObject);
begin
  SQLPedidoItens := 'SELECT cast(PedItm_ID as integer) AS PedItm_ID, PDI.Ped_Numero, cast(PRO.Pro_Descricao as varchar) AS Pro_Descricao ,'+
  ' cast(PDI.Pro_Codigo as integer) AS Pro_Codigo ,cast(PedItm_PercDesc as float) AS PedItm_PercDesc ,cast(PedItm_Qtde as float) AS PedItm_Qtde,'+
  ' cast(PRO.Pro_CstVenda as float) AS Pro_CstVenda'+
  ' ,cast(ROUND(SUM(((PDI.PedItm_Qtde*PRO.Pro_CstVenda)-((PDI.PedItm_Qtde*PRO.Pro_CstVenda)*(PDI.PedItm_PercDesc/100)))),2)as float) AS Pro_Liquido'+
  ' ,cast(PedItm_Status as varchar) AS PedItm_Status FROM pedidos_itens PDI INNER JOIN Pedidos P ON P.Ped_Numero = PDI.Ped_Numero INNER JOIN produtos PRO'+
  ' ON PRO.Pro_Codigo = PDI.Pro_Codigo INNER JOIN clientes C ON C.Cli_Codigo = P.Cli_Codigo'+
  ' WHERE PDI.Ped_Numero = :ped_numero';
  SQLPedidoItens := SQLPedidoItens+' GROUP BY PedItm_ID, PDI.Ped_Numero ,PRO.Pro_Descricao ,PDI.Pro_Codigo ,PRO.Pro_CstVenda,PedItm_Qtde ,PedItm_PercDesc ,PedItm_Status';
end;

end.
