// Версия - 29.09.2011
unit ucDBWorker;
{$include ..\delphi_ver.inc}

interface

uses Forms, Controls, SysUtils, Classes, IBDataBase, DB, IBQuery, IniFiles,
     Variants, StrUtils, IB, StdCtrls, IBServices, Math, DBGrids,
     ExcelXP, OleServer, Graphics,
     ucSQLGenerator, uOpenOffice, ucFunctions,
{$IFDEF DELPHI_2009_UP}
     ucDialogs,
{$ELSE}
     Dialogs,
{$ENDIF}
     ucHint, ucTypes;

type
  TUcDBWorker = class(TComponent)
  private
    DBSettingsSection: String;
    DEF_SettingsPath:String;
    DEF_DBPath:String;
    DB: TIBDataBase;
    Tr_R: TIBTransaction; // Читающая транзакция
    Tr_W: TIBTransaction; // Пишущая (короткая) транзакция
    fWorkPath:string;
    fDBSettingsPath:string;
    fOnBackUpProcess: TBackUpFeedBack;
    function GetAbsolutePath(Path: string): String;
    function GetDBPath: String;
    procedure SetDBPath(Value: string);
    procedure SetDB(Value: TIBDataBase);
    procedure SetDBSettingsPath(Value: string);

    procedure SetTr_R(Value: TIBTransaction);
    procedure SetTr_W(Value: TIBTransaction);

    function GetVersion: TCaption;
    procedure SetVersion(Value: TCaption);

    function  GetUserName: string;
    procedure SetUserName(Value: string);
    function  GetPassword: string;
    procedure SetPassword(Value: string);
  protected
    procedure ConfTr_R(Transaction: TIBTransaction);
    procedure ConfTr_W(Transaction: TIBTransaction);
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent;
                       IBDatabase: TIBDatabase;
                       AutoConnect: Boolean);reintroduce; overload;
    destructor Destroy; override;
    procedure LoadDBSettings;
    procedure SaveDBSettings;
    function  CreateDatabase(PageSize: integer = 4096): Boolean;
    function  Connect: Boolean;
    function  TestConnected(TryConnect: Boolean): Boolean;
    procedure Disconnect;
    function  NewWriteTransaction(AOwner: TComponent): TIBTransaction;
    procedure BackUp(BackUpPath: string = ''; ShowDialog: Boolean = True);
    procedure Restore(BackUpPath: string = ''; ShowDialog: Boolean = True);

    procedure ConfiguratingReadingQuery(IBQuery: TIBQuery; NeedOpen: Boolean);
    function  OpenQuery(Sql: string; Transaction: TIBTransaction = nil): TIBQuery;
    procedure UpdateQuery(Q: TIBQuery; SaveBookmark: Boolean = true;
                          RestartTransaction: Boolean = false;
                          SaveActivTransaction: Boolean = false);
    function  NewIBQuery(AOwner: TComponent): TIBQuery;
    function  NewReadIBQuery(AOwner: TComponent = nil): TIBQuery;
    function  NewWriteIBQuery(AOwner: TComponent = nil): TIBQuery;
    function  ProcessingQuery(Query: TIBQuery; ReturnData: Boolean): Boolean;

    function  ExecuteQuery(SqlTxt: array of string;
                           Transaction: TIBTransaction = nil;
                           Commit: Boolean = true): Boolean; overload;
    function  ExecuteQuery(SqlList: TStringList): Boolean; overload;

    function  ParamsToStr(Values: array of Variant): string;
    function  SaveToDBF(SQL: string;
                        Transaction: TIBTransaction;
                        Commit: Boolean): Boolean; overload;
    function  SaveToDBF(Q: TIBQuery; Commit: Boolean): Boolean; overload;

    procedure ComboBoxFill(ComboBox: TComboBox;
                           Sql, Field_Txt, Field_ID: string;
                           SetID: integer = -1);
    function  ComboBoxGetValue(ComboBox: TComboBox): Variant;

    function  ExportToOOEA(DBGrid: TDBGrid): Boolean; overload;
    function  ExportToOOEA(Q: TDataSet;
                iFields, iAliases: array of string): Boolean; overload;

    function  ExportToOpenOfficeCalc(DBGrid: TDBGrid): Boolean; overload;
    function  ExportToOpenOfficeCalc(Q: TDataSet;
                iFields, iAliases: array of string): Boolean; overload;

    function  ExportToMSExcel(DBGrid: TDBGrid): Boolean; overload;
    function  ExportToMSExcel(Q: TDataSet;
                iFields, iAliases: array of string): Boolean; overload;

    property UserName: string read GetUserName write SetUserName;
    property Password: string read GetPassword write SetPassword;
    property DBPath : string read GetDBPath write SetDBPath;
    property WorkPath : string read fWorkPath write fWorkPath;
  published
    property Version: TCaption read GetVersion write SetVersion stored False;
    property DataBase : TIBDataBase read DB write SetDB;
    property IBTransaction_R : TIBTransaction read Tr_R write SetTr_R;
    property IBTransaction_W : TIBTransaction read Tr_W write SetTr_W;
    property DBSettingsPath : string read fDBSettingsPath
                                     write SetDBSettingsPath;
    property OnBackUpProcess: TBackUpFeedBack read  fOnBackUpProcess
                                              write fOnBackUpProcess;
  end;

  TFormClass = class of TForm;

  TDBLink = class(TComponent)
  private
    fOwner:TComponent;
    procedure SetOwner(Value: TComponent);
  protected
    fIDOwner          : integer;
    fID               : integer;
    fTransaction      : TIBTransaction;
    fTableName        : string;
    fSQL              : string;
    fClassWinEdit     : TFormClass;
    fCommitAfterEdit  : Boolean;

    function GetIDAsStr: string;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateFill( AOwner: TComponent;
                            crIDOwner, crID: integer;
                            crTransaction: TIBTransaction;
                            crTableName, crSQL: string;
                            crClassWinEdit: TFormClass;
                            crCommitAfterEdit: Boolean
                          ); overload;
    constructor CreateFill(AOwner: TComponent; crDBLink: TDBLink); overload;
    //--
    function GetQuerySelectAll: string;
    function GetQuerySelectByID: string;
    function GetQueryDeleteByID: string;
    //--
    property Owner:TComponent read fOwner write SetOwner;

    property IDOwner          : integer         read fIDOwner         write fIDOwner        ;
    property ID               : integer         read fID              write fID             ;
    property IDAsString       : string          read GetIDAsStr                             ;
    property Transaction      : TIBTransaction  read fTransaction     write fTransaction    ;
    property TableName        : string          read fTableName       write fTableName      ;
    property SQL              : string          read fSQL             write fSQL            ;
    property ClassWinEdit     : TFormClass      read fClassWinEdit    write fClassWinEdit   ;
    property CommitAfterEdit  : Boolean         read fCommitAfterEdit write fCommitAfterEdit;
  end;

  procedure BackUpIBDataBase(IBDataBase: TIBDatabase; iBackUpPath: string;
                             BackUp: Boolean; FeedBack: TBackUpFeedBack);
  procedure BackUpIBDataBaseEx(iDBPath, iDBUser, iDBPassword, iBackUpPath: string;
                               BackUp: Boolean; FeedBack: TBackUpFeedBack);
