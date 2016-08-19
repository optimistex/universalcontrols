// Версия - 08.05.2013
unit ucSkinEditor;
{$include ..\delphi_ver.inc}

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, StdCtrls, ComCtrls, Spin,
  CheckLst, ActnList, ImgList, Math, pngimage,
{$IFNDEF DELPHI_2009_UP}
  ucCompatibilityD7withD2010,
{$ENDIF}
  ucGraphics, ucExtCtrls, UcButtons, ucWindows, ucStdCtrls, ucFunctions;

type
  TWhatChanged = (wcNone, wcCurStyle, wcSelSrc, wcSelDest, wcEdits);

  TPaintInfoEditor = class(TForm)
    pnlWorkAreaBack: TUcPanel;
    pnlRight: TUcPanel;
    pnlTools: TUcPanel;
    pnlTarget: TUcPanel;
    edCurrentStyle: TEdit;
    btStyleAdd: TUcButton;
    btStyleDelete: TUcButton;
    SourcePages: TPageControl;
    tbPicture: TTabSheet;
    tbEditor: TTabSheet;
    PreviewStatus: TStatusBar;
    pnlPreviewTabs: TUcPanel;
    grpSource: TGroupBox;
    grpStyle: TGroupBox;
    UcButton4: TUcButton;
    grpDestination: TGroupBox;
    pStyle: TComboBox;
    UcButton5: TUcButton;
    pnlPreviewBack: TUcPanel;
    pnlDestination: TUcPanel;
    clbStyles: TCheckListBox;
    MainActions: TActionList;
    actStyleAdd: TAction;
    actStyleDelete: TAction;
    pnlSource: TUcPanel;
    actViewElement: TAction;
    actViewAll: TAction;
    cbSL: TCheckBox;
    SL: TSpinEdit;
    ST: TSpinEdit;
    cbST: TCheckBox;
    SR: TSpinEdit;
    cbSR: TCheckBox;
    cbSB: TCheckBox;
    SB: TSpinEdit;
    cbSW: TCheckBox;
    SW: TSpinEdit;
    cbSH: TCheckBox;
    SH: TSpinEdit;
    cbDL: TCheckBox;
    DL: TSpinEdit;
    cbDT: TCheckBox;
    DT: TSpinEdit;
    cbDR: TCheckBox;
    DR: TSpinEdit;
    cbDB: TCheckBox;
    DB: TSpinEdit;
    cbDW: TCheckBox;
    DW: TSpinEdit;
    cbDH: TCheckBox;
    DH: TSpinEdit;
    ViewTabs: TTabControl;
    actUndo: TAction;
    UcButton1: TUcButton;
    cbpStyle: TCheckBox;
    ImgLst: TImageList;
    UcBtn_Select: TUcButton;
    UcBtn_Move: TUcButton;
    Splitter1: TSplitter;
    UcLabel1: TUcLabel;
    tbSource: TTabSheet;
    Mmo_Source: TMemo;
    UcPanel1: TUcPanel;
    UcBtn_CopySrcToDest: TUcButton;
    UcBtn_CopyDestToSrc: TUcButton;
    procedure pnlDestinationMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure pnlDestinationMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlSourceMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlSourceMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlDestinationResize(Sender: TObject);
    procedure actStyleAddExecute(Sender: TObject);
    procedure actStyleDeleteExecute(Sender: TObject);
    procedure edCurrentStyleChange(Sender: TObject);
    procedure clbStylesClick(Sender: TObject);
    procedure pnlSourceDrawBackground(Sender: TObject; Canvas: TCanvas);
    procedure pnlDestinationDrawBackground(Sender: TObject; Canvas: TCanvas);
    procedure pnlSourceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ViewTabsChange(Sender: TObject);
    procedure pnlSourceMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlSourceClick(Sender: TObject);
    procedure pnlDestinationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actUndoExecute(Sender: TObject);
    procedure cbSLClick(Sender: TObject);
    procedure pnlSourceResize(Sender: TObject);
    procedure clbStylesClickCheck(Sender: TObject);
    procedure SLChange(Sender: TObject);
    procedure UcBtn_MoveClick(Sender: TObject);
    procedure tbPictureMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlPreviewBackMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SourcePagesChange(Sender: TObject);
    procedure Mmo_SourceChange(Sender: TObject);
  private
    // OptimistEx
    Sel0: TPoint;
    Selecting, SelMoving: Boolean;
    fSelRectDest: TRect;
    fSelRectSrc: TRect;
    fSaveCurrentStyle: string;
    fLockUpdates: Boolean;
    fSourceMode: Boolean;
    //**
    // OptimistEx
    function GetStyle: string;
    function GetCurrentStyle: string;
    procedure CurrentStyleUndoSet;
    procedure CurrentStyleUndo;
    procedure SetCurrentStyle(const Value: string);
    procedure SetStyle(const Value: string);
    procedure SetSelRectDest(const Value: TRect);
    procedure SetSelRectSrc(const Value: TRect);
    procedure SelectionMove(DeltaX, DeltaY: Integer; DestSelection: Integer);    // перемещение выделения
    procedure SelectionSize(DeltaX, DeltaY: Integer; DestSelection: Integer);    // перемещение выделения
    procedure ShowDestImage(aCanvas: TCanvas; APaintInfo: string; ADestRect: TRect);
    procedure ChangeWorkMode(Source: Boolean);
  protected
    fPainter: TUcSkinPainter;
    // OptimistEx
    procedure UpdateCurStyle2Edits;
    procedure UpdateCurStyle2Selects;
    procedure UpdateSelects2Edits;
    procedure UpdateEdits2CurStyle;
    procedure UpdateStyle(WhatChanged: TWhatChanged = wcNone);

    procedure UpdateCursor(Sender: TObject; X, Y: Integer);

    procedure CurrentStyleChanged;
    procedure SelRectSrcChanged;
    procedure SelRectDestChanged;


    procedure DrawSelectRect(Canvas: TCanvas; Rect: TRect);
    property SelRectSrc: TRect read fSelRectSrc write SetSelRectSrc;
    property SelRectDest: TRect read fSelRectDest write SetSelRectDest;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(srcImage: TGraphic; srcPaintInfo: string);

    // OptimistEx
    property Style: string read GetStyle write SetStyle;
    property CurrentStyle: string read GetCurrentStyle write SetCurrentStyle;
  end;

