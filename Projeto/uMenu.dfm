﻿object Crud: TCrud
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Crud'
  ClientHeight = 393
  ClientWidth = 737
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    OwnerDraw = True
    Left = 176
    Top = 200
    object C1: TMenuItem
      Caption = 'Cadastros'
      object Clientes1: TMenuItem
        Caption = 'Clientes'
        OnClick = Clientes1Click
      end
      object Produtos1: TMenuItem
        Caption = 'Produtos'
        OnClick = Produtos1Click
      end
      object Usuário: TMenuItem
        Caption = 'Usu'#225'rio'
        OnClick = UsuárioClick
      end
    end
    object Lanamento1: TMenuItem
      Caption = 'Lan'#231'amento'
      object PedidodeVenda1: TMenuItem
        Caption = 'Pedido de Venda'
        OnClick = PedidodeVenda1Click
      end
    end
    object Consultas1: TMenuItem
      Caption = 'Pesquisar'
      object Pedidos1: TMenuItem
        Caption = 'Pedidos'
        OnClick = Pedidos1Click
      end
    end
    object Sair1: TMenuItem
      Caption = 'Sair'
      OnClick = Sair1Click
    end
  end
end
