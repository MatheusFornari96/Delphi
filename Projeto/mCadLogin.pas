unit mCadLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, udmConexao,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, pesLogin;

type
  TForm_cadLogin = class(TForm)
    Panel1: TPanel;
    GroupBox3: TGroupBox;
    Label_senha: TLabel;
    Label_login: TLabel;
    Edit_senha: TEdit;
    Edit_login: TEdit;
    Edit_codigo: TEdit;
    Panel3: TPanel;
    BitBtn_excluir: TBitBtn;
    BitBtn_confirmar: TBitBtn;
    BitBtn_pesquisar: TBitBtn;
    BitBtn_voltar: TBitBtn;
    BitBtn_cancelar: TBitBtn;
    Label_idUser: TLabel;
    FDQuery1: TFDQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn_confirmarClick(Sender: TObject);
    procedure BitBtn_cancelarClick(Sender: TObject);
    procedure BitBtn_pesquisarClick(Sender: TObject);
    procedure BitBtn_voltarClick(Sender: TObject);
    procedure Edit_codigoExit(Sender: TObject);
    procedure BitBtn_excluirClick(Sender: TObject);
    procedure Edit_codigoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    function getUltimoID: String;
    function gravar: Boolean;
    function cancelar: Boolean;
    function validarCampos: Boolean;
    function excluir: Boolean;
    function existe_login(codigo: string): Boolean;
    procedure loadTela(id: string);
  public
    { Public declarations }
  end;

var
  Form_cadLogin: TForm_cadLogin;

implementation

{$R *.dfm}

function StrToSQL(caracter: String): String;
begin
  if caracter <> '' then
    Result := #39 + caracter + #39
  else
    Result := 'NULL';
end;

function TForm_cadLogin.cancelar: Boolean;
begin
  Edit_codigo.Text := getUltimoID;
  Edit_login.clear;
  Edit_senha.clear;
end;

function TForm_cadLogin.excluir: Boolean;
var
  sql : String;
  msg : Boolean;
