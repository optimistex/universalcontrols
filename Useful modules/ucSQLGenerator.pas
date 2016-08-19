// Версия - 30.06.2011
{
Модуль предназначен для упрощения работы с запросами. Массовое выполнение запросов передавая их в массиве или 
списком. Также удобная генерация запросов обновления и вставки данных

 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   Для работы с запросами через BDE
   Рекомендуется при вызове функций SqlInsert и SqlUpdate явно задавать дату и
         время пользуясь функциями StrDateTimeSQL и DateTimeToSQL
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
}
unit ucSQLGenerator;
{$include ..\delphi_ver.inc}

interface

Uses SysUtils, Dialogs, Math, DBTables, Variants, IBQuery, IBDatabase, DB, IB,
     Classes, ucTypes, ucFunctions;

type

  //--- Класс для создания отдельного
  // (транзакция + запрос) подключения к базе ---
  TSeparateConnection = class(TComponent)
  private
    FOwner: TComponent;

    F_IBTransaction : TIBTransaction;
    F_IBQuery       : TIBQuery;

    procedure SetOwner(AOwner: TComponent);
  protected

  public
    constructor Create(AOwner: TComponent;
                       IBDataBase: TIBDataBase); reintroduce;

    function ExecuteQuery(SqlTxt: array of string;
                          Retaining: Boolean = true;
                          Commit: Boolean = true;
                          CustomMessage: string = ''): Boolean; overload;

    function ExecuteQuery(SqlList: TStringList;
                          Retaining: Boolean = true;
                          Commit: Boolean = true;
                          CustomMessage: string = ''): Boolean; overload;
    function OpenQuery(SqlTxt: string): TIBQuery;

    property Owner: TComponent read FOwner write SetOwner;

    property IBTransaction: TIBTransaction read F_IBTransaction;
    property IBQuery: TIBQuery             read F_IBQuery; 
  end;
  //**
  // Прототипы функций
  function SqlInsert(TableName: string; ColNames: array of string; Values: array of Variant): string; overload;
  function SqlUpdate(TableName: string; ColNames: array of string; Values: array of Variant; WhereClause: string): string;
  // Дополнительные функции
  function StrDateTimeSQL(V: string): string;
  function GetSQLParamList(Q: TIBQuery): string;

  function GenerateKod(Const FieldName, TablName: string; Inc: integer = 1): integer; deprecated {$IFDEF DELPHI_2009_UP}'don`t use it!'{$ENDIF};
  function GenerateKod_IB(DBase: TIBDataBase; Trzact: TIBTransaction;
                          Const FieldName, TablName: string; Inc: integer = 1): integer; deprecated {$IFDEF DELPHI_2009_UP}'don`t use it!'{$ENDIF};
  // Обновление запросов
  procedure UpdateQuery(Q: TIBQuery; SaveBookmark: Boolean = true;
                        RestartTransaction: Boolean = false;
                        SaveActivTransaction: Boolean = false); overload;
  procedure UpdateQuery(Q: TQuery; SaveBookmark: Boolean = true); overload;
  // Выполнение запросов
  function ExecuteQuery(SqlTxt: array of string; DBase: TDataBase): Boolean; overload;

  function ExecuteQuery(SqlTxt: array of string;
                        IBTransaction: TIBTransaction;
                        Retaining: Boolean = true;
                        Commit: Boolean = true): Boolean; overload;
  function ExecuteQuery(SqlList: TStringList;
                        IBTransaction: TIBTransaction;
                        Retaining: Boolean = true;
                        Commit: Boolean = true): Boolean; overload;
  function OpenQuery(SqlTxt: string;
                     IBTransaction: TIBTransaction): TIBQuery; overload;

  function CheckingLocking(TableName, ID_Value: string;
                           Tr: TIBTransaction;
                           ShowDialog: Boolean = true): Boolean; overload;
  function CheckingLocking(SQLText: string;
                           Tr: TIBTransaction;
                           ShowDialog: Boolean = true): Boolean; overload;
  //**
  procedure SQLException(ErrText, ErrSql: PChar;
                         IBTransaction: TIBTransaction = nil;
                         Retaining: Boolean = true;
                         Commit: Boolean = true);

  function OpenQueryPar(SqlTxt: String; IBTransaction: TIBTransaction;
      Parameters, ParametersValue: array of string): TIBQuery; deprecated {$IFDEF DELPHI_2009_UP}'don`t use it!'{$ENDIF};

  //  Инфо
  procedure ucSetSQLShowMessages(NewValue: Boolean);
  procedure ucRestoreSQLShowMessages;

