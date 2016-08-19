unit UcButtons;
{$include ..\delphi_ver.inc}
//todo -o: Сброшен атрибут "Только чтение"

interface

uses
{$IF DEFINED(CLR)}
  System.ComponentModel.Design.Serialization,
{$IFEND}
{$IF DEFINED(LINUX)}
  WinUtils,
{$IFEND}
  Dialogs, Messages, CommCtrl, Windows, SysUtils, Classes, ActnList, Themes, StdCtrls,
  Controls, Forms, Graphics, ImgList, UxTheme,
{$IFNDEF DELPHI_2009_UP}
  ucCompatibilityD7withD2010,
{$ENDIF}
  ucTypes, ucHint, ucFunctions, ucSkin, ucGraphics;

type
  TButtonImages = class;
  TCaptionPositions = class;

  IUcButton = interface
    function  GetAllowAllUp: Boolean;
    procedure SetAllowAllUp(Value: Boolean);
    function  GetDown: Boolean;
    procedure SetDown(Value: Boolean);
    function  GetGroupIndex: Integer;
    procedure SetGroupIndex(Value: Integer);
    function  GetImages: TButtonImages;
    procedure SetImages(Value: TButtonImages);
    function  GetBtnImages: TCustomImageList;
    procedure SetBtnImages(Value: TCustomImageList);
    function  GetSkinManager: TUcSkinManager;
    procedure SetSkinManager(const Value: TUcSkinManager);
    function  GetControlStyle: TControlStyle;
    function  GetClientRect: TRect;
    procedure SetControlStyle(Value: TControlStyle);
    function  GetCaption: TCaption;
    procedure SetCaption(Value: TCaption);
    function  GetState: TButtonState;
    procedure SetState(const Value: TButtonState);
    function  GetFlat: Boolean;
    procedure SetFlat(const Value: Boolean);
    function  GetButtonStyle: TButtonStyle;
    procedure SetButtonStyle(const Value: TButtonStyle);
    function  GetEnabled: Boolean;
    procedure SetEnabled(Value: Boolean);
    function  GetFont_: TFont;
    procedure SetFont_(const Value: TFont);
    function  GetComponentState: TComponentState;
    function  GetCaptionPositions: TCaptionPositions;
    procedure SetCaptionPositions(const Value: TCaptionPositions);
    function  GetMouseInControl: Boolean;
    procedure SetMouseInControl(const Value: Boolean);
    function GetDragMode: TDragMode;
    procedure SetDragMode(Value: TDragMode);
    function GetDragging: Boolean;
    procedure SetDragging(const Value: Boolean);
    function GetShowCaption: Boolean;
    procedure SetShowCaption(const Value: Boolean);

    function  GetCanvas: TCanvas;
    //---
    procedure DoResize(Sender: TObject);
    function  SelfObj: TControl;
    function  GetWidth: Integer;
    function  GetHeight: Integer;
    procedure Invalidate;
    procedure Repaint;
    procedure DoPaint;
    //--
    property State: TButtonState read GetState write SetState;
    property Flat: Boolean read GetFlat write SetFlat;
    property ButtonStyle: TButtonStyle read GetButtonStyle write SetButtonStyle;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Font: TFont read GetFont_ write SetFont_;
    property ComponentState: TComponentState read GetComponentState;
    property CaptionPositions: TCaptionPositions read GetCaptionPositions
                                                 write SetCaptionPositions;
    //---
    property MouseInControl: Boolean read GetMouseInControl write SetMouseInControl;
    property DragMode: TDragMode read GetDragMode write SetDragMode;
    property Dragging_: Boolean read GetDragging write SetDragging;
    //--
    property AllowAllUp: Boolean read GetAllowAllUp write SetAllowAllUp;
    property Down: Boolean read GetDown write SetDown;
    property GroupIndex: Integer read GetGroupIndex write SetGroupIndex;
    property Images: TButtonImages read GetImages write SetImages;
    property BtnImages: TCustomImageList read GetBtnImages write SetBtnImages;
    property SkinManager: TUcSkinManager read GetSkinManager write SetSkinManager;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    property ControlStyle: TControlStyle read GetControlStyle write SetControlStyle;
    property ClientRect: TRect read GetClientRect;
    property Caption: TCaption read GetCaption write SetCaption;
    property Canvas: TCanvas read GetCanvas;
    property ShowCaption: Boolean read GetShowCaption write SetShowCaption;
  end;

  TUniversalButtonActionLink = class(TControlActionLink)
  protected
    FClient: IUcButton;
    procedure AssignClient(AClient: TObject); override;
    function IsCheckedLinked: Boolean; override;
    function IsGroupIndexLinked: Boolean; override;
    procedure SetGroupIndex(Value: Integer); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetChecked(Value: Boolean); override;
  end;

  TButtonImages = class (TPersistent)
  private
    FUp       : Pointer;
    FDisabled : Pointer;
    FDown     : Pointer;
    FHot      : Pointer;

    FIndexImgUp       : TImageIndex;
    FIndexImgDisabled : TImageIndex;
    FIndexImgDown     : TImageIndex;
    FIndexImgHot      : TImageIndex;

    FSkinUp       : TUcSkinPainter;
    FSkinDisabled : TUcSkinPainter;
    FSkinDown     : TUcSkinPainter;
    FSkinHot      : TUcSkinPainter;

    FPosLeft  : integer;
    FPosTop   : integer;
    FPosCenter: Boolean;
    FStretch  : Boolean;
    FTransparent: Boolean;
    FParentObj : IUcButton;
    FOnChangeImagesParams: TNotifyEvent;
    FSkinImgDown: TUcSkinName;
    FSkinImgUp: TUcSkinName;
    FSkinImgDisabled: TUcSkinName;
    FSkinImgHot: TUcSkinName;
    procedure SetUp        (Value: TPicture);
    procedure SetDisabled  (Value: TPicture);
    procedure SetDown      (Value: TPicture);
    procedure SetHot       (Value: TPicture);

    procedure SetIndexImgUp       (Value: TImageIndex);
    procedure SetIndexImgDisabled (Value: TImageIndex);
    procedure SetIndexImgDown     (Value: TImageIndex);
    procedure SetIndexImgHot      (Value: TImageIndex);

    procedure SetSkinImgDisabled(const Value: TUcSkinName);
    procedure SetSkinImgDown(const Value: TUcSkinName);
    procedure SetSkinImgHot(const Value: TUcSkinName);
    procedure SetSkinImgUp(const Value: TUcSkinName);

    procedure SetStretch   (Value: Boolean);
    procedure SetTransparent(Value: Boolean);
    procedure SetPosLeft   (Value: integer);
    procedure SetPosTop    (Value: integer);
    procedure SetPosCenter (Value: Boolean);

    function  GetUp      : TPicture;
    function  GetDisabled: TPicture;
    function  GetDown    : TPicture;
    function  GetHot     : TPicture;
    function  GetBtnImages  : TCustomImageList;
    function  GetSkinManager: TUcSkinManager;
  protected
  public
    constructor Create(crParentObj: IUcButton);
    destructor  Destroy; override;
    procedure   DoParentResize;
    procedure   UpdateSkinPainters(SkinName: string = '');
    function StorePos: Boolean;
    property BtnImages: TCustomImageList read GetBtnImages;
    property SkinManager: TUcSkinManager read GetSkinManager;
  published
    property ImgUp:       TPicture  read GetUp       write SetUp;
    property ImgDisabled: TPicture  read GetDisabled write SetDisabled;
    property ImgDown:     TPicture  read GetDown     write SetDown;
    property ImgHot:      TPicture  read GetHot      write SetHot;

    property IndexImgUp:       TImageIndex read FIndexImgUp       write SetIndexImgUp       default -1;
    property IndexImgDisabled: TImageIndex read FIndexImgDisabled write SetIndexImgDisabled default -1;
    property IndexImgDown:     TImageIndex read FIndexImgDown     write SetIndexImgDown     default -1;
    property IndexImgHot:      TImageIndex read FIndexImgHot      write SetIndexImgHot      default -1;

    property SkinImgUp:       TUcSkinName read FSkinImgUp       write SetSkinImgUp;
    property SkinImgDisabled: TUcSkinName read FSkinImgDisabled write SetSkinImgDisabled;
    property SkinImgDown:     TUcSkinName read FSkinImgDown     write SetSkinImgDown;
    property SkinImgHot:      TUcSkinName read FSkinImgHot      write SetSkinImgHot;

    property PosCenter:Boolean   read FPosCenter  write SetPosCenter;
    property PosLeft:  integer   read FPosLeft    write SetPosLeft stored StorePos;
    property PosTop:   integer   read FPosTop     write SetPosTop stored StorePos;
    property Stretch:  Boolean   read FStretch    write SetStretch    default false;
    property Transparent: Boolean read FTransparent write SetTransparent default false;
    property OnChangeImagesParams: TNotifyEvent read FOnChangeImagesParams write FOnChangeImagesParams;
  end;

  TCaptionPositions = class(TPersistent)
  private
    FAlignment: TAlignment;
    FLayout: TTextLayout;
    FPadding: TPadding;
    FCaptionRect: TRect;
    FWordWrap: Boolean;
    FWordEllipsis: Boolean;
    FParentObj: IUcButton;
    FOnChangeCaptionCenter: TNotifyEvent;
    procedure SetCaptionRect(Value: TRect);
    procedure SetAlignment(Value: TAlignment);
    procedure SetWordWrap(Value: Boolean);
    procedure SetWordEllipsis(const Value: Boolean);
    procedure SetPadding(const Value: TPadding);
    procedure SetLayout(const Value: TTextLayout);
    procedure DoPaddingChange(Sender: TObject);
  protected
    function GetDrawTextFlags: Longint;
    procedure CalcCaptionRect;
    property CaptionRect: TRect read FCaptionRect write SetCaptionRect;
    property OnChangeCaptionCenter: TNotifyEvent read  FOnChangeCaptionCenter
                                                 write FOnChangeCaptionCenter;
  public
    constructor Create(crParentObj: IUcButton);
    destructor  Destroy; override;
    procedure   DoParentResize;
  published
    property Alignment: TAlignment  read FAlignment write SetAlignment default taCenter;
    property Layout: TTextLayout read FLayout write SetLayout default tlCenter;
    property Padding: TPadding read FPadding write SetPadding;
    property WordEllipsis: Boolean read FWordEllipsis write SetWordEllipsis default False;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
  end;

  TUcWinButton = class(TCustomControl, IUcButton) //(TCustomControl)
  private
    FGroupIndex: Integer;
    FCaptionPositions: TCaptionPositions;
    FImages: TButtonImages;
    FDown: Boolean;
    FDragging: Boolean;
    FAllowAllUp: Boolean;
    FMouseInControl: Boolean;
    FButtonStyle: TButtonStyle;
    FFlat: Boolean;
    FShowFocus: Boolean;
    FModalResult: TModalResult;
    FActive: Boolean;
    FDefault: Boolean;
    FCancel: Boolean;

    FBtnImages: TCustomImageList;
    FSkinManager: TUcSkinManager;
    FImageChangeLink: TChangeLink;
    FCaptionEx: TStrings;

    fOnChangeState: TNotifyEvent;
    FShowCaption: Boolean;
    FOnPaint: TNotifyEvent;
{$IFNDEF DELPHI_2009_UP}
    fOnMouseLeave: TNotifyEvent;
    fOnMouseEnter: TNotifyEvent;
{$ENDIF}
    procedure SetCaptionEx(Value: TStrings);

    procedure ChangeCaptionPosition(Sender: TObject);
    procedure DoResize(Sender: TObject);
    procedure GlyphChanged(Sender: TObject);
    procedure UpdateDown;
    function  GetDown: Boolean;
    procedure SetDown(Value: Boolean);
    function  GetAllowAllUp: Boolean;
    procedure SetAllowAllUp(Value: Boolean);
    function  GetGroupIndex: Integer;
    procedure SetGroupIndex(Value: Integer);
    procedure SetButtonStyle(const Value: TButtonStyle);
    procedure SetFlat(const Value: Boolean);
    procedure SetShowFocus(Value: Boolean);
    procedure SetDefault(Value: Boolean);
    function  GetBtnImages: TCustomImageList;
    procedure SetBtnImages(Value: TCustomImageList);

    function  GetImages: TButtonImages;
    procedure SetImages(Value: TButtonImages);

    procedure ImageListChange(Sender: TObject);
    procedure SkinManagerChange(Sender: TObject);
    procedure CaptionExChange(Sender: TObject);

    procedure UpdateTracking;
    procedure WMLButtonDblClk(var Message: TWMLButtonDown); message WM_LBUTTONDBLCLK;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMButtonPressed(var Message: TMessage); message CM_BUTTONPRESSED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
{$IFDEF DELPHI_2009_UP}
    procedure CNCtlColorStatic(var Message: TWMCtlColorStatic); message CN_CTLCOLORSTATIC;
{$ENDIF}
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CNCtlColorBtn(var Message: TWMCtlColorBtn); message CN_CTLCOLORBTN;
{$IF NOT DEFINED(CLR)}
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
{$IFEND}

    function GetVersion: TCaption;
    procedure SetVersion(Value: TCaption);
    function GetState: TButtonState;
    procedure SetState(const Value: TButtonState);
    function GetFlat: Boolean;
    function GetButtonStyle: TButtonStyle;
    function GetFont_: TFont;
    procedure SetFont_(const Value: TFont);
    function GetComponentState: TComponentState;
    function GetCaptionPositions: TCaptionPositions;
    procedure SetCaptionPositions(const Value: TCaptionPositions);
    function GetMouseInControl: Boolean;
    procedure SetMouseInControl(const Value: Boolean);
    function GetDragging: Boolean;
    procedure SetDragging(const Value: Boolean);
    function GetShowCaption: Boolean;
    procedure SetShowCaption(const Value: Boolean);
    function GetSkinManager: TUcSkinManager;
    procedure SetSkinManager(const Value: TUcSkinManager);
  protected
    FState: TButtonState;

    function  SelfObj: TControl;
    function  GetWidth: Integer;
    function  GetHeight: Integer;
    function  GetControlStyle: TControlStyle;
    procedure SetControlStyle(Value: TControlStyle);
    function  GetCaption: TCaption;
    procedure SetCaption(Value: TCaption);
    function  GetCanvas: TCanvas;
    function GetDragMode: TDragMode;
    procedure SetDragMode(Value: TDragMode); override;

