// Версия - 08.04.2013
unit ucExtCtrls;
{$include ..\delphi_ver.inc}

interface

uses
  Messages, Windows, Classes, Types, ExtCtrls, SysUtils,
  Controls, Graphics, Forms, ucTypes, ucGraphics, ucSkin;

type
  TUcPanel = class (TCustomPanel)
  private
    fBgImg: TPicture;
    fBgBmp: TBitmap;
    fBgStyle: TUcIMGStyle;
    fTransparent: Boolean;
    fOnPaint: TNotifyEvent;
    fOnDrawBackground: TNotifyDrawBackground;
    fCaptureFocus: Boolean;

    FSkinManager: TUcSkinManager;
    FSkinName: TUcSkinName;
    fSkinPainter: TUcSkinPainter;

    function GetVersion: TCaption;
    procedure SetVersion(Value: TCaption);
    function GetBgImg: TPicture;
    procedure SetBgImg(Value: TPicture);
    procedure BgImgChange(Sender: TObject);
    procedure UpdateBGBmp;
    procedure SetBgStyle(Value: TUcIMGStyle);
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure SetTransparent(Value: Boolean);
    function GetCanvas: TCanvas;
    procedure SetSkinManager(const Value: TUcSkinManager);
    procedure SetSkinName(const Value: TUcSkinName);
    procedure DoSkinManagerChanged(Sender: TObject);
    procedure UpdateSkinPainter;
    function CreateBitmap32: TBitmap;
  protected
    procedure DoPaint; virtual;
    procedure DoDrawBG; virtual;
    procedure Paint; override;
    procedure WndProc(var Message: TMessage); override;
    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure DrawBg(R: TRect);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property Canvas: TCanvas read GetCanvas;
    property DockManager;
  published
    property Version: TCaption read GetVersion write SetVersion stored False;
    property Transparent: Boolean read fTransparent write SetTransparent default False;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderWidth;
    property BorderStyle;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    property Locked;
    property ParentBiDiMode;
    property ParentBackground;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property BackGroundImage: TPicture read GetBgImg write SetBgImg;
    property BackGroundStyle: TUcIMGStyle read fBgStyle write SetBgStyle;
    property CaptureFocus: Boolean read FCaptureFocus write FCaptureFocus default False;

    property SkinManager: TUcSkinManager read FSkinManager write SetSkinManager;
    property SkinName: TUcSkinName read FSkinName write SetSkinName;
{$IFDEF DELPHI_2009_UP}
    property Padding;
    property ParentDoubleBuffered;
    property ShowCaption;
    property VerticalAlignment;
    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnMouseActivate;
    property OnMouseEnter;
    property OnMouseLeave;
{$ENDIF}
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property OnDrawBackground: TNotifyDrawBackground  read fOnDrawBackground write fOnDrawBackground;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

{$IFDEF DELPHI_2009_UP}
  TUcFlowPanel = class(TFlowPanel)
  private
    FCenterControls: Boolean;
    FAutoHeight: Boolean;
    FAutoMinHeight: Integer;
    procedure SetAutoHeight(const Value: Boolean);
    procedure SetAutoMinHeight(const Value: Integer);
  protected
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property HorizCenterControls: Boolean read FCenterControls write FCenterControls default False;
    property AutoHeight: Boolean read FAutoHeight write SetAutoHeight default True;
    property AutoMinHeight: Integer read FAutoMinHeight write SetAutoMinHeight default 8;
  end;
{$ENDIF}



procedure Register;

implementation

uses
  Consts, Dialogs, Themes, Math, UxTheme,
{$IFDEF DELPHI_2009_UP}
  DwmApi,
{$ENDIF}
  CommCtrl;

{$R *.dcr}
{$Include ..\Versions.ucver}

procedure Register;
begin
  RegisterComponents('UControls', [TUcPanel]);

{$IFDEF DELPHI_2009_UP}
  RegisterComponents('UControls', [TUcFlowPanel]);
{$ENDIF}
end;

