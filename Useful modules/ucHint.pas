// Версия - 28.05.2012
unit ucHint;
{$include ..\delphi_ver.inc}

interface
Uses Windows, Messages, Forms, Graphics, SysUtils, ExtCtrls, Controls, Classes, ucFunctions;

type
  TCustomHint = class (THintWindow)
    T: TTimer;
    Procedure OnTime(Sender: TObject);
  private
    CurrentTime: Cardinal;
    Delay      : Cardinal;
    StartP     : Tpoint;
  protected
    procedure Paint; override;
  public
    Text: string;
    KillTime   : Cardinal;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowHint(MaxWidth: Integer = 0); overload;
    procedure ShowHint(X, Y: Integer; MaxWidth: Integer = 0;
                       PointAsCenter: Boolean = False); overload;
  end;

  procedure ShowMyHint(AOwner: TComponent; AText: string;
                       Time: Cardinal = 300; MaxWidth: Integer = 0); overload;

  procedure ShowMyHint(AOwner: TComponent; X, Y: Integer; AText: string;
                       Time: Cardinal = 300; MaxWidth: Integer = 0;
                       PointAsCenter: Boolean = False); overload;

implementation

uses Types;

var H: TCustomHint = nil;
    OldHintText: string = '';

constructor TCustomHint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Delay:= 100;
  T:= TTimer.Create(self);
  CurrentTime :=0;
  KillTime    := 1000;
  with T do
   begin
    Interval:= Delay;
    Enabled := true;
    OnTimer := Self.OnTime;
   end;
  Windows.GetCursorPos(StartP);
end;

destructor TCustomHint.Destroy;
begin
  H := nil;
  inherited;
end;

procedure TCustomHint.ShowHint(MaxWidth: Integer = 0);
var  P: TPoint;
//     R: Trect;
begin
  Windows.GetCursorPos(P);

  ShowHint(P.X + 10, P.Y + 15, MaxWidth);

//  if MaxWidth > 0 then
//    R:= CalcHintRect(MaxWidth, Text, nil)
//    else
//    R:= CalcHintRect(Screen.Width-P.X, Text, nil);
//
//  OffsetRect(R, P.X + 10, P.Y + 15);
//  ActivateHint(R,Text);
//  CurrentTime:= 0;
end;

procedure TCustomHint.ShowHint(X, Y: Integer; MaxWidth: Integer = 0;
                               PointAsCenter: Boolean = False);
var  R: Trect;
begin
  if MaxWidth > 0 then
    R:= CalcHintRect(MaxWidth, Text, nil)
    else
    R:= CalcHintRect(Screen.Width - X, Text, nil);

  if PointAsCenter then
    OffsetRect(R, X - UC_RectWidth(R) div 2, Y - UC_RectHeight(R) div 2)
    else
    OffsetRect(R, X, Y);
  ActivateHint(R,Text);
  CurrentTime:= 0;
end;

Procedure TCustomHint.OnTime(Sender: TObject);
var P: TPoint;
begin
  Inc(CurrentTime, Delay);
  T.Enabled  := true;
  if CurrentTime>= KillTime then
    begin
      Windows.GetCursorPos(P);
      if (Abs(P.X-StartP.X)<5)and(Abs(P.Y-StartP.Y)<5) then Exit;
      if Self = H then
        FreeAndNil(H)
        else
        Free;
    end;
end;

procedure TCustomHint.Paint;
begin
  Canvas.Brush.Color := clInfoBk;
  Canvas.FillRect(Canvas.ClipRect);
  Canvas.Brush.Style := bsClear;
  inherited Paint;
end;

procedure ShowMyHint(AOwner: TComponent; AText: string;
                     Time: Cardinal = 300; MaxWidth: Integer = 0); //Показать мое сообщение
begin
  if AText='' then Exit;
  if Assigned(H)and(AText=OldHintText) then H.CurrentTime:= 0
  else begin
    if not Assigned(H) then
    begin
      H:= TCustomHint.Create(AOwner);
      H.KillTime:= Time;
    end;
    H.Text := AText;
    H.ShowHint(MaxWidth);
  end;
  OldHintText:= H.Text;
end;

procedure ShowMyHint(AOwner: TComponent; X, Y: Integer; AText: string;
                     Time: Cardinal = 300; MaxWidth: Integer = 0;
                     PointAsCenter: Boolean = False); overload;
begin
  if AText='' then Exit;
  if Assigned(H)and(AText=OldHintText) then H.CurrentTime:= 0
  else begin
    if not Assigned(H) then
    begin
      H:= TCustomHint.Create(AOwner);
      H.KillTime:= Time;
    end;
    H.Text := AText;
    H.ShowHint(X, Y, MaxWidth, PointAsCenter);
  end;
  OldHintText:= H.Text;
end;

end.
