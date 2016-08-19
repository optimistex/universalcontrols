// Версия - 16.09.2014
unit ucdXmlRpc_Client;
{
  Модуль рассчитан на Delphi 2010.
  Для работы с этим модулем необходимо установить компоненты:
  OverbyteIcsV7 - http://www.overbyte.be/frame_index.html
}
{$include ..\delphi_ver.inc}

interface

uses Windows, Classes, OverbyteIcsHttpProt, SysUtils, WinInet, xmldom, StrUtils,
     ucXmlRpc, ucClasses, ucTypes, ucHttpUtils, ucFunctions;

type
  TXmlRpcClient = class (TUcNotifyObjectEx)
  private
    fFirstUrl: string;
    fHttpCli: THttpCli;
    SendStream: TStringStream; // поток отправляемого запроса
    fLog: TStringList;
    fAutoDetectProxy: Boolean;
//    fHeadNew
    procedure SetURL(Value: string);
    procedure SetProxy(Value: string);
    procedure SetProxyPort(Value: string);
    procedure SetCookie(Name: string; Value: string);

    function  GetURL: string;
    function  GetProxy: string;
    function  GetProxyPort: string;
    function  GetIsRespDataStream: Boolean;
    function  GetCookie(Name: string): string;

    function  GetFaultCode: integer;
    function  GetFaultString: string;
    procedure SetAutoDetectProxy(const Value: Boolean);
    function GetLocationChangeMaxCount: Integer;
    procedure SetLocationChangeMaxCount(const Value: Integer);
  protected
    function GetProxyData(var ProxyEnabled: boolean; var ProxyServer: string;
                          var ProxyPort: integer): Boolean;
    procedure PostData;
    function FillProxyFromIE: Boolean;
    procedure HttpCliCookie(Sender: TObject; const Data: String;
                            var Accept: Boolean);
    procedure HttpHeaderBegin(Sender: TObject);

    procedure HttpCliDocBegin(Sender: TObject);
    procedure HttpCliDocData(Sender: TObject; Buffer: Pointer; Len: Integer);
    procedure HttpCliDocEnd(Sender: TObject);

    procedure HttpCliSendBegin(Sender: TObject);
    procedure HttpCliSendData(Sender: TObject; Buffer: Pointer; Len: Integer);
    procedure HttpCliSendEnd(Sender: TObject);


    procedure HttpCliLocationChange(Sender: TObject);
  public
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>XML параметров запроса (передаваемые данные)</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    XRCall: TUcXmlRpcCall;

    HttpPost: TUcHttpPostBuilder;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>XML параметров ответа (получаемые данные)</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    XRResp: TUcXmlRpcResponse;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Поток ответа на запрос. Данные полученные с RPC сервера как
    ///	есть.</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    RespStream: TStringStream;
    DebugMode: Boolean;
    constructor Create; override;
    destructor Destroy; override;

    procedure Notifycation(const iInf: TUcNotifyInfos; const iTag, iMax, iPos: Integer;
                           const iTxt: string = ''; const iErr: Boolean = False); override;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Вызов удаленной процедуры</summary>
    ///	<param name="TargetStream">Поток в который должны быть записаны данные.
    ///	Актуально при получении файлов.</param>
    ///	<returns>Успешность вызова процедуры</returns>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function CallRemoteProcedure(TargetStream: TStream = nil): Boolean;

    procedure Pause;
    procedure Resume;
    procedure Stop;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Быстрая настройка работы с сетью</summary>
    ///	<param name="iUrl">URL обработки RPC запросов</param>
    ///	<param name="iProxy">адрес прокси сервера</param>
    ///	<param name="iProxyPort">порт на прокси сервере</param>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    procedure QuickSetup(iUrl, iProxy, iProxyPort: string);

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Очистка всех потоков обработки</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    procedure ClearStreams;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>HTTP клиент отвечающий за передачу данных на/с RPC
    ///	сервера</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property HttpCli: THttpCli read fHttpCli;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>URL обработчика вызовов удаленных процедур</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property URL: string read GetURL write SetURL;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>IP адрес прокси сервера</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property Proxy: string read GetProxy write SetProxy;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Порт на прокси сервере</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property ProxyPort: string read GetProxyPort write SetProxyPort;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Значение переменной Cookie по ее имени</summary>
    ///	<param name="Name">Имя Cookie переменной</param>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property Cookie[Name: string]: string read GetCookie write SetCookie; //

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Признак получения двоичного потока данных. true - значит
    ///	вернулся двоичный поток данных.</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property IsRespDataStream: Boolean read GetIsRespDataStream;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Лог сообщений</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property  Log: TStringList read fLog;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Код ошибки выполнения последнего RPC запроса</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property FaultCode: Integer read GetFaultCode;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Текст ошибки выполнения последнего RPC запроса</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property FaultString: string  read GetFaultString;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Автоматическое определение настроек прокси в свойствах
    ///	обозревателя. Если включено, то при отправке данных на удаленный сервер
    ///	в случае отказа соединения производится попытка подключиться через
    ///	прокси.</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property AutoDetectProxy: Boolean read fAutoDetectProxy write SetAutoDetectProxy;

    property LocationChangeMaxCount: Integer read GetLocationChangeMaxCount
                                            write SetLocationChangeMaxCount;
  end;