{ TUcPanel }
constructor TUcPanel.Create(AOwner: TComponent);
begin
  inherited;

  FCaptureFocus := False;
  fBgStyle := isOriginal;
  fBgImg := TPicture.Create;
  fBgImg.OnChange := BgImgChange;
  fBgBmp := CreateBitmap32;

  fSkinPainter := nil;
end;

function TUcPanel.CreateBitmap32: TBitmap;
begin
  Result := TBitmap.Create;
  Result.PixelFormat := pf32bit;
  Result.HandleType := bmDDB;
  Result.Canvas.Brush.Color := Color;
end;

destructor  TUcPanel.Destroy;
begin
  if Assigned(FSkinManager) then FSkinManager.UnregisterNotify(DoSkinManagerChanged);
  fSkinPainter.Free;
  fBgImg.Free;
  fBgBmp.Free;

  inherited;
end;

procedure TUcPanel.DoDrawBG;
begin
  if Assigned(fOnDrawBackground) then fOnDrawBackground(Self, fBgBmp.Canvas);
end;

procedure TUcPanel.DoPaint;
begin
  if Assigned(FOnPaint) then FOnPaint(Self);
end;

procedure TUcPanel.DoSkinManagerChanged(Sender: TObject);
var SM: TUcSkinManager;
    SCI: TUcSkinCollectionItem;
begin
  if Sender is TUcSkinManager then
  begin
    SM := Sender as TUcSkinManager;
    case SM.ChangeInfo of
      sciImage: UpdateSkinPainter;

      sciStyle: begin
        if SM.ChangedItem is TUcSkinCollectionItem then
          SCI := SM.ChangedItem as TUcSkinCollectionItem
          else
          SCI := nil;

        if Assigned(SCI) and (CompareText(SCI.Name, FSkinName) = 0) then
          UpdateSkinPainter;
      end;
    end;
  end;
end;

function TUcPanel.GetVersion: TCaption;
begin
  Result:= UcExtCtrlsVersion;
end;

procedure TUcPanel.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = SkinManager then
    begin
      FSkinManager := nil;
      UpdateSkinPainter;
      Invalidate;
    end;
  end;
end;

procedure TUcPanel.SetVersion(Value: TCaption);
begin
  //--
end;

function TUcPanel.GetBgImg: TPicture;
begin
  Result:= fBgImg;
end;

function TUcPanel.GetCanvas: TCanvas;
begin
  Result := inherited Canvas;
end;

procedure TUcPanel.SetBgImg(Value: TPicture);
begin
  fBgImg.Assign(Value);
  Invalidate;
end;

procedure TUcPanel.UpdateBGBmp;
var X, Y: Integer;
    DestCanvas: TCanvas;
begin
  X := 0;
  Y := 0;
  DestCanvas := fBgBmp.Canvas;
  if fBgBmp.Height < Height then fBgBmp.Height := Height;
  if fBgBmp.Width < Width then fBgBmp.Width  := Width;

  if Assigned(Parent) and fTransparent then
  begin
    DestCanvas.FillRect(Parent.ClientRect);

    if Parent is TUcPanel then
      DestCanvas.CopyRect(ClientRect, TUcPanel(Parent).fBgBmp.Canvas, BoundsRect)
    else
    begin
      SendMessage(Parent.Handle, WM_PRINTCLIENT, DestCanvas.Handle, PRF_CLIENT);
      DestCanvas.CopyRect(ClientRect, DestCanvas, BoundsRect);
    end;
  end else
    DestCanvas.FillRect(ClientRect);

  if Assigned(fBgImg.Graphic) and (fBgImg.Width > 0) and (fBgImg.Height > 0) then
    case fBgStyle of
      isStretch :  DestCanvas.StretchDraw(Rect(X, Y, Width, Height), fBgImg.Graphic);
      isRepeat  :
        repeat
          X := 0;
          repeat
            DestCanvas.Draw(X, Y, fBgImg.Graphic);
            inc(X, fBgImg.Graphic.Width);
          until X > Width;

          DestCanvas.Draw(X, Y, fBgImg.Graphic);
          inc(Y, fBgImg.Graphic.Height);
        until Y > Height;

      isRepeatX :
        repeat
          DestCanvas.Draw(X, Y, fBgImg.Graphic);
          inc(X, fBgImg.Graphic.Width);
        until X > Width;

      isRepeatY :
        repeat
          DestCanvas.Draw(X, Y, fBgImg.Graphic);
          inc(Y, fBgImg.Graphic.Height);
        until Y > Height;

      isOriginal: DestCanvas.Draw(X, Y, fBgImg.Graphic);
    end;

  if Assigned(fSkinPainter) then fSkinPainter.Draw(DestCanvas);
