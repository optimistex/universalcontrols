// ¬ерси€ - 08.05.2013
unit ucGraphics;
{$include ..\delphi_ver.inc}

interface

uses Windows, SysUtils, Classes, Graphics, Math, StrUtils, Contnrs,

     {$IFDEF DELPHI_2009_UP}
     pngimage,
     {$ENDIF}

     ucTypes, ucFunctions, ucClasses;

type
  TUcPaintStyle = (ipsOriginal, ipsRepeat, ipsRepeatX, ipsRepeatY, ipsStretch,
                   ipsRepeatXStretchY, ipsRepeatYStretchX);
  TUcPaintStyleParams = (sl, st, sr, sb, sw, sh, dl, dt, dr, db, dw, dh, style, unknown);
  TUcPaintStyleParamsInfo = array[TUcPaintStyleParams] of string;

  TUcPaintInfo = record
    Src: TRect;
    Dest: TRect;
    Style: TUcPaintStyle;
  end;

  TUcPainter = class
  private
    fBufIMG: TGraphic;
    fBufIMGXend: TGraphic;
    fBufIMGYend: TGraphic;
    fBufIMGXYend: TGraphic;

    fBufIMGPrepared: Boolean;
    fPaintInfo: TUcPaintInfo;
    fSrcIMG: TGraphic;
    procedure PrepareBufImg;
    {$IFDEF DELPHI_2009_UP}
    procedure PrepareBufImgPNG(Png: TPngImage);
    {$ENDIF}
    function GetDestHeight: Integer;
    function GetDestWidth: Integer;
    function GetSrcHeight: Integer;
    function GetSrcWidth: Integer;
    procedure SetSourceIMG(SrcIMG: TGraphic);
  protected
    property SrcWidth: Integer read GetSrcWidth;
    property SrcHeight: Integer read GetSrcHeight;
    property DestWidth: Integer read GetDestWidth;
    property DestHeight: Integer read GetDestHeight;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Draw(DestCanvas: TCanvas);

    procedure SetPaintInfo(PaintInfo: TUcPaintInfo); overload;
    procedure SetPaintInfo(PaintInfo: string; BaseSrc, BaseDest: TRect); overload;

    property SourceIMG: TGraphic read fSrcIMG write SetSourceIMG;
  end;

  TUcSkinPainter = class
  private
    fPainters: TObjectList;
    fPaintInfo: string;
    fBaseSrcRect: TRect;
    fBaseDestRect: TRect;
    fSrcIMG: TGraphic;
    fNeedUpdate: Boolean;
    procedure SetBaseDestRect(const Value: TRect);
    procedure SetBaseSrcRect(const Value: TRect);
    procedure SetPaintInfo(const Value: string);
    function GetBaseDestRect: TRect;
    function GetBaseSrcRect: TRect;
    function GetPaintInfo: string;
    procedure SetSourceIMG(SrcIMG: TGraphic);
  protected
    procedure UpdatePaintInfo;
    function CreatePainter: TUcPainter;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Draw(DestCanvas: TCanvas);

    property SourceIMG: TGraphic read fSrcIMG write SetSourceIMG;
    property PaintInfo: string read GetPaintInfo write SetPaintInfo;
    property BaseSrcRect: TRect read GetBaseSrcRect write SetBaseSrcRect;
    property BaseDestRect: TRect read GetBaseDestRect write SetBaseDestRect;
  end;

  function PaintInfoParseArr(PaintInfo: string): TUcPaintStyleParamsInfo;
  function PaintInfoParseStr(PaintInfo: string; BaseSrc, BaseDest: TRect): TUcPaintInfo;
  procedure PaintInfoParseStrs(PaintInfo: string; PaintInfoList: TStrings);
  function PaintInfoBuildStr(PaintInfoList: TStrings): string;

// Convert functions
  function UC_ConvPaintStyle(vStyle: string): TUcPaintStyle; overload;
  function UC_ConvPaintStyle(vStyle: TUcPaintStyle): string; overload;

  function UC_ConvPaintStyleParam(vParam: string): TUcPaintStyleParams; overload;
  function UC_ConvPaintStyleParam(vParam: TUcPaintStyleParams): string; overload;


