object dmHaven: TdmHaven
  OldCreateOrder = False
  Left = 450
  Top = 129
  Height = 477
  Width = 657
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dbHaven.mdb;Persist' +
      ' Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 32
    Top = 24
  end
  object tblCLIENTS: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'CLIENTS'
    Left = 104
    Top = 24
  end
  object tblEMPLOYEE: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'EMPLOYEE'
    Left = 184
    Top = 24
  end
  object tblEVENTS: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'EVENTS'
    Left = 264
    Top = 24
  end
  object tblSPONSERS: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'SPONSERS'
    Left = 32
    Top = 80
  end
  object tblSPONSERSHIPS: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'SPONSERSHIPS'
    Left = 144
    Top = 136
  end
  object dsCLIENTS: TDataSource
    DataSet = tblCLIENTS
    Left = 104
    Top = 80
  end
  object dsEMPLOYEE: TDataSource
    DataSet = tblEMPLOYEE
    Left = 184
    Top = 80
  end
  object dsEVENTS: TDataSource
    DataSet = tblEVENTS
    Left = 264
    Top = 80
  end
  object dsSPONSERS: TDataSource
    DataSet = tblSPONSERS
    Left = 32
    Top = 136
  end
  object dsSPONSERSHIPS: TDataSource
    DataSet = tblSPONSERSHIPS
    Left = 264
    Top = 136
  end
  object dsGoing: TDataSource
    DataSet = tblClientsGoing
    Left = 352
    Top = 88
  end
  object dsNotGoing: TDataSource
    Left = 432
    Top = 96
  end
  object tblClientsGoing: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'CLIENTS'
    Left = 360
    Top = 24
  end
end
