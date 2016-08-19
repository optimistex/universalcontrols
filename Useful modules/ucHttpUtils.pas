// Версия - 17.05.2013
unit ucHttpUtils;
{$include ..\delphi_ver.inc}

interface

uses Windows, Classes, SysUtils,
     ucClasses, ucIDObjects, ucWindows, ucFunctions;

type
  TUcHttpPostBuilder = class
  private
    fStream: TStream;
    fParams: TIDObjectList;
    fBoundary: string;
  protected
    procedure BuildHttpPost;
  public
    constructor Create;
    destructor Destroy; override;

    procedure CreateBoundary;
    procedure Clear;
    procedure AddParam(Name, Value: string);
    procedure AddFile(Name, FileName: string);
    function  BuildStream(UseTempFile: Boolean): TStream;

    property Params: TIDObjectList read fParams;
    property Boundary: string read fBoundary;
    property Stream: TStream read fStream;
  end;


implementation

{ THttpPostBuilder }
procedure TUcHttpPostBuilder.Clear;
begin
  fParams.Clear;
  if Assigned(fStream) then fStream.Size := 0;
end;

constructor TUcHttpPostBuilder.Create;
begin
  inherited;
  fParams := TIDObjectList.Create;
  fStream := nil;
  // Генерация разделителя
  CreateBoundary;
end;

procedure TUcHttpPostBuilder.CreateBoundary;
begin
  fBoundary := UC_GeneratePassword(30);
end;

destructor TUcHttpPostBuilder.Destroy;
begin
  fStream.Free;
  fParams.Free;
  inherited;
end;

procedure TUcHttpPostBuilder.AddFile(Name, FileName: string);
var Obj: TIDObject;
begin
  Obj := TIDObject.Create;
  try
    Obj['name'].AsString     := Name;
    Obj['filename'].AsString := FileName;
    Obj['type'].AsString     := 'file';
    fParams.Add(obj);
  except
    Obj.Free;
  end;
end;

procedure TUcHttpPostBuilder.AddParam(Name, Value: string);
var Obj: TIDObject;
begin
  Obj := TIDObject.Create;
  try
    Obj['name'].AsString  := Name;
    Obj['value'].AsString := Value;
    Obj['type'].AsString  := 'value';
    fParams.Add(obj);
  except
    Obj.Free;
  end;
end;

procedure TUcHttpPostBuilder.BuildHttpPost;
var i: Integer;
    ss: TStringStream;
    fs: TFileStream;
    Obj: TIDObject;
begin
  // Сброс данных
  fStream.Size := 0;

  // Сборка выходного потока
  {$IFDEF DELPHI_2009_UP}
  ss := TStringStream.Create('', TEncoding.UTF8);
  {$ELSE}
  ss := TStringStream.Create('');
  {$ENDIF}
  try
    for i := 0 to fParams.Count - 1 do
    begin
      Obj := fParams[i];
      ss.Size := 0;

      if i = 0 then
        ss.WriteString('--' + Boundary + #13#10)
        else
        ss.WriteString(#13#10'--' + Boundary + #13#10);

      // Вставка секции с файлом
      if Obj['type'].AsString = 'file' then
      begin
        ss.WriteString(Format('Content-Disposition: form-data; name="%s"; filename="%s"'#13#10,
                       [Obj['name'].AsString, ExtractFileName(Obj['filename'].AsString)]));
        ss.WriteString('Content-Type: application/octet-stream'#13#10#13#10);

        fs := TFileStream.Create(Obj['filename'].AsString, fmOpenRead);
        try
          ss.Position := 0;
          fStream.CopyFrom(ss, ss.Size);
          fs.Position := 0;
          fStream.CopyFrom(fs, fs.Size);
        finally
          fs.Free;
        end;
      end;

      // Вставка секции со строкой
      if Obj['type'].AsString = 'value' then
      begin
        ss.WriteString(Format('Content-Disposition: form-data; name="%s"'#13#10#13#10,
                       [Obj['name'].AsString]));
        ss.WriteString(Obj['value'].AsString);
        ss.Position := 0;
        fStream.CopyFrom(ss, ss.Size);
      end;
    end;

    if fParams.Count > 0 then
    begin
      ss.Size := 0;
      ss.WriteString(#13#10'--' + Boundary + '--');
      ss.Position := 0;
      fStream.CopyFrom(ss, ss.Size);
    end;
  finally
    ss.Free;
  end;
end;

function TUcHttpPostBuilder.BuildStream(UseTempFile: Boolean): TStream;
var FileHandle: THandle;
    TmpFile: string;
begin
  // Подготовка потока
  if UseTempFile then
  begin
    if not (fStream is TFileStream) then FreeAndNil(fStream);
    if not Assigned(fStream) then
    begin
      TmpFile := IncludeTrailingBackslash(UC_GetEnvironmentVariable('TEMP')) +
                 'HttpPost$' + UC_GeneratePassword + '.dat';

      FileHandle := CreateFile(PChar(TmpFile), GENERIC_READ or GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_TEMPORARY or FILE_FLAG_DELETE_ON_CLOSE, 0);
      Win32Check(FileHandle <> INVALID_HANDLE_VALUE);
      fStream := TFileStream.Create(FileHandle);
    end;
  end else
  begin
    if not (fStream is TMemoryStream) then FreeAndNil(fStream);
    if not Assigned(fStream) then fStream := TMemoryStream.Create;
  end;
  // Сборка потока
  BuildHttpPost;
  // Отдаем данные
  fStream.Position := 0;
  Result := fStream;
end;


end.