implementation

{$R *.dfm}
const BlancStyle = 'sl: 0; st: 0; sr: 0; sb: 0; dl: 0; dt: 0; dr: 0; db: 0; style: stretch;';

procedure TPaintInfoEditor.cbSLClick(Sender: TObject);
var CName: string;
    Ctrl: TControl;
begin
  CName := TCheckBox(Sender).Name;
  CName := Copy(CName, 3, Length(CName));
  Ctrl := TCheckBox(Sender).Parent.FindChildControl(CName);
  if Assigned(Ctrl) then
    Ctrl.Enabled := TCheckBox(Sender).Checked;

  UpdateStyle(wcEdits);
end;

procedure TPaintInfoEditor.ChangeWorkMode(Source: Boolean);
begin
  fSourceMode := Source;

  UC_SetEnabledEx(not Source, True, [grpSource, grpDestination, grpStyle,
    UcBtn_CopySrcToDest, UcBtn_CopyDestToSrc, pnlTools, UcBtn_Select
  ]);

  if Source then
  begin
    UcBtn_Move.Down := True;
    ViewTabs.TabIndex := 1;
    ViewTabs.Hide;
    Mmo_Source.Text := Style;
  end else
    ViewTabs.Show;

  UpdateStyle;
end;

procedure TPaintInfoEditor.clbStylesClick(Sender: TObject);
begin
  CurrentStyleChanged;
  CurrentStyleUndoSet;
end;

procedure TPaintInfoEditor.clbStylesClickCheck(Sender: TObject);
begin
  UpdateStyle;
end;

constructor TPaintInfoEditor.Create(AOwner: TComponent);
begin
  inherited;
  clbStyles.Clear;
  fPainter     := TUcSkinPainter.Create;

  fLockUpdates := False;
  UcBtn_Select.Click;

  CurrentStyleChanged;

  ChangeWorkMode(False);
  tbEditor.Show;
end;