var
  ucSQLLastErrors: TUcLastSQL;
  //**

implementation

uses IBCustomDataSet, StrUtils;
//--- Настройки ---
var
  ucSaveSQLShowMessages: Boolean = true;
  ucSQLShowMessages: Boolean = true;

procedure ucSetSQLShowMessages(NewValue: Boolean);
begin
  ucSaveSQLShowMessages := ucSaveSQLShowMessages;
  ucSQLShowMessages := NewValue;
end;

procedure ucRestoreSQLShowMessages;
begin
  ucSQLShowMessages := ucSaveSQLShowMessages;
end;

//--- Базовые функции ---
procedure SetLastSQL(E: EIBError);
begin
  ucSQLLastErrors.Message := E.Message;
  ucSQLLastErrors.SQLCode := E.SQLCode;
end;

function CheckIBDBConnectT(IBTransaction: TIBTransaction): Boolean;
begin
  Result := (Assigned(IBTransaction))and
            (Assigned(IBTransaction.DefaultDatabase))and
            (IBTransaction.DefaultDatabase.Connected);
  if not Result then
    MessageDlg('Нет соединения с базой данных!',mtError,[mbOK],0);
end;

function CheckIBDBConnectQ(Q: TIBQuery): Boolean;
begin
  Result := Assigned(Q);
  if not Result then
    begin
      MessageDlg('Нет соединения с базой данных!',mtError,[mbOK],0);
      exit;
    end;

  Result := CheckIBDBConnectT(Q.Transaction);
end;

procedure CommitTransaction(IBTransaction: TIBTransaction; Retaining: Boolean);
begin
  if Retaining then
    IBTransaction.CommitRetaining
    else
    IBTransaction.Commit;
end;

procedure SQLException(ErrText, ErrSql: PChar;
                       IBTransaction: TIBTransaction = nil;
                       Retaining: Boolean = true;
                       Commit: Boolean = true);
begin
  if Assigned(IBTransaction) and Commit then
    if Retaining then
      IBTransaction.RollbackRetaining
      else
      IBTransaction.Rollback;

  if ucSQLShowMessages then
    if ErrSql <> nil then
      MessageDlg('Не предвиденная ошибка!'#13'Изменения не сохранены!'+CrLf+CrLf+
                 'Error_text:'+CrLf+
                 ErrText+CrLf+CrLf+
                 'SQL_Text:'+CrLf+
                 ErrSql+CrLf,
                 mtError,[mbOK],0)
      else
      MessageDlg(ErrText, mtError, [mbOK], 0);
end;

function OpenQueryPar(SqlTxt: String; IBTransaction: TIBTransaction;
    Parameters, ParametersValue: array of string): TIBQuery;
var
  i: Integer;
begin
  Result:= nil;
  if not CheckIBDBConnectT(IBTransaction) then Exit;

  Result:= TIBQuery.Create(nil);
  with Result do
    begin
      Database    := IBTransaction.DefaultDatabase;
      Transaction := IBTransaction;

      SQL.Text:= SqlTxt;
      if Length(Parameters) <> 0 then
         for i := 0 to High(Parameters) do
            ParamByName(Parameters[i]).AsString := ParametersValue[i];
      try
        if not Transaction.InTransaction then
          Transaction.StartTransaction;
        Open;
      except
        on E: Exception do
         begin
           SQLException(PChar(E.Message), PChar(SqlTxt));
           Result:= nil;
         end;
      end;
    end;
end;

function ExecQuery(SqlTxt: array of string;
                   Q: TIBQuery;
                   Retaining: Boolean = true;
                   Commit: Boolean = true;
                   CustomMessage: string = ''): Boolean; overload;
