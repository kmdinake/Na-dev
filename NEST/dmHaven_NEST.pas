unit dmHaven_NEST;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TdmHaven = class(TDataModule)
    ADOConnection1: TADOConnection;
    tblCLIENTS: TADOTable;
    tblEMPLOYEE: TADOTable;
    tblEVENTS: TADOTable;
    tblSPONSERS: TADOTable;
    tblSPONSERSHIPS: TADOTable;
    dsCLIENTS: TDataSource;
    dsEMPLOYEE: TDataSource;
    dsEVENTS: TDataSource;
    dsSPONSERS: TDataSource;
    dsSPONSERSHIPS: TDataSource;
    dsGoing: TDataSource;
    dsNotGoing: TDataSource;
    tblClientsGoing: TADOTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmHaven: TdmHaven;

implementation

{$R *.dfm}

end. {Developed by K.M. Dinake ©}
