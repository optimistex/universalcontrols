// Версия - 03.04.2014
unit ucdVSTfunctions;
{
  Модуль рассчитан на Delphi 2010.
  Для работы с этим модулем необходимо установить компоненты:
  Virtual Treeview - http://www.soft-gems.net/index.php?option=com_content&task=view&id=30&Itemid=35
}

interface

uses Windows, SysUtils, Classes, VirtualTrees, ucIDObjects, ucTypes;

type
  TVSTController = class;
  TVSTControllerClass = class of TVSTController;

  TVSTIdObjData = record
    Obj: TIDObject;
  end;

  // Класс для работы с "плоским" списком
  TVSTController = class (TComponent)
  private
    function GetObjects(Node: PVirtualNode): TIDObject;
    procedure SetObjects(Node: PVirtualNode; Value: TIDObject);

    function GetLigament(Obj: TIDObject): PVirtualNode;
    procedure SetLigament(Obj: TIDObject; Node: PVirtualNode);
  protected
    fVST: TVirtualStringTree;
    fIDObjLst: TIDObjectList;
    fLigament: TStringList;
    procedure DoIDObjLstChanged(Sender: TObject);
    procedure AddObj(Obj: TIDObject); virtual;
    procedure PrepareVST; virtual;
    procedure LoadNodes;
    procedure LigamentDel(Obj: TIDObject);
  public
    constructor Create(iVST: TVirtualStringTree;
                       iIDObjList: TIDObjectList); reintroduce;
    destructor Destroy; override;
    procedure Init; virtual;
    procedure DoGetText(Sender: TBaseVirtualTree;
                        Node: PVirtualNode; Column: TColumnIndex;
                        TextType: TVSTTextType; var CellText: UnicodeString);
    property Objects[Node: PVirtualNode]: TIDObject read GetObjects write SetObjects; default;
    property IDObjLst: TIDObjectList read fIDObjLst;
    property Ligament[Obj: TIDObject]: PVirtualNode read  GetLigament
                                                    write SetLigament;
  end;

  // Класс для работы со списком имеющим древовидную структуру
  TVSTControllerTree = class(TVSTController)
  protected
    procedure DoCompareNodes(Sender: TBaseVirtualTree; Node1,
                             Node2: PVirtualNode; Column: TColumnIndex;
                             var Result: Integer); virtual;
    procedure AddObj(Obj: TIDObject); override;
    procedure PrepareVST; override;
  public
    procedure Init; override;
    procedure RebuildTree;
  end;

implementation

{ TVSTController }
constructor TVSTController.Create(iVST: TVirtualStringTree;
                                  iIDObjList: TIDObjectList);
begin
  inherited Create(iVST);
  fLigament := TStringList.Create;

  fVST      := iVST;
  fIDObjLst := iIDObjList;
  Tag       := integer(Self);
end;

destructor TVSTController.Destroy;
var tmp: TVSTGetTextEvent;
begin
  if Assigned(fIDObjLst) then
    fIDObjLst.UnregisterNotify(DoIDObjLstChanged);

  tmp := DoGetText;
  if Addr(fVST.OnGetText) = Addr(tmp) then
    fVST.OnGetText := nil;

  fLigament.Free;
  inherited;
end;

procedure TVSTController.Init;
begin
  if Assigned(fIDObjLst) then
  begin
    fVST.NodeDataSize := SizeOf(TVSTIdObjData);
    if not Assigned(fVST.OnGetText) then
      fVST.OnGetText := DoGetText;
    fIDObjLst.RegisterNotify(DoIDObjLstChanged);
    PrepareVST;
    LoadNodes;
  end;
end;

function TVSTController.GetObjects(Node: PVirtualNode): TIDObject;
begin
  if Assigned(Node) then
    Result := TVSTIdObjData(fVST.GetNodeData(Node)^).Obj
    else
    Result := nil;
end;

procedure TVSTController.SetObjects(Node: PVirtualNode; Value: TIDObject);
begin
  TVSTIdObjData(fVST.GetNodeData(Node)^).Obj := Value;
end;

function TVSTController.GetLigament(Obj: TIDObject): PVirtualNode;
var Index: Integer;
begin
  Index := fLigament.IndexOf(IntToStr(Integer(Obj)));
  if (Index > -1) and (Index < fLigament.Count) then
    Result := PVirtualNode(fLigament.Objects[Index])
    else
    Result := nil;
end;

procedure TVSTController.SetLigament(Obj: TIDObject; Node: PVirtualNode);
begin
  fLigament.AddObject(IntToStr(Integer(Obj)), TObject(Node));
end;

procedure TVSTController.DoGetText(Sender: TBaseVirtualTree;
                                   Node: PVirtualNode; Column: TColumnIndex;
                                   TextType: TVSTTextType; var CellText: UnicodeString);
var
  Obj: TIDObject;
begin
  try
    Obj := Objects[Node];

    if Assigned(Obj)and(Column > -1) then
      CellText := Obj.Fields[fVST.Header.Columns.Items[Column].Hint].AsString;
  except
    CellText := 'Fatal error';
  end;

//  if fVST.Header.Columns.Items[Column].Hint = 'id' then
//    CellText := CellText + ' ['+IntToStr(integer(Obj.IsChanged))+']';
end;

procedure TVSTController.DoIDObjLstChanged(Sender: TObject);

  procedure MoveLevelUpChildNodes(pNode: PVirtualNode);
  var Node, NodeMove: PVirtualNode;
  begin
    Node := fVST.GetFirstChild(pNode);
    while Assigned(Node) do
    begin
      NodeMove := Node;
      Node := fVST.GetNextSibling(Node);
      fVST.MoveTo(NodeMove, pNode, amInsertBefore, False);
    end;
  end;

