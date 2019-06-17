unit uAdminCentre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Grids, DBGrids, Menus;

type
  TfrmAdminCentre = class(TForm)
    pgcAdmin: TPageControl;
    tsStatistics: TTabSheet;
    stat1: TStatusBar;
    tsAddEmployee: TTabSheet;
    grpAddEmployee: TGroupBox;
    grpRemoveEmployee: TGroupBox;
    lbledtName: TLabeledEdit;
    lbledtSurname: TLabeledEdit;
    btnAddEmployee: TBitBtn;
    btnEmployeeCancel: TBitBtn;
    lbledtContactNo: TLabeledEdit;
    lbledtIDNo: TLabeledEdit;
    cbbUsernames: TComboBox;
    lblRemove: TLabel;
    lbledtEmployeeName: TLabeledEdit;
    lbledtEmployeeSurname: TLabeledEdit;
    btnDeleteEmployee: TBitBtn;
    mmAdmin: TMainMenu;
    File1: TMenuItem;
    Home1: TMenuItem;
    Logout1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    lbledtPassword: TLabeledEdit;
    lbledtVerifyPassword: TLabeledEdit;
    GroupBox1: TGroupBox;
    lbledtNewPassword: TLabeledEdit;
    cbbUsers: TComboBox;
    Label1: TLabel;
    lbledtVerifyNewPassword: TLabeledEdit;
    lbledtNewSurname: TLabeledEdit;
    lbledtNewContactNo: TLabeledEdit;
    btnUpdate: TBitBtn;
    lblCaption: TLabel;
    lblPassRecovery: TLabel;
    cbbRecoveryQuestions: TComboBox;
    lbledtRQAns: TLabeledEdit;
    cbAdmin: TCheckBox;
    Timer1: TTimer;
    lblToAdmin: TLabel;
    reSTATS: TRichEdit;
    gbStatsSearch: TGroupBox;
    cbbStatsFilter: TComboBox;
    rgbStatsSearch: TRadioGroup;
    lblFilter: TLabel;
    lbledtSearch: TLabeledEdit;
    BitBtnFilter: TBitBtn;
    Help1: TMenuItem;
    HowtoAddEmployee1: TMenuItem;
    UpdateEmployeeInformation1: TMenuItem;
    Deleteanemployee1: TMenuItem;
    N2: TMenuItem;
    HowToGenerateStatistics1: TMenuItem;
    procedure btnDeleteEmployeeClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Logout1Click(Sender: TObject);
    procedure Home1Click(Sender: TObject);
    procedure btnAddEmployeeClick(Sender: TObject);
    procedure btnEmployeeCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure Show(Sender: TObject);
    procedure cbbUsernamesChange(Sender: TObject);
    procedure cbbUsersChange(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure lblToAdminClick(Sender: TObject);
    procedure tsStatisticsShow(Sender: TObject);
    procedure cisticsExit(Sender: TObject);
    procedure cbbStatsFilterChange(Sender: TObject);
    procedure rgbStatsSearchClick(Sender: TObject);
    procedure BitBtnFilterClick(Sender: TObject);
    procedure lblToAdminMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblToAdminMouseLeave(Sender: TObject);
    // dynamic procedure:
    procedure bitbtnPrintClick(Sender : TObject);
    procedure HowToGenerateStatistics1Click(Sender: TObject);
    procedure HowtoAddEmployee1Click(Sender: TObject);
    procedure UpdateEmployeeInformation1Click(Sender: TObject);
    procedure Deleteanemployee1Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }


  end;

var
  frmAdminCentre: TfrmAdminCentre;
  bDone : Boolean;
implementation

uses
  uMain, uLogin, uClientControl, dmHaven_NEST, uCheckIO, Math, DateUtils,
  DB;

{$R *.dfm}

procedure TfrmAdminCentre.btnDeleteEmployeeClick(Sender: TObject);
begin
  {Delete}
  // Initialize:
  stat1.Panels[0].Text := 'Deleting...';
  Application.ProcessMessages;

  // Confirm empID:
  if cbbUsernames.Text = '' then
  begin
    MessageDlg('Select a EmpID first', mtWarning,[mbOK], 0);
    cbbUsernames.SetFocus;
    Exit;
  end;//

  // Confirm Delete:
  if (MessageDlg('Are you sure you want to delete this employee?', mtConfirmation, [mbNo, mbYes], 1)) = mrYes then
  begin
    // Get EmpID:
    cbbUsernamesChange(self);
    //Check if EmpID matches
    with dmHaven do
    begin
      // Delete:
      tblEMPLOYEE.Edit;
      tblEMPLOYEE['EmployementStatus'] := False;
      tblEMPLOYEE['DateUnemployed']    := FormatDateTime('dd/mm/yyyy', Now);
      tblEMPLOYEE.Post;

    end;//with

    // Success Msg:
    MessageDlg('Employee: '+cbbUsernames.Text+' successfully deleted!', mtInformation, [mbOK], 0);

    // Clear components:
    cbbUsernames.ItemIndex := -1;
    lbledtEmployeeSurname.Clear;
    lbledtEmployeeName.Clear;

    // Finalize:
    frmAdminCentre.Show(self);
    stat1.Panels[0].Text := 'Ready';
    Application.ProcessMessages;
  end
  else
  begin
    // Cancel Msg:
    MessageDlg('Operation cancelled!', mtInformation, [mbOK], 0);

    // Clear components:
    cbbUsernames.ItemIndex := -1;
    lbledtEmployeeSurname.Clear;
    lbledtEmployeeName.Clear;
    exit;

    // Finalize:
    stat1.Panels[0].Text := 'Ready';
    Application.ProcessMessages;
  end;//else
  