type
  TFDBWorker = class (TUcDBWorker); // Для совместимости со старыми проектами
  procedure Register;

implementation

{$R *.dcr}
{$Include ..\Versions.ucver}

procedure Register;
begin
  RegisterComponents('UControls', [TUcDBWorker]);
end;

//               TUcDBWorker
procedure TUcDBWorker.LoadDBSettings;
var ini: TIniFile;
begin
  ini := TIniFile.Create(fDBSettingsPath);
  try
    DB.DatabaseName := ini.ReadString(DBSettingsSection,'DBPath',DEF_DBPath);
  finally
    ini.Free;
  end;
end;

procedure TUcDBWorker.SaveDBSettings;
var ini: TIniFile;
begin
  ini := TIniFile.Create(fDBSettingsPath);
  try
    ini.WriteString(DBSettingsSection,'DBPath', DB.DatabaseName);
  finally
    ini.Free;
  end;
end;

function TUcDBWorker.CreateDatabase(PageSize: integer = 4096): Boolean;
begin
  try
    with DataBase do
    begin
      Params.Clear;
      Params.Add('USER "SYSDBA"');
      Params.Add('PASSWORD "masterkey"');
      Params.Add('PAGE_SIZE '+IntToStr(PageSize));
      SQLDialect := 3;
      CreateDatabase;
    end;
    Result := true;
  except
    Result := false;
  end;
end;

function TUcDBWorker.Connect: Boolean;
begin
  try
    //DB.DatabaseName := DBPath;
    DB.Connected := True;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TUcDBWorker.Disconnect;
begin
  if Assigned(DB) then
    DB.Connected := False;
