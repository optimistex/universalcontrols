// Версия - 12.02.2014 //25.11.2013
unit ucThreadHelper;
{$include ..\delphi_ver.inc}

interface

uses Forms, Classes, Windows;

type
  /// <summary>
  /// Этот класс позволяет переданный метод выполнить в отдельном потоке.
  /// </summary>
  TUcThreadHelper = class(TThread)
  private
    fThreadMethod: TThreadMethod; // Метод выполняемый в потоке
    fCanExecute: Boolean;         // Для того, что бы поток можно было запустить 1-н раз!
    fFinished: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create; reintroduce;
    /// <summary>
    ///  Выполнене метода в отдельном потоке
    /// <param name="ThreadMethod">Метод который нужно выполнить в отдельном потоке</param>
    /// <param name="Wait">Ожидание завершения потока</param>
    /// </summary>
    function ThreadExecute(ThreadMethod: TThreadMethod; Wait: Boolean): boolean;
    /// <summary>
    /// Синхронизация потока с приложением.
    /// </summary>
    procedure ThreadSynchronize(ThreadMethod: TThreadMethod);
    procedure Terminate;
    procedure WaitWhileExecute;
    property Terminated;
{$IFNDEF DELPHI_2009_UP}
    property Finished: Boolean read fFinished;
{$ENDIF}
  end;


implementation

{ TThreadHelper }

constructor TUcThreadHelper.Create;
begin
  inherited Create(True);
  fCanExecute := True;
  fFinished   := False;
end;

procedure TUcThreadHelper.Execute;
begin
  // Возможны ситуации при которых поток начинает выполнятся до того как свойство
  // Suspend было сброшено в False, в результате чего метод ThreadSynchronize
  // будет работать не правильно, поэтому ждем
  while Suspended do ;  
  fThreadMethod;
  fFinished := True;
end;

procedure TUcThreadHelper.Terminate;
begin
  inherited;
// Закомментировано 12.02.2014
//  TerminateThread(Handle, 0);
end;

function TUcThreadHelper.ThreadExecute(ThreadMethod: TThreadMethod; Wait: Boolean): boolean;
begin
  Result := fCanExecute;
  if Result then
  begin
    fCanExecute   := False;
    fThreadMethod := ThreadMethod;
    Suspended     := False;
    // Ожидание завершения потока
    if Wait then WaitWhileExecute;
    //**
  end;
end;

procedure TUcThreadHelper.ThreadSynchronize(ThreadMethod: TThreadMethod);
begin
  if Suspended then
    ThreadMethod
    else
    Synchronize(ThreadMethod);
end;

procedure TUcThreadHelper.WaitWhileExecute;
begin
{$IFDEF DELPHI_2009_UP}
  while not Finished do
{$ELSE}
  while not fFinished do
{$ENDIF}
    Application.ProcessMessages;
end;

end.
