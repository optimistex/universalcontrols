unit UcNetscapeSplitter;
{$include ..\delphi_ver.inc}

interface

uses
  SysUtils, Classes,
  Windows, Messages, Graphics, Forms, ExtCtrls, Controls;

const
  MOVEMENT_TOLERANCE = 5; // See WMLButtonUp message handler.
  JvDefaultButtonHighlightColor = TColor($00FFCFCF); // RGB(207,207,255)
  CM_DENYSUBCLASSING = CM_BASE + 2000; // from ThemeMgr.pas

type
  TUcButtonWidthKind = (btwPixels, btwPercentage);
  TUcButtonStyle = (bsNetscape, bsWindows);
  TUcWindowsButton = (wbMin, wbMax, wbClose);
  TUcWindowsButtons = set of TUcWindowsButton;

  TUcCustomNetscapeSplitter = class(TSplitter)
  private
    FMouseOver: Boolean;
    FHintWindowClass: THintWindowClass;
    FBusy: Boolean;
    FShowButton: Boolean;
    FButtonWidthKind: TUcButtonWidthKind;
    FButtonWidth: Integer;
    FOnMaximize: TNotifyEvent;
    FOnMinimize: TNotifyEvent;
    FOnRestore: TNotifyEvent;
    FMaximized: Boolean;
    FMinimized: Boolean;
    // Internal use for "restoring" from "maximized" state
    FRestorePos: Integer;
    // For internal use to avoid calling GetButtonRect when not necessary
    FLastKnownButtonRect: TRect;
    // Internal use to avoid unecessary painting
    FIsHighlighted: Boolean;
    // Internal for detecting real clicks
    FGotMouseDown: Boolean;
    FButtonColor: TColor;
    FButtonHighlightColor: TColor;
    FArrowColor: TColor;
    FTextureColor1: TColor;
    FTextureColor2: TColor;
    FAutoHighlightColor: Boolean;
    FAllowDrag: Boolean;
    FButtonStyle: TUcButtonStyle;
    FWindowsButtons: TUcWindowsButtons;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnParentColorChanged: TNotifyEvent;
    FOnClose: TNotifyEvent;
    FButtonCursor: TCursor;
    function BaseWndProc(Msg: Integer; WParam: Integer = 0; LParam: Longint = 0): Integer; overload;
    function BaseWndProc(Msg: Integer; WParam: Integer; LParam: TControl): Integer; overload;
    function BaseWndProcEx(Msg: Integer; WParam: Integer; var LParam): Integer;
    procedure SetShowButton(const Value: Boolean);
    procedure SetButtonWidthKind(const Value: TUcButtonWidthKind);
    procedure SetButtonWidth(const Value: Integer);
    function GetButtonRect: TRect;
    procedure SetMaximized(const Value: Boolean);
    procedure SetMinimized(const Value: Boolean);
    function GetAlign: TAlign;
    procedure SetAlign(Value: TAlign);
    procedure SetArrowColor(const Value: TColor);
    procedure SetButtonColor(const Value: TColor);
    procedure SetButtonHighlightColor(const Value: TColor);
    procedure SetButtonStyle(const Value: TUcButtonStyle);
    procedure SetTextureColor1(const Value: TColor);
    procedure SetTextureColor2(const Value: TColor);
    procedure SetAutoHighlightColor(const Value: Boolean);
    procedure SetAllowDrag(const Value: Boolean);
    procedure SetWindowsButtons(const Value: TUcWindowsButtons);
    procedure SetButtonCursor(const Value: TCursor);
    function GetVersion: TCaption;
    procedure SetVersion(Value: TCaption);
  protected
    // Internal use for moving splitter position with FindControl and
    // UpdateControlSize
    FControl: TControl;
    FDownPos: TPoint;
    procedure WndProc(var Msg: TMessage); override;
    procedure FocusChanged(AControl: TWinControl);
    procedure VisibleChanged; reintroduce; dynamic;
    procedure EnabledChanged; reintroduce; dynamic;
    procedure TextChanged; reintroduce; virtual;
    procedure ColorChanged; reintroduce; dynamic;
    procedure FontChanged; reintroduce; dynamic;
    procedure ParentFontChanged; reintroduce; dynamic;
    procedure ParentColorChanged; reintroduce; dynamic;
    procedure ParentShowHintChanged; reintroduce; dynamic;
    property MouseOver: Boolean read FMouseOver write FMouseOver;
    procedure MouseEnter(Control: TControl);
    procedure MouseLeave(Control: TControl);
    function WantKey(Key: Integer; Shift: TShiftState; const KeyText: WideString): Boolean; reintroduce; virtual;
    function HintShow(var HintInfo: THintInfo): Boolean; reintroduce; dynamic;
    function HitTest(X, Y: Integer): Boolean; reintroduce; virtual;
    procedure Paint; override;
    procedure WMLButtonDown(var Msg: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Msg: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMMouseMove(var Msg: TWMMouseMove); message WM_MOUSEMOVE;
    procedure LoadOtherProperties(Reader: TReader); dynamic;
    procedure StoreOtherProperties(Writer: TWriter); dynamic;
    procedure DefineProperties(Filer: TFiler); override;
    function DoCanResize(var NewSize: Integer): Boolean; override;
    procedure Loaded; override;
    procedure PaintButton(Highlight: Boolean); dynamic;
    function DrawArrow(ACanvas: TCanvas; AvailableRect: TRect; Offset: Integer;
      ArrowSize: Integer; Color: TColor): Integer; dynamic;
    function WindowButtonHitTest(X, Y: Integer): TUcWindowsButton; dynamic;
    function ButtonHitTest(X, Y: Integer): Boolean; dynamic;
    procedure DoMaximize; dynamic;
    procedure DoMinimize; dynamic;
    procedure DoRestore; dynamic;
    procedure DoClose; dynamic;
    procedure FindControl; dynamic;
    procedure UpdateControlSize(NewSize: Integer); dynamic;
    function GrabBarColor: TColor;
    function VisibleWinButtons: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property ButtonRect: TRect read GetButtonRect;
    property RestorePos: Integer read FRestorePos write FRestorePos;
    property Maximized: Boolean read FMaximized write SetMaximized;
    property Minimized: Boolean read FMinimized  write SetMinimized;
    property AllowDrag: Boolean read FAllowDrag write SetAllowDrag default True;
    property ButtonCursor: TCursor read FButtonCursor write SetButtonCursor;
    property ButtonStyle: TUcButtonStyle read FButtonStyle write SetButtonStyle default bsNetscape;
    property WindowsButtons: TUcWindowsButtons read FWindowsButtons write SetWindowsButtons
      default [wbMin, wbMax, wbClose];
    property ButtonWidthKind: TUcButtonWidthKind read FButtonWidthKind write SetButtonWidthKind
      default btwPixels;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth default 100;
    property ShowButton: Boolean read FShowButton write SetShowButton default True;
    property ButtonColor: TColor read FButtonColor write SetButtonColor default clBtnFace;
    property ArrowColor: TColor read FArrowColor write SetArrowColor default clNavy;
    property ButtonHighlightColor: TColor read FButtonHighlightColor write SetButtonHighlightColor
      default JvDefaultButtonHighlightColor;
    property AutoHighlightColor: Boolean read FAutoHighlightColor write SetAutoHighlightColor
      default False;
    property TextureColor1: TColor read FTextureColor1 write SetTextureColor1 default clWhite;
    property TextureColor2: TColor read FTextureColor2 write SetTextureColor2 default clNavy;
    property Align: TAlign read GetAlign write SetAlign; // Need to know when it changes to redraw arrows
    property Width default 10; // it looks best with 10
    property Beveled default False; // it looks best without the bevel
    property Enabled;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnMaximize: TNotifyEvent read FOnMaximize write FOnMaximize;
    property OnMinimize: TNotifyEvent read FOnMinimize write FOnMinimize;
    property OnRestore: TNotifyEvent read FOnRestore write FOnRestore;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
  published
    property Version: TCaption read GetVersion write SetVersion stored False;
  end;

  TUcNetscapeSplitter = class(TUcCustomNetscapeSplitter)
  published
    property Version;
    property Maximized;
    property Minimized;
    property AllowDrag;
    property ButtonCursor;
    property ButtonStyle;
    property WindowsButtons;
    property ButtonWidthKind;
    property ButtonWidth;
    property ShowButton;
    property ButtonColor;
    property ArrowColor;
    property ButtonHighlightColor;
    property AutoHighlightColor;
    property TextureColor1;
    property TextureColor2;
    property Align;
    property Width;
    property Beveled;
    property Enabled;
    property ShowHint;
    property OnClose;
    property OnMaximize;
    property OnMinimize;
    property OnRestore;
{$IFDEF DELPHI_2009_UP}
    property OnMouseEnter;
    property OnMouseLeave;
{$ENDIF}
    property OnParentColorChange;
  end;

  function CreateWMMessage(Msg: Integer; WParam: Integer; LParam: Longint): TMessage; overload; {$IFDEF SUPPORTS_INLINE} inline {$ENDIF}
  function CreateWMMessage(Msg: Integer; WParam: Integer; LParam: TControl): TMessage; overload; {$IFDEF SUPPORTS_INLINE} inline {$ENDIF}

procedure Register;

implementation

{$R *.dcr}
{$Include ..\Versions.ucver}

procedure Register;
begin
  RegisterComponents('UControls', [TUcNetscapeSplitter]);
end;

function DispatchIsDesignMsg(Control: TControl; var Msg: TMessage): Boolean;
var
  Form: TCustomForm;
begin
  Result := False;
  case Msg.Msg of
    WM_SETFOCUS, WM_KILLFOCUS, WM_NCHITTEST,
    WM_MOUSEFIRST..WM_MOUSELAST,
    WM_KEYFIRST..WM_KEYLAST,
    WM_CANCELMODE:
      Exit; // These messages are handled in TWinControl.WndProc before IsDesignMsg() is called
  end;
  if (Control <> nil) and (csDesigning in Control.ComponentState) then
  begin
    Form := GetParentForm(Control);
    if (Form <> nil) and (Form.Designer <> nil) and
       Form.Designer.IsDesignMsg(Control, Msg) then
      Result := True;
  end;
end;

procedure SetRectEmpty(var R: TRect);
begin
  FillChar(R, SizeOf(TRect), #0);
end;

constructor TUcCustomNetscapeSplitter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  IncludeThemeStyle(Self, [csParentBackground]);

  Beveled := False;
  FAllowDrag := True;
  FButtonStyle := bsNetscape;
  FWindowsButtons := [wbMin, wbMax, wbClose];
  FButtonWidthKind := btwPixels;
  FButtonWidth := 100;
  FShowButton := True;
  SetRectEmpty(FLastKnownButtonRect);
  FIsHighlighted := False;
  FGotMouseDown := False;
  FControl := nil;
  FDownPos := Point(0, 0);
  FMaximized := False;
  FMinimized := False;
  FRestorePos := -1;
  Width := 10;
  FButtonColor := clBtnFace;
  FArrowColor := clNavy;
  FButtonHighlightColor := JvDefaultButtonHighlightColor;
  FAutoHighlightColor := False;
  FTextureColor1 := clWhite;
  FTextureColor2 := clNavy;
end;

type
 { Add IJvDenySubClassing to the base class list if the control should not
    be themed by the ThemeManager (http://www.soft-gems.net Mike Lischke).
    This only works with JvExVCL derived classes. }
  IJvDenySubClassing = interface
    ['{76942BC0-2A6E-4DC4-BFC9-8E110DB7F601}']
  end;

  TStructPtrMessage = class(TObject)
  private
  public
    Msg: TMessage;
    constructor Create(Msg: Integer; WParam: Integer; var LParam);
  end;

constructor TStructPtrMessage.Create(Msg: Integer; WParam: Integer; var LParam);
begin
  inherited Create;
  Self.Msg.Msg := Msg;
  Self.Msg.WParam := WParam;
  Self.Msg.LParam := Longint(@LParam);
  Self.Msg.Result := 0;
end;

procedure TUcCustomNetscapeSplitter.WndProc(var Msg: TMessage);
begin
  if not DispatchIsDesignMsg(Self, Msg) then
  case Msg.Msg of
    CM_DENYSUBCLASSING:
      Msg.Result := Ord(GetInterfaceEntry(IJvDenySubClassing) <> nil);
    CM_DIALOGCHAR:
      with TCMDialogChar{$IFDEF CLR}.Create{$ENDIF}(Msg) do
        Result := Ord(WantKey(CharCode, KeyDataToShiftState(KeyData), WideChar(CharCode)));
    CM_HINTSHOW:
      with TCMHintShow(Msg) do
        Result := Integer(HintShow(HintInfo^));
    CM_HITTEST:
      with TCMHitTest(Msg) do
        Result := Integer(HitTest(XPos, YPos));
    CM_MOUSEENTER:
      MouseEnter(TControl(Msg.LParam));
    CM_MOUSELEAVE:
      MouseLeave(TControl(Msg.LParam));
    CM_VISIBLECHANGED:
      VisibleChanged;
    CM_ENABLEDCHANGED:
      EnabledChanged;
    CM_TEXTCHANGED:
      TextChanged;
    CM_FONTCHANGED:
      FontChanged;
    CM_COLORCHANGED:
      ColorChanged;
    CM_FOCUSCHANGED:
      FocusChanged(TWinControl(Msg.LParam));
    CM_PARENTFONTCHANGED:
      ParentFontChanged;
    CM_PARENTCOLORCHANGED:
      ParentColorChanged;
    CM_PARENTSHOWHINTCHANGED:
      ParentShowHintChanged;
  else
    inherited WndProc(Msg);
  end;
end;

procedure TUcCustomNetscapeSplitter.FocusChanged(AControl: TWinControl);
begin
  BaseWndProc(CM_FOCUSCHANGED, 0, AControl);
end;

procedure TUcCustomNetscapeSplitter.VisibleChanged;
begin
  BaseWndProc(CM_VISIBLECHANGED);
end;

procedure TUcCustomNetscapeSplitter.EnabledChanged;
begin
  BaseWndProc(CM_ENABLEDCHANGED);
end;

procedure TUcCustomNetscapeSplitter.TextChanged;
begin
  BaseWndProc(CM_TEXTCHANGED);
end;

procedure TUcCustomNetscapeSplitter.FontChanged;
begin
  BaseWndProc(CM_FONTCHANGED);
end;

procedure TUcCustomNetscapeSplitter.ColorChanged;
begin
  BaseWndProc(CM_COLORCHANGED);
end;

procedure TUcCustomNetscapeSplitter.ParentFontChanged;
begin
  BaseWndProc(CM_PARENTFONTCHANGED);
end;

procedure TUcCustomNetscapeSplitter.ParentColorChanged;
begin
  BaseWndProc(CM_PARENTCOLORCHANGED);
  if Assigned(OnParentColorChange) then
    OnParentColorChange(Self);
end;

procedure TUcCustomNetscapeSplitter.ParentShowHintChanged;
begin
  BaseWndProc(CM_PARENTSHOWHINTCHANGED);
end;

procedure TUcCustomNetscapeSplitter.MouseEnter(Control: TControl);
var
  Pos: TPoint;
begin
  if csDesigning in ComponentState then
    Exit;

  if not MouseOver then
  begin
      FMouseOver := True;
      if Assigned(FOnMouseEnter) then
      FOnMouseEnter(Self);
      BaseWndProc(CM_MOUSEENTER, 0, Control);

      //inherited MouseEnter(Control);

    //from dfs
    GetCursorPos(Pos); // CM_MOUSEENTER doesn't send mouse pos.
    Pos := Self.ScreenToClient(Pos);
    // The order is important here.  ButtonHitTest must be evaluated before
    // the ButtonStyle because it will change the cursor (over button or not).
    // If the order were reversed, the cursor would not get set for bsWindows
    // style since short-circuit Boolean eval would stop it from ever being
    // called in the first place.
    if ButtonHitTest(Pos.X, Pos.Y) and (ButtonStyle = bsNetscape) then
    begin
      if not FIsHighlighted then
        PaintButton(True)
    end
    else
    if FIsHighlighted then
      PaintButton(False);
  end;
end;

procedure TUcCustomNetscapeSplitter.MouseLeave(Control: TControl);
begin
  if MouseOver then
  begin
    FMouseOver := False;
    BaseWndProc(CM_MOUSELEAVE, 0, Control);
    if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
    //inherited MouseLeave(Control);

    //from dfs
    if (ButtonStyle = bsNetscape) and FIsHighlighted then
      PaintButton(False);

    FGotMouseDown := False;
  end;
end;

function ShiftStateToKeyData(Shift: TShiftState): Longint;
const
  AltMask = $20000000;
  CtrlMask = $10000000;
  ShiftMask = $08000000;
begin
  Result := 0;
  if ssAlt in Shift then
    Result := Result or AltMask;
  if ssCtrl in Shift then
    Result := Result or CtrlMask;
  if ssShift in Shift then
    Result := Result or ShiftMask;
end;

function TUcCustomNetscapeSplitter.WantKey(Key: Integer; Shift: TShiftState; const KeyText: WideString): Boolean;
begin
  Result := BaseWndProc(CM_DIALOGCHAR, Word(Key), ShiftStateToKeyData(Shift)) <> 0;
end;

function TUcCustomNetscapeSplitter.HintShow(var HintInfo: THintInfo): Boolean;
begin
  HintInfo.HintColor := Application.HintColor;
  if FHintWindowClass <> nil then
    HintInfo.HintWindowClass := FHintWindowClass;
  Result := BaseWndProcEx(CM_HINTSHOW, 0, HintInfo) <> 0;
end;

function SmallPointToLong(const Pt: TSmallPoint): Longint;
begin
  Result := Longint(Pt);
end;

function TUcCustomNetscapeSplitter.HitTest(X, Y: Integer): Boolean;
begin
  Result := BaseWndProc(CM_HITTEST, 0, SmallPointToLong(PointToSmallPoint(Point(X, Y)))) <> 0;
end;

procedure TUcCustomNetscapeSplitter.Paint;
{$IFDEF JVCLThemesEnabled}
var
  Bmp: TBitmap;
  DC: THandle;
{$ENDIF JVCLThemesEnabled}
begin
  if FBusy then
    Exit;
  FBusy := True;
  try
    // Exclude button rect from update region here for less flicker.
    {$IFDEF JVCLThemesEnabled}
    if ThemeServices.ThemesEnabled then
    begin
      // DrawThemedBackground(Self, Canvas, ClientRect, Parent.Brush.Color);
      DC := Canvas.Handle;
      Bmp := TBitmap.Create;
      try
        Bmp.Width := ClientWidth;
        Bmp.Height := ClientHeight;
        Canvas.Handle := Bmp.Canvas.Handle;
        try
          inherited Paint;
        finally
          Canvas.Handle := DC;
        end;
        Bmp.Transparent := True;
        Bmp.TransparentColor := Color;
        Canvas.Draw(0, 0, Bmp);
      finally
        Bmp.Free;
      end;
    end
    else
      inherited Paint;
    {$ELSE}
    inherited Paint;
    {$ENDIF JVCLThemesEnabled}

    // Don't paint while being moved unless ResizeStyle = rsUpdate!!!
    // Make rect smaller if Beveled is True.
    PaintButton(FIsHighlighted);
  finally
    FBusy := False;
  end;
end;


//dfs

function TUcCustomNetscapeSplitter.ButtonHitTest(X, Y: Integer): Boolean;
begin
  // We use FLastKnownButtonRect here so that we don't have to recalculate the
  // button rect with GetButtonRect every time the mouse moved.  That would be
  // EXTREMELY inefficient.
  Result := PtInRect(FLastKnownButtonRect, Point(X, Y));
  if Align in [alLeft, alRight] then
  begin
    if (not AllowDrag) or ((Y >= FLastKnownButtonRect.Top) and
      (Y <= FLastKnownButtonRect.Bottom)) then
      Windows.SetCursor(Screen.Cursors[ButtonCursor])
    else
      Windows.SetCursor(Screen.Cursors[Cursor]);
  end
  else
  begin
    if (not AllowDrag) or ((X >= FLastKnownButtonRect.Left) and
      (X <= FLastKnownButtonRect.Right)) then
      Windows.SetCursor(Screen.Cursors[ButtonCursor])
    else
      Windows.SetCursor(Screen.Cursors[Cursor]);
  end;
end;

procedure TUcCustomNetscapeSplitter.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('RestorePos', LoadOtherProperties, StoreOtherProperties,
    Minimized or Maximized);
end;

function TUcCustomNetscapeSplitter.DoCanResize(var NewSize: Integer): Boolean;
begin
  Result := inherited DoCanResize(NewSize);
  // D4 version has a bug that causes it to not honor MinSize, which causes a
  // really nasty problem.
  if Result and (NewSize < MinSize) then
    NewSize := MinSize;
end;

procedure TUcCustomNetscapeSplitter.DoClose;
begin
  if Assigned(FOnClose) then
    FOnClose(Self);
end;

procedure TUcCustomNetscapeSplitter.DoMaximize;
begin
  if Assigned(FOnMaximize) then
    FOnMaximize(Self);
end;

procedure TUcCustomNetscapeSplitter.DoMinimize;
begin
  if Assigned(FOnMinimize) then
    FOnMinimize(Self);
end;

procedure TUcCustomNetscapeSplitter.DoRestore;
begin
  if Assigned(FOnRestore) then
    FOnRestore(Self);
end;

function TUcCustomNetscapeSplitter.DrawArrow(ACanvas: TCanvas; AvailableRect: TRect;
  Offset, ArrowSize: Integer; Color: TColor): Integer;
var
  X, Y, Q, I, J: Integer;
  ArrowAlign: TAlign;
begin
  // STB Nitro drivers have a LineTo bug, so I've opted to use the slower
  // SetPixel method to draw the arrows.

  if not Odd(ArrowSize) then
    Dec(ArrowSize);
  if ArrowSize < 1 then
    ArrowSize := 1;

  if FMaximized then
  begin
    case Align of
      alLeft:
        ArrowAlign := alRight;
      alRight:
        ArrowAlign := alLeft;
      alTop:
        ArrowAlign := alBottom;
    else //alBottom
      ArrowAlign := alTop;
    end;
  end
  else
    ArrowAlign := Align;
  Q := ArrowSize * 2 - 1;
  Result := Q;
  ACanvas.Pen.Color := Color;
  with AvailableRect do
  begin
    case ArrowAlign of
      alLeft:
        begin
          X := Left + ((Right - Left - ArrowSize) div 2) + 1;
          if Offset < 0 then
            Y := Bottom + Offset - Q
          else
            Y := Top + Offset;
          for J := X + ArrowSize - 1 downto X do
          begin
            for I := Y to Y + Q - 1 do
              ACanvas.Pixels[J, I] := Color;
            Inc(Y);
            Dec(Q, 2);
          end;
        end;
      alRight:
        begin
          X := Left + ((Right - Left - ArrowSize) div 2) + 1;
          if Offset < 0 then
            Y := Bottom + Offset - Q
          else
            Y := Top + Offset;
          for J := X to X + ArrowSize - 1 do
          begin
            for I := Y to Y + Q - 1 do
              ACanvas.Pixels[J, I] := Color;
            Inc(Y);
            Dec(Q, 2);
          end;
        end;
      alTop:
        begin
          if Offset < 0 then
            X := Right + Offset - Q
          else
            X := Left + Offset;
          Y := Top + ((Bottom - Top - ArrowSize) div 2) + 1;
          for I := Y + ArrowSize - 1 downto Y do
          begin
            for J := X to X + Q - 1 do
              ACanvas.Pixels[J, I] := Color;
            Inc(X);
            Dec(Q, 2);
          end;
        end;
    else // alBottom
      if Offset < 0 then
        X := Right + Offset - Q
      else
        X := Left + Offset;
      Y := Top + ((Bottom - Top - ArrowSize) div 2) + 1;
      for I := Y to Y + ArrowSize - 1 do
      begin
        for J := X to X + Q - 1 do
          ACanvas.Pixels[J, I] := Color;
        Inc(X);
        Dec(Q, 2);
      end;
    end;
  end;
end;

procedure TUcCustomNetscapeSplitter.FindControl;
var
  P: TPoint;
  I: Integer;
  R: TRect;
begin
  if Parent = nil then
    Exit;
  FControl := nil;
  P := Point(Left, Top);
  case Align of
    alLeft:
      Dec(P.X);
    alRight:
      Inc(P.X, Width);
    alTop:
      Dec(P.Y);
    alBottom:
      Inc(P.Y, Height);
  else
    Exit;
  end;
  for I := 0 to Parent.ControlCount - 1 do
  begin
    FControl := Parent.Controls[I];
    if FControl.Visible and FControl.Enabled then
    begin
      R := FControl.BoundsRect;
      if (R.Right - R.Left) = 0 then
        Dec(R.Left);
      if (R.Bottom - R.Top) = 0 then
        Dec(R.Top);
      if PtInRect(R, P) then
        Exit;
    end;
  end;
  FControl := nil;
end;

function TUcCustomNetscapeSplitter.GetAlign: TAlign;
begin
  Result := inherited Align;
end;

function TUcCustomNetscapeSplitter.GetButtonRect: TRect;
var
  BW: Integer;
begin
  if ButtonStyle = bsWindows then
  begin
    if Align in [alLeft, alRight] then
      BW := (ClientRect.Right - ClientRect.Left) * VisibleWinButtons
    else
      BW := (ClientRect.Bottom - ClientRect.Top) * VisibleWinButtons;
    if BW < 1 then
      SetRectEmpty(Result)
    else
    begin
      if Align in [alLeft, alRight] then
        Result := Rect(0, 0, ClientRect.Right - ClientRect.Left,
          BW - VisibleWinButtons)
      else
        Result := Rect(ClientRect.Right - BW + VisibleWinButtons, 0,
          ClientRect.Right, ClientRect.Bottom - ClientRect.Top);
      InflateRect(Result, -1, -1);
    end;
  end
  else
  begin
    // Calc the rectangle the button goes in
    if ButtonWidthKind = btwPercentage then
    begin
      if Align in [alLeft, alRight] then
        BW := ClientRect.Bottom - ClientRect.Top
      else
        BW := ClientRect.Right - ClientRect.Left;
      BW := MulDiv(BW, FButtonWidth, 100);
    end
    else
      BW := FButtonWidth;
    if BW < 1 then
      SetRectEmpty(Result)
    else
    begin
      Result := ClientRect;
      if Align in [alLeft, alRight] then
      begin
        Result.Top := (ClientRect.Bottom - ClientRect.Top - BW) div 2;
        Result.Bottom := Result.Top + BW;
        InflateRect(Result, -1, 0);
      end
      else
      begin
        Result.Left := (ClientRect.Right - ClientRect.Left - BW) div 2;
        Result.Right := Result.Left + BW;
        InflateRect(Result, 0, -1);
      end;
    end;
  end;
  if not IsRectEmpty(Result) then
  begin
    if Result.Top < 1 then
      Result.Top := 1;
    if Result.Left < 1 then
      Result.Left := 1;
    if Result.Bottom >= ClientRect.Bottom then
      Result.Bottom := ClientRect.Bottom - 1;
    if Result.Right >= ClientRect.Right then
      Result.Right := ClientRect.Right - 1;
    // Make smaller if it's beveled
    if Beveled then
      if Align in [alLeft, alRight] then
        InflateRect(Result, -3, 0)
      else
        InflateRect(Result, 0, -3);
  end;
  FLastKnownButtonRect := Result;
end;

function TUcCustomNetscapeSplitter.GrabBarColor: TColor;
var
  BeginRGB: array [0..2] of Byte;
  RGBDifference: array [0..2] of Integer;
  R, G, B: Byte;
  BeginColor, EndColor: TColor;
  NumberOfColors: Integer;
begin
  //Need to figure out how many colors available at runtime
  NumberOfColors := 256;

  BeginColor := clActiveCaption;
  EndColor := clBtnFace;

  BeginRGB[0] := GetRValue(ColorToRGB(BeginColor));
  BeginRGB[1] := GetGValue(ColorToRGB(BeginColor));
  BeginRGB[2] := GetBValue(ColorToRGB(BeginColor));

  RGBDifference[0] := GetRValue(ColorToRGB(EndColor)) - BeginRGB[0];
  RGBDifference[1] := GetGValue(ColorToRGB(EndColor)) - BeginRGB[1];
  RGBDifference[2] := GetBValue(ColorToRGB(EndColor)) - BeginRGB[2];

  R := BeginRGB[0] + MulDiv(180, RGBDifference[0], NumberOfColors - 1);
  G := BeginRGB[1] + MulDiv(180, RGBDifference[1], NumberOfColors - 1);
  B := BeginRGB[2] + MulDiv(180, RGBDifference[2], NumberOfColors - 1);

  Result := RGB(R, G, B);
end;

procedure TUcCustomNetscapeSplitter.Loaded;
begin
  inherited Loaded;
  if FRestorePos = -1 then
  begin
    FindControl;
    if FControl <> nil then
      case Align of
        alLeft, alRight:
          FRestorePos := FControl.Width;
        alTop, alBottom:
          FRestorePos := FControl.Height;
      end;
  end;
end;

procedure TUcCustomNetscapeSplitter.LoadOtherProperties(Reader: TReader);
begin
  RestorePos := Reader.ReadInteger;
end;

procedure TUcCustomNetscapeSplitter.PaintButton(Highlight: Boolean);
const
  TEXTURE_SIZE = 3;
var
  BtnRect: TRect;
  CaptionBtnRect: TRect;
  BW: Integer;
  TextureBmp: TBitmap;
  X, Y: Integer;
  RW, RH: Integer;
  OffscreenBmp: TBitmap;
  WinButton: array [0..2] of TUcWindowsButton;
  B: TUcWindowsButton;
  BtnFlag: UINT;
begin
  if (not FShowButton) or (not Enabled) or (GetParentForm(Self) = nil) then
    Exit;

  if FAutoHighlightColor then
    FButtonHighlightColor := GrabBarColor;

  BtnRect := ButtonRect; // So we don't repeatedly call GetButtonRect
  if IsRectEmpty(BtnRect) then
    Exit; // nothing to draw

  OffscreenBmp := TBitmap.Create;
  try
    OffsetRect(BtnRect, -BtnRect.Left, -BtnRect.Top);
    OffscreenBmp.Width := BtnRect.Right;
    OffscreenBmp.Height := BtnRect.Bottom;

    if ButtonStyle = bsWindows then
    begin
      OffscreenBmp.Canvas.Brush.Color := Color;
      OffscreenBmp.Canvas.FillRect(BtnRect);
      if Align in [alLeft, alRight] then
        BW := BtnRect.Right
      else
        BW := BtnRect.Bottom;
      FillChar(WinButton, SizeOf(WinButton), 0);
      X := 0;
      if Align in [alLeft, alRight] then
      begin
        for B := High(TUcWindowsButton) downto Low(TUcWindowsButton) do
          if B in WindowsButtons then
          begin
            WinButton[X] := B;
            Inc(X);
          end;
      end
      else
      begin
        for B := Low(TUcWindowsButton) to High(TUcWindowsButton) do
          if B in WindowsButtons then
          begin
            WinButton[X] := B;
            Inc(X);
          end;
      end;
      for X := 0 to VisibleWinButtons - 1 do
      begin
        if Align in [alLeft, alRight] then
          CaptionBtnRect := Bounds(0, X * BW, BW, BW)
        else
          CaptionBtnRect := Bounds(X * BW, 0, BW, BW);
        BtnFlag := 0;
        case WinButton[X] of
          wbMin:
            if Minimized then
              BtnFlag := DFCS_CAPTIONRESTORE
            else
              BtnFlag := DFCS_CAPTIONMIN;
          wbMax:
            if Maximized then
              BtnFlag := DFCS_CAPTIONRESTORE
            else
              BtnFlag := DFCS_CAPTIONMAX;
          wbClose:
            BtnFlag := DFCS_CAPTIONCLOSE;
        end;
        DrawFrameControl(OffscreenBmp.Canvas.Handle,
          CaptionBtnRect, DFC_CAPTION, BtnFlag);
      end;
    end
    else
    begin
      // Draw basic button
      OffscreenBmp.Canvas.Brush.Color := clGray;
      OffscreenBmp.Canvas.FrameRect(BtnRect);
      InflateRect(BtnRect, -1, -1);

      OffscreenBmp.Canvas.Pen.Color := clWhite;
      with BtnRect, OffscreenBmp.Canvas do
      begin
        // This is not going to work with the STB bug.  Have to find workaround.
        MoveTo(Left, Bottom - 1);
        LineTo(Left, Top);
        LineTo(Right, Top);
      end;
      Inc(BtnRect.Left);
      Inc(BtnRect.Top);

      if Highlight then
        OffscreenBmp.Canvas.Brush.Color := ButtonHighlightColor
      else
        OffscreenBmp.Canvas.Brush.Color := ButtonColor;
      OffscreenBmp.Canvas.FillRect(BtnRect);
      FIsHighlighted := Highlight;
      Dec(BtnRect.Right);
      Dec(BtnRect.Bottom);

      // Draw the insides of the button
      with BtnRect do
      begin
        // Draw the arrows
        if Align in [alLeft, alRight] then
        begin
          InflateRect(BtnRect, 0, -4);
          BW := BtnRect.Right - BtnRect.Left;
          DrawArrow(OffscreenBmp.Canvas, BtnRect, 1, BW, ArrowColor);
          BW := DrawArrow(OffscreenBmp.Canvas, BtnRect, -1, BW, ArrowColor);
          InflateRect(BtnRect, 0, -(BW + 4));
        end
        else
        begin
          InflateRect(BtnRect, -4, 0);
          BW := BtnRect.Bottom - BtnRect.Top;
          DrawArrow(OffscreenBmp.Canvas, BtnRect, 1, BW, ArrowColor);
          BW := DrawArrow(OffscreenBmp.Canvas, BtnRect, -1, BW, ArrowColor);
          InflateRect(BtnRect, -(BW + 4), 0);
        end;

        // Draw the texture
        // Note: This is so complex because I'm trying to make as much like the
        //       Netscape splitter as possible.  They use a 3x3 texture pattern, and
        //       that's harder to tile.  If the had used an 8x8 (or smaller
        //       divisibly, i.e. 2x2 or 4x4), I could have used Brush.Bitmap and
        //       FillRect and they whole thing would have been about half the size,
        //       twice as fast, and 1/10th as complex.
        RW := BtnRect.Right - BtnRect.Left;
        RH := BtnRect.Bottom - BtnRect.Top;
        if (RW >= TEXTURE_SIZE) and (RH >= TEXTURE_SIZE) then
        begin
          TextureBmp := TBitmap.Create;
          try
            with TextureBmp do
            begin
              Width := RW;
              Height := RH;
              // Draw first square
              Canvas.Brush.Color := OffscreenBmp.Canvas.Brush.Color;
              Canvas.FillRect(Rect(0, 0, RW + 1, RH + 1));
              Canvas.Pixels[1, 1] := TextureColor1;
              Canvas.Pixels[2, 2] := TextureColor2;

              // Tile first square all the way across
              for X := 1 to ((RW div TEXTURE_SIZE) + ord(RW mod TEXTURE_SIZE > 0)) do
                Canvas.CopyRect(Bounds(X * TEXTURE_SIZE, 0, TEXTURE_SIZE,
                  TEXTURE_SIZE), Canvas, Rect(0, 0, TEXTURE_SIZE, TEXTURE_SIZE));

              // Tile first row all the way down
              for Y := 1 to ((RH div TEXTURE_SIZE) + ord(RH mod TEXTURE_SIZE > 0)) do
                Canvas.CopyRect(Bounds(0, Y * TEXTURE_SIZE, RW, TEXTURE_SIZE),
                  Canvas, Rect(0, 0, RW, TEXTURE_SIZE));

              // Above could be better if it reversed process when splitter was
              // taller than it was wider.  Optimized only for horizontal right now.
            end;
            // Copy texture bitmap to the screen.
            OffscreenBmp.Canvas.CopyRect(BtnRect, TextureBmp.Canvas,
              Rect(0, 0, RW, RH));
          finally
            TextureBmp.Free;
          end;
        end;
      end;
    end;
(**)
    Canvas.CopyRect(ButtonRect, OffscreenBmp.Canvas, Rect(0, 0,
      OffscreenBmp.Width, OffscreenBmp.Height));
  finally
    OffscreenBmp.Free;
  end;
end;

procedure TUcCustomNetscapeSplitter.SetAlign(Value: TAlign);
begin
  if Align <> Value then
  begin
    inherited Align := Value;
    Invalidate; // Direction changing, redraw arrows.
  end;
end;

procedure TUcCustomNetscapeSplitter.SetAllowDrag(const Value: Boolean);
var
  Pt: TPoint;
begin
  if FAllowDrag <> Value then
  begin
    FAllowDrag := Value;
    // Have to reset cursor in case it's on the splitter at the moment
    GetCursorPos(Pt);
    Pt := ScreenToClient(Pt);
    ButtonHitTest(Pt.X, Pt.Y);
  end;
end;

procedure TUcCustomNetscapeSplitter.SetArrowColor(const Value: TColor);
begin
  if FArrowColor <> Value then
  begin
    FArrowColor := Value;
    if (ButtonStyle = bsNetscape) and ShowButton then
      Invalidate;
  end;
end;

procedure TUcCustomNetscapeSplitter.SetAutoHighlightColor(const Value: Boolean);
begin
  if FAutoHighlightColor <> Value then
  begin
    FAutoHighlightColor := Value;
    if FAutoHighlightColor then
      FButtonHighlightColor := GrabBarColor
    else
      FButtonHighlightColor := JvDefaultButtonHighlightColor;
    if (ButtonStyle = bsNetscape) and ShowButton then
      Invalidate;
  end;
end;

procedure TUcCustomNetscapeSplitter.SetButtonColor(const Value: TColor);
begin
  if FButtonColor <> Value then
  begin
    FButtonColor := Value;
    if (ButtonStyle = bsNetscape) and ShowButton then
      Invalidate;
  end;
end;

procedure TUcCustomNetscapeSplitter.SetButtonCursor(const Value: TCursor);
begin
  FButtonCursor := Value;
end;

function TUcCustomNetscapeSplitter.GetVersion: TCaption;
begin
  Result:= UcNetscapeSplitterVersion;
end;

procedure TUcCustomNetscapeSplitter.SetVersion(Value: TCaption);
begin

end;

procedure TUcCustomNetscapeSplitter.SetButtonHighlightColor(const Value: TColor);
begin
  if FButtonHighlightColor <> Value then
  begin
    FButtonHighlightColor := Value;
    if (ButtonStyle = bsNetscape) and ShowButton then
      Invalidate;
  end;
end;

procedure TUcCustomNetscapeSplitter.SetButtonStyle(const Value: TUcButtonStyle);
begin
  FButtonStyle := Value;
  if ShowButton then
    Invalidate;
end;

procedure TUcCustomNetscapeSplitter.SetButtonWidth(const Value: Integer);
begin
  if Value <> FButtonWidth then
  begin
    FButtonWidth := Value;
    if (ButtonWidthKind = btwPercentage) and (FButtonWidth > 100) then
      FButtonWidth := 100;
    if FButtonWidth < 0 then
      FButtonWidth := 0;
    if (ButtonStyle = bsNetscape) and ShowButton then
      Invalidate;
  end;
end;

procedure TUcCustomNetscapeSplitter.SetButtonWidthKind(const Value: TUcButtonWidthKind);
begin
  if Value <> FButtonWidthKind then
  begin
    FButtonWidthKind := Value;
    if (FButtonWidthKind = btwPercentage) and (ButtonWidth > 100) then
      FButtonWidth := 100;
    if (ButtonStyle = bsNetscape) and ShowButton then
      Invalidate;
  end;
end;

procedure TUcCustomNetscapeSplitter.SetMaximized(const Value: Boolean);
begin
  if Value <> FMaximized then
  begin
    if csLoading in ComponentState then
    begin
      FMaximized := Value;
      Exit;
    end;

    FindControl;
    if FControl = nil then
      Exit;

    if Value then
    begin
      if FMinimized then
        FMinimized := False
      else
      begin
        case Align of
          alLeft, alRight:
            FRestorePos := FControl.Width;
          alTop, alBottom:
            FRestorePos := FControl.Height;
        else
          Exit;
        end;
      end;
      if ButtonStyle = bsNetscape then
        UpdateControlSize(-3000)
      else
        case Align of
          alLeft, alBottom:
            UpdateControlSize(3000);
          alRight, alTop:
            UpdateControlSize(-3000);
        else
          Exit;
        end;
      FMaximized := Value;
      DoMaximize;
    end
    else
    begin
      UpdateControlSize(FRestorePos);
      FMaximized := Value;
      DoRestore;
    end;
  end;
end;

procedure TUcCustomNetscapeSplitter.SetMinimized(const Value: Boolean);
begin
  if Value <> FMinimized then
  begin
    if csLoading in ComponentState then
    begin
      FMinimized := Value;
      Exit;
    end;

    FindControl;
    if FControl = nil then
      Exit;

    if Value then
    begin
      if FMaximized then
        FMaximized := False
      else
      begin
        case Align of
          alLeft, alRight:
            FRestorePos := FControl.Width;
          alTop, alBottom:
            FRestorePos := FControl.Height;
        else
          Exit;
        end;
      end;
      FMinimized := Value;
      // Just use something insanely large to get it to move to the other extreme
      case Align of
        alLeft, alBottom:
          UpdateControlSize(-3000);
        alRight, alTop:
          UpdateControlSize(3000);
      else
        Exit;
      end;
      DoMinimize;
    end
    else
    begin
      FMinimized := Value;
      UpdateControlSize(FRestorePos);
      DoRestore;
    end;
  end;
end;

function CreateWMMessage(Msg: Integer; WParam: Integer; LParam: Longint): TMessage;
begin
  Result.Msg := Msg;
  Result.WParam := WParam;
  Result.LParam := LParam;
  Result.Result := 0;
end;

function CreateWMMessage(Msg: Integer; WParam: Integer; LParam: TControl): TMessage;
begin
  Result := CreateWMMessage(Msg, WParam, 0);
end;

function TUcCustomNetscapeSplitter.BaseWndProc(Msg: Integer; WParam: Integer = 0; LParam: Longint = 0): Integer;
var
  Mesg: TMessage;
begin
  Mesg := CreateWMMessage(Msg, WParam, LParam);
  inherited WndProc(Mesg);
  Result := Mesg.Result;
end;

function TUcCustomNetscapeSplitter.BaseWndProc(Msg: Integer; WParam: Integer; LParam: TControl): Integer;
var
  Mesg: TMessage;
begin
  Mesg := CreateWMMessage(Msg, WParam, LParam);
  inherited WndProc(Mesg);
  Result := Mesg.Result;
end;

function TUcCustomNetscapeSplitter.BaseWndProcEx(Msg: Integer; WParam: Integer; var LParam): Integer;
var
  Mesg: TStructPtrMessage;
begin
  Mesg := TStructPtrMessage.Create(Msg, WParam, LParam);
  try
    inherited WndProc(Mesg.Msg);
  finally
    Result := Mesg.Msg.Result;
    Mesg.Free;
  end;
end;

procedure TUcCustomNetscapeSplitter.SetShowButton(const Value: Boolean);
begin
  if Value <> FShowButton then
  begin
    FShowButton := Value;
    SetRectEmpty(FLastKnownButtonRect);
    Invalidate;
  end;
end;

procedure TUcCustomNetscapeSplitter.SetTextureColor1(const Value: TColor);
begin
  if FTextureColor1 <> Value then
  begin
    FTextureColor1 := Value;
    if (ButtonStyle = bsNetscape) and ShowButton then
      Invalidate;
  end;
end;

procedure TUcCustomNetscapeSplitter.SetTextureColor2(const Value: TColor);
begin
  if FTextureColor2 <> Value then
  begin
    FTextureColor2 := Value;
    if (ButtonStyle = bsNetscape) and ShowButton then
      Invalidate;
  end;
end;

procedure TUcCustomNetscapeSplitter.SetWindowsButtons(const Value: TUcWindowsButtons);
begin
  FWindowsButtons := Value;
  if (ButtonStyle = bsWindows) and ShowButton then
    Invalidate;
end;

procedure TUcCustomNetscapeSplitter.StoreOtherProperties(Writer: TWriter);
begin
  Writer.WriteInteger(RestorePos);
end;

procedure TUcCustomNetscapeSplitter.UpdateControlSize(NewSize: Integer);

  procedure MoveViaMouse(FromPos, ToPos: Integer; Horizontal: Boolean);
  begin
    if Horizontal then
    begin
      MouseDown(mbLeft, [ssLeft], FromPos, 0);
      MouseMove([ssLeft], ToPos, 0);
      MouseUp(mbLeft, [ssLeft], ToPos, 0);
    end
    else
    begin
      MouseDown(mbLeft, [ssLeft], 0, FromPos);
      MouseMove([ssLeft], 0, ToPos);
      MouseUp(mbLeft, [ssLeft], 0, ToPos);
    end;
  end;

var P: TPoint;
    NeedResetCursor: Boolean;
begin
  if FControl <> nil then
  begin
    { You'd think that using FControl directly would be the way to change it's
      position (and thus the splitter's position), wouldn't you?  But, TSplitter
      has this nutty idea that the only way a control's size will change is if
      the mouse moves the splitter.  If you size the control manually, the
      splitter has an internal variable (FOldSize) that will not get updated.
      Because of this, if you try to then move the newly positioned splitter
      back to the old position, it won't go there (NewSize <> OldSize must be
      True).  Now, what are the odds that the user will move the splitter back
      to the exact same pixel it used to be on?  Normally, extremely low.  But,
      if the splitter has been restored from it's minimized position, it then
      becomes quite likely:  i.e. they drag it back all the way to the min
      position.  What a pain. }


    Windows.GetCursorPos(P);
    P := ScreenToClient(P);
    NeedResetCursor := PtInRect(ButtonRect, P);
    case Align of
      alLeft:
        MoveViaMouse(Left, FControl.Left + NewSize, True);
              // alLeft: FControl.Width := NewSize;
      alTop:
        MoveViaMouse(Top, FControl.Top + NewSize, False);
             // FControl.Height := NewSize;
      alRight:
        MoveViaMouse(Left, (FControl.Left + FControl.Width - Width) - NewSize, True);
        {begin
          Parent.DisableAlign;
          try
            FControl.Left := FControl.Left + (FControl.Width - NewSize);
            FControl.Width := NewSize;
          finally
            Parent.EnableAlign;
          end;
        end;}
      alBottom:
        MoveViaMouse(Top, (FControl.Top + FControl.Height - Height) - NewSize, False);
        {begin
          Parent.DisableAlign;
          try
            FControl.Top := FControl.Top + (FControl.Height - NewSize);
            FControl.Height := NewSize;
          finally
            Parent.EnableAlign;
          end;
        end;}
    end;
    if NeedResetCursor then
    begin
      P := ClientToScreen(P);
      Windows.SetCursorPos(P.X, P.Y);
    end;

    Update;
  end;
end;

function TUcCustomNetscapeSplitter.VisibleWinButtons: Integer;
var
  X: TUcWindowsButton;
begin
  Result := 0;
  for X := Low(TUcWindowsButton) to High(TUcWindowsButton) do
    if X in WindowsButtons then
      Inc(Result);
end;

function TUcCustomNetscapeSplitter.WindowButtonHitTest(X, Y: Integer): TUcWindowsButton;
var
  BtnRect: TRect;
  I: Integer;
  B: TUcWindowsButton;
  WinButton: array [0..2] of TUcWindowsButton;
  BW: Integer;
  BRs: array [0..2] of TRect;
begin
  Result := wbMin;
  // Figure out which one was hit.  This function assumes ButtonHitTest has
  // been called and returned True.
  BtnRect := ButtonRect; // So we don't repeatedly call GetButtonRect
  I := 0;
  if Align in [alLeft, alRight] then
  begin
    for B := High(TUcWindowsButton) downto Low(TUcWindowsButton) do
      if B in WindowsButtons then
      begin
        WinButton[I] := B;
        Inc(I);
      end;
  end
  else
    for B := Low(TUcWindowsButton) to High(TUcWindowsButton) do
      if B in WindowsButtons then
      begin
        WinButton[I] := B;
        Inc(I);
      end;

  if Align in [alLeft, alRight] then
    BW := BtnRect.Right - BtnRect.Left
  else
    BW := BtnRect.Bottom - BtnRect.Top;
  FillChar(BRs, SizeOf(BRs), 0);
  for I := 0 to VisibleWinButtons - 1 do
    if ((Align in [alLeft, alRight]) and PtInRect(Bounds(BtnRect.Left,
      BtnRect.Top + (BW * I), BW, BW), Point(X, Y))) or ((Align in [alTop,
      alBottom]) and PtInRect(Bounds(BtnRect.Left + (BW * I), BtnRect.Top, BW,
        BW), Point(X, Y))) then
    begin
      Result := WinButton[I];
      break;
    end;
end;

procedure TUcCustomNetscapeSplitter.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if FRestorePos < 0 then
  begin
    FindControl;
    if FControl <> nil then
      case Align of
        alLeft, alRight:
          FRestorePos := FControl.Width;
        alTop, alBottom:
          FRestorePos := FControl.Height;
      end;
  end;
end;



procedure TUcCustomNetscapeSplitter.WMLButtonDown(var Msg: TWMLButtonDown);
begin
  if Enabled then
  begin
    FGotMouseDown := ButtonHitTest(Msg.XPos, Msg.YPos);
    if FGotMouseDown then
    begin
      FindControl;
      FDownPos := ClientToScreen(Point(Msg.XPos, Msg.YPos));
    end;
  end;
  if AllowDrag then
    inherited // Let TSplitter have it.
  else
    // Bypass TSplitter and just let normal handling occur. Prevents drag painting.
    DefaultHandler(Msg);
end;

procedure TUcCustomNetscapeSplitter.WMLButtonUp(var Msg: TWMLButtonUp);
var
  CurPos: TPoint;
  OldMax: Boolean;
begin
  inherited;

  if FGotMouseDown then
  begin
    if ButtonHitTest(Msg.XPos, Msg.YPos) then
    begin
      CurPos := ClientToScreen(Point(Msg.XPos, Msg.YPos));
      // More than a little movement is not a click, but a regular resize.
      if ((Align in [alLeft, alRight]) and
        (Abs(FDownPos.X - CurPos.X) <= MOVEMENT_TOLERANCE)) or
        ((Align in [alTop, alBottom]) and
        (Abs(FDownPos.Y - CurPos.Y) <= MOVEMENT_TOLERANCE)) then
      begin
        StopSizing;
        if ButtonStyle = bsNetscape then
          Maximized := not Maximized
        else
          case WindowButtonHitTest(Msg.XPos, Msg.YPos) of
            wbMin:
              Minimized := not Minimized;
            wbMax:
              Maximized := not Maximized;
            wbClose:
              DoClose;
          end;
      end;
    end;
    FGotMouseDown := False;
  end
  else
    if AllowDrag then
  begin
    FindControl;
    if FControl = nil then
      Exit;

    OldMax := FMaximized;
    case Align of
      alLeft, alRight:
        FMaximized := FControl.Width <= MinSize;
      alTop, alBottom:
        FMaximized := FControl.Height <= MinSize;
    end;
    if FMaximized then
    begin
      UpdateControlSize(MinSize);
      if not OldMax then
        DoMaximize;
    end
    else
    begin
      case Align of
        alLeft, alRight:
          FRestorePos := FControl.Width;
        alTop, alBottom:
          FRestorePos := FControl.Height;
      end;
      if OldMax then
        DoRestore;
    end;
  end;
  Invalidate;
end;

procedure TUcCustomNetscapeSplitter.WMMouseMove(var Msg: TWMMouseMove);
begin
  if AllowDrag then
  begin
    inherited;
  end
  else
  begin
    DefaultHandler(Msg); // Bypass TSplitter and just let normal handling occur.
  end;

  // Mantis 3718: The button is always highlighted whatever value AllowDrag is.

  // The order is important here.  ButtonHitTest must be evaluated before
  // the ButtonStyle because it will change the cursor (over button or not).
  // If the order were reversed, the cursor would not get set for bsWindows
  // style since short-circuit Boolean eval would stop it from ever being
  // called in the first place.
  if ButtonHitTest(Msg.XPos, Msg.YPos) and (ButtonStyle = bsNetscape) then
  begin
    if not FIsHighlighted then
      PaintButton(True)
  end
  else
  if FIsHighlighted then
    PaintButton(False);
end;



{$IFDEF UNITVERSIONING}
initialization
//  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
//  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.
