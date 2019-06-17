unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, uNewParcel, uParcel, uLogin, uSearch,
  dmParcel, DB, jpeg, ExtCtrls;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    AddNewRecord1: TMenuItem;
    Search1: TMenuItem;
    imgNAV: TImage;
    lblNAV: TLabel;
    lblNavH: TLabel;
    Logout1: TMenuItem;
    Exit1: TMenuItem;
    Shape1: TShape;
    Label1: TLabel;
    Shape2: TShape;
    Label2: TLabel;
    Shape3: TShape;
    Label3: TLabel;
    lblAbout: TLabel;
    procedure AddNewRecord1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Search1Click(Sender: TObject);
    procedure Logout1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label1MouseLeave(Sender: TObject);
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label2MouseLeave(Sender: TObject);
    procedure Label2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label3MouseLeave(Sender: TObject);
    procedure lblAboutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
implementation

uses ADODB;

{$R *.dfm}


procedure TfrmMain.AddNewRecord1Click(Sender: TObject);
begin
  {Add Record}
  frmMain.Hide;
  frmNewParcel.ShowModal;
end;


procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmMain.Search1Click(Sender: TObject);
begin
  {Search}
  frmMain.Hide;
  frmSearch.ShowModal;
end;

procedure TfrmMain.Logout1Click(Sender: TObject);
begin
  {logout}
  if (MessageDlg('Are you sure you want to logout?', mtConfirmation, [mbNo, mbYes], 0)) = mrYes then
  begin
    frmMain.Hide;
    frmLogin.ShowModal;
  end
  else Exit;

end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  {exit}
  if (MessageDlg('Are you sure you want to exit this application?', mtConfirmation, [mbNo, mbYes], 0))=mryes then
  begin
    Application.Terminate;
  end;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  frmMain.Hide;
  frmSearch.TabSheet1.Show;
  MessageDlg('To view a parcel report first search for a parcel.', mtInformation, [mbOK], 0);
end;

procedure TfrmMain.Label1Click(Sender: TObject);
begin
  frmMain.hide;
  frmSearch.Show;
  MessageDlg('To view a parcel report first search for a parcel.', mtInformation, [mbOK], 0);
end;

procedure TfrmMain.Label1MouseLeave(Sender: TObject);
begin
  {small}
  Shape1.Height := 73;
  Shape1.Width  := 177;
  Shape1.Left   := 168;
  Shape1.Top    := 272;
  Shape1.Brush.Color := clMaroon;
  Shape1.Pen.Width   := 1;
  Shape1.Pen.Color  := clBlack;
end;

procedure TfrmMain.Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  {big}
  Shape1.Height := 83;
  Shape1.Width  := 210;
  Shape1.Left   := 152;
  Shape1.Top    := 270;
  Shape1.Brush.Color := clRed;
  Shape1.Pen.Width   := 4;
  Shape1.Pen.Color  := clBlack;
end;

procedure TfrmMain.Label2Click(Sender: TObject);
begin
  frmMain.Hide;
  frmSearch.Show;
  frmSearch.PageControl1.ActivePageIndex := 0;
end;

procedure TfrmMain.Label3Click(Sender: TObject);
begin
  frmMain.Hide;
  frmNewParcel.Show;
end;

procedure TfrmMain.Label2MouseLeave(Sender: TObject);
begin
  {small}
  Shape2.Height := 73;
  Shape2.Width  := 177;
  Shape2.Left   := 168;
  Shape2.Top    := 200;
  Shape2.Brush.Color := clMaroon;
  Shape2.Pen.Width   := 1;
  Shape2.Pen.Color  := clBlack;
end;

procedure TfrmMain.Label2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  {big}
  Shape2.Height := 78;
  Shape2.Width  := 210;
  Shape2.Left   := 152;
  Shape2.Top    := 198;
  Shape2.Brush.Color := clRed;
  Shape2.Pen.Width   := 4;
  Shape2.Pen.Color  := clBlack;
end;

procedure TfrmMain.Label3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
{big}
  Shape3.Height := 78;
  Shape3.Width  := 210;
  Shape3.Left   := 152;
  Shape3.Top    := 126;
  Shape3.Brush.Color := clRed;
  Shape3.Pen.Width   := 4;
  Shape3.Pen.Color  := clBlack;
end;

procedure TfrmMain.Label3MouseLeave(Sender: TObject);
begin
 {small}
  Shape3.Height := 73;
  Shape3.Width  := 177;
  Shape3.Left   := 168;
  Shape3.Top    := 128;
  Shape3.Brush.Color := clMaroon;
  Shape3.Pen.Width   := 1;
  Shape3.Pen.Color  := clBlack;
end;

procedure TfrmMain.lblAboutClick(Sender: TObject);
begin
  MessageDlg('Welcome to About PACSKA.'+#13+'Pacska is a software designed to simplify parcel management @ Northern Academy.'+
             #13+'Why Pacska?... The birth of Pacska came about when 3 students went into the hostel office and noticed a lack in their parcel management system.'+
             #13+'So these students decided to tackle this problem by designing the ultimate program - PACKSA! The name Pacska means "Parcel" in Ukrainian.'+
             #13+'We chose this name because it had a nice ring to it and because it was relevant.'+
             #13+'Pakcsa Developed by: K.M. Dinake, S.L.K. Mwaniki and P. Maake *_*', mtInformation, [mbOK], 0);
end;

end.