end;
procedure TfrmAdminCentre.Exit1Click(Sender: TObject);
begin
  {Exit}
  if (MessageDlg('Are you sure you want to exit this application ?', mtConfirmation, [mbYes, mbNo], 1)) = mrYes then
  Application.Terminate;
end;

procedure TfrmAdminCentre.Logout1Click(Sender: TObject);
begin
  {Logout}
  // Initialize:
  stat1.Panels[0].Text := 'Loging out...';
  Application.ProcessMessages;

  // Load Form:
  frmAdminCentre.hide;
  frmLogin.Show;

  // Finalize:
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;

end;

procedure TfrmAdminCentre.Home1Click(Sender: TObject);
begin
  {Home}
  frmAdminCentre.hide;
  frmMain.Show;
end;

procedure TfrmAdminCentre.btnAddEmployeeClick(Sender: TObject);
var
  sEmpID_New, sEmpName, sEmpSurname, sEmpContactNo,
  sEmpIDNo, sEmpRQ, sEmpRAns, sGender,
  sEmpPassword, sEmpVerified :String;
  iErr, iGender, iEmp  : Integer;
  rIDNo : Real;
  bAdmin, bEmployed : Boolean;

begin
  {Insert Employee}
  // Initialize:
  Randomize;
  stat1.Panels[0].Text := 'Inserting...';
  Application.ProcessMessages;

  {Validate}
  // Name:
  if Length(lbledtName.Text) = 0 then
    begin
      MessageDlg('Enter a name!', mtWarning, [mbOK], 0);
      lbledtName.SetFocus;
      Exit;
    end
    else
      sEmpName := lbledtName.Text;

  // Surname:
  if Length(lbledtSurname.Text) = 0 then
    begin
      MessageDlg('Enter a surname!', mtWarning, [mbOK], 0);
      lbledtSurname.SetFocus;
      Exit;
    end
    else
      sEmpSurname := lbledtSurname.Text;

  // Contact No:
  if Length(lbledtContactNo.Text) = 0 then
    sEmpContactNo := 'N/A'
  else
    sEmpContactNo := lbledtContactNo.Text;

  //ID No:
  Val(lbledtIDNo.Text, rIDNo, iErr);
  if iErr > 0 then
  begin
    MessageDlg('Invalid ID number!', mtWarning, [mbOK], 0);
    lbledtIDNo.SetFocus;
    Exit;
  end
  else
    sEmpIDNo := FloatToStr(rIDNo);

    ShowMessage(sEmpIDNo);
  // Determine Gender:
  iGender := StrToInt(copy(sEmpIDNo, 7, 4));

  ShowMessage(IntToStr(iGender));
  if (iGender > 0000) and (iGender <= 4999) then
    sGender := 'FEMALE'
  else if (iGender > 4999) and (iGender <= 9999) then
    sGender := 'MALE';

    ShowMessage(sGender);
  // Recovery Question:
  if cbbRecoveryQuestions.ItemIndex = -1 then
  begin
    MessageDlg('Select a recovery question!', mtWarning, [mbOK], 0);
    cbbRecoveryQuestions.SetFocus;
    Exit;
  end
  else
  begin
    case cbbRecoveryQuestions.ItemIndex of
      0 : sEmpRQ := 'What is your grandmother''s maiden name?';
      1 : sEmpRQ := 'What is the name of your first pet?';
      2 : sEmpRQ := 'Who was your first kiss?';
      3 : sEmpRQ := 'Where is the place you''d like to retire to?';
      4 : sEmpRQ := 'What''s the name of your favourite high school teacher?';
      5 : sEmpRQ := 'What is the make of your first car?';
    end;//case
  end;//else

  // Answer:
  if Length(lbledtRQAns.Text) = 0 then
  begin
    MessageDlg('Enter a surname!', mtWarning, [mbOK], 0);
    lbledtRQAns.SetFocus;
    Exit;
  end
  else
    sEmpRAns := lbledtRQAns.Text;

  // Administrator:
  if cbAdmin.Checked = true then bAdmin := True
  else                           bAdmin := False;

  // Employement:
  bEmployed := True;

  // Password:
  if Length(lbledtPassword.Text) = 0 then
  begin
    MessageDlg('Enter your password!', mtWarning, [mbOK], 0);
    lbledtPassword.SetFocus;
    Exit;
  end
  else
    sEmpPassword := lbledtPassword.Text;

  // Check if there is a verified password:
  if Length(lbledtVerifyPassword.Text) = 0 then
  begin
    MessageDlg('Enter your password!', mtWarning, [mbOK], 0);
    lbledtVerifyPassword.SetFocus;
    Exit;
  end;
  // Verify Password:
  if sEmpPassword <> lbledtVerifyPassword.Text then
  begin
    MessageDlg('Invalid Password! Make sure your passwords are the same.', mtWarning, [mbOK], 0);
    lbledtVerifyPassword.SetFocus;
    Exit;
  end
  else
    sEmpVerified := lbledtVerifyPassword.Text;

  {Employee ID}
  // Generate empID number:
  iEmp := RandomRange(100, 10000);
  // Search if there is more than one name:
  if pos(' ', sEmpName)>0 then
  begin
    // Get firstname initial:
    sEmpID_New := UpperCase(copy(sEmpName, 1, 1));

    // Delete firstname, get second name initial:
    Delete(sEmpName, 1, pos(' ', sEmpName));
    // Concutinate initials and empID number:
    sEmpID_New := sEmpID_New + UpperCase(copy(sEmpName, 1, 1)) + UpperCase(copy(sEmpSurname, 1, 1)) + IntToStr(iEmp);

    // Reset name to original text:
    sEmpName := lbledtName.Text;
  end
  else
    // Concutinate initials and empID number:
    sEmpID_New := UpperCase(copy(sEmpName, 1, 1)) + UpperCase(copy(sEmpSurname, 1, 1)) + IntToStr(iEmp);;