{$IF DEFINED(CLR)}
    procedure FocusChanged(NewFocusControl: TWinControl); override;
{$IFEND}
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure WndProc(var Message: TMessage); override;
    procedure CreateWnd; override;

    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    function GetActionLinkClass: TControlActionLinkClass; override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;

    property DragMode: TDragMode read GetDragMode write SetDragMode default dmManual;
    property Dragging_: Boolean read GetDragging write SetDragging;
    property MouseInControl: Boolean read GetMouseInControl write SetMouseInControl;
    property State: TButtonState read GetState write SetState;
    property ComponentState: TComponentState read GetComponentState;
    procedure DoPaint; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PaintTo(DC: HDC; BtnState: TButtonState);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Click; override;
    property Canvas: TCanvas read GetCanvas;
    property ControlStyle: TControlStyle read GetControlStyle write SetControlStyle;
  published
    property Version: TCaption read GetVersion write SetVersion stored False;
    property Action;
    property Align;
    property AllowAllUp: Boolean read GetAllowAllUp write SetAllowAllUp default False;
    property Anchors;
    property ButtonStyle: TButtonStyle read GetButtonStyle write SetButtonStyle default bsClassic;
    property Cancel: Boolean read FCancel write FCancel default False;
    property Caption: TCaption read GetCaption write SetCaption;
    property CaptionEx: TStrings read FCaptionEx write SetCaptionEx;
    property CaptionPositions: TCaptionPositions read GetCaptionPositions write SetCaptionPositions;
    property Constraints;
    property Down: Boolean read GetDown write SetDown default False;
    property DoubleBuffered;
    property Enabled;
    property Font: TFont read GetFont_ write SetFont_;
    property Flat: Boolean read GetFlat write SetFlat default False;
    property ShowFocus: Boolean read FShowFocus write SetShowFocus default True;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;

    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property Default: Boolean read FDefault write SetDefault default False;

    property BtnImages: TCustomImageList read GetBtnImages write SetBtnImages;
    property SkinManager: TUcSkinManager read GetSkinManager write SetSkinManager;

    property Images: TButtonImages read FImages write FImages;
{$IFDEF DELPHI_2009_UP}
    property ParentDoubleBuffered;
    property OnMouseLeave;
    property OnMouseEnter;
{$ELSE}
    property OnMouseLeave: TNotifyEvent read fOnMouseLeave write fOnMouseLeave;
    property OnMouseEnter: TNotifyEvent read fOnMouseEnter write fOnMouseEnter;
{$ENDIF}
    //property ParentBackground;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnChangeState: TNotifyEvent read fOnChangeState write fOnChangeState;
    property ShowCaption: Boolean read GetShowCaption write SetShowCaption default True;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
  end;

  TUcButton = class(TGraphicControl, IUcButton) //(TGraphicControl)
  private
    FGroupIndex: Integer;
    FCaptionPositions: TCaptionPositions;
    FImages: TButtonImages;
    FDown: Boolean;
    FDragging: Boolean;
    FAllowAllUp: Boolean;
    FMouseInControl: Boolean;
    FButtonStyle: TButtonStyle;
    FFlat: Boolean;
    FModalResult: TModalResult;
    FDefault: Boolean;
    FCancel: Boolean;

    FBtnImages: TCustomImageList;
    FSkinManager: TUcSkinManager;
    FImageChangeLink: TChangeLink;
    FCaptionEx: TStrings;

    fOnChangeState: TNotifyEvent;
    FShowCaption: Boolean;
    FOnPaint: TNotifyEvent;
{$IFNDEF DELPHI_2009_UP}
    fOnMouseLeave: TNotifyEvent;
    fOnMouseEnter: TNotifyEvent;
{$ENDIF}
    procedure SetCaptionEx(Value: TStrings);
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;

    procedure ChangeCaptionPosition(Sender: TObject);
    procedure DoResize(Sender: TObject);
    procedure GlyphChanged(Sender: TObject);
    procedure UpdateDown;
    function  GetDown: Boolean;
    procedure SetGroupIndex(Value: Integer);
    procedure SetDown(Value: Boolean);
    function  GetAllowAllUp: Boolean;
    procedure SetAllowAllUp(Value: Boolean);
    function  GetGroupIndex: Integer;
    procedure SetButtonStyle(const Value: TButtonStyle);
    procedure SetFlat(const Value: Boolean);
    function  GetBtnImages: TCustomImageList;
    procedure SetBtnImages(Value: TCustomImageList);

    function  GetImages: TButtonImages;
    procedure SetImages(Value: TButtonImages);

    procedure ImageListChange(Sender: TObject);
    procedure CaptionExChange(Sender: TObject);

    procedure UpdateTracking;
    procedure WMLButtonDblClk(var Message: TWMLButtonDown); message WM_LBUTTONDBLCLK;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMButtonPressed(var Message: TMessage); message CM_BUTTONPRESSED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;

    function GetVersion: TCaption;
    procedure SetVersion(Value: TCaption);
    function GetState: TButtonState;
    procedure SetState(const Value: TButtonState);
    function GetFlat: Boolean;
    function GetButtonStyle: TButtonStyle;
    function GetFont_: TFont;
    procedure SetFont_(const Value: TFont);
    function GetComponentState: TComponentState;
    function GetCaptionPositions: TCaptionPositions;
    procedure SetCaptionPositions(const Value: TCaptionPositions);
    function GetMouseInControl: Boolean;
    procedure SetMouseInControl(const Value: Boolean);
    function GetDragging: Boolean;
    procedure SetDragging(const Value: Boolean);
    function GetShowCaption: Boolean;
    procedure SetShowCaption(const Value: Boolean);
    function GetSkinManager: TUcSkinManager;
    procedure SetSkinManager(const Value: TUcSkinManager);
    procedure SkinManagerChange(Sender: TObject);
  protected
    FState: TButtonState;

    function  SelfObj: TControl;
    function  GetWidth: Integer;
    function  GetHeight: Integer;
    function  GetControlStyle: TControlStyle;
    procedure SetControlStyle(Value: TControlStyle);
    function  GetCaption: TCaption;
    procedure SetCaption(Value: TCaption);
    function  GetCanvas: TCanvas;
    function GetDragMode: TDragMode;
    procedure SetDragMode(Value: TDragMode); override;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    function GetActionLinkClass: TControlActionLinkClass; override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;

    property DragMode: TDragMode read GetDragMode write SetDragMode default dmManual;
    property Dragging_: Boolean read GetDragging write SetDragging;
    property MouseInControl: Boolean read GetMouseInControl write SetMouseInControl;
    property State: TButtonState read GetState write SetState;
    property ComponentState: TComponentState read GetComponentState;
    procedure DoPaint; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PaintTo(DC: HDC; BtnState: TButtonState);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Click; override;
    property Canvas: TCanvas read GetCanvas;
    property ControlStyle: TControlStyle read GetControlStyle write SetControlStyle;
  published
    property Version: TCaption read GetVersion write SetVersion stored False;
    property Action;
    property Align;
    property AllowAllUp: Boolean read GetAllowAllUp write SetAllowAllUp default False;
    property Anchors;
    property ButtonStyle: TButtonStyle read GetButtonStyle write SetButtonStyle default bsClassic;
    property Constraints;
    property Cancel: Boolean read FCancel write FCancel default False;
    property Caption: TCaption read GetCaption write SetCaption;
    property CaptionEx: TStrings read FCaptionEx write SetCaptionEx;
    property CaptionPositions: TCaptionPositions read GetCaptionPositions write SetCaptionPositions;
    property Default: Boolean read FDefault write FDefault default False;
    property GroupIndex: Integer read GetGroupIndex write SetGroupIndex default 0;
    property Down: Boolean read FDown write SetDown default False;
    property Enabled;
    property Font: TFont read GetFont_ write SetFont_;
    property Flat: Boolean read GetFlat write SetFlat default False;

    property ModalResult: TModalResult read FModalResult write FModalResult default 0;

    property BtnImages: TCustomImageList read GetBtnImages write SetBtnImages;
    property SkinManager: TUcSkinManager read GetSkinManager write SetSkinManager;

    property Images: TButtonImages read FImages write FImages;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
{$IFDEF DELPHI_2009_UP}
    property OnMouseLeave;
    property OnMouseEnter;
{$ELSE}
    property OnMouseLeave: TNotifyEvent read fOnMouseLeave write fOnMouseLeave;
    property OnMouseEnter: TNotifyEvent read fOnMouseEnter write fOnMouseEnter;
{$ENDIF}
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnChangeState: TNotifyEvent read fOnChangeState write fOnChangeState;
    property ShowCaption: Boolean read GetShowCaption write SetShowCaption default True;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
  end;

  TUniversalWinButton = class (TUcWinButton);
  TUniversalButton = class (TUcButton)
  public
    constructor Create(AOwner: TComponent); override;
  end;