implementation

{ TIMGPainter }

constructor TUcPainter.Create;
begin
  inherited;
  fBufIMG      := nil;
  fBufIMGXend  := nil;
  fBufIMGYend  := nil;
  fBufIMGXYend := nil;

  fSrcIMG      := nil;
  fBufIMGPrepared := False;
end;

destructor TUcPainter.Destroy;
begin
  fBufIMG.Free;
  fBufIMGXend.Free;
  fBufIMGYend.Free;
  fBufIMGXYend.Free;
  inherited;
end;

procedure TUcPainter.Draw(DestCanvas: TCanvas);

  procedure _DrawChunk(X, Y: Integer; DestRect: TRect);
  begin
    if (DestRect.Right - X >= SrcWidth) and (DestRect.Bottom - Y >= SrcHeight) then
      DestCanvas.Draw(X, Y, fBufIMG)
    else if DestRect.Right - X >= SrcWidth then
      DestCanvas.Draw(X, Y, fBufIMGYend)
    else if DestRect.Bottom - Y >= SrcHeight then
      DestCanvas.Draw(X, Y, fBufIMGXend)
    else
      DestCanvas.Draw(X, Y, fBufIMGXYend);
  end;

var dR: TRect;
    X, Y: Integer;
begin
  PrepareBufImg;

  dR := fPaintInfo.Dest;
  X := dR.Left;
  Y := dR.Top;

  case fPaintInfo.Style of
    ipsOriginal:  _DrawChunk(X, Y, dR);

    ipsRepeat: if Assigned(fBufIMG) then
    repeat
      X := dR.Left;
      repeat
        _DrawChunk(X, Y, dR);
        inc(X, fBufIMG.Width);
      until X >= dR.Right;

      inc(Y, fBufIMG.Height);
    until Y >= dR.Bottom;

    ipsRepeatX : if Assigned(fBufIMG) then
    repeat
      _DrawChunk(X, Y, dR);
      inc(X, fBufIMG.Width);
    until X >= dR.Right;

    ipsRepeatY : if Assigned(fBufIMG) then
    repeat
      _DrawChunk(X, Y, dR);
      inc(Y, fBufIMG.Height);
    until Y >= dr.Bottom;

    ipsStretch: DestCanvas.StretchDraw(dR, fBufIMG);

    ipsRepeatXStretchY: if Assigned(fBufIMG) then
    repeat
      if dR.Right - X >= SrcWidth then
        DestCanvas.StretchDraw(Rect(X, Y, X + SrcWidth, dR.Bottom), fBufIMG)
      else
        DestCanvas.StretchDraw(Rect(X, Y, dR.Right, dR.Bottom), fBufIMGXend);

      inc(X, fBufIMG.Width);
    until X >= dR.Right;

    ipsRepeatYStretchX: if Assigned(fBufIMG) then
    repeat
      if dR.Bottom - Y >= SrcHeight then
        DestCanvas.StretchDraw(Rect(X, Y, dR.Right, Y + SrcHeight), fBufIMG)
      else
        DestCanvas.StretchDraw(Rect(X, Y, dR.Right, dR.Bottom), fBufIMGYend);

      inc(Y, fBufIMG.Height);
    until Y >= dr.Bottom;
  end;
end;

function TUcPainter.GetDestHeight: Integer;
begin
  Result := fPaintInfo.Dest.Bottom - fPaintInfo.Dest.Top;
end;

function TUcPainter.GetDestWidth: Integer;
begin
  Result := fPaintInfo.Dest.Right - fPaintInfo.Dest.Left;
end;

function TUcPainter.GetSrcHeight: Integer;
begin
  Result := fPaintInfo.Src.Bottom - fPaintInfo.Src.Top;
end;

function TUcPainter.GetSrcWidth: Integer;
begin
  Result := fPaintInfo.Src.Right - fPaintInfo.Src.Left;
end;

