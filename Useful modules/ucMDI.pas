// Версия - 08.05.2013
unit ucMDI;
{$include ..\delphi_ver.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms,
  UcButtons, ComCtrls, ucTypes;

type
  { TMDIController у ведомого окна занимает событие OnActivate.
    Если необходимо использовать это событие в основном окне то
    нужно использовать следующий код:

    procedure TCustomEditFormMDI.FormActivate(Sender: TObject);
    begin
      inherited;
      fMDIController.FormActivate;

      // любые другие операции!
    end;
  }
  TMDIController = class(TComponent)
  private
    fForm: TForm;
    fTaskBar: TWinControl;      // панель для кнопок
    fButton: TUcButton;         // Кнопка для управления окном
    procedure InitControlBtn;   // Инициация кнопки
    procedure DoButtonClick(Sender: TObject);
    procedure DoContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure DoFormActivate(Sender: TObject);

  public
    constructor Create(iForm: TForm; iTaskBar: TWinControl); reintroduce;
    destructor Destroy; override;
    procedure FormActivate;
    procedure Update;
    property Button: TUcButton read fButton;
  end;

  function CreateMDIController(iForm: TForm; iTaskBar: TWinControl): TMDIController;

var MDIControllerMaxWidthButton: Integer = 200;
implementation

function CreateMDIController(iForm: TForm; iTaskBar: TWinControl): TMDIController;
begin
  Result := TMDIController.Create(iForm, iTaskBar);
end;

{ TTaskBarControl }
type
  TTaskBarControl = class
  public
    // Обработчик OnResize панели для кнопок
    procedure DoTaskBarResize(Sender: TObject);
  end;

var
  TaskBarControl_: TTaskBarControl = nil;

function TaskBarControl: TTaskBarControl;
begin
  if not Assigned(TaskBarControl_) then
    TaskBarControl_ := TTaskBarControl.Create;
  Result := TaskBarControl_;
end;

procedure TTaskBarControl.DoTaskBarResize(Sender: TObject);
var NewWidth, i: Integer;
    Ctrl: TControl;
begin
  if TToolBar(Sender).ControlCount > 0 then
  begin
    NewWidth := TToolBar(Sender).Width div TToolBar(Sender).ControlCount;
    if  NewWidth > MDIControllerMaxWidthButton then
      NewWidth := MDIControllerMaxWidthButton;
    for I := 0 to TToolBar(Sender).ControlCount - 1 do
    begin
      Ctrl := TToolBar(Sender).Controls[i];

      {$IFDEF DELPHI_2009_UP}
      if Ctrl.AlignWithMargins then
      begin
        Ctrl.Width := NewWidth - Ctrl.Margins.Left - Ctrl.Margins.Right;
        Ctrl.Height:= TToolBar(Sender).Height - Ctrl.Margins.Top - Ctrl.Margins.Bottom;
      end else
      begin
      {$ENDIF}
        Ctrl.Width := NewWidth;
        Ctrl.Height:= TToolBar(Sender).Height;
      {$IFDEF DELPHI_2009_UP}
      end;
      {$ENDIF}
    end;
  end;
end;

{ TMDIController }
constructor TMDIController.Create(iForm: TForm; iTaskBar: TWinControl);
begin
  inherited Create(iForm);
  fForm    := iForm;
  fTaskBar := iTaskBar;
  InitControlBtn;
end;

type
  TCtrlHack = class(TControl);

destructor TMDIController.Destroy;
var fTaskBarExists: Boolean;
begin
  fTaskBarExists := fButton.Parent = fTaskBar;
  inherited;
  if fTaskBarExists and Assigned(TCtrlHack(fTaskBar).OnResize) then TCtrlHack(fTaskBar).OnResize(fTaskBar);
end;

procedure TMDIController.InitControlBtn;   // Инициация кнопки
var Img: TIcon;
begin
  // Создание кнопки
  fButton := TUcButton.Create(self);
  with fButton do
  begin
    Caption   := fForm.Caption;
    GroupIndex:= 1;
    CaptionPositions.WordEllipsis := True;
    OnClick   := DoButtonClick;
    OnContextPopup := DoContextPopup;
    //--
    Img := nil;
    if not fForm.Icon.Empty then Img := fForm.Icon
    else if not Application.MainForm.Icon.Empty then Img := Application.MainForm.Icon
    else if not Application.Icon.Empty then Img := Application.Icon;

    if Assigned(Img) then
      with Images.ImgUp do
      begin
        Bitmap.Width  := 16;
        Bitmap.Height := 16;
        DrawIconEx(Bitmap.Canvas.Handle, 0, 0, Img.Handle, 16, 16, 0, 0, DI_NORMAL);
        Bitmap.Transparent := True;
      end;
    Images.Transparent := true;
    //--
    Parent := fTaskBar;
    Align  := alLeft;
    Left   := fTaskBar.Width + 1000; // чтобы кнопка оказалась в конце списка
    ButtonStyle := bsClassic;
    Images.PosLeft := 4;
    CaptionPositions.Padding.Left := 22;
    CaptionPositions.Padding.Right:= 5;
    CaptionPositions.Alignment := taLeftJustify;
  end;

  // Owner Form
  if not Assigned(fForm.OnActivate) then
    fForm.OnActivate := DoFormActivate;
  // TaskBar
  if not Assigned(TCtrlHack(fTaskBar).OnResize) then
    TCtrlHack(fTaskBar).OnResize := TaskBarControl.DoTaskBarResize;
  TCtrlHack(fTaskBar).OnResize(fTaskBar);
  //**
end;

procedure TMDIController.DoButtonClick(Sender: TObject);
begin
  fForm.Show;
end;

type
  TformCrack = class(TForm);

procedure TMDIController.DoContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  fForm.Show;
  TformCrack(fForm).Activate;
  MousePos := TControl(Sender).ClientToScreen(MousePos);
  fForm.Perform(WM_SYSCOMMAND, Integer(TrackPopupMenu(GetSystemMenu(fForm.Handle, False),
              TPM_RETURNCMD, MousePos.X, MousePos.Y, 0, fForm.Handle, nil)), 0);
  Handled := True;
end;

procedure TMDIController.DoFormActivate(Sender: TObject);
begin
  FormActivate;
end;

procedure TMDIController.FormActivate;
begin
  fButton.Down := True;
end;

procedure TMDIController.Update;
begin
  fButton.Caption := fForm.Caption;
end;
{ ** }

initialization

finalization
  TaskBarControl_.Free;

end.