procedure Register;

implementation

uses Math;

var ButtonCount: integer = 0;

{$R *.dcr}
{$Include ..\Versions.ucver}

procedure Register;
begin
  RegisterComponents('UControls', [TUcButton, TUcWinButton]);
  RegisterComponents('UControls support', [TUniversalButton, TUniversalWinButton]);
end;

{ TUniversalWinButtonActionLink }

procedure TUniversalButtonActionLink.AssignClient(AClient: TObject);
begin
  inherited AssignClient(AClient);
  if AClient is TUcWinButton then
    FClient := AClient as TUcWinButton;
  if AClient is TUcButton then
    FClient := AClient as TUcButton;
end;

function TUniversalButtonActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and //(FClient.GroupIndex <> 0) and
    FClient.AllowAllUp and (FClient.Down = (Action as TCustomAction).Checked);
end;

function TUniversalButtonActionLink.IsGroupIndexLinked: Boolean;
begin
  Result := ((FClient.SelfObj is TUcWinButton)or
             (FClient.SelfObj is TUcButton))
    and
    (FClient.GroupIndex = (Action as TCustomAction).GroupIndex);
end;

procedure TUniversalButtonActionLink.SetChecked(Value: Boolean);
begin
  if IsCheckedLinked then FClient.Down := Value;
end;

procedure TUniversalButtonActionLink.SetGroupIndex(Value: Integer);
begin
  if IsGroupIndexLinked then FClient.GroupIndex := Value;
end;

procedure TUniversalButtonActionLink.SetImageIndex(Value: Integer);
begin
  if IsImageIndexLinked then
    FClient.Images.IndexImgUp := Value;
end;
//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM

constructor TButtonImages.Create(crParentObj: IUcButton);
begin
  FUp       := TPicture.Create;
  FDisabled := TPicture.Create;
  FDown     := TPicture.Create;
  FHot      := TPicture.Create;

  FIndexImgUp       := -1;
  FIndexImgDisabled := -1;
  FIndexImgDown     := -1;
  FIndexImgHot      := -1;

  FSkinUp       := nil;
  FSkinDisabled := nil;
  FSkinDown     := nil;
  FSkinHot      := nil;

  FPosCenter := True;
  FPosLeft   := 0;
  FPosTop    := 0;

  FParentObj := crParentObj;
  inherited Create;
end;

destructor TButtonImages.Destroy;
begin
  FSkinUp.Free;
  FSkinDisabled.Free;
  FSkinDown.Free;
  FSkinHot.Free;

  TPicture(FUp).Free;
  TPicture(FDisabled).Free;
  TPicture(FDown).Free;
  TPicture(FHot).Free;

  inherited;
end;

procedure TButtonImages.DoParentResize;
begin
  if FPosCenter and Assigned(FParentObj) then
  begin
    if Assigned(FParentObj.BtnImages) and (FIndexImgUp > -1) then
    begin
      FPosLeft:= (FParentObj.Width  - FParentObj.BtnImages.Width) div 2;
      FPosTop := (FParentObj.Height - FParentObj.BtnImages.Height)div 2;
    end else
    begin
      FPosLeft:= (FParentObj.Width  - TPicture(FUp).Width) div 2;
      FPosTop := (FParentObj.Height - TPicture(FUp).Height)div 2;
    end;
  end;

  if Assigned(FSkinUp)       then FSkinUp.BaseDestRect       := FParentObj.ClientRect;
  if Assigned(FSkinDisabled) then FSkinDisabled.BaseDestRect := FParentObj.ClientRect;
  if Assigned(FSkinDown)     then FSkinDown.BaseDestRect     := FParentObj.ClientRect;
  if Assigned(FSkinHot)      then FSkinHot.BaseDestRect      := FParentObj.ClientRect;
end;

function TButtonImages.StorePos: Boolean;
begin
  Result := not FPosCenter;
end;

procedure TButtonImages.UpdateSkinPainters(SkinName: string = '');

  procedure UpdateSkinPainter_(var Obj; SkinName_: string);
  begin
    FreeAndNil(Obj);
    if Assigned(SkinManager) then
    begin
      Pointer(Obj) := SkinManager.CreateSkinPainterByStyleName(SkinName_);
      if Assigned(TObject(Obj)) then
        TUcSkinPainter(Obj).BaseDestRect := FParentObj.ClientRect;
      FParentObj.Invalidate;
    end;
  end;

begin
  if (SkinName = '') or (CompareText(SkinName, FSkinImgUp) = 0) then
    UpdateSkinPainter_(FSkinUp, FSkinImgUp);

  if (SkinName = '') or (CompareText(SkinName, FSkinImgDisabled) = 0) then
    UpdateSkinPainter_(FSkinDisabled, FSkinImgDisabled);

  if (SkinName = '') or (CompareText(SkinName, FSkinImgDown) = 0) then
    UpdateSkinPainter_(FSkinDown, FSkinImgDown);

  if (SkinName = '') or (CompareText(SkinName, FSkinImgHot) = 0) then
    UpdateSkinPainter_(FSkinHot, FSkinImgHot);
end;

procedure TButtonImages.SetUp(Value: TPicture);
begin
  TPicture(FUp).Assign(Value);
  if Assigned(TPicture(FUp).Graphic) then
    TPicture(FUp).Graphic.Transparent:= FTransparent;
end;

procedure TButtonImages.SetDisabled(Value: TPicture);
begin
  TPicture(FDisabled).Assign(Value);
  if Assigned(TPicture(FDisabled).Graphic) then
    TPicture(FDisabled).Graphic.Transparent:= FTransparent;
end;

procedure TButtonImages.SetDown(Value: TPicture);
begin
  TPicture(FDown).Assign(Value);
  if Assigned(TPicture(FDown).Graphic) then
    TPicture(FDown).Graphic.Transparent:= FTransparent;
end;

procedure TButtonImages.SetHot(Value: TPicture);
begin
  TPicture(FHot).Assign(Value);
  if Assigned(TPicture(FHot).Graphic) then
    TPicture(FHot).Graphic.Transparent:= FTransparent;
end;

procedure TButtonImages.SetIndexImgUp(Value: TImageIndex);
begin
  if FIndexImgUp <> Value then
  begin
    FIndexImgUp := Value;
    DoParentResize;
    FParentObj.Invalidate;
  end;
end;

procedure TButtonImages.SetIndexImgDisabled(Value: TImageIndex);
begin
  if FIndexImgDisabled <> Value then
  begin
    FIndexImgDisabled := Value;
    FParentObj.Invalidate;
  end;
end;

procedure TButtonImages.SetIndexImgDown(Value: TImageIndex);
begin
  if FIndexImgDown <> Value then
  begin
    FIndexImgDown := Value;
    FParentObj.Invalidate;
  end;
end;

procedure TButtonImages.SetIndexImgHot(Value: TImageIndex);
begin
  if FIndexImgHot <> Value then
  begin
    FIndexImgHot := Value;
    FParentObj.Invalidate;
  end;
end;

procedure TButtonImages.SetSkinImgDisabled(const Value: TUcSkinName);
begin
  if FSkinImgDisabled <> Value then
  begin
    FSkinImgDisabled := Value;
    UpdateSkinPainters(FSkinImgDisabled);
    FParentObj.Invalidate;
  end;
end;

procedure TButtonImages.SetSkinImgDown(const Value: TUcSkinName);
begin
  if FSkinImgDown <> Value then
  begin
    FSkinImgDown := Value;
    UpdateSkinPainters(FSkinImgDown);
    FParentObj.Invalidate;
  end;
end;