implementation

var URLRef_: TDBFields;

{ TXmlRpcClient }

function ICSTr(var Msg: string): Boolean; overload;
begin
  Result := True;
  if Msg = 'can''t resolve hostname to IP address' then
    Msg := 'Не найдено соответствие хоста с IP адресом. Возможны проблемы с сетью.'
  else if Msg = 'Request aborted on timeout' then
    Msg := 'Истекло время ожидания сервера, запрос отменен. Проверьте соединение ' +
           'с Интернетом и повторите попытку.'
  else Result := False;
end;

function ICSTr(E: Exception): Boolean; overload;
var s: string;
begin
  s := E.Message;
  Result := ICSTr(s);
  if Result then
    E.Message := s;
end;

function TXmlRpcClient.CallRemoteProcedure(TargetStream: TStream = nil): Boolean;
{$IFNDEF DELPHI_2009_UP}
var
  Count: Longint;
  Buffer: Pointer;
{$ENDIF}
begin
  try
    Notifycation([niPos, niErr], 0, 0, -1);
    XRResp.Clear;
    fHttpCli.RcvdStream.Size := 0;
    fHttpCli.SendStream.Size := 0;
    fLog.Clear;

    if Assigned(TargetStream) then
      fHttpCli.RcvdStream := TargetStream;

    if HttpPost.Params.Count > 0 then
    begin
      if DebugMode then Notifycation([niTxt], 0, 0, 0, 'Подготовка данных к отправке');
      fHttpCli.ContentTypePost := 'multipart/form-data; boundary=' + HttpPost.Boundary;
      HttpPost.AddParam('XMLRPC', XRCall.XML);
      fHttpCli.SendStream := HttpPost.BuildStream(True);
    end else
    begin
      fHttpCli.ContentTypePost := 'text/plain';
      SendStream.WriteString(XRCall.XML);
      SendStream.Position := 0; // !!!
    end;

    try
      PostData;
    except
      on E: Exception do
        if AutoDetectProxy and (Proxy = '') and FillProxyFromIE then
        begin
          Notifycation([niTxt], 0, 0, 0,
                       Format('Используется прокси-сервер %s:%s', [Proxy, ProxyPort]));
          PostData;
          if (fHttpCli.RcvdStream.Size = 0) and
             (Trim(fHttpCli.AuthorizationRequest.Text) <> '') then
            Notifycation([niTxt, niErr], 0, 0, 0,
                         'Требуется авторизация на прокси сервере: '#13#10 +
                         Trim(fHttpCli.AuthorizationRequest.Text), True);
        end else
        begin
          if E is EHttpException then
          begin
            if not ICSTr(E) then
              case EHttpException(E).ErrorCode of
                httperrAborted:       E.Message := 'Соединение прервано';
                httperrCustomTimeOut: E.Message := 'Соединение прервано, так как сервер не отвечает';
              end;
            raise EHttpException.Create(E.Message, EHttpException(E).ErrorCode);
          end else
            raise Exception.Create(E.Message);
        end;
    end;

    // [2013.11.14] СТАРАЯ обработка полученных данных