var i: integer;
begin
  Result:= CheckIBDBConnectQ(Q);
  if not Result then Exit;

  with Q do
    begin
      i := 0;
      try
        if not Transaction.InTransaction then
          Transaction.StartTransaction;
        while i <= High(SqlTxt) do
          begin
            SQL.Clear;
            SQL.Text:= SqlTxt[i];
            inc(i);
            ExecSQL;
          end;
        if Commit then
          CommitTransaction(Transaction, Retaining);
      except
        on E: EIBError do
          begin
            SetLastSQL(E);
            if CustomMessage = '' then
              SQLException(PChar(IntToStr(E.SQLCode)+': '+E.Message), PChar(SqlTxt[i - 1]), Transaction, Retaining, Commit)
              else
              SQLException(PChar(CustomMessage), nil, Transaction, Retaining, Commit);
            Result:= false;
          end;
      end;
    end;
end;

function ExecQuery(SqlList: TStringList;
                   Q: TIBQuery;
                   Retaining: Boolean = true;
                   Commit: Boolean = true;
                   CustomMessage: string = ''): Boolean; overload;
var i: integer;
begin
  Result:= CheckIBDBConnectQ(Q);
  if not Result then Exit;

  with Q do
    begin
      i := 0;
      try
        if not Transaction.InTransaction then
          Transaction.StartTransaction;
        while i < SqlList.Count do
          begin
            SQL.Clear;
            SQL.Text:= SqlList[i];
            inc(i);
            ExecSQL;
          end;
        if Commit then
          CommitTransaction(Transaction, Retaining);
      except
        on E: EIBError do
          begin
            SetLastSQL(E);
            if CustomMessage = '' then
              SQLException(PChar(E.Message), PChar(SqlList[i - 1]), Transaction, Retaining, Commit)
              else
              SQLException(PChar(CustomMessage), nil, Transaction, Retaining, Commit);
            Result:= false;
          end;
      end;
    end;
end;
//--- TSeparateConnection ---
constructor TSeparateConnection.Create(AOwner: TComponent;
                                       IBDataBase: TIBDataBase);
begin
  inherited Create(nil);
  Owner := AOwner;
  //---
  F_IBTransaction := TIBTransaction.Create(Self);
  with F_IBTransaction do
    begin
      DefaultDatabase := IBDataBase;
      Params.Add('read_committed');
      Params.Add('rec_version');
      Params.Add('nowait');
    end;
  //---
  F_IBQuery                       := TIBQuery.Create(Self);
  F_IBQuery.Database              := IBDataBase;
  F_IBQuery.Transaction           := IBTransaction;
  //---
  F_IBTransaction.StartTransaction;
end;

procedure TSeparateConnection.SetOwner(AOwner: TComponent);
begin
  if FOwner <> nil then FOwner.RemoveComponent(Self);
  FOwner := AOwner;
  if FOwner <> nil then FOwner.InsertComponent(Self);
end;

function TSeparateConnection.ExecuteQuery(SqlTxt: array of string;
                                          Retaining: Boolean = true;
                                          Commit: Boolean = true;
                                          CustomMessage: string = ''): Boolean;
begin
  Result:= ExecQuery(SqlTxt, IBQuery, Retaining, Commit, CustomMessage);
end;

function TSeparateConnection.ExecuteQuery(SqlList: TStringList;
                                          Retaining: Boolean = true;
                                          Commit: Boolean = true;
                                          CustomMessage: string = ''): Boolean;
begin
  Result:= ExecQuery(SqlList, IBQuery, Retaining, Commit, CustomMessage);
end;

function TSeparateConnection.OpenQuery(SqlTxt: string): TIBQuery;
begin
  Result:= IBQuery;

  with IBQuery do
    begin
      SQL.Text:= SqlTxt;
      try
        if not Transaction.InTransaction then
          Transaction.StartTransaction;
        Open;
      except
        on E: EIBError do
          begin
            SetLastSQL(E);
            SQLException(PChar(E.Message), PChar(SqlTxt));
            Result:= nil;
          end;
      end;
    end;