procedure TButtonImages.SetSkinImgHot(const Value: TUcSkinName);
begin
  if FSkinImgHot <> Value then
  begin
    FSkinImgHot := Value;
    UpdateSkinPainters(FSkinImgHot);
    FParentObj.Invalidate;
  end;
end;

procedure TButtonImages.SetSkinImgUp(const Value: TUcSkinName);
begin
  if FSkinImgUp <> Value then
  begin
    FSkinImgUp := Value;
    UpdateSkinPainters(FSkinImgUp);
    FParentObj.Invalidate;
  end;
end;

procedure TButtonImages.SetStretch (Value: Boolean);
begin
  FStretch:= Value;
  if Assigned(FOnChangeImagesParams) then FOnChangeImagesParams(Self);
end;

procedure TButtonImages.SetTransparent(Value: Boolean);
begin
  FTransparent:= Value;
  if Assigned(TPicture(FUp).Graphic) then
    TPicture(FUp).Graphic.Transparent:= FTransparent;
  if Assigned(TPicture(FDown).Graphic) then
    TPicture(FDown).Graphic.Transparent:= FTransparent;
  if Assigned(TPicture(FHot).Graphic) then
    TPicture(FHot).Graphic.Transparent:= FTransparent;
  if Assigned(TPicture(FDisabled).Graphic) then
    TPicture(FDisabled).Graphic.Transparent:= FTransparent;
  if Assigned(FOnChangeImagesParams) then FOnChangeImagesParams(Self);

  if Assigned(FParentObj) then
    if FTransparent then
      FParentObj.ControlStyle := FParentObj.ControlStyle - [csOpaque]
      else
      FParentObj.ControlStyle := FParentObj.ControlStyle + [csOpaque];
end;

procedure TButtonImages.SetPosCenter(Value: Boolean);
begin
  if FPosCenter<>Value then
    begin
      FPosCenter:= Value;
      DoParentResize;
      if Assigned(FOnChangeImagesParams) then FOnChangeImagesParams(Self);
    end;
end;

procedure TButtonImages.SetPosLeft(Value: integer);
begin
  if (FPosLeft<>Value){and(not FPosCenter)} then
    begin
      FPosLeft   := Value;
      FPosCenter := False;
      if Assigned(FOnChangeImagesParams) then FOnChangeImagesParams(Self);
    end;
end;

procedure TButtonImages.SetPosTop(Value: integer);
begin
  if (FPosTop<>Value){and(not FPosCenter)}then
    begin
      FPosTop    := Value;
      FPosCenter := False;
      if Assigned(FOnChangeImagesParams) then FOnChangeImagesParams(Self);
    end;
end;

function TButtonImages.GetUp: TPicture;
begin
  Result:= TPicture(FUp);
end;

function TButtonImages.GetDisabled: TPicture;
begin
  Result:= TPicture(FDisabled);
end;

function TButtonImages.GetDown: TPicture;
begin
  Result:= TPicture(FDown);
end;

function TButtonImages.GetHot: TPicture;
begin
  Result:= TPicture(FHot);
end;

function TButtonImages.GetBtnImages: TCustomImageList;
begin
  Result := FParentObj.BtnImages;
end;

function TButtonImages.GetSkinManager: TUcSkinManager;
begin
  Result := FParentObj.SkinManager;
end;
//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
constructor TCaptionPositions.Create(crParentObj: IUcButton);
begin
  FParentObj := nil;
  inherited Create;
  FParentObj := crParentObj;
  FAlignment := taCenter;
  FLayout    := tlCenter;
  FPadding   := TPadding.Create(nil);
  FPadding.OnChange := DoPaddingChange;
end;

destructor  TCaptionPositions.Destroy;
begin
  FPadding.Free;
  inherited;
end;

procedure TCaptionPositions.DoPaddingChange(Sender: TObject);
begin
  CalcCaptionRect;
  if Assigned(FOnChangeCaptionCenter)then FOnChangeCaptionCenter(self);
end;

procedure TCaptionPositions.SetPadding(const Value: TPadding);
begin
  FPadding.Assign(Value);
end;

procedure TCaptionPositions.SetLayout(const Value: TTextLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;

    CalcCaptionRect;
    if Assigned(FOnChangeCaptionCenter)then FOnChangeCaptionCenter(self);
  end;
end;

procedure TCaptionPositions.DoParentResize;
begin
  CalcCaptionRect;
end;

procedure TCaptionPositions.SetCaptionRect(Value: TRect);
begin
  FCaptionRect := Value;
end;

procedure TCaptionPositions.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;

    CalcCaptionRect;
    if Assigned(FOnChangeCaptionCenter)then FOnChangeCaptionCenter(self);
  end;
end;

procedure TCaptionPositions.SetWordEllipsis(const Value: Boolean);
begin
  if FWordEllipsis <> Value then
  begin
    FWordEllipsis := Value;
    CalcCaptionRect;
    if Assigned(FOnChangeCaptionCenter)then FOnChangeCaptionCenter(self);
  end;
end;

procedure TCaptionPositions.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    CalcCaptionRect;
    if Assigned(FOnChangeCaptionCenter)then FOnChangeCaptionCenter(self);
  end;
end;

function TCaptionPositions.GetDrawTextFlags: Longint;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
  WordEllipses: array[Boolean] of DWord = (0, DT_WORD_ELLIPSIS);
begin
  Result := WordWraps[FWordWrap] or Alignments[FAlignment] or
            WordEllipses[FWordEllipsis];
end;

procedure TCaptionPositions.CalcCaptionRect;
var s: string;
    Ra, R: TRect;
begin
  if Assigned(FParentObj)and Assigned(FParentObj.SelfObj.Parent) then
  begin
    Ra := Rect(Padding.Left, Padding.Top,
               FParentObj.Width - Padding.Right,
               FParentObj.Height - Padding.Bottom);
    R := Ra;
    s := FParentObj.Caption;
    FParentObj.Canvas.Refresh;
    DrawText(FParentObj.Canvas.Handle, PChar(s), Length(s), R,
             DT_CALCRECT or GetDrawTextFlags);

    // Учет позиции "по центру"
    case FLayout of
      tlTop   : ;
      tlCenter: OffsetRect(R, 0, (UC_RectHeight(Ra) - UC_RectHeight(R)) div 2);
      tlBottom: OffsetRect(R, 0, (UC_RectHeight(Ra) - UC_RectHeight(R)));
    end;

    // Корректировка попадания в область печати
    if R.Top < Padding.Top then OffsetRect(R, 0, Padding.Top - R.Top);
    if R.Bottom > FParentObj.Height - Padding.Bottom then
      R.Bottom := FParentObj.Height - Padding.Bottom;
    // Расширения горизонтальных границ, что бы сработало свойство Aligment
    R.Left  := Ra.Left;
    R.Right := Ra.Right;
    // Сохранение рассчитанной области
    FCaptionRect := R;
  end;
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM

// Общие функции CF_.........   (CF - Common Functions)
procedure CF_ActionChange(Button: IUcButton; Sender: TObject; CheckDefaults: Boolean);
begin
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      if CheckDefaults or (Button.GroupIndex = 0) then
        Button.GroupIndex := GroupIndex;

      if (ActionList <> nil) and (ActionList.Images <> nil) and
        (ImageIndex >= 0) and (ImageIndex < ActionList.Images.Count) then
        begin
          if not Assigned(Button.BtnImages) then
            Button.BtnImages := ActionList.Images;

          if Button.Images.IndexImgUp = -1 then
            Button.Images.IndexImgUp := ImageIndex;

//          Button.Images.PosCenter  := True;
        end;
    end;
end;

procedure CF_Paint(Button: IUcButton; BtnState: TButtonState; Canvas: TCanvas = nil);
const r = 10;
      cbsUp       = 1;
      cbsHot      = 2;
      cbsDown     = 3;
      cbsDisabled = 4;
var Details: TThemedElementDetails;

  procedure BtnImagesDraw(Canvas: TCanvas; X, Y, Index: Integer; Enabled: Boolean = True);
  var ico: HICON;
  begin
    if Button.Images.Stretch and
       ((Button.Width <> Button.BtnImages.Width) or
        (Button.Height <> Button.BtnImages.Height)) then
      begin
        ico := ImageList_GetIcon(Button.BtnImages.Handle, Index, ILD_NORMAL or ILD_TRANSPARENT);
        DrawIconEx(Canvas.Handle, 0, 0, ico,
                   Button.Width, Button.Height, 0, 0, DI_NORMAL);
        DestroyIcon(ico);
      end else
      Button.BtnImages.Draw(Canvas, X, Y, Index, Enabled);
  end;

  function DrawDefaultUp: Boolean;
  var Dxy: integer;
  begin
    Result := false;
    if Assigned(Button.BtnImages) and (Button.Images.IndexImgUp > -1) then
    begin
      Dxy := integer((Button.Images.IndexImgDown < 0) and (BtnState = btsDown));
      BtnImagesDraw(Canvas, Button.Images.PosLeft + Dxy, Button.Images.PosTop + Dxy,
                    Button.Images.IndexImgUp, BtnState <> btsDisabled);
      Result := true;
    end else
      if Assigned(Button.Images.ImgUp.Graphic) then
        with Canvas do
        begin
          if Button.Images.Stretch then
            StretchDraw(Rect(0,0,Button.Width,Button.Height), Button.Images.ImgUp.Graphic)
            else
            Draw(Button.Images.PosLeft, Button.Images.PosTop, Button.Images.ImgUp.Graphic);
          Result := true;
        end;
  end;

  procedure DrawThemeElement(State: Byte);
  const
    DownStyles: array[Boolean] of Integer = (BDR_RAISEDINNER, BDR_SUNKENOUTER);
    FillStyles: array[Boolean] of Integer = (BF_MIDDLE, 0);
  var PaintRect: TRect;
      DrawFlags: Integer;
  begin
    if (State = cbsUp) and Assigned(Button.Images.FSkinUp) then
      Button.Images.FSkinUp.Draw(Canvas)

    else if (State = cbsHot) and Assigned(Button.Images.FSkinHot) then
      Button.Images.FSkinHot.Draw(Canvas)

    else if (State = cbsDown) and Assigned(Button.Images.FSkinDown) then
      Button.Images.FSkinDown.Draw(Canvas)

    else if (State = cbsDisabled) and Assigned(Button.Images.FSkinDisabled) then
      Button.Images.FSkinDisabled.Draw(Canvas)

    else if ThemeServices.ThemesEnabled then
    begin
      Details.Element:= teButton;
      Details.Part   := 1;
      Details.State  := State;
      ThemeServices.DrawElement(Canvas.Handle, Details,
                                Rect(0,0,Button.Width,Button.Height));
    end else
    begin
      PaintRect := Rect(0, 0, Button.Width, Button.Height);
      if State in [1,2,4] then
        DrawFlags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT
        else
        DrawFlags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT or DFCS_PUSHED;
      if Button.Flat then
        DrawEdge(Canvas.Handle, PaintRect, DownStyles[BtnState = btsDown],
                 FillStyles[Button.Images.Transparent] or BF_RECT)
        else
        DrawFrameControl(Canvas.Handle, PaintRect, DFC_BUTTON, DrawFlags);
    end;
  end;

  procedure DrawUp;
  begin
    with Canvas do
    begin
      //---bsClassic---
      if (Button.ButtonStyle = bsClassic) and (not Button.Flat) then
        DrawThemeElement(cbsUp);
      //---bsImaged---
      if (not DrawDefaultUp) and (Button.ButtonStyle <> bsClassic) then
        RoundRect(0, 0, Button.Width, Button.Height, r, r);
      //**
    end;
  end;

  procedure DrawHot;
  begin
    //---bsClassic---
    if (Button.ButtonStyle = bsClassic)or Button.Flat then
      DrawThemeElement(cbsHot);
    if Assigned(Button.BtnImages)and(Button.Images.IndexImgHot > -1) then
    begin
      BtnImagesDraw(Canvas, Button.Images.PosLeft, Button.Images.PosTop,
                    Button.Images.IndexImgHot);
    end else
      with Canvas do
      begin
        //---bsImaged---
        if Assigned(Button.Images.ImgHot.Graphic) then
        begin
          if Button.Images.Stretch then
            StretchDraw(Rect(0,0,Button.Width,Button.Height), Button.Images.ImgHot.Graphic)
            else
            Draw(Button.Images.PosLeft,Button.Images.PosTop,Button.Images.ImgHot.Graphic);
        end else
        if (not DrawDefaultUp)and(Button.ButtonStyle<>bsClassic) then
        begin
          RoundRect(0,0,Button.Width,Button.Height,r,r);
          Pen.Style  := psDot;
          RoundRect(2,2,Button.Width-2,Button.Height-2,r-2,r-2);
        end;
        //**
      end;
  end;

  procedure DrawDown;
  begin
    //---bsClassic---
    if (Button.ButtonStyle = bsClassic) or Button.Flat then
      DrawThemeElement(cbsDown);
    if Assigned(Button.BtnImages)and(Button.Images.IndexImgDown > -1) then
    begin
      BtnImagesDraw(Canvas, Button.Images.PosLeft, Button.Images.PosTop,
                    Button.Images.IndexImgDown);
    end else
      with Canvas do
      begin
        //---bsImaged---
        if Assigned(Button.Images.ImgDown.Graphic) then
        begin
          if Button.Images.Stretch then
            StretchDraw(Rect(0,0,Button.Width,Button.Height), Button.Images.ImgDown.Graphic)
            else
            Draw(Button.Images.PosLeft,Button.Images.PosTop,Button.Images.ImgDown.Graphic);
        end else
        if (not DrawDefaultUp)and(Button.ButtonStyle<>bsClassic) then
        begin
          RoundRect(0,0,Button.Width,Button.Height,r,r);
          RoundRect(2,2,Button.Width-2,Button.Height-2,r-2,r-2);
        end;
        //**
      end;
  end;

  procedure DrawDisabled;
  begin
    //---bsClassic---
    if Button.ButtonStyle = bsClassic then
      DrawThemeElement(cbsDisabled);
    if Assigned(Button.BtnImages)and(Button.Images.IndexImgDisabled > -1) then
    begin
      BtnImagesDraw(Canvas, Button.Images.PosLeft, Button.Images.PosTop,
                    Button.Images.IndexImgDisabled);
    end else
      with Canvas do
      begin
        //---bsImaged---
        if Assigned(Button.Images.ImgDisabled.Graphic) then
        begin
          if Button.Images.Stretch then
            StretchDraw(Rect(0,0,Button.Width,Button.Height), Button.Images.ImgDisabled.Graphic)
            else
            Draw(Button.Images.PosLeft,Button.Images.PosTop,Button.Images.ImgDisabled.Graphic);
        end else
        if (not DrawDefaultUp)and(Button.ButtonStyle<>bsClassic) then
        begin
          Pen.Color := clGray;
          RoundRect(0,0,Button.Width,Button.Height,r,r);
          MoveTo(2,2);
          LineTo(Button.Width-2,Button.Height-2);
          MoveTo(Button.Width-2,2);
          LineTo(2,Button.Height-2);
        end;
        //**
      end;
    Canvas.Font.Color:= clGray;
  end;

const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);

