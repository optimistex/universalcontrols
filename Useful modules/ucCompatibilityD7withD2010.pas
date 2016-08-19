unit ucCompatibilityD7withD2010;

interface

uses Classes, Controls, Types;

type
  TMarginSize = 0..MaxInt;

  TMargins = class(TPersistent)
  private
    FControl: TControl;
    FLeft, FTop, FRight, FBottom: TMarginSize;
    FOnChange: TNotifyEvent;
    procedure SetMargin(Index: Integer; Value: TMarginSize);
  protected
    procedure Change; virtual;
    procedure AssignTo(Dest: TPersistent); override;
//    function GetControlBound(Index: Integer): Integer; virtual;
    class procedure InitDefaults(Margins: TMargins); virtual;
    property Control: TControl read FControl;
  public
    constructor Create(Control: TControl); virtual;
//    procedure SetControlBounds(ALeft, ATop, AWidth, AHeight: Integer; Aligning: Boolean = False); overload;
//    procedure SetControlBounds(const ARect: TRect; Aligning: Boolean = False); overload;
    procedure SetBounds(ALeft, ATop, ARight, ABottom: Integer);
//    property ControlLeft: Integer index 0 read GetControlBound;
//    property ControlTop: Integer index 1 read GetControlBound;
//    property ControlWidth: Integer index 2 read GetControlBound;
//    property ControlHeight: Integer index 3 read GetControlBound;
//    property ExplicitLeft: Integer index 4 read GetControlBound;
//    property ExplicitTop: Integer index 5 read GetControlBound;
//    property ExplicitWidth: Integer index 6 read GetControlBound;
//    property ExplicitHeight: Integer index 7 read GetControlBound;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Left: TMarginSize index 0 read FLeft write SetMargin default 3;
    property Top: TMarginSize index 1 read FTop write SetMargin default 3;
    property Right: TMarginSize index 2 read FRight write SetMargin default 3;
    property Bottom: TMarginSize index 3 read FBottom write SetMargin default 3;
  end;

  TPadding = class(TMargins)
  protected
    class procedure InitDefaults(Margins: TMargins); override;
  published
    property Left default 0;
    property Top default 0;
    property Right default 0;
    property Bottom default 0;
  end;

implementation

{ TMargins }

constructor TMargins.Create(Control: TControl);
begin
  inherited Create;
  FControl := Control;
  InitDefaults(Self);
end;

procedure TMargins.AssignTo(Dest: TPersistent);
begin
  if Dest is TMargins then
    with TMargins(Dest) do
    begin
      FLeft := Self.FLeft;
      FTop := Self.FTop;
      FRight := Self.FRight;
      FBottom := Self.FBottom;
      Change;
    end
  else
    inherited;
end;

procedure TMargins.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

class procedure TMargins.InitDefaults(Margins: TMargins);
begin
  with Margins do
  begin
    FLeft := 3;
    FRight := 3;
    FTop := 3;
    FBottom := 3;
  end;
end;

procedure TMargins.SetMargin(Index: Integer; Value: TMarginSize);
begin
  case Index of
    0:
      if Value <> FLeft then
      begin
        FLeft := Value;
        Change;
      end;
    1:
      if Value <> FTop then
      begin
        FTop := Value;
        Change;
      end;
    2:
      if Value <> FRight then
      begin
        FRight := Value;
        Change;
      end;
    3:
      if Value <> FBottom then
      begin
        FBottom := Value;
        Change;
      end;
  end;
end;

//procedure TMargins.SetControlBounds(ALeft, ATop, AWidth, AHeight: Integer; Aligning: Boolean);
//begin
//  if Control <> nil then
//  begin
//    if Aligning then
//    begin
//      Control.FAnchorMove := True;
//      Include(Control.FControlState, csAligning);
//    end;
//    try
//      if Control.AlignWithMargins and (Control.Parent <> nil) then
//        Control.SetBounds(ALeft + FLeft, ATop + FTop, AWidth - (FLeft + FRight), AHeight - (FTop + FBottom))
//      else
//        Control.SetBounds(ALeft, ATop, AWidth, AHeight);
//    finally
//      if Aligning then
//      begin
//        Control.FAnchorMove := False;
//        Exclude(Control.FControlState, csAligning);
//      end;
//    end;
//  end;
//end;
//
//procedure TMargins.SetControlBounds(const ARect: TRect; Aligning: Boolean);
//begin
//  SetControlBounds(ARect.Left, ARect.Top, ARect.Right - ARect.Left, ARect.Bottom - ARect.Top, Aligning);
//end;

procedure TMargins.SetBounds(ALeft, ATop, ARight, ABottom: Integer);
begin
  if (FLeft <> ALeft) or (FTop <> ATop) or (FRight <> ARight) or (FBottom <> ABottom) then
  begin
    FLeft := ALeft;
    FTop := ATop;
    FRight := ARight;
    FBottom := ABottom;
    Change;
  end;
end;

//function TMargins.GetControlBound(Index: Integer): Integer;
//begin
//  Result := 0;
//  if FControl <> nil then
//    case Index of
//      0:
//        if FControl.AlignWithMargins and (FControl.Parent <> nil) then
//          Result := FControl.Left - FLeft
//        else
//          Result := FControl.Left;
//      1:
//        if FControl.AlignWithMargins and (FControl.Parent <> nil) then
//          Result := FControl.Top - FTop
//        else
//          Result := FControl.Top;
//      2:
//        if FControl.AlignWithMargins and (FControl.Parent <> nil) then
//          Result := FControl.Width + FLeft + FRight
//        else
//          Result := FControl.Width;
//      3:
//        if FControl.AlignWithMargins and (FControl.Parent <> nil) then
//          Result := FControl.Height + FTop + FBottom
//        else
//          Result := FControl.Height;
//      4:
//        if FControl.AlignWithMargins and (FControl.Parent <> nil) then
//          Result := FControl.ExplicitLeft - FLeft
//        else
//          Result := FControl.ExplicitLeft;
//      5:
//        if FControl.AlignWithMargins and (FControl.Parent <> nil) then
//          Result := FControl.ExplicitTop - FTop
//        else
//          Result := FControl.ExplicitTop;
//      6:
//        if FControl.AlignWithMargins and (FControl.Parent <> nil) then
//          Result := FControl.ExplicitWidth + FLeft + FRight
//        else
//          Result := FControl.ExplicitWidth;
//      7:
//        if FControl.AlignWithMargins and (FControl.Parent <> nil) then
//          Result := FControl.ExplicitHeight + FTop + FBottom
//        else
//          Result := FControl.ExplicitHeight;
//    end;
//end;

{ TPadding }

class procedure TPadding.InitDefaults(Margins: TMargins);
begin
  { Zero initialization is sufficient here }
end;

end.
