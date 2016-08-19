// Версия - 06.06.2012
unit ucProtect;
{$include ..\delphi_ver.inc}

interface

uses Windows, Classes, SysUtils, XMLDoc, XMLIntf, Math, Dialogs, Registry,
     ucXXTEA, ucBase64, ucZibProcs, ucClasses, ucTypes, ucFunctions, md5;

type
  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Класс для защиты программы методом регистрации. Привязки к
  ///	компьютеру по ключу.</summary>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  TUcProtect = class
  private
    FUseStaticPassword: Boolean;
    FPassword: String;
    FOnGetPassword: TGetPassword;
    FValues: TDBFields;
    FPassword2: String;
    FOnGetPassword2: TGetPassword;
    FUseMd5HashByPassword: Boolean;
    function GetPassword: String;
    function GetPassword2: String;
    function GetValues(Name: string): TDBField;
    function PreparePassword(Pass: String): RawByteString;
    function GetIsChanged: Boolean;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Удаляет всю информацию о защите.</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    procedure Clear;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Загружает данные ключа из файла</summary>
    ///	<param name="FileName">Путь к файлу ключа</param>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function LoadFromFile(FileName: string): Boolean;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Загружает данные ключа из потока</summary>
    ///	<param name="Stream">Поток с ключом</param>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function LoadFromStream(Stream: TStream): Boolean;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Загрузка данных ключа из текстовой строки</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function LoadFromString(Str: string): Boolean;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Загрузка данных ключа из реестра</summary>
    ///	<param name="RootKey">Корневая ветка реестра</param>
    ///	<param name="Key">Ключ реестра</param>
    ///	<param name="Param">Параметр из которого загружается ключ</param>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function LoadFromRegistry(RootKey: HKEY; Key, Param: string): Boolean;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Сохраняет данные ключа в файл</summary>
    ///	<param name="FileName">Путь к файлу ключа</param>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function SaveToFile(FileName: string): Boolean;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Сохраняет данные ключа в поток</summary>
    ///	<param name="Stream">Поток</param>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function SaveToStream(Stream: TStream): Boolean;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Сохраняет данные ключа в строку</summary>
    ///	<returns>Строка с зашифрованным ключом</returns>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function SaveToString: string;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Сохранение ключа в реестр</summary>
    ///	<param name="RootKey">Корневая ветка реестра</param>
    ///	<param name="Key">Ключ реестра</param>
    ///	<param name="Param">Параметр для сохранения данных ключа</param>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function SaveToRegistry(RootKey: HKEY; Key, Param: string): Boolean;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Формирует строку запроса ключа</summary>
    ///	<returns>Строка запроса ключа</returns>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function RequestKey(ProductSID: string): string;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Разбирает строку запроса ключа извлекая из нее пароль и
    ///	строковый идентификатор продукта</summary>
    ///	<param name="ReqKey">Строка запроса ключа</param>
    ///	<param name="Password">Пароль</param>
    ///	<param name="ProductSID">Строковый идентификатор продукта</param>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    procedure ParceRequestKey(ReqKey: string; out vPassword, vProductSID: string);

    function EncryptStream(Stream: TStream): Boolean;
    function DecryptStream(Stream: TStream; CheckEncrypted: Boolean = False): Boolean;


    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Создает строковый поток TStringStream настроенный на работу с
    ///	кодировкой UTF8</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function NewStringStream: TStringStream;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Возвращает список всех имеющихся параметров защиты и их
    ///	значения</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function Debug: string;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Выводит сообщение со списком всех имеющихся параметров защиты
    ///	и их значениями</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    procedure DebugMessage;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Определяет используются постоянные пароли или генерируются
    ///	обработчиками событий: OnGetPassword, OnGetPassword2</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property UseStaticPassword: Boolean read FUseStaticPassword write FUseStaticPassword;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>
    ///	  <para>Пароль защиты ключа программы.</para>
    ///	  <para>Им шифруется ключ программы. С помощью его программа
    ///	  расшифровывает ключ и получает из него данные о регистрации.</para>
    ///	</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property Password: String read GetPassword write FPassword;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>
    ///	  <para>Пароль шифрования строки запроса ключа.</para>
    ///	  <para>Этот ключ всегда постоянный (открытый)</para>
    ///	</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property Password2: String read GetPassword2 write FPassword2;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Событие получения пароля Password. Срабатывает при
    ///	UseStaticPassword = False</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property OnGetPassword: TGetPassword read FOnGetPassword write FOnGetPassword;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Событие получения пароля Password2. Срабатывает при
    ///	UseStaticPassword = False</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property OnGetPassword2: TGetPassword read FOnGetPassword2 write FOnGetPassword2;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Параметры ключа программы</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property Values[Name: string]: TDBField read GetValues; default;
    property UseMd5HashByPassword: Boolean read FUseMd5HashByPassword write FUseMd5HashByPassword;
    property IsChanged: Boolean read GetIsChanged;
  end;

implementation

uses Variants;

{ TUcProtect }

