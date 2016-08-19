// Версия - 31.03.2014
unit ucClasses;
{$include ..\delphi_ver.inc}

interface

uses
  Windows, DB, Contnrs, Variants, SysUtils, StdCtrls, Classes,
  ucFunctions, ucTypes;

type
  IUcNotifyObject = interface
    function NotifyObject: TObject;
    procedure Notify;
    procedure DisableNotification;
    procedure EnableNotification;

    function GetState: TNotifyObjectState;
    function GetIsChanged: Boolean;
    procedure SetIsChanged(Value: Boolean);

    procedure Change; 
    procedure RegisterNotify(NotifyEvent: TNotifyEvent);
    procedure UnregisterNotify(NotifyEvent: TNotifyEvent);

    property State: TNotifyObjectState read GetState;
    property IsChanged: Boolean read GetIsChanged write SetIsChanged;
  end;

  TUcNotifyObject = class(TInterfacedObject, IUcNotifyObject)
  private
    fState: TNotifyObjectState;
    fNotifyList: TList;
    fIsChanged: Boolean;
    fDisableNotifyCount: Integer;
    function GetIsNormalState: Boolean;
  protected
    function NotifyObject: TObject; virtual;
    function GetState: TNotifyObjectState;
    function GetIsChanged: Boolean;
    procedure SetIsChanged(Value: Boolean);
  public
    constructor Create; virtual;
    destructor  Destroy; override;
    procedure Notify;
    procedure DisableNotification;
    procedure EnableNotification;

    procedure Change; virtual;
    procedure RegisterNotify(NotifyEvent: TNotifyEvent);
    procedure UnregisterNotify(NotifyEvent: TNotifyEvent);
    procedure UnregisterNotifyAll;

    property State: TNotifyObjectState read GetState;
    property IsChanged: Boolean read GetIsChanged write SetIsChanged;
    property IsNormalState: Boolean read GetIsNormalState;
  end;

  TUcNotifyHelper = class(TUcNotifyObject)
  private
    fOwnObjectNotification: TObject;
  protected
    function NotifyObject: TObject; override;
  public
    constructor Create(OwnObjectNotification: TObject); reintroduce;
  end;

  TUcNotifyObjectEx = class(TUcNotifyObject)
  private
    FNotifyInf: TUcNotifyInfos;
    FNotifyTag: Integer;
    FNotifyMax: Integer;
    FNotifyPos: Integer;
    FNotifyTxt: string;
    FNotifyErr: Boolean;
    FWereErrors: Boolean;
  protected
    procedure SetNotify(const iInf: TUcNotifyInfos; const iTag, iMax, iPos: Integer;
                        const iTxt: string = ''; const iErr: Boolean = False);
    procedure Notifycation(const iInf: TUcNotifyInfos; const iTag, iMax, iPos: Integer;
                           const iTxt: string = ''; const iErr: Boolean = False); virtual;
  public
    constructor Create; override;
    property NotifyInf: TUcNotifyInfos read FNotifyInf; // Информация об оповещении
    property NotifyTag: Integer        read FNotifyTag; // Произвольное значение характеризующее прогресс
    property NotifyMax: Integer        read FNotifyMax; // Общий путь выполнения
    property NotifyPos: Integer        read FNotifyPos; // Позиция на пути выполнения
    property NotifyTxt: string         read FNotifyTxt; // Описание текущей операции
    property NotifyErr: Boolean        read FNotifyErr; // Успешность операции / сообщение об ошибке
    property WereErrors: Boolean read FWereErrors write FWereErrors;
  end;

  TDBField = class;
  TDBFieldClass = class of TDBField;

  TDBField = class (TUcNotifyObject)
  private
    FValueBuffer: Variant;
    fFieldName: string;
    fIsBlob: Boolean;
    fStream: TMemoryStream;
    function GetAsInt64: Int64;
    procedure SetAsInt64(const Value: Int64);
  protected
    procedure SetData(const Value: Variant);
    function  GetData: Variant;

    function  GetAsVariant: Variant;
    procedure SetAsVariant(const Value: Variant);
    function  GetAsObject: TObject;
    procedure SetAsObject(const Value: TObject);
    function  GetAsStream: TStream;
    function  GetAsClass: TClass;
    procedure SetAsClass(const Value: TClass);
    function  GetAsDateTime: TDateTime;
    procedure SetAsDateTime(const Value: TDateTime);
    function  GetAsString: String;
    function  GetAsSQLStr: String;
    procedure SetAsString(const Value: String);
    function  GetAsFloat: Double;
    procedure SetAsFloat(const Value: Double);
    function  GetAsInteger: Integer;
    procedure SetAsInteger(const Value: Integer);
    function  GetAsBool: Boolean;
    procedure SetAsBool(const Value: Boolean);
  public
    constructor Create(Name: string); reintroduce;
    destructor  Destroy; override;
    procedure Clear;

    procedure InitStream;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);

    procedure AssignField(Field: TField;const  ChangeName: Boolean = False); overload;
    procedure AssignField(Field: TDBField); overload;
    property AsVariant: Variant read GetAsVariant write SetAsVariant;
    property AsObject: TObject read GetAsObject write SetAsObject;
    property AsStream: TStream read GetAsStream;
    property AsClass: TClass read GetAsClass write SetAsClass;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsString: String read GetAsString write SetAsString;
    property AsSQLStr: String read GetAsSQLStr;
    property AsBoolean: Boolean read GetAsBool write SetAsBool;
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    property AsInteger: integer read GetAsInteger write SetAsInteger;
    property AsInt64: Int64 read GetAsInt64 write SetAsInt64;
    property FieldName: string read fFieldName;
    property IsBlob: Boolean read fIsBlob;
  end;

  TDBFields = class (TUcNotifyObject)
  private
    fFields: TObjectList;
    fFieldDef: TDBField;
    fAutoCreateFields: Boolean;
    fChangedField: TDBField;
  protected
    function GetFieldClass: TDBFieldClass; virtual;
    function GetField(Index: Integer): TDBField;
    function GetCount: Integer;
    function NewField(Name: String = ''): TDBField;
    function GetValue(Name: string): TDBField;
    procedure FieldCahnged(Sender: TObject);
    function GetDebug_FieldList: string;
  public
    constructor Create; override;
    destructor  Destroy; override;

    procedure AssignFields(Fields: TFields); overload;
    procedure AssignFields(Fields: TDBFields); overload;
    procedure AssignFields(Fields: TDBFields; FieldNames: array of String); overload;

    procedure FillFields(Fields: TFields); overload;
    procedure FillFields(Fields: TDBFields); overload;

    function  AddField(Name: string; Value: Variant): TDBField; overload;
    procedure AddField(Field: TDBField); overload;

    procedure RemoveField(Field: TDBField); overload;
    procedure RemoveField(FieldName: String); overload;
    procedure ClearFields; deprecated {$IFDEF DELPHI_2009_UP}'use Clear'{$ENDIF};
    procedure Clear;
    function  FieldByName(Name: string): TDBField;
    function FindField(Name: string): TDBField;
    procedure SetFieldsChanged(Value: Boolean);

    property Debug: string read GetDebug_FieldList; //For debug !!!
    property Count: integer read GetCount;
    property AutoCreateFields: Boolean read fAutoCreateFields write fAutoCreateFields;
    property Fields[Index: Integer]: TDBField read GetField;
    property Values[Name: string]: TDBField read GetValue; default;
    property FieldDef: TDBField read fFieldDef;
    property ChangedField: TDBField read fChangedField;
  end;

  TVirtualTable = class
  private
    fRows: TObjectList;
    fRow: TDBFields;
    function GetRow(Index: Integer): TDBFields;
    function GetCount: Integer;
    function GetRowIndex: Integer;
  public
    constructor Create;
    destructor  Destroy; override;

    function  Add: TDBFields;
    function  Insert(Index: Integer): TDBFields;
    procedure Delete(Index: Integer);
    procedure Clear;

    procedure First;
    procedure Next;
    procedure Prev;
    procedure Last;
    function Eof: Boolean;
    function Bof: Boolean;

    property Rows[Index: Integer]: TDBFields read GetRow;
    property Count: Integer read GetCount;
    property Row: TDBFields read fRow;
    property RowIndex: Integer read GetRowIndex;
  end;

  // Описание старых классов оставленных для совместимости
  TNotifyObject = class(TUcNotifyObject);
  //**

  procedure CheckEditScalar(Edit: TCustomEdit;
                            Float: Boolean = False); deprecated {$IFDEF DELPHI_2009_UP}'use UC_CheckEditScalar(Edit, Float) from ucFunctions'{$ENDIF};
{$IFNDEF DELPHI_2009_UP}
  function  CharInSet(Chr: Char; CharSet: TSysCharSet): Boolean;
{$ENDIF}

