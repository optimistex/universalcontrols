unit UcDBGrids;
{$include ..\delphi_ver.inc}
interface

uses
  Windows, SysUtils, Classes, Controls, Grids, StrUtils, ShellAPI,
  DBGrids, Messages, Dialogs, Themes, Graphics, ucHint, Forms, StdCtrls,
  Math, DB, ucTypes;

type
  TColChangeInfo  = (ccBegin, ccDo, ccEnd, ccNormal);
  TColChangeState = (ccsBeginResize, ccsDoResize, ccsEndResize,
                     ccsBeginMove, ccsDoMove, ccsEndMove,
                     ccsRubberSize,
                     ccsNormal);
  TXPDBGridOptionsEx= set of (xdgRubberGrid, xdgAutoSearch, xdgMemoAsString);

  TUcDBGridOptionsEx = TXPDBGridOptionsEx;

  TOnColSizing = procedure(Sender: TObject; Column: TColumn;
                           Pos, NewWidth: integer;
                           var ColResizeState: TColChangeState) of object;

  TOnCheckColumnDrag = procedure(Sender: TObject; Origin, Destination: Integer;
                                 var CanDrag: Boolean) of object;

  TUcDBGrid = class(TDBGrid)
  private
    { Private declarations }
    FShowRowHint: Boolean;
    fBgImg: TPicture;
    fBgBmp: TBitmap;
    fBgStyle: TUcIMGStyle;
    FTitleOffset: Byte;

    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;

    procedure CheckSelectedRows;
    function IsActiveControl: Boolean;
    procedure GridRectToScreenRect(GridRect: TGridRect;
      var ScreenRect: TRect; IncludeLine: Boolean);

    function GetVersion: TCaption;
    procedure SetVersion(Value: TCaption);
    function GetBgImg: TPicture;
    procedure SetBgImg(Value: TPicture);
    procedure BgImgChange(Sender: TObject);
    procedure UpdateBGBmp;
    procedure DrawBg(R: TRect);
    procedure SetBgStyle(Value: TUcIMGStyle);
  protected
    { Protected declarations }
    fLastResizeCol    : integer;
    fStartPosColResize: integer;
    fOnColSizing      : TOnColSizing;
    fOnCheckColumnDrag: TOnCheckColumnDrag;
    fXPDBGridOptionsEx: TUcDBGridOptionsEx;

    fFindWin: TForm;
    fFindEdit: TEdit;
    fSaveColWidths: array of integer;
    fSaveScroll: Integer;

    procedure FindWinShow(Sender: TObject);
    procedure FindWinExit(Sender: TObject);
    procedure FindWinKeyPress(Sender: TObject; var Key: Char);
    function  FindValInColumn(FieldName, Value: string): Boolean;
    procedure Scroll(Distance: Integer); override;

    procedure ColSizing(X, Y: Integer; ColChangeInfo: TColChangeInfo);
    function CheckColumnDrag(var Origin, Destination: Integer;
      const MousePt: TPoint): Boolean; override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure LinkActive(Value: Boolean); override;

    procedure Paint; override;

    procedure UpdateTitleOffset;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure DefaultDrawColumnCell(const Rect: TRect; DataCol: Integer;
                                    Column: TColumn; State: TGridDrawState);
    procedure DoRubberGrid(FixedCol: integer = -1);
    procedure Resize; override;
    procedure AverageWidthOfColumns;
    procedure SaveColWidths;
    procedure RestoreColWidths;
    procedure SaveScroll;
    procedure RestoreScroll;
    procedure ScrollActiveToRow(DestRow : Integer);

    property DataLink;
    property TitleOffset: Byte read FTitleOffset;
  published
    { Published declarations }
    property Version: TCaption read GetVersion write SetVersion stored False;
    property ShowRowHint: Boolean read FShowRowHint write FShowRowHint;
    property OnColSizing: TOnColSizing read fOnColSizing write fOnColSizing;
    property OnCheckColumnDrag: TOnCheckColumnDrag read fOnCheckColumnDrag
                                                   write fOnCheckColumnDrag;
    property OptionsEx: TUcDBGridOptionsEx read fXPDBGridOptionsEx
                                write fXPDBGridOptionsEx default [];

    property BackGroundImage: TPicture read GetBgImg write SetBgImg;
    property BackGroundStyle: TUcIMGStyle read fBgStyle write SetBgStyle;
  end;

  // Для совместимости
  TXPDBGrid = class (TUcDBGrid);

procedure Register;

implementation

{$R *.dcr}
{$Include ..\Versions.ucver}

// Примеры
{
procedure TfrClient_Notes.UcDBGridColSizing(Sender: TObject; Column: TColumn;
  Pos, NewWidth: Integer; var ColResizeState: TColChangeState);
begin
  inherited;

  if Column.FieldName = 'Exec_ICO' then
  begin
    if Column.Width <> 18 then Column.Width := 18;
    ColResizeState := ccsNormal;
  end;

  if Column.FieldName = 'DATE_TIME' then
  begin
    if Column.Width <> 105 then Column.Width := 105;
    ColResizeState := ccsNormal;
  end;

  if ColResizeState in [ccsBeginResize, ccsDoResize, ccsEndResize] then
    ShowMyHint(Self, IntToStr(NewWidth));
end;
}

{
procedure TfrClient_Notes.UcDBGridCheckColumnDrag(Sender: TObject; Origin,
  Destination: Integer; var CanDrag: Boolean);
var i: integer;
begin
  inherited;

  if Origin > Destination then
  begin
    i:= Origin;
    Origin := Destination;
    Destination := i;
  end;

  for I := Origin to Destination do
    if TUcDBGrid(Sender).Columns[i].FieldName = 'Exec_ICO' then
    begin
      CanDrag := False;
      Break;
    end;
end;
}

procedure Register;
begin
  RegisterComponents('UControls', [TUcDBGrid]);
  RegisterComponents('UControls support', [TXPDBGrid]);
end;

//********
function TUcDBGrid.GetVersion: TCaption;
begin
  Result:= UcDBGridVersion;
end;

procedure TUcDBGrid.SetVersion(Value: TCaption);
begin
  //--
end;

function TUcDBGrid.GetBgImg: TPicture;
begin
  Result:= fBgImg;
end;

procedure TUcDBGrid.SetBgImg(Value: TPicture);
begin
  fBgImg.Assign(Value);
  UpdateBGBmp;
end;