procedure TUcProtect.Clear;
begin
  FValues.Clear;
end;

constructor TUcProtect.Create;
begin
  inherited;
  FUseMd5HashByPassword := False;
  FUseStaticPassword := True;
  FPassword          := '';
  FPassword2         := '';
  FOnGetPassword     := nil;
  FOnGetPassword2    := nil;
  FValues            := TDBFields.Create;
end;

function TUcProtect.Debug: string;
begin
  Result := FValues.Debug;
end;

procedure TUcProtect.DebugMessage;
begin
  ShowMessage(Debug);
end;

function TUcProtect.DecryptStream(Stream: TStream; CheckEncrypted: Boolean = False): Boolean;
begin
  Result := (not CheckEncrypted) or (xxtea_stream_encrypted(Stream));
  if Result then
  begin
    if Password <> '' then
      Result := xxtea_decrypt(Stream, PreparePassword(Password));
    Result := Result and UC_ZIP(Stream, False);
  end;
end;

destructor TUcProtect.Destroy;
begin
  FValues.Free;
  inherited;
end;

function TUcProtect.EncryptStream(Stream: TStream): Boolean;
begin
  Result := not xxtea_stream_encrypted(Stream);
  if Result then
  begin
    Result := UC_ZIP(Stream, True);
    if Password <> '' then
//      Result := xxtea_encrypt(Stream, PreparePassword(Password));
      Result := xxtea_encrypt_ex(Stream, PreparePassword(Password));
  end;
end;

function TUcProtect.RequestKey(ProductSID: string): string;
var ss: TStringStream;
begin
  ss := NewStringStream;
  try
    ss.WriteString(UC_Implode('?', [Password, ProductSID, UC_GeneratePassword(2)]));
    if Password2 <> '' then xxtea_encrypt(ss, RawByteString(Password2));
    base64_encode(ss);

    Result := ss.DataString;
  finally
    ss.Free;
  end;
end;

procedure TUcProtect.ParceRequestKey(ReqKey: string; out vPassword, vProductSID: string);
var ss: TStringStream;
    sa: TStrArray;
begin
  ss := NewStringStream;
  try
    ss.WriteString(Trim(ReqKey));
    base64_decode(ss);
    if Password2 <> '' then xxtea_decrypt(ss, RawByteString(Password2));

    sa := UC_Explode('?', ss.DataString, 3);
    vPassword   := sa[0];
    vProductSID := sa[1];
  finally
    ss.Free;
  end;
end;

function TUcProtect.PreparePassword(Pass: String): RawByteString;
begin
  Result := RawByteString(Pass);

  if FUseMd5HashByPassword then
    Result := RawByteString(UC_MD5String(Result));
end;

function TUcProtect.GetIsChanged: Boolean;
begin
  Result := FValues.IsChanged;
end;

function TUcProtect.GetPassword: String;
begin
  if FUseStaticPassword then
    Result := FPassword
    else begin
      if Assigned(FOnGetPassword) then
        FOnGetPassword(Self, Result)
        else
        raise Exception.Create('Не указан обработчик формирования пароля!');
    end;
end;

function TUcProtect.GetPassword2: String;
begin
  if FUseStaticPassword then
    Result := FPassword2
    else begin
      if Assigned(FOnGetPassword2) then
        FOnGetPassword2(Self, Result)
        else
        raise Exception.Create('Не указан обработчик формирования пароля (2)!');
    end;
end;

function TUcProtect.GetValues(Name: string): TDBField;
begin
  Result := FValues[Name];
end;

function TUcProtect.LoadFromFile(FileName: string): Boolean;
var
  Stream: TStream;
begin
  Result := FileExists(FileName);
  if Result then
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      Result := LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;

function TUcProtect.LoadFromRegistry(RootKey: HKEY; Key, Param: string): Boolean;
var R: TRegistry;
    {$IFDEF DELPHI_2009_UP}
      Buffer: TBytes;
    {$ELSE}
      Buffer: string;
    {$ENDIF}
    ms: TMemoryStream;
    DataSize: Integer;
begin
  R := TRegistry.Create;
  ms := TMemoryStream.Create;
  try
    try
      R.RootKey := RootKey;
      Result := R.OpenKey(Key, False);
      if Result then
      begin
        DataSize := R.GetDataSize(Param);
        Result := DataSize > 0;
        if Result then
        begin
          SetLength(Buffer, DataSize);
          R.ReadBinaryData(Param, Pointer(Buffer)^, DataSize);
          ms.Write(Pointer(Buffer)^, DataSize);
          ms.Position := 0;
          Result := LoadFromStream(ms);
        end;
      end;
    except
      Result := False;
    end;
  finally
    ms.Free;
    R.Free;
  end;
end;

function TUcProtect.LoadFromStream(Stream: TStream): Boolean;
var ms: TMemoryStream;
    xd: IXMLDocument;
    nRoot, Node: IXMLNode;
    i: Integer;