end;
//*** TSeparateConnection ***
// Выполнение запросов
function ExecuteQuery(SqlTxt: array of string;
                      IBTransaction: TIBTransaction;
                      Retaining: Boolean = true;
                      Commit: Boolean = true): Boolean;
var Q: TIBQuery;
begin
  Q := TIBQuery.Create(nil);
  with Q do
    try
      Database    := IBTransaction.DefaultDatabase;
      Transaction := IBTransaction;

      Result:= ExecQuery(SqlTxt, Q, Retaining, Commit);
    finally
      Free;
    end;
end;

function ExecuteQuery(SqlList: TStringList;
                      IBTransaction: TIBTransaction;
                      Retaining: Boolean = true;
                      Commit: Boolean = true): Boolean; overload;
var Q: TIBQuery;
begin
  Q := TIBQuery.Create(nil);
  with Q do
    try
      Database    := IBTransaction.DefaultDatabase;
      Transaction := IBTransaction;

      Result:= ExecQuery(SqlList, Q, Retaining, Commit);
    finally
      Free;
    end;
end;

type
  TCrIBQuery = class (TIBQuery);

//Открытие запроса (не забываем потом прибить возвращенный объект!)
function OpenQuery(SqlTxt: string;
                   IBTransaction: TIBTransaction): TIBQuery;
begin
  Result:= nil;
  if not CheckIBDBConnectT(IBTransaction) then Exit;

  Result:= TIBQuery.Create(nil);
  with Result do
    begin
      Database    := IBTransaction.DefaultDatabase;
      Transaction := IBTransaction;
      ParamCheck  := false;

      SQL.Text:= SqlTxt;
      try
        if not Transaction.InTransaction then
          Transaction.StartTransaction;
        Open;
      except
        on E: EIBError do
          begin
            SetLastSQL(E);
            SQLException(PChar(E.Message), PChar(SqlTxt), Transaction);
            try
              FreeAndNil(Result);
            except
            end;
          end;
      end;
    end;
end;

function CheckingLocking(TableName, ID_Value: string;
                         Tr: TIBTransaction;
                         ShowDialog: Boolean = true): Boolean;
begin
  Result := CheckingLocking(
            'select id from ' + TableName +
            ' where id = ' + ID_Value + ' with lock',
            Tr, ShowDialog);
end;


function CheckingLocking(SQLText: string;
                         Tr: TIBTransaction;
                         ShowDialog: Boolean = true): Boolean;
var Q: TIBQuery;
begin
  Q := TIBQuery.Create(nil);
  with Q do
  try
    Database    := Tr.DefaultDatabase;
    Transaction := Tr;
    SQL.Text:= SQLText;
    try
      if not Transaction.InTransaction then
        Transaction.StartTransaction;
      Open;
      Result := false;
    except
      on E: EIBError do
        begin
          Transaction.Rollback;
          Result:= true;
          SetLastSQL(E);
          if ShowDialog then
            MessageDlg( IntToStr(E.SQLCode)+': Запись заблокирована!', mtWarning, [mbOK], 0);
        end;
    end;
  finally
    Free;
  end;
end;


// Обновление запросов
procedure UpdateQuery(Q: TIBQuery; SaveBookmark: Boolean = true;
                      RestartTransaction: Boolean = false;
                      SaveActivTransaction: Boolean = false);
var Rsave: integer;
begin
  {if Q.Active or RestartTransaction then }with Q do
    try
      Rsave := 0;
      if SaveBookmark and (RecordCount>0) and Active then Rsave:= RecNo;
      Close;
      if RestartTransaction and Transaction.InTransaction then
        begin
          if SaveActivTransaction then
              Transaction.CommitRetaining
            else begin
              Transaction.Commit;
              Transaction.StartTransaction;
            end;
        end;
      Open;   Last;
      if SaveBookmark and (RecordCount>0) then RecNo:= Rsave;
    except
      MessageDlg('Запрос компонента "'+Name+'" не может быть обновлен!',mtError,[mbOK],0);
    end;
