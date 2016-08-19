// Версия - 28.08.2014
unit ucWindows;
{$include ..\delphi_ver.inc}

interface

uses
  Forms, Windows, Messages, SysUtils, Classes, ActiveX, ShlObj, ComObj, TlHelp32,
  ShellAPI, ComCtrls, Controls,
  ucTypes, PsAPI;

type
  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Класс для работы с ярлыками</summary>
  ///	<example>with TUcShortCut.Create do begin ShellLink.SetPath('D:\');
  ///	ShellLink.SetArguments('yo yo'); ShellLink.SetWorkingDirectory('D:\');
  ///	ShellLink.SetIconLocation('%SystemRoot%\system32\SHELL32.dll', 25);
  ///	ShellLink.SetDescription('Описание программы');
  ///	ShellLink.SetShowCmd(SW_MAXIMIZE); Save('D:\test\test.lnk'); Free;
  ///	end;</example>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  TUcShortCut = class
  private
    fPersistFile: IPersistFile;
    fShellLink: IShellLink;
  public
    constructor Create;

    function GetPath(out Path: string): Boolean;
    function GetIconLocation(out IconPath: string; out IconIndex: Integer): Boolean;
    function GetDescription(out Description: string): Boolean;
    function GetShowCmd(out ShowCmd: Integer): Boolean;
    function GetArguments(out Args: string): Boolean;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Загрузка данных ярлыка</summary>
    ///	<param name="pszFileName">Загрузка данных ярлыка из файла</param>
    ///	<param name="dwMode">Режим доступа</param>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function Load(pszFileName: string; dwMode: Longint = STGM_READ): Boolean;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Сохранение данных ярлыка в файл</summary>
    ///	<param name="pszFileName">Имя файла</param>
    ///	<param name="fRemember">??</param>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    function Save(pszFileName: string; fRemember: BOOL = False): Boolean;

    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Объект с параметрами ярлыка</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property ShellLink: IShellLink read fShellLink;
    {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
    ///	<summary>Объект доступа к файловой системе</summary>
    {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
    property PersistFile: IPersistFile read fPersistFile;
  end;


{$IFDEF DELPHI_2009_UP}
  ///	<summary>Класс доступа к интерфейсам панели задач Windows</summary>
  TUcTaskbarList = class
  private
    fTaskbarList:  ITaskbarList;
    fTaskbarList2: ITaskbarList2;
    fTaskbarList3: ITaskbarList3;
    fTaskbarList4: ITaskbarList4;
  protected
    procedure ClearTaskbarLists;
  public
    constructor Create;
    destructor Destroy; override;

    property TaskbarList:  ITaskbarList  read fTaskbarList;
    property TaskbarList2: ITaskbarList2 read fTaskbarList2;
    property TaskbarList3: ITaskbarList3 read fTaskbarList3;
    property TaskbarList4: ITaskbarList4 read fTaskbarList4;
  end;

  ///	<summary>Класс-контроллер. Синхронизирует отображение некоторого
  ///	прогресса на ProgressBar и на кнопке панели задач.</summary>
  TUcTaskbarListProgress = class
  private
    fTBL: TUcTaskbarList;
    fWinHandle: HWND;
    fPrBar: TProgressBar;
    FMax: Integer;
    FPosition: Integer;
    FMin: Integer;
    FState: TProgressBarState;
    FStyle: TProgressBarStyle;
    FProgressState: Integer;
    FShowProgressOnTaskbar: Boolean;
    procedure SetMax(const Value: Integer);
    procedure SetPosition(const Value: Integer);
    procedure SetMin(const Value: Integer);
    procedure UpdateTaskbarListProgress;
    procedure UpdateTaskbarListProgressState;
    procedure SetState(const Value: TProgressBarState);
    procedure SetStyle(const Value: TProgressBarStyle);
    procedure SetProgressState(const Value: Integer);
    procedure SetShowProgressOnTaskbar(const Value: Boolean);
  protected
    property ProgressState: Integer read FProgressState write SetProgressState;
  public
    constructor Create;
    destructor Destroy; override;
    ///	<summary>Инициализация контроллера</summary>
    ///	<param name="WindowHandle">Хендл окна имеющего кнопку на панели задач.
    ///	На Этой кнопке будет отображаться прогресс.</param>
    ///	<param name="ProgressBar">Компонент для отображения прогресса.</param>
    procedure Init(WindowHandle: HWND; ProgressBar: TProgressBar);
    procedure InitDef(ProgressBar: TProgressBar);
    property Max: Integer read FMax write SetMax;
    property Min: Integer read FMin write SetMin;
    property Position: Integer read FPosition write SetPosition;
    property Style: TProgressBarStyle read FStyle write SetStyle;
    property State: TProgressBarState read FState write SetState;
    property ShowProgressOnTaskbar: Boolean read FShowProgressOnTaskbar
                                            write SetShowProgressOnTaskbar;
  end;
{$ENDIF}

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Выключение/перезагрузка компа без сохранения данных (выдергивание
///	из розетки!)</summary>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function  NtShutdownSystem(Action : SHUTDOWN_ACTION): LongInt; stdcall; external 'ntdll.dll';
function  ShutdownSystem(Action : SHUTDOWN_ACTION): LongInt;
// Мютексы
{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Создает Мютекс в системе</summary>
///	<param name="mid">Имя мютекса</param>
///	<returns>Результат создания мютекса</returns>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_InitMutex(mid: string): boolean;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Удаляет мютекс с заданным именем</summary>
///	<param name="mid">имя мютекса</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
procedure UC_DeleteMutex(mid: string);

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Генерирует GUID используя функцию CreateGUID</summary>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_CreateGUID: string;

// Проверяет перекрыто ли заданное окно другими
{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Проверяет перекрыто ли заданное окно другими</summary>
///	<param name="WinHandle">Хэндл окна</param>
///	<returns>
///	  <para>True - окно видно полностью</para>
///	  <para>False - окно закрыто другми окнами</para>
///	</returns>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_VisibleWinRectFull(WinHandle: HWND): Boolean;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Ожидание освобождения объекта</summary>
///	<param name="hHandle">Объект</param>
///	<param name="Milliseconds">Время ожидания</param>
///	<param name="AsyncMode">Асинхронный режим (использует
///	Application.ProcessMessages)</param>
///	<returns>Успех если дождались освобождения объекта или истекло время
///	ожидания.</returns>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_WaitForSingleObject(hHandle: THandle; Milliseconds: DWORD;
                                AsyncMode: Boolean): Boolean;
{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Запуск процесса с ожиданием</summary>
///	<param name="FileName">Имя Файла для запуска</param>
///	<param name="Params">Командная строка</param>
///	<param name="WinState">Состояние окна запускаемой программы</param>
///	<param name="Milliseconds">Время ожидания завершения процесса в
///	миллисикундах. [0..INFINITE]</param>
///	<param name="AsyncMode">Если =True, то функция будет вызывать
///	Application.Processmessages</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_Execute(const FileName, Params: String; const AShowCmd: Word;
                    const Milliseconds: DWORD; AsyncMode: Boolean = False): Boolean;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Завершает все процессы с указанным именем exe-файла (имени образа
///	процесса)</summary>
///	<param name="ExeName">имя exe-файла (образа процесса)</param>
///	<param name="Forcibly">Принудительное завершение. Если true, то при
///	истечении таймаута указанного в Milliseconds процесс завершается
///	принудительно</param>
///	<param name="Milliseconds">Время ожидания завершения процесса.</param>
///	<param name="AsyncMode">Асинхронный (не блокирующий) режим работы</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_TaskKill(ExeName: string; Forcibly: Boolean = False;
                     Milliseconds: Integer = 3000; AsyncMode: Boolean = False): Boolean;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Проверяет существование процесса с именем exe-файла (образа
///	процесса)</summary>
///	<param name="ExeName">имя exe-файла</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_TaskExists(ExeName: string; CheckFilePath: Boolean = False): Boolean;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Запуск от имени администратора</summary>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_RunAsAdministrator(const FileName, Params, ADirectory: string;
                               AShowCmd: Integer; const Milliseconds: DWORD = 0;
                               AsyncMode: Boolean = False): Boolean;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Открывает URL в браузере по умолчанию</summary>
///	<param name="URL">Адрес сайта</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
procedure UC_GoToWebSite(URL: string);


{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Получение значения переменных среды Windows
///	http://ru.wikipedia.org/wiki/Переменные_среды_Windows</summary>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_GetEnvironmentVariable(VarName: string): string;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Преобразование CSIDL_-идентификатора в путь в файловой
///	системе</summary>
///	<param name="CSIDL">CSIDL_-идентификатор из модуля ShlObj</param>
///	<returns>Путь к папке или пустая строка</returns>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_ShGetSpecialFolderLocation(CSIDL: Integer): string;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Отображение стандартного окна свойств файла/папки</summary>
///	<param name="FileName">Путь к файлу/папке свойства которого нужно показать</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
procedure UC_ShowFileProperties(const FileName: string);

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Загружает системные курсоры из профиля текущего
///	пользователя.</summary>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
procedure UC_SetupSystemCursors;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Добавляет на панель задач кнопку для указанного окна</summary>
///	<param name="Handle">Хендл окна</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
procedure UC_SetWinButtonToTaskBar(Handle: HWND);

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Выводит главное окно программы на передний план</summary>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
procedure UC_ShowMainForm;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Возвращает имя пользователя от имени которого работает текущий
///	процесс</summary>
///	<param name="UserName">Имя пользователя</param>
///	<returns>Успешность выполнения операции</returns>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_GetUserName(out UserName: string): Boolean;
{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Получение серийного номера тома диска</summary>
///	<param name="disk">Буква тома в формате X:\</param>
///	<param name="SerialNum">Серийный номер тома диска в 16-тиричной
///	форме</param>
///	<returns>Успешность выполнения операии</returns>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_GetSerialNumberVolumeDisk(disk: string; out SerialNum: string): Boolean;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Выполнение системных комманд управления окном</summary>
///	<param name="SysCommand">Команда. (напрмер: SC_DragMove)</param>
///	<example>UC_WinSysCommand(SC_DragMove);</example>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
procedure UC_WinSysCommands(Handle: HWND; SysCommand: Integer);

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Перемещение/изменение размера элемена управления</summary>
///	<param name="Ctrl">Элемент управления</param>
///	<param name="Top">Верхняя граница для изменения размера</param>
///	<param name="Right">Правая граница для изменения размера</param>
///	<param name="Bottom">Нижняя граница для изменения размера</param>
///	<param name="Left">Левая граница для изменения размера</param>
///	<param name="Drag">Действие. True - переместить. False - Установить
///	курсор.</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
procedure UC_WinSysControlCMD(Ctrl: TWinControl;
                              Top, Right, Bottom, Left: Integer;
                              Drag: Boolean; CanMove: Boolean = True);

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Включение/отключение кнопки "закрыть" в заголовке окна</summary>
///	<param name="Handle">Хэндл окна</param>
///	<param name="Enable">Вкл/Выкл</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
procedure UC_ChangeCloseButton(Handle: HWND; Enable: Boolean);


{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Получение названия группы "Все" (например, для английской версии
/// Windows это Everyone)</summary>
///	<example>UC_GetEveryoneGroup();</example>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_GetEveryoneGroup: string;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Проверяет состояние виртуальной клавиши (нажата или
///	нет).</summary>
///	<param name="Key">Код клавиши: VK_...</param>
///	<returns>Состояние клавиши</returns>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_IsKeyPressed(Key: Word): Boolean;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Инициализация анимации TAnimate. Загружает ресурс, по имени, из
///	текущего *.exe и настраивает</summary>
///	<param name="Animate">Компонент анимации</param>
///	<param name="ResName">Имя ресурса с анимацией</param>
///	<param name="Activate">Указывает нужно ли сразу запустить анимацию</param>
///	<param name="Hint">Устанавливает подсказку</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
procedure UC_AnimateInit(Animate: TAnimate; ResName: string;
                         Activate: Boolean = False; Hint: string = '');

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Управляет активностью анимации. Не активная скрывается.</summary>
///	<param name="Animate">Компонент анимации</param>
///	<param name="Active">Показать/запустить или остановить/скрыть</param>
///	<param name="Hint">Устанавливает подсказку</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
procedure UC_AnimateSetActive(Animate: TAnimate; Active: Boolean; Hint: string = '');


implementation

var Mutexes_: TStringList = nil;

function  ShutdownSystem(Action : SHUTDOWN_ACTION): LongInt;
var
  hToken: THandle;
  tkp, prevst: TTokenPrivileges;
  rl: DWORD;
begin
  OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken);

  LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tkp.Privileges[0].Luid);
  tkp.PrivilegeCount := 1;
  tkp.Privileges[0].Attributes := 2;

  AdjustTokenPrivileges(hToken, FALSE, tkp, SizeOf(prevst), prevst, rl);

  Result := NtShutdownSystem(Action);
end;

function Mutexes: TStringList;
begin
  if not Assigned(Mutexes_) then Mutexes_ := TStringList.Create;
  Result := Mutexes_;
end;

function UC_InitMutex(mid: string): boolean;
var mut_id: string; // Может быть любое слово. Желательно латинскими буквами.
    mut: thandle;
begin
  mut_id := StringReplace(mid, '\', '_', [rfReplaceAll]);
  Mut := CreateMutex(nil, false, pchar(mut_id));
  Result := not ((Mut = 0) or (GetLastError = ERROR_ALREADY_EXISTS));

  if Result then
    Mutexes.AddObject(mut_id, TObject(mut));
end;

procedure UC_DeleteMutex(mid: string);
var i: Integer;
    mut_id: string; // Может быть любое слово. Желательно латинскими буквами.
begin
  mut_id := StringReplace(mid, '\', '_', [rfReplaceAll]);
  i := Mutexes.IndexOf(mut_id);
  if i > -1 then
  begin
    CloseHandle(LongWord(Mutexes_.Objects[0]));
    Mutexes.Delete(i);
  end;
end;

function UC_CreateGUID: string;
var MyGUID : TGUID;
begin
  CreateGUID(MyGUID);
  Result := GUIDToString(MyGUID);
  // Убираем скобки
  Result := StringReplace(Result, '{', '', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll]);
end;

function UC_VisibleWinRectFull(WinHandle: HWND): Boolean;
var wnd: HWND;
    WndRect, wRect: TRect;
begin
  Result := GetWindowRect(WinHandle, WndRect);
  if not Result then Exit;

  wnd := GetWindow(WinHandle, GW_HWNDFIRST);
  while (wnd > 0)and(wnd <> WinHandle) do
  begin
    if (GetWindowLong(wnd, GWL_STYLE)and WS_VISIBLE > 0)and GetWindowRect(wnd, wRect) then
      if IntersectRect(wRect, wRect, WndRect) then
      begin
        Result := False;
        Exit;
      end;
    wnd := GetWindow(wnd, GW_HWNDNEXT);
  end;
end;

function UC_WaitForSingleObject(hHandle: THandle; Milliseconds: DWORD;
                                AsyncMode: Boolean): Boolean;

var
  tStart: TDateTime;
  WaitResult: Cardinal;

begin
  tStart := Now;
  if AsyncMode then
  begin
    repeat
      Application.ProcessMessages;
      WaitResult := WaitForSingleObject(hHandle, 100);
    until Application.Terminated or (WaitResult <> WAIT_TIMEOUT) or
          ((Now - tStart) * 24 * 60 * 60 * 1000 > Milliseconds);
  end else WaitResult := WaitForSingleObject(hHandle, Milliseconds);
  Result := ((Now - tStart) * 24 * 60 * 60 * 1000 >= Milliseconds) or
            (WaitResult <> WAIT_TIMEOUT);
end;

function UC_Execute(const FileName, Params: String; const AShowCmd: Word;
                    const Milliseconds: DWORD; AsyncMode: Boolean = False): Boolean;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: String;
begin
  { Помещаем имя файла между кавычками, с соблюдением всех пробелов в именах Win9x }
  CmdLine := '"' + Filename + '" ' + Params;
  FillChar(StartInfo, SizeOf(TStartupInfo), #0);
  with StartInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := AShowCmd;
  end;
  UniqueString(CmdLine);
  Result := CreateProcess(nil, PChar( String( CmdLine ) ), nil, nil, false,
                          CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
                          PChar(ExtractFilePath(Filename)), StartInfo, ProcInfo);

  { Ожидаем завершения приложения }
  if Result then
  begin
    Result := UC_WaitForSingleObject(ProcInfo.hProcess, Milliseconds, AsyncMode);
    { Free the Handles }
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

function UC_TaskKill(ExeName: string; Forcibly: Boolean = False;
                     Milliseconds: Integer = 3000; AsyncMode: Boolean = False): Boolean;

  function ProcCloseEnum(HWND: THandle; Data: Pointer): BOOL; stdcall;
  var PID: Cardinal;
  begin
    Result := True;
    GetWindowThreadProcessId(HWND, PID);
    if PID = Cardinal(Data) then
      PostMessage(HWND, WM_CLOSE, 0, 0);
  end;

var
  SSH: THandle;
  PE: TProcessEntry32;
  hProc: Cardinal;
begin
  Result := True;

  ExeName := ExtractFileName(ExeName);

  SSH := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    PE.dwSize := SizeOf(PE);
    if Process32First(SSH, PE) then
    repeat
      if CompareText(PE.szExeFile, ExeName) = 0 then
      try
        hProc := OpenProcess(SYNCHRONIZE or $0001, False, PE.th32ProcessID);
        Result := hProc = 0;
        if not Result then
        begin
          EnumWindows(@ProcCloseEnum, PE.th32ProcessID);
          UC_WaitForSingleObject(hProc, Milliseconds, AsyncMode);
          Result := WaitForSingleObject(hProc, 0) <> WAIT_TIMEOUT;
          if Forcibly then
            Result := TerminateProcess(hProc, 0);
        end;
      except
        Result := False;
      end;
    until not Process32Next(SSH, PE);
  finally
    CloseHandle(SSH);
  end;
end;

function UC_TaskExists(ExeName: string; CheckFilePath: Boolean): Boolean;
var
  SSH: THandle;
  PE: TProcessEntry32;
  hProc: THandle;
  FileName: String;
  StrLen: Integer;
begin
  Result := False;

  SSH := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    PE.dwSize := SizeOf(PE);
    if Process32First(SSH, PE) then
    repeat
      if (CheckFilePath) then
      begin
        hProc := OpenProcess(PROCESS_QUERY_INFORMATION OR PROCESS_VM_READ, false, PE.th32ProcessID);
        if (hProc <> 0) then
        begin
          SetLength(FileName, MAX_PATH);
          StrLen := GetModuleFileNameEx(hProc, 0, PChar(FileName), MAX_PATH);
          if (StrLen > 0) then
            SetLength(FileName, StrLen);
        end;
      end
      else
      begin
        FileName := PE.szExeFile;
        ExeName := ExtractFileName(ExeName);
      end;

      if CompareText(FileName, ExeName) = 0 then
      begin
        Result := True;
        Break;
      end;
    until not Process32Next(SSH, PE);
  finally
    CloseHandle(SSH);
  end;
end;

function UC_RunAsAdministrator(const FileName, Params, ADirectory: string;
                               AShowCmd: Integer; const Milliseconds: DWORD = 0;
                               AsyncMode: Boolean = False): Boolean;
var shExecInfo: TShellExecuteInfo;
    LastErr: Cardinal;
begin
  //  Запускает файл с повышенными привилегиями.
  shExecInfo.cbSize       := sizeof(ShellExecuteInfo);
  shExecInfo.fMask        := SEE_MASK_NOCLOSEPROCESS;
  shExecInfo.Wnd          := 0;
  shExecInfo.lpVerb       := 'runas';
  shExecInfo.lpFile       := PChar(FileName);
  shExecInfo.lpParameters := PChar(Params);
  shExecInfo.lpDirectory  := PChar(ADirectory);
  shExecInfo.nShow        := AShowCmd;
  shExecInfo.hInstApp     := 0;
  Result := ShellExecuteEx(@shExecInfo) and (shExecInfo.hInstApp > 32);
  if Result then
  begin
    LastErr := GetLastError;
    Result  := UC_WaitForSingleObject(shExecInfo.hProcess, Milliseconds, AsyncMode);
    CloseHandle(shExecInfo.hProcess);
    SetLastError(LastErr);
  end;
end;

procedure UC_GoToWebSite(URL: string);
begin
  if URL <> '' then
    ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWMAXIMIZED);
end;

function UC_GetEnvironmentVariable(VarName: string): string;
var
  Size : DWORD;
begin
  SetLength(Result, 10000);
  Size := GetEnvironmentVariable(PChar(VarName), PChar(Result), Length(Result));
  SetLength(Result, Size);
end;

function UC_ShGetSpecialFolderLocation(CSIDL: Integer): string;
var
  pidl: PItemIDList;
  buf: array[0..MAX_PATH] of Char;
begin
  Result := '';
  if Succeeded(ShGetSpecialFolderLocation(0, CSIDL, pidl)) then
  begin
    if ShGetPathfromIDList(pidl, buf) then
      Result := buf;
    CoTaskMemFree(pidl);
  end;
end;

procedure UC_ShowFileProperties(const FileName: string);
var sei: TShellExecuteInfo;
begin
  FillChar(sei, sizeof(sei), 0);
  sei.cbSize := sizeof(sei);
  sei.lpFile := Pchar(FileName);
  sei.lpVerb := 'properties';
  sei.fMask  := SEE_MASK_INVOKEIDLIST;
  ShellExecuteEx(@sei);
end;

procedure UC_SetupSystemCursors;
begin
//  Screen.Cursors[crDefault]   := LoadCursor(0, IDC_);
//  Screen.Cursors[crNone]      := LoadCursor(0, IDC_);
  Screen.Cursors[crArrow]     := LoadCursor(0, IDC_ARROW);
  Screen.Cursors[crCross]     := LoadCursor(0, IDC_CROSS);
  Screen.Cursors[crIBeam]     := LoadCursor(0, IDC_IBEAM);
  Screen.Cursors[crSize]      := LoadCursor(0, IDC_SIZE);

  Screen.Cursors[crSizeNESW]  := LoadCursor(0, IDC_SIZENESW);
  Screen.Cursors[crSizeNS]    := LoadCursor(0, IDC_SIZENS);
  Screen.Cursors[crSizeNWSE]  := LoadCursor(0, IDC_SIZENWSE);
  Screen.Cursors[crSizeWE]    := LoadCursor(0, IDC_SIZEWE);

  Screen.Cursors[crUpArrow]   := LoadCursor(0, IDC_UPARROW);
  Screen.Cursors[crHourGlass] := LoadCursor(0, IDC_WAIT);
//  Screen.Cursors[crDrag]      := LoadCursor(0, IDC_);
//  Screen.Cursors[crNoDrop]    := LoadCursor(0, IDC_);
//  Screen.Cursors[crHSplit]    := LoadCursor(0, IDC_);
//  Screen.Cursors[crVSplit]    := LoadCursor(0, IDC_);
//  Screen.Cursors[crMultiDrag] := LoadCursor(0, IDC_);
//  Screen.Cursors[crSQLWait]   := LoadCursor(0, IDC_);
  Screen.Cursors[crNo]        := LoadCursor(0, IDC_NO);
  Screen.Cursors[crAppStart]  := LoadCursor(0, IDC_APPSTARTING);
  Screen.Cursors[crHelp]      := LoadCursor(0, IDC_HELP);
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Screen.Cursors[crSizeAll]   := LoadCursor(0, IDC_SIZEALL);
end;

procedure UC_SetWinButtonToTaskBar(Handle: HWND);
var WLong: integer;
begin
  // Добавляем кнопку на панель задач
  WLong := GetWindowLong(Handle, gwl_ExStyle);
  SetWindowLong(Handle, gwl_ExStyle, WLong OR WS_EX_APPWINDOW);
  //**
end;

procedure UC_ShowMainForm;
var
  hWnd, hCurWnd, dwThreadID, dwCurThreadID: THandle;
  OldTimeOut: DWORD;
  AResult: Boolean;
begin
  hWnd := Application.Handle;
  if Assigned(Application.MainForm) and (Application.MainForm.WindowState = wsMinimized) then
  begin
    ShowWindow(hWnd, SW_RESTORE);
    Application.MainForm.Visible := True;   // Показываем главную форму
    Application.Restore;
  end;

  // Ставим нашу форму впереди всех окон
  SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @OldTimeOut, 0);
  SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, Pointer(0), 0);
  SetWindowPos(hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  hCurWnd := GetForegroundWindow;
  AResult := False;
  while not AResult do
  begin
    dwThreadID := GetCurrentThreadId;
    dwCurThreadID := GetWindowThreadProcessId(hCurWnd);
    AttachThreadInput(dwThreadID, dwCurThreadID, True);
    AResult := SetForegroundWindow(hWnd);
    AttachThreadInput(dwThreadID, dwCurThreadID, False);
  end;
  SetWindowPos(hWnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, Pointer(OldTimeOut), 0);
end;

function UC_GetUserName(out UserName: string): Boolean;
var BufSize: Cardinal;
begin
  BufSize  := 0;
  GetUserName(nil, BufSize);
  SetLength(UserName, BufSize);
  Result   := GetUserName(PChar(UserName), BufSize);
  UserName := PChar(UserName);
end;

function UC_GetSerialNumberVolumeDisk(disk: string; out SerialNum: string): Boolean;
var
  VolumeName         : array [0..MAX_PATH-1] of Char;
  FileSystemName     : array [0..MAX_PATH-1] of Char;
  VolumeSerialNo     : DWord;
  MaxComponentLength : DWord;
  FileSystemFlags    : DWord;
begin
  Result := GetVolumeInformation(PChar(disk), VolumeName, MAX_PATH,
                                 @VolumeSerialNo, MaxComponentLength,
                                 FileSystemFlags, FileSystemName, MAX_PATH);
  SerialNum := IntToHex(VolumeSerialNo, 8);
end;

procedure UC_WinSysCommands(Handle: HWND; SysCommand: Integer);
begin
  ReleaseCapture;
  SendMessage(Handle, WM_SYSCOMMAND, SysCommand, 0);
end;

procedure UC_WinSysControlCMD(Ctrl: TWinControl;
                              Top, Right, Bottom, Left: Integer;
                              Drag: Boolean; CanMove: Boolean = True);
var R: TRect;
    P: TPoint;
    CtrlArea: Integer;
begin
  // Формирование внутренней (рабочей области)
  R := Ctrl.ClientRect;
  Inc(R.Left, Left);
  Inc(R.Top, Top);
  Dec(R.Right, Right);
  Dec(R.Bottom, Bottom);
  // Определение позиции курсора
  GetCursorPos(P);
  P := Ctrl.ScreenToClient(P);
  // Определение области под курсором
  if PtInRect(R, P) and CanMove then
    CtrlArea := SC_DragMove

  else if PtInRect(Rect(0, 0, R.Left, R.Top), P) then
    CtrlArea := SC_SizeNW_NWSE
  else if PtInRect(Rect(R.Right, R.Bottom, R.Right + Right, R.Bottom + Bottom), P) then
    CtrlArea := SC_SizeSE_SENW

  else if PtInRect(Rect(R.Left, 0, R.Right, R.Top), P) then
    CtrlArea := SC_SizeN_NS
  else if PtInRect(Rect(R.Left, R.Bottom, R.Right, R.Bottom + Bottom), P) then
    CtrlArea := SC_SizeS_NS

  else if PtInRect(Rect(R.Right, 0, R.Right + Right, R.Top), P) then
    CtrlArea := SC_SizeNE_NESW
  else if PtInRect(Rect(0, R.Bottom, R.Left, R.Bottom + Bottom), P) then
    CtrlArea := SC_SizeSW_SWNE

  else if PtInRect(Rect(R.Right, R.Top, R.Right + Right, R.Bottom), P) then
    CtrlArea := SC_SizeE_EW
  else if PtInRect(Rect(0, R.Top, R.Left, R.Bottom), P) then
    CtrlArea := SC_SizeW_EW
  else begin
    Ctrl.Cursor := crDefault;
    Exit;
  end;
  // Отработка действий
  if Drag then
  begin
    if CanMove or (CtrlArea <> SC_DragMove) then
      UC_WinSysCommands(Ctrl.Handle, CtrlArea);
  end else
  case CtrlArea of
    SC_SizeW_EW, SC_SizeE_EW       : Ctrl.Cursor := crSizeWE;
    SC_SizeN_NS, SC_SizeS_NS       : Ctrl.Cursor := crSizeNS;
    SC_SizeNW_NWSE, SC_SizeSE_SENW : Ctrl.Cursor := crSizeNWSE;
    SC_SizeNE_NESW, SC_SizeSW_SWNE : Ctrl.Cursor := crSizeNESW;
    SC_DragMove                    : Ctrl.Cursor := crSizeAll;
  end;
end;

procedure UC_ChangeCloseButton(Handle: HWND; Enable: Boolean);
var SysMenu: HMenu;
begin
  SysMenu := GetSystemMenu(Handle, False);
  if Enable then
    Windows.EnableMenuItem(SysMenu, SC_CLOSE, MF_ENABLED)
    else
    Windows.EnableMenuItem(SysMenu, SC_CLOSE, MF_DISABLED or MF_GRAYED);
end;

function UC_GetEveryoneGroup: string;
const
  SECURITY_WORLD_SID_AUTHORITY: SID_IDENTIFIER_AUTHORITY = (Value: (0, 0, 0, 0, 0, 1));
  SECURITY_WORLD_RID = $0;
var
  SID : PSID;
  GroupName, DomainName : array[0..30]of Char;
  GroupLen, DomainLen : DWORD;
  peUse : SID_NAME_USE;
begin
  GroupLen := Length(GroupName);
  DomainLen := Length(DomainName);
  // получаем SID для группы EVERYONE
  Win32Check(AllocateAndInitializeSid(SECURITY_WORLD_SID_AUTHORITY,
    1, SECURITY_WORLD_RID, 0, 0, 0, 0, 0, 0, 0, SID));
//  ConvertStringSidToSid("S-1-5-32-544", SID); // Получить SID для группы Администраторы
  LookupAccountSid(nil, SID, @GroupName, GroupLen, @DomainName, DomainLen, peUse);
  Result := GroupName;
end;

function UC_IsKeyPressed(Key: Word): Boolean;
var KeyboardState: TKeyboardState;
begin
  GetKeyboardState(KeyboardState);
  Result := KeyboardState[key] and 128 <> 0;
end;

procedure UC_AnimateInit(Animate: TAnimate; ResName: string;
                   Activate: Boolean = False; Hint: string = '');
begin
  if Assigned(Animate) then
  try
    Animate.ResHandle := 0;
    Animate.ResName   := ResName;
    Animate.ShowHint  := True;
    UC_AnimateSetActive(Animate, Activate, Hint);
  except
    Animate.ResName := '';
    // не удалось подгрузить ресурс!? Да и ладно :) Будем работать без него ;)
  end;
end;

procedure UC_AnimateSetActive(Animate: TAnimate; Active: Boolean; Hint: string = '');
begin
  if Assigned(Animate) and (Animate.ResName <> '') then
  begin
    Animate.Hint    := Hint;
    Animate.Visible := Active;
    Animate.Active  := Active;
  end;
end;

{ TUcShortCut }

constructor TUcShortCut.Create;
var
  ShObject: IUnknown;
begin
  inherited;

  ShObject      := CreateComObject(CLSID_ShellLink);
  fShellLink    := ShObject as IShellLink;
  fPersistFile  := ShObject as IPersistFile;
end;

function TUcShortCut.GetArguments(out Args: string): Boolean;
begin
  SetLength(Args, MAX_PATH);
  Result := ShellLink.GetArguments(PChar(Args), MAX_PATH) = S_OK;
  Args := PChar(Args)
end;

function TUcShortCut.GetDescription(out Description: string): Boolean;
begin
  SetLength(Description, MAX_PATH);
  Result := ShellLink.GetDescription(PChar(Description), MAX_PATH) = S_OK;
  Description := PChar(Description)
end;

function TUcShortCut.GetIconLocation(out IconPath: string;
  out IconIndex: Integer): Boolean;
begin
  SetLength(IconPath, MAX_PATH);
  Result := ShellLink.GetIconLocation(PChar(IconPath), MAX_PATH, IconIndex) = S_OK;
  IconPath := PChar(IconPath);
end;

function TUcShortCut.GetPath(out Path: string): Boolean;
var FindData: TWin32FindData;
begin
  SetLength(Path, MAX_PATH);
  Result := ShellLink.GetPath(PChar(Path), MAX_PATH, FindData, SLGP_RAWPATH) = S_OK;
  Path := PChar(Path);
end;

function TUcShortCut.GetShowCmd(out ShowCmd: Integer): Boolean;
begin
  Result := ShellLink.GetShowCmd(ShowCmd) = S_OK;
end;

function TUcShortCut.Load(pszFileName: string; dwMode: Integer = STGM_READ): Boolean;
begin
{$IFDEF DELPHI_2009_UP}
  Result := fPersistFile.Load(PChar(pszFileName), dwMode) = S_OK;
{$ELSE}
  Result := fPersistFile.Load(StringToOleStr(pszFileName), dwMode) = S_OK;
{$ENDIF}

end;

function TUcShortCut.Save(pszFileName: string; fRemember: BOOL = False): Boolean;
begin
{$IFDEF DELPHI_2009_UP}
  Result := fPersistFile.Save(PWideChar(pszFileName), fRemember) = S_OK;
{$ELSE}
  Result := fPersistFile.Save(StringToOleStr(pszFileName), fRemember) = S_OK;
{$ENDIF}
end;

{$IFDEF DELPHI_2009_UP}
{ TUcTaskbarList }

constructor TUcTaskbarList.Create;
var iObj: IUnknown;
begin
  try
    iObj := CreateComObject(CLSID_TaskBarList);

    if iObj.QueryInterface(IID_ITaskbarList, fTaskbarList) = E_NOINTERFACE then
      fTaskbarList := nil;

    if Assigned(fTaskbarList) and (fTaskbarList.HrInit = S_OK) then
    begin
      if iObj.QueryInterface(IID_ITaskbarList2, fTaskbarList2) = E_NOINTERFACE then
        fTaskbarList2 := nil;

      if iObj.QueryInterface(IID_ITaskbarList3, fTaskbarList3) = E_NOINTERFACE then
        fTaskbarList3 := nil;

      if iObj.QueryInterface(IID_ITaskbarList4, fTaskbarList4) = E_NOINTERFACE then
        fTaskbarList4 := nil;
    end else
      ClearTaskbarLists;
  except
    fTaskbarList  := nil;
    fTaskbarList2 := nil;
    fTaskbarList3 := nil;
    fTaskbarList4 := nil;
  end;
end;

destructor TUcTaskbarList.Destroy;
begin
  ClearTaskbarLists;
  inherited;
end;

procedure TUcTaskbarList.ClearTaskbarLists;
begin
  fTaskbarList  := nil;
  fTaskbarList2 := nil;
  fTaskbarList3 := nil;
  fTaskbarList4 := nil;
end;

{ TUcTaskbarListProgress }

constructor TUcTaskbarListProgress.Create;
begin
  inherited;
  fTBL := TUcTaskbarList.Create;
  FShowProgressOnTaskbar := True;
end;

destructor TUcTaskbarListProgress.Destroy;
begin
  ShowProgressOnTaskbar := False;
  fTBL.Free;
  inherited;
end;

procedure TUcTaskbarListProgress.Init(WindowHandle: HWND;
  ProgressBar: TProgressBar);
begin
  fWinHandle := WindowHandle;
  fPrBar := nil;
  if Assigned(ProgressBar) then
  begin
    FState   := ProgressBar.State;
    FStyle   := ProgressBar.Style;
    Max      := ProgressBar.Max;
    Min      := ProgressBar.Min;
    Position := ProgressBar.Position;

    UpdateTaskbarListProgressState;

    fPrBar   := ProgressBar;
  end;
end;

procedure TUcTaskbarListProgress.InitDef(ProgressBar: TProgressBar);
begin
  if Assigned(Application.MainForm) then
    Init(Application.MainForm.Handle, ProgressBar)
    else
    Init(Application.Handle, ProgressBar);
end;

procedure TUcTaskbarListProgress.SetMax(const Value: Integer);
begin
  if FMax <> Value then
  begin
    FMax := Value;
    if Assigned(fPrBar) then fPrBar.Max := FMax;
    UpdateTaskbarListProgress;
  end;
end;

procedure TUcTaskbarListProgress.SetMin(const Value: Integer);
begin
  if FMin <> Value then
  begin
    FMin := Value;
    if Assigned(fPrBar) then fPrBar.Min := FMin;
    UpdateTaskbarListProgress;
  end;
end;

procedure TUcTaskbarListProgress.SetPosition(const Value: Integer);
begin
  if FPosition <> Value then
  begin
    FPosition := Value;
    if Assigned(fPrBar) then fPrBar.Position := FPosition;
    UpdateTaskbarListProgress;
  end;
end;

procedure TUcTaskbarListProgress.SetProgressState(const Value: Integer);
begin
  if FProgressState <> Value then
  begin
    FProgressState := Value;
    if Assigned(fTBL.TaskbarList3) then
      try                                   // Вероятны ошибки из-за нехватки библиотек
        fTBL.TaskbarList3.SetProgressState(fWinHandle, FProgressState);
      except
        //
      end;
    UpdateTaskbarListProgress;
  end;
  if Assigned(fPrBar) then fPrBar.Position := FPosition;
end;

procedure TUcTaskbarListProgress.SetShowProgressOnTaskbar(const Value: Boolean);
begin
  if FShowProgressOnTaskbar <> Value then
  begin
    FShowProgressOnTaskbar := Value;
    UpdateTaskbarListProgressState;
  end;
end;

procedure TUcTaskbarListProgress.SetState(const Value: TProgressBarState);
begin
  FState := Value;
  if Assigned(fPrBar) then fPrBar.State := FState;
  UpdateTaskbarListProgressState;
end;

procedure TUcTaskbarListProgress.SetStyle(const Value: TProgressBarStyle);
begin
  FStyle := Value;
  if Assigned(fPrBar) then fPrBar.Style := FStyle;
  UpdateTaskbarListProgressState;
end;

procedure TUcTaskbarListProgress.UpdateTaskbarListProgress;
begin
  if FShowProgressOnTaskbar and Assigned(fTBL.TaskbarList3) and
    ((FStyle = pbstNormal) or (FState <> pbsNormal)) then
    try                                     // Вероятны ошибки из-за нехватки библиотек
      fTBL.TaskbarList3.SetProgressValue(fWinHandle, FPosition - FMin, FMax - FMin);
    except
      //
    end;
end;

procedure TUcTaskbarListProgress.UpdateTaskbarListProgressState;
begin
  if not FShowProgressOnTaskbar then ProgressState := TBPF_NOPROGRESS
  else if FState = pbsError     then ProgressState := TBPF_ERROR
  else if FState = pbsPaused    then ProgressState := TBPF_PAUSED
  else if FStyle = pbstMarquee  then ProgressState := TBPF_INDETERMINATE
  else if FState = pbsNormal    then ProgressState := TBPF_NORMAL
  else ProgressState := TBPF_NOPROGRESS;
end;
{$ENDIF}

initialization

finalization
  if Assigned(Mutexes_) then
  begin
    while Mutexes_.Count > 0 do
      UC_DeleteMutex(Mutexes_[0]);
    Mutexes_.Free;
  end;
end.
