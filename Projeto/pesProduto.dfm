object Form_pesProduto: TForm_pesProduto
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Relat'#243'rio de Usu'#225'rios'
  ClientHeight = 478
  ClientWidth = 603
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 23
    Width = 603
    Height = 391
    Align = alClient
    TabOrder = 0
    object DBGrid1: TDBGrid
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 595
      Height = 383
      Align = alClient
      DataSource = DataSource1
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = DBGrid1DblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'Pro_Codigo'
          Title.Caption = 'C'#243'd. Produto'
          Width = 68
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Pro_Descricao'
          Title.Caption = 'Descri'#231#227'o'
          Width = 144
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Pro_CodBar'
          Title.Caption = 'C'#243'd. Barras'
          Width = 111
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Pro_QtdEstoque'
          Title.Caption = 'Qtd. Estoque'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Pro_Unidade'
          Title.Caption = 'Un. Medida'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Pro_CstUnitario'
          Title.Caption = 'Cst. Unit'#225'rio'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Pro_CstVenda'
          Title.Caption = 'Cst. Venda'
          Visible = True
        end>
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 603
    Height = 23
    Align = alTop
    AutoSize = True
    TabOrder = 1
    object Label1: TLabel
      Left = 4
      Top = 3
      Width = 217
      Height = 18
      Caption = 'Pesquisar produto por descri'#231#227'o: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edit_pesquisa: TEdit
      Left = 216
      Top = 1
      Width = 373
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 50
      TabOrder = 0
      OnKeyUp = edit_pesquisaKeyUp
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 414
    Width = 603
    Height = 64
    Align = alBottom
    AutoSize = True
    TabOrder = 2
    object button_voltar: TButton
      Left = 1
      Top = 1
      Width = 75
      Height = 62
      Align = alLeft
      Caption = 'Voltar'
      TabOrder = 0
      OnClick = button_voltarClick
    end
    object button_pesquisar: TButton
      Left = 505
      Top = 1
      Width = 97
      Height = 62
      Align = alRight
      Caption = 'Exibir Todos'
      TabOrder = 1
      OnClick = button_pesquisarClick
    end
    object button_limpa: TButton
      Left = 249
      Top = 1
      Width = 88
      Height = 62
      Align = alCustom
      Caption = 'Limpar Pesquisa'
      TabOrder = 2
      OnClick = button_limpaClick
    end
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 487
    Top = 312
  end
  object FDQuery1: TFDQuery
    Left = 487
    Top = 256
  end
end