begin
  Clear;
  ms := TMemoryStream.Create;
  try
    // Загрузка потока
    ms.LoadFromStream(Stream);
    // Дешифруем ключ защиты
    base64_decode(ms);
    DecryptStream(ms);
    //**

    // Подготовка к работе с ключом защиты
    xd := NewXMLDocument();
    xd.Encoding := 'UTF-8';
    xd.NodeIndentStr := #9;
    xd.Options := xd.Options + [doNodeAutoIndent];

    // Загрузка данных из ключа
    Result := ms.Size > 0;
    if Result then
      try
        xd.LoadFromStream(ms);
        Result := True;
      except
        Result := False;
      end;
    //**
    if not Result then Exit;

    // Обработка данных
    nRoot := xd.ChildNodes.FindNode('root');
    if Assigned(nRoot) then
      for i := 0 to nRoot.ChildNodes.Count - 1 do
      begin
        Node := nRoot.ChildNodes[i];
        if CompareText(Node.NodeName, 'v') = 0 then
        begin
          Values[Node.Attributes['name']].AsString := Node.Attributes['value'];

//          { TODO : При преобразовании кодов на английской винде происходят ошибки. }
////          {$IFDEF DELPHI_2009_UP}
//          Values[Node.Attributes['name']].AsString := Node.Attributes['value'];
////          {$ELSE}
////          Values[Node.Attributes['name']].AsString := VarToStrDef(Node.Attributes['value'], 'encode problem');
////          {$ENDIF}
        end;
      end;
    FValues.IsChanged := False;
    //**
  finally
    ms.Free;
  end;
end;

function TUcProtect.LoadFromString(Str: string): Boolean;
var ss: TStringStream;
begin
  ss := NewStringStream;
  try
    ss.WriteString(Trim(Str));
    Result := LoadFromStream(ss);
  finally
    ss.Free;
  end;
end;

function TUcProtect.NewStringStream: TStringStream;
begin
{$IFDEF DELPHI_2009_UP}
  Result := TStringStream.Create('', TUTF8Encoding.Create);
{$ELSE}
  Result := TStringStream.Create('');
{$ENDIF}
end;

function TUcProtect.SaveToFile(FileName: string): Boolean;
var
  Stream: TStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmCreate);
    try
      Result := SaveToStream(Stream);
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;

function TUcProtect.SaveToRegistry(RootKey: HKEY; Key, Param: string): Boolean;
var R: TRegistry;
    {$IFDEF DELPHI_2009_UP}
      Buffer: TBytes;
    {$ELSE}
      Buffer: string;
    {$ENDIF}
    ms: TMemoryStream;
begin
  R := TRegistry.Create;
  ms := TMemoryStream.Create;
  try
    try
      R.RootKey := RootKey;
      Result := R.OpenKey(Key, True) and SaveToStream(ms);
      if Result then
      begin
        SetLength(Buffer, ms.Size);
        ms.Position := 0;
        ms.Read(Pointer(Buffer)^, ms.Size);
        R.WriteBinaryData(Param, Pointer(Buffer)^, ms.Size);
      end;
    except
      Result := False;
    end;
  finally
    ms.Free;
    R.Free;
  end;
end;

function TUcProtect.SaveToStream(Stream: TStream): Boolean;
var ms: TMemoryStream;
    xd: IXMLDocument;
    nRoot, Node: IXMLNode;
    i: Integer;
begin
  ms := TMemoryStream.Create;
  try
    try
      // Сохранение данных
      xd := NewXMLDocument();
      xd.Encoding := 'UTF-8';
      xd.NodeIndentStr := #9;
      xd.Options := xd.Options + [doNodeAutoIndent];

      nRoot := xd.AddChild('root');
      if Assigned(nRoot) then
      begin
        Values['trash'].AsString := UC_GeneratePassword();
        for i := 0 to FValues.Count - 1 do
        begin
          Node := nRoot.AddChild('v');

          Node.Attributes['name']  := FValues.Fields[i].FieldName;
          Node.Attributes['value'] := FValues.Fields[i].AsString;

//          if VarType(FValues.Fields[i].AsVariant) = varDate then         // Для того, чтобы избежать ошибок при различных системных
//            begin                                                        // настройках даты
//              Node.Attributes['value'] := FValues.Fields[i].AsFloat;
//              Node.Attributes['txtvalue'] := FValues.Fields[i].AsString; // Чтобы можно было визуально определить дату
//            end
//          else
//            Node.Attributes['value'] := FValues.Fields[i].AsString;

        end;
      end;

      xd.SaveToStream(ms);
      // Выгрузка потока
      EncryptStream(ms);
      base64_encode(ms);

      ms.SaveToStream(Stream);
      Result := True;
    except
      Result := False;
    end;
  finally
    ms.Free;
  end;
end;

function TUcProtect.SaveToString: string;
var ss: TStringStream;
begin
  ss := NewStringStream;
  try
    SaveToStream(ss);
    Result := ss.DataString;
  finally
    ss.Free;
  end;
end;

end.
