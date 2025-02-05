unit mCadProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask, RxToolEdit, RxCurrEdit, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, udmConexao, pesProduto;

type
  TForm_CadProduto = class(TForm)
    Panel1: TPanel;
    BitBtn_confirmar: TBitBtn;
    BitBtn_pesquisar: TBitBtn;
    BitBtn_cancelar: TBitBtn;
    BitBtn_voltar: TBitBtn;
    Edit_descricao: TEdit;
    Label_descricao: TLabel;
    Edit_CodBar: TEdit;
    Label_codBar: TLabel;
    Label_qtdEstoque: TLabel;
    Panel2: TPanel;
    Label_panelCustos: TLabel;
    Label_cstCompra: TLabel;
    Label_cstVenda: TLabel;
    Edit_unMedida: TEdit;
    Label1: TLabel;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    RxCalcEdit_CstCompra: TRxCalcEdit;
    RxCalcEdit_CstVenda: TRxCalcEdit;
    RxCalcEdit_qtdEstoque: TRxCalcEdit;
    Edit_codigo: TEdit;
    Label_codigo: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn_voltarClick(Sender: TObject);
    procedure Edit_codigoKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn_confirmarClick(Sender: TObject);
    procedure Edit_codigoExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn_pesquisarClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn_cancelarClick(Sender: TObject);
    procedure Edit_CodBarKeyPress(Sender: TObject; var Key: Char);
  private
    procedure loadTela(id: string);
    function getUltimoID: String;
    function excluir: Boolean;
    function gravar: Boolean;
    function VirgulaPorPonto(Vlr : string) : string;
    function cancelar: Boolean;
    function validarCampos: Boolean;
  public
    { Public declarations }
    function existe_produto(codigo: string): Boolean;
  end;

var
  Form_CadProduto: TForm_CadProduto;

implementation

{$R *.dfm}

function TForm_CadProduto.excluir: Boolean;
var
  sql : String;
  msg : Boolean;
