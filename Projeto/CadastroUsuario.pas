unit CadastroUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.Mask, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Frame.Generico, FireDAC.Stan.Async, FireDAC.DApt, Utils, ACBrBase,
  ACBrSocket, ACBrCEP, ACBrValidador;

type
  TForm_CadastroUsuario = class(TForm)
    Panel_CadastroUsuario: TPanel;
    SpeedButton_editar: TSpeedButton;
    SpeedButton_Sair: TSpeedButton;
    FDMemTable1: TFDMemTable;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Label9: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Edit_senha: TEdit;
    Edit_email: TEdit;
    Edit_confirmasenha: TEdit;
    Edit_login: TEdit;
    FDQuery1: TFDQuery;
    BitBtn1: TBitBtn;
    Cancelar: TBitBtn;
    Panel3: TPanel;
    BitBtn_cancelar: TBitBtn;
    BitBtn_confirmar: TBitBtn;
    BitBtn_pesquisar: TBitBtn;
    BitBtn_voltar: TBitBtn;
    BitBtn2: TBitBtn;
    Edit_codigo: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton_SairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit_codigoExit(Sender: TObject);
    procedure Frame_PessoaComboBox_InformacaoExit(Sender: TObject);
    procedure SpeedButton_editarClick(Sender: TObject);
    procedure Frame_PessoaComboBox_InformacaoChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SpeedButton_salvarClick(Sender: TObject);
    procedure Mask_cepExit(Sender: TObject);
    procedure Mask_cepEnter(Sender: TObject);
    procedure CancelarClick(Sender: TObject);
    procedure Frame_StatusComboBox_InformacaoExit(Sender: TObject);
    procedure Edit_cxpostalKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Edit_loginKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_nomecompletoKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_logradouroKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_bairroKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_cidadeKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_UfKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_numeroKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn_voltarClick(Sender: TObject);
    // procedure Edit_codigoExit(Sender: TObject);

  private
    function inserirDados: Boolean;
    function alterarDados: Boolean;
    function inserirendereco: Boolean;
    function alterarEndereco: Boolean;
    function carregaStatus: Boolean;
    function validarCampos: Boolean;
    function existe_usuario(codigo: string): Boolean;
    function existe_cpf(codigo: string): Boolean;
    function existe_cnpj(codigo: string): Boolean;
    function existe_rg(codigo: string): Boolean;
    function existe_login(codigo: string): Boolean;
    function inserirSenha: Boolean;
    function alterarSenha: Boolean;
    function existeCampos: Boolean;
    function EncryptSTR(const Key, texto: String): String;
    function getUltimoId: String;
    function getUltimoIdEnd: String;
    function limpacampos: Boolean;
    procedure mudaMascaraPessoa(Sender: TObject);
    function carregaGenero: Boolean;
    function loadEnd: Boolean;
    function loadLog: Boolean;
    procedure loadTela(id: string);
    function limparMask(cpf: String): String;
    function validacpf: Boolean;
    function loadGenero: String;

  public
    function carregatppessoa: Boolean;
  end;

var
  Form_CadastroUsuario: TForm_CadastroUsuario;

implementation

{$R *.dfm}

uses FAG.DataModule.Conexao, FAG.ConsultaUsuario, FAG.RelatorioUsuario,
  ACBrUtil;

function TForm_CadastroUsuario.alterarDados: Boolean;
var
  sql: String;
begin
  sql := 'UPDATE pessoa SET ' + ' pes_nome = ' +
    StrToSQL(Edit_nomecompleto.Text) + ',' + ' pes_rg = ' +
    StrToSQL(Mask_RG.Text) + ',' + ' pes_celular =' +
    StrToSQL(Mask_Celular.Text) + ',' + ' pes_ativo =' +
    StrToSQL(Frame_Status.indexCombo) + ',' + ' pes_telefone =' +
    StrToSQL(Mask_telefone.Text) + ',' + ' pes_genero = ' +
    StrToSQL(Combo_Genero.Text) + ',' + ' pes_email = ' +
    StrToSQL(Edit_email.Text) + ',' + ' pes_data_atualizacao = ' + 'NOW()' + ','
    + ' pes_matricula = ' + StrToSQL(Edit_Matricula.Text) + ',' +
    ' pes_nascimento = ' + DateTimeToSQL(Date_Nascimento.datetime);

  if Frame_Pessoa.TableTemp.FieldByName('id_tipoPessoa').AsString = '1' then
  // Pessoa fisica
  begin
    sql := sql + ', pes_cpf = ' + StrToSQL(Mask_CPF.Text) + ', pes_cnpj = ' +
      StrToSQL('');
  end
  else
  begin
    sql := sql + ', pes_cnpj = ' + StrToSQL(Mask_CPF.Text) + ', pes_cpf = ' +
      StrToSQL('');
  end;

  sql := sql + ' WHERE pes_id_pessoa = ' + Edit_codigo.Text;
  DataModuleConexao.ExecSQL(sql);