//    if IsRespDataStream and (fHttpCli.RcvdStream <> RespStream) then
//      RespStream.WriteString(Format('Получены бинарные данные %d байт', [fHttpCli.RcvdStream.Size]));
//
//    if (not IsRespDataStream) and (fHttpCli.RcvdStream = RespStream) then
//      XRResp.XML := RespStream.DataString;

    // [2013.11.14] НОВАЯ обработка полученных данных
    if IsRespDataStream then // Проверяем, что получены бинарные данные
    begin
      if fHttpCli.RcvdStream <> RespStream then
        RespStream.WriteString(Format('Получены бинарные данные %d байт', [fHttpCli.RcvdStream.Size]));
    end else
    begin
      if (fHttpCli.RcvdStream <> RespStream) and (fHttpCli.RcvdStream.Size <= 1024) then
      begin
        fHttpCli.RcvdStream.Position := 0;
        RespStream.Size := 0;
      {$IFDEF DELPHI_2009_UP}
        RespStream.LoadFromStream(fHttpCli.RcvdStream);
      {$ELSE}
        Count := fHttpCli.RcvdStream.Size;
        fHttpCli.RcvdStream.Position := 0;
        RespStream.Position := 0;
        GetMem(Buffer, Count);
        try
          fHttpCli.RcvdStream.ReadBuffer(Buffer, Count);
          RespStream.WriteBuffer(Buffer, Count);
        finally
          FreeMem(Buffer, Count);
        end;
      {$ENDIF}
      end;

      XRResp.XML := RespStream.DataString;
    end;
    //**

    // Обработка результата RPC запроса
    Result := False;
    if fHttpCli.ContentLength = -1 then
      Notifycation([niTxt, niErr], 0, 0, 0, 'Ответ сервера не получен (нет данных)', True)
    else if (fHttpCli.RcvdCount > 0) and (fHttpCli.ContentLength <> fHttpCli.RcvdCount) then
      Notifycation([niTxt, niErr], 0, 0, 0, 'Загрузка данных была прервана', True)
    else
      Result := True;
    //**
  except
    on E: Exception do
    begin
      Result := False;
      URLRef_[fFirstUrl].Free;
      // Перевод сообщений и обновление XRResp
      if not XRResp.IsFault and (E is EDOMParseError) then
      begin
        E.Message := 'Некорректный ответ сервера.';
        XRResp.Fault.FaultCode   := (E as EDOMParseError).ErrorCode;
        XRResp.Fault.FaultString := E.Message;
      end else
      if not XRResp.IsFault and (E is EHttpException) and (EHttpException(E).ErrorCode = httperrNoStatusCode) then
      begin
        E.Message := 'Соединение было преждевременно закрыто. Попробуйте отключить антивирус.';
        XRResp.Fault.FaultCode   := (E as EHttpException).ErrorCode;
        XRResp.Fault.FaultString := E.Message;
      end;
      // Вывод сообщения об ошибке
      Notifycation([niTxt, niErr], 0, 0, 0, E.Message, True);
    end;
  end;
  if (fHttpCli.RcvdStream <> RespStream) and
     (fHttpCli.RcvdStream <> HttpPost.Stream) then fHttpCli.RcvdStream := RespStream;

  if XRResp.IsFault then Notifycation([niTxt, niErr], 0, 0, 0, IntToStr(FaultCode) + ': ' + FaultString, true);
  if NotifyPos < 0 then
    Notifycation([niPos], 0, 0, 0);
end;

procedure TXmlRpcClient.ClearStreams;
begin
  XRCall.Clear;
  XRResp.Clear;
  HttpPost.Clear;
  SendStream.Size := 0;
  RespStream.Size := 0;
  if fHttpCli.RcvdStream <> RespStream then
    fHttpCli.RcvdStream.Size := 0;
  if fHttpCli.SendStream <> SendStream then
    fHttpCli.SendStream.Size := 0;
end;

constructor TXmlRpcClient.Create;
begin
  inherited;
  DebugMode := False;

  fHttpCli := THttpCli.Create(nil);
  fHttpCli.Connection := 'Keep-Alive';
  fHttpCli.RequestVer := '1.1';
  fHttpCli.ContentTypePost := 'text/plain';
