unit uLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TfrmLogin = class(TForm)
    lbl1: TLabel;
    lbledtUsername: TLabeledEdit;
    lbledtPassword: TLabeledEdit;
    btnLogin: TBitBtn;
    btnCancelLogin: TBitBtn;
    lblHelp: TLabel;
    lblForgotPassWord: TLabel;
    stat1: TStatusBar;
    procedure btnCancelLoginClick(Sender: TObject);
    procedure lblHelpClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure lblForgotPassWordClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;
  sEmpID  : String;

implementation

uses
  uMain, uClientControl, uPasswordRecovery, uAdminCentre, dmHaven_NEST, uCheckIO;
{$R *.dfm}

procedure TfrmLogin.btnCancelLoginClick(Sender: TObject);
begin
  {Clear/Exit}
  if (MessageDlg('Are you sure you want to exit this application ?', mtConfirmation, [mbYes, mbNo], 1)) = mrYes then
    Application.Terminate
  else
  begin
    lbledtUsername.Clear;
    lbledtUsername.SetFocus;
    lbledtPassword.Clear;
  end;
end;

procedure TfrmLogin.lblHelpClick(Sender: TObject);
begin
  {Help}
  ShowMessage('1: If you forgot your password, click on "Forgot Password".'
                +#13+IntToStr(2)+': How to Login: Enter username and password where required, then click on Login button.'
                +#13+IntToStr(3)+': If problem in 1 persists, then seek help from the program administrator.');
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  sPasscode : String;
begin
  // Initialize:
  stat1.Panels[0].Text := 'Proccesing...';
  Application.ProcessMessages;

  if (Length(lbledtUsername.Text)= 0)  then
  begin
    MessageDlg('Enter your Username!',mtWarning, [mbOK], 0);
    lbledtUsername.SetFocus;
    Exit;
  end;
  if (Length(lbledtPassword.Text)= 0)  then
  begin
    MessageDlg('Enter your Password!',mtWarning, [mbOK], 0);
    lbledtPassword.SetFocus;
    Exit;
  end;

  // Validate Login
  with dmHaven do
  begin
    // Set username and passcode:
    sEmpID    := lbledtUsername.Text;
    sPasscode := lbledtPassword.Text;

    // Filter by Username:
    tblEMPLOYEE.Filtered := False;
    tblEMPLOYEE.Filter   := 'EmpID ='+QuotedStr(sEmpID);
    tblEMPLOYEE.Filtered := True;

    // Check is username exists:
    if tblEMPLOYEE.RecordCount = 0 then
    begin
      MessageDlg('Username does not exist!', mtWarning, [mbOK], 0);
      lbledtUsername.SetFocus;
      Exit;
    end;

    // Incorrect Criteria:
    if sEmpID <> tblEMPLOYEE['EmpID'] then
    begin
      MessageDlg('Incorrect username!', mtWarning, [mbOK], 0);
      lbledtUsername.SetFocus;
      Exit;
    end
    else if sPasscode <> tblEMPLOYEE['Password'] then
    begin
      MessageDlg('Incorrect password!', mtWarning, [mbOK], 0);
      lbledtPassword.SetFocus;
      lblForgotPassWord.Font.Color := clRed;
      Exit;
    end
    else if (tblEMPLOYEE['EmployementStatus'] = false) then
    begin
      // Check if employee is employed:
      MessageDlg(''+sEmpID+' is no has access rights to NEST!', mtWarning, [mbOK], 0);
      lbledtUsername.Clear;
      lbledtPassword.Clear;
      lbledtUsername.SetFocus;
      Exit;
    end;//else


    // Correct Criteria:
    if (sEmpID = tblEMPLOYEE['EmpID']) and (sPasscode = tblEMPLOYEE['Password']) and (tblEMPLOYEE['EmployementStatus'] = true) then
    begin
      ShowMessage('Welcome to NEST Targeted Systems Solution Employee: '+sEmpID);
      frmLogin.Hide;
      frmMain.Show;
    end;

  end;//with

  // Finalize:
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;
  lbledtUsername.Clear;
  lbledtPassword.Clear;
  lblForgotPassWord.Font.Color := clBlack;

end;

procedure TfrmLogin.lblForgotPassWordClick(Sender: TObject);
begin
  // Initialize:
  stat1.Panels[0].Text := 'Loading...';
  Application.ProcessMessages;

  // Load Form:
  lbledtPassword.Clear;
  frmPasswordRecovery.ShowModal;

  // Finalize:
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {Exit}
  Application.Terminate;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  // Clear
  lbledtUsername.Clear;
  lbledtPassword.Clear;
  lblForgotPassWord.Font.Color := clBlack;
end;

end. {Developed by K.M. Dinake ©}