procedure TUcDBGrid.UpdateBGBmp;
var X, Y: Integer;
begin
  if Assigned(fBgImg.Graphic) then
  begin
    //    fBgBmp.FreeImage;
    fBgBmp.Canvas.FillRect(BoundsRect);
    fBgBmp.Height := Height;
    fBgBmp.Width  := Width;
    X := 0;
    Y := 0;
    case fBgStyle of
      isStretch :  fBgBmp.Canvas.StretchDraw(Rect(X, Y, Width, Height), fBgImg.Graphic);
      isRepeat  :
        repeat
          X := 0;
          repeat
            fBgBmp.Canvas.Draw(X, Y, fBgImg.Graphic);
            inc(X, fBgImg.Graphic.Width);
          until X > Width;

          fBgBmp.Canvas.Draw(X, Y, fBgImg.Graphic);
          inc(Y, fBgImg.Graphic.Height);
        until Y > Height;

      isRepeatX :
        repeat
          fBgBmp.Canvas.Draw(X, Y, fBgImg.Graphic);
          inc(X, fBgImg.Graphic.Width);
        until X > Width;

      isRepeatY :
        repeat
          fBgBmp.Canvas.Draw(X, Y, fBgImg.Graphic);
          inc(Y, fBgImg.Graphic.Height);
        until Y > Height;

      isOriginal: fBgBmp.Canvas.Draw(X, Y, fBgImg.Graphic);
    end;
  end;
  Invalidate;
end;

procedure TUcDBGrid.BgImgChange(Sender: TObject);
begin
  UpdateBGBmp;
end;

procedure TUcDBGrid.DrawBg(R: TRect);
begin
  if Assigned(fBgImg.Graphic) then
    Canvas.CopyRect(R, fBgBmp.Canvas, R)
    else begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(R);
    end;
end;

procedure TUcDBGrid.SetBgStyle(Value: TUcIMGStyle);
begin
  if fBgStyle <> Value then
  begin
    fBgStyle := Value;
    UpdateBGBmp;
  end;
end;

var
  DrawBitmap: TBitmap;
  UserCount: Integer;

procedure UsesBitmap;
begin
  if UserCount = 0 then
    DrawBitmap := TBitmap.Create;
  Inc(UserCount);
end;

procedure ReleaseBitmap;
begin
  Dec(UserCount);
  if UserCount = 0 then DrawBitmap.Free;
end;

procedure WriteText(ACanvas: TCanvas; ARect: TRect; DX, DY: Integer;
  const Text: string; Alignment: TAlignment; ARightToLeft: Boolean);
const
  AlignFlags : array [TAlignment] of Integer =
    ( DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX );
  RTL: array [Boolean] of Integer = (0, DT_RTLREADING);
var
  B, R: TRect;
  Hold, Left: Integer;
  I: TColorRef;
begin
  I := ColorToRGB(ACanvas.Brush.Color);
  if GetNearestColor(ACanvas.Handle, I) = I then
  begin                       { Use ExtTextOut for solid colors }
    { In BiDi, because we changed the window origin, the text that does not
      change alignment, actually gets its alignment changed. }
    if (ACanvas.CanvasOrientation = coRightToLeft) and (not ARightToLeft) then
      ChangeBiDiModeAlignment(Alignment);
    case Alignment of
      taLeftJustify:
        Left := ARect.Left + DX;
      taRightJustify:
        Left := ARect.Right - ACanvas.TextWidth(Text) - 3;
    else { taCenter }
      Left := ARect.Left + (ARect.Right - ARect.Left) shr 1
        - (ACanvas.TextWidth(Text) shr 1);
    end;
    ACanvas.TextRect(ARect, Left, ARect.Top + DY, Text);
  end
  else begin                  { Use FillRect and Drawtext for dithered colors }
    DrawBitmap.Canvas.Lock;
    try
      with DrawBitmap, ARect do { Use offscreen bitmap to eliminate flicker and }
      begin                     { brush origin tics in painting / scrolling.    }
        Width := Max(Width, Right - Left);
        Height := Max(Height, Bottom - Top);
        R := Rect(DX, DY, Right - Left - 1, Bottom - Top - 1);
        B := Rect(0, 0, Right - Left, Bottom - Top);
      end;
      with DrawBitmap.Canvas do
      begin
        Font := ACanvas.Font;
        Font.Color := ACanvas.Font.Color;
        Brush := ACanvas.Brush;
        Brush.Style := bsSolid;
        FillRect(B);
        SetBkMode(Handle, TRANSPARENT);
        if (ACanvas.CanvasOrientation = coRightToLeft) then
          ChangeBiDiModeAlignment(Alignment);
        DrawText(Handle, PChar(Text), Length(Text), R,
          AlignFlags[Alignment] or RTL[ARightToLeft]);
      end;
      if (ACanvas.CanvasOrientation = coRightToLeft) then
      begin
        Hold := ARect.Left;
        ARect.Left := ARect.Right;
        ARect.Right := Hold;
      end;
      ACanvas.CopyRect(ARect, DrawBitmap.Canvas, B);
    finally
      DrawBitmap.Canvas.Unlock;
    end;
  end;
end;

constructor TUcDBGrid.Create(AOwner: TComponent);
begin
  inherited;

  fBgStyle := isOriginal;
  fBgImg := TPicture.Create;
  fBgBmp := TBitmap.Create;
  fBgImg.OnChange := BgImgChange;
  UsesBitmap;
  //--
  fFindWin  := TForm.Create(Self);
  fFindWin.BorderStyle  := bsNone;
  fFindWin.Height       := 22;
  fFindWin.OnShow       := FindWinShow;
  fFindWin.OnDeactivate := FindWinExit;
  //--
  fFindEdit := TEdit.Create(fFindWin);
  fFindEdit.Parent      := fFindWin;
  fFindEdit.Align       := alClient;
  fFindEdit.CharCase    := ecUpperCase;
  fFindEdit.OnExit      := FindWinExit;
  fFindEdit.OnKeyPress  := FindWinKeyPress;
  //--
end;

destructor TUcDBGrid.Destroy;
begin
  fBgImg.Free;
  fBgBmp.Free;

  inherited;
  ReleaseBitmap;
end;