//  fHttpCli.MultiThreaded := True; // Закомментировано 19.03.2014
  // Обработчики событий
  fHttpCli.OnCookie      := HttpCliCookie;
  fHttpCli.OnHeaderBegin := HttpHeaderBegin;

  fHttpCli.OnDocBegin    := HttpCliDocBegin;
  fHttpCli.OnDocData     := HttpCliDocData;
  fHttpCli.OnDocEnd      := HttpCliDocEnd;

  fHttpCli.OnSendBegin   := HttpCliSendBegin;
  fHttpCli.OnSendData    := HttpCliSendData;
  fHttpCli.OnSendEnd     := HttpCliSendEnd;

  fHttpCli.OnLocationChange := HttpCliLocationChange; //   fHttpCli.LocationChangeMaxCount
  //**
  fLog                := TStringList.Create;

  {$IFDEF DELPHI_2009_UP}
    SendStream        := TStringStream.Create('', TUTF8Encoding.Create);
    RespStream        := TStringStream.Create('', TUTF8Encoding.Create);
  {$ELSE}
    SendStream        := TStringStream.Create('');
    RespStream        := TStringStream.Create('');
  {$ENDIF}
  fHttpCli.SendStream := SendStream;
  fHttpCli.RcvdStream := RespStream;

  XRCall   := TUcXmlRpcCall.Create;
  XRResp   := TUcXmlRpcResponse.Create;
  HttpPost := TUcHttpPostBuilder.Create;
end;

destructor TXmlRpcClient.Destroy;
begin
  HttpPost.Free;
  XRCall.Free;
  XRResp.Free;
  SendStream.Free;
  RespStream.Free;
  fLog.Free;
  fHttpCli.Free;
  inherited;
end;

function TXmlRpcClient.FillProxyFromIE: Boolean;
var vProxyEnabled: boolean;
    vProxyServer: string;
    vProxyPort: integer;
begin
  Result := GetProxyData(vProxyEnabled, vProxyServer, vProxyPort) and vProxyEnabled;
  if Result then
  begin
    Proxy := vProxyServer;
    ProxyPort := IntToStr(vProxyPort);
  end;
end;

function TXmlRpcClient.GetProxyPort: string;
begin
  Result := fHttpCli.ProxyPort;
end;

function TXmlRpcClient.GetCookie(Name: string): string;
var Cookies_, Cookie_: TStrArray;
    i: Integer;
begin
  Cookies_ := UC_Explode(';', fHttpCli.Cookie);
  for I := Low(Cookies_) to High(Cookies_) do
  begin
    Cookie_ := UC_Explode('=', Cookies_[i], 2);
    if CompareText(Trim(Cookie_[0]), Name) = 0 then
    begin
      Result := Cookie_[1];
      Break;
    end;
  end;
end;

function TXmlRpcClient.GetFaultCode: integer;
begin
  if XRResp.IsFault then
    Result := XRResp.Fault.FaultCode
    else
    Result := 0;
end;

function TXmlRpcClient.GetFaultString: string;
begin
  if XRResp.IsFault then
    Result := XRResp.Fault.FaultString
    else
    Result := Trim(fLog.Text);
end;

function TXmlRpcClient.GetIsRespDataStream: Boolean;
begin
  Result := Copy(fHttpCli.ContentType, 1, 5) <> 'text/';
end;

function TXmlRpcClient.GetLocationChangeMaxCount: Integer;
begin
  Result := fHttpCli.LocationChangeMaxCount;
end;

function TXmlRpcClient.GetProxy: string;
begin
  Result := fHttpCli.Proxy;
end;

function TXmlRpcClient.GetURL: string;
begin
  Result := fHttpCli.URL;
end;

function TXmlRpcClient.GetProxyData(var ProxyEnabled: boolean;
                                    var ProxyServer: string;
                                    var ProxyPort: integer): Boolean;
//type
//  INTERNET_PROXY_INFO = record
//    dwAccessType: DWORD;
//    lpszProxy: PChar;
//    lpszProxyBypass: PChar;
//  end;
//  PINTERNET_PROXY_INFO = ^INTERNET_PROXY_INFO;
var
  ProxyInfo: PInternetProxyInfo;
  PiSize: Cardinal;
  i, j: integer;
