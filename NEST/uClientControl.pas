unit uClientControl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ComCtrls, Buttons, Menus, ToolWin,
  ActnMan, ActnCtrls, ActnMenus, Spin, ExtCtrls, ExtDlgs,jpeg,DB, ADODB;

type
  TfrmAddPerson = class(TForm)
    dbgrdClients: TDBGrid;
    btnPrint: TBitBtn;
    lblClient: TLabel;
    mmClients: TMainMenu;
    File1: TMenuItem;
    Home1: TMenuItem;
    Exit1: TMenuItem;
    Exit2: TMenuItem;
    Exitt1: TMenuItem;
    grpClietInfo: TGroupBox;
    lbledtName: TLabeledEdit;
    lbledtSurname: TLabeledEdit;
    lbledtOrigin: TLabeledEdit;
    lbledtEmergencyContactNo: TLabeledEdit;
    btnAddClient: TBitBtn;
    btnCancel: TBitBtn;
    pgc1: TPageControl;
    tsClientControl: TTabSheet;
    redtClients: TRichEdit;
    tsSponser: TTabSheet;
    stat1: TStatusBar;
    lbl2: TLabel;
    lbledtSponserName: TLabeledEdit;
    dbgrdSponser: TDBGrid;
    cbbSponserKind: TComboBox;
    lblSponserKind: TLabel;
    lbledtAmount: TLabeledEdit;
    lbledtSponserType: TLabeledEdit;
    btnAddSponser: TBitBtn;
    tsEvents: TTabSheet;
    grpAddEvent: TGroupBox;
    grpViewEvents: TGroupBox;
    dbgrdEvents: TDBGrid;
    lblSelectEvent: TLabel;
    imgEvent: TImage;
    lbledtEventName: TLabeledEdit;
    lblDateOfEvent: TLabel;
    btnAddEvent: TBitBtn;
    btnEventCancel: TBitBtn;
    btnCancelSponser: TBitBtn;
    lblEventInfo: TLabel;
    mmEventDesc: TMemo;
    lblDescOfEvent: TLabel;
    cbbRealtedIndustry: TComboBox;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    lbledtPreviousCareer: TLabeledEdit;
    btnLoadEventIMG: TButton;
    btnLoadSponsIMG: TButton;
    Label2: TLabel;
    imgSponser: TImage;
    Timer1: TTimer;
    lbledtSponserValue: TLabeledEdit;
    DateTimePicker1: TDateTimePicker;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    lblValueOfSpons: TLabel;
    lblSavedByEmp: TLabel;
    mEventINFO: TMemo;
    Label9: TLabel;
    Label10: TLabel;
    PrinterSetupDialog1: TPrinterSetupDialog;
    Home2: TMenuItem;
    AddClient1: TMenuItem;
    AddNewSponsor1: TMenuItem;
    AddNewEvent1: TMenuItem;
    N1: TMenuItem;
    View1: TMenuItem;
    CLient1: TMenuItem;
    Sponsor1: TMenuItem;
    Event1: TMenuItem;
    dtpEventDate: TDateTimePicker;
    procedure Home1Click(Sender: TObject);
    procedure Exitt1Click(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnAddClientClick(Sender: TObject);
    procedure cbbSponserKindChange(Sender: TObject);
    procedure dbgrdEventsCellClick(Column: TColumn);
    procedure Exit2Click(Sender: TObject);
    procedure btnCancelSponserClick(Sender: TObject);
    procedure btnAddSponserClick(Sender: TObject);
    procedure btnEventCancelClick(Sender: TObject);
    procedure btnAddEventClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoadEventIMGClick(Sender: TObject);
    procedure btnLoadSponsIMGClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure tsClientControlShow(Sender: TObject);
    procedure tsSponserShow(Sender: TObject);
    procedure tsEventsShow(Sender: TObject);
    procedure dbgrdSponserCellClick(Column: TColumn);
    procedure lblUpdateEventClick(Sender: TObject);
    procedure lbledtAmountChange(Sender: TObject);
    procedure dbgrdClientsCellClick(Column: TColumn);
    procedure Label9Click(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure Label2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label2MouseLeave(Sender: TObject);
    procedure Label9MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label9MouseLeave(Sender: TObject);
    procedure Label10MouseLeave(Sender: TObject);
    procedure Label10MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AddClient1Click(Sender: TObject);
    procedure AddNewSponsor1Click(Sender: TObject);
    procedure AddNewEvent1Click(Sender: TObject);
    procedure CLient1Click(Sender: TObject);
    procedure Sponsor1Click(Sender: TObject);
    procedure Event1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddPerson: TfrmAddPerson;
  sSponsImagePath, sEventImgPath : String;
  imageDirBEGIN ,imageDirEND : string;
  sClientID,
  sEventID,
  sClient,
  sUpdateClient : String;

implementation

uses uMain, uLogin, uAdminCentre, dmHaven_NEST, uCheckIO, DateUtils, Math, StrUtils, clipbrd, VarUtils;

{$R *.dfm}

procedure TfrmAddPerson.Home1Click(Sender: TObject);
begin
  {Home}
  frmAddPerson.hide;
  frmMain.Show;
end;

procedure TfrmAddPerson.Exitt1Click(Sender: TObject);
begin
  {Exit}
  if (MessageDlg('Are you sure you want to exit this application ?', mtConfirmation, [mbYes, mbNo], 1)) = mrYes then
  Application.Terminate;
end;

procedure TfrmAddPerson.btnCancelClick(Sender: TObject);
begin
  {Cancel&Clear}
  lbledtName.Clear;
  lbledtSurname.Clear;
  lbledtOrigin.Clear;
  lbledtPreviousCareer.Clear;
  lbledtEmergencyContactNo.Clear;
  RadioGroup1.ItemIndex := -1;
  DateTimePicker1.Date := Now;
  redtClients.Lines.Clear;
end;

procedure TfrmAddPerson.btnPrintClick(Sender: TObject);
begin
  {Print}
  // Initialize:
  stat1.Panels[0].Text := 'Printing...'; Application.ProcessMessages;

  if redtClients.Text <> '' then
  begin

    if PrinterSetupDialog1.Execute then
    begin
      redtClients.Print('Client '+sClient+' '+FormatDateTime('dd, mmm, yyyy', Now));
      stat1.Panels[0].Text := 'Saving...'; Application.ProcessMessages;
      redtClients.Lines.SaveToFile('Reports\ClientReports\'+'Client '+sClient+' '+FormatDateTime('dd, mmm, yyyy', Now)+'.rtf');
      redtClients.Lines.Clear;
      // Notification:
      MessageDlg('Report succesfully printed and saved!', mtInformation, [mbOK], 0);
    end;

  end
  else exit;

  // Finalize:
  stat1.Panels[0].Text := 'Ready'; Application.ProcessMessages;
end;

procedure TfrmAddPerson.btnAddClientClick(Sender: TObject);
var
  sName, sSurname, sGender,
  sHome, sEContact, sCareer,
  sClientID, sDOB  : string;
  rName : Real;
  iAge, iErr, iEContact : Integer;
begin
{Insert Client into Database}
  // Initialize:
  Randomize;
  stat1.Panels[0].Text := 'Inserting...';
  Application.ProcessMessages;

{Validate}
  // Name
  if Length(lbledtName.Text) = 0 then
  begin
    MessageDlg('Enter a name!', mtWarning, [mbOK], 0);
    lbledtName.SetFocus;
    Exit;
  end;

  sName := lbledtName.Text;
  Val(sName, rName, iErr);
  if iErr = 0 then
  begin
    MessageDlg('Invalid name!', mtWarning, [mbOK], 0);
    lbledtName.SetFocus;
    Exit;
  end;


  // Surname
  if Length(lbledtSurname.Text) = 0 then
    sSurname := 'N/A'
  else
  begin
    sSurname := lbledtSurname.Text;
    Val(sSurname, rName, iErr);
    if iErr = 0 then
    begin
      MessageDlg('Invalid surname!', mtWarning, [mbOK], 0);
      lbledtSurname.SetFocus;
      Exit;
    end;
  end;

  // Date of Birth
  if DateTimePicker1.Date = Now then
  begin
    MessageDlg('Invalid date of birth!', mtWarning, [mbOK], 0);
    DateTimePicker1.SetFocus;
    exit;
  end
  else
    sDOB := FormatDateTime('dd/mm/yyyy', DateTimePicker1.Date);

  // Gender
  if (RadioGroup1.ItemIndex = -1) then
  begin
    MessageDlg('Select your gender!', mtWarning, [mbOK], 0);
    RadioGroup1.SetFocus;
    Exit;
  end;

  case RadioGroup1.ItemIndex of
    0 : sGender := 'MALE';
    1 : sGender := 'FEMALE';
  end;//case

  // Home
  if Length(lbledtOrigin.Text) = 0 then
    sHome := 'N/A'
  else
    sHome := lbledtOrigin.Text;

  // Emergency Contact
  if Length(lbledtEmergencyContactNo.Text) = 0 then
  begin
    sEContact := 'N/A';
  end
  else if Length(lbledtEmergencyContactNo.text) > 10 then
  begin
    MessageDlg('Emergency contact number out of bounds!', mtError, [mbOK], 0);
    lbledtEmergencyContactNo.SetFocus;
    Exit;
  end
  else
  begin
    sEContact := lbledtEmergencyContactNo.Text;
    Val(sEContact, iEContact, iErr);
    if iErr > 0 then
    begin
      MessageDlg('Invalid emergency contact number!', mtWarning, [mbOK], 0);
      lbledtEmergencyContactNo.SetFocus;
      Exit;
    end
    else sEContact := IntToStr(iEContact);
  end;



  // Career
  if Length(lbledtPreviousCareer.Text) = 0 then
    sCareer := 'N/A'
  else
    sCareer := lbledtPreviousCareer.Text;

  // Age
  iAge := YearOf(Now)-YearOf(StrToDate(sDOB));
  //ShowMessage(IntToStr(iAge));

  // ClientID
  sClientID := copy(sName, 1, 1)+IntToStr(RandomRange(100, 10000))+copy(sSurname, 1, 1);

{Save Client}
  with dmHaven do
  begin
   { tblCLIENTS.Append;
    tblCLIENTS['ClientID']               := sClientID;
    tblCLIENTS['EmpID']                  := sEmpID;
    tblCLIENTS['Fullname(s)']            := sName;
    tblCLIENTS['Surname']                := sSurname;
    tblCLIENTS['Gender']                 := sGender;
    tblCLIENTS['Date_of_Birth']          := StrToDate(sDOB);
    tblCLIENTS['Age']                    := iAge;
    tblCLIENTS['Origin_Home']            := sHome;
    tblCLIENTS['EmergencyContactNumber'] := sEContact;
    tblCLIENTS['PreviousCareer']         := UpperCase(sCareer);
    tblCLIENTS['DateOfArrival']          := StrToDate(FormatDateTime('dd/mm/yyyy', Now));
    tblCLIENTS.Post;     }
    // Notification:
    MessageDlg('Client: '+sClientID+' has been successfully added to the database.', mtInformation, [mbOK], 0);
  end;//with

  // Finalize:
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;
  btnCancelClick(Self);
  dbgrdClients.Refresh;
end;

procedure TfrmAddPerson.cbbSponserKindChange(Sender: TObject);
begin
  case cbbSponserKind.ItemIndex of
    0 : begin
          lbledtAmount.Visible := True;
          lbledtSponserType.Visible := False;
        end;//case 0
    1 : begin
          lbledtAmount.Visible := False;
          lbledtSponserType.Visible := True;
        end;//case 1
    2 : begin
          lbledtAmount.Visible := False;
          lbledtSponserType.Visible := True;
        end;//case 1
  end;
end;
procedure TfrmAddPerson.dbgrdEventsCellClick(Column: TColumn);
begin

  // Initialize:
  stat1.Panels[0].Text := 'Proccesing...';
  Application.ProcessMessages;
  mEventINFO.Clear;

  // Dispaly:
  lblEventInfo.Caption := 'Event Informantion...';
  lblEventInfo.Visible := True;
  mEventINFO.Visible   := true;

  {Get event info}

  // Filter by Event ID
  with dmHaven do
  begin
    dbgrdEvents.DataSource := nil;

    if tblEVENTS.RecordCount = 0 then
      exit;
      
    sEventID := tblEVENTS['EventID'];

    // Filter Events table:
    tblEVENTS.Filtered := False;
    tblEVENTS.Filter   :='EventID =' +QuotedStr(sEventID);
    tblEVENTS.Filtered := True;

    // Display:
    with mEventINFO.Lines do
    begin
      Add('Event Name: '+#9+tblEVENTS['EventName']);
      Add('Event Description: '+#9+tblEVENTS['EventDesc']);
      Add('Event Date: '+#9+DateToStr(tblEVENTS['EventDate']));
      Add('Added by employee: '+#9+tblEVENTS['EmpID']);
    end;//with

    // Check if filepath exists
    if FileExists(GetCurrentDir+'\Event Images\'+tblEVENTS['EventImageFile']) then
    begin
      //load image:
      if tblEVENTS['EventImageFile'] = '' then
        imgEvent.Picture.LoadFromFile(GetCurrentDir+'\NoIMGAvailable.bmp')
      else
        imgEvent.Picture.LoadFromFile(GetCurrentDir+'\Event Images\'+tblEVENTS['EventImageFile']);
    end
    else
    begin
      MessageDlg('File Not Found!', mtError, [mbOK], 0);
      imgEvent.Picture.LoadFromFile(GetCurrentDir+'\NoIMGAvailable.bmp');
    end;// else

    // Change Datasource:
    dbgrdEvents.DataSource := dsEVENTS;

    // Remove Filter:
    tblEVENTS.Filtered := False;
  end;//with

  // Finalize:
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;

end;

procedure TfrmAddPerson.Exit2Click(Sender: TObject);
begin
  {Logout}
  // Initialize:
  stat1.Panels[0].Text := 'Logging out...';
  Application.ProcessMessages;

  // Load Form:
  frmAddPerson.hide;
  frmMain.hide;
  frmLogin.Show;

  // Finalize:
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;
end;

procedure TfrmAddPerson.btnCancelSponserClick(Sender: TObject);
begin
  {Clear}
  if Length(lbledtSponserName.Text) > 0 then
  begin
    MessageDlg('Operation cancelled!', mtInformation, [mbOK], 0);
    lbledtSponserName.Clear;
    lbledtSponserType.Clear;
    lbledtAmount.Text := 'R';
    lbledtSponserValue.Text := 'R';
    lblValueOfSpons.Caption := '';
    lblSavedByEmp.Caption := '';
    cbbSponserKind.ItemIndex := -1;
    cbbRealtedIndustry.ItemIndex := -1;
    // Remove SponserImage:
    DeleteFile(sSponsImagePath);
    // Reset the Image
    imgSponser.Picture := nil;
  end
  else
  begin
    lbledtSponserName.Clear;
    lbledtSponserType.Clear;
    lbledtAmount.Text := 'R';
    lbledtSponserValue.Text := 'R';
    lblValueOfSpons.Caption := '';
    lblSavedByEmp.Caption := '';
    cbbSponserKind.ItemIndex := -1;
    cbbRealtedIndustry.ItemIndex := -1;
    // Remove SponserImage:
    DeleteFile(sSponsImagePath);
    // Reset the Image
    imgSponser.Picture := nil;
  end;
  end;

procedure TfrmAddPerson.btnAddSponserClick(Sender: TObject);
var
  sSponserID, sSponsName,
  sSponsKind, sSponsDESC,
  sRelatedIndustry, sValue : String;
  rSponsValue : real;
  iErr : integer;
begin
  {Insert Sponser}
  // Initialize:
  stat1.Panels[0].Text := 'Inserting...';
  Application.ProcessMessages;

  {Validate}
  //Name
  if (Length(lbledtSponserName.Text)= 0)  then
  begin
    MessageDlg('Enter the Sponsor name!',mtWarning, [mbOK], 0);
    lbledtSponserName.SetFocus;
    Exit;
  end
  else
    sSponsName := lbledtSponserName.Text;

  // kind, desc/amount:
  case cbbSponserKind.ItemIndex of
    0 : begin
          sSponsKind := 'Money';
          if lbledtAmount.Text = '' then
          begin
            MessageDlg('Enter the amount sponsored!', mtWarning, [mbOK], 0);
            lbledtAmount.SetFocus;
            Exit;
          end;//
          sSponsDESC := lbledtAmount.Text;
        end;
    1 : begin
          sSponsKind := 'Food';
          if lbledtSponserType.Text = '' then
          begin
            MessageDlg('Enter the sponsor description!', mtWarning, [mbOK], 0);
            lbledtSponserType.SetFocus;
            Exit;
          end;//
          sSponsDESC := lbledtSponserType.Text;
        end;
    2 : begin
          sSponsKind := 'Other';
          if lbledtSponserType.Text = '' then
          begin
            MessageDlg('Enter the sponsor description!', mtWarning, [mbOK], 0);
            lbledtSponserType.SetFocus;
            Exit;
          end;//
          sSponsDESC := lbledtSponserType.Text;
        end;
  end;//case

  // Value of sponsership
  sValue := Copy(lbledtSponserValue.Text, 2, Length(lbledtSponserValue.Text));
  val(sValue, rSponsValue, iErr);
  if iErr > 0 then
  begin
    MessageDlg('Enter the value of the sponsorship!', mtWarning, [mbOK], 0);
    lbledtSponserValue.SetFocus;
    Exit;
  end
  else
  begin
    delete(sValue, 1, 0);
    rSponsValue := StrToFloat(sValue);
    ShowMessage(FloatToStr(rSponsValue));
  end;//else


  // Industry
  if cbbRealtedIndustry.ItemIndex = -1 then
  begin
    MessageDlg('Select the related industry of the sponsor!', mtWarning, [mbOK], 0);
    cbbRealtedIndustry.SetFocus;
    Exit;
  end;//

  // Get industry
  case cbbRealtedIndustry.ItemIndex of
    0 : sRelatedIndustry := 'Finance';
    1 : sRelatedIndustry := 'Sports and Recreation';
    2 : sRelatedIndustry := 'Education';
    3 : sRelatedIndustry := 'Science and Research';
    4 : sRelatedIndustry := 'Technology';
    5 : sRelatedIndustry := 'Health and Environment';
    6 : sRelatedIndustry := 'Safety and Security';
    7 : sRelatedIndustry := 'Motors';
    8 : sRelatedIndustry := 'Clothing';
    9 : sRelatedIndustry := 'NGO';
    10 : sRelatedIndustry := 'Other';
  end;//case

  // SponserID:
  sSponserID := UpperCase(copy(sSponsName, 1, 1));
  Delete(sSponsName, 1, length(sSponsName)-1);
  sSponserID := sSponserID + UpperCase(sSponsName) +IntToStr(RandomRange(100, 10000));
  //ShowMessage(sSponserID);
  //ShowMessage(sSponsImagePath);

  // Reset Sponser name bcoz we deleted from it in SponserID:
  sSponsName := lbledtSponserName.Text;

  {SAVE Sponsor}
  with dmHaven do
  begin
    // Save to Sponsor Table
    tblSPONSERS.Append;
    tblSPONSERS['SponserID'] := sSponserID;
    tblSPONSERS['SponserName'] := sSponsName;
    tblSPONSERS['SponserKind'] := sSponsKind;
    tblSPONSERS['SponserDesc'] := sSponsDESC;
    tblSPONSERS['RelatedIndustry'] := sRelatedIndustry;
    tblSPONSERS['SponserImageFile'] := sSponsImagePath;
    tblSPONSERS.Post;

    // Save to Sponsorship Table:
    tblSPONSERSHIPS.Append;
    tblSPONSERSHIPS['SponserID'] := sSponserID;
    tblSPONSERSHIPS['EmpID'] := sEmpID;
    tblSPONSERSHIPS['Value'] := rSponsValue;
    tblSPONSERSHIPS.Post;
  end;//with

  // clear components:
  lbledtSponserName.Clear;
  lbledtSponserType.Clear;
  lbledtAmount.Text := 'R';
  lbledtSponserValue.Text := 'R';
  cbbSponserKind.ItemIndex := -1;
  cbbRealtedIndustry.ItemIndex := -1;
  imgSponser.Picture := nil;

  // Finalize:
  sSponsImagePath := '';
  ShowMessage('Sponsor: '+sSponserID+' is successfully added to the database.');
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;
  dbgrdSponser.Refresh;
end;

procedure TfrmAddPerson.btnEventCancelClick(Sender: TObject);
begin
  {Cancel}
  if Length(lbledtEventName.Text) > 0 then
  begin
    MessageDlg('Operation cancelled!', mtWarning, [mbOK], 0);
    lbledtEventName.Clear;
    mmEventDesc.Lines.Clear;
    dtpEventDate.Date := Now;
    DeleteFile(sEventImgPath);
    imgEvent.Picture := nil;
    mEventINFO.Clear;
  end
  else
  begin
    lbledtEventName.Clear;
    mmEventDesc.Lines.Clear;
    dtpEventDate.Date := Now;
    DeleteFile(sEventImgPath);
    imgEvent.Picture := nil;
    mEventINFO.Clear;
  end;// else

end;

procedure TfrmAddPerson.btnAddEventClick(Sender: TObject);
var
  sEventName,
  sEventDESC,
  sEventID, sEventDate : String;
  
begin
  {Insert Event}
  // Initialize:
  stat1.Panels[0].Text := 'Inserting...';
  Application.ProcessMessages;

  // Event Name
  if (Length(lbledtEventName.Text)= 0)  then
  begin
    MessageDlg('Enter the Event name!',mtWarning, [mbOK], 0);
    lbledtEventName.SetFocus;
    Exit;
  end
  else
    sEventName := lbledtEventName.Text;

  // Event Description:
  if (Length(mmEventDesc.Text)= 0)  then
  begin
    MessageDlg('Enter the Event description!',mtWarning, [mbOK], 0);
    mmEventDesc.SetFocus;
    Exit;
  end
  else
    sEventDESC := mmEventDesc.Text;
                                                   
  // Event date :
  sEventDate := FormatDateTime('dd/mm/yyyy', dtpEventDate.Date);
 // ShowMessage(sEventDate);
  if (MonthOfTheYear(dtpEventDate.Date) >= MonthOfTheYear(Now)) then
  begin
    MessageDlg('Event Date cannot be today, or a date before today! Enter a future date.', mtWarning, [mbOK], 0);
    dtpEventDate.SetFocus;
    Exit;
  end
  else
    sEventDate := FormatDateTime('dd/mm/yyyy', dtpEventDate.Date);

  // Generate EventID:
  sEventID := UpperCase(copy(sEventName, 1, 2))+IntToStr(RandomRange(100, 10000));
  //ShowMessage(sEventID);
  ShowMessage(sEmpID);
 // ShowMessage(sEventImgPath);

  {Save/Add Event}
  with dmHaven do
  begin
    // to Events Table
    tblEVENTS.Append;
    tblEVENTS['EventID'] := sEventID;
    tblEVENTS['EventName'] := sEventName;
    tblEVENTS['EventDesc'] := sEventDESC;
    tblEVENTS['EventDate'] := sEventDate;
    tblEVENTS['EventImageFile'] := sEventImgPath;
    tblEVENTS['EmpID'] := sEmpID;
    tblEVENTS.Post;
    
  end;//with

  // Finalize:
  sEventImgPath := '';
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;
  dbgrdEvents.Refresh;
end;

procedure TfrmAddPerson.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  {Exit}
  Application.Terminate;
end;

procedure TfrmAddPerson.btnLoadEventIMGClick(Sender: TObject);
var
  dFile : string;
begin
  // Initialize:
  stat1.Panels[0].Text := 'Loading...';
  Application.ProcessMessages;

  // Load sponser image:
  if OpenDialog1.Execute then
  begin
    imageDirBEGIN := OpenDialog1.FileName;
   // ShowMessage(imageDirBEGIN);
    dFile := ExtractFileName(imageDirBEGIN);
  //  ShowMessage(dFile);
    //check for directory
    if DirectoryExists(GetCurrentDir+'\'+'Keoagile Dinake_17029_IT_PAT'+'\'+'Phase 3'+'\'+'Event Images\') then
      begin
        imageDirEND :=  GetCurrentDir+'\'+'Keoagile Dinake_17029_IT_PAT'+'\'+'Phase 3'+'\'+'Event Images\';
        CopyFile(pchar(imageDirBEGIN),pchar(imageDirEND+dFile),True);
      end
    else
      begin
        CreateDir(GetCurrentDir+'\'+'Keoagile Dinake_17029_IT_PAT'+'\'+'Phase 3'+'\'+'Event Images\');
        Application.ProcessMessages;
        CopyFile(pchar(imageDirBEGIN),pchar(imageDirEND+dFile),True);
      end; //else

    // Display image preview:
    imgEvent.Picture.LoadFromFile(imageDirEND+dFile);

    // Verify Image preview:
    if (MessageDlg('Is this the correct image?', mtConfirmation, [mbYes, mbNo], 0))= mrYes then
    begin
      // save file path:
      sEventImgPath := dFile;
     // ShowMessage(sEventImgPath);
      MessageDlg('Image saved!', mtInformation, [mbOK], 0);
      imgEvent.Picture := nil;
      Exit;
    end
    else
    begin
      imgEvent.Picture := nil;
      MessageDlg('Operation cancelled. Reselect your image.', mtInformation, [mbOK], 0);
      Exit;
    end;//else

  end;// openDialog

  // Finalize:
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;

end;
procedure TfrmAddPerson.btnLoadSponsIMGClick(Sender: TObject);
var
  dLoc : string;
begin
  // Initialize:
  stat1.Panels[0].Text := 'Loading...';
  Application.ProcessMessages;

  // Load sponser image:
  if OpenDialog1.Execute then
  begin
    imageDirBEGIN := OpenDialog1.FileName;
    dLoc := ExtractFileName(imageDirBEGIN);

    //check for directory:
    if DirectoryExists(GetCurrentDir+'\'+'Keoagile Dinake_17029_IT_PAT'+'\'+'Phase 3'+'\'+'Sponsers\') then
      begin
        imageDirEND :=  GetCurrentDir+'\'+'Keoagile Dinake_17029_IT_PAT'+'\'+'Phase 3'+'\'+'Sponsers\';
        CopyFile(pchar(imageDirBEGIN),pchar(imageDirEND+dLoc),True);
      end
    else
      begin
        CreateDir(GetCurrentDir+'\'+'Keoagile Dinake_17029_IT_PAT'+'\'+'Phase 3'+'\'+'Sponsers\');
        Application.ProcessMessages;
        CopyFile(pchar(imageDirBEGIN),pchar(imageDirEND+dLoc),True);
      end; //else

    // Display image Preview:
    imgSponser.Picture.LoadFromFile(imageDirEND+dLoc);

    if (MessageDlg('Is this the correct image?', mtConfirmation, [mbYes, mbNo], 0))= mrYes then
    begin
      // save file path:
      sSponsImagePath := dLoc;
      MessageDlg('Image saved!', mtInformation, [mbOK], 0);
      Exit;
    end
    else
    begin
      imgSponser.Picture := nil;
      MessageDlg('Operation cancelled. Reselect your image.', mtInformation, [mbOK], 0);
      Exit;
    end;//else

  end;//opendialog

  // Finalize:
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;

end;
procedure TfrmAddPerson.Label2Click(Sender: TObject);
var
  sPasscode: string;
begin
  // View stats page:
  sPasscode := InputBox('Authorise Access', 'Enter passcode.', '');
  if sPasscode = '' then
    Exit;

  {Check Authorise}
  if UpperCase(sPasscode) = 'IMBOSS' then
  begin
      MessageDlg('Access granted!', mtInformation, [mbOK] ,0);
      frmAddPerson.Hide;
      frmAdminCentre.Visible := True;
      frmAdminCentre.pgcAdmin.ActivePage := frmAdminCentre.tsStatistics;
    end
    else
      MessageDlg('Access Denied! You do not have admin rights.', mtWarning, [mbOK], 0);
      Exit;

end;

procedure TfrmAddPerson.Timer1Timer(Sender: TObject);
begin
  // show time:
  stat1.Panels[1].Text := TimeToStr(Now);

end;

procedure TfrmAddPerson.tsClientControlShow(Sender: TObject);
begin
  {Clear}
  btnCancelClick(Self);
end;

procedure TfrmAddPerson.tsSponserShow(Sender: TObject);
begin
  {Clear}
  btnCancelSponserClick(Self);
end;

procedure TfrmAddPerson.tsEventsShow(Sender: TObject);
begin
  {Clear}
  btnEventCancelClick(Self);
  mEventINFO.Clear;
end;


procedure TfrmAddPerson.dbgrdSponserCellClick(Column: TColumn);
var
  sSponsID : string;
begin
  {Get Sponser Info}

  // Initialize:
  stat1.Panels[0].Text := 'Loading...';
  Application.ProcessMessages;
  lblValueOfSpons.Caption := '';
  lblSavedByEmp.Caption := '';

  // Filter by SponserID:
  with dmHaven do
  begin
    dbgrdSponser.DataSource := nil;

    if tblSPONSERSHIPS.RecordCount = 0 then
    exit;

    // Get sponsor ID:
    sSponsID := tblSPONSERS['SponserID'];

    // Check if filepath exists
   // ShowMessage(GetCurrentDir);
    if FileExists(GetCurrentDir+'\Sponsers\'+tblSPONSERS['SponserImageFile']) then
    begin
      //load image:
      if tblSPONSERS['SponserImageFile'] = '' then
      begin
        imgSponser.Picture.LoadFromFile(GetCurrentDir+'\NoIMGAvailable.bmp');
        // Remove Filter:
        tblSPONSERS.Filtered := false;
        dbgrdSponser.Refresh;
        dbgrdSponser.DataSource := dsSPONSERS;
      end
      else
        imgSponser.Picture.LoadFromFile(GetCurrentDir+'\Sponsers\'+tblSPONSERS['SponserImageFile']);
    end
    else
    begin
        MessageDlg('File Not Found!', mtError, [mbOK], 0);
        imgSponser.Picture.LoadFromFile(GetCurrentDir+'\NoIMGAvailable.bmp');
        // Remove Filter:
        tblSPONSERS.Filtered := false;
        dbgrdSponser.Refresh;
        dbgrdSponser.DataSource := dsSPONSERS;
    end;//else

    // filter sponsorship:
    tblSPONSERSHIPS.Filtered := False;
    tblSPONSERSHIPS.Filter   := 'SponserID =' + QuotedStr(sSponsID);
    tblSPONSERSHIPS.Filtered := True;

    // Get Sponsor Info:
    lblValueOfSpons.Caption := 'Value of sponsorship: '+FloatToStrF(tblSPONSERSHIPS['Value'], ffCurrency, 6, 2);
    lblSavedByEmp.Caption   := 'Saved by employee: '+tblSPONSERSHIPS['EmpID'];


    // Change Datasource:
    dbgrdSponser.DataSource := dsSPONSERS;

    // Remove Filter:
    tblSPONSERSHIPS.Filtered := false;
  end;//with

  // Finalize:
  stat1.Panels[0].Text := 'Ready';
  Application.ProcessMessages;
end;

procedure TfrmAddPerson.lblUpdateEventClick(Sender: TObject);
var
  sEventName : String;
begin
  {Get event Name}
  if sEventID = '' then
  begin
    MessageDlg('First select an event to update!', mtWarning, [mbOK], 0);
    dbgrdEvents.SetFocus;
    Exit;
  end
  else
  begin
    with dmHaven do
    begin
      tblEVENTS.Filtered := False;
      tblEVENTS.Filter   := 'EventID ='+QuotedStr(sEventID);
      tblEVENTS.Filtered := True;
      sEventName := tblEVENTS['EventName'];
      Application.ProcessMessages;

      // Remove Filter:
      tblEVENTS.Filtered := False;
    end;// with
  end;//else
end;

procedure TfrmAddPerson.lbledtAmountChange(Sender: TObject);
begin
  // Display Money sponsered:
  lbledtSponserValue.Text := lbledtAmount.Text;
end;

procedure TfrmAddPerson.dbgrdClientsCellClick(Column: TColumn);
var
  CName, Surname,  Age, Orign, EcontactNo, Career: String;
  sName: string;
  ArrivalDate, DOB : TDate;
begin
   {Display client info in richedit}

  with dmHaven do
  begin
    // Remove filter:
    tblCLIENTS.Filtered := false;
    
    sClient := tblCLIENTS['ClientID'];

    // Extract 1st name if there are two or more names:
    if pos(' ',tblCLIENTS['Fullname(s)']) > 0 then
    begin
      sName := tblCLIENTS['Fullname(s)'];
      CName := copy(sName,1, pos(' ', sName)-1);
      Delete(sName, 1, pos(' ', sName));
      CName := CName+' '+sName;
    end
    else
      //ShowMessage(tblCLIENTS['Fullname(s)']);
      CName := tblCLIENTS['Fullname(s)'];

    // Get Info:
    Surname := tblCLIENTS['Surname'];
    DOB := tblCLIENTS['Date_of_Birth'];
    Age := tblCLIENTS.FieldByName('Age').AsString;
    Orign := tblCLIENTS['Origin_Home'];
    EcontactNo := tblCLIENTS['EmergencyContactNumber'];
    Career := tblCLIENTS['PreviousCareer'];
    ArrivalDate := tblCLIENTS['DateOfArrival'];

    // Display:
    redtClients.Clear;
    with redtClients.Lines do
    begin
      redtClients.SelAttributes.Style := [fsBold];
      Add(#9+#9+#9+#9+#9+#9+'HAVEN NIGHT SHELTER'+#13+''
          +#13+'CLIENT INFORMATION');
      Add('Client Name: '+CName+#9+#9+'Surname: '+Surname
          +#13+'Age: '+Age+#9+#9+#9+#9+'Born on the: '+FormatDateTime('dd, mmmm, yyyy', DOB));
      redtClients.SelAttributes.Style := [fsBold];
      Add('Additional Information');
      Add('Last place of residence: '+#9+#9+Orign
          +#13+'Emergency Contact Number: '+#9+EcontactNo
          +#13+'Previous job career: '+#9+#9+Career
          +#13+'Arrived in: '+#9+#9+#9+FormatDateTime('dd, ddd, mmmm, yyyy', ArrivalDate));
      Add(#13+'Copy generated by NEST Targeted Systems Solution.'
         +#13+'Developed by K.M Dinake.');
    end;// with

  end;//with

end;

procedure TfrmAddPerson.Label9Click(Sender: TObject);
var
  sPasscode : string;
begin
    // View stats page:
  sPasscode := InputBox('Authorise Access', 'Enter passcode.', '');
  if sPasscode = '' then
    Exit;

  {Check Authorise}
  if UpperCase(sPasscode) = 'IMBOSS' then
  begin
      MessageDlg('Access granted!', mtInformation, [mbOK] ,0);
      frmAddPerson.Hide;
      frmAdminCentre.Visible := True;
      frmAdminCentre.pgcAdmin.ActivePage := frmAdminCentre.tsStatistics;
    end
    else
      MessageDlg('Access Denied! You do not have admin rights.', mtWarning, [mbOK], 0);
      Exit;
end;

procedure TfrmAddPerson.Label10Click(Sender: TObject);
var
  sPasscode : string;
begin
    // View stats page:
  sPasscode := InputBox('Authorise Access', 'Enter passcode.', '');
  if sPasscode = '' then
    Exit;

  {Check Authorise}
  if UpperCase(sPasscode) = 'IMBOSS' then
  begin
      MessageDlg('Access granted!', mtInformation, [mbOK] ,0);
      frmAddPerson.Hide;
      frmAdminCentre.Visible := True;
      frmAdminCentre.pgcAdmin.ActivePage := frmAdminCentre.tsStatistics;
    end
    else
      MessageDlg('Access Denied! You do not have admin rights.', mtWarning, [mbOK], 0);
      Exit;
end;

procedure TfrmAddPerson.Label11Click(Sender: TObject);
var
  sPasscode : string;
begin
    // View stats page:
  sPasscode := InputBox('Authorise Access', 'Enter passcode.', '');
  if sPasscode = '' then
    Exit;

  {Check Authorise}
  if UpperCase(sPasscode) = 'IMBOSS' then
  begin
      MessageDlg('Access granted!', mtInformation, [mbOK] ,0);
      frmAddPerson.Hide;
      frmAdminCentre.Visible := True;
      frmAdminCentre.pgcAdmin.ActivePage := frmAdminCentre.tsStatistics;
    end
    else
      MessageDlg('Access Denied! You do not have admin rights.', mtWarning, [mbOK], 0);
      Exit;
end;

procedure TfrmAddPerson.Label2MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  Label2.Font.Color := clSilver;
end;

procedure TfrmAddPerson.Label2MouseLeave(Sender: TObject);
begin
  Label2.Font.Color := clGray;
end;

procedure TfrmAddPerson.Label9MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    Label9.Font.Color := clSilver;
end;

procedure TfrmAddPerson.Label9MouseLeave(Sender: TObject);
begin
  Label9.Font.Color := clGray;
end;

procedure TfrmAddPerson.Label10MouseLeave(Sender: TObject);
begin
  Label10.Font.Color := clGray;
end;

procedure TfrmAddPerson.Label10MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  Label10.Font.Color := clSilver;
end;

procedure TfrmAddPerson.AddClient1Click(Sender: TObject);
begin
  {HELP _ Add New Client}
  MessageDlg('How To Add A New Client:'+
             #13+'1. Enter all relevant personal information.'+
             #13+'2. Click on the Add Client button to successfully save the new client to the database.'+
             #13+'For further help, seek the program administrator.', mtInformation, [mbOK], 0);
end;

procedure TfrmAddPerson.AddNewSponsor1Click(Sender: TObject);
begin
  {HELP _ Add New Sponsor}
  MessageDlg('How To Add A New Sponsor:'+
             #13+'1. Enter all information related to the sponsor.'+
             #13+'2. Load an image of the sponsor.(Optional)'+
             #13+'3. Click on the Add Sponsor button to successfully save the new sponsor to the database.'+
             #13+'For further help, seek the program administrator.', mtInformation, [mbOK], 0);
end;

procedure TfrmAddPerson.AddNewEvent1Click(Sender: TObject);
begin
  {HELP _ Add New Event}
  MessageDlg('How To Add A New Event:'+
             #13+'1. Enter all information related to the event.'+
             #13+'2. Load an image of the event.(Optional)'+
             #13+'3. Click on the Add Event button to successfully save the new event to the database.'+
             #13+'For further help, seek the program administrator.', mtInformation, [mbOK], 0);
end;

procedure TfrmAddPerson.CLient1Click(Sender: TObject);
begin
  {Help _ view client}
  MessageDlg('How To View A Client''s Information: '+
             #13+'1. Select and click on the record of the client whose information you want to view.'+
             #13+'2. Click on the Print button to print the client''s information.'+
             #13+'For further help, seek the program administrator.', mtInformation, [mbOK], 0);
end;

procedure TfrmAddPerson.Sponsor1Click(Sender: TObject);
begin
  {Help _ view sponsor}
  MessageDlg('How To View A Sponsor''s Information: '+
             #13+'1. Select and click on the record of the sponsor whose information you want to view.'+
             #13+'For further help, seek the program administrator.', mtInformation, [mbOK], 0);
end;

procedure TfrmAddPerson.Event1Click(Sender: TObject);
begin
  {Help _ view event}
  MessageDlg('How To View A Client''s Information: '+
             #13+'1. Select and click on the record of the event whose information you want to view.'+
             #13+'Additional Help: Update An Event.'+
             #13+'1. Select an event.'+
             #13+'2. Click on Click to update an event label.'+
             #13+'For further help, seek the program administrator.', mtInformation, [mbOK], 0);
end;

end. {Developed by K.M. Dinake ©}
