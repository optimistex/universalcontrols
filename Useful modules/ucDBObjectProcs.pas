// Версия - 30.06.2011
unit ucDBObjectProcs;
{$include ..\delphi_ver.inc}

interface

uses IBDatabase, ucDBObjects, ucClasses;

// Регистрация обработчиков для объектов БД
procedure RegObjProc(iObjClass, DBRead, DBWrite, DBDelete, DBGenID: TClass);
// Операции с обьектами БД
function ReadObj(iObj: TObject; iTransaction: TIBTransaction = nil): Boolean;
function WriteObj(iObj: TObject; iTransaction: TIBTransaction = nil): Boolean;
function DeleteObj(iObj: TObject; iTransaction: TIBTransaction = nil): Boolean;
function GenIdObj(iObj: TObject; iTransaction: TIBTransaction = nil): Boolean;
//**

implementation

var Procs_: TDBFields = nil;

function Procs: TDBFields;
begin
  if not Assigned(Procs_) then
    Procs_ := TDBFields.Create;
  Result := Procs_;
end;

procedure ProcsFree;
var i: Integer;
begin
  if Assigned(Procs_) then
  begin
    for i := 0 to Procs_.Count - 1 do
      Procs_.Fields[i].AsObject.Free;
    Procs_.Free;
  end;
end;
//----

procedure RegObjProc(iObjClass, DBRead, DBWrite, DBDelete, DBGenID: TClass);
var field: TDBField;
begin
  field := Procs.FieldByName(iObjClass.ClassName);
  if not Assigned(field.AsObject) then
    field.AsObject := TDBFields.Create;

  TDBFields(field.AsObject).FieldByName('read').AsClass   := DBRead;
  TDBFields(field.AsObject).FieldByName('write').AsClass  := DBWrite;
  TDBFields(field.AsObject).FieldByName('delete').AsClass := DBDelete;
  TDBFields(field.AsObject).FieldByName('genid').AsClass  := DBGenID;
end;

function GetObjProc(iObj: TObject; Operation: string): TDBObjectClass;
var fs: TDBFields;
begin
  if not Assigned(iObj) then
    Result := nil
    else begin
      fs := TDBFields(Procs.FieldByName(iObj.ClassName).AsObject);
      if Assigned(fs) then
        Result := TDBObjectClass(fs.FieldByName(Operation).AsObject)
        else
        Result := nil;
    end;
end;

function ObjProcess(iObj: TObject; Operation: string;
                    iTransaction: TIBTransaction = nil): Boolean;
var DBObjClass: TDBObjectClass;
    DBObj: TDBObject;
begin
  Result := False;
  DBObjClass := GetObjProc(iObj, Operation);
  if Assigned(DBObjClass) then
  begin
    DBObj := DBObjClass.Create(iTransaction);
    try
      Result := DBObj.Execute(iObj);
    finally
      DBObj.Free;
    end;
  end;
end;

function ReadObj(iObj: TObject; iTransaction: TIBTransaction = nil): Boolean;
begin
  Result := ObjProcess(iObj, 'read', iTransaction);
end;

function WriteObj(iObj: TObject; iTransaction: TIBTransaction = nil): Boolean;
begin
  Result := ObjProcess(iObj, 'write', iTransaction);
end;

function DeleteObj(iObj: TObject; iTransaction: TIBTransaction = nil): Boolean;
begin
  Result := ObjProcess(iObj, 'delete', iTransaction);
end;

function GenIdObj(iObj: TObject; iTransaction: TIBTransaction = nil): Boolean;
begin
  Result := ObjProcess(iObj, 'genid', iTransaction);
end;

initialization

finalization
  ProcsFree;

end.