begin
   sql := 'DELETE FROM usuario WHERE User_Codigo ='+Edit_codigo.text;
   if Application.MessageBox('Tem certeza que deseja excluir o registro selecionado?',
     'Confirma��o', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = IDYES then
   begin
   try
      dmConexao.ExecSQL(sql);
   except
   msg := True;
     Application.MessageBox(PCHAR('O cadastro n�o pode ser excluido.'),
     'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
   end;
   if not msg then
     Application.MessageBox(PCHAR('Cadastro excluido com sucesso.'),
     'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
   end;
  cancelar;
end;

procedure TForm_cadLogin.Edit_codigoExit(Sender: TObject);
var
  carrega: TFDQuery;
  sql: String;
begin
  carrega := TFDQuery.Create(Self);
  if Edit_codigo.Text <> '' then
  begin
  try
    sql := ' SELECT User_Codigo, User_Login, User_Senha FROM usuario WHERE User_Codigo = '+Edit_codigo.Text;
    dmConexao.ExecSQL(sql, carrega);
    if carrega.IsEmpty then
    begin
    cancelar;
    Edit_codigo.Text := getUltimoID;
    end else
    begin
    Edit_codigo.Text := carrega.FieldByName('User_Codigo').AsString;
    Edit_login.Text := carrega.FieldByName('User_Login').AsString;
    Edit_senha.Text := carrega.FieldByName('User_Senha').AsString;
    end;
  finally
    FreeAndNil(carrega);
  end;
  end else
  begin
   cancelar;
  end;
end;

procedure TForm_cadLogin.Edit_codigoKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#8]) then Abort;
end;

procedure TForm_cadLogin.loadTela(id: string);
var
  carrega: TFDQuery;
begin
  carrega := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL('SELECT User_Codigo, User_Login, User_Senha FROM usuario WHERE User_Codigo = '
      + id, carrega);
    Edit_codigo.Text := carrega.FieldByName('User_Codigo').AsString;
    Edit_login.Text := carrega.FieldByName('User_Login').AsString;
    Edit_senha.Text := carrega.FieldByName('User_Senha').AsString;
  finally
    FreeAndNil(carrega);
  end;
end;

function TForm_cadLogin.getUltimoID: String;
var
  existe: TFDQuery;
begin
  existe := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL
      ('SELECT COALESCE(MAX(User_Codigo)+1, 1) AS User_Codigo FROM usuario', existe);
    Result := existe.FieldByName('User_Codigo').AsString;
  finally
    FreeAndNil(existe);
  end;
end;

function TForm_cadLogin.existe_login(codigo: string): Boolean;
var
  excist: TFDQuery;
begin
  excist := TFDQuery.Create(Self);
  try
    dmConexao.ExecSQL
      ('SELECT * FROM usuario WHERE User_Codigo =  ' +
      StrToSQL(codigo), excist);
    Result := not excist.IsEmpty;
  finally
    FreeAndNil(excist);
  end;
end;

function TForm_cadLogin.validarCampos: Boolean;
begin
  Result := False;
    if Edit_codigo.Text = '' then
  begin
    Application.MessageBox(PCHAR('Informe o c�digo.'),
      'Aten��o, campo vazio!', MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Edit_codigo.SetFocus;
  end
  else if Edit_senha.Text = '' then
  begin
    Application.MessageBox(PCHAR('Informe a senha.'),
      'Aten��o, campo vazio!', MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Edit_senha.SetFocus;
  end
  else if Edit_login.Text = '' then
  begin
    Application.MessageBox(PCHAR('Informe o login.'),
      'Aten��o, necess�rio informar um documento!', MB_ICONWARNING + MB_OK + MB_TASKMODAL);
    Edit_login.SetFocus;
  end
  else
  begin
    Result := True;
  end;
end;

function TForm_cadLogin.gravar: Boolean;
var
  sql : String;
begin
  if not validarCampos then
  begin
    Result := False;
    Exit;
  end;
  begin
    if existe_login(Edit_codigo.Text) then
    begin
      sql := 'UPDATE usuario '+
             ' SET User_Login = '+StrToSQL(Edit_login.Text)+
             ' ,User_Senha = '+StrToSQL(Edit_Senha.Text)+
            ' WHERE User_Codigo ='+Edit_codigo.Text;

    dmConexao.ExecSQL(sql);
    Application.MessageBox(PCHAR('Cadastro alterado com sucesso.'),'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
    end
    else
    begin
      if not existe_login(Edit_codigo.Text) then
      begin
      sql := (' INSERT INTO usuario'+
           '(User_Login, User_Senha)'+
      ' VALUES'+
           '('+StrToSQL(Edit_login.Text)+','+StrToSQL(Edit_Senha.Text)+')');
        dmConexao.ExecSQL(sql);
        Application.MessageBox(PCHAR('Cadastro incluso com sucesso.'),
            'Aten��o.', MB_ICONINFORMATION + MB_OK + MB_TASKMODAL);
      end
      else
      begin
        Application.MessageBox(PCHAR('O produto ' + Edit_login.Text +
          ' j� est� cadastrado.'), 'Aten��o, verifique seus produtos!',
          MB_ICONWARNING + MB_OK + MB_TASKMODAL);
        Edit_login.SetFocus;
      end;
    end;
    cancelar;
  end;
end;


procedure TForm_cadLogin.BitBtn_cancelarClick(Sender: TObject);
begin
  cancelar;
end;

procedure TForm_cadLogin.BitBtn_confirmarClick(Sender: TObject);
begin
  gravar;
end;

procedure TForm_cadLogin.BitBtn_excluirClick(Sender: TObject);
begin
  excluir;
end;

procedure TForm_cadLogin.BitBtn_pesquisarClick(Sender: TObject);
begin
  Form_pesLogin := TForm_pesLogin.Create(Application);
  try
    if Form_pesLogin.ShowModal = mrOk then
      loadTela(Form_pesLogin.FDQuery1.FieldByName('User_Codigo').AsString);
  finally
    FreeAndNil(Form_pesLogin);
  end;
end;

procedure TForm_cadLogin.BitBtn_voltarClick(Sender: TObject);
begin
  Form_cadLogin.Close;
end;

procedure TForm_cadLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CaFree;
  Release;
  Form_cadLogin := nil;
end;

procedure TForm_cadLogin.FormCreate(Sender: TObject);
begin
  Edit_codigo.Text := getUltimoID;
end;

end.
