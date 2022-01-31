object dmConexao: TdmConexao
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 225
  Width = 518
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=TESTE_VISUALSOFTWARE'
      'User_Name=sa'
      'Password=root'
      'Server=localhost\SQLEXPRESS'
      'DriverID=MSSQL')
    LoginPrompt = False
    Left = 80
    Top = 88
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 160
    Top = 88
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrNone
    Left = 256
    Top = 88
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 360
    Top = 96
  end
end