procedure TUcPainter.PrepareBufImg;
begin
  if not fBufIMGPrepared then
  begin
    if Assigned(fBufIMG)      then FreeAndNil(fBufIMG);
    if Assigned(fBufIMGXend)  then FreeAndNil(fBufIMGXend);
    if Assigned(fBufIMGYend)  then FreeAndNil(fBufIMGYend);
    if Assigned(fBufIMGXYend) then FreeAndNil(fBufIMGXYend);

    {$IFDEF DELPHI_2009_UP}
    if fSrcIMG is TPngImage then
      PrepareBufImgPNG(TPngImage(fSrcIMG));
    {$ENDIF}

    fBufIMGPrepared := True;
  end;
end;

{$IFDEF DELPHI_2009_UP}
procedure TUcPainter.PrepareBufImgPNG(Png: TPngImage);

    function _CreateNewPng(Src: TRect): TPngImage;
    var BufRect: TRect;
        i: Integer;
        sBarr, dBarr: pByteArray;
    begin
      BufRect := Src;
      OffsetRect(BufRect, -BufRect.Left, -BufRect.Top);
      if (BufRect.Right > 0) and (BufRect.Bottom > 0) then
      begin
//        Result := TPngImage.CreateBlank(COLOR_RGBALPHA, 8, BufRect.Right, BufRect.Bottom);
        Result := TPngImage.CreateBlank(Png.Header.ColorType, 8, BufRect.Right, BufRect.Bottom);
        BitBlt(Result.Canvas.Handle, 0, 0, BufRect.Right, BufRect.Bottom,
               Png.Canvas.Handle, Src.Left, Src.Top, SRCCOPY);
        for i := 0 to BufRect.Bottom - 1 Do
        begin
          dBarr := Result.AlphaScanline[i];
          sBarr := Png.AlphaScanline[i + Src.Top];
          if (dBarr = nil) or (sBarr = nil) then Break;
          sBarr := pByteArray(Integer(sBarr) + Src.Left);
          CopyMemory(dBarr, sBarr, BufRect.Right);
        end;
      end else
        Result :=  nil;
    end;

begin
  fBufIMG := _CreateNewPng(fPaintInfo.Src);

  if (SrcWidth > 0) and (SrcHeight > 0) then
    fBufIMGXend := _CreateNewPng(Rect(
      fPaintInfo.Src.Left, fPaintInfo.Src.Top,
      fPaintInfo.Src.Left + DestWidth mod SrcWidth, fPaintInfo.Src.Bottom
    ));

  if (SrcWidth > 0) and (SrcHeight > 0) then
    fBufIMGYend := _CreateNewPng(Rect(
      fPaintInfo.Src.Left, fPaintInfo.Src.Top,
      fPaintInfo.Src.Right, fPaintInfo.Src.Top + DestHeight mod SrcHeight
    ));

  if (SrcWidth > 0) and (SrcHeight > 0) then
    fBufIMGXYend := _CreateNewPng(Rect(
      fPaintInfo.Src.Left, fPaintInfo.Src.Top,
      fPaintInfo.Src.Left + DestWidth mod SrcWidth,
      fPaintInfo.Src.Top + DestHeight mod SrcHeight
    ));
end;
{$ENDIF}

procedure TUcPainter.SetPaintInfo(PaintInfo: TUcPaintInfo);
begin
  fPaintInfo := PaintInfo;
  fBufIMGPrepared := False;
end;

procedure TUcPainter.SetPaintInfo(PaintInfo: string; BaseSrc, BaseDest: TRect);
begin
  SetPaintInfo(PaintInfoParseStr(PaintInfo, BaseSrc, BaseDest));
end;

procedure TUcPainter.SetSourceIMG(SrcIMG: TGraphic);
begin
  fSrcIMG := SrcIMG;
  fBufIMGPrepared := False;
end;

// FUNCTIONS
function UC_ConvPaintStyle(vStyle: string): TUcPaintStyle;
begin
  if      vStyle = 'original' then Result := ipsOriginal
  else if vStyle = 'repeat'   then Result := ipsRepeat
  else if vStyle = 'repeat-x' then Result := ipsRepeatX
  else if vStyle = 'repeat-y' then Result := ipsRepeatY
  else if vStyle = 'stretch'   then Result := ipsStretch
  else if vStyle = 'repeat-x-stretch-y' then Result := ipsRepeatXStretchY
  else if vStyle = 'repeat-y-stretch-x' then Result := ipsRepeatYStretchX
  else Result := ipsOriginal;