end;

constructor TUcDBWorker.Create(AOwner: TComponent);
begin
  inherited;

  //  Настройки по умолчанию
  fWorkPath         := ExtractFilePath(Application.ExeName);
  DEF_DBPath        := GetAbsolutePath('DB\DB.FDB');
  DEF_SettingsPath  := GetAbsolutePath('db.ini');
  DBSettingsSection := 'FDBW_Settings';
  fDBSettingsPath := DEF_SettingsPath;
  DB    := nil;
  Tr_R  := nil;
  Tr_W  := nil;

end;

constructor TUcDBWorker.Create(AOwner: TComponent; IBDatabase: TIBDatabase; AutoConnect: Boolean);
begin
	Create(AOwner);
  // Создаем и настраиваем компоненты работы с базой
  if Assigned(IBDatabase) then
  begin
    DB := IBDatabase;
  end
  else begin
    try
      DB := TIBDatabase.Create(Self);
    except
      on E: EIBError do
        begin
          if E.SQLCode = 1 then
            raise EIBClientError.Create(E.SQLCode,
                    #13#10'Библиотека, gds32.dll не найдена. '+
                    'Пожалуйста установите Firebird 2.5 (или выше), '+
                    'чтобы использовать эти функциональные возможности.')
            else
            raise EIBClientError.Create(E.SQLCode, E.Message);
        end;
    end;
    with DB do
    begin
      LoginPrompt := false;
      Params.Add('user_name=sysdba');
      Params.Add('password=masterkey');
      Params.Add('lc_ctype=WIN1251');
    end;
  end;
  //---
  if not DB.Connected then DBPath := DEF_DBPath;

  Tr_R := TIBTransaction.Create(Self);
  ConfTr_R(Tr_R);
  Tr_W := NewWriteTransaction(Self);
  //**
  if AutoConnect then
  begin
    DB.Connected := False;
    LoadDBSettings;
    Connect;
  end;
end;

destructor TUcDBWorker.Destroy;
begin
  Disconnect;
	inherited Destroy;
end;

function TUcDBWorker.NewWriteTransaction(AOwner: TComponent): TIBTransaction;
begin
  Result := TIBTransaction.Create(AOwner);
  ConfTr_W(Result);
end;

procedure TUcDBWorker.BackUp(BackUpPath: string = ''; ShowDialog: Boolean = True);
var SvDlg: TSaveDialog;
begin
  if ShowDialog then
  begin
    SvDlg := TSaveDialog.Create(Self);
    try
      SvDlg.Filter := 'Firebird BackUp|*.fbk';
      SvDlg.Options := SvDlg.Options + [ofOverwritePrompt];
      SvDlg.FileName := BackUpPath;
      if
        {$IFDEF DELPHI_2009_UP}
              SvDlg.Execute(Application.Handle)
        {$ELSE}
              SvDlg.Execute()
        {$ENDIF}
        then
        BackUpIBDataBase(DB, SvDlg.FileName, True, fOnBackUpProcess);
    finally
      SvDlg.Free;
    end;
  end else
    BackUpIBDataBase(DB, BackUpPath, True, fOnBackUpProcess);
end;

procedure TUcDBWorker.Restore(BackUpPath: string = ''; ShowDialog: Boolean = True);
  procedure DBRestore(FileName: string);
  var SaveConnects: array of Boolean;
      i: integer;
  begin
    SetLength(SaveConnects, DB.DataSetCount);
    for I := 0 to DB.DataSetCount - 1 do
      SaveConnects[i] := DB.DataSets[i].Active;
    //--
    Disconnect;
    BackUpIBDataBase(DB, FileName, False, fOnBackUpProcess);
    Connect;
    DB.DataSetCount;
    //--
    for I := 0 to DB.DataSetCount - 1 do
      DB.DataSets[i].Active := SaveConnects[i];
    SetLength(SaveConnects, 0);
  end;

var OpnDlg: TOpenDialog;
    SaveCurDir: string;
begin
  if ShowDialog then
  begin
    OpnDlg := TOpenDialog.Create(Self);
    try
      OpnDlg.Filter := 'Firebird BackUp|*.fbk';
      OpnDlg.FileName := BackUpPath;
      SaveCurDir := GetCurrentDir;
      if
        {$IFDEF DELPHI_2009_UP}
              OpnDlg.Execute(Application.Handle)
        {$ELSE}
              OpnDlg.Execute()
        {$ENDIF}
        then
        begin
          ChDir(SaveCurDir);
          DBRestore(OpnDlg.FileName);
        end;
      ChDir(SaveCurDir);
    finally
      OpnDlg.Free;
    end;
  end else
    DBRestore(BackUpPath);