end;

function TForm_CadastroUsuario.alterarEndereco: Boolean;
var
  sql: String;
begin
  sql := ('UPDATE endereco SET end_num = ' + StrToSQL(Edit_numero.Text) + ',' +
    ' end_rua = ' + StrToSQL(Edit_logradouro.Text) + ',' + ' end_bairro = ' +
    StrToSQL(Edit_bairro.Text) + ',' + ' end_cidade =' +
    StrToSQL(Edit_cidade.Text) + ',' + ' end_cep = ' + StrToSQL(Mask_cep.Text) +
    ',' + ' end_estado = ' + StrToSQL(Edit_Uf.Text) + ',' + ' end_cx_postal = '
    + StrToSQL(Edit_cxpostal.Text) + ',' + ' end_complemento = ' +
    StrToSQL(Edit_complemento.Text) + '' + ' WHERE end_pes_id_pessoa = ' +
    Edit_codigo.Text + '');
  DataModuleConexao.ExecSQL(sql);
end;

function TForm_CadastroUsuario.alterarSenha: Boolean;
var
  sql: String;
begin
  sql := ('UPDATE login SET ' + 'login_senha = ' + CryptBD(Edit_senha.Text) +
    ' WHERE login_pes_id_pessoa = ' + (Edit_codigo.Text) + '');
  DataModuleConexao.ExecSQL(sql);
end;