{Save}
  with dmHaven do
  begin
    tblEMPLOYEE.Append;
    tblEMPLOYEE['EmpID']             := sEmpID_New;
    tblEMPLOYEE['Fullname(s)']       := sEmpName;
    tblEMPLOYEE['Surname']           := sEmpSurname;
    tblEMPLOYEE['ContactNo']         := sEmpContactNo;
    tblEMPLOYEE['IDNo']              := sEmpIDNo;
    tblEMPLOYEE['Gender']            := sGender;
    tblEMPLOYEE['Password']          := sEmpVerified;
    tblEMPLOYEE['RecoveryQuestion']  := sEmpRQ;
    tblEMPLOYEE['RecoveryAnswer']    := sEmpRAns;
    tblEMPLOYEE['EmployementStatus'] := bEmployed;
    tblEMPLOYEE['Administrator']     := bAdmin;
    tblEMPLOYEE['DateEmployed']      := FormatDateTime('dd/mm/yyyy', Now);
    tblEMPLOYEE.Post;
  end;//with


  // Finalize:
  MessageDlg('Employee: '+sEmpID_New+' is successfully added.', mtInformation, [mbOK], 0);
  btnEmployeeCancelClick(Self);
  cbbUsernames.Refresh;
  cbbUsers.Refresh;
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;

end;

procedure TfrmAdminCentre.btnEmployeeCancelClick(Sender: TObject);
begin
  {Clear}
  lbledtName.Clear;
  lbledtSurname.Clear;
  lbledtContactNo.Clear;
  lbledtIDNo.Clear;
  lbledtPassword.Clear;
  lbledtVerifyPassword.Clear;
  lbledtRQAns.Clear;
  cbbRecoveryQuestions.ItemIndex := -1;
  cbAdmin.Checked := False;
end;

procedure TfrmAdminCentre.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  {Exit}
  Application.Terminate;
end;

procedure TfrmAdminCentre.Timer1Timer(Sender: TObject);
begin
  // show time:
  stat1.Panels[1].Text := TimeToStr(Now);
end;

procedure TfrmAdminCentre.Show(Sender: TObject);
var
  sAuthorise : string;
begin
  {Admin Centre}

  // Initialize:
  stat1.Panels[0].Text := 'Loading...';
  Application.ProcessMessages;


  // Check if passcode is entered:
  if sAuthorise = '' then
    Exit;

  // Get Authorisation Passcode:
  sAuthorise := InputBox('Authorise Access', 'Enter your admin passcode.', '');

  with dmHaven do
  begin
    // Filter by logged on employee:
    tblEMPLOYEE.Filtered := False;
    tblEMPLOYEE.Filter   := 'EmpID =' +QuotedStr(sEmpID);
    tblEMPLOYEE.Filtered := True;

    // Check if passcode is correct:
    if (sAuthorise = tblEMPLOYEE['Password']) and (tblEMPLOYEE['Administrator']) then
    begin
      MessageDlg('Access granted!', mtInformation, [mbOK] ,0);
      pgcAdmin.ActivePage := tsAddEmployee;
    end
    else
      MessageDlg('Access Denied! You do not have admin rights.', mtWarning, [mbOK], 0);
      pgcAdmin.ActivePage := tsStatistics;
      Exit;

  end;//with

  lbledtEmployeeName.Clear;
  lbledtEmployeeSurname.Clear;

  // Populate Combobox's with empID:
  with dmHaven do
  begin
    cbbUsernames.Clear;
    cbbUsers.Clear;

    tblEMPLOYEE.Filtered := False;
    tblEMPLOYEE.Filter   := 'EmployementStatus = True';
    tblEMPLOYEE.Filtered := True;

    tblEMPLOYEE.First;
    while not tblEMPLOYEE.Eof do
    begin
      // Add empID's into comboboxes
      cbbUsernames.Items.Add(tblEMPLOYEE['EmpID']);
      cbbUsers.Items.Add(tblEMPLOYEE['EmpID']);
      tblEMPLOYEE.Next;
    end;
  end;//with

  // Finalize:
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;
end;

procedure TfrmAdminCentre.cbbUsernamesChange(Sender: TObject);
begin
  // Get employee details:
  with dmHaven do
  begin
    // Filter by EmpID:
    tblEMPLOYEE.Filtered := False;
    tblEMPLOYEE.Filter   := 'EmployementStatus = True and EmpID ='+QuotedStr(cbbUsernames.Text) ;
    tblEMPLOYEE.Filtered := True;

    if not tblEMPLOYEE['EmployementStatus'] = False then
    begin
      // Retrieve Info:
      lbledtEmployeeName.Text := tblEMPLOYEE['Fullname(s)'];
      lbledtEmployeeSurname.Text := tblEMPLOYEE['Surname'];
    end;  
  end;//with
end;

procedure TfrmAdminCentre.cbbUsersChange(Sender: TObject);
begin
  // Get employee details:
  with dmHaven do
  begin
    // Filter by EmpID:
    tblEMPLOYEE.Filtered := False;
    tblEMPLOYEE.Filter   := 'EmployementStatus = True and EmpID ='+QuotedStr(cbbUsers.Text) ;
    tblEMPLOYEE.Filtered := True;

  end;//with
end;