procedure TPaintInfoEditor.UpdateEdits2CurStyle;
var NewStyle: string;
begin
  NewStyle := '';
  if cbSL.Checked then NewStyle := NewStyle + Format('%s: %s; ', [LowerCase(SL.Name), SL.Text]);
  if cbST.Checked then NewStyle := NewStyle + Format('%s: %s; ', [LowerCase(ST.Name), ST.Text]);
  if cbSR.Checked then NewStyle := NewStyle + Format('%s: %s; ', [LowerCase(SR.Name), SR.Text]);
  if cbSB.Checked then NewStyle := NewStyle + Format('%s: %s; ', [LowerCase(SB.Name), SB.Text]);
  if cbSW.Checked then NewStyle := NewStyle + Format('%s: %s; ', [LowerCase(SW.Name), SW.Text]);
  if cbSH.Checked then NewStyle := NewStyle + Format('%s: %s; ', [LowerCase(SH.Name), SH.Text]);

  if cbDL.Checked then NewStyle := NewStyle + Format('%s: %s; ', [LowerCase(DL.Name), DL.Text]);
  if cbDT.Checked then NewStyle := NewStyle + Format('%s: %s; ', [LowerCase(DT.Name), DT.Text]);
  if cbDR.Checked then NewStyle := NewStyle + Format('%s: %s; ', [LowerCase(DR.Name), DR.Text]);
  if cbDB.Checked then NewStyle := NewStyle + Format('%s: %s; ', [LowerCase(DB.Name), DB.Text]);
  if cbDW.Checked then NewStyle := NewStyle + Format('%s: %s; ', [LowerCase(DW.Name), DW.Text]);
  if cbDH.Checked then NewStyle := NewStyle + Format('%s: %s; ', [LowerCase(DH.Name), DH.Text]);

  if cbpStyle.Checked then NewStyle := NewStyle + Format('style: %s; ', [pStyle.Text]);

  CurrentStyle := NewStyle;
end;

procedure TPaintInfoEditor.CurrentStyleChanged;
begin
  if clbStyles.ItemIndex = -1 then
  begin
    if edCurrentStyle.Text <> '' then
      edCurrentStyle.Text := '';
    edCurrentStyle.Enabled := False;
  end else
  begin
    if edCurrentStyle.Text <> clbStyles.Items[clbStyles.ItemIndex] then
      edCurrentStyle.Text := clbStyles.Items[clbStyles.ItemIndex];
    edCurrentStyle.Enabled := True and not fSourceMode;
  end;

  UpdateStyle(wcCurStyle);
end;

procedure TPaintInfoEditor.CurrentStyleUndo;
begin
  CurrentStyle := fSaveCurrentStyle;
end;

procedure TPaintInfoEditor.CurrentStyleUndoSet;
begin
  fSaveCurrentStyle := CurrentStyle;
end;

destructor TPaintInfoEditor.Destroy;
begin
  fPainter.Free;
  inherited;
end;

procedure TPaintInfoEditor.DrawSelectRect(Canvas: TCanvas; Rect: TRect);
begin
  if UcBtn_Select.Down then
    with Canvas do
    begin
      Pen.Style   := psDot;
      Pen.Color   := clGray;
      Pen.Mode    := pmXor;
      Brush.Style := bsClear;
      Rectangle(Rect);
    end;
end;

procedure TPaintInfoEditor.edCurrentStyleChange(Sender: TObject);
begin
  CurrentStyle := TEdit(Sender).Text;
end;

procedure TPaintInfoEditor.ShowDestImage(aCanvas: TCanvas; APaintInfo: string; ADestRect: TRect);
begin
  if Assigned(fPainter) and Assigned(fPainter.SourceIMG) and (not fPainter.SourceIMG.Empty) then
  begin
    fPainter.PaintInfo    := APaintInfo;
    fPainter.BaseDestRect := ADestRect;
    fPainter.Draw(aCanvas);
  end;
end;

procedure TPaintInfoEditor.SLChange(Sender: TObject);
begin
  UpdateStyle(wcEdits);
end;

procedure TPaintInfoEditor.SourcePagesChange(Sender: TObject);
begin
  ChangeWorkMode(TPageControl(Sender).ActivePage = tbSource);
end;

procedure TPaintInfoEditor.tbPictureMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlSource.SetFocus;
end;