end;

function TUcDBWorker.GetAbsolutePath(Path: string): String;
begin
  if (Length(Path)<2)or
     (Copy(Path, 1, 2) = PathDelim + PathDelim)or
     (ExtractFileDrive(Path) <> '')or
     (Pos(':',Path)>0)then
	begin
		Result := Path;
	end
	else begin
	  if Path[1]=PathDelim then  Delete(Path,1,1);
    Result := fWorkPath + Path;
	  if (Path[Length(Result)]<>PathDelim)and(ExtractFileExt(Result)='') then
	    Result := Result + PathDelim;
	end;
end;

function TUcDBWorker.GetDBPath: String;
begin
  if Assigned(DB) then
    Result := DB.DatabaseName// GetAbsolutePath(DB.DatabaseName)
    else
    Result := '';
end;

procedure TUcDBWorker.SetDBPath(Value: string);
begin
  if Assigned(DB) then
    DB.DatabaseName := Value;
end;

procedure TUcDBWorker.SetDBSettingsPath(Value: string);
begin
  fDBSettingsPath := GetAbsolutePath(Value);
end;

procedure TUcDBWorker.SetDB(Value: TIBDataBase);
begin
  if DB <> Value then
  begin
    if Assigned(DB)and (DB.Owner = Self) then
    begin
      IBTransaction_R := nil;
      IBTransaction_W := nil;
      DB.Free;
    end;
    DB := Value;
  end;
end;

procedure TUcDBWorker.SetTr_R(Value: TIBTransaction);
begin
  if Tr_R <> Value then
  begin
    if Assigned(Tr_R)and (Tr_R.Owner = Self)then Tr_R.Free;
    if Assigned(DB) then
    begin
      Tr_R := Value;
      ConfTr_R(Tr_R);
    end else
      Tr_R := nil;
  end;
end;

procedure TUcDBWorker.SetTr_W(Value: TIBTransaction);
begin
  if Tr_W <> Value then
  begin
    if Assigned(Tr_W)and (Tr_W.Owner = Self)then Tr_W.Free;
    if Assigned(DB) then
    begin
      Tr_W := Value;
      ConfTr_W(Tr_W);
    end else
      Tr_W := nil;
  end;
end;

procedure TUcDBWorker.ConfTr_R(Transaction: TIBTransaction);
begin
  if Assigned(Transaction)then
    with Transaction do
      begin
        DefaultDatabase := DB;
        Params.Clear;
        Params.Add('read_committed');
        Params.Add('rec_version');
        Params.Add('nowait');
        Params.Add('read');
      end;
end;

procedure TUcDBWorker.ConfTr_W(Transaction: TIBTransaction);
begin
  if Assigned(Transaction)then
    with Transaction do
      begin
        DefaultDatabase := DB;
        Params.Clear;
        Params.Add('read_committed');
        Params.Add('rec_version');
        Params.Add('nowait');
      end;
end;

function TUcDBWorker.GetVersion: TCaption;
begin
  Result:= UcDBWorkerVersion;
end;

procedure TUcDBWorker.SetVersion(Value: TCaption);
begin
  //--
end;

function TUcDBWorker.TestConnected(TryConnect: Boolean): Boolean;
begin
  Result := DB.TestConnected or (TryConnect and Connect);
end;

function  TUcDBWorker.GetUserName: string;
begin
  if Assigned(DB) then
    Result := DB.Params.Values['user_name']
    else
    Result := '';
end;

procedure TUcDBWorker.SetUserName(Value: string);
begin
  if Assigned(DB) then
    DB.Params.Values['user_name'] := Value;
end;

function  TUcDBWorker.GetPassword: string;
begin
  if Assigned(DB) then
    Result := DB.Params.Values['password']
    else
    Result := '';
end;

procedure TUcDBWorker.SetPassword(Value: string);
begin
  if Assigned(DB) then
    DB.Params.Values['password'] := Value;
end;

procedure TUcDBWorker.ConfiguratingReadingQuery(IBQuery: TIBQuery; NeedOpen: Boolean);
var SaveActive: Boolean;
begin
  if Assigned(IBQuery) then
    with IBQuery do
      begin
        SaveActive := Active;
        Close;
        Database := DB;
        Transaction := Tr_R;
        Active := SaveActive or NeedOpen;
      end;
