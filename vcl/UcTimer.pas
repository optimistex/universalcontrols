unit UcTimer;
{$include ..\delphi_ver.inc}

interface

uses
  Windows, Messages, Forms, SysUtils, Classes, ExtCtrls, Controls, Consts;

type
  { TWinTimer - класс содран с TTimer и дописан. Содран из-за ограничений
    секции private !!!}
  TUcTimer = class(TComponent)
  private
    FWindowHandle: HWND;
    FInterval: Cardinal;
    fAlarmClock: Cardinal;
    fCounter: Cardinal;
    FOnTimer: TNotifyEvent;
    fOnAlarmClock: TNotifyEvent;

    FEnabled: Boolean;

    procedure UpdateTimer;
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: Cardinal);
    procedure SetOnTimer(Value: TNotifyEvent);
    procedure WndProc(var Msg: TMessage);

    procedure SetOnAlarmClock(Value: TNotifyEvent);

    function GetVersion: string;
    procedure SetVersion(Value: string);
  protected
    procedure Timer; dynamic;
{$IF DEFINED(CLR)}
  strict protected
    procedure Finalize; override;
{$IFEND}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Reset(NewAlarm: Cardinal = 0);
    procedure Restart;
    property Counter: Cardinal read fCounter;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default False;
    property Interval: Cardinal read FInterval write SetInterval default 100;
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;

    property Version: string read GetVersion write SetVersion stored False;
    property AlarmClock: Cardinal read fAlarmClock write fAlarmClock default 1000;
    property OnAlarmClock: TNotifyEvent read fOnAlarmClock
                                        write SetOnAlarmClock stored true;
  end;

procedure Register;

implementation

{$R *.dcr}
{$Include ..\Versions.ucver}

procedure Register;
begin
  RegisterComponents('UControls', [TUcTimer]);
end;

{ TWinTimer }

constructor TUcTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := False;
  FInterval := 100;
  fAlarmClock := 1000;
  fCounter    := 0;
  FWindowHandle := AllocateHWnd(WndProc);
end;

destructor TUcTimer.Destroy;
begin
  FEnabled := False;
{$IF DEFINED(CLR)}
  if FWindowHandle <> 0 then
  begin
    UpdateTimer;
    DeallocateHWnd(FWindowHandle);
    FWindowHandle := 0;
  end;
  System.GC.SuppressFinalize(self);
{$ELSE}
  DeallocateHWnd(FWindowHandle);
{$IFEND}
  inherited Destroy;
end;

{$IF DEFINED(CLR)}
procedure TWinTimer.Finalize;
begin
  FEnabled := False;
  if FWindowHandle <> 0 then
  begin
    KillTimer(FWindowHandle, 1);
    DeallocateHWnd(FWindowHandle);
    FWindowHandle := 0;
  end;
  inherited;
end;
{$IFEND}

procedure TUcTimer.WndProc(var Msg: TMessage);
begin
  with Msg do
    if Msg = WM_TIMER then
      try
        Timer;
      except
        Application.HandleException(Self);
      end
    else
      Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
end;

procedure TUcTimer.UpdateTimer;
begin
  KillTimer(FWindowHandle, 1);
  if (FInterval <> 0) and (fAlarmClock <> 0) and FEnabled and
     (Assigned(FOnTimer) or Assigned(fOnAlarmClock)) then
    if SetTimer(FWindowHandle, 1, FInterval, nil) = 0 then
      raise EOutOfResources.Create(SNoTimers);
end;

procedure TUcTimer.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure TUcTimer.SetInterval(Value: Cardinal);
begin
  if Value <> FInterval then
  begin
    if FInterval > fAlarmClock then
      FInterval := fAlarmClock
      else
      FInterval := Value;
    UpdateTimer;
  end;
end;

procedure TUcTimer.SetOnTimer(Value: TNotifyEvent);
begin
  FOnTimer := Value;
  if FEnabled and (fCounter = 0) then
    UpdateTimer;
end;

procedure TUcTimer.Timer;
begin
  if Assigned(FOnTimer) then FOnTimer(Self);

  Inc(fCounter, fInterval);
  if (fCounter >= fAlarmClock)and
     Assigned(fOnAlarmClock) then fOnAlarmClock(Self);
end;

procedure TUcTimer.SetOnAlarmClock(Value: TNotifyEvent);
begin
  fOnAlarmClock := Value;
  if FEnabled and (fCounter = 0) then
    UpdateTimer;
end;

function TUcTimer.GetVersion: string;
begin
  Result:= UcTimerVersion;
end;

procedure TUcTimer.SetVersion(Value: string);
begin
  //--
end;

procedure TUcTimer.Reset(NewAlarm: Cardinal = 0);
begin
  fCounter := NewAlarm;
end;

procedure TUcTimer.Restart;
begin
  Reset();
  Enabled := True;
end;


end.
