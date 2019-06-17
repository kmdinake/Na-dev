program NEST;

uses
  sysUtils,
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uClientControl in 'uClientControl.pas' {frmAddPerson},
  uLogin in 'uLogin.pas' {frmLogin},
  uPasswordRecovery in 'uPasswordRecovery.pas' {frmPasswordRecovery},
  uAdminCentre in 'uAdminCentre.pas' {frmAdminCentre},
  uSplashscreen in 'uSplashscreen.pas' {Splashscreen},
  dmHaven_NEST in 'dmHaven_NEST.pas' {dmHaven: TDataModule},
  uRecoveryClass in 'uRecoveryClass.pas',
  uCheckIO in 'uCheckIO.pas' {frmCheckLog};

{$R *.res}

begin
  Application.Initialize;
  Splashscreen := TSplashscreen.Create(nil);
  Splashscreen.Show;
  Splashscreen.Update;
  sleep(2000);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmAddPerson, frmAddPerson);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmPasswordRecovery, frmPasswordRecovery);
  Application.CreateForm(TfrmAdminCentre, frmAdminCentre);
  Application.CreateForm(TdmHaven, dmHaven);
  Application.CreateForm(TfrmCheckLog, frmCheckLog);
  Splashscreen.Hide;
  Splashscreen.Free;
  Application.Run;

end. {Developed by K.M. Dinake ©}
