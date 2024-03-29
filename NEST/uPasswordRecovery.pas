unit uPasswordRecovery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, Buttons, ComCtrls, uRecoveryClass;

type
  TfrmPasswordRecovery = class(TForm)
    lblPassRecovery: TLabel;
    lbledtUsername: TLabeledEdit;
    mmPassRecovery: TMainMenu;
    Fiel1: TMenuItem;
    LoginPage1: TMenuItem;
    Exit1: TMenuItem;
    Exit2: TMenuItem;
    lbledtRQAnswer: TLabeledEdit;
    btnSubitRQAnswer: TBitBtn;
    stat1: TStatusBar;
    Label1: TLabel;
    procedure btnSubitRQAnswerClick(Sender: TObject);
    procedure LoginPage1Click(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbledtUsernameChange(Sender: TObject);
    procedure lbledtRQAnswerSubLabelClick(Sender: TObject);
    procedure lbledtRQAnswerChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   
  end;

var
  frmPasswordRecovery: TfrmPasswordRecovery;
  Recovery : TRecovery;
  cbbRecoveryQuestions : TCombobox;
implementation

uses
  uLogin, dmHaven_NEST;

{$R *.dfm}

procedure TfrmPasswordRecovery.btnSubitRQAnswerClick(Sender: TObject);
begin
  {Get Password}
  // Initialize:
  stat1.Panels[0].Text := 'Proccesing...';
  Application.ProcessMessages;
  frmPasswordRecovery.OnCreate(Self);

  {Validate}
  // Username:
  if lbledtUsername.Text ='' then
  begin
    MessageDlg('Enter your username!', mtWarning, [mbOK], 0);
    lbledtUsername.SetFocus;
    exit;
  end//
  else
    Recovery.setUsername(lbledtUsername.Text);

  // Recovery Question:
  if cbbRecoveryQuestions.ItemIndex = -1 then
  begin
    MessageDlg('Select a recovery question!', mtWarning, [mbOK], 0);
    cbbRecoveryQuestions.SetFocus;
    exit;
  end
  else
    Recovery.setRecoveryQues(cbbRecoveryQuestions.Text);

  // Recovery Answer:
  if lbledtRQAnswer.Text ='' then
  begin
    MessageDlg('Enter your recovery answer!', mtWarning, [mbOK], 0);
    lbledtRQAnswer.SetFocus;
    exit;
  end//
  else
    Recovery.setRecoveryAnswer(lbledtRQAnswer.Text);

  with dmHaven do
  begin
    // Check if employee is employed:
    if (tblEMPLOYEE['EmployementStatus'] = false) then
    begin
      MessageDlg(''+lbledtUsername.Text+' is no has access rights to NEST!', mtWarning, [mbOK], 0);
      lbledtUsername.Clear;
      lbledtRQAnswer.Clear;
      cbbRecoveryQuestions.ItemIndex := -1;
      lbledtUsername.SetFocus;
      Exit;
    end;//else

    // Validate answer:
    Recovery.validAnwer(lbledtRQAnswer.Text, tblEMPLOYEE);

    if bValid = true then
      Recovery.getAnswer(tblEMPLOYEE)
    else
    begin
      lbledtRQAnswer.Font.Color := clRed;
      lbledtRQAnswer.Text := 'Incorrect Answer. Try Again.';
    end;//else
  end;// with

  // Save employees who recovered passwords:
  Recovery.RecoveryPasswordLog;

  // Clear components:
  lbledtUsername.Clear;
  lbledtRQAnswer.Clear;
  cbbRecoveryQuestions.ItemIndex := -1;
  lbledtUsername.SetFocus;
  // Finalize:
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;

end;

procedure TfrmPasswordRecovery.LoginPage1Click(Sender: TObject);
begin
  {Logout}
  // Initialize:
  stat1.Panels[0].Text := 'Loading...';
  Application.ProcessMessages;

  // Load Form:
  frmPasswordRecovery.Close;
  frmLogin.Show;

  // Finalize:
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;
end;

procedure TfrmPasswordRecovery.Exit2Click(Sender: TObject);
begin
  {Exit}
  if (MessageDlg('Are you sure you want to exit this application ?', mtConfirmation, [mbYes, mbNo], 1)) = mrYes then
  Application.Terminate;
end;

procedure TfrmPasswordRecovery.FormShow(Sender: TObject);
begin
  // Show username/ EmpID :
  lbledtUsername.Clear;
  lbledtUsername.Text := frmLogin.lbledtUsername.Text;
  // Clear answer:
  lbledtRQAnswer.Font.Color := clBlack;
  lbledtRQAnswer.Clear;
end;

procedure TfrmPasswordRecovery.FormCreate(Sender: TObject);
begin
  Recovery := TRecovery.create(lbledtUsername.text);
end;

procedure TfrmPasswordRecovery.lbledtUsernameChange(Sender: TObject);
begin
  cbbRecoveryQuestions := TComboBox.Create(Self);

  with cbbRecoveryQuestions do
  begin
   parent := frmPasswordRecovery;
   left   := 14;
   width  := 345;
   height := 30;
   top    := 83;
   style  := csDropDownList;
   Font.Size := 10;
   items.add('What is your grandmother''s maiden name?');
   items.add('What is the name of your first pet?');
   items.add('Who was your first kiss?');
   items.add('Where is the place you''d like to retire to?');
   items.add('What''''s'+' the name of your favourite high school teacher?');
   items.add('What is the make of your first car?');
  end;//with
end;

procedure TfrmPasswordRecovery.lbledtRQAnswerSubLabelClick(
  Sender: TObject);
begin
  // Revert Colour:
  lbledtRQAnswer.Color := clWindow;
end;

procedure TfrmPasswordRecovery.lbledtRQAnswerChange(Sender: TObject);
begin
  // Revert colour:
  lbledtRQAnswerSubLabelClick(self);
end;


end. {Developed by K.M. Dinake �}