procedure TForm_CadastroUsuario.BitBtn1Click(Sender: TObject);
begin
  try
    DataModuleConexao.BeginTrans;
    if existe_usuario(Edit_codigo.Text) then
    begin
      if validarCampos then
      begin
        if validacpf then
        begin
          alterarDados;
          alterarEndereco;
          alterarSenha;
          Application.MessageBox(PCHAR('Cadastro alterado com sucesso.'),
            'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
          limpacampos;
        end;
        exit
      end;
      exit
    end
    else
    begin
      if validarCampos then
      begin
        if validacpf then
        begin
          if existeCampos then
          begin
            inserirDados;
            Edit_codigo.Text := getLastID;
            inserirendereco;
            inserirSenha;
            Application.MessageBox(PCHAR('Cadastro incluso com sucesso.'),
              'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
            limpacampos;
          end;
        end;
        exit
      end;
      exit
    end;
    DataModuleConexao.CommitTrans;
  except
    on E: Exception do
    begin
      DataModuleConexao.RollBackTrans;
      Application.MessageBox(PCHAR('O produto ' + E.Message +
        ' j� est� cadastrado.'), 'Aten��o, verifique seus produtos!',
        MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    end;
  end;
end;

procedure TForm_CadastroUsuario.BitBtn_voltarClick(Sender: TObject);
begin
  try
    DataModuleConexao.BeginTrans;

    DataModuleConexao.CommitTrans;
  except
    on E: Exception do
    begin
      DataModuleConexao.RollBackTrans;
    end;
  end;
end;

procedure TForm_CadastroUsuario.Button1Click(Sender: TObject);
begin
  inserirDados;
end;

function TForm_CadastroUsuario.existeCampos: Boolean;
begin
  Result := False;
  if Frame_Pessoa.ComboBox_Informacao.ItemIndex = 1 then
  begin
    if existe_cpf(Mask_CPF.Text) then
    begin
      Application.MessageBox(PCHAR('CPF j� cadastrado.'), 'Aten��o!',
        MB_ICONWARNING + MB_OK + MB_TASKMODAL);
      Mask_CPF.SetFocus;
      exit;
    end;
  end;
  if Frame_Pessoa.ComboBox_Informacao.ItemIndex = 2 then
  begin
    if existe_cnpj(Mask_CPF.Text) then
    begin
      Application.MessageBox(PCHAR('CNPJ j� cadastrado.'), 'Aten��o!',
        MB_ICONWARNING + MB_OK + MB_TASKMODAL);
      Mask_CPF.SetFocus;
      exit;
    end;
  end;
//  if existe_rg(Mask_RG.Text) then
//  begin
//    ShowMessage('RG j� cadastrado');
//    Mask_RG.SetFocus;
//    exit;
//  end;
  if existe_login(Edit_login.Text) then
  begin
    ShowMessage('Login j� cadastrado');
    Edit_login.SetFocus;
    exit;
  end
  else
    Result := True;
end;

procedure TForm_CadastroUsuario.CancelarClick(Sender: TObject);
begin
  carregaStatus;
  getUltimoId;
  carregaGenero;
  carregatppessoa;
  limpacampos;
end;

function TForm_CadastroUsuario.carregaGenero: Boolean;
begin
  Combo_Genero.clear;
  Combo_Genero.Style := csDropDownList;
  Combo_Genero.Items.Add('SELECIONE');
  Combo_Genero.Items.Add('MASCULINO');
  Combo_Genero.Items.Add('FEMININO');
  Combo_Genero.Items.Add('INDEFINIDO');
  Combo_Genero.ItemIndex := 0;
end;

function TForm_CadastroUsuario.carregaStatus: Boolean;
begin
  Frame_Status.tabela := 'situacao';
  Frame_Status.campoChave := 'sit_id';
  Frame_Status.campoDescricao := 'sit_descricao';
  Frame_Status.camposExtras := '';
  Frame_Status.condicao := '';
  Frame_Status.titulo := 'Status*';
  Frame_Status.primeiraOpcao := 'SELECIONE';
  Frame_Status.carregaFrame := True;
end;

function TForm_CadastroUsuario.carregatppessoa: Boolean;
begin
  Frame_Pessoa.tabela := 'tipopessoa';
  Frame_Pessoa.campoChave := 'id_tipoPessoa';
  Frame_Pessoa.campoDescricao := 'tipopessoa_desc';
  Frame_Pessoa.camposExtras := '';
  Frame_Pessoa.condicao := '';
  Frame_Pessoa.titulo := 'Tipo Pessoa*';
  Frame_Pessoa.primeiraOpcao := 'SELECIONE';
  Frame_Pessoa.carregaFrame := True;
end;

procedure TForm_CadastroUsuario.mudaMascaraPessoa(Sender: TObject);
begin

  case Frame_Pessoa.ComboBox_Informacao.ItemIndex of
    0:
      begin
        ShowMessage('Escolha tipo de pessoa');
        Frame_Pessoa.ComboBox_Informacao.SetFocus;
      end;
    1:
      begin
        Label_CPF.Caption := 'CPF*';
        Mask_CPF.EditMask := '999.999.999-99;1;_';
      end;
    2:
      begin
        Label_CPF.Caption := 'CNPJ*';
        Mask_CPF.EditMask := '99.999.999/9999-99;1;_';
      end;
  end;
end;


procedure TForm_CadastroUsuario.Edit_bairroKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['0' .. '9']) then
    Key := #0;
end;

procedure TForm_CadastroUsuario.Edit_cidadeKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['0' .. '9']) then
    Key := #0;
end;

procedure TForm_CadastroUsuario.Edit_codigoExit(Sender: TObject);
var
  carrega: TFDMemTable;
begin
  if Edit_codigo.Text = '' then
  begin
    limpacampos;
  end
  else
  begin
    if StrToInt(Edit_codigo.Text) = Edit_codigo.Tag then
      exit;
    if existe_usuario(Edit_codigo.Text) then
    begin
      carrega := TFDMemTable.Create(Self);
      try
        // Dados Pessoais //
        DataModuleConexao.ExecSQL
          ('SELECT pes_id_pessoa, pes_nome, pes_cpf, pes_rg, pes_genero, pes_nascimento, pes_email, pes_telefone,'
          + 'pes_celular, pes_datacadastro,pes_data_atualizacao, log_id,tip_id_tipo_pessoa,	'
          + 'pes_fantasia, pes_incricao_municipal, pes_incricao_estadual, pes_ativo, end_id_endereco FROM pessoa WHERE pes_id_pessoa = '
          + Edit_codigo.Text, carrega);

        Edit_codigo.Text := carrega.FieldByName('pes_id_pessoa').AsString;
        Edit_nomecompleto.Text := carrega.FieldByName('pes_nome').AsString;
        Mask_CPF.Text := carrega.FieldByName('pes_cpf').AsString;
        Mask_RG.Text := carrega.FieldByName('pes_rg').AsString;
        Mask_Celular.Text := carrega.FieldByName('pes_celular').AsString;
        Mask_telefone.Text := carrega.FieldByName('pes_telefone').AsString;
        Edit_email.Text := carrega.FieldByName('pes_email').AsString;
        Combo_Genero.Text := carrega.FieldByName('pes_genero').AsString;
        Frame_Pessoa.ComboBox_Informacao.ItemIndex :=
          carrega.FieldByName('tip_id_tipo_pessoa').AsInteger;
        Frame_Status.ComboBox_Informacao.ItemIndex :=
          carrega.FieldByName('pes_ativo').AsInteger;
        Date_Nascimento.Date := carrega.FieldByName('pes_nascimento').Value;
        Edit_nomecompleto.Text := carrega.FieldByName('pes_nome').AsString;
        Mask_CPF.Text := carrega.FieldByName('pes_cpf').AsString;

      finally
        FreeAndNil(carrega);
      end;
    end
    else
    begin
      limpacampos;
      carregaGenero;
    end;
  end;
end;

procedure TForm_CadastroUsuario.Edit_cxpostalKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0' .. '9', #8, #9]) then
    Key := #0;
end;

procedure TForm_CadastroUsuario.Edit_loginKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['0' .. '9']) then
    Key := #0;