implementation

uses StrUtils;

type
  PNotifyEvent = ^TNotifyEvent;

{ TUcNotifyObject }
constructor TUcNotifyObject.Create();
begin
  inherited;
  fDisableNotifyCount := 0;
  fState      := nosNormal;
  fNotifyList := nil;
  fIsChanged  := False;
end;

destructor  TUcNotifyObject.Destroy;
var i: integer;
begin
  fState := nosDestroing;
  Change;
  if Assigned(fNotifyList) then
    for i := 0 to fNotifyList.Count - 1 do
      FreeMem(fNotifyList[i], SizeOf(TNotifyEvent));
  fNotifyList.Free;
  inherited;
end;

procedure TUcNotifyObject.DisableNotification;
begin
  Inc(fDisableNotifyCount);
end;

procedure TUcNotifyObject.EnableNotification;
begin
  if fDisableNotifyCount > 0 then Dec(fDisableNotifyCount);
end;

procedure TUcNotifyObject.Change;
begin
  fIsChanged := True;
  Notify;
end;

procedure TUcNotifyObject.RegisterNotify(NotifyEvent: TNotifyEvent);
var
  i: integer;
  p: PNotifyEvent;
begin
  if not Assigned(fNotifyList) then
    fNotifyList := TList.Create;

  p := AllocMem(SizeOf(TNotifyEvent));
  p^:= NotifyEvent;
  i := FNotifyList.IndexOf(p);
  if i < 0 then
    FNotifyList.Add(p);
