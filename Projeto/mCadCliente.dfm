object Form_CadCliente: TForm_CadCliente
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Cadastro de cliente'
  ClientHeight = 282
  ClientWidth = 517
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 417
    Height = 282
    Align = alLeft
    Color = cl3DLight
    ParentBackground = False
    TabOrder = 0
    object Label_nome: TLabel
      Left = 16
      Top = 67
      Width = 27
      Height = 13
      Caption = 'Nome'
    end
    object Label_cpf: TLabel
      Left = 16
      Top = 113
      Width = 19
      Height = 13
      Caption = 'CPF'
    end
    object Label_cidade: TLabel
      Left = 16
      Top = 156
      Width = 33
      Height = 13
      Caption = 'Cidade'
    end
    object Label_UF: TLabel
      Left = 200
      Top = 160
      Width = 13
      Height = 13
      Caption = 'UF'
    end
    object Label_codCliente: TLabel
      Left = 16
      Top = 16
      Width = 69
      Height = 13
      Caption = 'C'#243'digo Cliente'
    end
    object Label1: TLabel
      Left = 137
      Top = 113
      Width = 25
      Height = 13
      Caption = 'CNPJ'
    end
    object Edit_nome: TEdit
      Left = 16
      Top = 86
      Width = 342
      Height = 21
      TabOrder = 1
    end
    object Edit_cidade: TEdit
      Left = 16
      Top = 175
      Width = 161
      Height = 21
      TabOrder = 4
    end
    object Edit_uf: TEdit
      Left = 197
      Top = 175
      Width = 35
      Height = 21
      TabOrder = 5
    end
    object Edit_codCliente: TEdit
      Left = 16
      Top = 34
      Width = 69
      Height = 21
      TabOrder = 0
      OnExit = Edit_codClienteExit
      OnKeyPress = Edit_codClienteKeyPress
    end
    object MaskEdit_cpf: TMaskEdit
      Left = 16
      Top = 132
      Width = 89
      Height = 21
      EditMask = '999.999.999-99;1;_'
      MaxLength = 14
      TabOrder = 2
      Text = '   .   .   -  '
    end
    object MaskEdit_cnpj: TMaskEdit
      Left = 137
      Top = 132
      Width = 112
      Height = 21
      EditMask = '99.999.999/9999-99;1;_'
      MaxLength = 18
      TabOrder = 3
      Text = '  .   .   /    -  '
    end
    object RadioGroup1: TRadioGroup
      Left = 111
      Top = 16
      Width = 90
      Height = 59
      Caption = 'Tipo'
      ItemIndex = 0
      Items.Strings = (
        'F'#237'sica '
        'Jur'#237'dica')
      TabOrder = 6
      OnClick = RadioGroup1Click
    end
  end
  object Panel2: TPanel
    Left = 416
    Top = 0
    Width = 101
    Height = 282
    Align = alRight
    TabOrder = 1
    object BitBtn_Cancelar: TBitBtn
      Left = 1
      Top = 34
      Width = 99
      Height = 33
      Align = alTop
      Caption = 'Cancelar'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000020000000C05031A46110852AB190C76E31D0E89FF1C0E89FF190C
        76E4120852AD06031B4D0000000E000000030000000000000000000000000000
        000301010519130A55A9211593FF2225AEFF2430C2FF2535CBFF2535CCFF2430
        C3FF2225AFFF211594FF140B58B20101051E0000000400000000000000020101
        03151C1270CD2522A6FF2D3DCCFF394BD3FF3445D1FF2939CDFF2839CDFF3344
        D0FF394AD4FF2D3CCDFF2523A8FF1C1270D20101051D00000003000000091912
        5BA72A27AAFF2F41D0FF3541C7FF2726ABFF3137BCFF384AD3FF384BD3FF3137
        BCFF2726ABFF3540C7FF2E40D0FF2927ACFF1A115EB10000000D08061C3D3129
        A2FD2C3CCCFF3842C6FF5F5DBDFFEDEDF8FF8B89CEFF3337B9FF3437B9FF8B89
        CEFFEDEDF8FF5F5DBDFF3741C6FF2B3ACDFF3028A4FF0907204A1E185F9F373B
        BCFF3042D0FF2621A5FFECE7ECFFF5EBE4FFF8F2EEFF9491D1FF9491D1FFF8F1
        EDFFF3E9E2FFECE6EBFF2621A5FF2E3FCFFF343ABEFF201A66B0312A92E03542
        CBFF3446D1FF2C2FB5FF8070ADFFEBDBD3FFF4EAE4FFF7F2EDFFF8F1EDFFF4E9
        E2FFEADAD1FF7F6FACFF2B2EB5FF3144D0FF3040CBFF312A95E53E37AEFA3648
        D0FF374AD3FF3A4ED5FF3234B4FF8A7FB9FFF6ECE7FFF5ECE6FFF4EBE5FFF6EB
        E5FF897DB8FF3233B4FF384BD3FF3547D2FF3446D1FF3E37AEFA453FB4FA4557
        D7FF3B50D5FF4C5FDAFF4343B7FF9189C7FFF7EFE9FFF6EEE9FFF6EFE8FFF7ED
        E8FF9087C5FF4242B7FF495DD8FF394CD4FF3F52D4FF443FB3FA403DA1DC5967
        DAFF5B6EDDFF4F4DBAFF8F89CAFFFBF6F4FFF7F1ECFFEDE1D9FFEDE0D9FFF7F0
        EAFFFAF5F2FF8F89CAFF4E4DB9FF576ADCFF5765D9FF403EA4E12E2D70987C85
        DDFF8798E8FF291D9BFFE5DADEFFF6EEEBFFEDDFDAFF816EA9FF816EA9FFEDDF
        D8FFF4ECE7FFE5D9DCFF291D9BFF8494E7FF7A81DDFF33317BAC111125356768
        D0FC9EACEDFF686FCEFF5646A1FFCCB6BCFF7A68A8FF4C4AB6FF4D4BB7FF7A68
        A8FFCBB5BCFF5646A1FF666DCCFF9BAAEEFF696CD0FD1212273F000000043B3B
        79977D84DFFFA5B6F1FF6D74D0FF2D219BFF5151B9FF8EA2ECFF8EA1ECFF5252
        BBFF2D219BFF6B72D0FFA2B3F0FF8086E0FF404183A700000008000000010303
        050C4E509DBC8087E2FFAEBDF3FFA3B6F1FF9DAFF0FF95A9EEFF95A8EEFF9BAD
        EFFFA2B3F0FFACBCF3FF838AE3FF4F52A0C10303051100000002000000000000
        000100000005323464797378D9F8929CEAFFA1AEEFFFB0BFF3FFB0BFF4FFA2AE
        EFFF939DE9FF7479DAF83234647D000000080000000200000000000000000000
        000000000000000000031213232D40437D935D61B5D07378DFFC7378DFFC5D61
        B5D040437D951212223000000004000000010000000000000000}
      TabOrder = 1
      OnClick = BitBtn_CancelarClick
    end
    object BitBtn_confirmar: TBitBtn
      Left = 1
      Top = 1
      Width = 99
      Height = 33
      Align = alTop
      Caption = 'Confirmar'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        00000000000000000002000000070000000C0000001000000012000000110000
        000E000000080000000200000000000000000000000000000000000000000000
        000100000004000101120D2A1D79184E36C6216B4BFF216B4BFF216C4BFF1A53
        3AD20F2F21840001011500000005000000010000000000000000000000000000
        0005050F0A351C5B40DC24805CFF29AC7EFF2CC592FF2DC894FF2DC693FF2AAE
        80FF258560FF1A563DD405110C3D00000007000000010000000000000003040E
        0A31206548ED299D74FF2FC896FF2EC996FF56D4ACFF68DAB5FF3BCD9DFF30C9
        96FF32CA99FF2BA479FF227050F805110C3D00000005000000000000000A1A57
        3DD02EA57CFF33CA99FF2EC896FF4CD2A8FF20835CFF00673BFF45BE96FF31CB
        99FF31CB98FF34CC9CFF31AD83FF1B5C41D300010113000000020B23185E2E8A
        66FF3BCD9EFF30CA97FF4BD3A9FF349571FF87AF9DFFB1CFC1FF238A60FF45D3
        A8FF36CF9FFF33CD9BFF3ED0A3FF319470FF0F32237F00000007184D37B63DB3
        8CFF39CD9FFF4BD5A9FF43A382FF699782FFF8F1EEFFF9F3EEFF357F5DFF56C4
        A1FF43D5A8FF3ED3A4FF3CD1A4FF41BC95FF1B5C43CD0000000B1C6446DF4BCA
        A4FF44D2A8FF4FB392FF4E826AFFF0E9E6FFC0C3B5FFEFE3DDFFCEDDD4FF1B75
        4FFF60DCB8FF48D8ACFF47D6AAFF51D4ACFF247A58F80000000E217050F266D9
        B8FF46D3A8FF0B6741FFD2D2CBFF6A8F77FF116B43FF73967EFFF1E8E3FF72A2
        8BFF46A685FF5EDFBAFF4CD9AFFF6BE2C2FF278460FF020604191E684ADC78D9
        BEFF52DAB1FF3DBA92FF096941FF2F9C76FF57DEB8FF2D9973FF73967EFFF0EA
        E7FF4F886CFF5ABB9AFF5BDEB9FF7FE2C7FF27835FF80000000C19523BAB77C8
        B0FF62E0BCFF56DDB7FF59DFBAFF5CE1BDFF5EE2BEFF5FE4C1FF288C67FF698E
        76FFE6E1DCFF176B47FF5FD8B4FF83D5BDFF1E674CC60000000909201747439C
        7BFF95ECD6FF5ADFBAFF5EE2BDFF61E4BFFF64E6C1FF67E6C5FF67E8C7FF39A1
        7EFF1F6D4AFF288B64FF98EFD9FF4DAC8CFF1036286D00000004000000041C5F
        46B578C6ADFF9AEED9FF65E5C0FF64E7C3FF69E7C6FF6BE8C8FF6CE9C9FF6BEA
        C9FF5ED6B6FF97EDD7FF86D3BBFF237759D20102010C0000000100000001030A
        0718247B5BDA70C1A8FFB5F2E3FF98F0DAFF85EDD4FF75EBCEFF88EFD6FF9CF2
        DDFFBAF4E7FF78CDB3FF2A906DEA0615102E0000000200000000000000000000
        0001030A07171E694FB844AB87FF85D2BBFFA8E6D6FFC5F4EBFFABE9D8FF89D8
        C1FF4BB692FF237F60CB05130E27000000030000000000000000000000000000
        000000000001000000030A241B411B60489D258464CF2C9D77EE258867CF1F71
        56B00E3226560000000600000002000000000000000000000000}
      TabOrder = 0
      OnClick = BitBtn_confirmarClick
    end
    object BitBtn_Pesquisar: TBitBtn
      Left = 1
      Top = 100
      Width = 99
      Height = 33
      Align = alTop
      Caption = 'Pesquisar'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000040000000A000000100000001300000015000000140000
        00110000000C0000000500000001000000000000000000000000000000000000
        00030000000C070404263F271F836E4235CA7A4839DE915644FF774436DE693C
        30CE3A2019870704032B00000010000000040000000000000000000000030000
        0011442C2486976253F5BE998EFFD9C5BEFFE0CFCAFFEFE6E3FFDDCAC4FFD3BC
        B5FFB48B7FFF895140F540231B92000000180000000500000001010204145536
        2D9CC5A398FFF2E9E7FFF5EFEDFFBCAEA8FF71574CFF593A2DFF755B4EFFBEAE
        A7FFEBE2DEFFE5D8D3FFB79085FF4E2A21A90101021A000000032F23246BB58D
        80FFF9F5F4FFF7F3F2FFC1B3ADFF826555FFB19A85FFC2AC97FFB09783FF7F62
        51FFC0B0A9FFECE3DFFFECE2DFFFA37467FF28191A750000000A5E4F60E1BCB1
        ACFFF6F3F3FFF8F4F3FF7A5E50FFBEA995FF857162FF3F2A22FF746053FFB8A3
        8FFF806658FFEEE5E2FFECE2DFFFB1A29CFF503F50E40000000D182C4D885C63
        72FFB2B0B0FFF1EEEDFF725242FFDDD1B9FF806D5EFF493229FF493228FFCFC0
        A9FF745545FFEBE3E1FFABA6A3FF505566FF142A55AA0000000A05080F21395F
        9DFA697F9AFF626160FF55443CFFB2A894FFE4E0C1FF584135FF847466FFA498
        87FF58483FFF5F5C5CFF4E6586FF2F5191FF050B173C00000004000000031221
        3B685A7FB7FFA6C5E3FF7990ABFF444D59FF3E4248FF2B2A25FF3C4148FF3E48
        56FF627D9EFF789DC9FF3C609FFD0B172E630000000600000000000000000000
        00030F1B3159315593ED6F91C1FF9BB9DCFFB0CDE9FFCBE8FCFFA7C7E6FF87AA
        D3FF5A7EB3FF284B8BF10A152958000000060000000100000000000000000000
        0000000000020204071112223E6F1C3765B0213F76D0274C91FC1E3C74D01933
        62B40F1F3D750204081700000003000000000000000000000000000000000000
        0000000000000000000000000002000000030000000400000005000000050000
        0004000000020000000100000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      TabOrder = 3
      OnClick = BitBtn_PesquisarClick
    end
    object BitBtn_voltar: TBitBtn
      Left = 1
      Top = 248
      Width = 99
      Height = 33
      Align = alBottom
      Caption = 'Sair'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000B8824DFFAE7B
        49F1A17243DF805A35B149331E65060503090000000000000000000000000000
        0000000000000000000000000000000000000000000000000000B8824DFFB882
        4DFFB8824DFFB8824DFFB8824DFFA57445E42A1E123A00000000000000000000
        0000000000000000000000000000000000000000000000000000B8824DFFB882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFAF7C49F319110A22000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000E0A06132F2114418F653CC6B8824DFFB8824DFF704F2F9B000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000001A120B24B8824DFFB8824DFFA17243DF000000000000
        0000000000000A07040E8B623AC1B8824DFFB7814DFE4F38216D000000000000
        0000000000000000000000000000B8824DFFB8824DFFB07C4AF4000000000000
        00000D09051292673DCAB8824DFFB7814DFE4A351F6700000000000000000000
        0000000000000000000018110A21B8824DFFB8824DFFA27244E000000000110C
        0717986B3FD2B8824DFFB6804CFC45311D600000000000000000000000000000
        00000403020523190F318D633BC3B8824DFFB8824DFF71502F9D160F091E9C6E
        41D8B8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB07C4AF41A120B24896139BEB882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB882
        4DFFB8824DFFB8824DFFB8824DFFA77646E82C1F123D00000000120D0819996C
        40D4B8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB07C
        4AF4A27344E1825C36B44C36206A0A07040E0000000000000000000000000D09
        051291663DC9B8824DFFB7814DFE49331E650000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000907040D886039BDB8824DFFB7814DFE4C36206A00000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000060402087F5A35B0B8824DFFB7814DFE5039226F000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      TabOrder = 4
      OnClick = BitBtn_voltarClick
    end
    object BitBtn_excluir: TBitBtn
      Left = 1
      Top = 67
      Width = 99
      Height = 33
      Align = alTop
      Caption = 'Excluir'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000001000000030000
        0007000000060000000300000006000000080000000400000001000000000000
        00000000000000000000000000000000000000000000000000030B082C4D2619
        99EA110A58A2010003160F0855A3160C7EEA0603244F00000004000000000000
        0001000000060000000A0000000B0000000B0000000B000000112E23A2EA6F85
        EAFF4150CBFF1F1689E63B48C9FF5C74E4FF180E82E700000007000000000000
        000680574CBDB37B69FFB37A68FFB37A68FFB27968FFDCC6BEFF756BC0FF7780
        DDFF6D8BEFFF5872E5FF6381EDFF6972D8FF1A13659F00000005000000000000
        0008B57D6BFFFBF7F3FFFBF6F3FFFBF6F3FFFBF5F2FFFAF5F3FFEFECEFFF4D46
        BDFF6A85EBFF7494F2FF6079E7FF262094E40101041300000002000000000000
        0008B67F6DFFFCF8F5FFF8EFECFFF7EEEAFFF7EEEAFFF9F5F3FF807DD4FF6B7E
        E2FF93B0F6FFA0B3F2FF8AA6F4FF5D6EDBFF1C186AA000000004000000000000
        0008B8826FFFFCF9F6FFF8F0ECFFF8F0ECFFF7EFECFFFAF8F7FF6261D8FFB1C3
        F6FF8D99EAFF5F5DD2FF8995E7FFA6B8F3FF3B35AEE300000004000000000000
        0007BA8473FFFDF9F8FFF8F1EEFFF8F0EDFFF8F0ECFFFAF5F3FFCECDEEFF6564
        DEFF9291E2FFF2F1F3FF8982D3FF4340BCE71212334600000002000000000000
        0007BB8776FFFDFBF9FFF9F1EFFFF9F2EEFFF8F1EEFFF8F0EDFFFAF5F3FFFAF8
        F7FFFAF7F6FFFCF9F8FFE3CFC9FF0000000C0000000200000000000000000000
        0006BD8A78FFFDFBFAFFF9F2F0FFF9F2F0FFF8F2EFFFF9F1EFFFF8F1EEFFF9F1
        EEFFF8F0EDFFFDFAF8FFBB8675FF000000080000000000000000000000000000
        0006BF8D7BFFFEFCFBFFFAF4F1FFFAF4F1FFFAF2F1FFFAF2F0FFF9F2EFFFF9F2
        EEFFF8F1EEFFFDFBF9FFBD8978FF000000080000000000000000000000000000
        0005C39381FFFEFDFDFFFBF6F4FFFBF5F4FFFBF4F2FFFAF4F2FFFAF4F1FFF9F3
        F1FFFAF3F1FFFEFCFBFFC18F7EFF000000070000000000000000000000000000
        0004C69887FFFFFEFEFFFBF7F6FFFCF6F6FFFBF6F5FFFBF6F4FFFBF5F4FFFAF5
        F3FFFAF5F3FFFEFDFDFFC59684FF000000060000000000000000000000000000
        0003C99B8AFFFFFEFEFFFBF7F6FFFCF7F6FFFCF6F5FFFBF6F5FFFCF6F5FFFBF5
        F5FFFBF6F4FFFFFEFEFFC79887FF000000050000000000000000000000000000
        0003CA9E8DFFFFFFFFFFFFFFFFFFFFFFFEFFFFFEFEFFFFFEFEFFFFFEFEFFFFFE
        FEFFFFFEFEFFFFFEFEFFC99B8AFF000000040000000000000000000000000000
        00029B7F74BFD0AB9CFFD0AB9CFFD0AA9CFFCFA99BFFCFA99AFFCFA999FFCFA8
        99FFCEA899FFCFA898FF997B71C0000000030000000000000000}
      TabOrder = 2
      OnClick = BitBtn_excluirClick
    end
  end
  object FDQuery1: TFDQuery
    Left = 464
    Top = 168
  end
end
