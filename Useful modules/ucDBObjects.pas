// Версия - 29.09.2011
unit ucDBObjects;
{$include ..\delphi_ver.inc}

interface

uses ucDBWorker, IBDatabase, ucClasses, SysUtils;

type
  TDBObject = class;
  TDBObjectClass = class of TDBObject;

  TDBObject = class (TUcNotifyObject)
  protected
    fDBW: TUcDBWorker;
    fTransaction: TIBTransaction;
    function DoBeforeExecute(iOBject: TObject): Boolean; virtual;
    function DoExecute(iOBject: TObject): Boolean; virtual;
    function DoAfterExecute(iOBject: TObject): Boolean; virtual;
    function CheckIDObject(Obj: Tobject; ObjClass: TClass): Boolean; virtual;
  public
    constructor Create(iTransaction: TIBTransaction = nil); reintroduce;
    function Execute(iOBject: TObject): Boolean;
  end;

//---
procedure RegDBWorker(DBWorker: TUcDBWorker);
function  GetDBWorker: TUcDBWorker;

implementation

var
  DBWorker_: TUcDBWorker = nil;

procedure RegDBWorker(DBWorker: TUcDBWorker);
begin
  DBWorker_ := DBWorker;
end;

function  GetDBWorker: TUcDBWorker;
begin
  Result := DBWorker_;
end;

{ TDBObject }
constructor TDBObject.Create(iTransaction: TIBTransaction = nil);
begin
  inherited Create;
  fDBW := GetDBWorker;
  fTransaction := iTransaction;
end;

function TDBObject.DoBeforeExecute(iOBject: TObject): Boolean;
begin
  Result := True;
end;

function TDBObject.DoExecute(iOBject: TObject): Boolean;
begin
  Result := False;
end;

function TDBObject.DoAfterExecute(iOBject: TObject): Boolean;
begin
  Result := True;
end;

function TDBObject.CheckIDObject(Obj: Tobject; ObjClass: TClass): Boolean;
begin
  Result := Obj.ClassType = ObjClass;
end;

function TDBObject.Execute(iOBject: TObject): Boolean;
begin
  Result := fDBW.TestConnected(True) and DoBeforeExecute(iOBject);
  if Result then
  begin
    Result := DoExecute(iOBject);
    if Result then
      Result := DoAfterExecute(iOBject);
  end;
end;
{ ** }


end.