end;

procedure TUcNotifyObject.UnregisterNotify(NotifyEvent: TNotifyEvent);
var i: integer;
begin
  if Assigned(fNotifyList) then
  begin
    i := 0;
    while (i < fNotifyList.Count) and
          (not CompareMem(fNotifyList[i], @@NotifyEvent, SizeOf(TNotifyEvent))) do
      Inc(i);

    if i = fNotifyList.Count then i := -1;

    if i >= 0 then
    begin
      FreeMem(fNotifyList[i], SizeOf(TNotifyEvent));
      FNotifyList.Delete(i);
    end;
  end;
end;

procedure TUcNotifyObject.UnregisterNotifyAll;
begin
  if Assigned(fNotifyList) then
  begin
    while (fNotifyList.Count > 0) do
    begin
      FreeMem(fNotifyList[0], SizeOf(TNotifyEvent));
      fNotifyList.Delete(0);
    end;
  end;
end;

function TUcNotifyObject.GetIsNormalState: Boolean;
begin
  Result := fState = nosNormal;
end;

function TUcNotifyObject.NotifyObject: TObject;
begin
  Result := Self;
end;

procedure TUcNotifyObject.Notify;
var
  i: integer;
  p: PNotifyEvent;
begin
  if (fDisableNotifyCount = 0) and Assigned(fNotifyList) then
  begin
    i := 0;
    while i < FNotifyList.Count do
    begin
      p := FNotifyList.Items[i];
      p^(NotifyObject);
      Inc(i);
    end;
  end;
end;

function TUcNotifyObject.GetState: TNotifyObjectState;
begin
  Result := fState;
end;

function TUcNotifyObject.GetIsChanged: Boolean;
begin
  Result := fIsChanged;
end;

procedure TUcNotifyObject.SetIsChanged(Value: Boolean);
begin
  if fIsChanged <> Value then
  begin
    fIsChanged := Value;
//    Change;
  end;
end;

{     TDBField      }
constructor TDBField.Create(Name: string);
begin
  inherited Create;
  fFieldName   := Name;
  FValueBuffer := null;
  fIsBlob      := False;
  fStream      := nil;
end;

destructor  TDBField.Destroy;
begin
  //Finalize(FValueBuffer);
  fStream.Free;
  inherited;
end;

procedure TDBField.Clear;
begin
  FValueBuffer := null;
  if Assigned(fStream) then FreeAndNil(fStream);
  fIsBlob := False;
  Change;
