// Версия - 18.04.2013
unit ucCMD;
{$include ..\delphi_ver.inc}

interface

uses Classes, StrUtils, ucClasses, ucTypes, ucFunctions;

type
  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>
  ///	  <para>Обработка командной строки вида:</para>
  ///	  <para>param1=value1 param2 param3="value 3"</para>
  ///	</summary>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  TUcCMDLineProcessor = class
  private
    function GetParam(Name: string): TDBField;
  protected
    fParams: TDBFields;
    procedure ParceCMDLine; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function ParamExists(Name: string): Boolean;
    property Param[Name: string]: TDBField read GetParam; default;
    property Params: TDBFields read fParams;
  end;

  TUcCustomCMDLineProcessor = class(TUcCMDLineProcessor)
  protected
    fUserCMD: string;
    procedure ParceCMDLine; override;
  public
    constructor Create(CustomCMD: string); reintroduce;
  end;

function UC_CMD: TUcCMDLineProcessor;

implementation

uses SysUtils;

var gvUC_CMD: TUcCMDLineProcessor = nil;

function UC_CMD: TUcCMDLineProcessor;
begin
  if not Assigned(gvUC_CMD) then
    gvUC_CMD := TUcCMDLineProcessor.Create;
  Result := gvUC_CMD;
end;

{ TUcCustomCMDLineProcessor }

constructor TUcCMDLineProcessor.Create;
begin
  fParams := TDBFields.Create;
  fParams.AutoCreateFields := False;
  ParceCMDLine;
end;

destructor TUcCMDLineProcessor.Destroy;
begin
  fParams.Free;
  inherited;
end;

function TUcCMDLineProcessor.GetParam(Name: string): TDBField;
begin
  Result := fParams[Name];
end;

function TUcCMDLineProcessor.ParamExists(Name: string): Boolean;
begin
  Result := Assigned(fParams.FindField(Name));
end;

procedure TUcCMDLineProcessor.ParceCMDLine;
var i: Integer;
    a: TStrArray;
begin
  try
    fParams.AutoCreateFields := True;
    // Разбираем все входящие параметры
    for i := 1 to ParamCount do
    begin
      SetLength(a, 0); // Избавляемся от Warning!
      a := UC_Explode('=', ParamStr(i), 2);
      fParams[a[0]].AsString := a[1];
    end;
  finally
    fParams.AutoCreateFields := False;
  end;
end;

{ TUcCustomCMDLineProcessor }

constructor TUcCustomCMDLineProcessor.Create(CustomCMD: string);
begin
  fUserCMD := CustomCMD;
  inherited Create;
end;

procedure TUcCustomCMDLineProcessor.ParceCMDLine;
var Params: TStringList;
    i, Len, Start: Integer;
    Quote: Boolean;
    a: TStrArray;
begin
  Len := Length(fUserCMD);
  if Len = 0 then Exit;

  Params := TStringList.Create;
  try
    // Satge 1
    Start := 1;
    Quote := False;
    for i := 1 to Len do
      if (fUserCMD[i] = '"'){ and not Quote} then
        Quote := not Quote
      else if (fUserCMD[i] = ' ') and not Quote then
      begin
        {$IFDEF DELPHI_2009_UP}
        Params.Add(ReplaceStr(Copy(fUserCMD, Start, i - Start), '"', ''));
        {$ELSE}
        Params.Add(StringReplace(Copy(fUserCMD, Start, i - Start), '"', '', [rfReplaceAll, rfIgnoreCase]));
        {$ENDIF}
        Start := i + 1;
      end;
      {$IFDEF DELPHI_2009_UP}
      Params.Add(ReplaceStr(Copy(fUserCMD, Start, Len - Start + 1), '"', ''));
      {$ELSE}
      Params.Add(StringReplace(Copy(fUserCMD, Start, Len - Start + 1), '"', '', [rfReplaceAll, rfIgnoreCase]));
      {$ENDIF}

    // Stage 2
    try
      fParams.AutoCreateFields := True;
      // Разбираем все входящие параметры
      for i := 0 to Params.Count - 1 do
      begin
        SetLength(a, 0); // Избавляемся от Warning!
        a := UC_Explode('=', Params.Strings[i], 2);
        fParams[a[0]].AsString := a[1];
      end;
    finally
      fParams.AutoCreateFields := False;
    end;
  finally
    Params.Free;
  end;
end;

initialization

finalization
  gvUC_CMD.Free;

end.