procedure TfrmAdminCentre.btnUpdateClick(Sender: TObject);
var
  sPasscode, sVerPasscode, sSurname, sContactNo : String;
begin
  // Initialize:
  stat1.Panels[0].Text := 'Updating...';
  Application.ProcessMessages;

  // Confirm empID:
  if cbbUsers.Text = '' then
  begin
    MessageDlg('Select a EmpID first', mtWarning,[mbOK], 0);
    cbbUsers.SetFocus;
    Exit;
  end;//

  // Get EmpID:
  cbbUsersChange(Self);

  // Get & Validate Passcode:
  sPasscode := lbledtNewPassword.Text;

  if lbledtVerifyNewPassword.Text = sPasscode then sVerPasscode := lbledtVerifyNewPassword.Text
  else
  begin
    MessageDlg('Invalid Password! Make sure your passwords are the same.', mtWarning, [mbOK], 0);
    lbledtVerifyNewPassword.SetFocus;
    Exit;
  end;//else

  // Get Surname:
  sSurname := lbledtNewSurname.Text;

  // Get Contact Number:
  sContactNo := lbledtNewContactNo.Text;

  if (MessageDlg('Are you sure you want to update the employee''s information?', mtConfirmation, [mbYes, mbNo], 0)) = mrYes then
  begin
    // Update Info:
    with dmHaven do
    begin
      if sVerPasscode = '' then
        sVerPasscode := tblEMPLOYEE['Password'];

      if sSurname = '' then
        sSurname := tblEMPLOYEE['Surname'];

      if sContactNo = '' then
        sContactNo := tblEMPLOYEE['ContactNo'];

      tblEMPLOYEE.Edit;
      tblEMPLOYEE['EmpID']     := cbbUsers.Text;
      tblEMPLOYEE['Surname']   := sSurname;
      tblEMPLOYEE['ContactNo'] := sContactNo;
      tblEMPLOYEE['Password']  := sVerPasscode;
      tblEMPLOYEE.Post;
    end;//with

    // Success Msg:
    MessageDlg('Employee: '+cbbUsers.Text+' successfully updated!', mtConfirmation, [mbOK], 0);

    // Finalize:
    cbbUsers.Refresh;

    // Clear components:
    cbbUsers.ItemIndex := -1;
    lbledtNewSurname.Clear;
    lbledtNewPassword.Clear;
    lbledtVerifyNewPassword.Clear;
    lbledtNewContactNo.Clear;
    exit;

    frmAdminCentre.Show(self);
    stat1.Panels[0].Text := 'Ready';
    Application.ProcessMessages;
  end
  else
  begin
    // Cancel Msg:
    MessageDlg('Operation cancelled!', mtInformation, [mbOK], 0);

    // Clear components:
    cbbUsers.ItemIndex := -1;
    lbledtNewSurname.Clear;
    lbledtNewPassword.Clear;
    lbledtVerifyNewPassword.Clear;
    lbledtNewContactNo.Clear;
    exit;

    // Finalize:
    frmAdminCentre.Show(self);
    stat1.Panels[0].Text := 'Ready';
    Application.ProcessMessages;
  end;//else
end;

procedure TfrmAdminCentre.lblToAdminClick(Sender: TObject);
begin
  frmMain.btnAdminCentreClick(self);
end;

procedure TfrmAdminCentre.tsStatisticsShow(Sender: TObject);

begin
  {Populate Combobox}
  case rgbStatsSearch.ItemIndex of
    0 : begin
          bitBtnFilter.Enabled := True;
          cbbStatsFilter.Enabled := True;
          cbbStatsFilter.Clear;
          cbbStatsFilter.Items.Add('Gender');
          cbbStatsFilter.Items.Add('Age');
          cbbStatsFilter.Items.Add('Previous Career');
        end;// clients

    1 : begin
          bitBtnFilter.Enabled := True;
          cbbStatsFilter.Clear;
          cbbStatsFilter.Enabled := False;
        end;// Employees

    2 : begin
          bitBtnFilter.Enabled := True;
          cbbStatsFilter.Clear;
          cbbStatsFilter.Enabled := False;
        end;// sponsors


  end;//case filter
end;

procedure TfrmAdminCentre.cisticsExit(Sender: TObject);
begin
  // Clear:
  bitBtnFilter.Enabled := False;
  reSTATS.Lines.Clear;
  lbledtSearch.Visible := False;
  lbledtSearch.Clear;
  rgbStatsSearch.ItemIndex := -1;
  cbbStatsFilter.Clear;
  cbbStatsFilter.ItemIndex := -1;
end;

procedure TfrmAdminCentre.cbbStatsFilterChange(Sender: TObject);
begin
  // Visibility of Input Component:
  with dmHaven do
  begin
    if rgbStatsSearch.ItemIndex = 0 then
    begin
      case cbbStatsFilter.ItemIndex of
            0 : lbledtSearch.Visible := True;


            1 : lbledtSearch.Visible := False;


            2 : lbledtSearch.Visible := False;

          end;// clients
          end;//with

  end;

end;

procedure TfrmAdminCentre.rgbStatsSearchClick(Sender: TObject);
begin
  tsStatisticsShow(self);
end;

procedure TfrmAdminCentre.BitBtnFilterClick(Sender: TObject);
var
  sInput, sHAge, sLAge,
  sGender, sCareerH, sCareerL,
  sHSpons, sLSpons : String;
  iLAge, iHAge, iAveAge, iAgeSum,
  iMale, iFemale, iGender, iHDonate, iLDonate: Integer;
  bitbtnPrint : TBitBtn;
  rAveDonate : Real;
  i, iErr, iInput: Integer;
  arrEmpID : array[1..5] of string;
  MostClient, MostEvents, MostSponsors : String;
