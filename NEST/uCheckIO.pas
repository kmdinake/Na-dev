unit uCheckIO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, dmHaven_NEST, Menus, uLogin, uClientControl, uPasswordRecovery,
  ComCtrls;

type
  TfrmCheckLog = class(TForm)
    cbbClientID: TComboBox;
    lbledtName: TLabeledEdit;
    lbledtSurname: TLabeledEdit;
    Label1: TLabel;
    btnCheckIn: TBitBtn;
    btnCheckOut: TBitBtn;
    lblBeds: TLabel;
    lblNoOfBeds: TLabel;
    lblFrmCap: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Home1: TMenuItem;
    Logout1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure cbbClientIDChange(Sender: TObject);
    procedure Home1Click(Sender: TObject);
    procedure Logout1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure btnCheckInClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure btnCheckOutClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     function checkBeds(): string;
  end;

var
  frmCheckLog: TfrmCheckLog;
  iNoAvailBeds : Integer;

implementation

uses uMain;

{$R *.dfm}

procedure TfrmCheckLog.FormShow(Sender: TObject);
var
  tBeds : TextFile;
  sBeds : String;
begin

  // Initialize:
  AssignFile(tBeds, GetCurrentDir+'\Reports\Check_In_Out\NoOfBeds'+FormatDateTime('dd,mm,yyyy', Now)+'.txt');

  // Check if file exists:
  if not FileExists(GetCurrentDir+'\Reports\Check_In_Out\NoOfBeds'+FormatDateTime('dd,mm,yyyy', Now)+'.txt') then
  begin
    // Reset beds:
    Rewrite(tBeds);
    Writeln(tBeds, '100#');
    closefile(tBeds);
  end
  else
  begin
    Reset(tBeds);
    Readln(tBeds, sBeds);
    iNoAvailBeds := StrToInt(copy(sBeds, 1, pos('#', sBeds)-1));
    lblNoOfBeds.Caption := IntToStr(iNoAvailBeds);
   // ShowMessage(IntToStr(iNoAvailBeds));
    CloseFile(tBeds);
  end;

  // Populate ccbClientID with ID of clients:
  cbbClientID.Clear;
  with dmHaven do
  begin
    tblCLIENTS.Filtered := false;
    tblCLIENTS.First;
    while not tblCLIENTS.Eof do
    begin
      cbbClientID.Items.Add(tblCLIENTS['ClientID']);
      tblCLIENTS.Next;
    end;//while
  end;//with
end;

procedure TfrmCheckLog.cbbClientIDChange(Sender: TObject);
var
  ClientID : String;
begin
  { Get Client Info }

  // filter by ClientID:
  ClientID := cbbClientID.Text;

  with dmHaven do
  begin
    tblCLIENTS.Filtered := False;
    tblCLIENTS.Filter   := 'ClientID ='+QuotedStr(ClientID);
    tblCLIENTS.Filtered := True;

    // Display Name And Surname:
    lbledtName.Text := tblCLIENTS['Fullname(s)'];
    lbledtSurname.Text := tblCLIENTS['Surname'];

  end;//with

end;

procedure TfrmCheckLog.Home1Click(Sender: TObject);
begin
  {Home}
  frmCheckLog.Hide;
  frmMain.Show;
end;

procedure TfrmCheckLog.Logout1Click(Sender: TObject);
begin
  {Logout}
  frmCheckLog.Hide;
  frmLogin.Show;
end;

procedure TfrmCheckLog.Exit1Click(Sender: TObject);
begin
  {Exit}
  if (MessageDlg('Are you sure you want to exit this application ?', mtConfirmation, [mbYes, mbNo], 1)) = mrYes then
  Application.Terminate;
end;

procedure TfrmCheckLog.btnCheckInClick(Sender: TObject);
var
  tBeds, tClientLog : TextFile;
  AvailabeBeds, ClientID, Name, Surname, Output, sRead, sAlready : String;