var dTxtLeft, dTxtTop: integer;
    rr: TRect; s: string;
begin
  if not Assigned(Canvas) then Canvas := Button.Canvas;
  
  //TButtonState = (btsUp, btsDisabled, btsDown, btsHot);
  //--
  if not Button.Enabled then BtnState:= btsDisabled;
  with Canvas do
  begin
    dTxtLeft:= 0; dTxtTop:= 0;
    Canvas.Font := Button.Font;
    Pen.Color := clBlack;
    Pen.Style  := psSolid;

    if (Button.SelfObj is TCustomControl) and (Canvas = Button.Canvas) then
      DrawThemeParentBackground(TCustomControl(Button.SelfObj).Handle, Handle, nil);

    {if csDesigning in Button.ComponentState then
      DrawUp
      else} case BtnState of
        btsUp        : DrawUp;
        btsHot       : DrawHot;
        btsDown      : begin
                         dTxtLeft:= 1; dTxtTop:= 1;
                         DrawDown;
                       end;
        btsDisabled  : begin
                         DrawDisabled;
                         Brush.Style := bsClear;
                       end;
      end;
    Button.DoResize(TObject(Button));

    if Button.ShowCaption then
    begin
      s  := Button.Caption;
      rr := Button.CaptionPositions.CaptionRect;
      OffsetRect(rr, dTxtLeft, dTxtTop);
      Brush.Style:= bsClear;
      DrawText(Canvas.Handle, PChar(s), Length(s), rr,
               Button.CaptionPositions.GetDrawTextFlags);
    end;

    if (Button.SelfObj is TUcWinButton) and
       Button.Enabled and
       TUcWinButton(Button.SelfObj).ShowFocus and
       TUcWinButton(Button.SelfObj).Focused then
    begin
      Brush.Style:= bsSolid;
      DrawFocusRect(Rect(3, 3, Button.Width - 3, Button.Height - 3));
    end;

    Button.DoPaint;
  end;
end;

procedure CF_CMMouseEnter(Button: IUcButton; var Message: TMessage);
var NeedRepaint: Boolean;
    OldState: TButtonState;
begin
  { Don't draw a border if DragMode <> dmAutomatic since this button is meant to
    be used as a dock client. }
  OldState:= Button.State;
  if Button.State = btsUp then Button.State:= btsHot;

  NeedRepaint := not Button.MouseInControl and
                 Button.Enabled and (Button.DragMode <> dmAutomatic) and
                 (GetCapture = 0) or (OldState <> Button.State);
  { Windows XP introduced hot states also for non-flat buttons. }
  if (NeedRepaint or ThemeServices.ThemesEnabled) and not (csDesigning in Button.ComponentState) then
  begin
    Button.MouseInControl := True;
    if Button.Enabled then
      Button.Repaint;
  end;
end;

procedure CF_CMMouseLeave(Button: IUcButton; var Message: TMessage);
var NeedRepaint: Boolean;
    OldState: TButtonState;
begin
  OldState:= Button.State;
  if Button.State = btsHot then Button.State:= btsUp;
  NeedRepaint := Button.MouseInControl and
                 Button.Enabled and not Button.Dragging_ or (OldState <> Button.State);
  { Windows XP introduced hot states also for non-flat buttons. }
  if NeedRepaint or ThemeServices.ThemesEnabled then
  begin
    Button.MouseInControl := False;
    if Button.Enabled then
      Button.Repaint;
  end;
end;

procedure CF_SkinManagerChange(Button: IUcButton; Sender: TObject);
var SM: TUcSkinManager;
    SCI: TUcSkinCollectionItem;
begin
  if Sender is TUcSkinManager then
  begin
    SM := Sender as TUcSkinManager;
    case SM.ChangeInfo of
      sciImage: Button.Images.UpdateSkinPainters;

      sciStyle: begin
        if SM.ChangedItem is TUcSkinCollectionItem then
          SCI := SM.ChangedItem as TUcSkinCollectionItem
          else
          SCI := nil;

        if Assigned(SCI) then
          Button.Images.UpdateSkinPainters(SCI.Name);
      end;
    end;
  end;
end;
//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM

{ TUniversalWinButton }
constructor TUcWinButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCaptionPositions:= TCaptionPositions.Create(Self);
  FCaptionPositions.OnChangeCaptionCenter:= ChangeCaptionPosition;
  FImages:= TButtonImages.Create(Self);
  FImages.ImgUp.OnChange        := GlyphChanged;
  FImages.ImgDisabled.OnChange  := GlyphChanged;
  FImages.ImgDown.OnChange      := GlyphChanged;
  FImages.ImgHot.OnChange       := GlyphChanged;
  FImages.OnChangeImagesParams  := GlyphChanged;
  OnResize                      := DoResize;

  FCaptionEx := TStringList.Create;
  TStringList(FCaptionEx).OnChange := CaptionExChange;

  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FGroupIndex := 0;
  FDown       := False;
  FFlat       := False;
  FShowFocus  := True;
  FShowCaption := True;

  SetBounds(0, 0, 100, 25);
  ControlStyle  := [csAcceptsControls, csCaptureMouse, csDoubleClicks, csSetCaption];
  FButtonStyle  := bsClassic;
  ParentFont    := True;
  Color         := clBtnFace;
  Inc(ButtonCount);

  TabStop       := True;
end;