end;

function TUcDBWorker.OpenQuery(Sql: string; Transaction: TIBTransaction = nil): TIBQuery;
var Tr: TIBTransaction;
begin
  if Assigned(Transaction) then
    Tr := Transaction
    else
    Tr := Tr_R;
  Result := ucSQLGenerator.OpenQuery(Sql, Tr);
end;

procedure TUcDBWorker.UpdateQuery(Q: TIBQuery; SaveBookmark: Boolean = true;
                                 RestartTransaction: Boolean = false;
                                 SaveActivTransaction: Boolean = false);
begin
  ucSQLGenerator.UpdateQuery(Q, SaveBookmark,
                             RestartTransaction, SaveActivTransaction);
end;

function TUcDBWorker.NewIBQuery(AOwner: TComponent): TIBQuery;
begin
  if Assigned(AOwner) then
    Result := TIBQuery.Create(AOwner)
    else
    Result := TIBQuery.Create(Self);
  Result.Database := DataBase;
end;

function TUcDBWorker.NewReadIBQuery(AOwner: TComponent = nil): TIBQuery;
begin
  Result := NewIBQuery(AOwner);
  Result.Transaction := IBTransaction_R;
end;

function TUcDBWorker.NewWriteIBQuery(AOwner: TComponent = nil): TIBQuery;
begin
  Result := NewIBQuery(AOwner);
  Result.Transaction := IBTransaction_W;
end;

function TUcDBWorker.ProcessingQuery(Query: TIBQuery; ReturnData: Boolean): Boolean;
begin
  with Query do
  try
    if ReturnData then
      Open
      else
      ExecSQL;
    Result := true;
  except
    on E: EIBError do
     begin
       Result := false;
       SQLException(PChar(E.Message), PChar(SQL.Text + CrLf + GetSQLParamList(Query)));
     end;
  end;
end;

function TUcDBWorker.ExecuteQuery(SqlTxt: array of string;
                                  Transaction: TIBTransaction = nil;
                                  Commit: Boolean = true): Boolean;
var Tr: TIBTransaction;
begin
  if Assigned(Transaction) then
    Tr := Transaction
    else
    Tr := Tr_W;
  Result := ucSQLGenerator.ExecuteQuery(SqlTxt, Tr, false, Commit);
end;

function TUcDBWorker.ExecuteQuery(SqlList: TStringList): Boolean;
begin
  Result := ucSQLGenerator.ExecuteQuery(SqlList, Tr_W, false);
end;

function TUcDBWorker.ParamsToStr(Values: array of Variant): string;
var RetVar, ErrMsg: string;
    i: integer;
begin
  RetVar:='';

  ErrMsg:= '';
  for i:=0 to High(Values) do
    RetVar := RetVar + UC_VarToSQLStr(Values[i]) + ',';
  Delete(RetVar,length(RetVar),1);
  if ErrMsg <> '' then ShowMessage(ErrMsg);

  Result := RetVar;
end;

function TUcDBWorker.SaveToDBF(SQL: string;
                              Transaction: TIBTransaction;
                              Commit: Boolean): Boolean;
begin
  Result := SaveToDBF(OpenQuery(SQL, Transaction), Commit);
end;

function TUcDBWorker.SaveToDBF(Q: TIBQuery; Commit: Boolean): Boolean;
var Field: TField;
    vResult: integer;
    vMsg: string;
begin
  Result := False;
  if Assigned(Q) then
  try
    // Получаем результат выполнения процедуры
    Field := Q.FindField('Result');
    if Assigned(Field) then
      vResult := Field.AsInteger else vResult := 0;

    Field := Q.FindField('MSG');
    if Assigned(Field) then
      vMsg := Field.AsString else vMsg := '';
    // Обработка результатов
    if vResult = 0 then
    begin
      if Commit then Q.Transaction.Commit;
      Result := True;
    end;
    if vMsg <> '' then
      MessageDlg(vMsg, mtInformation, [mbOK], 0);
    //**

  finally
    Q.Free;
  end;
end;

procedure TUcDBWorker.ComboBoxFill(ComboBox: TComboBox;
                                  Sql, Field_Txt, Field_ID: string;
                                  SetID: integer = -1);
var Q: TIBQuery;
begin
  Q := OpenQuery(Sql);
  if Assigned(Q) then
  try
    ComboBox.Clear;
    //ComboBox.ItemIndex := -1;
    Q.First;
    while not Q.Eof do
    begin
      ComboBox.AddItem(Q.FieldByName(Field_Txt).AsString,
                       TObject(Q.FieldByName(Field_ID).AsInteger));
      if Q.FieldByName(Field_ID).AsInteger = SetID then
        ComboBox.ItemIndex := ComboBox.Items.Count - 1;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

