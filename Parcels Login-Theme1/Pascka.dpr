program Pascka;

uses
  Forms,
  System.SysUtils,
  uLogin in 'uLogin.pas' {frmLogin},
  uMain in 'uMain.pas' {frmMain},
  uNewParcel in 'uNewParcel.pas' {frmNewParcel},
  uParcel in 'uParcel.pas',
  uSearch in 'uSearch.pas' {frmSearch},
  dmParcel in 'dmParcel.pas' {DataModule1: TDataModule},
  Vcl.Themes,
  Vcl.Styles,
  uSplashscreen in 'uSplashscreen.pas' {Splashscreen};

{$R *.res}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Charcoal Dark Slate');
  Splashscreen:=TSplashscreen.Create(nil);
  Application.CreateForm(TDataModule1, DataModule1);
  Splashscreen.Show;
  Splashscreen.Update;
  sleep(2000);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSearch, frmSearch);
  Application.CreateForm(TfrmNewParcel, frmNewParcel);
  Splashscreen.Hide;
  //Splashscreen.Close;
  Application.Run;
end.                             
