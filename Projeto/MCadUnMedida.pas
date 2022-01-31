unit MCadUnMedida;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TForm_CadUnMedida = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn_Confirmar: TBitBtn;
    BitBtn_pesquisar: TBitBtn;
    BitBtn_voltar: TBitBtn;
    BitBtn_excluir: TBitBtn;
    BitBtn_cancelar: TBitBtn;
    Label_descricao: TLabel;
    Edit_descricao: TEdit;
    Edit_sigla: TEdit;
    Label_sigla: TLabel;
    procedure BitBtn_voltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_CadUnMedida: TForm_CadUnMedida;

implementation

{$R *.dfm}

procedure TForm_CadUnMedida.BitBtn_voltarClick(Sender: TObject);
begin
   Form_CadUnMedida.Close;
end;

procedure TForm_CadUnMedida.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := CaFree;
  Release;
  Form_CadUnMedida := nil;
end;

end.