function TUcDBWorker.ComboBoxGetValue(ComboBox: TComboBox): Variant;
begin
  if ComboBox.ItemIndex > -1 then
    Result:= integer(ComboBox.Items.Objects[ComboBox.ItemIndex])
    else
    Result:= null;
end;

type TArrayOfString = array of string;

procedure ExtractFieldsFromDBGrid(DBGrid: TDBGrid;
                                  Out Fields, Aliases: TArrayOfString);
var i, t: integer;
begin
  SetLength(Fields, DBGrid.Columns.Count);
  SetLength(Aliases, DBGrid.Columns.Count);
  t := 0;
  for I := 0 to DBGrid.Columns.Count - 1 do
  if Assigned(DBGrid.DataSource.DataSet.FindField(DBGrid.Columns[i].FieldName)) then
  begin
    Fields[t] := DBGrid.Columns[i].FieldName;
    Aliases[t]:= DBGrid.Columns[i].Title.Caption;
    Inc(t);
  end;
  SetLength(Fields,  t);
  SetLength(Aliases, t);
end;

function  TUcDBWorker.ExportToOOEA(DBGrid: TDBGrid): Boolean;
var Fields, Aliases: TArrayOfString;
begin
  ExtractFieldsFromDBGrid(DBGrid, Fields, Aliases);
  Result := ExportToOOEA(DBGrid.DataSource.DataSet, Fields, Aliases);
end;

function  TUcDBWorker.ExportToOOEA(Q: TDataSet;
            iFields, iAliases: array of string): Boolean;
begin
  Result := ExportToMSExcel(Q, iFields, iAliases);
  if not Result then
    Result := ExportToOpenOfficeCalc(Q, iFields, iAliases);
  //--
  if not Result then
    MessageDlg('Для выгрузки таблицы необходимо установить:'#13#10+
               'MS Office или OpenOffice', mtInformation, [mbOK], 0);
end;

function TUcDBWorker.ExportToOpenOfficeCalc(DBGrid: TDBGrid): Boolean;
var Fields, Aliases: TArrayOfString;
begin
  ExtractFieldsFromDBGrid(DBGrid, Fields, Aliases);
  Result := ExportToOpenOfficeCalc(DBGrid.DataSource.DataSet, Fields, Aliases);
end;

function TUcDBWorker.ExportToOpenOfficeCalc(Q: TDataSet;
                      iFields, iAliases: array of string): Boolean;
var oo : TOOCalc;
    Sheet: TOOCalcSheet;
    r, c, FCnt: integer;
    Fields, Aliases: array of string;

    OBL: TOpenBorderLine;

begin
  TRY
    FCnt := Min(Length(iFields), Length(iAliases));
    if FCnt = 0 then
    begin
      FCnt := Q.FieldCount;
      SetLength(Fields, FCnt);
      SetLength(Aliases, FCnt);
      for c := 0 to FCnt - 1 do
      begin
        Fields[c]  := Q.Fields[c].FieldName;
        Aliases[c] := Q.Fields[c].FieldName;
      end;
    end else
    begin
      SetLength(Fields, Length(iFields));
      for c := 0 to Length(iFields) - 1  do Fields[c]  := iFields[c];

      SetLength(Aliases, Length(iAliases));
      for c := 0 to Length(iAliases) - 1 do Aliases[c] := iAliases[c];
    end;
    //--
    oo := TOOCalc.Create;
    Q.DisableControls;
    try
      oo.Connect := True;
      oo.OpenDocument('', [oomAsTemplate, oomHidden], ommAlways);
      oo.Sheets.ActiveByIndex := 0;
      Sheet := oo.Sheets.Active;
      //----------
      r := 0;
      for c := 0 to FCnt - 1 do Sheet.Cell[c, r].AsText := Aliases[c];
      Sheet.CellRange[0, r, FCnt - 1, r].Font.Weight := ofwBold;
      Inc(r);
      Q.First;
      while not Q.Eof do
      begin
        for c := 0 to FCnt - 1 do
          Sheet.Cell[c, r].AsText := Q.FieldByName(Fields[c]).AsString;
        Inc(r);
        Q.Next;
      end;
      for c := 0 to FCnt - 1 do Sheet.Columns[c].OptimalWidth := True;

      OBL.Color := clBlack;
      OBL.InnerLineWidth := 1;
      OBL.OuterLineWidth := 0;
      OBL.LineDistance := 0;
      Sheet.CellRange[0, 0, FCnt - 1, r - 1].TableBorder.SetAll(OBL, otbOuterHoriVert);

      oo.Visible := True;
      //**
    finally
      oo.Free;
      Q.EnableControls;
    end;
    Result := True;
  EXCEPT
    Result := False;
  END;