end;

procedure TDBField.InitStream;
begin
  if not Assigned(fStream) then
    fStream := TMemoryStream.Create;
  fIsBlob := True;
end;

procedure TDBField.LoadFromStream(Stream: TStream);
begin
  InitStream;
  fStream.LoadFromStream(Stream);
end;

procedure TDBField.SaveToStream(Stream: TStream);
begin
  InitStream;
  fStream.SaveToStream(Stream);
end;

procedure TDBField.AssignField(Field: TField;const  ChangeName: Boolean = False);
var Stream: TStream;
begin
  if ChangeName then fFieldName := Field.FieldName;

  if Field.IsBlob then
  begin
    Stream := Field.DataSet.CreateBlobStream(Field, bmRead);
    try
      LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end else
    FValueBuffer := Field.Value;

  Change;
end;

procedure TDBField.AssignField(Field: TDBField);
begin
  fFieldName   := Field.FieldName;

  if Field.IsBlob then
    LoadFromStream(Field.fStream);

  FValueBuffer := Field.AsVariant;

  Change;
end;

procedure TDBField.SetData(const Value: Variant);
begin
  if (VarType(FValueBuffer) <> VarType(Value))or
     (FValueBuffer <> Value) then
  begin
    FValueBuffer := Value;
    Change;
  end;
end;

function  TDBField.GetData: Variant;
begin
  Result := FValueBuffer;
end;

function  TDBField.GetAsVariant: Variant;
begin
  Result := GetData;
end;

function  TDBField.GetAsDateTime: TDateTime;
var vt: Word;
begin
//  if FValueBuffer = null then
//    Result := 0
//    else try
//      Result := VarToDateTime(FValueBuffer);
//    except
//      Result := FloatToDateTime(0);
//    end;


  if FValueBuffer = null then
    Result := 0
    else begin
      vt := VarType(FValueBuffer);
      if (vt = varString)
         {$IFDEF DELPHI_2009_UP}or (vt = varUString){$ENDIF} then
        Result := UC_DecodeDateTimeDef(FValueBuffer, 0)
        else
        try
          Result := VarToDateTime(FValueBuffer);
        except
          Result := FloatToDateTime(0);
        end;
    end;

end;

procedure TDBField.SetAsDateTime(const Value: TDateTime);
begin
  SetData(Value);
end;

procedure TDBField.SetAsVariant(const Value: Variant);
begin
  SetData(Value);
end;

function  TDBField.GetAsObject: TObject;
begin
  Result := TObject(AsInteger);
end;

procedure TDBField.SetAsObject(const Value: TObject);
begin
  AsInteger := integer(Value);
end;

function  TDBField.GetAsStream: TStream;
begin
  InitStream;
  Result := fStream;
end;

function  TDBField.GetAsClass: TClass;
begin
  Result := TClass(AsInteger);
end;

procedure TDBField.SetAsClass(const Value: TClass);
begin
  AsInteger := Integer(Value);
end;

function  TDBField.GetAsString: String;
begin
  if VarType(FValueBuffer) = varDate then
    Result := UC_EncodeDateTime(TDateTime(FValueBuffer))
    else
    Result := VarToStr(FValueBuffer);
end;

function  TDBField.GetAsSQLStr: String;
begin
  Result := UC_VarToSQLStr(FValueBuffer);
end;

procedure TDBField.SetAsString(const Value: String);
begin
  SetData(Value);
end;

function  TDBField.GetAsFloat: Double;
var
  vt: Word;
  fs: TFormatSettings;
begin
  if FValueBuffer = null then
    Result := 0
  else begin
    vt := VarType(FValueBuffer);
    if (vt = varString)
       {$IFDEF DELPHI_2009_UP}or (vt = varUString){$ENDIF} then
    begin
        GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, fs);
        FValueBuffer := StringReplace(FValueBuffer, '.', fs.DecimalSeparator, []);
        Result := StrToFloatDef(FValueBuffer, 0);
    end else
      Result := VarAsType(FValueBuffer, varDouble);
  end;

//  if FValueBuffer = null then
//    Result := 0
//    else
//    Result := VarAsType(FValueBuffer, varDouble);
end;