begin
  ProxyEnabled := false;

  InternetQueryOptionW(nil, INTERNET_OPTION_PROXY, nil, PiSize);
  GetMem(ProxyInfo, PiSize);
  try
    Result := InternetQueryOptionW(nil, INTERNET_OPTION_PROXY, ProxyInfo, PiSize);
    if Result and (ProxyInfo^.dwAccessType = INTERNET_OPEN_TYPE_PROXY) then
    begin
      ProxyEnabled:= True;
      ProxyServer :=  string(ProxyInfo^.lpszProxy);
    end;
  finally
    FreeMem(ProxyInfo, PiSize);
  end;

  if ProxyEnabled and (ProxyServer <> '') then
  begin
    i := Pos('http=', ProxyServer);
    if (i > 0) then
    begin
      Delete(ProxyServer, 1, i+5);
      j := Pos(';', ProxyServer);
      if (j > 0) then
        ProxyServer := Copy(ProxyServer, 1, j-1);
    end;
    i := Pos(':', ProxyServer);
    if (i > 0) then
    begin
      ProxyPort := StrToIntDef(Copy(ProxyServer, i+1, Length(ProxyServer)-i), 0);
      ProxyServer := Copy(ProxyServer, 1, i-1)
    end
  end;
end;

procedure TXmlRpcClient.HttpCliCookie(Sender: TObject; const Data: String;
  var Accept: Boolean);
var Cookies_, Cookie_: TStrArray;
begin
  Cookies_ := UC_Explode(';', Data, 2);
  if Trim(Cookies_[0]) <> '' then
  begin
    Cookie_ := UC_Explode('=', Cookies_[0], 2);
    Cookie[Trim(Cookie_[0])] := Trim(Cookie_[1]);
  end;
end;

procedure TXmlRpcClient.HttpCliDocBegin(Sender: TObject);
begin
  fHttpCli.RcvdStream.Size     := HttpCli.ContentLength;
  fHttpCli.RcvdStream.Position := 0;
  Notifycation([niMax, niPos], 0, HttpCli.ContentLength, 0);

  if DebugMode then
    Notifycation([niTxt], 0, 0, 0,
                 Format('%s HttpCliDocBegin: ContentLength=%d',
                        [TimeToStr(Now), HttpCli.ContentLength]));
end;

procedure TXmlRpcClient.HttpCliDocData(Sender: TObject; Buffer: Pointer;
  Len: Integer);
begin
  Notifycation([niPos], 0, 0, HttpCli.RcvdCount);

  if DebugMode then
    Notifycation([niTxt], 0, 0, 0,
                 Format('%s HttpCliDocData: RcvdCount=%d',
                        [TimeToStr(Now), HttpCli.RcvdCount]));
end;

procedure TXmlRpcClient.HttpCliDocEnd(Sender: TObject);
begin
  if DebugMode then
    Notifycation([niTxt], 0, 0, 0,
                 Format('%s HttpCliDocEnd: RcvdCount=%d',
                        [TimeToStr(Now), HttpCli.RcvdCount]));
end;

procedure TXmlRpcClient.HttpCliLocationChange(Sender: TObject);
begin
  Notifycation([niTxt], 0, 0, 0, 'Перенаправление на адрес: ' + HttpCli.Location);
end;

procedure TXmlRpcClient.HttpCliSendBegin(Sender: TObject);
begin
  Notifycation([niMax, niPos], 0, HttpCli.SendStream.Size, 0);

  if DebugMode then
    Notifycation([niTxt], 0, 0, 0,
                 Format('%s HttpCliSendBegin: ContentLength=%d',
                        [TimeToStr(Now), HttpCli.SendStream.Size]));

end;

procedure TXmlRpcClient.HttpCliSendData(Sender: TObject; Buffer: Pointer;
  Len: Integer);
begin
  Notifycation([niPos], 0, 0, HttpCli.SentCount);

  if DebugMode then
    Notifycation([niTxt], 0, 0, 0,
                 Format('%s HttpCliSendData: SentCount=%d',
                        [TimeToStr(Now), HttpCli.SentCount]));
end;

procedure TXmlRpcClient.HttpCliSendEnd(Sender: TObject);
begin
  if DebugMode then
    Notifycation([niTxt], 0, 0, 0,
                 Format('%s HttpCliSendEnd: SentCount=%d',
                        [TimeToStr(Now), HttpCli.SentCount]));
end;

procedure TXmlRpcClient.HttpHeaderBegin(Sender: TObject);
begin
//  fHttpCli.Cookie := '';
end;

procedure TXmlRpcClient.Notifycation(const iInf: TUcNotifyInfos; const iTag,
  iMax, iPos: Integer; const iTxt: string; const iErr: Boolean);
