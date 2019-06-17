unit uParcel;

interface
uses
   SysUtils, Classes, Controls, Dialogs, DateUtils;

type
  TParcel = class(TObject)
  private
    // Properties:
    fParcelNo        : Integer;
    fStudentNo     : String;
    fParcelDesc    : String;
    fParcelBearer   : String;
    fRelation      : String;
    fDateReceived  : String;
    fDateCollected : String;
    fCollected     : Boolean;
    fCategory      : String;
    fReceivedBy    : String;

   public
     constructor create(theParcelNo : Integer; theStudentNo, theParcelDesc, theParcelBearer : String);

     // Mutators/ Manipulators:
     procedure setDateCollected(theDateC : String);
     procedure setDateReceived(theDateR : String);
     procedure changeRelation(theRelation : String);
     procedure setCollected(theCollect : Boolean);
     procedure setCategory(theCategory : String);
     procedure setReceivedBy(thePerson : String);

     // Accessors:
     function getParcelNo      : Integer;
     function getParcelBearer  : String;
     function getParcelDesc    : String;
     function getStudentNo     : String;
     function getRealtion      : String;
     function getDateReceived  : String;
     function getDateCollected : String;
     function getCollected     : String;
     function getCategory      : String;
     function getReceivedBy    : String;
     
     //Strigfy:
     function toString       : String;
     function toFileString  : String;
end;// TParcel

implementation

{ TParcel }

constructor TParcel.create(theParcelNo : Integer; theStudentNo, theParcelDesc, theParcelBearer : String);
begin
  // Default Values:
  fParcelNo    := theParcelNo;
  fStudentNo   := theStudentNo;
  fParcelDesc  := theParcelDesc;
  fParcelBearer := theParcelBearer;
  fRelation    := 'Mother';

  //ShortDateFormat := 'yyyy/mm/dd';
  fDateReceived   :='2012/12/31';
  fDateCollected  :='2012/12/31';
  fCollected      := False;
  fCategory    := 'Food';
end;

function TParcel.getParcelNo: Integer;
begin
  result:=fParcelNo;
end;

function TParcel.getDateCollected: String;
begin
  getDateCollected := fDateCollected;
end;

function TParcel.getDateReceived: String;
begin
  getDateReceived := fDateReceived;
end;

function TParcel.getParcelBearer: String;
begin
  getParcelBearer := fParcelBearer;
end;

function TParcel.getParcelDesc: String;
begin
  getParcelDesc := fParcelDesc;
end;

function TParcel.getRealtion: String;
begin
  getRealtion := fRelation;
end;

function TParcel.getStudentNo: String;
begin
  getStudentNo := fStudentNo;
end;

procedure TParcel.setDateCollected(theDateC: String);
begin
  fDateCollected := theDateC;
end;

procedure TParcel.setDateReceived(theDateR: String);
begin
  fDateReceived := theDateR;
end;

procedure TParcel.changeRelation(theRelation: String);
begin
  fRelation := theRelation;
end;
procedure TParcel.setCategory(theCategory: String);
begin
   fCategory:=theCategory;
end;

function TParcel.getCategory: String;
begin
  getCategory:=fCategory;
end;

function TParcel.getCollected: String;
begin
  if fCollected =True then
    Result:='True'
  else Result:='False';
end;

procedure TParcel.setCollected(theCollect: Boolean);
begin
  fCollected := theCollect;
end;

function TParcel.getReceivedBy: String;
begin
  getReceivedBy:=fReceivedBy;
end;

procedure TParcel.setReceivedBy(thePerson: String);
begin
  fReceivedBy:=thePerson;
end;

function TParcel.toFileString: String;
begin
  Result:='INSERT INTO PARCEL (StudentNo, ParcelBearerName, Relation, ParcelDescription, DateReceived, DateCollected, Category, isCollected, ReceivedBy) VALUES (' +QuotedStr(getStudentNo)+','
                                                                                                                                                                    +QuotedStr(getParcelBearer)+','
                                                                                                                                                                    +QuotedStr(getRealtion)+','
                                                                                                                                                                    +QuotedStr(getParcelDesc)+','
                                                                                                                                                                    +QuotedStr(getDateReceived)+','
                                                                                                                                                                    +QuotedStr(getDateCollected)+','
                                                                                                                                                                    +QuotedStr(getCategory)+','
                                                                                                                                                                    +getCollected+','
                                                                                                                                                                    +QuotedStr(getReceivedBy)+')';

  {[StudentNo, ParcelBearerName, Relation, ParcelDescription, DateReceived, DateCollected, Category, isCollected, ReceivedBy]}
end;

function TParcel.toString: String;
var
  sOutPut : String;
begin

  sOutPut :=    'PARCEL NUMBER:' +#9+ IntToStr(fParcelNo)
            +#13+'-------------------------------------------------------------------'
            +#13+'Client:'+getStudentNo
            +#13+'Parcel Date:'   +#9+ {FormatDateTime('dd/MM/yyyy',} fDateReceived//)
            +#13+'-------------------------------------------------------------------'
            +#13+'Description'
            +#13+fParcelDesc
            +#13+'                         '
            +#13+'Category :  '+fCategory
            +#13+'------------------------------------------------------------------------';

  if fCollected then sOutPut:=sOutPut +#13+ 'Student has collected the Parcel.'
  else               sOutPut:=sOutPut +#13+ 'Student has not collected Parcel.';

  {if fCollected then sOutPut:=sOutPut +#13+
              'Date Collected:' +#9+FormatDateTime('dd/MM/yyyy', fDateCollected); }

  sOutPut := sOutPut+#13+'-------------------------------------------------------------------';

  if fCollected then
     sOutPut:=sOutPut +#13+
               'Date Collected:' +#9+ {FormatDateTime('dd/MM/yyyy',} fDateCollected//)
               +#13+'========================================================='
               +#13+' '
  else
    sOutPut:=sOutPut +#13+'========================================================='
               +#13+' ';

     toString := sOutPut;

end;

end.