procedure TDBField.SetAsFloat(const Value: Double);
begin
  SetData(Value);
end;

function TDBField.GetAsInt64: Int64;
begin
  if FValueBuffer = null then
    Result := 0
    else begin
      if VarType(FValueBuffer) = varString then
        Result := StrToInt64Def(FValueBuffer, 0)
        else
        Result := VarAsType(FValueBuffer, varInt64);
    end;
end;

function  TDBField.GetAsInteger: Integer;
var vt: Word;
begin
  if FValueBuffer = null then
    Result := 0
    else begin
      vt := VarType(FValueBuffer);
      if (vt = varString)
         {$IFDEF DELPHI_2009_UP}or (vt = varUString){$ENDIF} then
        Result := StrToIntDef(FValueBuffer, 0)
        else
        Result := VarAsType(FValueBuffer, varInteger);
    end;
end;

procedure TDBField.SetAsInt64(const Value: Int64);
begin
  SetData(Value);
end;

procedure TDBField.SetAsInteger(const Value: Integer);
begin
  SetData(Value);
end;

function  TDBField.GetAsBool: Boolean;
var vt: Word;
begin
//  Result := Boolean(AsInteger);

  if FValueBuffer = null then
    Result := False
  else begin
    vt := VarType(FValueBuffer);

    if (vt = varString)
       {$IFDEF DELPHI_2009_UP}or (vt = varUString){$ENDIF} then
    begin
      if not TryStrToBool(FValueBuffer, Result) then
        Result := Boolean(AsInteger);
    end else
      Result := Boolean(AsInteger);
  end;
end;

procedure TDBField.SetAsBool(const Value: Boolean);
begin
  AsInteger := Integer(Value);
end;

{     TDBFields      }
constructor TDBFields.Create;
begin
  inherited;

  fChangedField := nil;
  fAutoCreateFields := True;
  fFields   := TObjectList.Create;
  fFieldDef := GetFieldClass.Create('');
  fFieldDef.AsVariant := null;
end;

destructor  TDBFields.Destroy;
begin

  fFields.Clear;
  fFields.Free;
  fFieldDef.Free;


  inherited Destroy;
end;

function TDBFields.NewField(Name: String = ''): TDBField;
begin
  Result := GetFieldClass.Create(Name);
  fFields.Add(Result);
  Result.RegisterNotify(FieldCahnged);
end;

procedure TDBFields.AssignFields(Fields: TFields);
var i: integer;
begin
  Clear;
  for I := 0 to Fields.Count - 1 do
//    NewField.AssignField(Fields[i], True);
    Values[Fields[i].FieldName].AssignField(Fields[i]);
end;

procedure TDBFields.AssignFields(Fields: TDBFields);
var i: integer;
begin
  Clear;
  for I := 0 to Fields.Count - 1 do
    Values[Fields.Fields[i].FieldName].AssignField(Fields.Fields[i]);
end;

procedure TDBFields.AssignFields(Fields: TDBFields;
  FieldNames: array of String);
var
  i: Integer;
begin
  for I := 0 to High(FieldNames) - 1 do
    Values[FieldNames[i]].AssignField(Fields[FieldNames[i]]);
end;

procedure TDBFields.FillFields(Fields: TFields);
var i: integer;
begin
  for I := 0 to Fields.Count - 1 do
    FieldByName(Fields[i].FieldName).AsVariant := Fields.Fields[i].Value;
end;

procedure TDBFields.FillFields(Fields: TDBFields);
var i: integer;
begin
  for I := 0 to Fields.Count - 1 do
    FieldByName(Fields.Fields[i].FieldName).AsVariant := Fields.Fields[i].AsVariant;
end;

function TDBFields.GetField(Index: Integer): TDBField;
begin
  Result :=  TDBField(fFields.Items[Index]);
end;

function TDBFields.GetFieldClass: TDBFieldClass;
begin
  Result := TDBField;
end;

function TDBFields.GetCount: Integer;
begin
  Result := fFields.Count;
end;

function TDBFields.AddField(Name: string; Value: Variant): TDBField;
var i: integer;
begin
  for I := 0 to Count - 1 do
    if AnsiUpperCase(Fields[i].FieldName) = AnsiUpperCase(Name) then
      raise Exception.Create('Уже есть такое поле!');

  Result := NewField(Name);
  Result.AsVariant := Value;
