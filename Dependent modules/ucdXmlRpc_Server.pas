// Версия - 29.03.2012
unit ucdXmlRpc_Server;
{
  Модуль рассчитан на Delphi 2010.
  Для работы с этим модулем необходимо установить компоненты:
  OverbyteIcsV7 - http://www.overbyte.be/frame_index.html
}
{$include ..\delphi_ver.inc}

interface

uses Windows, SysUtils, StrUtils, Classes, OverbyteIcsHttpSrv, OverbyteIcsWSocket,
     ucClasses, ucFunctions, ucXmlRpc, UcTimer, ucdXmlRpc_Client, ucTypes;

const

  ////[1001..1019] - Ошибки класса xmlrpc_server
  rpcErr_BadRequest       = 1001; //1001 => "XML request is empty or incorrect.",
  rpcErr_BadMethod        = 1002; //1002 => "Metod name is bad.",
  rpcErr_UnitNotFound     = 1003; //1003 => "Unit not found.",
  rpcErr_FuncNoExists     = 1004; //1004 => "Function not exists.",
  rpcErr_FuncCrash        = 1005; //1005 => "Function must return object as xmlrpcresponse.",
  //
  ////[1020..1050] - Ошибки подключаемых модулей типа common.php
  rpcErr_InternalError    = 1020; //1020 => "Internal error",
  rpcErr_AccessDenied     = 1021; //1021 => "Access denied",
  //
  ////[1051..1500] - Ошибки классов из "src/classes"
  //
  ////[1501..2000] - Ошибки функций из "src/func"
  //
  ////[2001.. ...] - Ошибки функций из "srcrpc"
  rpcErr_FileNotFound     = 2001; //2001 => "File not found",
  rpcErr_UploadFiled      = 2002; //2002 => "Upload error",
  rpcErr_NoUpdate         = 2003; //2003 => "Update not available",
  rpcErr_DecompressFiled  = 2004; //2004 => "Unable to decompress the data"