end;

function TUcDBWorker.ExportToMSExcel(DBGrid: TDBGrid): Boolean;
var Fields, Aliases: TArrayOfString;
begin
  ExtractFieldsFromDBGrid(DBGrid, Fields, Aliases);
  Result := ExportToMSExcel(DBGrid.DataSource.DataSet, Fields, Aliases);
end;

function TUcDBWorker.ExportToMSExcel(Q: TDataSet;
                      iFields, iAliases: array of string): Boolean;
var EA: TExcelApplication;
    WB: _Workbook;
    WS: _Worksheet;

    r, c, FCnt: integer;
    Fields, Aliases: array of string;
begin
  TRY
    FCnt := Min(Length(iFields), Length(iAliases));
    if FCnt = 0 then
    begin
      FCnt := Q.FieldCount;
      SetLength(Fields, FCnt);
      SetLength(Aliases, FCnt);
      for c := 0 to FCnt - 1 do
      begin
        Fields[c]  := Q.Fields[c].FieldName;
        Aliases[c] := Q.Fields[c].FieldName;
      end;
    end else
    begin
      SetLength(Fields, Length(iFields));
      for c := 0 to Length(iFields) - 1  do Fields[c]  := iFields[c];

      SetLength(Aliases, Length(iAliases));
      for c := 0 to Length(iAliases) - 1 do Aliases[c] := iAliases[c];
    end;
    //--
    EA := TExcelApplication.Create(Self);
    Q.DisableControls;
    try
      EA.ConnectKind := ckNewInstance;
      EA.Connect;
      EA.Workbooks.Add(NULL, 0);
      WB := EA.Workbooks.Item[1];
      WS := WB.Worksheets.Item[1] as _Worksheet;
      //----------
      r := 1;
      for c := 0 to FCnt - 1 do
        WS.Cells.Item[r, c + 1].Value2 := Aliases[c];
      WS.Range[WS.Cells.Item[r, 1],WS.Cells.Item[r, FCnt]].Font.Bold := True;
      Inc(r);
      Q.First;
      while not Q.Eof do
      begin
        for c := 0 to FCnt - 1 do
          WS.Cells.Item[r, c + 1].Value2 := Q.FieldByName(Fields[c]).AsString;
        Inc(r);
        Q.Next;
      end;
      WS.Range[WS.Cells.Item[1, 1],WS.Cells.Item[1, FCnt]].EntireColumn.AutoFit;
      WS.Range[WS.Cells.Item[1, 1],WS.Cells.Item[r - 1, FCnt]].Borders.LineStyle := xlContinuous;
      EA.Visible[0] := True;
      //**
      EA.AutoQuit := False;
      EA.Disconnect;
    finally
      Q.EnableControls;
      EA.Free;
    end;
    Result := True;
  EXCEPT
    Result := False;
  END;
end;
//            TDBLink
constructor TDBLink.Create(AOwner: TComponent);
begin
  inherited Create(nil);
  fOwner := nil;
  Owner := AOwner;

  fIDOwner          := 0;
  fID               := 0;
  fTransaction      := nil;
  fTableName        := '';
  fSQL              := '';
  fClassWinEdit     := nil;
  fCommitAfterEdit  := True;
end;

procedure TDBLink.SetOwner(Value: TComponent);
begin
  if Assigned(fOwner) then
    fOwner.RemoveComponent(Self);
  fOwner := Value;
  if Assigned(fOwner) then
    fOwner.InsertComponent(Self);
end;

constructor TDBLink.CreateFill( AOwner: TComponent;
                                crIDOwner, crID: integer;
                                crTransaction: TIBTransaction;
                                crTableName, crSQL: string;
                                crClassWinEdit: TFormClass;
                                crCommitAfterEdit: Boolean
                              );
begin
  Create(AOwner);

  fIDOwner          := crIDOwner;
  fID               := crID;
  fTransaction      := crTransaction;
  fTableName        := crTableName;
  fSQL              := crSQL;
  fClassWinEdit     := crClassWinEdit;
  fCommitAfterEdit  := crCommitAfterEdit;