end;

procedure TDBFields.AddField(Field: TDBField);
var i: integer;
begin
  for I := 0 to Count - 1 do
    if AnsiUpperCase(Fields[i].FieldName) = AnsiUpperCase(Field.FieldName) then
      raise Exception.Create('Уже есть такое поле!');

  fFields.Add(Field);
end;


procedure TDBFields.RemoveField(Field: TDBField);
begin
  if Assigned(Field) and (Field.State = nosDestroing) and
     fFields.OwnsObjects then
  begin
    fFields.OwnsObjects := False;
    fFields.Remove(Field);
    fFields.OwnsObjects := True;
  end else
    fFields.Remove(Field);
end;

procedure TDBFields.RemoveField(FieldName: String);
begin
  RemoveField(FindField(FieldName));
end;

procedure TDBFields.ClearFields;
begin
  fFields.Clear;
end;

procedure TDBFields.Clear;
begin
  fFields.Clear;
end;

function  TDBFields.FieldByName(Name: string): TDBField;
begin
  Result := FindField(Name);
  if not Assigned(Result) then
    if fAutoCreateFields then
      Result := AddField(Name, FieldDef.AsVariant)
      else
      Result := FieldDef;
end;

function TDBFields.FindField(Name: string): TDBField;
var i: integer;
begin
  for i := 0 to Count - 1 do
    if AnsiUpperCase(Fields[i].FieldName) = AnsiUpperCase(Name) then
    begin
      Result := Fields[i];
      Exit;
    end;
  Result := nil;
end;

procedure TDBFields.SetFieldsChanged(Value: Boolean);
var i: Integer;
begin
  for i := 0 to Count - 1 do
    Fields[i].IsChanged := Value;
end;

function TDBFields.GetValue(Name: string): TDBField;
begin
  Result := FieldByName(Name);
end;

procedure TDBFields.FieldCahnged(Sender: TObject);
begin
  if Assigned(Sender) and (Sender is TDBField) then
  begin
    fChangedField := TDBField(Sender);
    Change;
    if Assigned(fChangedField) and (fChangedField.State = nosDestroing) then
      RemoveField(fChangedField);
    fChangedField := nil;
  end;
end;

function TDBFields.GetDebug_FieldList: string;

  function VarTypeToStr(vType: TVarType): string;
  begin
    case vType of
      varEmpty		: Result := 'varEmpty';
      varNull			: Result := 'varNull';
      varSmallint	: Result := 'varSmallint';
      varInteger	: Result := 'varInteger';
      varSingle		: Result := 'varSingle';
      varDouble		: Result := 'varDouble';
      varCurrency	: Result := 'varCurrency';
      varDate			: Result := 'varDate';
      varOleStr		: Result := 'varOleStr';
      varDispatch	: Result := 'varDispatch';
      varError		: Result := 'varError';
      varBoolean	: Result := 'varBoolean';
      varVariant	: Result := 'varVariant';
      varUnknown	: Result := 'varUnknown';
      varShortInt	: Result := 'varShortInt';
      varByte			: Result := 'varByte';
      varWord			: Result := 'varWord';
      varLongWord	: Result := 'varLongWord';
      varInt64		: Result := 'varInt64';

      varStrArg		: Result := 'varStrArg';
      varString		: Result := 'varString';
      varAny			: Result := 'varAny';

{$IFDEF DELPHI_2009_UP}
      varUInt64		: Result := 'varUInt64';
      varUString	: Result := 'varUString';
{$ENDIF}

      varTypeMask	: Result := 'varTypeMask';
      varArray		: Result := 'varArray';
      varByRef		: Result := 'varByRef';
    end;
  end;

var i: Integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
    if Fields[i].IsBlob then
      Result := Result + Fields[i].FieldName + ' (blob) =' +
                'size(' + IntToStr(Fields[i].AsStream.Size) + ') ' + CrLf
    else
      Result := Result + Fields[i].FieldName +
                ' (' + VarTypeToStr(VarType(Fields[i].AsVariant)) + ') =' +
                Fields[i].AsString + CrLf;

  if Count > 0 then
    Delete(Result, Length(Result) - Length(CrLf) + 1, Length(CrLf));
end;