procedure TUcDBGrid.DefaultDrawColumnCell(const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Value: string;
begin
  Value := '';
  if Assigned(Column.Field) then
    if xdgMemoAsString in OptionsEx then
      Value := Column.Field.AsString
      else
      Value := Column.Field.DisplayText;
  WriteText(Canvas, Rect, 2, 2, Value, Column.Alignment,
    UseRightToLeftAlignmentForField(Column.Field, Column.Alignment));
end;

procedure TUcDBGrid.FindWinShow(Sender: TObject);
var P: TPoint;
    i: Integer;
    DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  P.X := 0;
  for I := 0 to SelectedIndex do Inc(P.X, ColWidths[i] +
                                     DrawInfo.Horz.EffectiveLineWidth);
  P.Y := Height - 5;
  P := ClientToScreen(P);
  TForm(Sender).Top  := P.Y;
  TForm(Sender).Left := P.X;
  TForm(Sender).Width := ColWidths[SelectedIndex+1];
end;

procedure TUcDBGrid.FindWinExit(Sender: TObject);
begin
  fFindWin.Hide;
end;

procedure TUcDBGrid.FindWinKeyPress(Sender: TObject; var Key: Char);
var fStr: string;
begin
  inherited;
  if (Key = #13)or(Key = #27) then
  begin
    fFindWin.Hide;
    Exit;
  end;

  if Key = #8 then
    fStr := Copy(fFindEdit.Text, 1, Length(fFindEdit.Text)-1)
    else
    fStr := fFindEdit.Text + Key;

  if (fStr <> '')and
     (not FindValInColumn(Columns.Items[SelectedIndex].FieldName, fStr)) then
    if Key <> #8 then Key := #0;
end;

function  TUcDBGrid.FindValInColumn(FieldName, Value: string): Boolean;
var Fld: TField;
    {$IFDEF DELPHI_2009_UP}
    Bkmrk: TBytes;
    {$ELSE}
    Bkmrk: TBookmarkStr;
    {$ENDIF}
begin
  Result := False;
  if Assigned(DataSource)and Assigned(DataSource.DataSet) then
  with DataSource.DataSet do
  begin
    Value := AnsiUpperCase(Value);
    Fld := FindField(FieldName);
    if not Assigned(Fld) then Exit;
    DisableControls;
    Bkmrk := Bookmark;

    First;
    while not Eof do
    begin
      if AnsiPos(Value, AnsiUpperCase(Fld.AsString)) = 1 then
      begin
        Result := true;
        break;
      end;
      Next;
    end;

    if not Result then
      Bookmark := Bkmrk;
    EnableControls;
  end;
end;

procedure TUcDBGrid.Scroll(Distance: Integer);
begin
  if (Distance <> 0) and Assigned(fBgImg.Graphic) then Invalidate;
  inherited;
end;

procedure TUcDBGrid.CheckSelectedRows;
begin
  if (SelectedRows.Count <=1)and
     Assigned(DataSource)and
     Assigned(DataSource.DataSet) then
    SelectedRows.CurrentRowSelected := false;
end;

function TUcDBGrid.IsActiveControl: Boolean;
var
  H: Hwnd;
  ParentForm: TCustomForm;
begin
  Result := False;
  ParentForm := GetParentForm(Self);
  if Assigned(ParentForm) then
  begin
    if (ParentForm.ActiveControl = Self) and (ParentForm = Screen.ActiveForm) then
      Result := True
  end
  else
  begin
    H := GetFocus;
    while IsWindow(H) and (Result = False) do
    begin
      if H = WindowHandle then
        Result := True
      else
        H := GetParent(H);
    end;
  end;
end;

procedure TUcDBGrid.GridRectToScreenRect(GridRect: TGridRect;
  var ScreenRect: TRect; IncludeLine: Boolean);

  function LinePos(const AxisInfo: TGridAxisDrawInfo; Line: Integer): Integer;
  var
    Start, I: Longint;
  begin
    with AxisInfo do
    begin
      Result := 0;
      if Line < FixedCellCount then
        Start := 0
      else
      begin
        if Line >= FirstGridCell then
          Result := FixedBoundary;
        Start := FirstGridCell;
      end;
      for I := Start to Line - 1 do
      begin
        Inc(Result, AxisInfo.GetExtent(I) + EffectiveLineWidth);
        if Result > GridExtent then
        begin
          Result := 0;
          Exit;
        end;
      end;
    end;
  end;

  function CalcAxis(const AxisInfo: TGridAxisDrawInfo;
    GridRectMin, GridRectMax: Integer;
    var ScreenRectMin, ScreenRectMax: Integer): Boolean;
  begin
    Result := False;
    with AxisInfo do
    begin
      if (GridRectMin >= FixedCellCount) and (GridRectMin < FirstGridCell) then
        if GridRectMax < FirstGridCell then
        begin
          ScreenRect := Rect(0, 0, 0, 0); { erase partial results}
          Exit;
        end
        else
          GridRectMin := FirstGridCell;
      if GridRectMax > LastFullVisibleCell then
      begin
        GridRectMax := LastFullVisibleCell;
        if GridRectMax < GridCellCount - 1 then Inc(GridRectMax);
        if LinePos(AxisInfo, GridRectMax) = 0 then
          Dec(GridRectMax);
      end;

      ScreenRectMin := LinePos(AxisInfo, GridRectMin);
      ScreenRectMax := LinePos(AxisInfo, GridRectMax);
      if ScreenRectMax = 0 then
        ScreenRectMax := ScreenRectMin + AxisInfo.GetExtent(GridRectMin)
      else
        Inc(ScreenRectMax, AxisInfo.GetExtent(GridRectMax));
      if ScreenRectMax > GridExtent then
        ScreenRectMax := GridExtent;
      if IncludeLine then Inc(ScreenRectMax, EffectiveLineWidth);
    end;
    Result := True;
  end;

var
  DrawInfo: TGridDrawInfo;
  Hold: Integer;
begin
  ScreenRect := Rect(0, 0, 0, 0);
  if (GridRect.Left > GridRect.Right) or (GridRect.Top > GridRect.Bottom) then
    Exit;
  CalcDrawInfo(DrawInfo);
  with DrawInfo do
  begin
    if GridRect.Left > Horz.LastFullVisibleCell + 1 then Exit;
    if GridRect.Top > Vert.LastFullVisibleCell + 1 then Exit;

    if CalcAxis(Horz, GridRect.Left, GridRect.Right, ScreenRect.Left,
      ScreenRect.Right) then
    begin
      CalcAxis(Vert, GridRect.Top, GridRect.Bottom, ScreenRect.Top,
        ScreenRect.Bottom);
    end;
  end;
  if UseRightToLeftAlignment and (Canvas.CanvasOrientation = coLeftToRight) then
  begin
    Hold := ScreenRect.Left;
    ScreenRect.Left := ClientWidth - ScreenRect.Right;
    ScreenRect.Right := ClientWidth - Hold;
  end;
end;

procedure TUcDBGrid.WMVScroll(var Message: TWMVScroll);
begin
  CheckSelectedRows;
  inherited;
end;

procedure TUcDBGrid.WMChar(var Msg: TWMChar);
var NeedShowFindWin: Boolean;
begin
  NeedShowFindWin := not(Msg.CharCode in
                          [VK_RETURN, VK_ESCAPE, VK_BACK, VK_TAB]);
  inherited;
  if (xdgAutoSearch in OptionsEx)and
     Assigned(DataSource) and Assigned(DataSource.DataSet) and
     Assigned(DataSource.DataSet.FindField(Columns.Items[SelectedIndex].FieldName))
     and NeedShowFindWin
     then
  begin
    fFindWin.Show;
    fFindEdit.Text := '';
    fFindEdit.Perform(WM_CHAR, Msg.CharCode, 0);
  end;
end;

procedure TUcDBGrid.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  //inherited;
end;

procedure TUcDBGrid.WMPaint(var Message: TWMPaint);
begin
  inherited;
end;

procedure TUcDBGrid.WMMouseWheel(var Message: TWMMouseWheel);
begin
  CheckSelectedRows;
  if (Message.WheelDelta<120)and(Message.WheelDelta>-120) then inherited;

  if Assigned(Self.DataLink.DataSet) then
  begin
    if Message.WheelDelta>=120 then
      Self.DataLink.DataSet.MoveBy(Message.WheelDelta div -120);

    if Message.WheelDelta<=-120 then
      Self.DataLink.DataSet.MoveBy(Message.WheelDelta div -120);
  end;
end;

procedure TUcDBGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
var OldActive: Integer;
    s: string;
    Field: TField;
begin
  inherited;

  UpdateTitleOffset;
  if FShowRowHint and
     Assigned(DataSource)and
     (MouseCoord(x, y).Y > TitleOffset - 1)and
     (MouseCoord(x, y).X > IndicatorOffset - 1)and
     (DataSource.DataSet.RecordCount > 0) then
  begin
    OldActive := DataLink.ActiveRecord;
    try
      DataLink.ActiveRecord := MouseCoord(X, Y).Y - TitleOffset;

      Field := Columns[MouseCoord(X, Y).X - IndicatorOffset].Field;
      if not Assigned(Field) then Exit;

      if Field.IsBlob then
        s := Field.AsString
        else
        s := TrimRight(Field.DisplayText);

      if (Field.IsBlob and (OptionsEx * [xdgMemoAsString] <> [])) or
         (Canvas.TextWidth(s) > Columns[MouseCoord(X, Y).X - IndicatorOffset].Width) then
        ShowMyHint(Self, s);

    finally
      DataLink.ActiveRecord := OldActive;
    end;
  end;
  ColSizing(X, Y, ccDo);
end;

procedure TUcDBGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  inherited;
  ColSizing(X, Y, ccBegin);
end;

procedure TUcDBGrid.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  ColSizing(X, Y, ccEnd);
  inherited;
  ColSizing(X, Y, ccNormal);
end;

procedure TUcDBGrid.LinkActive(Value: Boolean);
var
  SIOld, SINew: TScrollInfo;
begin
  inherited;

  if Datalink.Active and HandleAllocated then
    with Datalink.DataSet do
    begin
      SIOld.cbSize := sizeof(SIOld);
      SIOld.fMask := SIF_ALL;
      GetScrollInfo(Self.Handle, SB_VERT, SIOld);
      SINew := SIOld;
      if IsSequenced then
      begin
        SINew.nMin := 1;
        SINew.nPage := Self.VisibleRowCount;
        SINew.nMax := Integer(DWORD(RecordCount) + SINew.nPage - 1);
        if State in [dsInactive, dsBrowse, dsEdit] then
          SINew.nPos := RecNo;  // else keep old pos
      end
      else
      begin
        SINew.nMin := 0;
        SINew.nPage := 0;
        SINew.nMax := 4;
        if DataLink.BOF then SINew.nPos := 0
        else if DataLink.EOF then SINew.nPos := 4
        else SINew.nPos := 2;
      end;
      if (SINew.nMin <> SIOld.nMin) or (SINew.nMax <> SIOld.nMax) or
        (SINew.nPage <> SIOld.nPage) or (SINew.nPos <> SIOld.nPos) then
        SetScrollInfo(Self.Handle, SB_VERT, SINew, True);
    end;
end;

///****************************************************
type
  TCustomGridCrack = class (TCustomGrid);

{$IF NOT DEFINED(CLR)}
type
  PIntArray = ^TIntArray;
  TIntArray = array[0..MaxCustomExtents] of Integer;
{$IFEND}

function PointInGridRect(Col, Row: Longint; const Rect: TGridRect): Boolean;
begin
  Result := (Col >= Rect.Left) and (Col <= Rect.Right) and (Row >= Rect.Top)
    and (Row <= Rect.Bottom);
end;

function GridRect(Coord1, Coord2: TGridCoord): TGridRect;
begin
  with Result do
  begin
    Left := Coord2.X;
    if Coord1.X < Coord2.X then Left := Coord1.X;
    Right := Coord1.X;
    if Coord1.X < Coord2.X then Right := Coord2.X;
    Top := Coord2.Y;
    if Coord1.Y < Coord2.Y then Top := Coord1.Y;
    Bottom := Coord1.Y;
    if Coord1.Y < Coord2.Y then Bottom := Coord2.Y;
  end;
end;

{$IF NOT DEFINED(CLR)}
function StackAlloc(Size: Integer): Pointer; register;
asm
  POP   ECX          { return address }
  MOV   EDX, ESP
  ADD   EAX, 3
  AND   EAX, not 3   // round up to keep ESP dword aligned
  CMP   EAX, 4092
  JLE   @@2
@@1:
  SUB   ESP, 4092
  PUSH  EAX          { make sure we touch guard page, to grow stack }
  SUB   EAX, 4096
  JNS   @@1
  ADD   EAX, 4096
@@2:
  SUB   ESP, EAX
  MOV   EAX, ESP     { function result = low memory address of block }
  PUSH  EDX          { save original SP, for cleanup }
  MOV   EDX, ESP
  SUB   EDX, 4
  PUSH  EDX          { save current SP, for sanity check  (sp = [sp]) }
  PUSH  ECX          { return to caller }
end;
{$IFEND}

{$IF NOT DEFINED(CLR)}
procedure StackFree(P: Pointer); register;
asm
  POP   ECX                     { return address }
  MOV   EDX, DWORD PTR [ESP]
  SUB   EAX, 8
  CMP   EDX, ESP                { sanity check #1 (SP = [SP]) }
  JNE   @@1
  CMP   EDX, EAX                { sanity check #2 (P = this stack block) }
  JNE   @@1
  MOV   ESP, DWORD PTR [ESP+4]  { restore previous SP  }
@@1:
  PUSH  ECX                     { return to caller }
end;
{$IFEND}

{$IF NOT DEFINED(CLR)}
procedure FillDWord(var Dest; Count, Value: Integer); register;
asm
  XCHG  EDX, ECX
  PUSH  EDI
  MOV   EDI, EAX
  MOV   EAX, EDX
  REP   STOSD
  POP   EDI
end;
{$IFEND}

procedure TUcDBGrid.Paint;
var
  LineColor: TColor;
  DrawInfo: TGridDrawInfo;
  Sel: TGridRect;
  UpdateRect: TRect;
  AFocRect, FocRect: TRect;
{$IF DEFINED(CLR)}
  PointsList: array of TPoint;
  StrokeList: array of DWORD;
  I: Integer;
{$ELSE}
  PointsList: PIntArray;
  StrokeList: PIntArray;
{$IFEND}
  MaxStroke: Integer;
  FrameFlags1, FrameFlags2: DWORD;

  procedure DrawLines(DoHorz, DoVert: Boolean; Col, Row: Longint;
    const CellBounds: array of Integer; OnColor, OffColor: TColor);

  { Cellbounds is 4 integers: StartX, StartY, StopX, StopY
    Horizontal lines:  MajorIndex = 0
    Vertical lines:    MajorIndex = 1 }

  const
    FlatPenStyle = PS_Geometric or PS_Solid or PS_EndCap_Flat or PS_Join_Miter;

    procedure DrawAxisLines(const AxisInfo: TGridAxisDrawInfo;
      Cell, MajorIndex: Integer; UseOnColor: Boolean);
    var
      Line: Integer;
      LogBrush: TLOGBRUSH;
      Index: Integer;
{$IF DEFINED(CLR)}
      Points: array of TPoint;
{$ELSE}
      Points: PIntArray;
{$IFEND}
      StopMajor, StartMinor, StopMinor, StopIndex: Integer;
      LineIncr: Integer;
    begin
      with Canvas, AxisInfo do
      begin
        if EffectiveLineWidth <> 0 then
        begin
          Pen.Width := GridLineWidth;
          if UseOnColor then
            Pen.Color := OnColor
          else
            Pen.Color := OffColor;
          if Pen.Width > 1 then
          begin
            LogBrush.lbStyle := BS_Solid;
            LogBrush.lbColor := Pen.Color;
            LogBrush.lbHatch := 0;
            Pen.Handle := ExtCreatePen(FlatPenStyle, Pen.Width, LogBrush, 0, nil);
          end;
          Points := PointsList;
          Line := CellBounds[MajorIndex] + (EffectiveLineWidth shr 1) +
            AxisInfo.GetExtent(Cell);
          //!!! ??? Line needs to be incremented for RightToLeftAlignment ???
          if UseRightToLeftAlignment and (MajorIndex = 0) then Inc(Line);
          StartMinor := CellBounds[MajorIndex xor 1];
          StopMinor := CellBounds[2 + (MajorIndex xor 1)];
          StopMajor := CellBounds[2 + MajorIndex] + EffectiveLineWidth;
{$IF DEFINED(CLR)}
          StopIndex := MaxStroke * 2;
{$ELSE}
          StopIndex := MaxStroke * 4;
{$IFEND}
          Index := 0;
          repeat
{$IF DEFINED(CLR)}
            if MajorIndex <> 0 then
            begin
              Points[Index].Y := Line;
              Points[Index].X := StartMinor;
            end else
            begin
              Points[Index].X := Line;
              Points[Index].Y := StartMinor;
            end;
            Inc(Index);
            if MajorIndex <> 0 then
            begin
              Points[Index].Y := Line;
              Points[Index].X := StopMinor;
            end else
            begin
              Points[Index].X := Line;
              Points[Index].Y := StopMinor;
            end;
            Inc(Index);
{$ELSE}
            Points^[Index + MajorIndex] := Line;         { MoveTo }
            Points^[Index + (MajorIndex xor 1)] := StartMinor;
            Inc(Index, 2);
            Points^[Index + MajorIndex] := Line;         { LineTo }
            Points^[Index + (MajorIndex xor 1)] := StopMinor;
            Inc(Index, 2);
{$IFEND}

            // Skip hidden columns/rows.  We don't have stroke slots for them
            // A column/row with an extent of -EffectiveLineWidth is hidden
            repeat
              Inc(Cell);
              LineIncr := AxisInfo.GetExtent(Cell) + EffectiveLineWidth;
            until (LineIncr > 0) or (Cell > LastFullVisibleCell);
            Inc(Line, LineIncr);
          until (Line > StopMajor) or (Cell > LastFullVisibleCell) or (Index > StopIndex);
{$IF DEFINED(CLR)}
          { 2 points per line -> Index div 2 }
          PolyPolyLine(Canvas.Handle, Points, StrokeList, Index shr 1);
{$ELSE}
           { 2 integers per point, 2 points per line -> Index div 4 }
          PolyPolyLine(Canvas.Handle, Points^, StrokeList^, Index shr 2);
{$IFEND}
        end;
      end;
    end;

  begin
    if (CellBounds[0] = CellBounds[2]) or (CellBounds[1] = CellBounds[3]) then
      Exit;
    if not DoHorz then
    begin
      DrawAxisLines(DrawInfo.Vert, Row, 1, DoHorz);
      DrawAxisLines(DrawInfo.Horz, Col, 0, DoVert);
    end
    else
    begin
      DrawAxisLines(DrawInfo.Horz, Col, 0, DoVert);
      DrawAxisLines(DrawInfo.Vert, Row, 1, DoHorz);
    end;
  end;

  procedure DrawCells(ACol, ARow: Longint; StartX, StartY, StopX, StopY: Integer;
    Color: TColor; IncludeDrawState: TGridDrawState);
  var
    CurCol, CurRow: Longint;
    AWhere, Where, TempRect: TRect;
    DrawState: TGridDrawState;
    Focused: Boolean;
  begin
    CurRow := ARow;
    Where.Top := StartY;
    while (Where.Top < StopY) and (CurRow < RowCount) do
    begin
      CurCol := ACol;
      Where.Left := StartX;
      Where.Bottom := Where.Top + RowHeights[CurRow];
      while (Where.Left < StopX) and (CurCol < ColCount) do
      begin
        Where.Right := Where.Left + ColWidths[CurCol];
        if (Where.Right > Where.Left) and RectVisible(Canvas.Handle, Where) then
        begin
          DrawState := IncludeDrawState;
          Focused := IsActiveControl;
          if Focused and (CurRow = Row) and (CurCol = Col)  then
          begin
            SetCaretPos(Where.Left, Where.Top);
            Include(DrawState, gdFocused);
          end;
          if PointInGridRect(CurCol, CurRow, Sel) then
            Include(DrawState, gdSelected);
          if not (gdFocused in DrawState) or not (goEditing in TCustomGridCrack(Self).Options) or
            not EditorMode or (csDesigning in ComponentState) then
          begin
            if DefaultDrawing or (csDesigning in ComponentState) then
              with Canvas do
              begin
                Font := Self.Font;
                if (gdSelected in DrawState) and
                  (not (gdFocused in DrawState) or
                  ([goDrawFocusSelected, goRowSelect] * TCustomGridCrack(Self).Options <> [])) then
                begin
                  Brush.Color := clHighlight;
                  Font.Color := clHighlightText;
                end
                else
                  Brush.Color := Color;
               // FillRect(Where);
              end;
            DrawCell(CurCol, CurRow, Where, DrawState);
            if DefaultDrawing and (gdFixed in DrawState) and Ctl3D and
              ((FrameFlags1 or FrameFlags2) <> 0) then
            begin
              TempRect := Where;
              if (FrameFlags1 and BF_RIGHT) = 0 then
                Inc(TempRect.Right, DrawInfo.Horz.EffectiveLineWidth)
              else if (FrameFlags1 and BF_BOTTOM) = 0 then
                Inc(TempRect.Bottom, DrawInfo.Vert.EffectiveLineWidth);
             // DrawEdge(Canvas.Handle, TempRect, BDR_RAISEDINNER, FrameFlags1);
             // DrawEdge(Canvas.Handle, TempRect, BDR_RAISEDINNER, FrameFlags2);
            end;

            if DefaultDrawing and not (csDesigning in ComponentState) and
              (gdFocused in DrawState) and
              ([goEditing, goAlwaysShowEditor] * TCustomGridCrack(Self).Options <>
              [goEditing, goAlwaysShowEditor])
              and not (goRowSelect in TCustomGridCrack(Self).Options) then
            begin
              if not UseRightToLeftAlignment then
                DrawFocusRect(Canvas.Handle, Where)
              else
              begin
                AWhere := Where;
                AWhere.Left := Where.Right;
                AWhere.Right := Where.Left;
                DrawFocusRect(Canvas.Handle, AWhere);
              end;
            end;
          end;
        end;
        Where.Left := Where.Right + DrawInfo.Horz.EffectiveLineWidth;
        Inc(CurCol);
      end;
      Where.Top := Where.Bottom + DrawInfo.Vert.EffectiveLineWidth;
      Inc(CurRow);
    end;
  end;

begin
//  inherited Paint;

  if UseRightToLeftAlignment then ChangeGridOrientation(True);

  UpdateRect := Canvas.ClipRect;
  CalcDrawInfo(DrawInfo);
  with DrawInfo do
  begin
    if (Horz.EffectiveLineWidth > 0) or (Vert.EffectiveLineWidth > 0) then
    begin
      { Draw the grid line in the four areas (fixed, fixed), (variable, fixed),
        (fixed, variable) and (variable, variable) }
      LineColor := clSilver;
      MaxStroke := Max(Horz.LastFullVisibleCell - LeftCol + FixedCols,
                        Vert.LastFullVisibleCell - TopRow + FixedRows) + 3;
{$IF DEFINED(CLR)}
      SetLength(PointsList, MaxStroke * 2); // two points per stroke
      SetLength(StrokeList, MaxStroke);
      for I := 0 to MaxStroke - 1 do
        StrokeList[I] := 2;
{$ELSE}
      PointsList := StackAlloc(MaxStroke * sizeof(TPoint) * 2);
      StrokeList := StackAlloc(MaxStroke * sizeof(Integer));
      FillDWord(StrokeList^, MaxStroke, 2);
{$IFEND}

      if ColorToRGB(Color) = clSilver then LineColor := clGray;

{
      DrawLines(goFixedHorzLine in TCustomGridCrack(Self).Options,
                goFixedVertLine in TCustomGridCrack(Self).Options,
                0, 0, [0, 0, Horz.FixedBoundary, Vert.FixedBoundary],
                clBlack, FixedColor);
      DrawLines(goFixedHorzLine in TCustomGridCrack(Self).Options,
                goFixedVertLine in TCustomGridCrack(Self).Options,
                LeftCol, 0, [Horz.FixedBoundary, 0, Horz.GridBoundary,
                Vert.FixedBoundary], clBlack, FixedColor);
      DrawLines(goFixedHorzLine in TCustomGridCrack(Self).Options,
                goFixedVertLine in TCustomGridCrack(Self).Options,
                0, TopRow, [0, Vert.FixedBoundary, Horz.FixedBoundary,
                Vert.GridBoundary], clBlack, FixedColor);
      DrawLines(goHorzLine in TCustomGridCrack(Self).Options,
                goVertLine in TCustomGridCrack(Self).Options, LeftCol,
                TopRow, [Horz.FixedBoundary, Vert.FixedBoundary, Horz.GridBoundary,
                Vert.GridBoundary], LineColor, Color);
}
      DrawLines(goFixedHorzLine in TCustomGridCrack(Self).Options,
                goFixedVertLine in TCustomGridCrack(Self).Options,
                0, 0, [0, 0, Horz.FixedBoundary, Vert.FixedBoundary],
                LineColor, FixedColor);
      DrawLines(goFixedHorzLine in TCustomGridCrack(Self).Options,
                goFixedVertLine in TCustomGridCrack(Self).Options,
                LeftCol, 0, [Horz.FixedBoundary, 0, Horz.GridBoundary,
                Vert.FixedBoundary], LineColor, FixedColor);
      DrawLines(goFixedHorzLine in TCustomGridCrack(Self).Options,
                goFixedVertLine in TCustomGridCrack(Self).Options,
                0, TopRow, [0, Vert.FixedBoundary, Horz.FixedBoundary,
                Vert.GridBoundary], LineColor, FixedColor);
      DrawLines(goHorzLine in TCustomGridCrack(Self).Options,
                goVertLine in TCustomGridCrack(Self).Options, LeftCol,
                TopRow, [Horz.FixedBoundary, Vert.FixedBoundary, Horz.GridBoundary,
                Vert.GridBoundary], LineColor, Color);

{$IF DEFINED(CLR)}
      SetLength(StrokeList, 0);
      SetLength(PointsList, 0);
{$ELSE}
      StackFree(StrokeList);
      StackFree(PointsList);
{$IFEND}
    end;

    { Draw the cells in the four areas }
    Sel := Selection;
    FrameFlags1 := 0;
    FrameFlags2 := 0;
    if goFixedVertLine in TCustomGridCrack(Self).Options then
    begin
      FrameFlags1 := BF_RIGHT;
      FrameFlags2 := BF_LEFT;
    end;
    if goFixedHorzLine in TCustomGridCrack(Self).Options then
    begin
      FrameFlags1 := FrameFlags1 or BF_BOTTOM;
      FrameFlags2 := FrameFlags2 or BF_TOP;
    end;
    DrawCells(0, 0, 0, 0, Horz.FixedBoundary, Vert.FixedBoundary, FixedColor,
      [gdFixed]);
    DrawCells(LeftCol, 0, Horz.FixedBoundary - 0, 0, Horz.GridBoundary,  //!! clip
      Vert.FixedBoundary, FixedColor, [gdFixed]);
    DrawCells(0, TopRow, 0, Vert.FixedBoundary, Horz.FixedBoundary,
      Vert.GridBoundary, FixedColor, [gdFixed]);
    DrawCells(LeftCol, TopRow, Horz.FixedBoundary - 0,                   //!! clip
      Vert.FixedBoundary, Horz.GridBoundary, Vert.GridBoundary, Color, []);

    if not (csDesigning in ComponentState) and
      (goRowSelect in TCustomGridCrack(Self).Options) and DefaultDrawing and Focused then
    begin
      GridRectToScreenRect(Selection, FocRect, False);
      if not UseRightToLeftAlignment then
        Canvas.DrawFocusRect(FocRect)
      else
      begin
        AFocRect := FocRect;
        AFocRect.Left := FocRect.Right;
        AFocRect.Right := FocRect.Left;
        DrawFocusRect(Canvas.Handle, AFocRect);
      end;
    end;

    { Fill in area not occupied by cells }
    if Horz.GridBoundary < Horz.GridExtent then
    begin
      Canvas.Brush.Color := clWindow;//Color;
      DrawBg(Rect(Horz.GridBoundary, 0, Horz.GridExtent, Vert.GridBoundary));
    end;
    if Vert.GridBoundary < Vert.GridExtent then
    begin
      Canvas.Brush.Color := Color;
      DrawBg(Rect(0, Vert.GridBoundary, Horz.GridExtent, Vert.GridExtent))
    end;
  end;

  if UseRightToLeftAlignment then ChangeGridOrientation(False);
end;

procedure TUcDBGrid.UpdateTitleOffset;
begin
  FTitleOffset := integer(dgTitles in Options);
end;
///****************************************************
procedure TUcDBGrid.Resize;
begin
  inherited;

  UpdateBGBmp;
  if FGridState = gsNormal then DoRubberGrid();
end;

procedure TUcDBGrid.AverageWidthOfColumns;
var i, w: Integer;
begin
  w := Round(ClientWidth / Columns.Count);
  for i := 0 to Columns.Count - 1 do
    Columns[i].Width := w;
end;

procedure TUcDBGrid.DoRubberGrid(FixedCol: integer = -1);
//const DeathZone = 12;
var i, TotalColWidth, NewWidth, FixedWidth,
    LastSizedCol, OldWidth, MaxWidth, ClientWidth_, k1, k2: integer;
    k: Real;
    Cols: array of Boolean;
    DeathZone: integer;
    DrawInfo: TGridDrawInfo;

    function CheckCanResize(Index: integer): Boolean;
    var ColChangeInfo: TColChangeState;
    begin
      if Index = FixedCol then
        Result := false
        else begin
          if Assigned(fOnColSizing) then
          begin
            ColChangeInfo := ccsRubberSize;
            fOnColSizing(Self, Columns.Items[Index - IndicatorOffset],
                         -1, -1, ColChangeInfo);
            Result := ColChangeInfo = ccsRubberSize;
          end else Result := true;
        end;
    end;

begin
  if (xdgRubberGrid in OptionsEx)and(ColCount > 0) then
  begin
    CalcDrawInfo(DrawInfo);
    DeathZone := DrawInfo.Horz.FixedBoundary;

    k1  := integer(not (dgIndicator in Options));
    k2 := integer(dgIndicator in Options);

    SetLength(Cols, ColCount - k2);

    TotalColWidth := 0; FixedWidth:= 0; LastSizedCol := -1;
    ClientWidth_  := ClientWidth - (integer(dgColLines in Options) * ColCount);


    for I := 1 - k1 to ColCount - 1 do
    begin
      Cols[i - k2] := CheckCanResize(i);
      if Cols[i - k2] then
      begin
        Inc(TotalColWidth, ColWidths[i]);
        LastSizedCol := i;
      end else
        Inc(FixedWidth, ColWidths[i]);
    end;

    if (FixedCol > 1)and(ClientWidth_ - DeathZone < FixedWidth) then
    begin
      OldWidth := ColWidths[FixedCol];
      MaxWidth := 0;
      for I := 1 - k1 to ColCount - 1 do
        if (not Cols[i - k2]) and (i <> FixedCol) then Inc(MaxWidth, ColWidths[i]);
      MaxWidth := ClientWidth_ - DeathZone - MaxWidth - Round(ClientWidth_ * 0.05);
      ColWidths[FixedCol] := MaxWidth;
      FixedWidth := FixedWidth - OldWidth + MaxWidth;
    end;

    if TotalColWidth <= 0 then Exit;

    k:= (ClientWidth_ - DeathZone - FixedWidth)/TotalColWidth;
    TotalColWidth := 0;
    for I := 1 - k1 to LastSizedCol - 1 do
      if Cols[i - k2] then
      begin
        NewWidth := Round(ColWidths[i] * k);
        if NewWidth < 2 then NewWidth := 2;

        ColWidths[i] := NewWidth;
        Inc(TotalColWidth, NewWidth);
      end;

    NewWidth := ClientWidth_ - DeathZone - FixedWidth - TotalColWidth;
    if NewWidth < 2 then NewWidth := 2;
    ColWidths[LastSizedCol] := NewWidth;
    //**
    SetLength(Cols, 0);
  end;
end;


procedure TUcDBGrid.ColSizing(X, Y: Integer; ColChangeInfo: TColChangeInfo);
var
  DrawInfo: TGridDrawInfo;
  State: TGridState;
  Pos, Ofs, NewWidth: Integer;
  ColChangeState: TColChangeState;
begin
  if FGridState in [gsColSizing, gsColMoving] then
  begin
    case ColChangeInfo of
      ccBegin : case FGridState of
                   gsColSizing: ColChangeState := ccsBeginResize;
                   gsColMoving: ColChangeState := ccsBeginMove;
                end;

      ccDo    : case FGridState of
                   gsColSizing: ColChangeState := ccsDoResize;
                   gsColMoving: ColChangeState := ccsDoMove;
                end;

      ccEnd   : case FGridState of
                   gsColSizing: ColChangeState := ccsEndResize;
                   gsColMoving: ColChangeState := ccsEndMove;
                end;

      ccNormal: ColChangeState := ccsNormal;
    end;
    //------
    if ColChangeState = ccsBeginResize then
    begin
      fStartPosColResize := X;
      State := FGridState;
      CalcDrawInfo(DrawInfo);
      CalcSizingState(X, Y, State, fLastResizeCol, Pos, Ofs, DrawInfo);
    end
    else if ColChangeState = ccsBeginMove then
    begin
      Pos := X;
      fLastResizeCol:= MouseCoord(X, Y).X;
    end else Pos := X;
    NewWidth := ColWidths[fLastResizeCol]+Pos-fStartPosColResize;

    if (ColChangeState = ccsEndResize)and(NewWidth < 2) then
      ColWidths[fLastResizeCol] := 2;

    if Assigned(fOnColSizing) then
      fOnColSizing(Self, Columns.Items[fLastResizeCol - IndicatorOffset],
                   Pos, NewWidth, ColChangeState);

    if ColChangeState = ccsNormal then
    begin
      FGridState := gsNormal;
      InvalidateGrid;
    end;
    //**
  end
  else if (ColChangeInfo = ccNormal) then
    DoRubberGrid(fLastResizeCol);
end;

procedure TUcDBGrid.SaveColWidths;
var i: integer;
begin
  SetLength(fSaveColWidths, ColCount);
  for i := 1 to ColCount - 1 do
    fSaveColWidths[i] := ColWidths[i];
end;

procedure TUcDBGrid.RestoreColWidths;
var i: integer;
    SaveOptionsEx: TUcDBGridOptionsEx;
begin
  if Length(fSaveColWidths) <> ColCount then Exit;

  SaveOptionsEx := OptionsEx;
  OptionsEx := OptionsEx - [xdgRubberGrid];
  for i := 1 to ColCount - 1 do
    ColWidths[i] := fSaveColWidths[i];
  OptionsEx := SaveOptionsEx;
end;

procedure TUcDBGrid.SaveScroll;
begin
  fSaveScroll := Row;
end;

procedure TUcDBGrid.RestoreScroll;
begin
  ScrollActiveToRow(fSaveScroll);
end;

procedure TUcDBGrid.ScrollActiveToRow(DestRow : Integer);
var
  CurRow, dRow, SDistance: Integer;
begin
  if Assigned(DataSource) then
  try
    BeginUpdate;
    CurRow := Row;
    dRow := CurRow - DestRow;
    if dRow = 0 then Exit;
    if dRow < 0 then
    begin
      DataLink.ActiveRecord := 0;
      SDistance:= DataSource.DataSet.MoveBy(dRow);
      DataSource.DataSet.MoveBy(CurRow - SDistance - TitleOffset);
    end else
    begin
      DataLink.ActiveRecord := VisibleRowCount - 1;
      SDistance := DataSource.DataSet.MoveBy(dRow);
      DataSource.DataSet.MoveBy(-VisibleRowCount + CurRow + 1 -
                                SDistance - TitleOffset);
    end;
  finally
    EndUpdate;
  end;
end;

function TUcDBGrid.CheckColumnDrag(var Origin, Destination: Integer;
                                   const MousePt: TPoint): Boolean;
begin
  Result := inherited CheckColumnDrag(Origin, Destination, MousePt);

  if Assigned(OnCheckColumnDrag) then
    OnCheckColumnDrag(Self, Origin - 1, Destination - 1, Result);
end;


procedure TUcDBGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
Var OldActive: Integer;
    Details: TThemedElementDetails;
    R: TRect;
    Index: Integer;
    DrawColumn: TColumn;
    Value: string;
    Highlight: Boolean;
begin
 // if [gdFixed] <> AState then Inherited;
  if not ThemeServices.ThemesEnabled then
  begin
    Inherited;
    Exit;
  end;

  UpdateTitleOffset;
  Dec(ARow, TitleOffset);
  Dec(ACol, IndicatorOffset);

  // Рисуем ячейки
  if not (gdFixed in AState) then with Canvas do
  begin
    DrawColumn := Columns[ACol];
    if not DrawColumn.Showing then Exit;
    Font := DrawColumn.Font;
    Brush.Color := DrawColumn.Color;

    if (DataLink = nil) or (not DataLink.Active)or
       (DataSource=nil)or(DataSource.DataSet=nil)or(DataSource.DataSet.RecordCount=0) then
    begin
      DrawBg(ARect);
    end else
    begin
      Value := '';
      OldActive := DataLink.ActiveRecord;
      try
        DataLink.ActiveRecord := ARow ;//- 1;
        if Assigned(DrawColumn.Field) then
          if xdgMemoAsString in OptionsEx then
          begin
            if not DrawColumn.Field.IsNull then
              Value := DrawColumn.Field.AsString;
          end else
            Value := DrawColumn.Field.DisplayText;
        Highlight := HighlightCell(ACol, ARow, Value, AState);
        if Highlight then
        begin
          Brush.Color := clHighlight;
          Font.Color := clHighlightText;
        end;
        if not Enabled then
          Font.Color := clGrayText;
        if DefaultDrawing then
        begin
          if (AState * [gdSelected, gdFocused] = [])or
             ((gdSelected in AState)and
              (not (dgAlwaysShowSelection in Options))and not Focused) then
          begin
            Canvas.Brush.Color := DrawColumn.Color;
            DrawBg(ARect);
          end else
            FillRect(ARect);
          Brush.Style := bsClear;
          WriteText(Canvas, ARect, 2, 2, Value, DrawColumn.Alignment,
            UseRightToLeftAlignmentForField(DrawColumn.Field, DrawColumn.Alignment));
        end;
        if Columns.State = csDefault then
          DrawDataCell(ARect, DrawColumn.Field, AState);
        DrawColumnCell(ARect, ACol, DrawColumn, AState);
      finally
        DataLink.ActiveRecord := OldActive;
      end;
      if DefaultDrawing and (gdSelected in AState)
        and ((dgAlwaysShowSelection in Options) or Focused)
        and not (csDesigning in ComponentState)
        and not (dgRowSelect in Options)
        and (UpdateLock = 0)
        and (ValidParentForm(Self).ActiveControl = Self) then
        Windows.DrawFocusRect(Handle, ARect);
    end;
  end;
  //**

  //Рисуем заголовки если они есть
  if ([gdFixed] = AState)and(ARow<0) then
    begin
       Details.Element:=teHeader;
       Details.Part := 1;
       Details.State:= 0;

       R.Left:= ARect.Left;
       R.Top := ARect.Top;
       R.Right:=ARect.Right;
       R.Bottom:=ARect.Bottom+1;
       ThemeServices.DrawElement(Canvas.Handle, Details, R);
       R.Top := ARect.Top+1;
       R.Left := ARect.Left+2;
       if (DataSource<>nil) then
       if (Columns.Count>=ACol)and(ACol>=0) then
       ThemeServices.DrawText(Canvas.Handle,
                              Details,
                              Columns.Items[ACol].Title.Caption,
                              R,0,0);
    end else
  //Рисуем индикатор
  if ([gdFixed] = AState)and(ARow>=0) then
    begin
      Details.Element:=teScrollBar;

      if (DataSource=nil)or(DataSource.DataSet=nil)then
        begin
          Details.Part:= 2;
          Details.State:= 13;
        end else
      if (DataSource<>nil)and(not DataSource.DataSet.Active) then
        begin
          Details.Part:= 2;
          Details.State:= 13;
        end else
          if (ARow = DataLink.ActiveRecord) then
            begin
              Details.Part:= 1;
              if SelectedRows.Count>1 then
                 Details.State:= 15 else Details.State:= 13;
            end else
            begin
              OldActive := DataLink.ActiveRecord;
              try
                DataLink.ActiveRecord := ARow;
                if (dgMultiSelect in Options) and Datalink.Active and
                    SelectedRows.Find(DataLink.DataSource.DataSet.Bookmark, Index)
                then begin
                  Details.Part:= 1;
                  Details.State:= 15;
                end else
                begin
                  Details.Part:= 2;
                  Details.State:= 13;
                end;
              finally
                DataLink.ActiveRecord := OldActive;
              end;
            end;
      R.Left:= ARect.Left;
      R.Top := ARect.Top;
      R.Right:=ARect.Right;
      R.Bottom:=ARect.Bottom;
//      R.Right:=ARect.Right+1;
//      R.Bottom:=ARect.Bottom+1;
      ThemeServices.DrawElement(Canvas.Handle, Details, R);
    end;
  //**
end;
//********

end.
