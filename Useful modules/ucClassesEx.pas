// Версия - 25.11.2013
unit ucClassesEx;
{$include ..\delphi_ver.inc}

interface

uses Forms, Classes, StrUtils, SysUtils, ucTypes, ucClasses, ucThreadHelper, Windows;

type
  TUcThreadedNotifyObjectEx = class(TUcNotifyObjectEx)
  private
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Лог всех сообщений процесса обработки</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    fLog: TStringList;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Вспомогательный поток (для выполнения действий в отдельном
    ///	потоке)</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    ThreadHelper: TUcThreadHelper;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Префикс текстового сообщения</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    FNotifyTxtPrefix: string;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Признак прерывания выполнения действий</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    fStop: Boolean;
    fFreeOnTerminate: Boolean;
    function  ThreadHelper_Init: Boolean;
    procedure ThreadHelper_DeInit;
    procedure ThreadHelperDoFree(Sender: TObject);
    function ThreadHelperTerminated: boolean;

    function GetPaused: Boolean;
    function GetFinished: Boolean;
    function GetFreeOnTerminate: Boolean;
    function GetHandle: THandle;
    procedure SetFreeOnTerminate(const Value: Boolean);
  protected
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Индикатор определяющий, что уже выполняется некоторая операци
    ///	и нельзя запускать другую</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    fIsBusy: Boolean;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Проверяет занят ли этот объект другой обработкой</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function CheckIsBusy: Boolean; virtual;
    function IsStopped: Boolean; virtual;
    // Обработка
    procedure DoExecute; virtual;
    procedure DoStop; virtual;
    procedure DoThreadDestroyed; virtual;
    property NotifyTxtPrefix: string read FNotifyTxtPrefix write FNotifyTxtPrefix;
    procedure ThreadSynchronize(ThreadMethod: TThreadMethod);
  public
    MultiThreaded: boolean;
    constructor Create; override;
    destructor Destroy; override;
    procedure Notifycation(const iInf: TUcNotifyInfos; const iTag, iMax, iPos: Integer;
                           const iTxt: string = ''; const iErr: Boolean = False); override;
    // Обработка
    function Execute(Wait: Boolean = True): Boolean;
    // Управление процессом установки
    procedure Pause; virtual;
    procedure Resume; virtual;
    procedure Stop;
    function CanStop: Boolean; virtual;
    // Освободить позже
    procedure FreeLater();
    // Состояние обработки
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Индикатор определяющий, что уже выполняется некоторая операци
    ///	и нельзя запускать другую</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property IsBusy: Boolean read fIsBusy;
    property Stopped: Boolean read fStop;
    property Log: TStringList read fLog;
    property IsPaused: Boolean read GetPaused;
    property IsFinished: Boolean read GetFinished;
    property Handle: THandle read GetHandle;
    property FreeOnTerminate: Boolean read GetFreeOnTerminate write SetFreeOnTerminate;
  end;

implementation

{ TUcThreadedNotifyObjectEx }

function TUcThreadedNotifyObjectEx.CanStop: Boolean;
begin
  Result := not fStop;
end;

function TUcThreadedNotifyObjectEx.CheckIsBusy: Boolean;
begin
  Result := fIsBusy;
  if Result then
    Notifycation([niTxt, niErr], 0, 0, 0, 'Уже выполняется другая обработка!', True);
end;

constructor TUcThreadedNotifyObjectEx.Create;
begin
  inherited Create;
  fFreeOnTerminate := True;
  // Инициализация лога сообщений
  fLog := TStringList.Create;
  FNotifyTxtPrefix  := ''; // Префикс сообщения

  // Настройка окружения
  ThreadHelper  := nil;
  MultiThreaded := False;
  fStop         := False;  // Признак прерывания выполнения действий
  fIsBusy       := False;  // Признак выполнения "занятости" обработчика
  SetNotify([niMax, niPos, niTxt, niErr], 0, 0, 0, '', False);
end;

destructor TUcThreadedNotifyObjectEx.Destroy;
begin
  if Assigned(ThreadHelper) then
    if ThreadHelper.FreeOnTerminate then
        ThreadHelper.Terminate()
      else
        ThreadHelper.Free();
  fLog.Free;
  inherited;
end;

procedure TUcThreadedNotifyObjectEx.DoExecute;
begin
  { Этот метод предназначен для выполнения целевого, долгого действия в потоке
   (!) Не забываем про разделение данных в потоках и при необходимости
       используем вызов ThreadHelper.ThreadSynchronize() }
end;

procedure TUcThreadedNotifyObjectEx.DoStop;
begin
    // .................Набор действий/оповещений при остановке.................
end;

procedure TUcThreadedNotifyObjectEx.DoThreadDestroyed;
begin

end;

function TUcThreadedNotifyObjectEx.Execute(Wait: Boolean = True): Boolean;
begin
  Result := not CheckIsBusy and (MultiThreaded or ThreadHelper_Init);
  if Result then
  try
    fStop   := False;
    fIsBusy := True;
    WereErrors := False;
    // Выполнение в отдельном потоке
    if MultiThreaded then
      DoExecute
      else
      ThreadHelper.ThreadExecute(DoExecute, Wait);
    // **
    if MultiThreaded or Wait then
    begin
      Result := not WereErrors;
      ThreadHelper_DeInit;
    end;
  finally
    if MultiThreaded or Wait then fIsBusy := False;
  end;
end;

procedure TUcThreadedNotifyObjectEx.FreeLater;
begin
  if IsFinished then
    Free()
  else
  begin
    UnregisterNotifyAll();
    FreeOnTerminate := True;
    Stop;
    if IsPaused then Resume();
  end;
end;

function TUcThreadedNotifyObjectEx.GetFinished: Boolean;
begin
  if Assigned(ThreadHelper) then
    Result := ThreadHelper.Finished
  else
    Result := True;
end;

function TUcThreadedNotifyObjectEx.GetFreeOnTerminate: Boolean;
begin
//  if Assigned(ThreadHelper) then
//    Result := ThreadHelper.FreeOnTerminate
//  else
//    Result := False;
  Result := fFreeOnTerminate;
end;

function TUcThreadedNotifyObjectEx.GetHandle: THandle;
begin
  if Assigned(ThreadHelper) then
    Result := ThreadHelper.Handle
  else
    Result := INVALID_HANDLE_VALUE;
end;

function TUcThreadedNotifyObjectEx.GetPaused: Boolean;
begin
  if Assigned(ThreadHelper) then
    Result := ThreadHelper.Suspended
  else
    Result := False;
end;

function TUcThreadedNotifyObjectEx.IsStopped: Boolean;
begin
  Result := (not MultiThreaded and ThreadHelperTerminated)
             or fStop or Application.Terminated;
end;

procedure TUcThreadedNotifyObjectEx.Notifycation(const iInf: TUcNotifyInfos;
  const iTag, iMax, iPos: Integer; const iTxt: string; const iErr: Boolean);
var Txt: string;
begin
  if niTxt in iInf then
  begin
    Txt := IfThen((niErr in iInf) and iErr, 'err::') +
           IfThen(NotifyTxtPrefix <> '', NotifyTxtPrefix + '. ') + iTxt;
    fLog.Add(Txt);
  end;

  if Assigned(ThreadHelper) then
  begin
    SetNotify(iInf, iTag, iMax, iPos, Txt, iErr);
    ThreadHelper.ThreadSynchronize(Notify);
  end else
    inherited Notifycation(iInf, iTag, iMax, iPos, Txt, iErr);
end;

procedure TUcThreadedNotifyObjectEx.Pause;
begin
  if Assigned(ThreadHelper) then
    ThreadHelper.Suspended := True;
end;

procedure TUcThreadedNotifyObjectEx.Resume;
begin
  if Assigned(ThreadHelper) then
    ThreadHelper.Suspended := False;
end;

procedure TUcThreadedNotifyObjectEx.SetFreeOnTerminate(const Value: Boolean);
begin
  fFreeOnTerminate := Value;
  if Assigned(ThreadHelper) then
    ThreadHelper.FreeOnTerminate := fFreeOnTerminate; //Value;
end;

procedure TUcThreadedNotifyObjectEx.Stop;
begin
  if not fStop then
  begin
    fStop := True;
    DoStop;
  end;
end;

procedure TUcThreadedNotifyObjectEx.ThreadHelperDoFree(Sender: TObject);
begin
  if fFreeOnTerminate then ThreadHelper := nil;
  fIsBusy := False;
  DoThreadDestroyed;
end;

function TUcThreadedNotifyObjectEx.ThreadHelperTerminated: boolean;
begin
  Result := not Assigned(ThreadHelper) or ThreadHelper.Terminated;
end;

procedure TUcThreadedNotifyObjectEx.ThreadHelper_DeInit;
begin
  FreeAndNil(ThreadHelper);
  fIsBusy := False;
end;

function TUcThreadedNotifyObjectEx.ThreadHelper_Init: Boolean;
begin
  Result := not MultiThreaded and not Assigned(ThreadHelper);

  if ((not Result) AND (Assigned(ThreadHelper)) AND (not fFreeOnTerminate)) then
  begin
    Result := True;
    ThreadHelper.Free();
  end;

  if Result then
  begin
    ThreadHelper := TUcThreadHelper.Create;
    ThreadHelper.FreeOnTerminate := fFreeOnTerminate;
    ThreadHelper.OnTerminate := ThreadHelperDoFree;
  end;
end;

procedure TUcThreadedNotifyObjectEx.ThreadSynchronize(
  ThreadMethod: TThreadMethod);
begin
  if Assigned(ThreadHelper) then
    ThreadHelper.ThreadSynchronize(ThreadMethod)
    else
    ThreadMethod;
end;

end.