destructor TUcWinButton.Destroy;
begin
  Dec(ButtonCount);
  if Assigned(FSkinManager) then FSkinManager.UnregisterNotify(SkinManagerChange);

  FImages.Free;
  FCaptionPositions.Free;
  FCaptionEx.Free;
  FImageChangeLink.Free;

  inherited Destroy;
end;

procedure TUcWinButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  DoResize(Self);
end;

procedure TUcWinButton.Paint;
begin
  CF_Paint(Self, State);
end;

procedure TUcWinButton.PaintTo(DC: HDC; BtnState: TButtonState);
var Cnv: TCanvas;
begin
  Cnv := TCanvas.Create;
  try
    Cnv.Handle := DC;
    CF_Paint(Self, BtnState, Cnv);
  finally
    Cnv.Free;
  end;
end;

procedure TUcWinButton.UpdateTracking;
var
  P: TPoint;
begin
  if Enabled then
  begin
    GetCursorPos(P);
    FMouseInControl := not (FindDragTarget(P, True) = Self);
    if FMouseInControl then
      Perform(CM_MOUSELEAVE, 0, 0)
    else
      Perform(CM_MOUSEENTER, 0, 0);
  end;
end;

procedure TUcWinButton.Loaded;
begin
  inherited Loaded;
end;

procedure TUcWinButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled and(not Dragging) then
  begin
    if not FDown then
    begin
      FState := btsDown;
      Invalidate;
    end;
    FDragging := true;
  end;
end;

procedure TUcWinButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewState: TButtonState;
begin
  inherited MouseMove(Shift, X, Y);
  if FDragging then
  begin
    if not FDown then NewState := btsUp
    else NewState := btsDown;
    if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
      if FDown then NewState := btsDown else NewState := btsDown;
    if NewState <> FState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end
  else if not FMouseInControl then
    UpdateTracking;
end;

procedure TUcWinButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  DoClick: Boolean;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FDragging then
  begin
    FDragging := False;
    DoClick := (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight);
    if FGroupIndex = 0 then
    begin
      { Redraw face in-case mouse is captured }
      FState := btsUp;
      FMouseInControl := False;
      if DoClick and not (FState in [btsDown, btsDown]) then
        Invalidate;
    end
    else
      if DoClick then
      begin
        SetDown(not FDown);
        if FDown then Repaint;
      end
      else
      begin
        if FDown then FState := btsDown;
        Repaint;
      end;
    if DoClick then Click;
    UpdateTracking;
  end;
end;

procedure TUcWinButton.Click;
var Form: TCustomForm;
begin
  Form := GetParentForm(Self);
  if Form <> nil then Form.ModalResult := ModalResult;
  inherited Click;
end;

function TUcWinButton.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TUniversalButtonActionLink;
end;

procedure TUcWinButton.GlyphChanged(Sender: TObject);
begin
  DoResize(self);
  Invalidate;
end;

procedure TUcWinButton.UpdateDown;
var
  Msg: TMessage;
begin
  if (FGroupIndex <> 0) and (Parent <> nil) then
  begin
    Msg.Msg := CM_BUTTONPRESSED;
    Msg.WParam := FGroupIndex;
    Msg.LParam := Longint(Self);
    Msg.Result := 0;
    Parent.Broadcast(Msg);
  end;
end;

function  TUcWinButton.GetDown: Boolean;
begin
  Result := FDown;
end;

function TUcWinButton.GetDragging: Boolean;
begin
  Result := FDragging;
end;

function TUcWinButton.GetDragMode: TDragMode;
begin
  Result := inherited DragMode;
end;

function TUcWinButton.GetFlat: Boolean;
begin
  Result := FFlat;
end;

function TUcWinButton.GetFont_: TFont;
begin
  Result := inherited Font;
end;

procedure TUcWinButton.SetDown(Value: Boolean);
begin
  //if FGroupIndex = 0 then Value := False;
  if Value <> FDown then
  begin
    if FDown and (not FAllowAllUp) and (FGroupIndex <> 0) then Exit;
    FDown := Value;
    if Value then
    begin
      if FState = btsUp then Invalidate;
      FState := btsDown
    end
    else
    begin
      FState := btsUp;
      Repaint;
    end;
    if Value then UpdateDown;
    if Assigned(OnChangeState) then OnChangeState(Self);
  end;
end;

procedure TUcWinButton.SetDragging(const Value: Boolean);
begin
  FDragging := Value;
end;

procedure TUcWinButton.SetDragMode(Value: TDragMode);
begin
  inherited DragMode := Value;
end;

function  TUcWinButton.GetGroupIndex: Integer;
begin
  Result := FGroupIndex;
end;

procedure TUcWinButton.SetGroupIndex(Value: Integer);
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    UpdateDown;
  end;
end;

procedure TUcWinButton.SetButtonStyle(const Value: TButtonStyle);
begin
  if FButtonStyle <> Value then
   begin
     FButtonStyle := Value;
     Invalidate;
   end;
end;

procedure TUcWinButton.SetFlat(const Value: Boolean);
begin
  if Value <> FFlat then
  begin
    FFlat := Value;
    Invalidate;
  end;
end;

procedure TUcWinButton.SetFont_(const Value: TFont);
begin
  inherited Font := Value;
end;

procedure TUcWinButton.SetShowCaption(const Value: Boolean);
begin
  if Value <> FShowCaption then
  begin
    FShowCaption := Value;
    Invalidate;
  end;
end;

procedure TUcWinButton.SetShowFocus(Value: Boolean);
begin
  if Value <> FShowFocus then
  begin
    FShowFocus := Value;
    if Focused then
      Invalidate;
  end;
end;

procedure TUcWinButton.SetState(const Value: TButtonState);
begin
  FState := Value;
end;

procedure TUcWinButton.SetDefault(Value: Boolean);
var
  Form: TCustomForm;
begin
  FDefault := Value;
  if HandleAllocated then
  begin
    Form := GetParentForm(Self);
    if Form <> nil then
{$IF DEFINED(CLR)}
      (Form as IWinControl).FocusChanged(Form.ActiveControl);
{$ELSE}
      Form.Perform(CM_FOCUSCHANGED, 0, Longint(Form.ActiveControl));
{$IFEND}
  end;
end;

procedure TUcWinButton.ImageListChange(Sender: TObject);
begin
  if Sender = BtnImages then Invalidate;
end;

procedure TUcWinButton.CaptionExChange(Sender: TObject);
var S: string;
begin
  while (FCaptionEx.Count > 0) and (FCaptionEx[0] = '') do
    FCaptionEx.Delete(0);
  while (FCaptionEx.Count > 0) and (FCaptionEx[FCaptionEx.Count - 1] = '') do
    FCaptionEx.Delete(FCaptionEx.Count - 1);

  S := FCaptionEx.Text;
  if Copy(S, length(S) - 1, 2) = #13#10 then
    Delete(S, length(S) - 1, 2);

  Caption := S;
end;

function  TUcWinButton.GetBtnImages: TCustomImageList;
begin
  Result := FBtnImages;
end;

function TUcWinButton.GetButtonStyle: TButtonStyle;
begin
  Result := FButtonStyle;
end;

procedure TUcWinButton.SetBtnImages(Value: TCustomImageList);
begin
  if FBtnImages <> nil then FBtnImages.UnRegisterChanges(FImageChangeLink);
  FBtnImages := Value;
  if FBtnImages <> nil then
  begin
    FBtnImages.RegisterChanges(FImageChangeLink);
    FBtnImages.FreeNotification(Self);
    FImages.DoParentResize;
  end;

  Invalidate;
end;

procedure TUcWinButton.SetSkinManager(const Value: TUcSkinManager);
begin
  if FSkinManager <> Value then
  begin
    if Assigned(FSkinManager) then FSkinManager.UnregisterNotify(SkinManagerChange);
    FSkinManager := Value;
    if Assigned(Value) then
    begin
      Value.FreeNotification(Self);
      Value.RegisterNotify(SkinManagerChange);
    end;
    FImages.UpdateSkinPainters;
    Invalidate;
  end;
end;

function  TUcWinButton.GetImages: TButtonImages;
begin
  Result := FImages;
end;

function TUcWinButton.GetMouseInControl: Boolean;
begin
  Result := FMouseInControl;
end;

function TUcWinButton.GetShowCaption: Boolean;
begin
  Result := FShowCaption;
end;

function TUcWinButton.GetSkinManager: TUcSkinManager;
begin
  Result := FSkinManager;
end;

function TUcWinButton.GetState: TButtonState;
begin
  Result := FState;
end;

procedure TUcWinButton.SetImages(Value: TButtonImages);
begin
  FImages := Value;
end;

procedure TUcWinButton.SetMouseInControl(const Value: Boolean);
begin
  FMouseInControl := Value;
end;

procedure TUcWinButton.SetCaptionEx(Value: TStrings);
begin
  FCaptionEx.Assign(Value);
end;

procedure TUcWinButton.SetCaptionPositions(const Value: TCaptionPositions);
begin
  FCaptionPositions := Value;
end;

procedure TUcWinButton.ChangeCaptionPosition(Sender: TObject);
begin
  DoResize(Self);
  Invalidate;
end;

procedure TUcWinButton.DoPaint;
begin
  if Assigned(FOnPaint) then FOnPaint(Self);
end;

procedure TUcWinButton.DoResize(Sender: TObject);
begin
  FCaptionPositions.DoParentResize;
  FImages.DoParentResize;
end;

function  TUcWinButton.GetAllowAllUp: Boolean;
begin
  Result := FAllowAllUp;
end;

procedure TUcWinButton.SetAllowAllUp(Value: Boolean);
begin
  if FAllowAllUp <> Value then
  begin
    FAllowAllUp := Value;
    UpdateDown;
  end;
end;

procedure TUcWinButton.WMLButtonDblClk(var Message: TWMLButtonDown);
begin
  inherited;
  //if FDown then
    DblClick;
end;

procedure TUcWinButton.CMEnabledChanged(var Message: TMessage);
const
  NewState: array[Boolean] of TButtonState = (btsDisabled, btsUp);
begin
  if Enabled then FState:= btsUp;
  UpdateTracking;
  Repaint;
end;

procedure TUcWinButton.CMButtonPressed(var Message: TMessage);
var
  Sender: TUcWinButton;