end;

function UC_ConvPaintStyle(vStyle: TUcPaintStyle): string;
begin
  case vStyle of
    ipsOriginal         : Result := 'original';
    ipsRepeat           : Result := 'repeat';
    ipsRepeatX          : Result := 'repeat-x';
    ipsRepeatY          : Result := 'repeat-y';
    ipsStretch          : Result := 'stretch';
    ipsRepeatXStretchY  : Result := 'repeat-x-stretch-y';
    ipsRepeatYStretchX  : Result := 'repeat-y-stretch-x';
  end;
end;
         // TUcPaintStyleParams = (sl, st, sr, sb, sw, sh, dl, dt, dr, db, dw, dh, style);
function UC_ConvPaintStyleParam(vParam: string): TUcPaintStyleParams;
begin
  if vParam  = 'sl' then Result := sl
  else if vParam  = 'st' then Result := st
  else if vParam  = 'sr' then Result := sr
  else if vParam  = 'sb' then Result := sb
  else if vParam  = 'sw' then Result := sw
  else if vParam  = 'sh' then Result := sh
  else if vParam  = 'dl' then Result := dl
  else if vParam  = 'dt' then Result := dt
  else if vParam  = 'dr' then Result := dr
  else if vParam  = 'db' then Result := db
  else if vParam  = 'dw' then Result := dw
  else if vParam  = 'dh' then Result := dh
  else if vParam  = 'style' then Result := style
  else Result := unknown;
end;

function UC_ConvPaintStyleParam(vParam: TUcPaintStyleParams): string;
begin
  case vParam of
    sl: Result := 'sl';
    st: Result := 'st';
    sr: Result := 'sr';
    sb: Result := 'sb';
    sw: Result := 'sw';
    sh: Result := 'sh';
    dl: Result := 'dl';
    dt: Result := 'dt';
    dr: Result := 'dr';
    db: Result := 'db';
    dw: Result := 'dw';
    dh: Result := 'dh';
    style: Result := 'style';
  else
    Result := 'unknown';
  end;
end;

function PaintInfoParseArr(PaintInfo: string): TUcPaintStyleParamsInfo;
var params, param: TStrArray;
    i: Integer;
begin
  params := UC_Explode(';', PaintInfo);
  for i := 0 to Length(params) - 1 do
  begin
    param := UC_Explode(':', params[i], 2);

    //todo -o: запретить отрицательные ширину и высоту
    if Trim(param[0]) = 'sl'   then Result[sl] := Trim(param[1])
    else if Trim(param[0]) = 'st'    then Result[st]    := Trim(param[1])
    else if Trim(param[0]) = 'sr'    then Result[sr]    := Trim(param[1])
    else if Trim(param[0]) = 'sb'    then Result[sb]    := Trim(param[1])
    else if Trim(param[0]) = 'sw'    then Result[sw]    := Trim(param[1])
    else if Trim(param[0]) = 'sh'    then Result[sh]    := Trim(param[1])
    else if Trim(param[0]) = 'dl'    then Result[dl]    := Trim(param[1])
    else if Trim(param[0]) = 'dt'    then Result[dt]    := Trim(param[1])
    else if Trim(param[0]) = 'dr'    then Result[dr]    := Trim(param[1])
    else if Trim(param[0]) = 'db'    then Result[db]    := Trim(param[1])
    else if Trim(param[0]) = 'dw'    then Result[dw]    := Trim(param[1])
    else if Trim(param[0]) = 'dh'    then Result[dh]    := Trim(param[1])
    else if Trim(param[0]) = 'style' then Result[style] := Trim(param[1]);
  end;
end;

function PaintInfoParseStr(PaintInfo: string; BaseSrc, BaseDest: TRect): TUcPaintInfo;
var iVal: Integer;
    xParams: TUcPaintStyleParamsInfo;
