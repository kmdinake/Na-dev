program Project1;

uses
  Forms,
  uLogin in 'uLogin.pas' {frmLogin},
  uMain in 'uMain.pas' {frmMain},
  uNewParcel in 'uNewParcel.pas' {frmNewParcel},
  uParcel in 'uParcel.pas',
  uSearch in 'uSearch.pas' {frmSearch},
  dmParcel in 'dmParcel.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSearch, frmSearch);
  Application.CreateForm(TfrmNewParcel, frmNewParcel);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.                             