begin
  if Message.WParam = FGroupIndex then
  begin
    Sender := TUcWinButton(Message.LParam);
    if Sender <> Self then
    begin
      if Sender.Down and FDown then
      begin
        FDown := False;
        FState := btsUp;
        if (Action is TCustomAction) then
          TCustomAction(Action).Checked := False;
        if Assigned(OnChangeState) then OnChangeState(Self);
        Invalidate;
      end;
      FAllowAllUp := Sender.AllowAllUp;
    end;
  end;
end;

procedure TUcWinButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if Focused and
       (IsAccel(CharCode, Caption) or
       (CharCode = VK_RETURN)) and Enabled and Visible and
       (Parent <> nil) and Parent.Showing then
    begin
      Click;
      Result := 1;
    end else
      if Focused and (CharCode = VK_SPACE) then
      begin
//        SetDown(not FDown);
        Click;
        Result := 1;
      end else
        inherited;
end;

procedure TUcWinButton.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
    if  (((CharCode = VK_RETURN) and FActive) or
      ((CharCode = VK_ESCAPE) and FCancel)) and
      (KeyDataToShiftState(Message.KeyData) = []) and CanFocus then
    begin
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TUcWinButton.CMFontChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TUcWinButton.CMTextChanged(var Message: TMessage);
begin
  FCaptionEx.Text := Caption;
  Invalidate;
end;

procedure TUcWinButton.CMSysColorChange(var Message: TMessage);
begin
  Invalidate;
end;

procedure TUcWinButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  CF_CMMouseEnter(Self, Message);
  {$IFNDEF DELPHI_2009_UP}
  if Assigned(OnMouseEnter) then OnMouseEnter(Self);
  {$ENDIF}
end;

procedure TUcWinButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  CF_CMMouseLeave(Self, Message);
  {$IFNDEF DELPHI_2009_UP}
  if Assigned(OnMouseLeave) then OnMouseLeave(Self);
  {$ENDIF}
end;

{$IFDEF DELPHI_2009_UP}
procedure TUcWinButton.CNCtlColorStatic(var Message: TWMCtlColorStatic);
begin
  with ThemeServices do
    if ThemeControl(Self) then
    begin
      if (Parent <> nil) and Parent.DoubleBuffered then
        PerformEraseBackground(Self, Message.ChildDC)
      else
        DrawParentBackground(Handle, Message.ChildDC, nil, False);
      { Return an empty brush to prevent Windows from overpainting we just have created. }
      Message.Result := GetStockObject(NULL_BRUSH);
    end
    else
      inherited;
end;
{$ENDIF}

procedure TUcWinButton.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  if ThemeServices.ThemesEnabled then
    Message.Result := 1
  else
    DefaultHandler(Message);
end;

procedure TUcWinButton.CNCtlColorBtn(var Message: TWMCtlColorBtn);
begin
  with ThemeServices do
    if ThemesEnabled then
    begin
      if (Parent <> nil) and Parent.DoubleBuffered then
        PerformEraseBackground(Self, Message.ChildDC)
      else
        DrawParentBackground(Handle, Message.ChildDC, nil, False);
      { Return an empty brush to prevent Windows from overpainting we just have created. }
      Message.Result := GetStockObject(NULL_BRUSH);
    end
    else
      inherited;
end;

{$IF NOT DEFINED(CLR)}
procedure TUcWinButton.CMFocusChanged(var Message: TCMFocusChanged);
begin
  with Message do
    if (Sender is TUcWinButton)
        {$IFDEF DELPHI_2009_UP}
        or(Sender is TCustomButton)
        {$ENDIF}
       then
      FActive := Sender = Self
    else
      FActive := FDefault;
  inherited;
end;
{$IFEND}

{$IF DEFINED(CLR)}
[UIPermission(SecurityActionfunction TUcButtonfunction TUcButton.GetDragMode: TDragMode;
begin

end;

.GetDragMode: TDragMode;
begin

end;

procedure TUcButton.SetDragMode(const Value: TDragMode);
begin

end;

.LinkDemand, Window=UIPermissionWindow.AllWindows)]
procedure TUcWinButton.FocusChanged(NewFocusControl: TWinControl);
begin
  if (NewFocusControl is TUniversalWinButton)or
     (NewFocusControl is TCustomButton) then
    FActive := NewFocusControl = Self
  else
    FActive := FDefault;
  inherited;
end;
{$IFEND}

function TUcWinButton.GetVersion: TCaption;
begin
  Result:= UcButtonsVersion;
end;

procedure TUcWinButton.SetVersion(Value: TCaption);
begin
  //--
end;

procedure TUcWinButton.SkinManagerChange(Sender: TObject);
begin
  CF_SkinManagerChange(Self, Sender);
end;

function  TUcWinButton.SelfObj: TControl;
begin
  Result := Self;
end;

function  TUcWinButton.GetWidth: Integer;
begin
  Result := Width;
end;

function  TUcWinButton.GetHeight: Integer;
begin
  Result := Height;
end;

function TUcWinButton.GetComponentState: TComponentState;
begin
  Result := inherited ComponentState;
end;

function  TUcWinButton.GetControlStyle: TControlStyle;
begin
  Result := inherited ControlStyle;
end;

procedure TUcWinButton.SetControlStyle(Value: TControlStyle);
begin
  inherited ControlStyle := Value;
end;

function  TUcWinButton.GetCaption: TCaption;
begin
  Result := inherited Caption;
end;

function TUcWinButton.GetCaptionPositions: TCaptionPositions;
begin
  Result := FCaptionPositions;
end;

procedure TUcWinButton.SetCaption(Value: TCaption);
begin
  inherited Caption := Value;
  FCaptionPositions.CalcCaptionRect;
end;

function  TUcWinButton.GetCanvas: TCanvas;
begin
  Result := inherited Canvas;
end;

procedure TUcWinButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FBtnImages then BtnImages := nil;
    if AComponent = FSkinManager then
    begin
      FSkinManager := nil;
      Images.UpdateSkinPainters;
    end;
    Invalidate;
  end;
end;

procedure TUcWinButton.WndProc(var Message: TMessage);

  procedure DoFocus;
  begin
    Windows.SetFocus(Handle);
  end;

begin
  case Message.Msg of
    WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
      if not (csDesigning in ComponentState) and not Focused
         and CanFocus then
      begin
        DoFocus;
      end;
    WM_SETFOCUS:
      Invalidate;

    WM_KILLFOCUS:
      Invalidate;
  end;
  //ShowMyHint(Self, IntToStr(Message.Msg));
  inherited WndProc(Message);
end;

procedure TUcWinButton.CreateWnd;
begin
  //if Assigned(Parent) then
    inherited;
  FActive := FDefault;
end;

procedure TUcWinButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  CF_ActionChange(Self, Sender, CheckDefaults);
end;

{ TUniversalButton }

constructor TUcButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCaptionPositions:= TCaptionPositions.Create(Self);
  FCaptionPositions.OnChangeCaptionCenter:= ChangeCaptionPosition;
  FImages:= TButtonImages.Create(Self);
  FImages.ImgUp.OnChange        := GlyphChanged;
  FImages.ImgDisabled.OnChange  := GlyphChanged;
  FImages.ImgDown.OnChange      := GlyphChanged;
  FImages.ImgHot.OnChange       := GlyphChanged;
  FImages.OnChangeImagesParams  := GlyphChanged;
  OnResize                      := DoResize;

  FCaptionEx := TStringList.Create;
  TStringList(FCaptionEx).OnChange := CaptionExChange;

  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FGroupIndex := 0;
  FDown       := False;
  FFlat       := False;
  FShowCaption := True;

  SetBounds(0, 0, 100, 25);
  ControlStyle  := [csCaptureMouse, csDoubleClicks];
  FButtonStyle  := bsClassic;
  ParentFont    := True;
  Color         := clBtnFace;
  Inc(ButtonCount);
end;

destructor TUcButton.Destroy;
begin
  Dec(ButtonCount);
  if Assigned(FSkinManager) then FSkinManager.UnregisterNotify(SkinManagerChange);

  FImages.Free;
  FCaptionPositions.Free;
  FCaptionEx.Free;
  FImageChangeLink.Free;

  inherited Destroy;
end;

procedure TUcButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  DoResize(Self);
end;

procedure TUcButton.Paint;
begin
  CF_Paint(Self, State);
end;

procedure TUcButton.PaintTo(DC: HDC; BtnState: TButtonState);
var Cnv: TCanvas;
begin
  Cnv := TCanvas.Create;
  try
    Cnv.Handle := DC;
    CF_Paint(Self, BtnState, Cnv);
  finally
    Cnv.Free;
  end;
end;

procedure TUcButton.UpdateTracking;
var
  P: TPoint;
begin
  if Enabled then
  begin
    GetCursorPos(P);
    FMouseInControl := not (FindDragTarget(P, True) = Self);
    if FMouseInControl then
      Perform(CM_MOUSELEAVE, 0, 0)
    else
      Perform(CM_MOUSEENTER, 0, 0);
  end;
end;

procedure TUcButton.Loaded;
begin
  inherited Loaded;
end;

procedure TUcButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled and(not Dragging) then
  begin
    if not FDown then
    begin
      FState := btsDown;
      Invalidate;
    end;
    FDragging := true;
  end;
end;

procedure TUcButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewState: TButtonState;
begin
  inherited MouseMove(Shift, X, Y);
  if FDragging then
  begin
    if not FDown then NewState := btsUp
    else NewState := btsDown;
    if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
      if FDown then NewState := btsDown else NewState := btsDown;
    if NewState <> FState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end
  else if not FMouseInControl then
    UpdateTracking;
end;

procedure TUcButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  DoClick: Boolean;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FDragging then
  begin
    FDragging := False;
    DoClick := (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight);
    if FGroupIndex = 0 then
    begin
      { Redraw face in-case mouse is captured }
      FState := btsUp;
      FMouseInControl := False;
      if DoClick and not (FState in [btsDown, btsDown]) then
        Invalidate;
    end
    else
      if DoClick then
      begin
        SetDown(not FDown);
        if FDown then Repaint;
      end
      else
      begin
        if FDown then FState := btsDown;
        Repaint;
      end;
    if DoClick then Click;
    UpdateTracking;
  end;
end;