begin
  xParams := PaintInfoParseArr(PaintInfo);
  Result.Src  := BaseSrc;
  Result.Dest := BaseDest;
    // src
  if TryStrToInt(xParams[sw], iVal) and (iVal > 0) then Result.Src.Right := BaseSrc.Left + iVal;
  if TryStrToInt(xParams[sh], iVal) and (iVal > 0) then Result.Src.Bottom := BaseSrc.Top + iVal;
  if TryStrToInt(xParams[sl], iVal) then
    if xParams[sw] = '' then
      Inc(Result.Src.Left, iVal)
      else
      OffsetRect(Result.Src, iVal, 0);

  if TryStrToInt(xParams[st], iVal) then
    if xParams[sh] = '' then
      Inc(Result.Src.Top, iVal)
      else
      OffsetRect(Result.Src, 0, iVal);

  if TryStrToInt(xParams[sr], iVal) then
    if xParams[sw] = '' then
      Inc(Result.Src.Right, -iVal)
      else
      OffsetRect(Result.Src, BaseSrc.Right - Result.Src.Right -iVal, 0);

  if TryStrToInt(xParams[sb], iVal) then
    if xParams[sh] = '' then
      Inc(Result.Src.Bottom, -iVal)
      else
      OffsetRect(Result.Src, 0, BaseSrc.Bottom - Result.Src.Bottom -iVal);

    // dest
  if TryStrToInt(xParams[dw], iVal) and (iVal > 0) then Result.Dest.Right := BaseDest.Left + iVal;
  if TryStrToInt(xParams[dh], iVal) and (iVal > 0) then Result.Dest.Bottom := BaseDest.Top + iVal;
  if TryStrToInt(xParams[dl], iVal) then
    if xParams[dw] = '' then
      Inc(Result.Dest.Left, iVal)
      else
      OffsetRect(Result.Dest, iVal, 0);

  if TryStrToInt(xParams[dt], iVal) then
    if xParams[dh] = '' then
      Inc(Result.Dest.Top, iVal)
      else
      OffsetRect(Result.Dest, 0, iVal);

  if TryStrToInt(xParams[dr], iVal) then
    if xParams[dw] = '' then
      Inc(Result.Dest.Right, -iVal)
      else
      OffsetRect(Result.Dest, BaseDest.Right - Result.Dest.Right -iVal, 0);

  if TryStrToInt(xParams[db], iVal) then
    if xParams[dh] = '' then
      Inc(Result.Dest.Bottom, -iVal)
      else
      OffsetRect(Result.Dest, 0, BaseDest.Bottom - Result.Dest.Bottom -iVal);

  Result.Style := UC_ConvPaintStyle(xParams[style]);
end;

procedure PaintInfoParseStrs(PaintInfo: string; PaintInfoList: TStrings);
var Ps, Pe: Integer;
begin
  Ps := Pos('{', PaintInfo);
  if Ps = 0 then
    PaintInfoList.Add(PaintInfo)
  else begin
    Pe := PosEx('}', PaintInfo, Ps + 1);
    while (Ps > 0) and (Pe > 0) do
    begin
      PaintInfoList.Add(Copy(PaintInfo, Ps + 1, Pe - Ps - 1));
      Ps := PosEx('{', PaintInfo, Pe + 1);
      Pe := PosEx('}', PaintInfo, Ps + 1);
    end;
  end;
end;

function PaintInfoBuildStr(PaintInfoList: TStrings): string;
var
  I, L, Size, Count: Integer;
  P: PChar;
  S, LB: string;
begin
  Count := PaintInfoList.Count;
  Size := Length('{}');
  LB := '}'#13#10'{';
  for I := 0 to Count - 2 do Inc(Size, Length(PaintInfoList[I]) + Length(LB));
  if Count > 0 then  Inc(Size, Length(PaintInfoList[Count - 1]));
  SetString(Result, nil, Size);
  Result[1] := '{';
  P := Pointer(Result);
  inc(P);
  for I := 0 to Count - 1 do
  begin
    S := PaintInfoList[I];
    L := Length(S);
    if L <> 0 then
    begin
      System.Move(Pointer(S)^, P^, L * SizeOf(Char));
      Inc(P, L);
    end;
    L := Length(LB);
    if (I < Count - 1) then
    begin
      System.Move(Pointer(LB)^, P^, L * SizeOf(Char));
      Inc(P, L);
    end;
  end;
  Result[Length(Result)] := '}';
