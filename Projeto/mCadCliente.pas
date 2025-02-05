unit mCadCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, udmConexao,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.Async,
  FireDAC.DApt, pesCliente,System.MaskUtils, Vcl.Mask;

type
  TForm_CadCliente = class(TForm)
    BitBtn_confirmar: TBitBtn;
    BitBtn_Cancelar: TBitBtn;
    BitBtn_Pesquisar: TBitBtn;
    BitBtn_voltar: TBitBtn;
    Panel1: TPanel;
    Label_nome: TLabel;
    Label_cpf: TLabel;
    Edit_nome: TEdit;
    Label_cidade: TLabel;
    Label_UF: TLabel;
    Edit_cidade: TEdit;
    Edit_uf: TEdit;
    Panel2: TPanel;
    BitBtn_excluir: TBitBtn;
    FDQuery1: TFDQuery;
    Edit_codCliente: TEdit;
    Label_codCliente: TLabel;
    MaskEdit_cpf: TMaskEdit;
    Label1: TLabel;
    MaskEdit_cnpj: TMaskEdit;
    RadioGroup1: TRadioGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn_voltarClick(Sender: TObject);
    procedure BitBtn_confirmarClick(Sender: TObject);
    procedure Edit_cpfKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn_PesquisarClick(Sender: TObject);
    procedure BitBtn_CancelarClick(Sender: TObject);
    procedure BitBtn_excluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit_codClienteExit(Sender: TObject);
    procedure Edit_codClienteKeyPress(Sender: TObject; var Key: Char);
    procedure MaskEdit_cpfExit(Sender: TObject);
    procedure MaskEdit_cnpjExit(Sender: TObject);
    procedure MaskEdit_cnpjChange(Sender: TObject);
    procedure MaskEdit_cpfChange(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure loadTela(id: string);
    function getUltimoID: String;
    function excluir: Boolean;
    function gravar: Boolean;
    function cancelar: Boolean;
    function validarCampos: Boolean;
    function FormataCPF(CPF : string): string;
    function FormataCNPJ(CNPJ : string): string;
  public
    { Public declarations }
    function existe_cliente(codigo: string): Boolean;

  end;

var
  Form_CadCliente: TForm_CadCliente;
  Documento : String;

implementation

{$R *.dfm}

function StrToSQL(caracter: String): String;
begin
  if caracter <> '' then
    Result := #39 + caracter + #39
  else
    Result := 'NULL';
end;

Function TForm_CadCliente.FormataCNPJ(CNPJ : string): string;
begin
   Result :=Copy(CNPJ,1,2)+'.'+Copy(CNPJ,3,3)+'.'+Copy(CNPJ,6,3)+'/'+Copy(CNPJ,9,4)+'-'+Copy(CNPJ,13,2);
end;

Function TForm_CadCliente.FormataCPF(CPF : string): string;
begin
   Result :=Copy(CPF,1,3)+'.'+Copy(CPF,4,3)+'.'+Copy(CPF,7,3)+'-'+Copy(CPF,10,2);
end;

function TForm_CadCliente.cancelar: Boolean;
begin
  Edit_codCliente.Text := getUltimoID;
  Edit_nome.clear;
  MaskEdit_cpf.clear;
  MaskEdit_cnpj.Clear;
  Edit_cidade.Clear;
  Edit_uf.Clear;
  RadioGroup1.ItemIndex := 0;
end;

procedure TForm_CadCliente.loadTela(id: string);
var
  carrega: TFDQuery;
begin
  carrega := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL('SELECT Cli_Codigo, Cli_Nome As Nome, Cli_Cpf As Doc, Cli_Cidade As Cidade, Cli_Uf As Estado FROM clientes WHERE Cli_Codigo = '
      + id, carrega);
    Edit_codCliente.Text := carrega.FieldByName('Cli_Codigo').AsString;
    Edit_nome.Text := carrega.FieldByName('Nome').AsString;

    MaskEdit_cpf.clear;
    MaskEdit_cnpj.Clear;

    if length(carrega.FieldByName('Doc').AsString) <= 14 then
    begin
    MaskEdit_cpf.Text := carrega.FieldByName('Doc').AsString;
    RadioGroup1.ItemIndex := 0;
    end else
    begin
    MaskEdit_cnpj.Text := carrega.FieldByName('Doc').AsString;
    RadioGroup1.ItemIndex := 1;
    end;

    Edit_cidade.Text := carrega.FieldByName('Cidade').AsString;
    Edit_uf.Text := carrega.FieldByName('Estado').AsString;
  finally
    FreeAndNil(carrega);
  end;
end;

procedure TForm_CadCliente.MaskEdit_cnpjChange(Sender: TObject);
begin
  if MaskEdit_cnpj.Text <> '__.___.___/____-__' then
  begin
  MaskEdit_cnpj.Enabled := True;
  MaskEdit_cpf.Enabled := False;
  end;
end;

procedure TForm_CadCliente.MaskEdit_cnpjExit(Sender: TObject);
begin
  if MaskEdit_cnpj.Text <> '__.___.___/____-__' then
  begin
  MaskEdit_cnpj.Enabled := True;
  MaskEdit_cpf.Enabled := False;
  end;
end;

procedure TForm_CadCliente.MaskEdit_cpfChange(Sender: TObject);
begin
  if MaskEdit_cpf.Text <> '   .   .   -  ' then
  begin
  MaskEdit_cnpj.Enabled := False;
  MaskEdit_cpf.Enabled := True;
  end;
end;

procedure TForm_CadCliente.MaskEdit_cpfExit(Sender: TObject);
begin
  if MaskEdit_cpf.Text <> '   .   .   -  ' then
  begin
  MaskEdit_cnpj.Enabled := False;
  MaskEdit_cpf.Enabled := True;
  end;
end;

procedure TForm_CadCliente.RadioGroup1Click(Sender: TObject);
begin
   if RadioGroup1.ItemIndex = 0 then
   begin
     MaskEdit_cpf.Enabled := True;
     MaskEdit_cnpj.Enabled := False;
     MaskEdit_cnpj.Clear;
   end;
      if RadioGroup1.ItemIndex = 1 then
   begin
     MaskEdit_cpf.Enabled := False;
     MaskEdit_cnpj.Enabled := True;
     MaskEdit_cpf.Clear;
   end;
end;

procedure TForm_CadCliente.Edit_codClienteExit(Sender: TObject);
var
  carrega: TFDQuery;
  sql: String;
begin
  carrega := TFDQuery.Create(Self);
  if Edit_codCliente.Text <> '' then
  if existe_cliente(Edit_codCliente.Text)then
  begin
  try
    sql := 'SELECT Cli_Codigo, Cli_Nome, Cli_Cpf, Cli_Cidade, Cli_Uf FROM clientes WHERE Cli_Codigo = '+Edit_codCliente.Text;
    dmConexao.ExecSQL(sql, carrega);

    MaskEdit_cpf.clear;
    MaskEdit_cnpj.Clear;

    if length(carrega.FieldByName('Cli_Cpf').AsString) <= 14 then
    begin
    MaskEdit_cpf.Text := carrega.FieldByName('Cli_Cpf').AsString;
    RadioGroup1.ItemIndex := 0;
    end else
    begin
    MaskEdit_cnpj.Text := carrega.FieldByName('Cli_Cpf').AsString;
    RadioGroup1.ItemIndex := 1;
    end;

    Edit_nome.Text := carrega.FieldByName('Cli_Nome').AsString;
    Edit_cidade.Text := carrega.FieldByName('Cli_cidade').AsString;
    Edit_Uf.Text := carrega.FieldByName('Cli_Uf').AsString;
    finally
    FreeAndNil(carrega);
  end;
  end else
  begin
    Edit_codCliente.Text := getUltimoID;
    cancelar;
  end;
end;

procedure TForm_CadCliente.Edit_codClienteKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'..'9',#8]) then Abort;
end;

procedure TForm_CadCliente.Edit_cpfKeyPress(Sender: TObject; var Key: Char);
begin
if not (Key in ['0'..'9',#8]) then Abort;
end;

function TForm_CadCliente.validarCampos: Boolean;
begin
  Result := False;
  if Edit_Nome.Text = '' then
  begin
    Application.MessageBox(PCHAR('Informe o nome.'),
      'Aten��o, campo vazio!', MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Edit_Nome.SetFocus;
  end
  else
  if RadioGroup1.ItemIndex = 0 then
  begin
  if MaskEdit_cpf.Text = '   .   .   -  ' then
  begin
    Application.MessageBox(PCHAR('Informe o CPF.'),
      'Aten��o, necess�rio informar um documento!', MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    MaskEdit_cpf.SetFocus;
  end
  else
  begin
    Result := True;
  end;
  end else
  begin
  if MaskEdit_cnpj.Text = '  .   .   /    -  ' then
  begin
    Application.MessageBox(PCHAR('Informe o Cnpj.'),
      'Aten��o, necess�rio informar um documento!', MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    MaskEdit_cnpj.SetFocus;
  end
  else
  begin
    Result := True;
  end;
  end;
end;

function TForm_CadCliente.getUltimoID: String;
var
  existe: TFDQuery;
begin
  existe := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL
      ('SELECT COALESCE(MAX(Cli_Codigo)+1, 1) AS ID FROM clientes', existe);
    Result := existe.FieldByName('ID').AsString;
  finally
    FreeAndNil(existe);
  end;
end;

function TForm_CadCliente.existe_cliente(codigo: string): Boolean;
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

function TForm_CadCliente.excluir: Boolean;
var
  sql : String;
  msg : Boolean;
begin
   sql := 'DELETE FROM clientes WHERE Cli_Codigo ='+Edit_codCliente.text;
   if Application.MessageBox('Tem certeza que deseja excluir o registro selecionado?',
     'Confirma��o', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = IDYES then
   begin
   try
      dmConexao.ExecSQL(sql);
   except
   msg := True;
     Application.MessageBox(PCHAR('O Cliente possui pedidos lan�ados.'),
     'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
   end;
   if not msg then
     Application.MessageBox(PCHAR('Cadastro excluido com sucesso.'),
     'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
   end;
  cancelar;
end;

function TForm_CadCliente.gravar: Boolean;
var
  sql : String;
begin
  if not validarCampos then
  begin
    Result := False;
    Exit;
  end;
  begin
    if existe_cliente(Edit_codCliente.Text) then
    begin
      sql := 'UPDATE clientes '+
             ' SET Cli_Nome = '+StrToSQL(Edit_nome.Text);

      if RadioGroup1.ItemIndex = 1 then
        sql := sql + ' ,Cli_Cpf = '+StrToSQL(MaskEdit_cnpj.Text)
      else
        sql := sql + ' ,Cli_Cpf = '+StrToSQL(MaskEdit_cpf.Text);

      sql := sql +' ,Cli_Cidade = '+StrToSQL(Edit_cidade.Text)+
      ' ,Cli_Uf = '+StrToSQL(Edit_Uf.Text)+
      ' WHERE Cli_Codigo ='+Edit_codCliente.Text;

    dmConexao.ExecSQL(sql);
    Application.MessageBox(PCHAR('Cadastro alterado com sucesso.'),'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
    end
    else
    begin
      if not existe_cliente(Edit_codCliente.Text) then
      begin
      sql := ' INSERT INTO clientes'+
           '(Cli_Nome, Cli_Cpf, Cli_Cidade, Cli_Uf)'+
      ' VALUES'+
           '('+StrToSQL(Edit_nome.Text);

      if RadioGroup1.ItemIndex = 1 then
        sql := sql + ' ,'+StrToSQL(MaskEdit_cnpj.Text)
      else
        sql := sql + ' ,'+StrToSQL(MaskEdit_cpf.Text);

        sql := sql +','+StrToSQL(Edit_Cidade.Text)+','+StrToSQL(Edit_Uf.Text)+')';
        dmConexao.ExecSQL(sql);
        Application.MessageBox(PCHAR('Cadastro incluso com sucesso.'),
            'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
      end
      else
      begin
        Application.MessageBox(PCHAR('O produto ' + Edit_Nome.Text +
          ' j� est� cadastrado.'), 'Aten��o, verifique seus produtos!',
          MB_ICONWARNING + MB_OK + MB_TASKMODAL);
        Edit_Nome.SetFocus;
      end;
    end;
    cancelar;
  end;
end;

procedure TForm_CadCliente.BitBtn_CancelarClick(Sender: TObject);
begin
  cancelar;
end;

procedure TForm_CadCliente.BitBtn_confirmarClick(Sender: TObject);
begin
  gravar;
end;

procedure TForm_CadCliente.BitBtn_excluirClick(Sender: TObject);
begin
  excluir;
end;

procedure TForm_CadCliente.BitBtn_PesquisarClick(Sender: TObject);
begin
  Form_pesCli := TForm_pesCli.Create(Application);
  try
    if Form_pesCli.ShowModal = mrOk then
      loadTela(Form_pesCli.FDQuery1.FieldByName('Cli_Codigo').AsString);
  finally
    FreeAndNil(Form_pesCli);
  end;
end;

procedure TForm_CadCliente.BitBtn_voltarClick(Sender: TObject);
begin
  Form_CadCliente.Close;
end;

procedure TForm_CadCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CaFree;
  Release;
  Form_CadCliente := nil;
end;

procedure TForm_CadCliente.FormCreate(Sender: TObject);
begin
 Edit_codCliente.Text := getUltimoID;
end;

procedure TForm_CadCliente.FormShow(Sender: TObject);
begin
   if RadioGroup1.ItemIndex = 0 then
   begin
     MaskEdit_cpf.Enabled := True;
     MaskEdit_cnpj.Enabled := False;
   end;
      if RadioGroup1.ItemIndex = 1 then
   begin
     MaskEdit_cpf.Enabled := False;
     MaskEdit_cnpj.Enabled := True;
   end;
end;

end.