{       TVirtualTable        }
constructor TVirtualTable.Create;
begin
  inherited;
  fRows := TObjectList.Create;
  fRows.OwnsObjects := True;

  First;
end;

destructor  TVirtualTable.Destroy;
begin
  fRows.Free;
  inherited;
end;

function TVirtualTable.Add: TDBFields;
begin
  Result := TDBFields.Create;
  Result.AutoCreateFields := True;
  fRows.Add(Result);
end;

function TVirtualTable.Insert(Index: Integer): TDBFields;
begin
  Result := TDBFields.Create;
  Result.AutoCreateFields := True;
  fRows.Insert(Index, Result);
end;

procedure TVirtualTable.Delete(Index: Integer);
begin
  if GetRowIndex = Index then
    if Eof then
      Prev
      else
      Next;

  fRows.Delete(Index);
end;

procedure TVirtualTable.Clear;
begin
  fRows.Clear;
  First;
end;

function TVirtualTable.GetRow(Index: Integer): TDBFields;
begin
  Result := TDBFields(fRows.Items[Index]);
end;

function TVirtualTable.GetCount: Integer;
begin
  Result := fRows.Count;
end;

function TVirtualTable.GetRowIndex: Integer;
begin
  Result := fRows.IndexOf(fRow);
end;

procedure TVirtualTable.First;
begin
  if Count > 0 then
    fRow := Rows[0]
    else
    fRow := nil;
end;

procedure TVirtualTable.Next;
var ri: Integer;
begin
  ri := GetRowIndex;
  if ri >= Count - 1 then
    fRow := nil
    else
    fRow := Rows[ri + 1];
end;

procedure TVirtualTable.Prev;
begin
  if not Bof then
    fRow := Rows[GetRowIndex - 1];
end;

procedure TVirtualTable.Last;
begin
  if Count > 0 then
    fRow := Rows[Count - 1]
    else
    fRow := nil;
end;

function TVirtualTable.Eof: Boolean;
begin
  Result := not Assigned(fRow);
end;

function TVirtualTable.Bof: Boolean;
begin
  Result := not Assigned(fRow);
end;

{         FUNCTIONS           }
procedure CheckEditScalar(Edit: TCustomEdit; Float: Boolean = False);
begin
  UC_CheckEditScalar(Edit, Float);
end;

{$IFNDEF DELPHI_2009_UP}
function  CharInSet(Chr: Char; CharSet: TSysCharSet): Boolean;
begin
  Result := Chr in CharSet;
end;
{$ENDIF}
{  ***   }

{ TUcNotifyObjectEx }

constructor TUcNotifyObjectEx.Create;
begin
  inherited;

  FNotifyInf  := [];
  FNotifyTag  := 0;
  FNotifyMax  := 0;
  FNotifyPos  := 0;
  FNotifyTxt  := '';
  FNotifyErr  := False;

  FWereErrors := False;
end;

procedure TUcNotifyObjectEx.Notifycation(const iInf: TUcNotifyInfos; const iTag,
                                         iMax, iPos: Integer; const iTxt: string = '';
                                         const iErr: Boolean = False);
begin
  SetNotify(iInf, iTag, iMax, iPos, iTxt, iErr);
  Notify;
end;

procedure TUcNotifyObjectEx.SetNotify(const iInf: TUcNotifyInfos; const iTag, iMax, iPos: Integer;
                                      const iTxt: string = ''; const iErr: Boolean = False);
begin
  FNotifyInf := iInf;
  if niTag in FNotifyInf then FNotifyTag := iTag;
  if niMax in FNotifyInf then FNotifyMax := iMax;
  if niPos in FNotifyInf then FNotifyPos := iPos;
  if niTxt in FNotifyInf then FNotifyTxt := iTxt;
  if niErr in FNotifyInf then FNotifyErr := iErr;

  // Запоминаем, если были уведомления об ошибке
  WereErrors := WereErrors or FNotifyErr;
end;

{ TUcNotifyHelper }

constructor TUcNotifyHelper.Create(OwnObjectNotification: TObject);
begin
  inherited Create;
  fOwnObjectNotification := OwnObjectNotification;
end;

function TUcNotifyHelper.NotifyObject: TObject;
begin
  Result := fOwnObjectNotification;
end;

end.