var Txt: string;
begin
  if niTxt in iInf then
  begin
    Txt := IfThen((niErr in iInf) and iErr, 'err::') + iTxt;
    fLog.Add(Txt);
  end;

  inherited Notifycation(iInf, iTag, iMax, iPos, Txt, iErr);
end;

procedure TXmlRpcClient.Pause;
begin
  fHttpCli.CtrlSocket.Pause;
end;

procedure TXmlRpcClient.PostData;
var n: Integer;
begin
  fHttpCli.NoCache := True;
  // Определение правильного адреса в случае обнаружения перенаправления
  fFirstUrl := fHttpCli.URL;
  if not Assigned(URLRef_.FindField(fFirstUrl)) then
  begin
    fHttpCli.FollowRelocation := True;
    if DebugMode then
      Notifycation([niTxt], 0, 0, 0, 'UrlHead: ' + fHttpCli.URL);
    fHttpCli.Head;
    n := 0;
    while (n < LocationChangeMaxCount) and
          (fHttpCli.Location <> fHttpCli.URL) do
    begin
      Inc(n);
      fHttpCli.URL := fHttpCli.Location;
      if DebugMode then
        Notifycation([niTxt], 0, 0, 0, 'NewUrlHead: ' + fHttpCli.URL);
      fHttpCli.Head;
    end;
    URLRef_[fFirstUrl].AsString := fHttpCli.URL;
    URLRef_[fHttpCli.URL].AsString := fHttpCli.URL;
    if n >= LocationChangeMaxCount then
      Notifycation([niTxt], 0, 0, 0, 'Превышено допустимое количество перенаправлений адреса');
  end;
  // Подстройка адреса отправки данных
  fHttpCli.URL      := URLRef_[fFirstUrl].AsString;
  fHttpCli.Location := URLRef_[fFirstUrl].AsString;

  // Отправка данных
  fHttpCli.FollowRelocation := False;
  if DebugMode then
    Notifycation([niTxt], 0, 0, 0, 'UrlPost: ' + fHttpCli.URL);

  fHttpCli.SendStream.Position := 0;
  fHttpCli.Post;
end;

procedure TXmlRpcClient.QuickSetup(iUrl, iProxy, iProxyPort: string);
begin
  URL       := iUrl;
  Proxy     := iProxy;
  ProxyPort := iProxyPort;
end;

procedure TXmlRpcClient.Resume;
begin
  fHttpCli.CtrlSocket.Resume;
end;

procedure TXmlRpcClient.SetProxyPort(Value: string);
begin
  fHttpCli.ProxyPort := Value;
end;

procedure TXmlRpcClient.SetAutoDetectProxy(const Value: Boolean);
begin
  fAutoDetectProxy := Value;
end;

procedure TXmlRpcClient.SetCookie(Name: string; Value: string);
var Cookies_, Cookie_: TStrArray;
    i: Integer;
    IsFound: Boolean;
begin
  IsFound := False;
  Cookies_ := UC_Explode(';', fHttpCli.Cookie);
  for I := Low(Cookies_) to High(Cookies_) do
  begin
    Cookie_ := UC_Explode('=', Cookies_[i], 2);
    if CompareText(Trim(Cookie_[0]), Name) = 0 then
    begin
      Cookie_[1] := Value;
      Cookies_[i] := UC_Implode('=', Cookie_);
      fHttpCli.Cookie := UC_Implode(';', Cookies_);
      IsFound := True;
    end;
  end;

  if (not IsFound) and (Value <> '') then
    fHttpCli.Cookie := fHttpCli.Cookie +
                       IfThen(fHttpCli.Cookie <> '', '; ') +
                       UC_Implode('=', [Name, Value]);

end;

procedure TXmlRpcClient.SetLocationChangeMaxCount(const Value: Integer);
begin
  fHttpCli.LocationChangeMaxCount := Value;
end;

procedure TXmlRpcClient.SetProxy(Value: string);
begin
  fHttpCli.Proxy := Value;
end;

procedure TXmlRpcClient.SetURL(Value: string);
begin
  fHttpCli.URL := Value;
end;

procedure TXmlRpcClient.Stop;
begin
  fHttpCli.Abort;
end;

initialization
  URLRef_ := TDBFields.Create;

finalization
  URLRef_.Free;

end.