begin
  {Check In}

  // Validate:
  if Length(cbbClientID.Text) = 0 then
  begin
    MessageDlg('Select a clientID first!', mtWarning, [mbOK], 0);
    cbbClientID.SetFocus;
    Exit;
  end;

  // Initialize:
  AssignFile(tClientLog, GetCurrentDir+'\Reports\Check_In_Out\Checked_In'+FormatDateTime('dd, mmm, yyyy', Now)+'.txt');
  if not FileExists(GetCurrentDir+'\Reports\Check_In_Out\Checked_In'+FormatDateTime('dd, mmm, yyyy', Now)+'.txt') then
  begin
    // Create new file:
    MessageDlg('File not found, but we will create it.', mtInformation, [mbOK], 0);
    Rewrite(tClientLog);
    CloseFile(tClientLog);
  end;

  // Keep record of who checked in on which date:
  ClientID := cbbClientID.Text;
  Name := lbledtName.Text;
  Surname := lbledtSurname.Text;
  Output := ClientID+'#'+Name+'#'+Surname+'#'+FormatDateTime('dd/mm/yyyy', Now)+#9+TimeToStr(Now);

  // Check if client hasnt already checked in:
  Reset(tClientLog);
  while not Eof(tClientLog) do
  begin
    Readln(tClientLog, sAlready);
    if Pos(Output, sAlready) > 0 then   {clientID works but >> doesnt}
    begin
      MessageDlg('Client: '+ClientID+' has already been checked in!', mtWarning, [mbOK], 0);
      cbbClientID.ItemIndex := -1;
      lbledtName.Clear;
      lbledtSurname.Clear;
      Exit;
    end;
  end;//while
  CloseFile(tClientLog);

  // Initialize:
  StatusBar1.Panels[0].Text := 'Checking in...'; Application.ProcessMessages;
  AssignFile(tBeds, GetCurrentDir+'\Reports\Check_In_Out\NoOfBeds'+FormatDateTime('dd,mm,yyyy', Now)+'.txt');
  Rewrite(tBeds);

  // Calculate available beds:
  Dec(iNoAvailBeds);
  AvailabeBeds := IntToStr(iNoAvailBeds)+'#';

  // Write new available:
  Writeln(tBeds, AvailabeBeds);
  CloseFile(tBeds);


  // Save to file:
  StatusBar1.Panels[0].Text := 'Saving...'; Application.ProcessMessages;
  Append(tClientLog);
  Writeln(tClientLog, Output);
  CloseFile(tClientLog);
  MessageDlg('Client: '+ClientID+' has been checked in.', mtInformation, [mbOK], 0);

  // Clear components:
  cbbClientID.ItemIndex := -1;
  lbledtName.Clear;
  lbledtSurname.Clear;

  // Finalize:
  frmCheckLog.FormShow(Self);
  StatusBar1.Panels[0].Text := 'Ready'; Application.ProcessMessages;
end;

procedure TfrmCheckLog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  {Exit}
  
  Application.Terminate;
end;

procedure TfrmCheckLog.Timer1Timer(Sender: TObject);
begin
  StatusBar1.Panels[1].Text := TimeToStr(Now);
end;

procedure TfrmCheckLog.btnCheckOutClick(Sender: TObject);
var
  tBeds, tClientLog : TextFile;
  AvailabeBeds, ClientID, Name, Surname, Output, sAlready : String;