begin
   sql := 'DELETE FROM produtos WHERE Pro_Codigo ='+Edit_codigo.text;
   if Application.MessageBox('Tem certeza que deseja excluir o registro selecionado?',
     'Confirma��o', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = IDYES then
   begin
   try
      dmConexao.ExecSQL(sql);
   except
   msg := True;
     Application.MessageBox(PCHAR('O Produto possui pedidos lan�ados.'),
     'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
   end;
   if not msg then
     Application.MessageBox(PCHAR('Cadastro excluido com sucesso.'),
     'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
   end;
  cancelar;
end;

function TForm_CadProduto.VirgulaPorPonto(Vlr : string) : string;
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

procedure TForm_CadProduto.loadTela(id: string);
var
  carrega: TFDQuery;
begin
  carrega := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL('SELECT Pro_Codigo, Pro_Descricao, Pro_CodBar, Pro_Unidade,Pro_CstUnitario, Pro_QtdEstoque,Pro_CstVenda FROM produtos WHERE Pro_Codigo = '
      + id, carrega);
    Edit_codigo.Text := carrega.FieldByName('Pro_Codigo').AsString;
    Edit_descricao.Text := carrega.FieldByName('Pro_Descricao').AsString;
    Edit_CodBar.Text := carrega.FieldByName('Pro_CodBar').AsString;
    Edit_unMedida.Text := carrega.FieldByName('Pro_Unidade').AsString;
    RxCalcEdit_CstCompra.Value := carrega.FieldByName('Pro_CstUnitario').AsFloat;
    RxCalcEdit_qtdEstoque.Value := carrega.FieldByName('Pro_QtdEstoque').AsFloat;
    RxCalcEdit_CstVenda.Value := carrega.FieldByName('Pro_CstVenda').AsFloat;
  finally
    FreeAndNil(carrega);
  end;
end;

function TForm_CadProduto.getUltimoID: String;
var
  existe: TFDQuery;
begin
  existe := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL
      ('SELECT COALESCE(MAX(Pro_Codigo)+1, 1) AS Pro_Codigo FROM produtos', existe);
    Result := existe.FieldByName('Pro_Codigo').AsString;
  finally
    FreeAndNil(existe);
  end;
end;

function TForm_CadProduto.validarCampos: Boolean;
begin
  Result := False;
    if Edit_CodBar.Text = '' then
  begin
    Application.MessageBox(PCHAR('Informe o c�digo de barras.'),
      'Aten��o, campo vazio!', MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Edit_CodBar.SetFocus;
  end
  else if Edit_descricao.Text = '' then
  begin
    Application.MessageBox(PCHAR('Informe a descri��o do produto.'),
      'Aten��o, campo vazio!', MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Edit_descricao.SetFocus;
  end
  else if Edit_unMedida.Text = '' then
  begin
    Application.MessageBox(PCHAR('Informe a unidade de medida.'),
      'Aten��o, necess�rio informar um documento!', MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Edit_unMedida.SetFocus;
  end
  else
  begin
    Result := True;
  end;
end;

function TForm_CadProduto.cancelar: Boolean;
begin
  Edit_codigo.Text := getUltimoID;
  Edit_descricao.Clear;
  Edit_CodBar.clear;
  Edit_unMedida.Clear;
  RxCalcEdit_CstCompra.Clear;
  RxCalcEdit_CstVenda.Clear;
  RxCalcEdit_qtdEstoque.Clear;
end;

function StrToSQL(caracter: String): String;
begin
  if caracter <> '' then
    Result := #39 + caracter + #39
  else
    Result := 'NULL';
end;

procedure TForm_CadProduto.Edit_CodBarKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#8]) then Abort;
end;

procedure TForm_CadProduto.Edit_codigoExit(Sender: TObject);
var
  carrega: TFDQuery;
  sql: String;
begin
  carrega := TFDQuery.Create(Self);
  if Edit_codigo.Text <> '' then
  begin
  try
    sql := 'SELECT Pro_Descricao, Pro_CodBar, Pro_Unidade,Pro_CstUnitario, Pro_QtdEstoque,Pro_CstVenda FROM produtos WHERE Pro_Codigo = '+Edit_codigo.Text;
    dmConexao.ExecSQL(sql, carrega);
    if carrega.IsEmpty then
    begin
    cancelar;
    Edit_codigo.Text := getUltimoID;
    end else
    begin
    Edit_descricao.Text := carrega.FieldByName('Pro_Descricao').AsString;
    Edit_CodBar.Text := carrega.FieldByName('Pro_CodBar').AsString;
    Edit_unMedida.Text := carrega.FieldByName('Pro_Unidade').AsString;
    RxCalcEdit_CstCompra.Value := carrega.FieldByName('Pro_CstUnitario').AsFloat;
    RxCalcEdit_qtdEstoque.Value := carrega.FieldByName('Pro_QtdEstoque').AsFloat;
    RxCalcEdit_CstVenda.Value := carrega.FieldByName('Pro_CstVenda').AsFloat;
    end;
  finally
    FreeAndNil(carrega);
  end;
  end else
  begin
   Edit_codigo.Text := getUltimoID;
  end;
end;

procedure TForm_CadProduto.Edit_codigoKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#8]) then Abort;
end;

function TForm_CadProduto.existe_produto(codigo: string): Boolean;
var
  excist: TFDQuery;
begin
  excist := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL
      ('SELECT * FROM produtos WHERE Pro_Codigo =  ' +
      StrToSQL(codigo), excist);
    Result := not excist.IsEmpty;
  finally
    FreeAndNil(excist);
  end;
end;

function TForm_CadProduto.gravar: Boolean;
var
  sql : String;
begin
  if not validarCampos then
  begin
    Result := False;
    Exit;
  end;
  begin
    if existe_produto(Edit_codigo.Text) then
    begin
      sql := 'UPDATE produtos '+
             ' SET Pro_Descricao = '+StrToSQL(Edit_descricao.Text)+
             ' ,Pro_CodBar = '+StrToSQL(Edit_CodBar.Text)+
             ' ,Pro_QtdEstoque = '+VirgulaPorPonto(RxCalcEdit_qtdEstoque.Text)+
             ' ,Pro_Unidade = '+StrToSQL(Edit_unMedida.Text)+
             ' ,Pro_CstUnitario = '+VirgulaPorPonto(RxCalcEdit_CstCompra.Text)+
             ' ,Pro_CstVenda = '+VirgulaPorPonto(RxCalcEdit_CstVenda.Text)+
            ' WHERE Pro_Codigo ='+Edit_codigo.Text;

    dmConexao.ExecSQL(sql);
    Application.MessageBox(PCHAR('Cadastro alterado com sucesso.'),'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
    end
    else
    begin
      if not existe_produto(Edit_codigo.Text) then
      begin
      sql := (' INSERT INTO produtos'+
           '(Pro_Descricao, Pro_CodBar, Pro_QtdEstoque, Pro_Unidade, Pro_CstUnitario, Pro_CstVenda)'+
      ' VALUES'+
           '('+StrToSQL(Edit_descricao.Text)+','+StrToSQL(Edit_CodBar.Text)+','
           +VirgulaPorPonto(RxCalcEdit_qtdEstoque.Text)+','+StrToSQL(Edit_unMedida.Text)+','+VirgulaPorPonto(RxCalcEdit_CstCompra.Text)+
           ','+VirgulaPorPonto(RxCalcEdit_CstVenda.Text)+')');
        dmConexao.ExecSQL(sql);
        Application.MessageBox(PCHAR('Cadastro incluso com sucesso.'),
            'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
      end
      else
      begin
        Application.MessageBox(PCHAR('O produto ' + Edit_descricao.Text +
          ' j� est� cadastrado.'), 'Aten��o, verifique seus produtos!',
          MB_ICONWARNING + MB_OK + MB_TASKMODAL);
        Edit_descricao.SetFocus;
      end;
    end;
    cancelar;
  end;
end;

procedure TForm_CadProduto.BitBtn1Click(Sender: TObject);
begin
  cancelar;
end;

procedure TForm_CadProduto.BitBtn_cancelarClick(Sender: TObject);
begin
  excluir;
end;

procedure TForm_CadProduto.BitBtn_confirmarClick(Sender: TObject);
begin
  gravar;
end;

procedure TForm_CadProduto.BitBtn_pesquisarClick(Sender: TObject);
begin
  Form_pesProduto := TForm_pesProduto.Create(Application);
  try
    if Form_pesProduto.ShowModal = mrOk then
      loadTela(Form_pesProduto.FDQuery1.FieldByName('Pro_Codigo').AsString);
  finally
    FreeAndNil(Form_pesProduto);
  end;
end;

procedure TForm_CadProduto.BitBtn_voltarClick(Sender: TObject);
begin
  Form_CadProduto.Close;
end;

procedure TForm_CadProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CaFree;
  Release;
  Form_CadProduto := nil;
end;

procedure TForm_CadProduto.FormCreate(Sender: TObject);
begin
 Edit_codigo.Text := getUltimoID;
end;

end.