procedure TPaintInfoEditor.UpdateSelects2Edits;
var Srect, Drect: TRect;
begin
  Srect := pnlSource.ClientRect;

  SL.Value := SelRectSrc.Left;
  ST.Value := SelRectSrc.Top;
  SR.Value := Srect.Right  - SelRectSrc.Right;
  SB.Value := Srect.Bottom - SelRectSrc.Bottom;
  SW.Value := SelRectSrc.Right  - SelRectSrc.Left;
  SH.Value := SelRectSrc.Bottom - SelRectSrc.Top;
  //--
  Drect := pnlDestination.ClientRect;

  DL.Value := SelRectDest.Left;
  DT.Value := SelRectDest.Top;
  DR.Value := Drect.Right  - SelRectDest.Right;
  DB.Value := Drect.Bottom - SelRectDest.Bottom;
  DW.Value := SelRectDest.Right  - SelRectDest.Left;
  DH.Value := SelRectDest.Bottom - SelRectDest.Top;
end;

procedure TPaintInfoEditor.UpdateStyle(WhatChanged: TWhatChanged = wcNone);
begin
  if not fLockUpdates then
  try
    fLockUpdates := True;

    case WhatChanged of
      wcCurStyle: begin
        UpdateCurStyle2Edits;
        UpdateCurStyle2Selects;
      end;

      wcSelSrc, wcSelDest: begin
        UpdateSelects2Edits;
        UpdateEdits2CurStyle;
      end;

      wcEdits: begin
        UpdateEdits2CurStyle;
        UpdateCurStyle2Selects;
      end;
    end;

    pnlSource.Invalidate;
    pnlDestination.Invalidate;
  finally
    fLockUpdates := False;
  end;
end;

procedure TPaintInfoEditor.ViewTabsChange(Sender: TObject);
begin
  UpdateStyle;
end;

procedure TPaintInfoEditor.actStyleAddExecute(Sender: TObject);
var ItemIndex: Integer;
begin
  ItemIndex := clbStyles.Items.Add(BlancStyle);
  clbStyles.Checked[ItemIndex] := True;
  clbStyles.ItemIndex := ItemIndex;
  clbStylesClick(clbStyles);
end;

procedure TPaintInfoEditor.actStyleDeleteExecute(Sender: TObject);
var ItemIndex: Integer;
begin
  ItemIndex := clbStyles.ItemIndex;

  if (ItemIndex > -1) and
     (MessageBox(Handle, 'Подтверждаете удаление стиля?',
                 'Подтверждение', MB_YESNO or MB_ICONQUESTION) = ID_YES) then
  begin
    clbStyles.Items.Delete(ItemIndex);
    if clbStyles.Items.Count > ItemIndex then
      clbStyles.ItemIndex := ItemIndex
      else
      clbStyles.ItemIndex := clbStyles.Items.Count - 1;
    CurrentStyleChanged;
  end;
end;

procedure TPaintInfoEditor.actUndoExecute(Sender: TObject);
begin
  CurrentStyleUndo;
end;

procedure TPaintInfoEditor.FormActivate(Sender: TObject);
begin
  PreviewStatus.Panels[1].Text := 'Шир.: ' + IntToStr(pnlDestination.Width) + ' пикс.';
  PreviewStatus.Panels[2].Text := 'Выс.: ' + IntToStr(pnlDestination.Height) + ' пикс.';
end;

procedure TPaintInfoEditor.SelectionMove(DeltaX, DeltaY: Integer; DestSelection: Integer);
begin
  case DestSelection of
    1:  with SelRectSrc do // Source image
          SelRectSrc := Rect(Left + DeltaX, Top + DeltaY,
                             Right + DeltaX, Bottom + DeltaY);
    2:  with SelRectDest do // DestImage
          SelRectDest := Rect(Left + DeltaX, Top + DeltaY,
                              Right + DeltaX, Bottom + DeltaY);
  end;
end;

procedure TPaintInfoEditor.SelectionSize(DeltaX, DeltaY,
  DestSelection: Integer);