end;

{ TUcSkinPainter }

constructor TUcSkinPainter.Create;
begin
  inherited;
  fSrcIMG := nil;
  fBaseSrcRect  := Rect(0, 0, 10, 10);
  fBaseDestRect := Rect(0, 0, 20, 20);

  fPainters := TObjectList.Create;
  fPainters.OwnsObjects := True;

  fNeedUpdate := True;
end;

function TUcSkinPainter.CreatePainter: TUcPainter;
begin
  Result := TUcPainter.Create;
  Result.SetSourceIMG(fSrcIMG);
end;

destructor TUcSkinPainter.Destroy;
begin
  fPainters.Free;
  inherited;
end;

procedure TUcSkinPainter.Draw(DestCanvas: TCanvas);
var i: Integer;
begin
  UpdatePaintInfo;

  for i := 0 to fPainters.Count - 1 do
    TUcPainter(fPainters[i]).Draw(DestCanvas);
end;

function TUcSkinPainter.GetBaseDestRect: TRect;
begin
  Result := fBaseDestRect
end;

function TUcSkinPainter.GetBaseSrcRect: TRect;
begin
  Result := fBaseSrcRect
end;

function TUcSkinPainter.GetPaintInfo: string;
begin
  Result := fPaintInfo;
end;

procedure TUcSkinPainter.SetBaseDestRect(const Value: TRect);
begin
  if not UC_RectIsEqual(Value, FBaseDestRect) then
  begin
    FBaseDestRect := Value;
    fNeedUpdate := True;
  end;
end;

procedure TUcSkinPainter.SetBaseSrcRect(const Value: TRect);
begin
  if not UC_RectIsEqual(Value, fBaseSrcRect) then
  begin
    FBaseSrcRect := Value;
    fNeedUpdate := True;
  end;
end;

procedure TUcSkinPainter.SetPaintInfo(const Value: string);
begin
  if Value <> fPaintInfo then
  begin
    FPaintInfo := Value;
    fNeedUpdate := True;
  end;
end;

procedure TUcSkinPainter.SetSourceIMG(SrcIMG: TGraphic);
var i: Integer;
begin
  fSrcIMG := SrcIMG;
  if Assigned(fSrcIMG) then
    BaseSrcRect := Rect(0, 0, fSrcIMG.Width, fSrcIMG.Height);
  for i := 0 to fPainters.Count - 1 do
    TUcPainter(fPainters).SetSourceIMG(fSrcIMG);
end;

procedure TUcSkinPainter.UpdatePaintInfo;
var Ps, Pe, Cnt: Integer;
begin
  if fNeedUpdate then
  begin
    Ps := Pos('{', fPaintInfo);
    if Ps = 0 then
    begin
      if fPainters.Count >= 1 then
        fPainters.Count := 1
        else
        fPainters.Add(CreatePainter);

      TUcPainter(fPainters[0]).SetPaintInfo(fPaintInfo, fBaseSrcRect, fBaseDestRect);
    end else
    begin
      Cnt := 0;
      Pe := PosEx('}', fPaintInfo, Ps + 1);
      while (Ps > 0) and (Pe > 0) do
      begin
        Inc(Cnt);
        if fPainters.Count < Cnt then fPainters.Add(CreatePainter);
        TUcPainter(fPainters[Cnt - 1]).SetPaintInfo(
          Copy(fPaintInfo, Ps + 1, Pe - Ps - 1), fBaseSrcRect, fBaseDestRect
        );
        TUcPainter(fPainters[Cnt - 1]).SetSourceIMG(fSrcIMG);

        Ps := PosEx('{', fPaintInfo, Pe + 1);
        Pe := PosEx('}', fPaintInfo, Ps + 1);
      end;
      fPainters.Count := Cnt;
    end;

    fNeedUpdate := False;
  end;
end;



end.
