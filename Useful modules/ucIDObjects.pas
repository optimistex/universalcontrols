// Версия - 27.09.2012
unit ucIDObjects;
{$include ..\delphi_ver.inc}

{$ASSERTIONS ON}
{*$ASSERTIONS OFF}

interface

uses Classes, Contnrs, SysUtils,
{$IFDEF DELPHI_2009_UP}
     ucDialogs,
{$ELSE}
     Dialogs,
{$ENDIF}
     ucZibProcs, ucClasses, ucTypes;

type
  TIDObject = class;
  TIDObjectList = class;
  TIDObjectClass = class of TIDObject;
  TIDObjectListClass = class of TObjectList;

  TIDObjectProc = procedure(obj: TIDObject) of object;

  TIDObjectIndexID = class
  private
    fData: array of TObject;
    fCapacity: Integer;
    procedure Grow(iCapacity: Integer); // Увеличение индекса
    function  GetIndexData(Index: integer): TObject;
    procedure SetIndexData(Index: integer; Data: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    property IndexData[Index: integer]: TObject read GetIndexData write SetIndexData; default;
  end;

  TIDObjectBase = class (TUcNotifyObject)
  protected
    fLoadMode: TIDObjectLoadMode;
    procedure Init; virtual;
  public
    constructor Create; override;
  end;

  TIDObject = class (TIDObjectBase)
  private
    fID: Integer;
    fFields: TDBFields;
    function GetField(Name: string): TDBField;
    function GetIDstr: String;
  protected
    fReadyToWork: Boolean;
    procedure FieldsChanged(Sender: TObject); virtual;
    procedure SetID(Value: Integer); virtual;
    procedure DoPrepareToSave; virtual;
    procedure DoPrepareToWork; virtual;

    procedure InitStreamFields(fNames: array of string);
    procedure PrepareStreamFields(fNames: array of string; Compress: boolean);
  public
    constructor Create(iID: Integer = 0); reintroduce;
    destructor  Destroy; override;
    procedure SetChanged(Value: Boolean);
    procedure PrepareToSave;
    procedure PrepareToWork;

    procedure Debug;

    property ID: Integer read fID write SetID;
    property IDstr: string read GetIDstr;
    property Fields[Name: string]: TDBField read GetField; default;
    property FieldList: TDBFields read fFields;
    property ReadyToWork: Boolean read fReadyToWork write fReadyToWork;
  end;

  TIDObjectListStates = (olsNormal, olsAddItem, olsRemoveItem,
                         olsChangeItem, olsExtractItem, olsChangeIDParent,
                         olsBeginProgress, olsDoProgress, olsEndProgress);

  TIDObjectList = class (TIDObjectBase)
  private
    fObjList: TObjectList;
    fDeletedObjList: TStringList;
    fNotifyState: TIDObjectListStates;
    fNotifyItem: TIDObject;

    // Позволяет уничтожение объектов при удалении из списка или при уничтожении списка
    fOwnsObjects: Boolean;
    function GetCount: Integer;
  protected
    fMax: integer;
    fPosition: integer;
    fStateTxt: string;
    fState: TWorkState;
    fAction: TWorkAction;
    fTag: Integer;

    fIDParent: Integer;
    procedure SetIDParent(Value: Integer);
    function GetIDParentStr: String;

    procedure DoChanged(Item: TIDObject; State: TIDObjectListStates); virtual;

    function GetItem(Index: Integer): TIDObject;
    procedure SetItem(Index: Integer; AObject: TIDObject);
    procedure DoItemChanged(Sender: TObject);

    function DoCompare(Item1, Item2: TIDObject): Integer; virtual;

    property ObjList: TObjectList read fObjList;
    // Оповещения о прогрессе выполнения чего-то
    procedure Notifycation(iState: TWorkState);
    procedure NotifyText(Txt: String);
    procedure NotifyProgress(iMax, iPos: Integer);
    procedure NotifyAction(iState: TWorkState; Action: TWorkAction);
  public
    constructor Create(iIDParent: Integer = 0); reintroduce; virtual;
    destructor  Destroy; override;
    procedure SetChanged(Value: Boolean);

    function Add(AObject: TIDObject): Integer; virtual;

                // Обработка списка данными из внешних списков
    procedure AddList(SrcList: TIDObjectList);
    procedure IncludeFromList(SrcList: TIDObjectList; KeyField: string);      // Добавить несуществующие из списка
    procedure MirrorList(SrcList: TIDObjectList; KeyField: string);           // Отразить указанный список
    procedure ExcludeList(SrcList: TIDObjectList; KeyField: string);          // Удалить существующие в указанном списке
    procedure ExcludeInvertedList(SrcList: TIDObjectList; KeyField: string);  // Удалить несуществующие в указанном списке
    procedure ProcessList(ItemProc: TIDObjectProc; FromBeginToEnd: Boolean = False);

    function Extract(Item: TIDObject): TIDObject;
    function Remove(AObject: TIDObject): Integer;
    function IndexOf(AObject: TIDObject): Integer;
    function FindByField(FieldName: string; FieldValue: Variant): TIDObject;
    procedure FindListByField(FieldName: string; FieldValue: Variant; TargetList: TIDObjectList);  // Выделение списка с указанным значением поля
    function GetByField(FieldName: string; FieldValue: Variant): TIDObject; deprecated {$IFDEF DELPHI_2009_UP}'use FindByField(FieldName, FieldValue)'{$ENDIF};
    function CountByField(FieldName: string; FieldValue: Variant): integer;
    procedure Insert(Index: Integer; AObject: TIDObject);
    function First: TIDObject;
    function Last: TIDObject;
    procedure Sort;
    procedure Clear;
    procedure Reinit;
    function NotifyItem: TIDObject;
    procedure Debug;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TIDObject read GetItem write SetItem; default;

    property IDParent: Integer read fIDParent write SetIDParent;
    property IDParentStr: String read GetIDParentStr;
    property NotifyState: TIDObjectListStates read fNotifyState;
    property DeletedObjList: TStringList read fDeletedObjList;
    property OwnsObjects: Boolean read fOwnsObjects write fOwnsObjects;

    property StatePublic: TWorkState  read fState;
    property Max: integer             read fMax;
    property Position: integer        read fPosition;
    property StateTxt: string         read fStateTxt;
    property Action: TWorkAction      read fAction;
    property Tag: Integer             read fTag;
  end;

  TIDObjectListIndexed = class(TIDObjectList)
  private
    fIndex: TIDObjectIndexID;

    // Поля для работы с древовидной структурой
    fIDFieldName: string;
    fIDParentFieldName: string;
    fOrderFieldName: string;
    //**
    function GetIndex(ID: Integer): TIDObject;
    function AddIdxObj(AObject: TIDObject): Integer;
  protected
    procedure Init; override;
    procedure DoChanged(Item: TIDObject; State: TIDObjectListStates); override;
  public
    destructor  Destroy; override;

    function AddEx(AObject: TIDObject; SkipDuplicate: Boolean = False): Integer;
    function Add(AObject: TIDObject): Integer; override;
    procedure Reindex;

    property Index[ID: Integer]: TIDObject read GetIndex;

    property IDFieldName: string  read fIDFieldName write fIDFieldName;
    property IDParentFieldName: string  read fIDParentFieldName write fIDParentFieldName;
    property OrderFieldName: string  read fOrderFieldName write fOrderFieldName;
  end;


implementation

{ TIDObjectIndexID }
constructor TIDObjectIndexID.Create;
begin
  inherited;
  fCapacity := 0;
end;

destructor  TIDObjectIndexID.Destroy;
begin
  SetLength(fData, 0);
  inherited;
end;

procedure TIDObjectIndexID.Grow(iCapacity: Integer); // Увеличение индекса
var
  Delta, StartIndex, i: Integer;
begin
  if iCapacity >= fCapacity then
  begin
    // Рассчет новой емкости индекса
    if iCapacity > 64 then Delta := iCapacity div 4 else
      if iCapacity > 8 then Delta := 16 else
        Delta := 4;
    fCapacity := iCapacity + Delta;

    // Установка емкости
    StartIndex := High(fData) + 1;
    SetLength(fData, fCapacity);

    // Обнуляем указатели
    for i := StartIndex to High(fData) do
      fData[i] := nil;
  end;
end;

function  TIDObjectIndexID.GetIndexData(Index: integer): TObject;
begin
  if (Index >= 0)and(Index <= High(fData)) then
    Result := fData[Index]
    else
    Result := nil;
end;

procedure TIDObjectIndexID.SetIndexData(Index: integer; Data: TObject);
begin
  if Index >= fCapacity then Grow(Index);
  fData[Index] := Data;
end;

procedure TIDObjectIndexID.Clear;
var i: Integer;
begin
  for i := 0 to High(fData) do
    fData[i] := nil;
end;

{ TIDObjectBase }
constructor TIDObjectBase.Create;
begin
  inherited;
  fLoadMode := iolmFull;
end;

procedure TIDObjectBase.Init;
begin

end;

{ TIDObject }
constructor TIDObject.Create(iID: Integer = 0);
begin
  inherited Create;
  fFields := TDBFields.Create;
  fFields.RegisterNotify(FieldsChanged);
  fID           := iID;
  fReadyToWork  := False;
  Init;
end;

destructor  TIDObject.Destroy;
begin
  inherited;
  fFields.Free;
end;

procedure TIDObject.SetChanged(Value: Boolean);
begin
  IsChanged := Value;
  FieldList.SetFieldsChanged(Value);
end;

procedure TIDObject.PrepareToSave;
begin
  if fReadyToWork then
  begin
    DoPrepareToSave;
    fReadyToWork := False;
  end;
end;

procedure TIDObject.PrepareToWork;
begin
  if not fReadyToWork then
  begin
    DoPrepareToWork;
    fReadyToWork := True;
  end;
end;

procedure TIDObject.Debug;
begin
  ShowMessage(
              'Debug: ' + ClassName + #13#10 +
              'ID=' + IDstr + #13#10#13#10 +

              FieldList.Debug
              );
end;

function  TIDObject.GetField(Name: string): TDBField;
begin
  Result := fFields.FieldByName(Name);
end;

function TIDObject.GetIDstr: String;
begin
  Result := IntToStr(ID);
end;

procedure TIDObject.FieldsChanged(Sender: TObject);
begin
  Change;
end;

procedure TIDObject.SetID(Value: Integer);
begin
  if fID <> Value then
  begin
    fID := Value;
    Change;
  end;
end;

procedure TIDObject.DoPrepareToSave;
begin

end;

procedure TIDObject.DoPrepareToWork;
begin

end;

procedure TIDObject.InitStreamFields(fNames: array of string);
var
  i: Integer;
begin
  for i := Low(fNames) to High(fNames) do
    Fields[fNames[i]].InitStream;
end;

procedure TIDObject.PrepareStreamFields(fNames: array of string;
                                        Compress: boolean);
var
  i: Integer;
begin
  for i := Low(fNames) to High(fNames) do
    UC_ZIP(Fields[fNames[i]].AsStream, Compress);
end;

{ TIDObjectList }
constructor TIDObjectList.Create(iIDParent: Integer = 0);
begin
  inherited Create;
  fDeletedObjList := TStringList.Create;
  fObjList        := TObjectList.Create;
  fObjList.OwnsObjects := False; // !!!
  fOwnsObjects    := True;
  fIDParent       := iIDParent;
  Init;
end;

procedure TIDObjectList.Debug;
var i: Integer;
    s: string;
begin
  s := '';
  for i := 0 to Count - 1 do
    s := s + #13#10'------------------------'#13#10 + Items[i].FieldList.Debug;
  ShowMessage(s);
end;

procedure TIDObjectList.ExcludeList(SrcList: TIDObjectList;
  KeyField: string);
var i: Integer;
begin
  for i := Count - 1 downto 0 do
    if Assigned(SrcList.FindByField(KeyField, Items[i][KeyField].AsVariant)) then
      Remove(Items[i]);
end;

procedure TIDObjectList.ExcludeInvertedList(SrcList: TIDObjectList;
  KeyField: string);
var i: Integer;
begin
  for i := Count - 1 downto 0 do
    if not Assigned(SrcList.FindByField(KeyField, Items[i][KeyField].AsVariant)) then
      Remove(Items[i]);
end;

destructor  TIDObjectList.Destroy;
begin
  Clear;
  fObjList.Free;
  fDeletedObjList.Free;
  inherited;
end;

procedure TIDObjectList.SetChanged(Value: Boolean);
var i: Integer;
begin
  IsChanged := Value;
  for i := 0 to Count - 1 do
    Items[i].SetChanged(Value);
end;

procedure TIDObjectList.DoChanged(Item: TIDObject; State: TIDObjectListStates);
begin
  fNotifyState := State;
  fNotifyItem  := Item;
  if fNotifyState in [olsAddItem, olsRemoveItem,
                      olsChangeItem, olsExtractItem, olsChangeIDParent] then
    Change
    else
    Notify;
  fNotifyState := olsNormal;
end;

function TIDObjectList.FindByField(FieldName: string; FieldValue: Variant): TIDObject;
var i: Integer;
begin
  for i := 0 to Count - 1 do
    if (not Items[i][FieldName].IsBlob) and
       (Items[i][FieldName].AsVariant = FieldValue) then
    begin
      Result := Items[i];
      Exit;
    end;
  Result := nil;
end;

function TIDObjectList.GetByField(FieldName: string;
  FieldValue: Variant): TIDObject;
begin
  Result := FindByField(FieldName, FieldValue);
end;

function TIDObjectList.GetCount: Integer;
begin
  Result := fObjList.Count;
end;

procedure TIDObjectList.SetIDParent(Value: Integer);
begin
  if fIDParent <> Value then
  begin
    fIDParent := Value;
    DoChanged(nil, olsChangeIDParent);
  end;
end;

function TIDObjectList.GetIDParentStr: String;
begin
  Result := IntToStr(fIDParent);
end;

function TIDObjectList.GetItem(Index: Integer): TIDObject;
begin
  Result := (fObjList[Index] as TIDObject);
end;

procedure TIDObjectList.FindListByField(FieldName: string;
  FieldValue: Variant; TargetList: TIDObjectList);
var i: Integer;
begin
  if not Assigned(TargetList) then Exit;

  for i := 0 to Count - 1 do
    if (not Items[i][FieldName].IsBlob) and (Items[i][FieldName].AsVariant = FieldValue) then
      TargetList.Add(Items[i]);
end;

procedure TIDObjectList.SetItem(Index: Integer; AObject: TIDObject);
begin
  fObjList[Index] := AObject;
end;

procedure TIDObjectList.DoItemChanged(Sender: TObject);
var Obj: TIDObject;
begin
  Obj := TIDObject(Sender);
  case Obj.State of
    nosNormal:    DoChanged(Obj, olsChangeItem);
    nosDestroing: begin
      if Obj.ID > 0 then
        fDeletedObjList.Add(Obj.IDstr);
//      fObjList.OwnsObjects := False;
//      fObjList.Remove(Obj);
//      fObjList.OwnsObjects := True;

      fObjList.Extract(Obj);

      DoChanged(Obj, olsRemoveItem);
    end;
  end;
end;

function TIDObjectList.Add(AObject: TIDObject): Integer;
begin
  Result := fObjList.Add(AObject);
  AObject.RegisterNotify(DoItemChanged);
  DoChanged(AObject, olsAddItem);
end;

function TIDObjectList.Extract(Item: TIDObject): TIDObject;
begin
  Result := (fObjList.Extract(Item) as TIDObject);
  Item.UnregisterNotify(DoItemChanged);
  DoChanged(Item, olsExtractItem);
end;

function TIDObjectList.Remove(AObject: TIDObject): Integer;
begin
  Result := fObjList.Remove(AObject);
  if fOwnsObjects then
    AObject.Free;
end;

function TIDObjectList.IndexOf(AObject: TIDObject): Integer;
begin
  Result := fObjList.IndexOf(AObject);
end;

procedure TIDObjectList.Insert(Index: Integer; AObject: TIDObject);
begin
  fObjList.Insert(Index, AObject);
  AObject.RegisterNotify(DoItemChanged);
  DoChanged(AObject, olsAddItem);
end;

function TIDObjectList.First: TIDObject;
begin
  Result := (fObjList.First as TIDObject);
end;

function TIDObjectList.Last: TIDObject;
begin
  Result := (fObjList.Last as TIDObject);
end;

// Обработчик сортировки
var
  SortObj: TIDObjectList;
  CanSort: Boolean = True;

function Compare(Item1, Item2: Pointer): Integer;
begin
  Result := SortObj.DoCompare(Item1, Item2);
end;
//**

procedure TIDObjectList.Sort;
begin
  if CanSort then
  begin
    SortObj := Self;
    CanSort := False;
    try
      ObjList.Sort(@Compare);
    finally
      CanSort := True;
      SortObj := nil;
    end;
  end;
end;

procedure TIDObjectList.IncludeFromList(SrcList: TIDObjectList; KeyField: string);
var i: Integer;
begin
  for i := SrcList.Count - 1 downto 0 do
    if not Assigned(FindByField(KeyField, SrcList[i][KeyField].AsVariant)) then
      Add(SrcList.Extract(SrcList[i]));
end;

procedure TIDObjectList.MirrorList(SrcList: TIDObjectList;
  KeyField: string);
begin
  ExcludeInvertedList(SrcList, KeyField);
  IncludeFromList(SrcList, KeyField);
end;

function TIDObjectList.DoCompare(Item1, Item2: TIDObject): Integer;
begin
  Result := 0;
end;

procedure TIDObjectList.AddList(SrcList: TIDObjectList);
begin
  while SrcList.Count > 0 do
    Add(SrcList.Extract(SrcList[0]));
end;

procedure TIDObjectList.Clear;
begin
  if fOwnsObjects then
    while Count > 0 do Items[0].Free
    else
    while Count > 0 do Extract(Items[0]);
//  fObjList.Clear;
end;

function TIDObjectList.CountByField(FieldName: string;
  FieldValue: Variant): integer;
var i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    if (not Items[i][FieldName].IsBlob) and
       (Items[i][FieldName].AsVariant = FieldValue) then
       Inc(Result);
end;

procedure TIDObjectList.Reinit;
begin
  Clear;
  fDeletedObjList.Clear;
end;

procedure TIDObjectList.NotifyAction(iState: TWorkState; Action: TWorkAction);
begin
  fAction := Action;
  Notifycation(iState);
end;

procedure TIDObjectList.Notifycation(iState: TWorkState);
begin
  fState := iState;
  Notify;
end;

function TIDObjectList.NotifyItem: TIDObject;
begin
  if fNotifyState in [olsAddItem, olsRemoveItem,
                      olsExtractItem, olsChangeItem] then
    Result := fNotifyItem
    else
    Result := nil;
end;

procedure TIDObjectList.NotifyProgress(iMax, iPos: Integer);
begin
  fMax := iMax;
  fPosition := iPos;
  Notifycation(wsProgress);
end;

procedure TIDObjectList.NotifyText(Txt: String);
begin
  fStateTxt := Txt;
  if Txt <> '' then
    Notifycation(wsText);
end;

procedure TIDObjectList.ProcessList(ItemProc: TIDObjectProc; FromBeginToEnd: Boolean = False);
var i: Integer;
begin
  if (not Assigned(ItemProc)) or (Count = 0) then Exit;

  if FromBeginToEnd then
    begin
      for i := 0 to Count - 1 do
        ItemProc(Items[i]);
    end
  else
    begin
      for i := Count - 1 downto 0 do
        ItemProc(Items[i]);
    end;
end;

{ TIDObjectListIndexed }
destructor  TIDObjectListIndexed.Destroy;
begin
  inherited;
  fIndex.Free;
end;

function TIDObjectListIndexed.GetIndex(ID: Integer): TIDObject;
begin
  Result := TIDObject(fIndex.IndexData[ID]);
end;

procedure TIDObjectListIndexed.Init;
begin
  fIndex := TIDObjectIndexID.Create;
  //--
  fIDFieldName        := 'id';
  fIDParentFieldName  := 'id_parent';
  fOrderFieldName     := 'f_order';
end;

procedure TIDObjectListIndexed.DoChanged(Item: TIDObject; State: TIDObjectListStates);
var DBField: TDBField;
    i, id, OldCount: Integer;
begin
  case State of
    olsAddItem: begin // Добавляем индекс при добавлении элемента
      DBField := Item.FieldList.FindField(fIDFieldName);
      if Assigned(DBField) then
      begin
        Assert(fIndex[DBField.AsInteger] = nil, 'Dublicate ID'#13#10);
        fIndex[DBField.AsInteger] := Item;
      end;
    end;
    olsRemoveItem, olsExtractItem: begin   // удаляем индекс при удалении элемента
      DBField := Item.FieldList.FindField(fIDFieldName);
      if Assigned(DBField) then
      begin
        // удаление дочерних объектов
        id := DBField.AsInteger;

        if fOwnsObjects then
        begin
          i := 0;
          while i < Count do
            if Items[i].Fields[fIDParentFieldName].AsInteger = id then
            begin
              OldCount :=Count;
              Items[i].Free;
              if OldCount - Count > 1 then i := 0; // страхуемся !!!
            end else
              Inc(i);
        end;
        //**
        fIndex[id] := nil;
      end;
    end;
    olsChangeItem:   // Обновляем индекс если изменился ID
      if Assigned(Item.FieldList.ChangedField) and
         (UpperCase(Item.FieldList.ChangedField.FieldName) = UpperCase(fIDFieldName)) then
      begin
        fIndex[Item.FieldList.ChangedField.AsInteger] := Item;
        Reindex;
      end;
  end;
  inherited;
end;

function TIDObjectListIndexed.AddIdxObj(AObject: TIDObject): Integer;
var DBField: TDBField;
begin
  // проверка уникальности
  DBField := AObject.Fields[fIDFieldName];
  if fIndex[DBField.AsInteger] = nil then
    Result := inherited Add(AObject)
    else
    Result := -1;
end;

function TIDObjectListIndexed.AddEx(AObject: TIDObject; SkipDuplicate: Boolean = False): Integer;
begin
  Result := AddIdxObj(AObject);
  if (Result = -1) and (not SkipDuplicate) then
      raise Exception.Create('У объекта ' + AObject.ClassName + ' добавляемого в ' +
                             ClassName + ' должно быть уникальное значение поля ' + fIDFieldName);
end;

function TIDObjectListIndexed.Add(AObject: TIDObject): Integer;
begin
  Result := AddEx(AObject, False);
end;

procedure TIDObjectListIndexed.Reindex;
var i: Integer;
    DBField: TDBField;
begin
  fIndex.Clear;
  for i := 0 to Count - 1 do
  begin
    DBField := Items[i].FieldList.FindField(fIDFieldName);
    if Assigned(DBField) then
      fIndex[DBField.AsInteger] := Items[i];
  end;
end;
{ ** }


end.
