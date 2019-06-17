object DataModule1: TDataModule1
  OldCreateOrder = False
  Left = 465
  Top = 228
  Height = 344
  Width = 440
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dbParcel.mdb;Persis' +
      't Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 136
    Top = 96
  end
  object qrySaveToFile: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 128
    Top = 32
  end
  object dsParcel: TDataSource
    DataSet = tblParcel
    Left = 32
    Top = 104
  end
  object tblParcel: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'PARCEL'
    Left = 32
    Top = 32
    object tblParcelParcelNo: TAutoIncField
      FieldName = 'ParcelNo'
      ReadOnly = True
    end
    object tblParcelStudentNo: TWideStringField
      FieldName = 'StudentNo'
      Size = 10
    end
    object tblParcelParcelBearerName: TWideStringField
      DisplayWidth = 30
      FieldName = 'ParcelBearerName'
      Size = 255
    end
    object tblParcelRelation: TWideStringField
      FieldName = 'Relation'
    end
    object tblParcelParcelDescription: TWideStringField
      DisplayWidth = 45
      FieldName = 'ParcelDescription'
      Size = 255
    end
    object tblParcelDateReceived: TDateTimeField
      FieldName = 'DateReceived'
    end
    object tblParcelDateCollected: TDateTimeField
      FieldName = 'DateCollected'
    end
    object tblParcelCategory: TWideStringField
      DisplayWidth = 10
      FieldName = 'Category'
      Size = 255
    end
    object tblParcelisCollected: TBooleanField
      FieldName = 'isCollected'
    end
    object tblParcelReceivedBy: TWideStringField
      DisplayWidth = 10
      FieldName = 'ReceivedBy'
      Size = 255
    end
    object tblParcelCheckedOutBy: TWideStringField
      FieldName = 'CheckedOutBy'
    end
  end
  object qStudentNo: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 240
    Top = 40
  end
  object qParcelDesc: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 200
    Top = 192
  end
  object dsParcelDesc: TDataSource
    DataSet = qParcelDesc
    Left = 104
    Top = 176
  end
  object dsStudentNo: TDataSource
    DataSet = qStudentNo
    Left = 32
    Top = 176
  end
end