begin
  case DestSelection of
    1:  with SelRectSrc do // Source image
          SelRectSrc := Rect(Left, Top,
                             Right + DeltaX, Bottom + DeltaY);
    2:  with SelRectDest do // DestImage
          SelRectDest := Rect(Left, Top,
                              Right + DeltaX, Bottom + DeltaY);
  end;
end;

procedure TPaintInfoEditor.SelRectDestChanged;
var Drect: TRect;
begin
  Drect := pnlDestination.ClientRect;

  DL.Value := SelRectDest.Left;
  DT.Value := SelRectDest.Top;
  DR.Value := Drect.Right  - SelRectDest.Right;
  DB.Value := Drect.Bottom - SelRectDest.Bottom;
  DW.Value := SelRectDest.Right  - SelRectDest.Left;
  DH.Value := SelRectDest.Bottom - SelRectDest.Top;
end;

procedure TPaintInfoEditor.SelRectSrcChanged;
var Srect: TRect;
begin
  Srect := pnlSource.ClientRect;

  SL.Value := SelRectSrc.Left;
  ST.Value := SelRectSrc.Top;
  SR.Value := Srect.Right  - SelRectSrc.Right;
  SB.Value := Srect.Bottom - SelRectSrc.Bottom;
  SW.Value := SelRectSrc.Right  - SelRectSrc.Left;
  SH.Value := SelRectSrc.Bottom - SelRectSrc.Top;
end;

procedure TPaintInfoEditor.SetCurrentStyle(const Value: string);
begin
  if clbStyles.ItemIndex > -1 then
  begin
    clbStyles.Items[clbStyles.ItemIndex] := Value;
    if Value <> edCurrentStyle.Text then
      edCurrentStyle.Text := Value;
  end;
  CurrentStyleChanged;
end;

procedure TPaintInfoEditor.SetStyle(const Value: string);
{$IFNDEF DELPHI_2009_UP}
var i: Integer;
{$ENDIF}
begin
  clbStyles.Clear;
  PaintInfoParseStrs(Value, clbStyles.Items);
  {$IFDEF DELPHI_2009_UP}
  clbStyles.CheckAll(cbChecked, False, False);
  {$ELSE}
  for i := 0 to clbStyles.Count - 1 do
    clbStyles.Checked[i] := True;
  {$ENDIF}
  if clbStyles.Items.Count > 0 then
    clbStyles.ItemIndex := 0;
  CurrentStyleChanged;
end;

procedure TPaintInfoEditor.SetSelRectDest(const Value: TRect);
begin
  fSelRectDest := Value;
  UpdateStyle(wcSelDest);
end;

procedure TPaintInfoEditor.SetSelRectSrc(const Value: TRect);
begin
  fSelRectSrc := Value;
  UpdateStyle(wcSelSrc);
end;

function TPaintInfoEditor.GetStyle: string;
var i: Integer;
begin
  for i := 0 to clbStyles.Items.Count - 1 do
    if clbStyles.Checked[i] then
      if i < clbStyles.Items.Count - 1 then
      Result := Result + '{' + clbStyles.Items[i] + '}'#13#10
      else
      Result := Result + '{' + clbStyles.Items[i] + '}';
end;

function TPaintInfoEditor.GetCurrentStyle: string;
begin
  if clbStyles.ItemIndex < 0 then
    Result := ''
    else
    Result := clbStyles.Items[clbStyles.ItemIndex];
end;

procedure TPaintInfoEditor.UcBtn_MoveClick(Sender: TObject);
begin
  UC_WinSysControlCMD(pnlSource, 0, 0, 0, 0, False);
  UC_WinSysControlCMD(pnlDestination, 0, 0, 0, 0, False);
  if UcBtn_Select.Down then
  begin
    pnlSource.Cursor := crCross;
    pnlDestination.Cursor := crCross;
  end;
  UpdateStyle;
end;

procedure TPaintInfoEditor.UpdateCursor(Sender: TObject; X, Y: Integer);
begin
  if UcBtn_Select.Down and not (SelMoving or Selecting) then
    if Sender = pnlSource then
    begin
      if PtInRect(SelRectSrc, Point(X, Y)) then
        pnlSource.Cursor      := crDrag
        else
        pnlSource.Cursor      := crCross;
    end
    else if Sender = pnlDestination then
    begin
      if PtInRect(SelRectDest, Point(X, Y)) then
        pnlDestination.Cursor := crDrag
        else
        pnlDestination.Cursor := crCross;
    end;
