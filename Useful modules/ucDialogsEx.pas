// Версия - 05.05.2012
unit ucDialogsEx;
{$include ..\delphi_ver.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  {$IFDEF DELPHI_2009_UP}
  ucDialogs,
  {$ELSE}
  Dialogs,
  {$ENDIF}

  ExtCtrls, StdCtrls;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Показ диалогового окна с сообщением пользователю и таймером на
///	указанной кнопке для автоматического срабатывания</summary>
///	<param name="Msg">Текст сообщения</param>
///	<param name="DlgType">Тип сообщения</param>
///	<param name="Buttons">Набор кнопок</param>
///	<param name="AutoClickedButton">Кнопка на которой вывести таймер обратного
///	отсчета</param>
///	<param name="Counter">Время таймера обратного отсчета в
///	миллисекундах</param>
///	<example>UC_MessageDlgCountDown('test', mtInformation, [mbYes, mbCancel],
///	mbYes, 8000);</example>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_MessageDlgCountDown(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; AutoClickedButton: TMsgDlgBtn;
  Counter: Cardinal = 9000): Integer;

implementation

type
  TTimerDlgCountDown = class(TTimer)
  private
    Dlg: TForm;
    Btn: TButton;
    BtnCaption: TCaption;
    procedure UpdateButton;
  protected
    procedure DoTimer(Sender: TObject);
  public
    Counter: Cardinal;
    constructor Create(AOwner: TComponent); reintroduce;
    procedure Init(AutoClickedButton: TMsgDlgBtn; iCounter: Cardinal);
  end;

var
  // Скопировано из модуля ucDialogs.pas (Dialogs.pas)
  {$IFDEF DELPHI_2009_UP}
  ButtonNames: array[TMsgDlgBtn] of string = (
    'Yes', 'No', 'OK', 'Cancel', 'Abort', 'Retry', 'Ignore', 'All', 'NoToAll',
    'YesToAll', 'Help', 'Close');
  {$ELSE}
  ButtonNames: array[TMsgDlgBtn] of string = (
    'Yes', 'No', 'OK', 'Cancel', 'Abort', 'Retry', 'Ignore', 'All', 'NoToAll',
    'YesToAll', 'Help');
  {$ENDIF}

constructor TTimerDlgCountDown.Create(AOwner: TComponent);
begin
  Assert(AOwner is TForm);

  inherited Create(AOwner);
  Interval := 1000;
  Dlg      := TForm(AOwner);
  OnTimer  := DoTimer;
  Btn      := nil;
end;

procedure TTimerDlgCountDown.Init(AutoClickedButton: TMsgDlgBtn; iCounter: Cardinal);
var Cmt: TComponent;
begin
  Counter  := iCounter;

  Cmt := Dlg.FindComponent(ButtonNames[AutoClickedButton]);
  if Cmt is TButton then
  begin
    Btn := TButton(Cmt);
    BtnCaption := Btn.Caption;
  end;

  UpdateButton;
  Enabled := True;
end;

procedure TTimerDlgCountDown.DoTimer(Sender: TObject);
begin
  Dec(Counter, Interval);
  UpdateButton;
  if Counter > 0 then
    Enabled := True;
end;

procedure TTimerDlgCountDown.UpdateButton;
begin
  if Assigned(Btn) then
  begin
    Btn.Caption := Format(BtnCaption + ' [%d]', [Counter div 1000]);
    if Counter <= 0 then Dlg.ModalResult := Btn.ModalResult;
  end;
end;

{ F U N C T I O N S }

function UC_MessageDlgCountDown(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; AutoClickedButton: TMsgDlgBtn;
  Counter: Cardinal = 9000): Integer;
var Dlg: TForm;
    Tmr: TTimerDlgCountDown;
begin
  Dlg := CreateMessageDialog(Msg, DlgType, Buttons);
  Dlg.Position := poScreenCenter;
  // Добавляем таймер обратного отсчета
  Tmr := TTimerDlgCountDown.Create(Dlg);
  Tmr.Init(AutoClickedButton, Counter);
  //**
  Result := Dlg.ShowModal;
end;

end.

