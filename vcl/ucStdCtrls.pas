unit ucStdCtrls;

interface

uses Windows, Messages, Classes, Controls, StdCtrls, Graphics,
     ucTypes, ucWindows;

type
  TUcLabel = class(TLabel)
  private
    FStyle: TUcLabelStyle;
    FWebLink: string;
    FEndEllipsis: Boolean;
    FOnPaint: TNotifyEvent;
    FShowCaption: Boolean;
    procedure SetStyle(const Value: TUcLabelStyle);
    function GetTransparent: Boolean;
    procedure SetTransparent(const Value: Boolean);
    function GetVersion: TCaption;
    procedure SetVersion(const Value: TCaption);
    procedure SetShowCaption(const Value: Boolean);
    procedure SetEndEllipsis(const Value: Boolean);
  protected
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Click; override;

    procedure Paint; override;
    procedure DoPaint; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DefaultPaint; virtual;
  published
    property Version: TCaption read GetVersion write SetVersion;
    property WebLink: string read FWebLink write FWebLink;
    property Style: TUcLabelStyle read FStyle write SetStyle default ulsLabel;
    property Transparent: Boolean read GetTransparent write SetTransparent default True;
    property ShowCaption: Boolean read FShowCaption write SetShowCaption default True;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default False;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property OnResize;
    property OnCanResize;
  end;

procedure Register;

implementation

{$R *.dcr}
{$Include ..\Versions.ucver}

procedure Register;
begin
  RegisterComponents('UControls', [TUcLabel]);
end;

{ TUcLabel }

procedure TUcLabel.Click;
begin
  inherited;
  if FStyle = ulsWebLink then UC_GoToWebSite(FWebLink);
end;

procedure TUcLabel.CMMouseEnter(var Message: TMessage);
begin
  if FStyle in [ulsLink, ulsWebLink] then
    Font.Style := Font.Style + [fsUnderline];
  inherited;
end;

procedure TUcLabel.CMMouseLeave(var Message: TMessage);
begin
  if FStyle in [ulsLink, ulsWebLink] then
    Font.Style := Font.Style - [fsUnderline];
  inherited;
end;

constructor TUcLabel.Create(AOwner: TComponent);
begin
  inherited;
  FEndEllipsis := False;
  ControlStyle := ControlStyle - [csOpaque];
  FShowCaption := True;
  FWebLink     := 'http://optitrex.ru';
end;

procedure TUcLabel.DefaultPaint;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  Rect, CalcRect: TRect;
  DrawStyle: Longint;
begin
  with Canvas do
  begin
    Rect := ClientRect;
    if not Transparent then
    begin
      Brush.Color := Self.Color;
      Brush.Style := bsSolid;
      FillRect(Rect);
    end;

    Brush.Style := bsClear;
    { DoDrawText takes care of BiDi alignments }
    DrawStyle := DT_EXPANDTABS or WordWraps[WordWrap] or Alignments[Alignment];
    { Calculate vertical layout }
    if Layout <> tlTop then
    begin
      CalcRect := Rect;
      DoDrawText(CalcRect, DrawStyle or DT_CALCRECT);
      if Layout = tlBottom then OffsetRect(Rect, 0, Height - CalcRect.Bottom)
      else OffsetRect(Rect, 0, (Height - CalcRect.Bottom) div 2);
    end;
    DoDrawText(Rect, DrawStyle);
  end;
end;

procedure TUcLabel.DoPaint;
begin
  if Assigned(FOnPaint) then FOnPaint(Self);
end;

function TUcLabel.GetTransparent: Boolean;
begin
  Result := not (csOpaque in ControlStyle);
end;

function TUcLabel.GetVersion: TCaption;
begin
  Result:= UcLabelVersion;
end;

procedure TUcLabel.Paint;
const
  Alignments_: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps_: array[Boolean] of Word = (0, DT_WORDBREAK);
  EndEllipsis_: array[Boolean] of Word = (0, DT_END_ELLIPSIS);
var
  Rect, CalcRect: TRect;
  DrawStyle: Longint;
begin
  if FShowCaption then
    with Canvas do
    begin
      Rect := ClientRect;
      if not Transparent then
      begin
        Brush.Color := Self.Color;
        Brush.Style := bsSolid;
        FillRect(Rect);
      end;

      Brush.Style := bsClear;
      { DoDrawText takes care of BiDi alignments }
      DrawStyle := DT_EXPANDTABS or WordWraps_[WordWrap] or
                   Alignments_[Alignment] or EndEllipsis_[EndEllipsis];
      { Calculate vertical layout }
      if Layout <> tlTop then
      begin
        CalcRect := Rect;
        DoDrawText(CalcRect, DrawStyle or DT_CALCRECT);
        if Layout = tlBottom then OffsetRect(Rect, 0, Height - CalcRect.Bottom)
        else OffsetRect(Rect, 0, (Height - CalcRect.Bottom) div 2);
      end;
      DoDrawText(Rect, DrawStyle);
    end;
  DoPaint;
end;

procedure TUcLabel.SetEndEllipsis(const Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    Invalidate;
  end;
end;

procedure TUcLabel.SetShowCaption(const Value: Boolean);
begin
  if Value <> FShowCaption then
  begin
    FShowCaption := Value;
    Invalidate;
  end;
end;

procedure TUcLabel.SetStyle(const Value: TUcLabelStyle);
begin
  FStyle := Value;
  if FStyle = ulsLabel then
    Cursor := crDefault
    else
    Cursor := crHandPoint;
end;

procedure TUcLabel.SetTransparent(const Value: Boolean);
begin
  if Transparent <> Value then
  begin
    if Value then
      ControlStyle := ControlStyle - [csOpaque]
    else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end;
end;

procedure TUcLabel.SetVersion(const Value: TCaption);
begin
  //--
end;

end.
