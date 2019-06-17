unit uSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, XPMan, ComCtrls, Grids, DBGrids, Buttons,
  jpeg, DB, ADODB, Menus, MPlayer, System.UITypes;

type
  TfrmSearch = class(TForm)
    StatusBar1: TStatusBar;
    PrinterSetupDialog1: TPrinterSetupDialog;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Exit2: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label3: TLabel;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    rgbSearchBy: TRadioGroup;
    DBGrid1: TDBGrid;
    DateTimePicker1: TDateTimePicker;
    TabSheet2: TTabSheet;
    bitbtnPrint: TBitBtn;
    Exit3: TMenuItem;
    Home1: TMenuItem;
    reSearch: TRichEdit;
    bitbtnViewReport: TBitBtn;
    bitbtnCheckOutParcel: TBitBtn;
    BitBtn1: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    Image4: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Image6: TImage;

    procedure rgbSearchByClick(Sender: TObject);
    procedure bitbtnPrintClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Exit1Click(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure Home1Click(Sender: TObject);
    procedure Exit3Click(Sender: TObject);
    procedure bitbtnViewReportClick(Sender: TObject);
    procedure bitbtnCheckOutParcelClick(Sender: TObject);
    procedure DateTimePicker1Enter(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
   // procedure DBGrid2CellClick(Column: TColumn);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSearch: TfrmSearch;
  sParcel : String;

implementation
uses dmParcel, uMain, uLogin;

{$R *.dfm}

procedure TfrmSearch.rgbSearchByClick(Sender: TObject);
var
  iErr,
  iStudentNo : Integer;
  sInput     : string;
begin

  // Searching:

  with DataModule1 do
  begin
    case rgbSearchBy.ItemIndex of
      0 : begin
            // Initialize:
            StatusBar1.Panels[0].Text := 'Searching...';
            Application.ProcessMessages;
            Label3.Visible := false;
            DateTimePicker1.Visible := false;

            sInput := InputBox('Search student number', 'Enter a student number', '');
            if length(sInput) = 0 then
            begin
              MessageDlg('No records found!', mtWarning, [mbOK], 0);
              rgbSearchBy.ItemIndex := -1;
              exit;
            end;//if

            val(sInput, iStudentNo, iErr);
            if iErr > 0 then
            begin
              MessageDlg('Invalid student number!', mtWarning, [mbOK], 0);
              rgbSearchBy.Buttons[0].Checked:=false;
              exit;
            end;// if

            // SQL :
            qStudentNo.SQL.Text := 'Select * from PARCEL where [StudentNo] = '+QuotedStr(sInput)+'';
            qStudentNo.Open;

            // Check for studentNo :
            if qStudentNo.FieldByName('StudentNo').AsString <> sInput then
            begin
              MessageDlg('Student number: '+sInput+' does not exist!', mtWarning, [mbOK], 0);
              rgbSearchBy.ItemIndex := -1;
              tblParcel.Filtered := False;
              DBGrid1.DataSource := nil;
              exit;
            end;//

            DBGrid1.DataSource := dsStudentNo;

            // Finalize:
            StatusBar1.Panels[0].Text := 'Ready';
            Application.ProcessMessages;

          end;// caseSTUDENTno

      1 : begin
            // Initialize:
            Label3.Visible := true;
            DateTimePicker1.Visible := true;
          //  DateTimePicker1.SetFocus;

            // cosmetics:
            StatusBar1.Panels[0].Text := 'Searching...';
            Application.ProcessMessages;

            
            // Finalize:
            StatusBar1.Panels[0].Text := 'Ready';
            Application.ProcessMessages;

          end;//1 caseDATE

      2 : begin
            // Initialize:
            Label3.Visible := false;
            DateTimePicker1.Visible := false;

            sInput := InputBox('Search Parcel description', 'Enter the parcel''s description', '');

            // Check for the parcelDESC:
            if length(sInput) = 0 then
            begin
              MessageDlg('No records found!', mtWarning, [mbOK], 0);
              rgbSearchBy.ItemIndex := -1;
              tblParcel.Filtered := False;
              DBGrid1.DataSource := nil;
              exit;
            end;//if

            // cosmetics:
            StatusBar1.Panels[0].Text := 'Searching...';
            Application.ProcessMessages;

            // SQL :
            qStudentNo.SQL.Text := 'Select * from PARCEL where [ParcelDescription] like '+QuotedStr('%'+sInput+'%');
            qStudentNo.Open;
            DBGrid1.DataSource := dsStudentNo;

            if qStudentNo.RecordCount = 0 then
            begin
              MessageDlg('No records found!', mtWarning, [mbOK], 0);
              rgbSearchBy.ItemIndex := -1;
              tblParcel.Filtered := False;
              DBGrid1.DataSource := nil;
              exit;
            end;//

            // Finalize:
            StatusBar1.Panels[0].Text := 'Ready';
            Application.ProcessMessages;

          end //2 caseParcelDESC
          else
            rgbSearchBy.ItemIndex:=-1;
    end;//case        
  end;//with

end;

procedure TfrmSearch.bitbtnPrintClick(Sender: TObject);
var
  sInfo : String;
begin
  {Print}
  // Initialize:
  StatusBar1.Panels[0].Text := 'Printing...'; Application.ProcessMessages;

  // Check null string:
  if reSearch.Text = '' then exit
  else
  begin
    // Print Parcel info:
    if PrinterSetupDialog1.Execute then
    begin
      sInfo := reSearch.Text;
      reSearch.Print(sInfo);
    end;//
  end;//else

  // Finalize:
  StatusBar1.Panels[0].Text := 'Ready'; Application.ProcessMessages;
end;

procedure TfrmSearch.Timer1Timer(Sender: TObject);
begin
  // component.text := formatdatetime('hh : mm : ss', Now);
  StatusBar1.Panels[1].Text := FormatDateTime('hh:mm:ss', Now);
end;

procedure TfrmSearch.FormShow(Sender: TObject);
begin
  // Set default date :
  DateTimePicker1.Date := Now;


end;

{procedure TfrmSearch.DBGrid2CellClick(Column: TColumn);
var
  sStudentNo,
  sName       : String;
begin
  // Get the distinct student's records:
  {Parcel Description & Date Received}
 { RichEdit2.Clear;
  RichEdit2.Paragraph.TabCount := 2;
  RichEdit2.Paragraph.Tab[0]   := 100;
  RichEdit2.Paragraph.Tab[1]   := 200;
  RichEdit2.Lines.Add('Student : '+sStudentNo+sName);
  RichEdit2.Lines.Add('=================================================');
  RichEdit2.Lines.Add('Parcel Description'+#9+'Date Received');   }

//end;


procedure TfrmSearch.DBGrid1CellClick(Column: TColumn);
begin
  // Enable ViewReportBtn:
  if DBGrid1.DataSource <> nil then
  begin
    bitbtnViewReport.Enabled := True;
    bitbtnCheckOutParcel.Enabled := True;
  end
  else
  begin
    bitbtnViewReport.Enabled := false;
    bitbtnCheckOutParcel.Enabled := False;
  end;//else

 
end;

procedure TfrmSearch.Exit1Click(Sender: TObject);
begin
  {Logout}
  if (MessageDlg('Are you sure you want to logout?', mtConfirmation, [mbNo, mbYes], 0)) = mrYes then
  begin
    DBGrid1.DataSource := nil;
    frmSearch.hide;
    frmLogin.Show;
  end
  else Exit;

end;

procedure TfrmSearch.TabSheet1Show(Sender: TObject);
begin
  //refresh
  DBGrid1.DataSource:=nil;
  bitbtnViewReport.Enabled := False;
  bitbtnCheckOutParcel.Enabled:=False;
  rgbSearchBy.ItemIndex:=-1;
end;

procedure TfrmSearch.Home1Click(Sender: TObject);
begin
  {Home}
  DBGrid1.DataSource := nil;
  frmSearch.hide;
  frmMain.show;
end;

procedure TfrmSearch.Exit3Click(Sender: TObject);
begin
  {Exit}
  if (MessageDlg('Are you sure you want to exit this application?', mtConfirmation, [mbNo, mbYes], 0))=mryes then
  begin
    Application.Terminate;
  end
  else exit;
  
end;

procedure TfrmSearch.bitbtnViewReportClick(Sender: TObject);
begin
  {View report}

  //Display Components
  TabSheet2.Show;
  reSearch.Visible := True;
  bitbtnPrint.Visible := True;
  bitbtnPrint.Enabled := True;
  BitBtn1.Enabled := true;
  
  {refresh}
  reSearch.Clear;
  bitbtnPrint.Enabled := False;

  // Display Parcel Info:
  with DataModule1 do
  begin
    reSearch.Clear;
    if DBGrid1.DataSource = nil then
    begin
      MessageDlg('Select a search criteria first!', mtWarning, [mbOK], 0);
      rgbSearchBy.SetFocus;
      Exit;
    end;//
    
    if qStudentNo.FieldByName('isCollected').AsBoolean = true then
    begin

      with reSearch.Lines do
      begin
        reSearch.SelAttributes.Style := [fsBold];
        Add(#9+#9+'NORTHERN ACADEMY COLLEGE');
        Add('');
        Add('Student No: '+qStudentNo['StudentNo']);
        Add('');
        reSearch.SelAttributes.Style := [fsBold];
        Add('PARCEL INFORMATION:');
        Add('Parcel Description: '+qStudentNo['ParcelDescription']);
        Add('Parcel Category: '+qStudentNo['Category']);
        Add('=========================================');
        Add('Brought in on the: '+qStudentNo.fieldByName('DateReceived').AsString);
        Add('Brought by: '+qStudentNo['Relation']);
        Add('Received by employee: '+qStudentNo['ReceivedBy']);
        Add('=========================================');
        Add('Collected status: Collected on the '+qStudentNo.fieldByName('DateCollected').AsString);
        Add('=========================================');
        Add('Copy generated by Paksca @ Northern Academy College.');
      end;// with
    end
    else
      begin
        with reSearch.Lines do
        begin
          reSearch.SelAttributes.Style := [fsBold];
          Add(#9+#9+'NORTHERN ACADEMY COLLEGE');
          Add('');
          Add('Student No: '+qStudentNo['StudentNo']);
          Add('');
          reSearch.SelAttributes.Style := [fsBold];
          Add('PARCEL INFORMATION:');
          Add('Parcel Description: '+qStudentNo['ParcelDescription']);
          Add('Parcel Category: '+qStudentNo['Category']);
          Add('=========================================');
          Add('Brought in on the: '+qStudentNo.fieldByName('DateReceived').AsString);
          Add('Brought by: '+qStudentNo['Relation']);
          Add('Received by employee: '+qStudentNo['ReceivedBy']);
          Add('=========================================');
          Add('Collected status: Not Collected');
          Add('=========================================');
          Add('Copy generated by Paksca @ Northern Academy College.');
        end;//with
      end;//else

  end;//with

  // enable printBtn:
  if Length(reSearch.Text) <> 0 then
    bitbtnPrint.Enabled := True;
end;

procedure TfrmSearch.bitbtnCheckOutParcelClick(Sender: TObject);
begin
  // Initialize:
  StatusBar1.Panels[0].Text := 'Processing...'; Application.ProcessMessages;
  
  // Change isCollected property:
  with DataModule1 do
  begin
    // Filter by the Parcel No:
     // Get Parcel no:
    sParcel :=qStudentNo['ParcelNo'];
    qStudentNo.Filtered := False;
    qStudentNo.Filter   := 'ParcelNo ='+QuotedStr(sParcel);
    qStudentNo.Filtered := True;

    // Check if pArcel is there:
    if qStudentNo.RecordCount = 0 then
    begin
      MessageDlg('Parcel number does not exist!', mtWarning, [mbOK], 0);
      DBGrid1.SetFocus;
      qStudentNo.Filtered := False;
      Exit;
    end;//

    // check collected property:
    if qStudentNo['isCollected'] = False then
    begin
      tblParcel.Filtered:=False;
      tblParcel.Filter:='ParcelNo ='+QuotedStr(sParcel);;
      tblParcel.Filtered:=True;

      tblParcel.Edit;
      tblParcel['isCollected'] := True;
      tblParcel['CheckedOutBy'] := sUser;
      tblParcel.Post;
      qStudentNo.Requery;
      MessageDlg('Parcel: '+IntToStr(StrToInt(sParcel))+' has successfully been checked out.', mtInformation, [mbOK], 0);

    end
    else if tblParcel['isCollected'] = True then
    begin
      MessageDlg('Parcel: '+IntToStr(StrToInt(sParcel))+' has already been collected!', mtInformation, [mbOK], 0);
      tblParcel.Filtered := False;
      DBGrid1.DataSource := nil;
    end;//else


     // Finalize:
     StatusBar1.Panels[0].Text := 'Ready'; Application.ProcessMessages;
     rgbSearchBy.ItemIndex:=-1;
     tblParcel.Filtered:=False;
     qStudentNo.Filtered:=False;
   end;//with
end;

procedure TfrmSearch.DateTimePicker1Enter(Sender: TObject);
begin
  with DataModule1 do
begin
   // SQL :  DateTimePickerOnChange event
             //ShortDateFormat := 'yyyy/mm/dd';

            // Filter:
            tblParcel.Filtered := False;
            tblParcel.Filter   := 'DateReceived = #' +DateToStr(DateTimePicker1.Date)+'#';
           // ShowMessage(tblParcel.filter);
            tblParcel.Filtered := true;

            // Check for date:
            if tblParcel.RecordCount = 0 then
            begin
              MessageDlg('No records found!',mtWarning, [mbOK], 0);
              rgbSearchBy.ItemIndex := -1;
              tblParcel.Filtered := False;
              DBGrid1.DataSource := nil;
              StatusBar1.Panels[0].Text := 'Ready';
              Application.ProcessMessages;
              exit;
            end
             else   DBGrid1.DataSource := dsParcel;
end;//with
end;

procedure TfrmSearch.BitBtn1Click(Sender: TObject);
begin
  {Refresh}
  reSearch.Clear;
  bitbtnPrint.Enabled := False;
end;

procedure TfrmSearch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.Show;
end;

end.