end;

procedure TUcPanel.UpdateSkinPainter;
begin
  FreeAndNil(fSkinPainter);
  if Assigned(FSkinManager) then
  begin
    fSkinPainter := FSkinManager.CreateSkinPainterByStyleName(FSkinName);
    if Assigned(fSkinPainter) then
      fSkinPainter.BaseDestRect := ClientRect;
    Invalidate;
  end;
end;

procedure TUcPanel.BgImgChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TUcPanel.DrawBg(R: TRect);
begin
//  if Assigned(fBgImg.Graphic) then
//  begin
    UpdateBGBmp;
    DoDrawBG;
    Canvas.CopyRect(R, fBgBmp.Canvas, R);
//  end else
//    Canvas.FillRect(R);
end;

procedure TUcPanel.SetBgStyle(Value: TUcIMGStyle);
begin
  if fBgStyle <> Value then
  begin
    fBgStyle := Value;
    Invalidate;
  end;
end;

procedure TUcPanel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if Assigned(fSkinPainter) then fSkinPainter.BaseDestRect := ClientRect;
end;

procedure TUcPanel.SetSkinManager(const Value: TUcSkinManager);
begin
  if FSkinManager <> Value then
  begin
    if Assigned(FSkinManager) then FSkinManager.UnregisterNotify(DoSkinManagerChanged);
    FSkinManager := Value;
    if Assigned(Value) then
    begin
      Value.FreeNotification(Self);
      Value.RegisterNotify(DoSkinManagerChanged);
    end;
    UpdateSkinPainter;
    Invalidate;
  end;
end;

procedure TUcPanel.SetSkinName(const Value: TUcSkinName);
begin
  if FSkinName <> Value then
  begin
    FSkinName := Value;
    UpdateSkinPainter;
    Invalidate;
  end;
end;

procedure TUcPanel.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 1
end;

procedure TUcPanel.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if fCaptureFocus then Message.Result := DLGC_WANTALLKEYS or DLGC_WANTARROWS;
end;

procedure TUcPanel.WndProc(var Message: TMessage);
begin
  if FCaptureFocus then
    case Message.Msg of
      WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
        if not (csDesigning in ComponentState) and not Focused
           and CanFocus then
        Windows.SetFocus(Handle);

      WM_SETFOCUS, WM_KILLFOCUS:
        Invalidate;
    end;

  inherited WndProc(Message);
end;

procedure TUcPanel.CMColorChanged(var Message: TMessage);
begin
  inherited;
  if Assigned(fBgBmp) then
    fBgBmp.Canvas.Brush.Color := Color;
end;

procedure TUcPanel.SetTransparent(Value: Boolean);
begin
  if fTransparent <> Value then
  begin
    fTransparent := Value;
    Invalidate;
  end;
end;

procedure TUcPanel.Paint;
const
  Alignments: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
{$IFDEF DELPHI_2009_UP}
  VerticalAlignments: array[TVerticalAlignment] of Longint = (DT_TOP, DT_BOTTOM, DT_VCENTER);
{$ENDIF}
var
  Rect: TRect;
  TopColor, BottomColor: TColor;
  //FontHeight: Integer;
  Flags: Longint;

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    TopColor := clBtnHighlight;
    if Bevel = bvLowered then TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = bvLowered then BottomColor := clBtnHighlight;
  end;

