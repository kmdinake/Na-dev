unit uNewParcel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, ExtCtrls, StdCtrls, Buttons, Menus, ComCtrls, uParcel,
  DB, ADODB, jpeg;

type
  TfrmNewParcel = class(TForm)
    Image1: TImage;
    lblRelation: TLabel;
    bitbtnSave: TBitBtn;
    memParcelDescription: TMemo;
    bitbtnClear: TBitBtn;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    eXIT1: TMenuItem;
    Timer1: TTimer;
    cbboxCategory: TComboBox;
    cbboxRelation: TComboBox;
    Image3: TImage;
    lbledtStudentNo: TLabeledEdit;
    lbledtRelation: TLabeledEdit;
    lbledtParcelBearerName: TLabeledEdit;
    lbledtCategory: TLabeledEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblParcelDesription: TLabel;
    Label1: TLabel;
    Image2: TImage;
    Label2: TLabel;
    Label6: TLabel;
    Home1: TMenuItem;
    Logout1: TMenuItem;
    Exit2: TMenuItem;
    N1: TMenuItem;
    procedure bitbtnClearClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure bitbtnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbboxRelationChange(Sender: TObject);
    procedure Home1Click(Sender: TObject);
    procedure Logout1Click(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure Howtoaddarecord1Click(Sender: TObject);
   

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmNewParcel: TfrmNewParcel;
  myParcel    : TParcel;

implementation
uses uMain, uLogin, dmParcel;

{$R *.dfm}

procedure TfrmNewParcel.bitbtnClearClick(Sender: TObject);
begin
  lbledtParcelBearerName.Clear;
  lbledtStudentNo.Clear;
  memParcelDescription.Clear;
  cbboxRelation.ItemIndex:=0;
  cbboxCategory.ItemIndex:=0;
  lbledtRelation.Clear;
  lbledtCategory.Clear;
end;

procedure TfrmNewParcel.Timer1Timer(Sender: TObject);
begin
  //lblTime.Caption:= FormatDateTime('hh:nn:ss',Now);
  StatusBar1.Panels[1].Text:= FormatDateTime('hh:mm:ss',Now);

end;

procedure TfrmNewParcel.bitbtnSaveClick(Sender: TObject);
var
  sReceivedBy : string;
begin
  //Create:
    FormCreate(Self);
    
      with DataModule1 do
      begin

        //Get the Date Received:
       myParcel.setDateReceived(FormatDateTime('yyyy/mm/dd',Now));

      //Get relation:
      if cbboxRelation.ItemIndex=6 then
        myParcel.changeRelation(lbledtRelation.Text)
      else    myParcel.changeRelation(cbboxRelation.Text);

        //Get Received By:
        sReceivedBy := copy(Label6.Caption, pos(':', Label6.Caption)+2, length(Label6.Caption));
        ShowMessage(sReceivedBy);
        myParcel.setReceivedBy(sReceivedBy);

        //Get category:
        if cbboxCategory.ItemIndex=3 then myParcel.setCategory(lbledtCategory.Text)
        else myParcel.setCategory(cbboxCategory.Text);

        //Save details of parcel:
        qrySaveToFile.SQL.Text:=myParcel.toFileString;
        qrySaveToFile.ExecSQL;

      end;//with

        //Finalize:
        MessageDlg('Parcel has successfully been saved.', mtInformation, [mbOK], 0);
        frmMain.Show;
        frmMain.Update;
        bitbtnClearClick(Self);
        frmNewParcel.Close;

end;

procedure TfrmNewParcel.FormCreate(Sender: TObject);
begin
   //Create or instaniate the object:
   Label5.Width:=81;
  myParcel:= TParcel.create(StrToInt(Label5.Caption),lbledtStudentNo.Text, memParcelDescription.Text, lbledtParcelBearerName.Text);

end;

procedure TfrmNewParcel.FormShow(Sender: TObject);
begin

   lbledtRelation.Visible:=False;
   lbledtCategory.Visible:=False;
   Label6.Caption := 'Logged in as: '+sUser;

   with DataModule1 do
   begin
    tblParcel.Filtered:=False;
    tblParcel.Last;
    if tblParcel.FieldByName('ParcelNo').AsString<>'' then
    begin
      Label5.Caption:=IntToStr(tblParcel.RecordCount+1);
      Label5.Repaint;
    end;//if
   end;//with
end;

procedure TfrmNewParcel.cbboxRelationChange(Sender: TObject);
begin
   //Make lbledtRelation visible to specify other Relation:
  if cbboxRelation.ItemIndex=6 then
    lbledtRelation.Visible:=True
  else lbledtRelation.Visible:=False;

  //Make lbledtCategory visible to specify other Category:
  if cbboxCategory.ItemIndex=3 then
    lbledtCategory.Visible:=True
  else lbledtCategory.Visible:=False;
end;

procedure TfrmNewParcel.Home1Click(Sender: TObject);
begin
  {Home}
  frmNewParcel.hide;
  frmMain.Show;
end;

procedure TfrmNewParcel.Logout1Click(Sender: TObject);
begin
  {logout}
  if (MessageDlg('Are you sure you want to logout?', mtConfirmation, [mbNo, mbYes], 0)) = mrYes then
  begin
    frmNewParcel.hide;
    frmLogin.Show;
  end
  else Exit;

end;

procedure TfrmNewParcel.Exit2Click(Sender: TObject);
begin
  {Exit}
  if (MessageDlg('Are you sure you want to exit this application?', mtConfirmation, [mbNo, mbYes], 0))=mryes then
  begin
    Application.Terminate;
  end;
end;

procedure TfrmNewParcel.Howtoaddarecord1Click(Sender: TObject);
begin
  ShowMessage('1.Stephen write down the procedure to add a new record!'+#13+'2.Seek help from administrator.');
end;

end.