procedure TUcButton.Click;
var Form: TCustomForm;
begin
  Form := GetParentForm(Self);
  if Form <> nil then Form.ModalResult := ModalResult;
  inherited Click;
end;

function TUcButton.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TUniversalButtonActionLink;
end;

procedure TUcButton.GlyphChanged(Sender: TObject);
begin
  DoResize(self);
  Invalidate;
end;

procedure TUcButton.UpdateDown;
var
  Msg: TMessage;
begin
  if (FGroupIndex <> 0) and (Parent <> nil) then
  begin
    Msg.Msg := CM_BUTTONPRESSED;
    Msg.WParam := FGroupIndex;
    Msg.LParam := Longint(Self);
    Msg.Result := 0;
    Parent.Broadcast(Msg);
  end;
end;

function  TUcButton.GetDown: Boolean;
begin
  Result := FDown;
end;

function TUcButton.GetDragging: Boolean;
begin
  Result := FDragging;
end;

function TUcButton.GetDragMode: TDragMode;
begin
  Result := inherited DragMode;
end;

function TUcButton.GetFlat: Boolean;
begin
  Result := FFlat;
end;

function TUcButton.GetFont_: TFont;
begin
  Result := inherited Font;
end;

procedure TUcButton.SetDown(Value: Boolean);
begin
  //if FGroupIndex = 0 then Value := False;
  if Value <> FDown then
  begin
    if FDown and (not FAllowAllUp) and (FGroupIndex <> 0) then Exit;
    FDown := Value;
    if Value then
    begin
      if FState = btsUp then Invalidate;
      FState := btsDown
    end
    else
    begin
      FState := btsUp;
      Repaint;
    end;
    if Value then UpdateDown;
    if Assigned(OnChangeState) then OnChangeState(Self);
  end;
end;

procedure TUcButton.SetDragging(const Value: Boolean);
begin
  FDragging := Value;
end;

procedure TUcButton.SetDragMode(Value: TDragMode);
begin
  inherited DragMode := Value;
end;

function  TUcButton.GetGroupIndex: Integer;
begin
  Result := FGroupIndex;
end;

procedure TUcButton.SetGroupIndex(Value: Integer);
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    UpdateDown;
  end;
end;

procedure TUcButton.SetButtonStyle(const Value: TButtonStyle);
begin
  if FButtonStyle <> Value then
   begin
     FButtonStyle := Value;
     Invalidate;
   end;
end;

procedure TUcButton.SetFlat(const Value: Boolean);
begin
  if Value <> FFlat then
  begin
    FFlat := Value;
    Invalidate;
  end;
end;

procedure TUcButton.SetFont_(const Value: TFont);
begin
  inherited Font := Value;
end;

procedure TUcButton.ImageListChange(Sender: TObject);
begin
  if Sender = BtnImages then Invalidate;
end;

procedure TUcButton.CaptionExChange(Sender: TObject);
var S: string;
begin
  while (FCaptionEx.Count > 0) and (FCaptionEx[0] = '') do
    FCaptionEx.Delete(0);
  while (FCaptionEx.Count > 0) and (FCaptionEx[FCaptionEx.Count - 1] = '') do
    FCaptionEx.Delete(FCaptionEx.Count - 1);

  S := FCaptionEx.Text;
  if Copy(S, length(S) - 1, 2) = #13#10 then
    Delete(S, length(S) - 1, 2);

  Caption := S;
end;

function  TUcButton.GetBtnImages: TCustomImageList;
begin
  Result := FBtnImages;
end;

function TUcButton.GetButtonStyle: TButtonStyle;
begin
  Result := FButtonStyle;
end;

procedure TUcButton.SetBtnImages(Value: TCustomImageList);
begin
  if FBtnImages <> nil then FBtnImages.UnRegisterChanges(FImageChangeLink);
  FBtnImages := Value;
  if FBtnImages <> nil then
  begin
    FBtnImages.RegisterChanges(FImageChangeLink);
    FBtnImages.FreeNotification(Self);
    FImages.DoParentResize;
  end;

  Invalidate;
end;

function  TUcButton.GetImages: TButtonImages;
begin
  Result := FImages;
end;

function TUcButton.GetMouseInControl: Boolean;
begin
  Result := FMouseInControl;
end;

function TUcButton.GetShowCaption: Boolean;
begin
  Result := FShowCaption;
end;

function TUcButton.GetSkinManager: TUcSkinManager;
begin
  Result := FSkinManager;
end;

function TUcButton.GetState: TButtonState;
begin
  Result := FState;
end;

procedure TUcButton.SetImages(Value: TButtonImages);
begin
  FImages := Value;
end;

procedure TUcButton.SetMouseInControl(const Value: Boolean);
begin
  FMouseInControl := Value;
end;

procedure TUcButton.SetShowCaption(const Value: Boolean);
begin
  if Value <> FShowCaption then
  begin
    FShowCaption := Value;
    Invalidate;
  end;
end;

procedure TUcButton.SetSkinManager(const Value: TUcSkinManager);
begin
  if FSkinManager <> Value then
  begin
    if Assigned(FSkinManager) then FSkinManager.UnregisterNotify(SkinManagerChange);
    FSkinManager := Value;
    if Assigned(Value) then
    begin
      Value.FreeNotification(Self);
      Value.RegisterNotify(SkinManagerChange);
    end;
    FImages.UpdateSkinPainters;
    Invalidate;
  end;
end;

procedure TUcButton.SetState(const Value: TButtonState);
begin
  FState := Value;
end;

procedure TUcButton.SetCaptionEx(Value: TStrings);
begin
  FCaptionEx.Assign(Value);
end;

procedure TUcButton.SetCaptionPositions(const Value: TCaptionPositions);
begin
  FCaptionPositions := Value;
end;

procedure TUcButton.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
    if  (((CharCode = VK_RETURN) and FDefault) or
      ((CharCode = VK_ESCAPE) and FCancel)) and
      (KeyDataToShiftState(Message.KeyData) = []){ and CanFocus} then
    begin
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TUcButton.ChangeCaptionPosition(Sender: TObject);
begin
  DoResize(Self);
  Invalidate;
end;

procedure TUcButton.DoPaint;
begin
  if Assigned(FOnPaint) then FOnPaint(Self);
end;

procedure TUcButton.DoResize(Sender: TObject);
begin
  FCaptionPositions.DoParentResize;
  FImages.DoParentResize;
end;

function  TUcButton.GetAllowAllUp: Boolean;
begin
  Result := FAllowAllUp;
end;

procedure TUcButton.SetAllowAllUp(Value: Boolean);
begin
  if FAllowAllUp <> Value then
  begin
    FAllowAllUp := Value;
    UpdateDown;
  end;
end;

procedure TUcButton.WMLButtonDblClk(var Message: TWMLButtonDown);
begin
  inherited;
  if FDown then DblClick;
end;

procedure TUcButton.CMEnabledChanged(var Message: TMessage);
const
  NewState: array[Boolean] of TButtonState = (btsDisabled, btsUp);
begin
  if Enabled then FState:= btsUp;
  UpdateTracking;
  Repaint;
end;

procedure TUcButton.CMButtonPressed(var Message: TMessage);
var
  Sender: TUcButton;
begin
  if Message.WParam = FGroupIndex then
  begin
    Sender := TUcButton(Message.LParam);
    if Sender <> Self then
    begin
      if Sender.Down and FDown then
      begin
        FDown := False;              
        FState := btsUp;
        if (Action is TCustomAction) then
          TCustomAction(Action).Checked := False;
        if Assigned(OnChangeState) then OnChangeState(Self);
        Invalidate;
      end;
      FAllowAllUp := Sender.AllowAllUp;
    end;
  end;
end;

procedure TUcButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and Enabled and Visible and
      (Parent <> nil) and Parent.Showing then
    begin
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TUcButton.CMFontChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TUcButton.CMTextChanged(var Message: TMessage);
begin
  FCaptionEx.Text := Caption;
  Invalidate;
end;

procedure TUcButton.CMSysColorChange(var Message: TMessage);
begin
  Invalidate;
end;

procedure TUcButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  CF_CMMouseEnter(Self, Message);
  {$IFNDEF DELPHI_2009_UP}
  if Assigned(OnMouseEnter) then OnMouseEnter(Self);
  {$ENDIF}
end;

procedure TUcButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  CF_CMMouseLeave(Self, Message);
  {$IFNDEF DELPHI_2009_UP}
  if Assigned(OnMouseLeave) then OnMouseLeave(Self);
  {$ENDIF}
end;

function TUcButton.GetVersion: TCaption;
begin
  Result:= UcButtonsVersion;
end;

procedure TUcButton.SetVersion(Value: TCaption);
begin
  //--
end;

procedure TUcButton.SkinManagerChange(Sender: TObject);
begin
  CF_SkinManagerChange(Self, Sender);
end;

function  TUcButton.SelfObj: TControl;
begin
  Result := Self;
end;

function  TUcButton.GetWidth: Integer;
begin
  Result := Width;
end;

function  TUcButton.GetHeight: Integer;
begin
  Result := Height;
end;

function TUcButton.GetComponentState: TComponentState;
begin
  Result := inherited ComponentState;
end;

function  TUcButton.GetControlStyle: TControlStyle;
begin
  Result := inherited ControlStyle;
end;

procedure TUcButton.SetControlStyle(Value: TControlStyle);
begin
  inherited ControlStyle := Value;
end;

function  TUcButton.GetCaption: TCaption;
begin
  Result := inherited Caption;
end;

function TUcButton.GetCaptionPositions: TCaptionPositions;
begin
  Result := FCaptionPositions;
end;

procedure TUcButton.SetCaption(Value: TCaption);
begin
  inherited Caption := Value;
  FCaptionPositions.CalcCaptionRect;
end;

function  TUcButton.GetCanvas: TCanvas;
begin
  Result := inherited Canvas;
end;

procedure TUcButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FBtnImages then BtnImages := nil;
    if AComponent = FSkinManager then
    begin
      FSkinManager := nil;
      Images.UpdateSkinPainters;
    end;
    Invalidate;
  end;
end;

procedure TUcButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  CF_ActionChange(Self, Sender, CheckDefaults);
end;


{ TUniversalButton }
constructor TUniversalButton.Create(AOwner: TComponent);
begin
  inherited;

  FFlat        := False;
  FButtonStyle := bsImaged;
end;


end.