end;

procedure TPaintInfoEditor.UpdateCurStyle2Edits;

  procedure SetControlFromStyle(cnt: TSpinEdit; stl: TUcPaintStyleParamsInfo);
  var pn: TUcPaintStyleParams;
      cb: TControl;
  begin
    // Установка значения
    pn := UC_ConvPaintStyleParam(LowerCase(cnt.Name));
    cnt.Value := StrToIntDef(stl[pn], 0);
    // Установка галочки
    cb := cnt.Parent.FindChildControl('cb' + cnt.Name);
    if Assigned(cb) and (cb is TCheckBox) then
      (cb as TCheckBox).Checked := stl[pn] <> '';
  end;

var pp: TUcPaintStyleParamsInfo;
begin
  pp := PaintInfoParseArr(CurrentStyle);
  // Обновление координат
  SetControlFromStyle(SL, pp);
  SetControlFromStyle(ST, pp);
  SetControlFromStyle(SR, pp);
  SetControlFromStyle(SB, pp);
  SetControlFromStyle(SW, pp);
  SetControlFromStyle(SH, pp);
  SetControlFromStyle(DL, pp);
  SetControlFromStyle(DT, pp);
  SetControlFromStyle(DR, pp);
  SetControlFromStyle(DB, pp);
  SetControlFromStyle(DW, pp);
  SetControlFromStyle(DH, pp);
  // Обновление стиля заполнения
  pStyle.ItemIndex := pStyle.Items.IndexOf(pp[ucGraphics.style]);
  cbpStyle.Checked := pStyle.ItemIndex >= 0;
end;

procedure TPaintInfoEditor.UpdateCurStyle2Selects;
var PI: TUcPaintInfo;
begin
  PI := PaintInfoParseStr(CurrentStyle, pnlSource.ClientRect, pnlDestination.ClientRect);
  SelRectSrc := PI.Src;
  SelRectDest:= PI.Dest;
end;

procedure TPaintInfoEditor.Init(srcImage: TGraphic; srcPaintInfo: string);
begin
  fPainter.PaintInfo := srcPaintInfo;

  if Assigned(srcImage) then
  begin
    fPainter.SourceIMG := srcImage;
    pnlSource.Width  := fPainter.SourceIMG.Width;
    pnlSource.Height := fPainter.SourceIMG.Height;
  end;

  pnlSource.Left   := (pnlSource.Parent.ClientWidth  - pnlSource.Width)  div 2;
  pnlSource.Top    := (pnlSource.Parent.ClientHeight - pnlSource.Height) div 2;
  fPainter.BaseSrcRect := pnlSource.ClientRect;
  Style := fPainter.PaintInfo;
end;

procedure TPaintInfoEditor.Mmo_SourceChange(Sender: TObject);
begin
  Style := TMemo(Sender).Text;
end;

procedure TPaintInfoEditor.pnlDestinationDrawBackground(Sender: TObject; Canvas: TCanvas);
begin
  case ViewTabs.TabIndex of
    0: ShowDestImage(Canvas, CurrentStyle, TControl(Sender).ClientRect);
    1: ShowDestImage(Canvas, Style, TControl(Sender).ClientRect);
  end;
  DrawSelectRect(Canvas, SelRectDest);
end;

procedure TPaintInfoEditor.pnlDestinationKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssShift in Shift then
    case Key of
      VK_LEFT : SelectionSize(-1, 0, 2);
      VK_RIGHT: SelectionSize(1, 0, 2);
      VK_UP   : SelectionSize(0, -1, 2);
      VK_DOWN : SelectionSize(0, 1, 2);
    end else
    case Key of
      VK_LEFT : SelectionMove(-1, 0, 2);
      VK_RIGHT: SelectionMove(1, 0, 2);
      VK_UP   : SelectionMove(0, -1, 2);
      VK_DOWN : SelectionMove(0, 1, 2);
    end;
end;