begin
  {Check Out}
  // Validate:
  if cbbClientID.Text = '' then
  begin
    MessageDlg('Select a ClientID first!', mtWarning, [mbOK], 0);
    cbbClientID.SetFocus;
    Exit;
  end;//

  // Initialize:
  StatusBar1.Panels[0].Text := 'Checking out...'; Application.ProcessMessages;
  AssignFile(tBeds, GetCurrentDir+'\Reports\Check_In_Out\NoOfBeds'+FormatDateTime('dd,mm,yyyy', Now)+'.txt');
  Rewrite(tBeds);

  // Calculate available beds:
  if iNoAvailBeds >= 100 then
    AvailabeBeds := IntToStr(100)
  else
  begin
    // Keep record of who checked out on which date:
    ClientID := cbbClientID.Text;
    Name := lbledtName.Text;
    Surname := lbledtSurname.Text;
    Output := ClientID+'#'+Name+'#'+Surname+'#'+FormatDateTime('dd/mm/yyyy', Now)+#9+TimeToStr(Now);

    // Initialize:
    AssignFile(tClientLog, GetCurrentDir+'\Reports\Check_In_Out\Checked_Out'+FormatDateTime('dd, mmm, yyyy', Now)+'.txt');
    if not FileExists(GetCurrentDir+'\Reports\Check_In_Out\Checked_Out'+FormatDateTime('dd, mmm, yyyy', Now)+'.txt') then
    begin
      // Create new file:
      MessageDlg('File not found, but we will create it.', mtInformation, [mbOK], 0);
      Rewrite(tClientLog);
      CloseFile(tClientLog);
    end;

    // Check if client hasnt already checked in:
    Reset(tClientLog);
    while not Eof(tClientLog) do
    begin
      Readln(tClientLog, sAlready);
      if Pos(Output, sAlready) > 0 then
      begin
        MessageDlg('Client: '+ClientID+' has already been checked out!', mtWarning, [mbOK], 0);
        cbbClientID.ItemIndex := -1;
        lbledtName.Clear;
        lbledtSurname.Clear;
      end
      else if Pos(Output, sAlready) < 0 then
      begin
        MessageDlg('Cannot check out client who has not yet checked in today!', mtWarning, [mbOK], 0);
        cbbClientID.ItemIndex := -1;
        lbledtName.Clear;
        lbledtSurname.Clear;

      end;//else
    end;//while
    CloseFile(tClientLog);

    Inc(iNoAvailBeds);
    AvailabeBeds := IntToStr(iNoAvailBeds)+'#';
    ShowMessage(AvailabeBeds);
    // Write new available:
    Writeln(tBeds, AvailabeBeds);
    CloseFile(tBeds);


    // Save to file:
    StatusBar1.Panels[0].Text := 'Saving...'; Application.ProcessMessages;

    Append(tClientLog);
    Writeln(tClientLog, Output);
    CloseFile(tClientLog);
    MessageDlg('Client: '+ClientID+' has been checked out.', mtInformation, [mbOK], 0);

  end;//else

  // Initialize:
  if not FileExists(GetCurrentDir+'\Reports\Check_In_Out\Checked_Out'+FormatDateTime('dd, mmm, yyyy', Now)+'.txt') then
  begin
    // Create new file:
    MessageDlg('File not found, but we will create it.', mtInformation, [mbOK], 0);
    Rewrite(tClientLog);
    CloseFile(tClientLog);
    exit;

    // Save to file:
    StatusBar1.Panels[0].Text := 'Saving...'; Application.ProcessMessages;
    Append(tClientLog);
    Writeln(tClientLog, Output);
    CloseFile(tClientLog);
    MessageDlg('Client: '+ClientID+' has been checked out.', mtInformation, [mbOK], 0);
  end;

  // Clear components:
  cbbClientID.ItemIndex := -1;
  lbledtName.Clear;
  lbledtSurname.Clear;

  // Finalize:
  frmCheckLog.FormShow(Self);
  StatusBar1.Panels[0].Text := 'Ready'; Application.ProcessMessages;
end;

procedure TfrmCheckLog.Label2Click(Sender: TObject);
begin
  {Help}
  MessageDlg('1. You can return to the home page by selecting "Home" on the menu, or simply press Ctrl+H .'
              +#13+'2. You can logout by selecting "Logout" on the menu, or simply press Ctrl+Alt+L .'
              +#13+'3. For further help, seek help from the program administrator.', mtInformation, [mbOK], 0);
end;

function TfrmCheckLog.checkBeds: string;
begin
  // Check if beds are still available:
  if iNoAvailBeds = 0 then
  begin
    MessageDlg('No beds are available!', mtWarning, [mbOK], 0);
    lblNoOfBeds.Caption := IntToStr(iNoAvailBeds);
    exit;
  end;//
  checkBeds := 'No beds';

end;

procedure TfrmCheckLog.BitBtn1Click(Sender: TObject);
begin
  frmLogin.Show;
end;

end. {Developed by K.M. Dinake ©}
