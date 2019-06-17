unit uLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, DB, ADODB, XPMan, Buttons;

type
  TfrmLogin = class(TForm)
    edtUsername: TEdit;
    edtPassword: TEdit;
    bitbtnLogin: TBitBtn;
    XPManifest1: TXPManifest;
    ADOConnection1: TADOConnection;
    tblParcels: TADOTable;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    dsParcels: TDataSource;
    qParcel: TADOQuery;
    procedure bitbtnLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;
  sUser : string;
implementation

uses uMain, dmParcel;

{$R *.dfm}

procedure TfrmLogin.bitbtnLoginClick(Sender: TObject);
begin
  {Verify Login}
  // check if there is input:
  if Length(edtUsername.Text) = 0 then
  begin
    MessageDlg('Enter a username!', mtWarning, [mbOK], 0);
    edtUsername.SetFocus;
    Exit;
  end;//

  // check if there is input:
  if Length(edtPassword.Text) = 0 then
  begin
    MessageDlg('Enter a password!', mtWarning, [mbOK], 0);
    edtPassword.SetFocus;
    Exit;
  end;//

  with DataModule1 do
  begin
    tblParcels.Filtered := False;
    tblParcels.Filter   := 'Username = '+QuotedStr(edtUsername.Text);
    tblParcels.Filtered := True;
    sUser := edtUsername.Text;
    // Check if username exists:
    if tblParcels.RecordCount = 0 then
    begin
      MessageDlg('Username does not exist!', mtWarning, [mbOK], 0);
      edtUsername.Clear;
      edtUsername.SetFocus;
      Exit;
    end;//

    // Check for invalid username:
    if edtUsername.Text <> tblParcels['Username'] then
    begin
      MessageDlg('Invalid Username!', mtWarning, [mbOK], 0);
      edtUsername.Clear;
      edtUsername.SetFocus;
      Exit;
    end;//

    // Check for invalid passcode:
    if edtPassword.Text <> tblParcels['Password'] then
    begin
      MessageDlg('Invalid password!', mtWarning, [mbOK], 0);
      edtPassword.Clear;
      edtPassword.SetFocus;
      Exit;
    end;//

  // Check for valid login credentials:
  if (edtUsername.Text = tblParcels['Username']) and (edtPassword.Text = tblParcels['Password']) then
  begin
    // Clear Components:
    edtUsername.Clear;
    edtPassword.Clear;
    edtUsername.SetFocus;
    // Load Forms:
    ShowMessage('Welcome To Paksca @ Northern Academy College: '+tblParcels['Username']);
    frmLogin.Hide;
    frmMain.Show;
  end;//

  end;//with



  // OLD METHOD _ OBSOLETE
 { tblParcels.First;

    while  not tblParcels.Eof do
    begin //whilwe
       sUser := tblParcels.FieldByName('Username').AsString;
       sPass := tblParcels.FieldByName('Password').AsString;

      if (sUser=edtUsername.Text ) and (sPass=edtPassword.Text) then
      begin
        ShowMessage('Welcome') ;
        frmMain.Show;
        frmLogin.Hide;
        break;
        frmLogin.Free;
       end
      else //if
        tblParcels.Next;
      end;//if

      if (tblParcels.Eof=True) and ((sUser<>edtUsername.Text ) or (sPass<>edtPassword.Text)) then
      begin
        MessageDlg('Invalid login credentials.', mtWarning, [mbOK], 0);
        edtUsername.Clear;
        edtPassword.Clear;
        edtUsername.SetFocus;
      end;//if
    end; //while   }

 {Copyright }
end;
end.
