unit uRecoveryClass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, Buttons, ComCtrls, DB, ADODB;

type
  TRecovery = class(TObject)

  private
    // Properties:
    fUsername : String;
    fRecoveryQues : String;
    fRecoveryAnswer : String;

  public
    // Constructor:
    constructor create(theUser : String);

    // Manipulators:
    procedure setUsername(theUser : String);
    procedure setRecoveryQues(theQues : String);
    procedure setRecoveryAnswer(theAnswer : String);

    // Accessors:
    function validAnwer(theAnswer : String; theTable : TADOTable) : Boolean;
    function getAnswer(theTable : TADOTable): String;

    // toString:
    function RecoveryPasswordLog : string;

end;//TRecovery

var
  bValid : Boolean;

implementation

uses dmHaven_NEST, Math ;


{ TRecovery }

constructor TRecovery.create(theUser: String);
begin
  // Default Values:
  fUsername := theUser;
  fRecoveryQues := '';
  fRecoveryAnswer := '';
end;

function TRecovery.getAnswer(theTable : TADOTable): String;
begin
  with dmHaven do
  begin
    Result := theTable['Password'];
    ShowMessage('Your Password is: '+Result);
  end;//with
end;

function TRecovery.RecoveryPasswordLog: string;
var
  sInfo : String;
  tRecoveryLog : TextFile;
  sDate, sTime : String;
begin
  // Initialize:
  AssignFile(tRecoveryLog, GetCurrentDir+'\Reports\RecoveryReports\RecoveryPasscodeLog'+FormatDateTime('dd, mmm, yyyy', Now)+'.txt');

  // Check if file exists:
  if not FileExists(GetCurrentDir+'\Reports\RecoveryReports\RecoveryPasscodeLog'+FormatDateTime('dd, mmm, yyyy', Now)+'.txt') then
  begin
    MessageDlg('File not found, but we will create it.', mtInformation, [mbOK], 0);
    Rewrite(tRecoveryLog);
    CloseFile(tRecoveryLog);
  end;
  MessageDlg('Saving to file...', mtInformation, [mbOK], 0);

  // Get info:
  sDate := FormatDateTime('dd/mm/yyyy', Now);
  sTime := TimeToStr(Now);

  // Correct Answer:
  if bValid = true then
    sInfo := fUsername+'#'+'Recovered'+'#'+sDate+#9+sTime
  else
    sInfo := fUsername+'#'+'NotRecovered'+'#'+sDate+#9+sTime;

  // Write to file:
  Append(tRecoveryLog);

  Writeln(tRecoveryLog, sInfo);
  CloseFile(tRecoveryLog);

end;

procedure TRecovery.setRecoveryAnswer(theAnswer: String);
begin
  fRecoveryAnswer := theAnswer;
end;

procedure TRecovery.setRecoveryQues(theQues: String);
begin
  fRecoveryQues := theQues;
end;

procedure TRecovery.setUsername(theUser: String);
begin
  fUsername := theUser;
end;

function TRecovery.validAnwer(theAnswer: String; theTable : TADOTable): Boolean;
begin
  {VALID ANSWER}

  with dmHaven do
  begin
    // Filter By Username:
    theTable.Filtered := False;
    theTable.Filter   := 'EmpID =' +QuotedStr(fUsername);
    theTable.Filtered := True;

    // Check is username exists:
    if theTable.RecordCount = 0 then
      MessageDlg('Username does not exist!', mtWarning, [mbOK], 0);


    // check Recovery Question
    if fRecoveryQues <> theTable['RecoveryQuestion'] then
    begin
      bValid := False;
      Result := bValid;
      MessageDlg('Incorrect recovery question!', mtWarning, [mbOK], 0);
    end;


    // Check  Answer:
    if fRecoveryAnswer <> theTable['RecoveryAnswer'] then
    begin
      bValid := False;
      Result := bValid;
      MessageDlg('Incorrect recovery answer!', mtWarning, [mbOK], 0);
    end;//

    // Correct:
    if (fUsername = theTable['EmpID']) and (fRecoveryQues = theTable['RecoveryQuestion']) and (fRecoveryAnswer = theTable['RecoveryAnswer']) then
      bValid := True;
      Result := bValid;

  end;//with
end;

end. {Developed by K.M. Dinake ©}
