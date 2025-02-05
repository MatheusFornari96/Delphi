unit mLanPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.Mask, RxToolEdit, RxCurrEdit, pesCliente, pesProduto,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, udmConexao,
  Datasnap.DBClient,StrUtils, mCadCliente, mCadProduto, pesPedido;

type
  TForm_mLanPedido = class(TForm)
    Panel2: TPanel;
    BitBtn_confirmar: TBitBtn;
    BitBtn_cancelar: TBitBtn;
    BitBtn_Sair: TBitBtn;
    BitBtn_pesquisar: TBitBtn;
    Panel1: TPanel;
    DBGrid: TDBGrid;
    Panel3: TPanel;
    Label_nome: TLabel;
    Label_dadosCliente: TLabel;
    Label2: TLabel;
    Edit_codigo: TEdit;
    Edit_nome: TEdit;
    BitBtn_adicionar: TBitBtn;
    BitBtn_remover: TBitBtn;
    Panel4: TPanel;
    Label_descProd: TLabel;
    Label_itemPed: TLabel;
    Label_codPro: TLabel;
    Edit_codPro: TEdit;
    Edit_descPro: TEdit;
    RxCalcEdit_quantidade: TRxCalcEdit;
    Label_quantPro: TLabel;
    BitBtn_consultaProduto: TBitBtn;
    BitBtn_consultaCli: TBitBtn;
    Label_VlrFrete: TLabel;
    Label_numPedido: TLabel;
    Edit_numPedido: TEdit;
    RxCalcEdit_frete: TRxCalcEdit;
    RxCalcEdit_total: TRxCalcEdit;
    RxCalcEdit_desconto: TRxCalcEdit;
    Label_descPro: TLabel;
    Label_itensTotal: TLabel;
    Label_SitPed: TLabel;
    ds_itens: TDataSource;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1Pro_Codigo: TSmallintField;
    ClientDataSet1Pro_Descricao: TStringField;
    ClientDataSet1PedItm_Qtde: TFloatField;
    ClientDataSet1Pro_CstVenda: TFloatField;
    ClientDataSet1PedItm_PercDesc: TFloatField;
    ClientDataSet1Pro_Liquido: TFloatField;
    ComboBox_sit: TComboBox;
    Edit_cidade: TEdit;
    Label1: TLabel;
    Edit_uf: TEdit;
    Label_UF: TLabel;
    RxCalcEdit_totalPed: TRxCalcEdit;
    Label_pedTotal: TLabel;
    procedure BitBtn_SairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn_consultaCliClick(Sender: TObject);
    procedure BitBtn_consultaProdutoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit_numPedidoExit(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure BitBtn_adicionarClick(Sender: TObject);
    procedure BitBtn_cancelarClick(Sender: TObject);
    procedure Edit_codigoExit(Sender: TObject);
    procedure Edit_codProExit(Sender: TObject);
    procedure Edit_codigoKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_codProKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_numPedidoKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn_removerClick(Sender: TObject);
    procedure BitBtn_pesquisarClick(Sender: TObject);
    procedure RxCalcEdit_totalChange(Sender: TObject);
    procedure RxCalcEdit_freteChange(Sender: TObject);
    procedure BitBtn_confirmarClick(Sender: TObject);
  private
    { Private declarations }
    procedure loadTelaProd(id: string);
    procedure loadTelaCli(id: string);
    procedure loadTelaPed(id: string);
    procedure desativaLanItens;
    procedure ativaLanItens;
    procedure AtivaCli;
    procedure DesativaCli;
    procedure CarregaItens;
    procedure CarregaParaEdicao;
    procedure Add(Pro_Codigo:Integer; Pro_Descricao:String; PedItm_Qtde,Pro_CstVenda,PedItm_PercDesc,Pro_Liquido:Extended);
    procedure Edit(Pro_Codigo:Integer; Pro_Descricao:String; PedItm_Qtde,Pro_CstVenda,PedItm_PercDesc,Pro_Liquido:Extended);
    procedure Remove;
    procedure ClearItens;
    function VirgulaPorPonto(Vlr : string) : string;
    function existe_pedido(codigo: string): Boolean;
    function existe_Itempedido(codigo, produto: String): Boolean;
    function getUltimoID: String;
    function cancelar: Boolean;
    function existe_cliente(codigo: string): Boolean;
    function validarCampos: Boolean;
    function gravar: Boolean;
  public
    { Public declarations }

  end;

var
  Form_mLanPedido: TForm_mLanPedido;

implementation

{$R *.dfm}

function TForm_mLanPedido.VirgulaPorPonto(Vlr : string) : string;
var
	i   : integer;
	Str : string;
begin
	Str := Vlr;

	if (Str = '') then
		Result := '0'
	else
	begin
		if Pos(',', Str) > 0 then
		begin
			for i := 1 to 2 do
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

function StrToSQL(caracter: String): String;
begin
  if caracter <> '' then
    Result := #39 + caracter + #39
  else
    Result := 'NULL';
end;

function TForm_mLanPedido.validarCampos: Boolean;
begin
  Result := False;
  if Edit_codigo.Text = '' then
  begin
    Application.MessageBox(PCHAR('Informe o cliente.'),
      'Aten��o, campo vazio!', MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Edit_codigo.SetFocus;
  end
  else if ClientDataSet1.IsEmpty then
  begin
    Application.MessageBox(PCHAR('Informe um item para incluir o pedido.'),
      'Aten��o, necess�rio informar um documento!', MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Edit_codPro.SetFocus;
  end
  else
  begin
    Result := True;
  end;
end;

function TForm_mLanPedido.gravar: Boolean;
var
  sql : String;
begin
  if not validarCampos then
  begin
    Result := False;
    Exit;
  end;
  begin
    if existe_pedido(Edit_numPedido.Text) then
    begin
    sql :=   'UPDATE pedidos ';

    if RxCalcEdit_frete.Text <> '' then
      sql := sql + ' SET Ped_VlrFrete = '+VirgulaPorPonto(RxCalcEdit_frete.Text)
    else
      sql := sql + ' SET Ped_VlrFrete = 0';

        case ComboBox_sit.ItemIndex of
        0: sql :=  sql +',Ped_Situacao = '+StrToSQL('Pendente');
        1: sql :=  sql +',Ped_Situacao = '+StrToSQL('Faturado');
        2: sql :=  sql +',Ped_Situacao = '+StrToSQL('Cancelado');
        end;
      sql :=  sql + ' WHERE Ped_Numero ='+Edit_numPedido.Text;
    dmConexao.ExecSQL(sql);

    dmConexao.ExecSQL('DELETE FROM pedidos_itens WHERE Ped_Numero ='+Edit_numPedido.Text);

    ClientDataSet1.First;
      while not ClientDataSet1.Eof do
      begin
        sql := (' INSERT INTO Pedidos_itens'+
        '(Ped_Numero,Pro_Codigo, PedItm_Qtde, PedItm_PercDesc,PedItm_Status)'+
        ' VALUES'+
        '('+Edit_numPedido.Text+','+VirgulaPorPonto(ClientDataSet1.FieldByName('Pro_Codigo').AsString)+','+
        VirgulaPorPonto(ClientDataSet1.FieldByName('PedItm_Qtde').AsString)+','+
        VirgulaPorPonto(ClientDataSet1.FieldByName('PedItm_PercDesc').AsString)+',''N�o'')');
        dmConexao.ExecSQL(sql);
        ClientDataSet1.Next;
      end;
    Application.MessageBox(PCHAR('Pedido alterado com sucesso.'),'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
    end
    else
    begin
      if not existe_pedido(Edit_numPedido.Text) then
      begin
      sql := ' INSERT INTO Pedidos'+
           '(Ped_Situacao, Cli_Codigo, Ped_VlrFrete)'+
      ' VALUES';

        case ComboBox_sit.ItemIndex of
        0: sql :=  sql + ' (''Pendente''';
        1: sql :=  sql + ' (''Pendente''';
        2: sql :=  sql + ' (''Cancelado''';
        end;

      sql :=  sql +' ,'+Edit_codigo.Text;

      if RxCalcEdit_frete.Text <> '' then
      sql := sql + ','+RxCalcEdit_frete.Text+')'
      else
      sql := sql + ',0)';

      dmConexao.ExecSQL(sql);
      Application.MessageBox(PCHAR('Pedido incluso com sucesso.'),
            'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
      end;

      ClientDataSet1.First;
        while not ClientDataSet1.Eof do
          begin
          if existe_Itempedido(Edit_numPedido.Text,ClientDataSet1.FieldByName('Pro_Codigo').AsString) then
          begin
          sql := 'UPDATE pedidos_itens SET '+
            ' PedItm_Qtde ='+VirgulaPorPonto(ClientDataSet1.FieldByName('PedItm_Qtde').AsString)+
            ' ,PedItm_PercDesc ='+VirgulaPorPonto(ClientDataSet1.FieldByName('Peditm_PercDesc').AsString);
            sql :=  sql + ' WHERE Ped_Numero ='+Edit_numPedido.Text+' AND Pro_Codigo='+ClientDataSet1.FieldByName('Pro_Codigo').AsString;
          dmConexao.ExecSQL(sql);
          end else
            begin
             ClientDataSet1.First;
              while not ClientDataSet1.Eof do
              begin
              sql := (' INSERT INTO Pedidos_itens'+
                   '(Ped_Numero,Pro_Codigo, PedItm_Qtde, PedItm_PercDesc,PedItm_Status)'+
              ' VALUES'+
                   '('+Edit_numPedido.Text+','+VirgulaPorPonto(ClientDataSet1.FieldByName('Pro_Codigo').AsString)+','+
                   VirgulaPorPonto(ClientDataSet1.FieldByName('PedItm_Qtde').AsString)+','+
                   VirgulaPorPonto(ClientDataSet1.FieldByName('PedItm_PercDesc').AsString)+',''N�o'')');
                dmConexao.ExecSQL(sql);
              ClientDataSet1.Next;
              end;
            end;
        ClientDataSet1.Next;
        end;
    end;
    cancelar;
  end;
end;

procedure TForm_mLanPedido.loadTelaPed(id: string);
var
  carrega: TFDQuery;
begin
  carrega := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL('SELECT * FROM pedidos P INNER JOIN Clientes C ON C.Cli_Codigo = P.Cli_Codigo INNER JOIN pedidos_itens PDS '+
      'ON PDS.Ped_Numero = P.Ped_Numero Where P.Ped_Numero = '+ id, carrega);

    Edit_numPedido.Text := carrega.FieldByName('Ped_Numero').AsString;
      case AnsiIndexStr(UpperCase(carrega.FieldByName('Ped_Situacao').AsString), ['PENDENTE', 'FATURADO','CANCELADO']) of
      0 : ComboBox_sit.ItemIndex := 0;
      1 : ComboBox_sit.ItemIndex := 1;
      2 : ComboBox_sit.ItemIndex := 2;
      else
      ComboBox_sit.ItemIndex := -1;
      end;
     Edit_codigo.Text := carrega.FieldByName('Cli_Codigo').AsString;
     Edit_nome.Text := carrega.FieldByName('Cli_Nome').AsString;
     RxCalcEdit_frete.Value := carrega.FieldByName('Ped_VlrFrete').AsFloat;

     carregaItens;
  finally
    FreeAndNil(carrega);
  end;
end;

function TForm_mLanPedido.existe_cliente(codigo: string): Boolean;
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

procedure TForm_mLanPedido.ativaLanItens;
begin
  BitBtn_adicionar.Enabled := True;
  BitBtn_consultaProduto.Enabled := True;
  BitBtn_remover.Enabled := True;
  Edit_codPro.SetFocus;
end;

procedure TForm_mLanPedido.desativaLanItens;
begin
  Edit_codPro.Clear;
  Edit_descPro.Clear;
  RxCalcEdit_quantidade.Clear;
  RxCalcEdit_desconto.Clear;
  RxCalcEdit_frete.Clear;
  //Panel4.Enabled := False;
 // BitBtn_adicionar.Enabled := False;
 // BitBtn_consultaProduto.Enabled := False;
  //BitBtn_remover.Enabled := False;
end;

procedure TForm_mLanPedido.AtivaCli;
  begin
    //panel3.Enabled := True;
    edit_nome.Clear;
    edit_codigo.Clear;
    edit_cidade.Clear;
    edit_uf.Clear;
    RxCalcEdit_frete.Clear;
    RxCalcEdit_total.Clear;
  end;

procedure TForm_mLanPedido.DesativaCli;
  begin
   // panel3.Enabled := False;
    edit_nome.Clear;
    edit_codigo.Clear;
    edit_cidade.Clear;
    edit_uf.Clear;
    RxCalcEdit_frete.Clear;
    RxCalcEdit_total.Clear;
  end;

procedure TForm_mLanPedido.ClearItens;
begin
   Edit_codPro.Clear;
   Edit_descPro.Clear;
   RxCalcEdit_quantidade.Clear;
   RxCalcEdit_desconto.Clear;
end;

procedure TForm_mLanPedido.CarregaParaEdicao;
begin
  Edit_codPro.Text := ClientDataSet1.FieldByName('Pro_Codigo').AsString;
  Edit_descPro.Text := ClientDataSet1.FieldByName('Pro_Descricao').AsString;
  RxCalcEdit_quantidade.Value := ClientDataSet1.FieldByName('PedItm_Qtde').AsExtended;
  RxCalcEdit_desconto.Value := ClientDataSet1.FieldByName('PedItm_PercDesc').AsExtended;
end;

procedure TForm_mLanPedido.DBGridDblClick(Sender: TObject);
begin
 CarregaParaEdicao;
end;

procedure TForm_mLanPedido.Add(Pro_Codigo:Integer; Pro_Descricao:String; PedItm_Qtde,Pro_CstVenda,PedItm_PercDesc,Pro_Liquido:Extended);
begin
  ClientDataSet1.Append;
  ClientDataSet1.FieldByName('Pro_Codigo').AsInteger  :=  Pro_Codigo;
  ClientDataSet1.FieldByName('Pro_Descricao').AsString := Pro_Descricao;
  ClientDataSet1.FieldByName('PedItm_Qtde').AsFloat := PedItm_Qtde;
  ClientDataSet1.FieldByName('Pro_CstVenda').AsFloat := Pro_CstVenda;
  ClientDataSet1.FieldByName('PedItm_PercDesc').AsFloat := PedItm_PercDesc;
  ClientDataSet1.FieldByName('Pro_Liquido').AsFloat := Pro_Liquido;
  ClientDataSet1.Post;
end;

procedure TForm_mLanPedido.Edit(Pro_Codigo:Integer; Pro_Descricao:String; PedItm_Qtde,Pro_CstVenda,PedItm_PercDesc,Pro_Liquido:Extended);
begin
  ClientDataSet1.Edit;
  ClientDataSet1.FieldByName('Pro_Codigo').AsInteger  :=  Pro_Codigo;
  ClientDataSet1.FieldByName('Pro_Descricao').AsString := Pro_Descricao;
  ClientDataSet1.FieldByName('PedItm_Qtde').AsFloat := PedItm_Qtde;
  ClientDataSet1.FieldByName('Pro_CstVenda').AsFloat := Pro_CstVenda;
  ClientDataSet1.FieldByName('PedItm_PercDesc').AsFloat := PedItm_PercDesc;
  ClientDataSet1.FieldByName('Pro_Liquido').AsFloat := Pro_Liquido;
  ClientDataSet1.Post;
end;

procedure TForm_mLanPedido.Remove;
begin
  ClientDataSet1.Delete;
end;

procedure TForm_mLanPedido.RxCalcEdit_freteChange(Sender: TObject);
begin
  RxCalcEdit_totalPed.Value := 0;
  RxCalcEdit_totalPed.Value := RxCalcEdit_totalPed.Value+(RxCalcEdit_frete.Value+RxCalcEdit_total.Value);
end;

procedure TForm_mLanPedido.RxCalcEdit_totalChange(Sender: TObject);
begin
  RxCalcEdit_totalPed.Value := 0;
  RxCalcEdit_totalPed.Value := RxCalcEdit_totalPed.Value+(RxCalcEdit_frete.Value+RxCalcEdit_total.Value);
end;

function TForm_mLanPedido.cancelar: Boolean;
begin
  Edit_codigo.Clear;
  Edit_nome.Clear;
  Edit_cidade.Clear;
  Edit_uf.Clear;
  Edit_codPro.Clear;
  Edit_descPro.Clear;
  Edit_numPedido.Text := getUltimoID;
  RxCalcEdit_quantidade.Clear;
  RxCalcEdit_frete.Clear;
  RxCalcEdit_total.Clear;
  RxCalcEdit_desconto.Clear;
  ClientDataSet1.EmptyDataSet;
  ComboBox_sit.ItemIndex := -1;
end;

function TForm_mLanPedido.getUltimoID: String;
var
  existe: TFDQuery;
begin
  existe := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL
      ('SELECT COALESCE(MAX(Ped_Numero)+1, 1) AS Ped_Numero FROM pedidos', existe);
    Result := existe.FieldByName('Ped_Numero').AsString;
  finally
    FreeAndNil(existe);
  end;
end;

procedure TForm_mLanPedido.loadTelaProd(id: string);
var
  carrega: TFDQuery;
begin
  carrega := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL('SELECT Pro_Codigo, Pro_Descricao, Pro_CodBar, Pro_Unidade,Pro_CstUnitario, Pro_QtdEstoque,Pro_CstVenda FROM produtos WHERE Pro_Codigo = '
      + id, carrega);
    Edit_descPro.Text := carrega.FieldByName('Pro_Descricao').AsString;
    Edit_codPro.Text := carrega.FieldByName('Pro_Codigo').AsString;
  finally
    FreeAndNil(carrega);
  end;
end;

procedure TForm_mLanPedido.loadTelaCli(id: string);
var
  carrega: TFDQuery;
begin
  carrega := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL('SELECT Cli_Codigo, Cli_Nome As Nome, Cli_Cpf As Doc, Cli_Cidade As Cidade, Cli_Uf As Estado FROM clientes WHERE Cli_Codigo = '
      + id, carrega);
    Edit_nome.Text := carrega.FieldByName('Nome').AsString;
    Edit_codigo.Text := carrega.FieldByName('Cli_Codigo').AsString;
    Edit_cidade.Text := carrega.FieldByName('Cidade').AsString;
    Edit_uf.Text := carrega.FieldByName('Estado').AsString;
  finally
    FreeAndNil(carrega);
  end;
end;

procedure TForm_mLanPedido.BitBtn_adicionarClick(Sender: TObject);
var
  carrega: TFDQuery;
begin
  if Edit_codPro.Text <> '' then
  begin
  if RxCalcEdit_quantidade.Text <> ''  then
  begin
  RxCalcEdit_total.Value := 0;
  carrega := TFDQuery.Create(Self);
  dmConexao.ExecSQL('SELECT Pro_CstVenda FROM produtos WHERE Pro_Codigo = '+ Edit_codPro.Text, carrega);

  if ClientDataSet1.Locate('Pro_Codigo', Edit_codPro.Text, []) then
  Edit(StrToInt(Edit_codPro.Text),Edit_descPro.Text,RxCalcEdit_quantidade.Value,carrega.FieldByName('Pro_CstVenda').AsFloat,RxCalcEdit_desconto.Value,((RxCalcEdit_quantidade.Value*carrega.FieldByName('Pro_CstVenda').AsFloat)-(RxCalcEdit_desconto.Value/100)*(RxCalcEdit_quantidade.Value*carrega.FieldByName('Pro_CstVenda').AsFloat)))
  else
  Add(StrToInt(Edit_codPro.Text),Edit_descPro.Text,RxCalcEdit_quantidade.Value,carrega.FieldByName('Pro_CstVenda').AsFloat,RxCalcEdit_desconto.Value,((RxCalcEdit_quantidade.Value*carrega.FieldByName('Pro_CstVenda').AsFloat)-(RxCalcEdit_desconto.Value/100)*(RxCalcEdit_quantidade.Value*carrega.FieldByName('Pro_CstVenda').AsFloat)));

  ClientDataSet1.First;
  while not ClientDataSet1.Eof do
  begin
    RxCalcEdit_total.Value :=   RxCalcEdit_total.Value+ClientDataSet1.FieldByName('Pro_Liquido').AsFloat;
  ClientDataSet1.Next;
  end;

  ClearItens;
  end else
  begin
  ShowMessage('Informe a quantidade');
  RxCalcEdit_quantidade.SetFocus;
  end;
  end else
  begin
  ShowMessage('Informe o c�digo do produto');
  Edit_codPro.SetFocus;
  end;
end;

procedure TForm_mLanPedido.BitBtn_cancelarClick(Sender: TObject);
begin
  cancelar;
  ComboBox_sit.ItemIndex := 0;
end;

procedure TForm_mLanPedido.BitBtn_confirmarClick(Sender: TObject);
begin
 gravar;
end;

procedure TForm_mLanPedido.BitBtn_consultaCliClick(Sender: TObject);
begin
  Form_pesCli := TForm_pesCli.Create(Application);
  try
    if Form_pesCli.ShowModal = mrOk then
      loadTelaCli(Form_pesCli.FDQuery1.FieldByName('Cli_Codigo').AsString);
  finally
    FreeAndNil(Form_pesCli);
  end;
end;

procedure TForm_mLanPedido.BitBtn_consultaProdutoClick(Sender: TObject);
begin
  Form_pesProduto := TForm_pesProduto.Create(Application);
  try
    if Form_pesProduto.ShowModal = mrOk then
      loadTelaProd(Form_pesProduto.FDQuery1.FieldByName('Pro_Codigo').AsString);
  finally
    FreeAndNil(Form_pesProduto);
  end;
end;

procedure TForm_mLanPedido.BitBtn_pesquisarClick(Sender: TObject);
begin
  Form_pesPedido := TForm_pesPedido.Create(Application);
  try
    if Form_pesPedido.ShowModal = mrOk then
      loadTelaPed(Form_pesPedido.FDQuery1.FieldByName('Ped_Numero').AsString);
  finally
    FreeAndNil(Form_pesPedido);
    //ativaLanItens;
  end;
end;

procedure TForm_mLanPedido.BitBtn_removerClick(Sender: TObject);
begin
  if not ClientDataSet1.IsEmpty then
  begin
  remove;
  RxCalcEdit_total.Value := 0;

  ClientDataSet1.First;
  while not ClientDataSet1.Eof do
  begin
    RxCalcEdit_total.Value :=   RxCalcEdit_total.Value+ClientDataSet1.FieldByName('Pro_Liquido').AsFloat;
  ClientDataSet1.Next;
  end;

  //if ClientDataSet1.IsEmpty then
  //panel3.Enabled := True
  //else
 // panel3.Enabled := False;
  end else
  begin
  ShowMessage('N�o h� itens para remover.');
  end;
end;

procedure TForm_mLanPedido.BitBtn_SairClick(Sender: TObject);
begin
 Form_mLanPedido.Close;
end;



procedure TForm_mLanPedido.carregaItens;
var
  sql :String;
  carrega :TFDQuery;
begin
    carrega := TFDQuery.Create(Self);
    try
    sql :='SELECT PDI.Pro_Codigo,P.Pro_Descricao,PDI.PedItm_Qtde,P.Pro_CstVenda, SUM(PDI.PedItm_PercDesc) As PedItm_PercDesc, '+
    ' ROUND(SUM(((PDI.PedItm_Qtde*P.Pro_CstVenda)-((PDI.PedItm_Qtde*P.Pro_CstVenda)*(PDI.PedItm_PercDesc/100)))),2) AS Pro_Liquido '+
    ' FROM pedidos_itens PDI INNER JOIN produtos P ON P.Pro_Codigo = PDI.Pro_Codigo '+
    ' INNER JOIN pedidos PD ON PD.Ped_Numero = PDI.Ped_Numero WHERE PD.Ped_Numero = '+Edit_numPedido.Text+
    ' GROUP BY PDI.Pro_Codigo,P.Pro_Descricao,PDI.PedItm_Qtde,P.Pro_CstVenda,PDI.PedItm_PercDesc';
    dmConexao.ExecSQL(sql, carrega);

    ClientDataSet1.EmptyDataSet;
    RxCalcEdit_total.Clear;

    carrega.First;
    while not carrega.Eof do
    begin
      Add(carrega.FieldByName('Pro_Codigo').AsInteger,carrega.FieldByName('Pro_Descricao').AsString,
       carrega.FieldByName('PedItm_Qtde').AsFloat,carrega.FieldByName('Pro_CstVenda').AsFloat,
       carrega.FieldByName('PedItm_PercDesc').AsFloat,carrega.FieldByName('Pro_Liquido').AsFloat);
       RxCalcEdit_total.Value := RxCalcEdit_total.Value+ClientDataSet1.FieldByName('Pro_Liquido').AsFloat;
      carrega.Next
    end;
    finally
    FreeAndNil(carrega);
    end;
    //panel3.Enabled := False;
end;

procedure TForm_mLanPedido.Edit_codigoExit(Sender: TObject);
var
  carrega: TFDQuery;
  sql: String;
begin
  carrega := TFDQuery.Create(Self);
  if Edit_codigo.Text <> '' then
  if existe_cliente(Edit_codigo.Text)then
  begin
  try
    sql := 'SELECT Cli_Codigo, Cli_Nome, Cli_Cidade, Cli_Uf FROM clientes WHERE Cli_Codigo = '+Edit_codigo.Text;
    dmConexao.ExecSQL(sql, carrega);

    Edit_nome.Text := carrega.FieldByName('Cli_Nome').AsString;
    Edit_cidade.Text := carrega.FieldByName('Cli_cidade').AsString;
    Edit_Uf.Text := carrega.FieldByName('Cli_Uf').AsString;
    //ativaLanItens;
    finally
    FreeAndNil(carrega);
  end;
  end else
  begin
    Edit_codigo.Clear;
    Edit_nome.Clear;
    Edit_cidade.Clear;
    Edit_uf.Clear;
    //desativaLanItens;
    Edit_codigo.SetFocus;
    ShowMessage('Cliente n�o encontrado');
  end;
end;

procedure TForm_mLanPedido.Edit_codigoKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#8]) then Abort;
end;

procedure TForm_mLanPedido.Edit_codProExit(Sender: TObject);
var
  carrega: TFDQuery;
  sql: String;
begin
  carrega := TFDQuery.Create(Self);
  if Edit_codPro.Text <> '' then
  try
    sql := 'SELECT Pro_Codigo, Pro_Descricao FROM Produtos WHERE Pro_Codigo = '+Edit_codPro.Text;
    dmConexao.ExecSQL(sql, carrega);

    if not carrega.IsEmpty then
    begin
    Edit_descPro.Text := carrega.FieldByName('Pro_Descricao').AsString;
    end
    else begin
    Edit_codPro.Clear;
    Edit_descPro.Clear;
    Edit_codPro.SetFocus;
    ShowMessage('Produto n�o encontrado');
    end;
  finally
    FreeAndNil(carrega);
  end else
  begin
  Edit_descPro.Clear;
  RxCalcEdit_quantidade.Clear;
  RxCalcEdit_desconto.Clear;
  Edit_codPro.SetFocus;
  end;
end;

procedure TForm_mLanPedido.Edit_codProKeyPress(Sender: TObject; var Key: Char);
begin
if not (Key in ['0'..'9',#8]) then Abort;
end;

function TForm_mLanPedido.existe_pedido(codigo: string): Boolean;
var
  excist: TFDQuery;
begin
  excist := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL
      ('SELECT * FROM pedidos WHERE Ped_Numero =  ' +
      StrToSQL(codigo), excist);
    Result := not excist.IsEmpty;
  finally
    FreeAndNil(excist);
  end;
end;

function TForm_mLanPedido.existe_Itempedido(codigo, produto: String): Boolean;
var
  excist: TFDQuery;
begin
  excist := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL
      ('SELECT * FROM pedidos_itens WHERE Ped_Numero ='+StrToSQL(codigo)+
       ' AND Pro_Codigo ='+ StrToSQL(produto), excist);
    Result := not excist.IsEmpty;
  finally
    FreeAndNil(excist);
  end;
end;

procedure TForm_mLanPedido.Edit_numPedidoExit(Sender: TObject);
var
  carrega: TFDQuery;
  sql: String;
begin
  carrega := TFDQuery.Create(Self);
  if existe_pedido(Edit_numPedido.Text) then
  begin
    try
    sql := 'SELECT Ped_Numero, Ped_Situacao, P.Cli_Codigo, C.Cli_Nome, Ped_VlrFrete, C.Cli_cidade, C.Cli_uf FROM pedidos P '+
     ' INNER JOIN Clientes C ON C.Cli_Codigo = P.Cli_Codigo WHERE Ped_Numero = '+Edit_numPedido.Text;
    dmConexao.ExecSQL(sql, carrega);
    if carrega.IsEmpty then
    begin
      cancelar;
      Edit_numPedido.Text := getUltimoID;
    end else
    begin
      Edit_numPedido.Text := carrega.FieldByName('Ped_Numero').AsString;
      case AnsiIndexStr(UpperCase(carrega.FieldByName('Ped_Situacao').AsString), ['PENDENTE', 'FATURADO','CANCELADO']) of
      0 : ComboBox_sit.ItemIndex := 0;
      1 : ComboBox_sit.ItemIndex := 1;
      2 : ComboBox_sit.ItemIndex := 2;
      else
      ComboBox_sit.ItemIndex := -1;
      end;
     Edit_codigo.Text := carrega.FieldByName('Cli_Codigo').AsString;
     Edit_nome.Text := carrega.FieldByName('Cli_Nome').AsString;
     Edit_cidade.Text := carrega.FieldByName('Cli_cidade').AsString;
     Edit_uf.Text := carrega.FieldByName('Cli_uf').AsString;
     RxCalcEdit_frete.Value := carrega.FieldByName('Ped_VlrFrete').AsFloat;
     carregaItens;
     //Panel3.Enabled := False;
     //Panel4.Enabled := True;
     BitBtn_consultaProduto.Enabled := True;
     BitBtn_adicionar.Enabled := True;
     BitBtn_remover.Enabled := True;
    end;
    finally
      FreeAndNil(carrega);
    end;
  end else
  begin
  Edit_numPedido.Text := getUltimoID;
  ativaCli;
  desativaLanItens;
  ClientDataSet1.EmptyDataSet;
  ComboBox_sit.ItemIndex := 0;
  end;
end;


procedure TForm_mLanPedido.Edit_numPedidoKeyPress(Sender: TObject;
  var Key: Char);
begin
if not (Key in ['0'..'9',#8]) then Abort;
end;

procedure TForm_mLanPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CaFree;
  Release;
  Form_mLanPedido := nil;
end;

procedure TForm_mLanPedido.FormCreate(Sender: TObject);
begin
  Edit_numPedido.Text := getUltimoID;
  ComboBox_sit.ItemIndex := 0;
  //desativaLanItens;
end;

end.