begin
  with dmHaven do
  begin
    if (rgbStatsSearch.ItemIndex = 0) then
    begin
      case cbbStatsFilter.ItemIndex of
        0 : begin
              sInput := lbledtSearch.Text;

              if sInput = '' then
              begin
                 reSTATS.Clear;
                 reSTATS.SelAttributes.Style := [fsBold];
                 reSTATS.Lines.Add(#9+#9+'THE HAVEN NIGHT SHELTER');
                 reSTATS.Lines.Add('No records found for: No Search Criteria Sumbited.');
                 exit;
              end
              else
              begin
                // initialize:
                iMale := 0;
                iFemale := 0;
                iGender := 0;
                sGender := '';

                // FILTER:
                tblCLIENTS.Filtered  := False;
                tblCLIENTS.Filter    := 'Gender =' +QuotedStr(UpperCase(sInput));
                tblCLIENTS.Filtered  := True;

                // get no. of males:
                iGender := tblCLIENTS.RecordCount;
               // ShowMessage(IntToStr(iGender));

                // Check if filter exists:
                if tblCLIENTS.RecordCount = 0 then
                begin
                  // Out of bound (IF ITS AN INTEGER)
                  Val(sInput, iInput , iErr);
                  if iErr = 0 then
                  begin
                    MessageDlg('Search filter out of bounds!', mtError, [mbOK], 0);
                  end
                  else MessageDlg('Invalid gender!', mtWarning, [mbOK], 0);

                  // Display:
                  reSTATS.Clear;
                  reSTATS.SelAttributes.Style := [fsBold];
                  reSTATS.Lines.Add(#9+#9+'THE HAVEN NIGHT SHELTER');
                  reSTATS.Lines.Add('No records found for: '+UpperCase(sInput));
                  exit;
                end;//

                // Diplay:
                with reSTATS do
                begin
                  Clear;
                  SelAttributes.Style := [fsBold];
                  Lines.Add(#9+#9+#9+'THE HAVEN NIGHT SHELTER');
                  lines.Add(#13+'According to the statistics matching the filter criteria there are : '+IntToStr(iGender)+' '+sInput+'s'+
                            #13+'currently residing in the shelter.');
                end;//with

                // get no of females:
                tblCLIENTS.Filtered  := false;
                tblCLIENTS.Filter    := 'Gender =' +QuotedStr(UpperCase('Female'));
                tblCLIENTS.Filtered  := True;

                iFemale := tblCLIENTS.RecordCount;
               // ShowMessage(IntToStr(iFemale));

                // get no of males:
                tblCLIENTS.Filtered  := false;
                tblCLIENTS.Filter    := 'Gender =' +QuotedStr(UpperCase('male'));
                tblCLIENTS.Filtered  := True;

                iMale := tblCLIENTS.RecordCount;
               // ShowMessage(IntToStr(imale));



                // Check which gender is greater:
                if iMale > iFemale then
                begin
                  sGender := 'Males.';
                  iGender := iMale;
                end
                else if iFemale > iMale then
                begin
                  sGender := 'Females.';
                  iGender := iFemale;
                end
                else if iMale = iFemale then
                begin
                  sGender := 'Both males and females.';
                  iGender := iMale;
                end
                else
                begin
                  sGender := 'Other/Not specified.';
                  iGender := 0;
                end;

                // DISPLAY:
                with reSTATS do
                begin
                  Lines.Add(#13+'-----------------------------------------------------------------------');
                  SelAttributes.Style := [fsBold];
                  Lines.Add('Additional Statistics Concerning Gender');
                  Lines.Add(#13+'The gender with the highest poverty rate: '+#9+sGender);
                  Lines.Add(#13+'----------------------------------------------------------------------');
                  Lines.Add(#13+'Copy generated by NEST Targeted System Solution.');
                  Lines.Add('Developed by K.M Dinake.');
                end;//with
              end;//else
            lbledtSearch.Clear;
            end;//gender

        1 : begin
              // Get Age:
              with dmHaven do
              begin
                tblCLIENTS.Filtered := False;

                tblCLIENTS.Sort := 'Age DESC';

                // Higest Age:
                tblCLIENTS.First;
                iHAge := tblCLIENTS['Age'];
                sHAge := tblCLIENTS['ClientID']+', '+tblCLIENTS['Fullname(s)']+' '+tblCLIENTS['Surname'];

                // Lowest Age:
                tblCLIENTS.Last;
                iLAge := tblCLIENTS['Age'];
                sLAge := tblCLIENTS['ClientID']+', '+tblCLIENTS['Fullname(s)']+' '+tblCLIENTS['Surname'];

                // Mean Age:
                tblCLIENTS.First;
                iAgeSum := 0;
                while not tblCLIENTS.eof do
                begin
                  iAgeSum := iAgeSum + tblCLIENTS['Age'];
                  tblCLIENTS.Next;
                end;//while
                iAveAge := iAgeSum div tblCLIENTS.RecordCount;
              end;

              // display
              with reSTATS do
              begin
                Clear;
                SelAttributes.Style := [fsBold];
                Lines.Add(#9+#9+#9+'THE HAVEN NIGHT SHELTER');
                SelAttributes.Style := [fsBold];
                lines.Add(#13+'Oldest Client: ');
                Lines.Add(sHAge+
                          #13+'Age: '+#9+IntToStr(iHAge));
                Lines.Add(#13+'-----------------------------------------------------------------------');
                SelAttributes.Style := [fsBold];
                Lines.Add(#13+'Youngest Client: ');
                Lines.Add(sLAge+
                          #13+'Age: '+#9+IntToStr(iLAge));
                Lines.Add(#13+'-----------------------------------------------------------------------');
                SelAttributes.Style := [fsBold];
                Lines.Add(#13+'Average Client Age: '+#9+IntToStr(iAveAge));
                Lines.Add(#13+'-----------------------------------------------------------------------');
                Lines.Add(#13+'Copy generated by NEST Targeted System Solution.');
                Lines.Add('Developed by K.M Dinake.');
              end;//with
            end;//age
         2 : begin
               // gET Highest Career:
               tblCLIENTS.First;
               while not tblCLIENTS.Eof do
               begin
                 if pos(UpperCase('Chartered accountant'), tblCLIENTS['PreviousCareer']) > Pos(UpperCase('Forensic Auditor'), tblCLIENTS['PreviousCareer']) then
                 begin
                   sCareerH := 'CHARTERED ACCOUNTING';
                   sCareerL := 'FORENSIC AUDITING';
                 end
                 else
                 begin
                   sCareerH := 'FORENSIC AUDITING';
                   sCareerL := 'CHARTERED ACCOUNTING';
                 end;
                 tblCLIENTS.Next;
               end;//while

               // Display:
               with reSTATS do
               begin
                 Clear;
                 SelAttributes.Style := [fsBold];
                 Lines.Add(#9+#9+#9+'THE HAVEN NIGHT SHELTER');
                 Lines.Add(#13+'According to the clients of The Haven Night Shelter, '+
                           #13+'the job profession with the highest unemployment is: '+#13+sCareerH);
                 Lines.Add(#13+'-----------------------------------------------------------------------');
               end;//with

               // Display:
               with reSTATS do
               begin
                 Lines.Add(#13+'According to the clients of The Haven Night Shelter, '+
                           #13+'the job profession with the lowest unemployment is: '+#13+sCareerL);
                 Lines.Add(#13+'-----------------------------------------------------------------------');
                 Lines.Add(#13+'Copy generated by NEST Targeted System Solution.');
                 Lines.Add('Developed by K.M Dinake.');
               end;//with

               lbledtSearch.Clear;
             end;//pre-career

      end;//case

    end
    else if (rgbStatsSearch.ItemIndex = 1 ) then
    begin
      // populate array:
      tblEMPLOYEE.Filtered := False;

      i := 0;
      tblEMPLOYEE.First;
      while not tblEMPLOYEE.Eof do
      begin
        Inc(i);
        arrEmpID[i] := tblEMPLOYEE['EmpID'];

        tblEMPLOYEE.Next;
      end;

      // Most Clients:
        i := 0;
        tblCLIENTS.First;
        while not tblCLIENTS.Eof do
        begin
          inc(i);
          if Pos(arrEmpID[i], tblCLIENTS['EmpID']) > Pos(arrEmpID[i+1], tblCLIENTS['EmpID']) then
          begin
            tblEMPLOYEE.First;
            while not tblEMPLOYEE.eof do
            begin
              if arrEmpID[i] <> tblEMPLOYEE['EmpID'] then
              begin
                tblEMPLOYEE.Filtered := False;
                tblEMPLOYEE.Filter   := 'EmpID =' + QuotedStr(arrEmpID[i]);
                tblEMPLOYEE.Filtered := True;

                if tblEMPLOYEE['EmployementStatus'] = False then
                begin
                  MostClient := 'Employee ID: '+#9+arrEmpID[i]+
                              #13+'Employee Name: '+tblEMPLOYEE['Fullname(s)']+' '+tblEMPLOYEE['Surname']+
                              #13+'Employement status: Unemployed'+
                              #13+'Date employed: '+#9+FormatDateTime('dd, mmmm, yyyy', tblEMPLOYEE['DateEmployed'])+
                              #13+'Date unemployed: '+#9+FormatDateTime('dd, mmmm, yyyy', tblEMPLOYEE['DateUnemployed']);
                end
                else if tblEMPLOYEE['EmployementStatus'] = True then
                begin
                  MostClient := 'Employee ID: '+#9+arrEmpID[i]+
                              #13+'Employee Name: '+tblEMPLOYEE['Fullname(s)']+' '+tblEMPLOYEE['Surname']+
                              #13+'Employement status: Employeed'+
                              #13+'Date employed: '+#9+FormatDateTime('dd, mmmm, yyyy', tblEMPLOYEE['DateEmployed']);
                end;

              end
              else MostClient := 'Results are inconclusive.';

              tblEMPLOYEE.Next;
            end;

          end;
          tblCLIENTS.Next;
        end; // while
     

      // Display:
      with reSTATS do
      begin
        Clear;
        SelAttributes.Style := [fsBold];
        Lines.Add(#9+#9+#9+'THE HAVEN NIGHT SHELTER');
        SelAttributes.Style := [fsBold];
        Lines.Add(#13+'Employee With Highest Client Input:');
        Lines.Add(MostClient);
        Lines.Add(#13+'-----------------------------------------------------------------------');
      end;

      // Most Events:
        i := 0;
        tblEVENTS.First;
        while not tblEVENTS.Eof do
        begin
          inc(i);
          if Pos(arrEmpID[i], tblEVENTS['EmpID']) > Pos(arrEmpID[i+1], tblEVENTS['EmpID']) then
          begin
            tblEMPLOYEE.First;
            while not tblEMPLOYEE.eof do
            begin
              if arrEmpID[i] <> tblEMPLOYEE['EmpID'] then
              begin
                tblEMPLOYEE.Filtered := False;
                tblEMPLOYEE.Filter   := 'EmpID =' + QuotedStr(arrEmpID[i]);
                tblEMPLOYEE.Filtered := True;

                if tblEMPLOYEE['EmployementStatus'] = False then
                begin
                  MostEvents := 'Employee ID: '+#9+arrEmpID[i]+
                              #13+'Employee Name: '+tblEMPLOYEE['Fullname(s)']+' '+tblEMPLOYEE['Surname']+
                              #13+'Employement status: Unemployed'+
                              #13+'Date employed: '+#9+FormatDateTime('dd, mmmm, yyyy', tblEMPLOYEE['DateEmployed'])+
                              #13+'Date unemployed: '+#9+FormatDateTime('dd, mmmm, yyyy', tblEMPLOYEE['DateUnemployed']);
                end
                else if tblEMPLOYEE['EmployementStatus'] = True then
                begin
                  MostEvents := 'Employee ID: '+#9+arrEmpID[i]+
                              #13+'Employee Name: '+tblEMPLOYEE['Fullname(s)']+' '+tblEMPLOYEE['Surname']+
                              #13+'Employement status: Employeed'+
                              #13+'Date employed: '+#9+FormatDateTime('dd, mmmm, yyyy', tblEMPLOYEE['DateEmployed']);
                end;

              end
              else MostEvents := 'Results are inconclusive.';

              tblEMPLOYEE.Next;
            end;
          end;
          tblEVENTS.Next;
        end; // while


      // Display:
      with reSTATS do
      begin
        SelAttributes.Style := [fsBold];
        Lines.Add('Employee With The Most Events Input:');
        Lines.Add(MostEvents);
        Lines.Add(#13+'-----------------------------------------------------------------------');
      end;

      // Most Sponsors:
      i := 0;
      tblSPONSERSHIPS.First;
      while not tblSPONSERSHIPS.Eof do
      begin
        Inc(i);
        if Pos(arrEmpID[i], tblSPONSERSHIPS['EmpID']) > Pos(arrEmpID[i+1], tblSPONSERSHIPS['EmpID']) then
        begin
          tblEMPLOYEE.First;
          while not tblEMPLOYEE.Eof do
          begin
            if arrEmpID[i] <> tblEMPLOYEE['EmpID'] then
            begin
              tblEMPLOYEE.Filtered := False;
              tblEMPLOYEE.Filter   := 'EmpID = '+QuotedStr(arrEmpID[i]);
              tblEMPLOYEE.Filtered := True;

              if tblEMPLOYEE['EmployementStatus'] = False then
              begin
                MostSponsors := 'Employee ID: '+#9+arrEmpID[i]+
                              #13+'Employee Name: '+tblEMPLOYEE['Fullname(s)']+' '+tblEMPLOYEE['Surname']+
                              #13+'Employement status: Unemployed'+
                              #13+'Date employed: '+#9+FormatDateTime('dd, mmmm, yyyy', tblEMPLOYEE['DateEmployed'])+
                              #13+'Date unemployed: '+#9+FormatDateTime('dd, mmmm, yyyy', tblEMPLOYEE['DateUnemployed']);
              end
              else if tblEMPLOYEE['EmployementStatus'] = True then
              begin
                MostSponsors := 'Employee ID: '+#9+arrEmpID[i]+
                              #13+'Employee Name: '+tblEMPLOYEE['Fullname(s)']+' '+tblEMPLOYEE['Surname']+
                              #13+'Employement status: Employeed'+
                              #13+'Date employed: '+#9+FormatDateTime('dd, mmmm, yyyy', tblEMPLOYEE['DateEmployed']);
              end;

            end
            else MostSponsors := 'Results are inconclusive.';
            tblEMPLOYEE.Next;
          end;
        end;
        tblSPONSERSHIPS.Next;
      end; // while

      // Display:
      with reSTATS do
      begin
        SelAttributes.Style := [fsBold];
        Lines.Add('Employee With The Most Sponsor Input:');
        Lines.Add(MostEvents);
        Lines.Add(#13+'-----------------------------------------------------------------------');
        Lines.Add(#13+'Copy generated by NEST Targeted System Solution.');
        Lines.Add('Developed by K.M Dinake.');
      end;



    end//Employees
    else if (rgbStatsSearch.ItemIndex = 2 ) then
    begin

      tblSPONSERSHIPS.Sort := 'Value DESC';

      // Higest Sponsor:
      tblSPONSERSHIPS.First;
      iHDonate := tblSPONSERSHIPS['Value'];
      sHSpons := 'SponsorID: ' + tblSPONSERSHIPS['SponserID'];
      tblSPONSERS.First;
      while not tblSPONSERS.Eof do
      begin
        if tblSPONSERSHIPS['SponserID'] = tblSPONSERS['SponserID'] then
        begin
          sHSpons := sHSpons +#13+ 'Sponsor name: '+tblSPONSERS['SponserName']+
                     #13+'Value of sponsorship: '+FloatToStrF(tblSPONSERSHIPS['Value'], ffCurrency, 10, 2)+
                     #13+'Industry of sponsor: '+tblSPONSERS['RelatedIndustry'];
        end;
        tblSPONSERS.Next;
      end;

      // Lowest Sponsor:
      tblSPONSERSHIPS.Last;
      iLDonate := tblSPONSERSHIPS['Value'];
      sLSpons := 'SponsorID: ' + tblSPONSERSHIPS['SponserID'];
      tblSPONSERS.First;
      while not tblSPONSERS.Eof do
      begin
        if tblSPONSERSHIPS['SponserID'] = tblSPONSERS['SponserID'] then
        begin
          sLSpons := sLSpons +#13+ 'Sponsor name: '+tblSPONSERS['SponserName']+
                     #13+'Value of sponsorship: '+FloatToStrF(tblSPONSERSHIPS['Value'], ffCurrency, 10, 2)+
                     #13+'Industry of sponsor: '+tblSPONSERS['RelatedIndustry'];
        end;
        tblSPONSERS.Next;
      end;

      // Average Sponsorship:
      rAveDonate := 0.00;

      tblSPONSERSHIPS.First;
      while not tblSPONSERSHIPS.Eof do
      begin
        rAveDonate := rAveDonate + tblSPONSERSHIPS['Value'];
        tblSPONSERSHIPS.Next;
      end;
        rAveDonate := rAveDonate / tblSPONSERSHIPS.RecordCount;

      // Display:
      with reSTATS do
      begin
        Clear;
        SelAttributes.Style := [fsBold];
        Lines.Add(#9+#9+#9+'THE HAVEN NIGHT SHELTER');
        SelAttributes.Style := [fsBold];
        Lines.Add(#13+'Most Valued Sponsor:');
        Lines.Add(sHSpons);
        Lines.Add(#13+'-----------------------------------------------------------------------');
        SelAttributes.Style := [fsBold];
        Lines.Add('Least Valued Sponsor:');
        Lines.Add(sLSpons);
        Lines.Add(#13+'-----------------------------------------------------------------------');
        SelAttributes.Style := [fsBold];
        Lines.Add('Average Sponsorship Value: '+FloatToStrF(rAveDonate, ffCurrency, 10, 2));
        Lines.Add(#13+'-----------------------------------------------------------------------');
        Lines.Add(#13+'Copy generated by NEST Targeted System Solution.');
        Lines.Add('Developed by K.M Dinake.');
      end;//with
    end//Sponsor
    else
      exit;



  end;//with

  // Dynamic Object: bitbtnPrint:
  bitbtnPrint := TBitBtn.Create(tsStatistics);
  with bitbtnPrint do
  begin
    Parent := tsStatistics;
    Caption:= 'Print';
    Height := 49;
    Width  := 97;
    Left   := 512;
    Top    := 584;
    if not FileExists(GetCurrentDir+'\Print image.bmp') then
    Glyph := nil
    else
    Glyph.LoadFromFile(GetCurrentDir+'\Print image.bmp');

    OnClick := bitbtnPrintClick;
    if bDone = true then
      Destroy;
  end;//with

end;

procedure TfrmAdminCentre.lblToAdminMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lblToAdmin.Font.Color := clSilver;
end;

procedure TfrmAdminCentre.lblToAdminMouseLeave(Sender: TObject);
begin
  lblToAdmin.Font.Color := clGray;
end;

procedure TfrmAdminCentre.bitbtnPrintClick(Sender: TObject);
var
  iNu : integer;

begin
  {Print}
  // Initialize:
  bDone := false;
  stat1.Panels[0].Text :='Printing...'; Application.ProcessMessages;
  Randomize;

  // Process Print:
  if reSTATS.Lines.Text = '' then
    exit
  else
  begin
    bDone := True;
    if frmAddPerson.PrinterSetupDialog1.Execute then
    begin
      iNu := RandomRange(1, 10000);
      stat1.Panels[0].Text := 'Saving...'; Application.ProcessMessages;
      reSTATS.Lines.SaveToFile(GetCurrentDir+'\Reports'+'\Statistics'+'\STATS'+IntToStr(iNu)+FormatDateTime('ddd, mmm, yyyyy', Now)+'.rtf');
      reSTATS.Lines.Clear;
      // Notification:
      MessageDlg('Report succesfully printed and saved!', mtInformation, [mbOK], 0);
    end;//print
  end;//else

  // Finalize:
  stat1.Panels[0].Text :='Ready'; Application.ProcessMessages;
end;

procedure TfrmAdminCentre.HowToGenerateStatistics1Click(Sender: TObject);
begin
  {Help _ Generate Stats}

  MessageDlg('How To Generate Statistics: '+
             #13+'1. Click on one of the three options listed in the Filter Selection group.'+
             #13+'2. If the filter selection is enabled then select an  option from the list, if not then proceed to step 3.'+
             #13+'3. Click on the Filter Search button to view the statistics results.'+
             #13+'For further help, seek the program administrator.', mtInformation, [mbOK], 0);

end;

procedure TfrmAdminCentre.HowtoAddEmployee1Click(Sender: TObject);
begin
  {Help_add EMP}

  MessageDlg('How To Add A New Employee:'+
              #13+'1. Enter all relevant personal information required. Eg: Name, surname and ID number.'+
              #13+'2. Provide your unique password, and verify it.'+
              #13+'3. Click on the Add Employee button to successfully save the new employee to the database.'+
              #13+'For further help, seek the program administrator.', mtInformation, [mbOK], 0);

end;

procedure TfrmAdminCentre.UpdateEmployeeInformation1Click(Sender: TObject);
begin
  {Help_update EMP}

  MessageDlg('How To Update Employee Information:'+
              #13+'1. Select an employee ID from the Select Username List.'+
              #13+'2. Input the new information you want to update.'+
              #13+'3. Click on the Update button to successfully update the employee''s information.'+
              #13+'For further help, seek the program administrator.', mtInformation, [mbOK], 0);

end;

procedure TfrmAdminCentre.Deleteanemployee1Click(Sender: TObject);
begin
  {Help_delete EMP}

  MessageDlg('How To Delete An Employee:'+
              #13+'1. Select an employee ID from the Select Username List.'+
              #13+'2. Click on the delete button to confirming the employee''s removal from employement.'+
              #13+'For further help, seek the program administrator.', mtInformation, [mbOK], 0);

end;

end. {Developed by K.M. Dinake ©}