end;


procedure TForm_CadastroUsuario.Edit_logradouroKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['0' .. '9']) then
    Key := #0;
end;
procedure TForm_CadastroUsuario.Edit_nomecompletoKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['0' .. '9']) then
    Key := #0;
end;

procedure TForm_CadastroUsuario.Edit_numeroKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not (Key in ['0' .. '9', #8, #9]) then
    Key := #0;
end;

procedure TForm_CadastroUsuario.Edit_UfKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['0' .. '9']) then
    Key := #0;
end;

function TForm_CadastroUsuario.EncryptSTR(const Key, texto: String): String;
var
  I: Integer;
  C: Byte;
begin
  Result := '';
  for I := 1 to Length(texto) do
  begin
    if Length(Key) > 0 then
      C := Byte(Key[1 + ((I - 1) mod Length(Key))]) xor Byte(texto[I])
    else
      C := Byte(texto[I]);
    Result := Result + AnsiLowerCase(IntToHex(C, 2));
  end;
end;

function TForm_CadastroUsuario.existe_cnpj(codigo: string): Boolean;
var
  excist: TFDMemTable;
begin
  excist := TFDMemTable.Create(Self);
  try
    DataModuleConexao.ExecSQL('SELECT pes_cnpj FROM pessoa WHERE pes_cnpj = ' +
      '"' + codigo + '"', excist);
    Result := not excist.IsEmpty;
  finally
    FreeAndNil(excist);
  end;
end;

function TForm_CadastroUsuario.existe_cpf(codigo: string): Boolean;
var
  excist: TFDMemTable;
begin
  excist := TFDMemTable.Create(Self);
  try
    DataModuleConexao.ExecSQL('SELECT pes_cpf FROM pessoa WHERE pes_cpf = ' +
      '"' + codigo + '"', excist);
    Result := not excist.IsEmpty;
  finally
    FreeAndNil(excist);
  end;
end;

function TForm_CadastroUsuario.existe_login(codigo: string): Boolean;
var
  excist: TFDMemTable;
begin
  excist := TFDMemTable.Create(Self);
  try
    DataModuleConexao.ExecSQL
      ('SELECT login_usuario FROM login WHERE login_usuario = ' + '"' + codigo +
      '"', excist);
    Result := not excist.IsEmpty;
  finally
    FreeAndNil(excist);
  end;
end;

function TForm_CadastroUsuario.existe_rg(codigo: string): Boolean;
var
  excist: TFDMemTable;
begin
  excist := TFDMemTable.Create(Self);
  try
    DataModuleConexao.ExecSQL('SELECT pes_rg FROM pessoa WHERE pes_rg = ' + '"'
      + codigo + '"', excist);
    Result := not excist.IsEmpty;
  finally
    FreeAndNil(excist);
  end;
end;

function TForm_CadastroUsuario.existe_usuario(codigo: string): Boolean;
var
  excist: TFDMemTable;
begin
  excist := TFDMemTable.Create(Self);
  try
    DataModuleConexao.ExecSQL
      ('SELECT pes_id_pessoa FROM pessoa WHERE pes_id_pessoa = ' +
      codigo, excist);
    Result := not excist.IsEmpty;
  finally
    FreeAndNil(excist);
  end;
end;

procedure TForm_CadastroUsuario.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := CaFree;
  Release;
  Form_CadastroUsuario := nil;
end;

procedure TForm_CadastroUsuario.FormCreate(Sender: TObject);
begin
  carregatppessoa;
  carregaStatus;
  Edit_codigo.Text := getUltimoId;
  getUltimoIdEnd;
  carregaGenero;
  Date_Nascimento.DateTime := Now;
  Date_Nascimento.MaxDate := now;
end;

procedure TForm_CadastroUsuario.Frame_PessoaComboBox_InformacaoChange
  (Sender: TObject);
begin
  mudaMascaraPessoa(Sender);
end;

procedure TForm_CadastroUsuario.Frame_PessoaComboBox_InformacaoExit
  (Sender: TObject);
begin
  Frame_Pessoa.ComboBox_InformacaoExit(Sender);
end;

procedure TForm_CadastroUsuario.Frame_StatusComboBox_InformacaoExit
  (Sender: TObject);
begin
  Frame_Status.ComboBox_InformacaoExit(Sender);
end;

function TForm_CadastroUsuario.getUltimoId: String;
var
  excist: TFDMemTable;
begin
  excist := TFDMemTable.Create(Self);
  try
    DataModuleConexao.ExecSQL
      ('SELECT COALESCE(MAX(pes_id_pessoa)+1, 1) AS ID FROM pessoa', excist);
    Result := excist.FieldByName('ID').AsString;
  finally
    FreeAndNil(excist);
  end;
end;

function TForm_CadastroUsuario.getUltimoIdEnd: String;
var
  excist: TFDMemTable;
begin
  excist := TFDMemTable.Create(Self);
  try
    DataModuleConexao.ExecSQL
      ('SELECT COALESCE(MAX(end_id_endereco)+1, 1) AS ID FROM endereco',
      excist);
    Result := excist.FieldByName('ID').AsString;
  finally
    FreeAndNil(excist);
  end;
end;

function TForm_CadastroUsuario.inserirDados: Boolean;
var
  sql: String;
  tpPessoa: String;
begin

  sql := 'INSERT INTO pessoa (pes_nome, pes_rg, pes_celular, pes_nascimento, ' +
    ' pes_email, pes_telefone, pes_ativo, tip_id_tipo_pessoa,pes_genero,' +
    'pes_matricula,pes_datacadastro, pes_cpf, pes_cnpj)' + 'VALUES (' +
    StrToSQL(Edit_nomecompleto.Text) + ',' + StrToSQL(Mask_RG.Text) + ',' +
    StrToSQL(Mask_Celular.Text) + ',' + DateTimeToSQL(Date_Nascimento.datetime)
    + ',' + StrToSQL(Edit_email.Text) + ',' + StrToSQL(Mask_telefone.Text) + ','
    + StrToSQL(Frame_Status.indexCombo) + ',' +
    StrToSQL(Frame_Pessoa.indexCombo) + ',' + StrToSQL(Combo_Genero.Text) + ','
    + StrToSQL(Edit_Matricula.Text) + ',' + 'NOW()' + ',';
  if Frame_Pessoa.TableTemp.FieldByName('id_tipoPessoa').AsString = '1' then
  // Pessoa fisica
  begin
    sql := sql + StrToSQL(Mask_CPF.Text) + ', ' + StrToSQL('');
  end
  else
  begin
    sql := sql + StrToSQL('') + ', ' + StrToSQL(Mask_CPF.Text);
  end;
  sql := sql + ')';
  DataModuleConexao.ExecSQL(sql);
end;

function TForm_CadastroUsuario.inserirendereco: Boolean;
var
  sql: String;
begin
  sql := 'INSERT INTO endereco (end_num, end_rua, end_bairro, end_cidade, ' +
    'end_cep, end_cx_postal, end_complemento, end_estado, end_data_cadastro, end_pes_id_pessoa) VALUES ('
    + StrToSQL(Edit_numero.Text) + ',' + StrToSQL(Edit_logradouro.Text) + ',' +
    StrToSQL(Edit_bairro.Text) + ',' + StrToSQL(Edit_cidade.Text) + ',' +
    StrToSQL(Mask_cep.Text) + ',' + StrToSQL(Edit_cxpostal.Text) + ',' +
    StrToSQL(Edit_complemento.Text) + ',' + StrToSQL(Edit_Uf.Text) + ',' +
    'NOW(),' + StrToSQL(Edit_codigo.Text) + ')';
  DataModuleConexao.ExecSQL(sql);
end;

function TForm_CadastroUsuario.limpacampos: Boolean;
begin
  // Dados pessoais //
  Edit_codigo.Text := getUltimoId;
  Frame_Pessoa.ComboBox_Informacao.ItemIndex := 0;
  Frame_Status.ComboBox_Informacao.ItemIndex := 0;
  Edit_nomecompleto.clear;
  Mask_RG.clear;
  Edit_Matricula.clear;
  Combo_Genero.ItemIndex := 0;
  Date_Nascimento.datetime := Date;
  Mask_Celular.clear;
  Mask_telefone.clear;
  Mask_CPF.clear;
  // Endere�o//
  Mask_cep.clear;
  Edit_logradouro.clear;
  Edit_numero.clear;
  Edit_complemento.clear;
  Edit_bairro.clear;
  Edit_cidade.clear;
  Edit_Uf.clear;
  Edit_cxpostal.clear;
  // Login //
  Edit_login.clear;
  Edit_senha.clear;
  Edit_confirmasenha.clear;
  Edit_email.clear;
end;

function TForm_CadastroUsuario.limparMask(cpf: String): String;
begin
  Trim(cpf);
  cpf := StringReplace(cpf, '-', '', [rfReplaceAll]);
  cpf := StringReplace(cpf, '_', '', [rfReplaceAll]);
  cpf := StringReplace(cpf, '.', '', [rfReplaceAll]);
end;

function TForm_CadastroUsuario.loadEnd: Boolean;
var
  carrega: TFDMemTable;
begin
  carrega := TFDMemTable.Create(Self);
  try
    DataModuleConexao.ExecSQL
      ('SELECT end_num, end_rua,end_bairro, end_cidade, end_estado,' +
      '	end_cep,end_cx_postal, end_complemento FROM endereco WHERE end_pes_id_pessoa = '
      + Form_ConsultaUsuario.FDMemTable_Usuario.FieldByName('C�digo')
      .AsString, carrega);

    Edit_numero.Text := carrega.FieldByName('end_num').AsString;
    Edit_logradouro.Text := carrega.FieldByName('end_rua').AsString;
    Edit_bairro.Text := carrega.FieldByName('end_bairro').AsString;
    Edit_cidade.Text := carrega.FieldByName('end_cidade').AsString;
    Edit_Uf.Text := carrega.FieldByName('end_estado').AsString;
    Mask_cep.Text := carrega.FieldByName('end_cep').AsString;
    Edit_cxpostal.Text := carrega.FieldByName('end_cx_postal').AsString;
    Edit_complemento.Text := carrega.FieldByName('end_complemento').AsString;
  finally
    FreeAndNil(carrega);
  end;

end;

function TForm_CadastroUsuario.loadGenero: String;
var
  excist: TFDMemTable;
begin
  excist := TFDMemTable.Create(Self);
  try
    DataModuleConexao.ExecSQL
      ('SELECT pes_genero FROM pessoa WHERE pes_id_pessoa = ' +
      Edit_codigo.Text, excist);
    Result := excist.FieldByName('pes_genero').AsString;
  finally
    FreeAndNil(excist);
  end;
end;

function TForm_CadastroUsuario.loadLog: Boolean;
var
  carrega: TFDMemTable;
begin
  carrega := TFDMemTable.Create(Self);
  try
    DataModuleConexao.ExecSQL('SELECT login_usuario, ' +
      ' AES_DECRYPT(login_senha,"' + Key + '") AS login_senha FROM Login ' +
      ' WHERE login_pes_id_pessoa = ' + Form_ConsultaUsuario.FDMemTable_Usuario.
      FieldByName('C�digo').AsString, carrega);
    Edit_login.Text := carrega.FieldByName('login_usuario').AsString;
    Edit_senha.Text := carrega.FieldByName('login_senha').AsString;
    Edit_confirmasenha.Text := carrega.FieldByName('login_senha').AsString;
  finally
    FreeAndNil(carrega);
  end;

end;

procedure TForm_CadastroUsuario.loadTela(id: string);
var
  carrega: TFDMemTable;
begin
  carrega := TFDMemTable.Create(Self);
  try
    DataModuleConexao.ExecSQL
      ('SELECT pes_id_pessoa, pes_nome, pes_rg, pes_cpf, pes_cnpj, pes_nascimento, pes_email, pes_ativo,tip_id_tipo_pessoa, pes_matricula, pes_celular, pes_telefone, pes_genero FROM pessoa '
      + 'WHERE pes_id_pessoa  = ' + id, carrega);

    Edit_codigo.Text := carrega.FieldByName('pes_id_pessoa').AsString;
    Edit_nomecompleto.Text := carrega.FieldByName('pes_nome').AsString;
    Mask_RG.Text := carrega.FieldByName('pes_rg').AsString;
    if carrega.FieldByName('pes_cpf').AsString = '' then
    begin
      Label_CPF.Caption := 'CNPJ*';
      Mask_CPF.EditMask := '99.999.999/9999-99;1;_';
      Mask_CPF.Text := carrega.FieldByName('pes_cnpj').AsString;
    end
    else
    begin
      Label_CPF.Caption := 'CPF*';
      Mask_CPF.EditMask := '999.999.999-99;1;_';
      Mask_CPF.Text := carrega.FieldByName('pes_cpf').AsString;
    end;
    Date_Nascimento.Date := carrega.FieldByName('pes_nascimento').Value;
    Edit_email.Text := carrega.FieldByName('pes_email').AsString;
    Frame_Status.ComboBox_Informacao.ItemIndex :=
      carrega.FieldByName('pes_ativo').Value;
    Frame_Pessoa.ComboBox_Informacao.ItemIndex :=
      carrega.FieldByName('tip_id_tipo_pessoa').Value;
    Edit_Matricula.Text := carrega.FieldByName('pes_matricula').AsString;
    Mask_Celular.Text := carrega.FieldByName('pes_celular').AsString;
    Mask_telefone.Text := carrega.FieldByName('pes_telefone').AsString;
    Combo_Genero.Text := carrega.FieldByName('pes_genero').AsString;
    loadEnd;
    loadLog;
  finally
    FreeAndNil(carrega);
  end;
  carregaGenero;
end;


procedure TForm_CadastroUsuario.Mask_cepEnter(Sender: TObject);
begin
  Mask_cep.Tag := StrToIntDef(OnlyNumber(Mask_cep.Text), 0);
end;

procedure TForm_CadastroUsuario.Mask_cepExit(Sender: TObject);
begin
  if Mask_cep.Tag = StrToIntDef(OnlyNumber(Mask_cep.Text), 0) then
    exit;

  if (Trim(OnlyNumber(Mask_cep.Text)).Length = 8) then
  begin
    ACBrCEP1.BuscarPorCEP(Mask_cep.Text);
    if ACBrCEP1.Enderecos.Count = 0 then
    begin
      Application.MessageBox(PCHAR('CEP n�o encontrado.'), 'Aten��o!',
        MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    end
    else
    begin
      Edit_logradouro.Text := ACBrCEP1.Enderecos[0].Logradouro;
      Edit_bairro.Text := ACBrCEP1.Enderecos[0].Bairro;
      Edit_cidade.Text := ACBrCEP1.Enderecos[0].Municipio;
      Edit_Uf.Text := ACBrCEP1.Enderecos[0].UF;
    end;
  end;

end;

function TForm_CadastroUsuario.inserirSenha: Boolean;
var
  sql: String;
begin
  sql := 'INSERT INTO login (login_usuario, login_senha, login_pes_id_pessoa) VALUES ('
    + StrToSQL(Edit_login.Text) + ',' + CryptBD(Edit_senha.Text) + ',' +
    StrToSQL(Edit_codigo.Text) + ')';
  DataModuleConexao.ExecSQL(sql);
end;

procedure TForm_CadastroUsuario.SpeedButton_editarClick(Sender: TObject);
begin
  Form_ConsultaUsuario := TForm_ConsultaUsuario.Create(Self);
  try
    if Form_ConsultaUsuario.ShowModal = mrOk then
      loadTela(Form_ConsultaUsuario.FDMemTable_Usuario.FieldByName('C�digo')
        .AsString);
    if loadGenero = 'MASCULINO' then
    begin
      Combo_Genero.ItemIndex := 1;
    end;
    if loadGenero = 'FEMININO' then
    begin
      Combo_Genero.ItemIndex := 2;
    end;
    if loadGenero = 'INDEFINIDO' then
    begin
      Combo_Genero.ItemIndex := 3;
    end;
  finally
    FreeAndNil(Form_ConsultaUsuario);
  end;
end;

procedure TForm_CadastroUsuario.SpeedButton_SairClick(Sender: TObject);
begin
  Form_CadastroUsuario.Close;
end;

procedure TForm_CadastroUsuario.SpeedButton_salvarClick(Sender: TObject);
begin
  try
    DataModuleConexao.BeginTrans;

    DataModuleConexao.CommitTrans;
  except
    on E: Exception do
    begin
      DataModuleConexao.RollBackTrans;
    end;
  end;
end;

function TForm_CadastroUsuario.validacpf: Boolean;
begin
  Result := False;
  validador.Documento := Mask_CPF.Text;

  if Frame_Pessoa.indexCombo = '1' then
  begin
    validador.TipoDocto := TACBrValTipoDocto(docCPF);
    if not validador.Validar then
    begin
      Application.MessageBox(PCHAR('CPF inv�lido.'), 'Aten��o!',
        MB_ICONWARNING + MB_OK + MB_TASKMODAL);
      Mask_CPF.SetFocus;
      exit;
    end
    else
    begin
      Result := True;
    end;
  end;
  if Frame_Pessoa.indexCombo = '2' then
  begin
    validador.TipoDocto := TACBrValTipoDocto(docCNPJ);
    if not validador.Validar then
    begin
      Application.MessageBox(PCHAR('CNPJ inv�lido.'), 'Aten��o!',
        MB_ICONWARNING + MB_OK + MB_TASKMODAL);
      Mask_CPF.SetFocus;
      exit;
    end
    else
    begin
      Result := True;
    end;
  end;
end;

function TForm_CadastroUsuario.validarCampos: Boolean;
begin
  Result := False;
  if Frame_Status.indexCombo.ToInteger = 0 then
  begin
    Application.MessageBox(PCHAR('Informe o status.'), 'Aten��o, campo vazio!',
      MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Frame_Status.ComboBox_Informacao.SetFocus;
    exit;
  end
  else if Frame_Pessoa.ComboBox_Informacao.ItemIndex = 0 then
  begin
    Application.MessageBox(PCHAR('Informe o tipo da pessoa.'),
      'Aten��o, campo vazio!', MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Frame_Pessoa.ComboBox_Informacao.SetFocus;
    exit;
  end
  else if Edit_nomecompleto.Text = '' then
  begin
    Application.MessageBox(PCHAR('Informe o nome.'), 'Aten��o, campo vazio!',
      MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Edit_nomecompleto.SetFocus;
    exit;
  end
  // else if Trim(OnlyNumber(Mask_RG.Text)).Length <= 8 then
  // begin
  // Application.MessageBox(PCHAR('RG inv�lido.'), 'Aten��o!',
  // MB_ICONWARNING + MB_OK + MB_TASKMODAL);
  // exit;
  // end
//  else if Combo_Genero.ItemIndex = 0 then
//  begin
//    Application.MessageBox(PCHAR('Informe o g�nero.'), 'Aten��o!',
//      MB_ICONWARNING + MB_OK + MB_TASKMODAL);
//    Edit_login.SetFocus;
//    exit;
//  end
  else if Edit_login.Text = '' then
  begin
    Application.MessageBox(PCHAR('Informe o login.'), 'Aten��o, campo vazio!',
      MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Edit_login.SetFocus;
    exit;
  end
  else if Edit_senha.Text = emptyStr then
  begin
    Application.MessageBox(PCHAR('Informe a senha.'), 'Aten��o, campo vazio!',
      MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Edit_login.SetFocus;
    exit;
  end
  else if (Edit_senha.Text <> Edit_confirmasenha.Text) then
  begin
    Application.MessageBox(PCHAR('Confirma��o de senha inv�lida.'), 'Aten��o!',
      MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Edit_confirmasenha.SetFocus;
    exit;
  end
  else if (Trim(OnlyNumber(Mask_cep.Text)).Length < 8) and
    (Trim(OnlyNumber(Mask_cep.Text)) <> emptyStr) then
  begin
    Application.MessageBox(PCHAR('CEP inv�lido.'), 'Aten��o!',
      MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Mask_cep.SetFocus;
    exit
  end
  else
    Result := True;
end;

end.
