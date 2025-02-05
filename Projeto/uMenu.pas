unit uMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, consPedidos, Vcl.Menus, mCadProduto, mCadCliente, MCadUnMedida, mLanPedido, mCadLogin, Login;

type
  TCrud = class(TForm)
    MainMenu1: TMainMenu;
    C1: TMenuItem;
    Consultas1: TMenuItem;
    Lanamento1: TMenuItem;
    Clientes1: TMenuItem;
    Produtos1: TMenuItem;
    PedidodeVenda1: TMenuItem;
    Pedidos1: TMenuItem;
    Sair1: TMenuItem;
    Usuário: TMenuItem;
    procedure Produtos1Click(Sender: TObject);
    procedure Clientes1Click(Sender: TObject);
    procedure UnMedida1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure PedidodeVenda1Click(Sender: TObject);
    procedure Pedidos1Click(Sender: TObject);
    procedure UsuárioClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Crud: TCrud;

implementation

{$R *.dfm}

procedure TCrud.Clientes1Click(Sender: TObject);
begin
  if not Assigned(Form_CadCliente) then
  begin
    Form_CadCliente := TForm_CadCliente.Create(Application);
  end;
  Form_CadCliente.Show;
end;

procedure TCrud.FormShow(Sender: TObject);
begin
 if not Assigned(Form_Login) then
  begin
    Form_Login := TForm_Login.Create(Self);
  end;
  while (Form_Login.ShowModal = mrOk) do
 begin
   FreeAndNil(Form_Login);
   Break;
  end;
  if Form_Login <> nil then
   Application.Terminate;
end;

procedure TCrud.PedidodeVenda1Click(Sender: TObject);
begin
  if not Assigned(Form_mLanPedido) then
  begin
    Form_mLanPedido := TForm_mLanPedido.Create(Application);
  end;
  Form_mLanPedido.Show;
end;

procedure TCrud.Pedidos1Click(Sender: TObject);
begin
  if not Assigned(Form_consultaPedidos) then
  begin
    Form_consultaPedidos := TForm_consultaPedidos.Create(Application);
  end;
  Form_consultaPedidos.Show;
end;

procedure TCrud.Produtos1Click(Sender: TObject);
begin
  if not Assigned(Form_CadProduto) then
  begin
    Form_CadProduto := TForm_CadProduto.Create(Application);
  end;
  Form_CadProduto.Show;
end;

procedure TCrud.Sair1Click(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TCrud.UnMedida1Click(Sender: TObject);
begin
  if not Assigned(Form_CadUnMedida) then
  begin
    Form_CadUnMedida := TForm_CadUnMedida.Create(Application);
  end;
  Form_CadUnMedida.Show;
end;

procedure TCrud.UsuárioClick(Sender: TObject);
begin
  if not Assigned(Form_cadLogin) then
  begin
    Form_cadLogin := TForm_cadLogin.Create(Application);
  end;
  Form_cadLogin.Show;
end;

end.