end;
//Преобразование строки даты к SQL или null
function StrDateTimeSQL(V: string): string;
begin
  if length(V)>=10 then
    Result:= V[4]+V[5]+'/'+V[1]+V[2]+'/'+V[7]+V[8]+V[9]+V[10]+Copy(V,11,Length(V))
    else Result:= 'null';
end;

function GetSQLParamList(Q: TIBQuery): string;

  function DataTypeToStr(DataType: TFieldType): string;
  begin
    case DataType of
      ftUnknown					: Result := 'Unknown';
      ftString					: Result := 'String';
      ftSmallint				: Result := 'Smallint';
      ftInteger					: Result := 'Integer';
      ftWord					  : Result := 'Word';
      ftBoolean					: Result := 'Boolean';
      ftFloat					  : Result := 'Float';
      ftCurrency				: Result := 'Currency';
      ftBCD					    : Result := 'BCD';
      ftDate					  : Result := 'Date';
      ftTime					  : Result := 'Time';
      ftDateTime				: Result := 'DateTime';
      ftBytes					  : Result := 'Bytes';
      ftVarBytes				: Result := 'VarBytes';
      ftAutoInc					: Result := 'AutoInc';
      ftBlob					  : Result := 'Blob';
      ftMemo					  : Result := 'Memo';
      ftGraphic					: Result := 'Graphic';
      ftFmtMemo					: Result := 'FmtMemo';
      ftParadoxOle			: Result := 'ParadoxOle';
      ftDBaseOle				: Result := 'DBaseOle';
      ftTypedBinary			: Result := 'TypedBinary';
      ftCursor					: Result := 'Cursor';
      ftFixedChar				: Result := 'FixedChar';
      ftWideString			: Result := 'WideString';
      ftLargeint				: Result := 'Largeint';
      ftADT					    : Result := 'ADT';
      ftArray					  : Result := 'Array';
      ftReference				: Result := 'Reference';
      ftDataSet					: Result := 'DataSet';
      ftOraBlob					: Result := 'OraBlob';
      ftOraClob					: Result := 'OraClob';
      ftVariant					: Result := 'Variant';
      ftInterface				: Result := 'Interface';
      ftIDispatch				: Result := 'IDispatch';
      ftGuid					  : Result := 'Guid';
      ftTimeStamp				: Result := 'TimeStamp';
      ftFMTBcd					: Result := 'FMTBcd';

{$IFDEF DELPHI_2009_UP}
      ftFixedWideChar		: Result := 'FixedWideChar';
      ftWideMemo				: Result := 'WideMemo';
      ftOraTimeStamp		: Result := 'OraTimeStamp';
      ftOraInterval			: Result := 'OraInterval';
      ftLongWord				: Result := 'LongWord';
      ftShortint				: Result := 'Shortint';
      ftByte					  : Result := 'Byte';
      ftExtended				: Result := 'Extended';
      ftConnection			: Result := 'Connection';
      ftParams					: Result := 'Params';
      ftStream					: Result := 'Stream';
      ftTimeStampOffset	: Result := 'TimeStampOffset';
      ftObject					: Result := 'Object';
      ftSingle          : Result := 'Single';
{$ENDIF}
    end;
  end;

var i: Integer;
begin
  Result := '';
  for i := 0 to Q.ParamCount - 1 do
    Result := Result +
              ':' + Q.Params[i].Name + ' (' + DataTypeToStr(Q.Params[i].DataType) + ') =' +
              Q.Params[i].AsString + CrLf;

  if Q.ParamCount > 0 then
    Delete(Result, Length(Result) - Length(CrLf) + 1, Length(CrLf));
end;

// Помещаем TDateTime в Values (array of const)
// Представлен как Variant
function SqlInsert(TableName: string; ColNames: array of string; Values: array of Variant): string;
var RetVar, ErrMsg: string;
    i: integer;