procedure TPaintInfoEditor.pnlSourceMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then
  begin
    if UcBtn_Move.Down then
      UC_WinSysControlCMD(TWinControl(Sender), 0, 0, 0, 0, True)
    else begin
      Sel0 := Point(X, Y);
      if PtInRect(SelRectSrc, Sel0) then
        SelMoving  := True
      else begin
        SelMoving  := False;
        SelRectSrc := Rect(X, Y, X, Y);
      end;
    end;
  end;
end;

procedure TPaintInfoEditor.pnlDestinationMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then
  begin
    if UcBtn_Move.Down then
      UC_WinSysControlCMD(TWinControl(Sender), 4, 4, 4, 4, True)
    else begin
      Sel0 := Point(X, Y);
      if PtInRect(SelRectDest, Sel0) then
        SelMoving  := True
      else begin
        SelMoving  := False;
        SelRectDest := Rect(X, Y, X, Y);
      end;
    end;
  end;
end;

procedure TPaintInfoEditor.pnlDestinationResize(Sender: TObject);
begin
  CurrentStyleChanged;
  PreviewStatus.Panels[1].Text := 'Шир.: ' + IntToStr(pnlDestination.Width) + ' пикс.';
  PreviewStatus.Panels[2].Text := 'Выс.: ' + IntToStr(pnlDestination.Height) + ' пикс.';
end;

procedure TPaintInfoEditor.pnlPreviewBackMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlDestination.SetFocus;
end;

procedure TPaintInfoEditor.pnlSourceClick(Sender: TObject);
begin
  if not Selecting then
    if Sender = pnlSource then
      SelRectSrc := Rect(0, 0, 0, 0)
      else
      SelRectDest := Rect(0, 0, 0, 0);
end;

procedure TPaintInfoEditor.pnlSourceDrawBackground(Sender: TObject; Canvas: TCanvas);
begin
  if Assigned(fPainter.SourceIMG) then Canvas.Draw(0, 0, fPainter.SourceIMG);
  DrawSelectRect(Canvas, SelRectSrc);
end;

procedure TPaintInfoEditor.pnlSourceKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssShift in Shift then
    case Key of
      VK_LEFT : SelectionSize(-1, 0, 1);
      VK_RIGHT: SelectionSize(1, 0, 1);
      VK_UP   : SelectionSize(0, -1, 1);
      VK_DOWN : SelectionSize(0, 1, 1);
    end else
    case Key of
      VK_LEFT : SelectionMove(-1, 0, 1);
      VK_RIGHT: SelectionMove(1, 0, 1);
      VK_UP   : SelectionMove(0, -1, 1);
      VK_DOWN : SelectionMove(0, 1, 1);
    end;
end;

procedure TPaintInfoEditor.pnlSourceMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var R: TRect;
begin
  if UcBtn_Move.Down then UC_WinSysControlCMD(TWinControl(Sender), 0, 0, 0, 0, False);
  if ssLeft in Shift then
  begin
    Selecting := True;
    if SelMoving then
    begin
      R := SelRectSrc;
      OffsetRect(R, X - Sel0.X, Y - Sel0.Y);
      SelRectSrc := R;
      Sel0 := Point(X, Y);
    end else
      SelRectSrc := Rect(Min(X, Sel0.X), Min(Y, Sel0.Y), Max(X, Sel0.X), Max(Y, Sel0.Y));
  end;
  UpdateCursor(Sender, X, Y);
end;

procedure TPaintInfoEditor.pnlDestinationMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var R: TRect;
begin
  if UcBtn_Move.Down then UC_WinSysControlCMD(TWinControl(Sender), 4, 4, 4, 4, False);
  if ssLeft in Shift then
  begin
    Selecting := True;
    if SelMoving then
    begin
      R := SelRectDest;
      OffsetRect(R, X - Sel0.X, Y - Sel0.Y);
      SelRectDest := R;
      Sel0 := Point(X, Y);
    end else
      SelRectDest := Rect(Min(X, Sel0.X), Min(Y, Sel0.Y), Max(X, Sel0.X), Max(Y, Sel0.Y));
  end;
  UpdateCursor(Sender, X, Y);
end;

procedure TPaintInfoEditor.pnlSourceMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Selecting := False;
  SelMoving := False;
end;

procedure TPaintInfoEditor.pnlSourceResize(Sender: TObject);
begin
  CurrentStyleChanged;
end;

end.