type
  TRemoteProcedureList = class;
  TSession = class;
  TSessionList = class;

  TRemoteProcedure = procedure(XRCall: TUcXmlRpcCall; XRResp: TUcXmlRpcResponse;
                               Session: TSession);

  TXmlRpcServer = class (TUcNotifyObjectEx)
  private
    fHttpSrv: THttpServer;
    fRPL: TRemoteProcedureList;
    fSessions: TSessionList;
    procedure DoHeadDocument(Sender: TObject; Client: TObject;
                             var Flags : THttpGetFlag);
    procedure DoGetDocument(Sender: TObject; Client: TObject;
                            var Flags : THttpGetFlag);
    procedure DoPostDocument(Sender: TObject; Client: TObject;
                             var Flags : THttpGetFlag);
    procedure DoPostedData(Sender: TObject; Client: TObject; Error: Word);
  public
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>XML параметров запроса (передаваемые данные)</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    XRCall: TUcXmlRpcCall;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>XML параметров ответа (получаемые данные)</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    XRResp: TUcXmlRpcResponse;
    constructor Create; override;
    destructor Destroy; override;
    function Start: Boolean; overload;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>
    ///	  <para>Стартует сервер с портом из указанного диапазона.</para>
    ///	  <para>Выбирается начальный прт. Если порт занят, то берется
    ///	  следующий... Так пока не будет открыт порт или дистигнут конец
    ///	  списка.</para>
    ///	</summary>
    ///	<param name="PortRangeStart">Начальный порт из диапазона.</param>
    ///	<param name="PortRangeEnd">Конечный порт из диапазона.</param>
    ///	<returns>Номер открытого порта или 0.</returns>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function Start(PortRangeStart, PortRangeEnd: Integer): Integer; overload;
    procedure Stop;
    function SelfTest: Boolean;
    procedure RegisterProc(Group, Name: string; Proc: TRemoteProcedure);
    procedure UnregisterProc(Proc: TRemoteProcedure);
    property HttpSrv: THttpServer read fHttpSrv;
    property SessionList: TSessionList read fSessions;
  end;

  TSrvHttpConnection = class(THttpConnection)
  protected
    FPostedRawData    : PAnsiChar; { Will hold dynamically allocated buffer }
    FPostedDataBuffer : PChar;     { Contains either Unicode or Ansi data   }
    FPostedDataSize   : Integer;   { Databuffer size                        }
    FDataLen          : Integer;   { Keep track of received byte count.     }
    FDataFile         : TextFile;  { Used for datafile display              }
    FFileIsUtf8       : Boolean;
  public
    destructor  Destroy; override;
  end;

  TRemoteProcedureList = class
  private
    fProcs: TDBFields;
  public
    constructor Create;
    destructor Destroy; override;

    procedure RegisterProc(Group, Name: string; Proc: TRemoteProcedure);
    procedure UnregisterProc(Proc: TRemoteProcedure);
    function  CallProc(FullName: string; XRCall: TUcXmlRpcCall;
                       XRResp: TUcXmlRpcResponse; Session: TSession): Boolean; overload;
    function  CallProc(Group, Name: string; XRCall: TUcXmlRpcCall;
                       XRResp: TUcXmlRpcResponse; Session: TSession): Boolean; overload;
  end;

  TSession = class(TDBFields)
  private
    fDateLastUse: TDateTime;
    fOwner: TDBField;
    function GetSSID: string;
  public
    constructor Create(AOwner: TDBField); reintroduce;
    destructor  Destroy; override;
    procedure UpdateDateLastUse;
    property DateLastUse: TDateTime read fDateLastUse;
    property SSID: string read GetSSID;
  end;

  TSessionList = class
  private
    fSessions: TDBFields;
    fTimer: TUcTimer;
    FSessionExpireTime: TDateTime;
    procedure SetSessionExpireTime(const Value: TDateTime);
    function GetCount: Integer;
    function GetSession_(Index: Integer): TSession;
  protected
    procedure DoSessionsChanged(Sender: TObject);
    procedure DoTimer(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    class function GenerateSSID: string;
    function GetSession(SSID: string): TSession;
    procedure KillOldSessions(ExpireTime: TDateTime);

    property SessionExpireTime: TDateTime read FSessionExpireTime write SetSessionExpireTime;
    property Count: Integer read GetCount;
    property Session[Index: Integer]: TSession read GetSession_;
  end;

implementation

{ TXmlRpcServer }

constructor TXmlRpcServer.Create;
begin
  inherited;
  fHttpSrv := THttpServer.Create(nil);
  fHttpSrv.ClientClass := TSrvHttpConnection;
  fHttpSrv.Port := '8080';
  // Обработчики событий
  fHttpSrv.OnHeadDocument := DoHeadDocument;
  fHttpSrv.OnGetDocument  := DoGetDocument;
  fHttpSrv.OnPostDocument := DoPostDocument;
  fHttpSrv.OnPostedData   := DoPostedData;
  // Список вызываемых функций
  fRPL := TRemoteProcedureList.Create;
  // Инициализируем сессии
  fSessions := TSessionList.Create;
  //**
  XRCall := TUcXmlRpcCall.Create;
  XRResp := TUcXmlRpcResponse.Create;
end;

destructor TXmlRpcServer.Destroy;
begin
  XRCall.Free;
  XRResp.Free;
  fSessions.Free;
  fRPL.Free;
  fHttpSrv.Free;
  inherited;
end;

procedure TXmlRpcServer.DoHeadDocument(Sender, Client: TObject;
  var Flags: THttpGetFlag);
begin
  {$IFDEF DELPHI_2009_UP}
  TSrvHttpConnection(Client).AnswerStringEx(Flags, '', '', '', '', CP_UTF8);
  {$ELSE}
  TSrvHttpConnection(Client).AnswerString(Flags, '', '', '', '');
  {$ENDIF}
end;

procedure TXmlRpcServer.DoGetDocument(Sender, Client: TObject;
  var Flags: THttpGetFlag);
var ClientCnx: TSrvHttpConnection;
begin
  ClientCnx := TSrvHttpConnection(Client);
  {$IFDEF DELPHI_2009_UP}
  ClientCnx.AnswerStringEx(Flags, '', '',
    'Content-Type: text/xml; charset=utf-8'#13#10,
    '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">' +
    '<html><head>' +
    '<meta http-equiv="content-type" content="text/html; charset=utf-8">' +
    '<title>Untitled</title></head><body>'+
    '<div style="position: absolute; top: 40%; width: 100%;">' +
    '<center><h1>Этот ресурс является WEB-сервисом</h1></center>' +
    '</div></body></html>',
    CP_UTF8
  );
  {$ELSE}
  ClientCnx.AnswerString(Flags, '', '',
    'Content-Type: text/html; charset=utf-8'#13#10,
    '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">' +
    '<html><head>' +
    '<meta http-equiv="content-type" content="text/html; charset=utf-8">' +
    '<title>Untitled</title></head><body>'+
    '<div style="position: absolute; top: 40%; width: 100%;">' +
    '<center><h1>Этот ресурс является WEB-сервисом</h1></center>' +
    '</div></body></html>'
  );
  {$ENDIF}
end;

procedure TXmlRpcServer.DoPostDocument(Sender, Client: TObject;
  var Flags: THttpGetFlag);
var
    ClientCnx  : TSrvHttpConnection;
begin
    { It's easyer to do the cast one time. Could use with clause... }
    ClientCnx := TSrvHttpConnection(Client);

    { Count request and display a message }
    if ClientCnx.RequestContentLength <= 0 then
    begin
      Flags := hg403;
      Exit;
    end;


  { Check for request past. We accept data for '/cgi-bin/FormHandler'    }
  { and any name starting by /cgi-bin/FileUpload/' (End of URL will be   }
  { the filename                                                         }
    { Tell HTTP server that we will accept posted data                 }
    { OnPostedData event will be triggered when data comes in          }
    Flags := hgAcceptData;
    { We wants to receive any data type. So we turn line mode off on   }
    { client connection.                                               }
    ClientCnx.LineMode := FALSE;
    { We need a buffer to hold posted data. We allocate as much as the }
    { size of posted data plus one byte for terminating nul char.      }
    { We should check for ContentLength = 0 and handle that case...    }
    ReallocMem(ClientCnx.FPostedRawData,
               ClientCnx.RequestContentLength + 1);
    { Clear received length                                            }
    ClientCnx.FDataLen := 0;
end;

procedure TXmlRpcServer.DoPostedData(Sender, Client: TObject; Error: Word);
var
    Len     : Integer;
    Remains : Integer;
    Junk    : array [0..255] of AnsiChar;
    ClientCnx  : TSrvHttpConnection;
    Flags: THttpGetFlag;
    SSID: string;
begin
  { It's easyer to do the cast one time. Could use with clause... }
  ClientCnx := TSrvHttpConnection(Client);

  { How much data do we have to receive ? }
  Remains := ClientCnx.RequestContentLength - ClientCnx.FDataLen;
  if Remains <= 0 then begin
      { We got all our data. Junk anything else ! }
      Len := ClientCnx.Receive(@Junk, SizeOf(Junk) - 1);
      if Len >= 0 then
          Junk[Len] := #0;
      Exit;
  end;
  { Receive as much data as we need to receive. But warning: we may       }
  { receive much less data. Data will be split into several packets we    }
  { have to assemble in our buffer.                                       }
  Len := ClientCnx.Receive(ClientCnx.FPostedRawData + ClientCnx.FDataLen, Remains);
  { Sometimes, winsock doesn't wants to givve any data... }
  if Len <= 0 then
      Exit;

  { Add received length to our count }
  Inc(ClientCnx.FDataLen, Len);
  { Add a nul terminating byte (handy to handle data as a string) }
  ClientCnx.FPostedRawData[ClientCnx.FDataLen] := #0;

  { When we received the whole thing, we can process it }
  if ClientCnx.FDataLen = ClientCnx.RequestContentLength then begin
    { First we must tell the component that we've got all the data }
    ClientCnx.PostedDataReceived;

    // Данные POST запроса полностью получены! Теперь можно обработать )))
    if not GetCookieValue(ClientCnx.RequestCookies, 'SESSID', SSID) then
      SSID := fSessions.GenerateSSID;

    XRResp.Clear;

    try
      XRCall.XML := String(ClientCnx.FPostedRawData);
    except
      XRResp.SetAsFault(rpcErr_BadRequest, 'XML request is empty or incorrect.');
    end;

    if not XRResp.IsFault then
    try
      { TODO : Добить сессии }
      if not fRPL.CallProc(XRCall.MetodName, XRCall, XRResp,
                           fSessions.GetSession(SSID)) then
        XRResp.SetAsFault(rpcErr_FuncNoExists, 'Function "' + XRCall.MetodName + '" not exists.');
    except
      on E: EInOutError do
        XRResp.SetAsFault(E.ErrorCode, E.Message);
      on E: EOSError do
        XRResp.SetAsFault(E.ErrorCode, E.Message);
      on E: Exception do
        XRResp.SetAsFault(rpcErr_InternalError, E.Message);
    end;

    // Посылаем ответ
  {$IFDEF DELPHI_2009_UP}
    ClientCnx.AnswerStringEx(Flags, '', '',
      'Set-Cookie: SESSID=' + SSID + #13#10, XRResp.XML, CP_UTF8);
  {$ELSE}
    ClientCnx.AnswerString(Flags, '', '',
      'Set-Cookie: SESSID=' + SSID + #13#10, XRResp.XML);
  {$ENDIF}
  end;
end;

procedure TXmlRpcServer.RegisterProc(Group, Name: string;
  Proc: TRemoteProcedure);
begin
  fRPL.RegisterProc(Group, Name, Proc);
end;

function TXmlRpcServer.Start: Boolean;
begin
  try
    fHttpSrv.Start;
    Result := True;
  except
    Result := False;
  end;
end;

function TXmlRpcServer.SelfTest: Boolean;
var XRC: TXmlRpcClient;
begin
  XRC := TXmlRpcClient.Create;
  try
    // Настройка клиента
    XRC.AutoDetectProxy := True;
    XRC.LocationChangeMaxCount := 2;
    XRC.URL := 'http://localhost:' + fHttpSrv.Port;

    // Проверка соединения
    XRC.ClearStreams;
    // Подготавливаем запрос информации о новой версии
    XRC.XRCall.MetodName := 'service.test_connection';
    // Отсылавем запрос
    Result := XRC.CallRemoteProcedure;

    // Обрабатываем результаты запроса
    Result := Result and (not XRC.XRResp.IsFault) and xrc.XRResp.Params[0].AsBoolean;
  finally
    XRC.Free;
  end;
end;

function TXmlRpcServer.Start(PortRangeStart, PortRangeEnd: Integer): Integer;
var i: Integer;
begin
  Result := 0;

  i := PortRangeStart;
  while i <= PortRangeEnd do
  try
    fHttpSrv.Port := IntToStr(i);
    fHttpSrv.Start;
    Result := i;
    Break;
  except
    On E: ESocketException do
    begin
      if GetLastError = 10048 then
        Inc(i)
        else
        break;
    end;
  end;
end;

procedure TXmlRpcServer.Stop;
begin
  fHttpSrv.Stop;
end;

procedure TXmlRpcServer.UnregisterProc(Proc: TRemoteProcedure);
begin
  fRPL.UnregisterProc(Proc);
end;

{ TRemoteProcedureList }

constructor TRemoteProcedureList.Create;
begin
  fProcs := TDBFields.Create;
end;

destructor TRemoteProcedureList.Destroy;
begin
  fProcs.Free;
  inherited;
end;

procedure TRemoteProcedureList.RegisterProc(Group, Name: string;
                                            Proc: TRemoteProcedure);
begin
  fProcs[Group + '.' + Name].AsInt64 := int64(@Proc);
end;

procedure TRemoteProcedureList.UnregisterProc(Proc: TRemoteProcedure);
var i: Integer;
begin
  i:= 0;
  while i < fProcs.Count do
  begin
    if fProcs.Fields[i].AsInt64 = int64(@Proc) then
      fProcs.Fields[i].Free
      else
      Inc(i);
  end;
end;

function TRemoteProcedureList.CallProc(FullName: string; XRCall: TUcXmlRpcCall;
  XRResp: TUcXmlRpcResponse; Session: TSession): Boolean;
var Proc: TDBField;
begin
  Proc := fProcs.FindField(FullName);
  Result := Assigned(Proc);
  if Result then
    TRemoteProcedure(Proc.AsInt64)(XRCall, XRResp, Session);
end;

function TRemoteProcedureList.CallProc(Group, Name: string;
  XRCall: TUcXmlRpcCall; XRResp: TUcXmlRpcResponse; Session: TSession): Boolean;
begin
  Result := CallProc(Group + '.' + Name, XRCall, XRResp, Session);
end;

{ TSrvHttpConnection }

destructor TSrvHttpConnection.Destroy;
begin
  if Assigned(FPostedRawData) then
  begin
    FreeMem(FPostedRawData, FPostedDataSize);
    FPostedRawData  := nil;
    FPostedDataSize := 0;
  end;
  inherited Destroy;
end;

{ TSession }

constructor TSession.Create(AOwner: TDBField);
begin
  inherited Create;
  fOwner := AOwner;
  UpdateDateLastUse;
end;

destructor TSession.Destroy;
begin
  if fOwner.IsNormalState then
    fOwner.AsObject := nil;
  inherited;
end;

function TSession.GetSSID: string;
begin
  Result := fOwner.FieldName;
end;

procedure TSession.UpdateDateLastUse;
begin
  fDateLastUse := Now;
end;

{ TSessionList }

constructor TSessionList.Create;
begin
  inherited;
  fSessions := TDBFields.Create;
  fSessions.RegisterNotify(DoSessionsChanged);
  fTimer    := TUcTimer.Create(nil);
  fTimer.AlarmClock := 5*60*1000; // Каждые 5 минут чистятся сессии
  fTimer.OnAlarmClock := DoTimer;

  { Устанавливаем время жизни сессий 2 часа. Потом сессии автоматически удаляются.
    Помним, что при каждом обращении к сессии вызвав GetSession, обновляется
    дата использования сессии. Т.е. если сессия автоматически умрет если не используется
    в течении заданного (здесь) времени }
  FSessionExpireTime := ((3600)*2{hours} + (60)*0{minutes} + 0{seconds})/(60*60*24);
end;

destructor TSessionList.Destroy;
begin
  fTimer.Free;
  fSessions.Clear;
  fSessions.Free;
  inherited;
end;

class function TSessionList.GenerateSSID: string;
begin
  Result := UC_MD5String(RawByteString(DateTimeToStr(Now) + UC_GeneratePassword));
end;

function TSessionList.GetCount: Integer;
begin
  Result := fSessions.Count;
end;

function TSessionList.GetSession(SSID: string): TSession;
var Field: TDBField;
begin
  Field := fSessions[SSID];
  if not Assigned(Field.AsObject) then
    Field.AsObject := TSession.Create(Field);
  Result := TSession(Field.AsObject);
  Result.UpdateDateLastUse;

  fTimer.Enabled := True;
end;

function TSessionList.GetSession_(Index: Integer): TSession;
begin
  Result := TSession(fSessions.Fields[Index].AsObject);
end;

procedure TSessionList.KillOldSessions(ExpireTime: TDateTime);
var PointRelevance: TDateTime;
    i: Integer;
begin
  PointRelevance := Now - ExpireTime;
  i := 0;
  while i < fSessions.Count do
    if Assigned(fSessions.Fields[i].AsObject) and
       (TSession(fSessions.Fields[i].AsObject).DateLastUse < PointRelevance) then
      fSessions.Fields[i].Free
      else
      Inc(i);
end;

procedure TSessionList.SetSessionExpireTime(const Value: TDateTime);
begin
  if FSessionExpireTime <> Value then
  begin
    FSessionExpireTime := Value;
    if FSessionExpireTime = 0 then
      fTimer.Enabled := False;
  end;
end;

procedure TSessionList.DoSessionsChanged(Sender: TObject);
var Fields: TDBFields;
begin
  Fields := TDBFields(Sender);
  if Fields.IsNormalState then
  begin
    if Assigned(Fields.ChangedField) and
       (not Fields.ChangedField.IsNormalState) and
       Assigned(Fields.ChangedField.AsObject) then
      Fields.ChangedField.AsObject.Free;
  end;
end;

procedure TSessionList.DoTimer(Sender: TObject);
begin
  KillOldSessions(FSessionExpireTime);
  //--
  TUcTimer(Sender).Restart;
end;

end.