begin
  RetVar:='insert into '+TableName+CrLf+'('+ColNames[0];
  for i:=1 to High(ColNames) do RetVar:=RetVar+','+ColNames[i];
  RetVar:=RetVar+')'+CrLf;
  RetVar:=RetVar+'values '+CrLf+'(';

  ErrMsg:= '';
  for i:=0 to High(Values) do
    RetVar := RetVar + UC_VarToSQLStr(Values[i]) + ',';
  Delete(RetVar,length(RetVar),1);
  RetVar := RetVar + ')';
  if High(Values) < High(ColNames) then ShowMessage('SQL Insert - Не достаточно значений.');
  if High(Values) > High(ColNames) then ShowMessage('SQL Insert - Слишком много значений.');
  if ErrMsg <> '' then ShowMessage(ErrMsg);

  Result := RetVar;
end;

function SqlUpdate(TableName: string; ColNames: array of string; Values: array of Variant; WhereClause: string): string;
var
  RetVar : string;
  i : integer;
begin
  RetVar := 'update ' + TableName + ' set' + CrLf;

  for i:=0 to High(Values) do
    RetVar := RetVar + ColNames[i] + '=' + UC_VarToSQLStr(Values[i]) + ',';
  Delete(RetVar,length(RetVar),1);
  RetVar := RetVar + CrLf + 'where ' + WhereClause;
  if High(Values) < High(ColNames) then
    ShowMessage('SQL Update - Not enough values.');
  if High(Values) > High(ColNames) then
    ShowMessage('SQL Update - Too many values.');

  Result := RetVar;
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
//WMWMWMWMWMWMWMWMWMWMWMWMWMW Для баз под Paradox WMWMWMWMWMWMWMWMWMWMWMWMWMMWMW
//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
procedure UpdateQuery(Q: TQuery; SaveBookmark: Boolean = true);
var Rsave: integer;
begin
  if Q.Active then with Q do
    try
      Rsave := 0;
      if SaveBookmark and (Q.RecordCount>0) then Rsave:= RecNo;
      Close;
      Open;
      if SaveBookmark and (Q.RecordCount>0) then RecNo:= Rsave;
    except
      MessageDlg('Запрос компонента "'+Name+'" не может быть обновлен!',mtError,[mbOK],0);
    end;
end;

function GenerateKod(Const FieldName, TablName: string;
                     Inc: integer = 1): integer;
begin
  With TQuery.Create(nil) do
    begin
      DatabaseName:= 'DbVOPBn6';
      SQL.Clear;
      SQL.Add('select Max(cast('+FieldName+' as integer)) as '+FieldName+' from '+TablName);
      Open;
      Result:=FieldByName(FieldName).AsInteger+Inc;
      Close;
      Free;
    end;
end;

function GenerateKod_IB(DBase: TIBDataBase;
                        Trzact: TIBTransaction;
                        Const FieldName, TablName: string;
                        Inc: integer = 1): integer;
begin
  with TIBQuery.Create(nil) do
    begin;
      Database:= DBase;
      Transaction := Trzact;
      SQL.Clear;
      SQL.Add('select Max(cast('+FieldName+' as integer)) as '+FieldName+' from '+TablName);
      Open;
      Result:=FieldByName(FieldName).AsInteger+Inc;
      Close;
      Free;
    end;
end;

function ExecuteQuery(SqlTxt: array of string; DBase: TDataBase): Boolean;
var i: integer;
begin
  Result:= true;
  if not DBase.Connected then
    begin
      Result:= false;
      Exit;
    end;
  with TQuery.Create(nil) do
    begin
      DatabaseName:= DBase.DatabaseName;
      i := 0;
      try
        DBase.StartTransaction;
        while i <= High(SqlTxt) do
          begin
            SQL.Clear;
            SQL.Text:= SqlTxt[i];
            ExecSQL;
            inc(i);
          end;
        DBase.Commit;
      except
        on E: Exception do
         begin
           DBase.Rollback;
           MessageDlg('Не предвиденная ошибка!'#13'Изменения не сохранены!'#13#13+
                   'Error_text:'#13+
                   E.Message+#13#13+
                   'SQL_Text:'#13+
                   SqlTxt[i]+#13,
                   mtError,[mbOK],0);
           Result:= false;
         end;
      end;
      Free;
    end;
end;
//wmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwm
//wmwmwmwmwmwmwmwmwmwmwmwmwmw Для баз под Paradox wmwmwmwmwmwmwmwmwmwmwmwmwmMwmW
//wmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwmwm

end.