var
  ObjLst: TIDObjectList;
  tR: TRect;
begin
  ObjLst := TIDObjectList(Sender);
  case ObjLst.NotifyState of
    olsAddItem:         AddObj(ObjLst.NotifyItem);
    olsRemoveItem, olsExtractItem: begin
        MoveLevelUpChildNodes(Ligament[ObjLst.NotifyItem]);
        fVST.DeleteNode(Ligament[ObjLst.NotifyItem]);
        LigamentDel(ObjLst.NotifyItem);
        fVST.Invalidate;
      end;
    olsChangeItem: if IntersectRect(tR, fVST.GetDisplayRect(Ligament[ObjLst.NotifyItem], -1, False), fVST.ClientRect) then
                     fVST.InvalidateNode(Ligament[ObjLst.NotifyItem]);
    olsChangeIDParent:  ;
  end;

  if fIDObjLst.State = nosDestroing then  fIDObjLst := nil;
end;

procedure TVSTController.AddObj(Obj: TIDObject);
var
  Node: PVirtualNode;
begin
  Node := fVST.AddChild(nil);
  TVSTIdObjData(fVST.GetNodeData(Node)^).Obj := Obj;
  Ligament[Obj] := Node;
end;

procedure TVSTController.PrepareVST;
begin
  with fVST do
  begin
    Indent          := 2;
    Margin          := 0;
    ParentShowHint  := False;
    ShowHint        := True;
    TextMargin      := 2;
    HintMode        := hmTooltip;
  //  TreeOptions.MiscOptions := [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning, toEditOnClick];
  //  TreeOptions.PaintOptions := [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages];
  //  TreeOptions.SelectionOptions := [toFullRowSelect];
  end;
end;

procedure TVSTController.LoadNodes;
var i: integer;
begin
  fVST.Clear;
  for i := 0 to fIDObjLst.Count - 1 do
    AddObj(fIDObjLst[i]);
end;

procedure TVSTController.LigamentDel(Obj: TIDObject);
var Index: Integer;
begin
  Index := fLigament.IndexOf(IntToStr(Integer(Obj)));
  if (Index > -1) and (Index < fLigament.Count) then
    fLigament.Delete(Index);
end;

{ TVSTControllerTree }

procedure TVSTControllerTree.Init;
begin
  inherited;
  if not Assigned(fVST.OnCompareNodes) then
    fVST.OnCompareNodes := DoCompareNodes;
  // Сортировка
  fVST.Sort(fVST.RootNode, -1, sdAscending);
end;

procedure TVSTControllerTree.DoCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var Obj1, Obj2: TIDObject;
    OLI: TIDObjectListIndexed; // Object List Indexed
begin
  if fIDObjLst is TIDObjectListIndexed then
  begin
    OLI := TIDObjectListIndexed(fIDObjLst);
    Obj1 := Objects[Node1];
    Obj2 := Objects[Node2];

    if Assigned(Obj1) and Assigned(Obj2) then
      Result := Obj1[OLI.OrderFieldName].AsInteger -
                Obj2[OLI.OrderFieldName].AsInteger;
  end;
end;

procedure TVSTControllerTree.AddObj(Obj: TIDObject);
var
  Node, ParentNode: PVirtualNode;
  OLI: TIDObjectListIndexed; // Object List Indexed
begin
  ParentNode := nil;
  OLI := nil;
  // Поиск родительского узла
  if fIDObjLst is TIDObjectListIndexed then
  begin
    OLI := TIDObjectListIndexed(fIDObjLst);
    ParentNode := Ligament[OLI.Index[Obj[OLI.IDParentFieldName].AsInteger]];
  end;
  // Добавление узла
  Node := fVST.AddChild(ParentNode);
  TVSTIdObjData(fVST.GetNodeData(Node)^).Obj := Obj;
  Ligament[Obj] := Node;
  // Присваиваем порядковый номер
  if Assigned(OLI) and (Obj[OLI.OrderFieldName].AsInteger < 1) then
  begin
    Node := fVST.GetPreviousSibling(Node);
    if Assigned(Node) then
      Obj[OLI.OrderFieldName].AsInteger := Objects[Node].Fields[OLI.OrderFieldName].AsInteger + 1
      else
      Obj[OLI.OrderFieldName].AsInteger := 1;
  end;
  // Сортируем родителя
//  fVST.Sort(ParentNode, -1, sdAscending);
end;

procedure TVSTControllerTree.PrepareVST;
begin
  with fVST do
  begin
    Indent          := 14;
    Margin          := 0;
    ParentShowHint  := False;
    ShowHint        := True;
    TextMargin      := 2;
    HintMode        := hmTooltip;
  //  TreeOptions.MiscOptions := [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning, toEditOnClick];
  //  TreeOptions.PaintOptions := [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages];
  //  TreeOptions.SelectionOptions := [toFullRowSelect];
  end;
end;

procedure TVSTControllerTree.RebuildTree;
var i: Integer;
    OLI: TIDObjectListIndexed; // Object List Indexed
    CurNode, NewParentNode: PVirtualNode;
begin
  try
    fVST.BeginUpdate;
    //--
    if fIDObjLst is TIDObjectListIndexed then
    begin
      OLI := TIDObjectListIndexed(fIDObjLst);
      for i := 0 to OLI.Count - 1 do
      begin
        CurNode := Ligament[OLI[i]];
        NewParentNode := Ligament[OLI.Index[OLI[i].Fields[OLI.IDParentFieldName].AsInteger]];

        if NewParentNode <> fVST.NodeParent[CurNode] then
          fVST.MoveTo(CurNode, NewParentNode, amAddChildFirst, False);
      end;
    end;
    fVST.SortTree(-1, sdAscending);
  finally
    fVST.EndUpdate;
  end;
end;

end.