begin
  Rect := GetClientRect;
  if BevelOuter <> bvNone then
  begin
    AdjustColors(BevelOuter);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;
  if not (ThemeServices.ThemesEnabled and (csParentBackground in ControlStyle)) then
    Frame3D(Canvas, Rect, Color, Color, BorderWidth)
  else
    InflateRect(Rect, -Integer(BorderWidth), -Integer(BorderWidth));
  if BevelInner <> bvNone then
  begin
    AdjustColors(BevelInner);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;
  with Canvas do
  begin
    if not ThemeServices.ThemesEnabled or not ParentBackground then
      Brush.Color := Color;
    DrawBg(Rect);

    if
      {$IFDEF DELPHI_2009_UP}
      ShowCaption and
      {$ENDIF}
      (Caption <> '') then
    begin
      Brush.Style := bsClear;
      Font := Self.Font;
      Flags := DT_EXPANDTABS or DT_SINGLELINE or
        {$IFDEF DELPHI_2009_UP}
          VerticalAlignments[VerticalAlignment] or
        {$ENDIF}
        Alignments[Alignment];
      Flags := DrawTextBiDiModeFlags(Flags);
      {$IFDEF DELPHI_2009_UP}
      DrawText(Handle, Caption, -1, Rect, Flags);
      {$ELSE}
      DrawText(Handle, PAnsiChar(Caption), -1, Rect, Flags);
      {$ENDIF}
    end;
  end;
  DoPaint;
end;

{$IFDEF DELPHI_2009_UP}
//TUcFlowPanel
procedure TUcFlowPanel.AlignControls(AControl: TControl; var Rect: TRect);
var
  NewHeight: integer;
  t: Integer;
  i, j , FCIndex, cWidth, cTop, Delta: integer;

begin
  inherited;
  if FAutoHeight and not Self.AutoSize then begin
    NewHeight := 0;
    for i := 0 to Self.ControlCount - 1 do begin
      t := Self.Controls[i].BoundsRect.Bottom + 1;
      if t > NewHeight then NewHeight := t;
    end;
    if NewHeight < FAutoMinHeight then NewHeight := FAutoMinHeight;
    Self.ClientHeight := NewHeight;
  end;

  if FCenterControls and (Self.ControlCount > 0) then
    begin
      FCIndex := 0;
      cTop := Self.Controls[0].BoundsRect.Top;
      for i := 0 to Self.ControlCount - 1 do
        begin
          if (i > 0) and (Self.Controls[i].BoundsRect.Top > cTop) then
            begin
              cWidth := Self.Controls[i-1].BoundsRect.Right - Self.Controls[FCIndex].BoundsRect.Left;
              Delta := (Self.ClientWidth - cWidth) div 2;

              for j := FCIndex to i - 1 do
                Self.Controls[j].Left := Self.Controls[j].Left + Delta;

              FCIndex := i;
              cTop := Self.Controls[i].BoundsRect.Top;
            end;
        end;

      if FCIndex <= (Self.ControlCount - 1) then
        begin
          cWidth := Self.Controls[Self.ControlCount - 1].BoundsRect.Right - Self.Controls[FCIndex].BoundsRect.Left;
          Delta := (Self.ClientWidth - cWidth) div 2;

          for j := FCIndex to Self.ControlCount - 1 do
            Self.Controls[j].Left := Self.Controls[j].Left + Delta;
        end;
    end;
end;

constructor TUcFlowPanel.Create(AOwner: TComponent);
begin
  inherited;
  Self.FAutoMinHeight := 8;
  Self.FAutoHeight := True;
  FCenterControls := False;
end;

procedure TUcFlowPanel.SetAutoHeight(const Value: Boolean);
begin
  FAutoHeight := Value;
  Realign;
end;

procedure TUcFlowPanel.SetAutoMinHeight(const Value: Integer);
begin
  FAutoMinHeight := Value;
  Realign;
end;
{$ENDIF}

end.