end;

constructor TDBLink.CreateFill(AOwner: TComponent; crDBLink: TDBLink);
begin
  Create(AOwner);

  fIDOwner          := crDBLink.IDOwner;
  fID               := crDBLink.ID;
  fTransaction      := crDBLink.Transaction;
  fTableName        := crDBLink.TableName;
  fSQL              := crDBLink.SQL;
  fClassWinEdit     := crDBLink.ClassWinEdit;
  fCommitAfterEdit  := crDBLink.CommitAfterEdit;
end;

function TDBLink.GetIDAsStr: string;
begin
  Result := IntToStr(ID);
end;

function TDBLink.GetQuerySelectAll: string;
begin
  Result := 'select * from ' + TableName;
end;

function TDBLink.GetQuerySelectByID: string;
begin
  Result := 'select * from ' + TableName + #13#10+
            'where ID=' + IDAsString;
end;

function TDBLink.GetQueryDeleteByID: string;
begin
  Result := 'delete from ' + TableName + #13#10+
            'where ID=' + IDAsString;
end;

//            Функции
procedure BackUpIBDataBase(IBDataBase: TIBDatabase; iBackUpPath: string;
                         BackUp: Boolean; FeedBack: TBackUpFeedBack);
begin
  BackUpIBDataBaseEx(IBDatabase.DatabaseName,
                   IBDatabase.Params.Values['user_name'],
                   IBDatabase.Params.Values['password'],
                   iBackUpPath, BackUp,
                   FeedBack);
end;

procedure BackUpIBDataBaseEx(iDBPath, iDBUser, iDBPassword, iBackUpPath: string;
                           BackUp: Boolean; FeedBack: TBackUpFeedBack);
var
  DbPath, ErrMsg: string;
  DivPos, DivPos2: integer;
  IBBackupService: TIBBackupRestoreService;
begin
  ErrMsg := '';
  if BackUp then
    IBBackupService := TIBBackupService.Create(nil)
    else
    IBBackupService := TIBRestoreService.Create(nil);

  try
  //++++++++++++++++++++++++++++
    TRY
      IBBackupService.LoginPrompt  := False;
      IBBackupService.Verbose      := Assigned(FeedBack);
      // Определение/настройка подключения
      DbPath  := iDBPath;
      DivPos  := Pos(':', DbPath);
      DivPos2 := PosEx(':', DbPath, DivPos + 1);
      if DivPos2 > 0  then
      begin
        IBBackupService.Protocol     := TCP;
        IBBackupService.ServerName   := Copy(DbPath, 1, DivPos - 1);
        DbPath := copy(DbPath, DivPos + 1, Length(DbPath));
      end else
      begin
        IBBackupService.Protocol     := Local;
        IBBackupService.ServerName   := '';//'localhost';
        if DivPos = 0 then
          DbPath := ExtractFilePath(Application.ExeName) + DbPath;

      end;
      if UpperCase(ExtractFileExt(iBackUpPath)) <> '.FBK' then
        iBackUpPath := iBackUpPath + '.fbk';

      if BackUp then
      begin
        TIBBackupService(IBBackupService).BackupFile.Text := iBackUpPath;
        TIBBackupService(IBBackupService).DatabaseName    := DbPath;
      end else
      begin
        TIBRestoreService(IBBackupService).BackupFile.Text  := iBackUpPath;
        TIBRestoreService(IBBackupService).DatabaseName.Text:= DbPath;
        TIBRestoreService(IBBackupService).Options :=
          TIBRestoreService(IBBackupService).Options + [Replace];
      end;

      // Импорт параметров
      IBBackupService.Params.Clear;
      IBBackupService.Params.Add('user_name='+iDBUser);
      IBBackupService.Params.Add('password='+iDBPassword);
      //**
      try
        IBBackupService.Active := True;
        IBBackupService.ServiceStart;

        if Assigned(FeedBack) then
          while not IBBackupService.Eof do
            FeedBack(IBBackupService.GetNextLine);
      finally
        IBBackupService.Active := False;
      end;

    EXCEPT
      on E: EDatabaseError do ErrMsg := E.Message;
      on E: Exception      do ErrMsg := E.Message;
    END;
    if ErrMsg <> '' then MessageDlg('Ошибка:'#10#13 + ErrMsg, mtError, [mbOK], 0);
  //++++++++++++++++++++++++++++++
  finally
    IBBackupService.Free;
  end;
end;

end.
