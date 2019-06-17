unit dmParcel;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TDataModule1 = class(TDataModule)
    ADOConnection1: TADOConnection;
    qrySaveToFile: TADOQuery;
    dsParcel: TDataSource;
    tblParcel: TADOTable;
    tblParcelParcelNo: TAutoIncField;
    tblParcelStudentNo: TWideStringField;
    tblParcelParcelBearerName: TWideStringField;
    tblParcelRelation: TWideStringField;
    tblParcelParcelDescription: TWideStringField;
    tblParcelDateReceived: TDateTimeField;
    tblParcelDateCollected: TDateTimeField;
    tblParcelCategory: TWideStringField;
    tblParcelisCollected: TBooleanField;
    tblParcelReceivedBy: TWideStringField;
    qStudentNo: TADOQuery;
    qParcelDesc: TADOQuery;
    dsParcelDesc: TDataSource;
    dsStudentNo: TDataSource;
    tblParcelCheckedOutBy: TWideStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

end.
