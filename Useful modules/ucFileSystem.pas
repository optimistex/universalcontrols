// Версия - 26.03.2014
unit ucFileSystem;
{$include ..\delphi_ver.inc}

interface

uses Windows, Messages, SysUtils, StrUtils, ShellAPI, Forms, AclAPI, AccCtrl,
     Dialogs, Classes, Controls, ucWindows, ucTypes;

Const
  fviCompanyNameTxt      = 'Название компании';
  fviFileDescriptionTxt  = 'Описание Файла';
  fviFileVersionTxt      = 'Версия Файла';
  fviInternalNameTxt     = 'Внутреннее Название';
  fviLegalCopyrightTxt   = 'Юридическое Авторское право';
  fviLegalTrademarksTxt  = 'Юридические Торговые марки';
  fviOriginalFilenameTxt = 'Оригинальное Имя файла';
  fviProductNameTxt      = 'Название продукта';
  fviProductVersionTxt   = 'Версия Продукта';
  fviCommentsTxt         = 'Комментарии';

type
  TUcFileVersionInfo = class
  private
    FFilename         : TFileName;
    FVersionInfoSize  : cardinal;
    FLanguageInfo     : string;
    FCompanyName      : string;  //Название компании
    FFileDescription  : string;  //Описание Файла
    FFileVersion      : string;  //Версия Файла
    FInternalName     : string;  //Внутреннее Название
    FLegalCopyright   : string;  //Юридическое Авторское право
    FLegalTrademarks  : string;  //Юридические Торговые марки
    FOriginalFilename : string;  //Оригинальное Имя файла
    FProductName      : string;  //Название продукта
    FProductVersion   : string;  //Версия Продукта
    FComments         : string;  //Комментарии
  protected
    { Protected declarations }
    procedure ClearAll;
  public
    { Public declarations }
    constructor Create(iFileName: string = '');
    function LoadFromFile(iFileName: string): Boolean;
    function TotalInformation: string;

    property FileName         : TFileName read FFilename;
    property LanguageInfo     : string    read FLanguageInfo;
    property VersionInfoSize  : cardinal  read FVersionInfoSize;
    property CompanyName      : string    read FCompanyName;
    property FileDescription  : string    read FFileDescription;
    property FileVersion      : string    read FFileVersion;
    property InternalName     : string    read FInternalName;
    property LegalCopyright   : string    read FLegalCopyright;
    property LegalTrademarks  : string    read FLegalTrademarks;
    property OriginalFilename : string    read FOriginalFilename;
    property ProductName      : string    read FProductName;
    property ProductVersion   : string    read FProductVersion;
    property Comments         : string    read FComments;
  end;

  //---Копирование папки с ее содержимым---
  function UC_CopyFolder(SourceDir, TargetDir: string;
                         FeedBack: TCopyFolderFeedBack = nil;
                         Silent: Boolean = False): Boolean; //скопировать директорию

  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Выполнение стандартных операций с файлами средствами
  ///	винды</summary>
  ///	<example>UC_SHFileOperation(0, DirTemp, '', FO_DELETE, FOF_NOCONFIRMMKDIR
  ///	or FOF_ALLOWUNDO);</example>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  function UC_SHFileOperation(Handle: HWND; const Src, Dest: string;
                              wFunc, fFlags: Cardinal): Boolean;
  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Копирование файлов средствами винды.</summary>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  function UC_SHCopyFiles(Handle: HWND; const Src, Dest: string;
                          SilentMode: Boolean; ShowErrors: Boolean = True): Boolean;
  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Перемещение файлов средствами винды.</summary>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  function UC_SHMoveFiles(Handle: HWND; const Src, Dest: string; SilentMode: Boolean;
                          ShowErrors: Boolean = True): Boolean;

  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Удаление файлов средствами винды. AllowUndo - Поместить файлы в
  ///	корзину!</summary>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  function UC_SHDeleteFiles(Handle: HWND; const Src: string; AllowUndo, SilentMode: Boolean;
                            ShowErrors: Boolean = True): Boolean;

  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Удаление файла с ожиданием. Раз в Delay миллисекунд производится
  ///	попытка удаления файла. И так до успеха удаления или истечения
  ///	таймаута.</summary>
  ///	<param name="FileName">Имя удаляемого файла.</param>
  ///	<param name="TimeOut">Таймаут на удаление</param>
  ///	<param name="Delay">Задержка между попытками удаления</param>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  procedure UC_DeleteFileByTimeout(FileName: string; TimeOut: Integer = 10000;
                                  Delay: Integer = 1000);

  // Удаление папки с содержимым
  function UC_RemoveDir(DirName: String; OnlyClear: Boolean = False): Boolean;

  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>
  ///	  <para>Удаление пустых папок (не содержащих файлов) в переданном
  ///	  пути.</para>
  ///	  <para>Сама папка так же удаляется если в ней нет останется файлов и
  ///	  подпапок</para>
  ///	</summary>
  ///	<param name="DirName">Путь к корневой папке из которой нужно удалить все
  ///	пустые папки.</param>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  function UC_RemoveEmptyDir(DirName: string): Boolean;
  //---Информация о файле---
  function UC_GetExeFileVersionInfo: TUcFileVersionInfo;

  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Получение информации о файле в структуре TFileInfo.</summary>
  ///	<param name="FileName">Путь к файлу</param>
  ///	<param name="FileInfo">Информация о файле</param>
  ///	<example>....... var fi: TFileInfo; .......
  ///	GetFileInfo(PChar(Application.ExeName), @fi); .......</example>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  procedure UC_GetFileInfo(FileName: PChar; FileInfo: PFileInfo);
  function UC_GetFileSize(FileName: string): Int64;
  //---Размер папки---
  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Получение размера папки</summary>
  ///	<param name="Dir">Путь к папке</param>
  ///	<param name="IncludeSubDirs">Учитывать размеры вложенных папок</param>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  function UC_GetDirSize(Dir: string; IncludeSubDirs: Boolean = true): Int64;
  //---Информация о диске---
  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Получить размер диска</summary>
  ///	<param name="TheDrive">Буква диска</param>
  ///	<param name="TotalBytes">Общий объем</param>
  ///	<param name="TotalFree">Свободное место</param>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  procedure UC_GetDriveSize(TheDrive: PChar; var TotalBytes, TotalFree: double);
  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Обработка перетаскивания файлов в приложение</summary>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  function UC_ProcessingDragDrop(var Msg: TMessage): TStringList;

  // Управление правами доступа к файлам/папкам
  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Изменение таблиц управления доступом (ACL) к файлам</summary>
  ///	<param name="FileObject">Путь к файлу/папке на которые назначаются
  ///	права</param>
  ///	<param name="UserName">Имя пользователя или группы пользователей для
  ///	которых назначаются права</param>
  ///	<param name="RightsMask">Набор прав (GENERIC_READ ... GENERIC_All) из
  ///	модуля Windows</param>
  ///	<param name="Inherit">Тип наследования
  ///	(SUB_CONTAINERS_AND_OBJECTS_INHERIT) из модуля AccCtrl</param>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  function UC_SetFileAccessRights(FileObject, UserName: String;
                                  RightsMask, Inherit: Cardinal): Boolean;

  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Ожидание освобождения занятого файла</summary>
  ///	<param name="FileName">Путь к файлу/папке</param>
  ///	<param name="Milliseconds">Время ожидания в миллисекундах</param>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  function UC_WaitWhileFileIsBusy(FileName: string; Milliseconds: DWORD = INFINITE): Boolean;

  //**

  // Устаревшие функции
  function GetWinVar(VarName: string): string; deprecated {$IFDEF DELPHI_2009_UP}'use UC_GetEnvironmentVariable(Path, True) from ucWindows'{$ENDIF};
  procedure ClearFolder(Path: string); deprecated {$IFDEF DELPHI_2009_UP}'use UC_RemoveDir(Path, True)'{$ENDIF};
  function DeleteDir(DirName: String; OnlyClear: Boolean = False): Boolean; deprecated {$IFDEF DELPHI_2009_UP}'use UC_RemoveDir(Path, True)'{$ENDIF};
  function CopyWinFolder(Handle: HWND; const FromFolder, ToFolder: string;
                         SilentMode: Boolean): Boolean; deprecated {$IFDEF DELPHI_2009_UP}'use UC_SHCopyFiles'{$ENDIF};
  function CopyFolder(SourceDir, TargetDir: string;
                      FeedBack: TCopyFolderFeedBack = nil;
                      Silent: Boolean = False): Boolean; deprecated {$IFDEF DELPHI_2009_UP}'use UC_CopyFolder'{$ENDIF};
  procedure GetFileInfo(FileName: PChar; FileInfo: PFileInfo); deprecated {$IFDEF DELPHI_2009_UP}'use UC_GetFileInfo'{$ENDIF};
  function GetExeFileVersionInfo: TUcFileVersionInfo; deprecated {$IFDEF DELPHI_2009_UP}'use UC_GetExeFileVersionInfo'{$ENDIF};
  function GetFileSize(FileName: string): Int64; deprecated {$IFDEF DELPHI_2009_UP}'use UC_GetFileSize'{$ENDIF};
  function GetDirSize(Dir: string; IncludeSubDirs: Boolean = true): Int64; deprecated {$IFDEF DELPHI_2009_UP}'use UC_GetDirSize'{$ENDIF};
  procedure GetDriveSize(TheDrive: PChar; var TotalBytes, TotalFree: double); deprecated {$IFDEF DELPHI_2009_UP}'use UC_GetDriveSize'{$ENDIF};
  function ProcessingDragDrop(var Msg: TMessage): TStringList; deprecated {$IFDEF DELPHI_2009_UP}'use UC_ProcessingDragDrop'{$ENDIF};

  //**

implementation

var
    ExeFileVersionInfo: TUcFileVersionInfo = nil;

{ TUcFileVersionInfo }
constructor TUcFileVersionInfo.Create(iFileName: string = '');
begin
  inherited Create;
  ClearAll;
  LoadFromFile(iFileName);
end;

procedure TUcFileVersionInfo.ClearAll;
begin
  FFilename         := '';
  FVersionInfoSize  := 0;
  FLanguageInfo     := '';
  FCompanyName      := '';  //Название компании
  FFileDescription  := '';  //Описание Файла
  FFileVersion      := '';  //Версия Файла
  FInternalName     := '';  //Внутреннее Название
  FLegalCopyright   := '';  //Юридическое Авторское право
  FLegalTrademarks  := '';  //Юридические Торговые марки
  FOriginalFilename := '';  //Оригинальное Имя файла
  FProductName      := '';  //Название продукта
  FProductVersion   := '';  //Версия Продукта
  FComments         := '';  //Комментарии
end;

function TUcFileVersionInfo.LoadFromFile(iFileName: string): Boolean;
type TDWord = record
        HWord: Word;
        LWord: Word;
     end;

var VISize, BuffSize:   cardinal;
    VIBuff, trans:   pointer;
    str: pchar;
    rec: TDWord;

  function GetStringValue(const From: string): string;
  begin
    VerQueryValue(VIBuff, pchar('\StringFileInfo\'+LanguageInfo+'\'+From),
                  pointer(str), BuffSize);
    Result := IfThen(BuffSize > 0, str, 'н/д');
  end;

begin
  VIBuff := nil;
  FFilename := iFileName;
  Result    := FileExists(iFileName);
  if Result then
  begin
    VISize := GetFileVersionInfoSize(pchar(iFilename),BuffSize);
    Result := VISize > 0;
    if Result then
    begin
      VIBuff := AllocMem(VISize);
      GetFileVersionInfo(pchar(iFilename),cardinal(0),VISize,VIBuff);
      VerQueryValue(VIBuff,'\VarFileInfo\Translation',Trans,BuffSize);
      Result := BuffSize >= 4;
      if Result then
      begin
        ClearAll;
        System.Move(Trans^, Pointer(rec), 4);

        FLanguageInfo     := IntToHex(rec.HWord, 4) + IntToHex(rec.LWord, 4);
        FVersionInfoSize  := VISize;
        FCompanyName      := GetStringValue('CompanyName');
        FFileDescription  := GetStringValue('FileDescription');
        FFileVersion      := GetStringValue('FileVersion');
        FInternalName     := GetStringValue('InternalName');
        FLegalCopyright   := GetStringValue('LegalCopyright');
        FLegalTrademarks  := GetStringValue('LegalTrademarks');
        FOriginalFilename := GetStringValue('OriginalFilename');
        FProductName      := GetStringValue('ProductName');
        FProductVersion   := GetStringValue('ProductVersion');
        FComments         := GetStringValue('Comments');
      end;
      FreeMem(VIBuff,VISize);
    end;
  end
  else begin
    FVersionInfoSize  := 0;
    FLanguageInfo     := '';
    FCompanyName      := '';  //Название компании
    FFileDescription  := '';  //Описание Файла
    FFileVersion      := '';  //Версия Файла
    FInternalName     := '';  //Внутреннее Название
    FLegalCopyright   := '';  //Юридическое Авторское право
    FLegalTrademarks  := '';  //Юридические Торговые марки
    FOriginalFilename := '';  //Оригинальное Имя файла
    FProductName      := '';  //Название продукта
    FProductVersion   := '';  //Версия Продукта
    FComments         := '';  //Комментарии
  end;
end;

function TUcFileVersionInfo.TotalInformation: string;
begin
  Result :=
            fviCompanyNameTxt      + ': ' +  CompanyName      + #13#10+
            fviFileDescriptionTxt  + ': ' +  FileDescription  + #13#10+
            fviFileVersionTxt      + ': ' +  FileVersion      + #13#10+
            fviInternalNameTxt     + ': ' +  InternalName     + #13#10+
            fviLegalCopyrightTxt   + ': ' +  LegalCopyright   + #13#10+
            fviLegalTrademarksTxt  + ': ' +  LegalTrademarks  + #13#10+
            fviOriginalFilenameTxt + ': ' +  OriginalFilename + #13#10+
            fviProductNameTxt      + ': ' +  ProductName      + #13#10+
            fviProductVersionTxt   + ': ' +  ProductVersion   + #13#10+
            fviCommentsTxt         + ': ' +  Comments;
end;
{* TUcFileVersionInfo *}
// Удаление папки с содержимым
function UC_RemoveDir(DirName: String; OnlyClear: Boolean = False): Boolean;
var sr: TSearchRec;
begin
  Result := True;
  DirName := IncludeTrailingBackslash(DirName);
  if FindFirst(DirName + '*.*', faAnyFile, sr) = 0 then
  try
    repeat
      if (sr.Name <> '..') and (sr.Name <> '.') then
      begin
        if sr.Attr = faDirectory then
          Result := UC_RemoveDir(DirName + sr.Name) and Result
          else
          Result := DeleteFile(DirName + sr.Name) and Result;
      end;
    until FindNext(sr) <> 0;
  finally
    FindClose(sr);
  end;
  if not OnlyClear then
    Result := RemoveDir(ExcludeTrailingBackslash(DirName)) and Result;
end;

function UC_RemoveEmptyDir(DirName: string): Boolean;
var SR: TSearchRec;
begin
  DirName := IncludeTrailingBackslash(DirName);
  if FindFirst(DirName + '*.*', faAnyFile, SR) = 0 then
  try
    repeat
      if (SR.Name <> '..') and (SR.Name <> '.') and (sr.Attr = faDirectory) then
        UC_RemoveEmptyDir(DirName + SR.Name);
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
  Result := not DirectoryExists(DirName) or RemoveDir(DirName);
end;

function DeleteDir(DirName: String; OnlyClear: Boolean = False): Boolean;
begin
  Result := UC_RemoveDir(DirName, OnlyClear);
end;

procedure ClearFolder(Path: string);
begin
  UC_RemoveDir(Path, True);
end;

function UC_GetExeFileVersionInfo: TUcFileVersionInfo;
begin
  if not Assigned(ExeFileVersionInfo) then
    ExeFileVersionInfo := TUcFileVersionInfo.Create(Application.ExeName);
  Result := ExeFileVersionInfo;
end;

function GetExeFileVersionInfo: TUcFileVersionInfo;
begin
  Result := UC_GetExeFileVersionInfo;
end;

procedure UC_GetFileInfo(FileName: PChar;      // Файл
                         FileInfo: PFileInfo); // Информация
var fi: TWin32FileAttributeData;
    st: TSystemTime;
begin
  if GetFileAttributesEx(FileName, GetFileExInfoStandard,@fi) then
  begin
    //----Преобразование даты---
      FileTimeToLocalFileTime(fi.ftCreationTime,fi.ftCreationTime);
      FileTimeToLocalFileTime(fi.ftLastAccessTime,fi.ftLastAccessTime);
      FileTimeToLocalFileTime(fi.ftLastWriteTime,fi.ftLastWriteTime);
    //**
    FileInfo^.FileAttributes := fi.dwFileAttributes;

    FileTimeToSystemTime(fi.ftCreationTime,st);
    FileInfo^.CreationTime  := SystemTimeToDateTime(st); //<<<  дата и время
    FileTimeToSystemTime(fi.ftLastAccessTime,st);
    FileInfo^.LastAccessTime  := SystemTimeToDateTime(st); //<<<  дата и время
    FileTimeToSystemTime(fi.ftLastWriteTime,st);
    FileInfo^.LastWriteTime  := SystemTimeToDateTime(st); //<<<  дата и время

    FileInfo^.Size           := fi.nFileSizeLow;
  end else
    FillChar(FileInfo^, SizeOf(FileInfo^), 0);
end;

procedure GetFileInfo(FileName: PChar; FileInfo: PFileInfo);
begin
  UC_GetFileInfo(FileName, FileInfo);
end;

function UC_GetFileSize(FileName: string): Int64;
var fi: TFileInfo;
begin
  UC_GetFileInfo(PChar(FileName), @fi);
  Result := fi.Size;
end;

function GetFileSize(FileName: string): Int64;
begin
  Result := UC_GetFileSize(FileName);
end;
  //---Размер папки---
function UC_GetDirSize(Dir: string;      // Папка
                       IncludeSubDirs: Boolean = true): Int64; overload; // Получить размер подпапок
var
  SearchRec: TSearchRec;
  FindResult: Integer;
begin
  Result := 0;
  Dir := IncludeTrailingBackslash(Dir);
  FindResult := FindFirst(Dir + '*.*', faAnyFile, SearchRec);
  try
    while FindResult = 0 do
      with SearchRec do
      begin
        if (Attr and faDirectory) <> 0 then
        begin
          if IncludeSubDirs and (Name <> '.') and (Name <> '..') then
            Result := Result + UC_GetDirSize(Dir + Name, IncludeSubDirs);
        end else
          Result := Result + Cardinal(Size);
        FindResult := FindNext(SearchRec);
      end;
  finally
    FindClose(SearchRec);
  end;
end;

function GetDirSize(Dir: string; IncludeSubDirs: Boolean = true): Int64;
begin
  Result := UC_GetDirSize(Dir, IncludeSubDirs);
end;

  //---Информация о диске---
procedure UC_GetDriveSize(TheDrive: PChar;
                          var TotalBytes, TotalFree: double);
var AvailToCall, TheSize: TLargeInteger;
begin
  GetDiskFreeSpaceEx(TheDrive, AvailToCall, TheSize, nil);
{$IFOPT Q+}
{$DEFINE TURNOVERFLOWON}
{$Q-}
{$ENDIF}
  if TheSize >= 0 then TotalBytes := TheSize
  else if TheSize = -1 then begin
    TotalBytes := $7FFFFFFF;
    TotalBytes := TotalBytes * 2;
    TotalBytes := TotalBytes + 1;
  end else begin
    TotalBytes := $7FFFFFFF;
    TotalBytes := TotalBytes + abs($7FFFFFFF - TheSize);
  end;
  if AvailToCall >= 0 then TotalFree := AvailToCall
  else if AvailToCall = -1 then begin
    TotalFree := $7FFFFFFF;
    TotalFree := TotalFree * 2;
    TotalFree := TotalFree + 1;
  end
  else begin
    TotalFree := $7FFFFFFF;
    TotalFree := TotalFree + abs($7FFFFFFF - AvailToCall);
  end;
end;

procedure GetDriveSize(TheDrive: PChar; var TotalBytes, TotalFree: double);
begin
  UC_GetDriveSize(TheDrive, TotalBytes, TotalFree);
end;

function UC_ProcessingDragDrop(var Msg: TMessage): TStringList;
var
  i, amount, size: integer;
  Filename: PChar;
begin
  Result := TStringList.Create;
  //---
  Amount := DragQueryFile(Msg.WParam, $FFFFFFFF, nil, 255);
  for i := 0 to (Amount - 1) do
  begin
    size := DragQueryFile(Msg.WParam, i, nil, 0) + 1;
    Filename := StrAlloc(size);
    DragQueryFile(Msg.WParam, i, Filename, size);
    Result.add(StrPas(Filename));
    StrDispose(Filename);
  end;
  DragFinish(Msg.WParam);
end;

function UC_SetFileAccessRights(FileObject, UserName: String;
                                RightsMask, Inherit: Cardinal): Boolean;
var
  psd            : PSECURITY_DESCRIPTOR;
  dwSize         : Cardinal;
  bDaclPresent, bDaclDefaulted: Bool;
  OldAcl, NewAcl : PACL;
  sd             : SECURITY_DESCRIPTOR;
  ea             : EXPLICIT_ACCESS;
begin
  Result := False;
  if WIN32Platform <> VER_PLATFORM_WIN32_NT then Exit;
  psd := nil;
  NewAcl := nil;
  bDaclDefaulted := True;
  if not GetFileSecurity(PChar(FileObject), DACL_SECURITY_INFORMATION,
                         Pointer(1), 0, dwSize) and
    (GetLastError = ERROR_INSUFFICIENT_BUFFER) then
  try
    psd := HeapAlloc(GetProcessHeap, 8, dwSize);
    if psd <> nil then
    begin
      BuildExplicitAccessWithName(@ea, PChar(UserName), RightsMask, SET_ACCESS, Inherit);

      Result := GetFileSecurity(PChar(FileObject), DACL_SECURITY_INFORMATION, psd, dwSize, dwSize) and
                GetSecurityDescriptorDacl(psd, bDaclPresent, OldAcl, bDaclDefaulted) and
                (SetEntriesInAcl(1, @ea, OldAcl, NewAcl) = ERROR_SUCCESS) and
                InitializeSecurityDescriptor(@sd, SECURITY_DESCRIPTOR_REVISION) and
                SetSecurityDescriptorDacl(@sd, True, NewAcl, False) and
                SetFileSecurity(PChar(FileObject), DACL_SECURITY_INFORMATION, @sd);
    end;
  finally
    if NewAcl <> nil then LocalFree(HLocal(NewAcl));
    if psd <> nil    then HeapFree(GetProcessHeap, 0, psd);
  end;
end;

function ProcessingDragDrop(var Msg: TMessage): TStringList;
begin
  Result := UC_ProcessingDragDrop(Msg);
end;

function GetWinVar(VarName: string): string;
begin
  Result := UC_GetEnvironmentVariable(VarName);
end;

function UC_CopyFolder(SourceDir, TargetDir: string;
                       FeedBack: TCopyFolderFeedBack = nil;
                       Silent: Boolean = False): Boolean; //скопировать директорию
var
  FileListSource, FileListDest: TStringList;

  function ScanFolder(sfSourceDir, sfTargetDir: string): Boolean;
  var
    SR: TSearchRec;
    I: Integer;
  begin
    Result := False;
    sfSourceDir := IncludeTrailingBackslash(sfSourceDir);
    sfTargetDir := IncludeTrailingBackslash(sfTargetDir);
    if Assigned(FeedBack) then FeedBack(sfSourceDir, 0, 0);

    if not DirectoryExists(sfSourceDir) then Exit;
    I := FindFirst(sfSourceDir + '*.*', faAnyFile, SR);
    try
      while I = 0 do
      begin
        if not ((SR.Name = '.') or (SR.Name = '..')) then
        begin
          if SR.Attr and faDirectory <> 0 then
            Result := ScanFolder(sfSourceDir + SR.Name, sfTargetDir + SR.NAME)
          else
          begin
            FileListSource.Add(sfSourceDir + SR.Name);
            FileListDest.Add(sfTargetDir + SR.NAME);
            Result := True;
          end;
        end;
        I := FindNext(SR);
      end;
    finally
      SysUtils.FindClose(SR);
    end;
  end;
var
    MsgResult: Integer;
    i: Integer;
    s: string;
    Success: Boolean;
begin
  Result := (SourceDir <> '')and(TargetDir <> '');
  if not Result then Exit;
  FileListSource := TStringList.Create;
  FileListDest   := TStringList.Create;
  try
    ScanFolder(SourceDir, TargetDir);
    //Result := (FileListSource.Count > 0);
    if not Result then Exit;
    //-------------
    i := 0;
    while i < FileListSource.Count do
    begin
      if Assigned(FeedBack) then FeedBack(FileListSource[i], FileListSource.Count, i);
      s := ExtractFilePath(FileListDest.Strings[i]);
      if not DirectoryExists(s) then ForceDirectories(s);

      Success := CopyFile(Pchar(FileListSource.Strings[i]),
                          Pchar(FileListDest.Strings[i]), False);
      Result := Success and Result;
      if not Success then
      begin
        if not Silent then
          MsgResult := MessageDlg('Не удается скопировать файл'#13#10+
                       '"' + FileListSource[i] + '"', mtWarning,
                       [mbIgnore, mbRetry, mbCancel], 0)
          else
          MsgResult := mrIgnore;
        case MsgResult of
          mrIgnore  : begin
                        inc(i);
                        Continue;
                      end;
          mrRetry   : Continue;
          mrCancel  : Exit;
          else Exit;
        end;
      end;
      Inc(i);
    end;
    //**
  finally
    FileListSource.Free;
    FileListDest.Free;
  end;
end;

function CopyFolder(SourceDir, TargetDir: string;
                    FeedBack: TCopyFolderFeedBack = nil;
                    Silent: Boolean = False): Boolean;
begin
  Result := UC_CopyFolder(SourceDir, TargetDir, FeedBack, Silent);
end;

function UC_SHFileOperation(Handle: HWND; const Src, Dest: string;
                            wFunc, fFlags: Cardinal): Boolean;

  function DestIsChildSrc: Boolean;
  var Src_: string;
  begin
    Src_ := ExcludeTrailingBackslash(Src);
    Result := Src_ = Copy(Dest, 1, Length(Src_));
  end;

var
  Fo: TSHFileOpStruct;
  buffer: array[0..4096] of char;
begin
  FillChar(Buffer, sizeof(Buffer), #0);
  StrECopy(@buffer, PChar(ExcludeTrailingBackslash(Src))); //директория, которую мы хотим скопировать
  FillChar(Fo, sizeof(Fo), #0);
  Fo.Wnd := Handle;
  Fo.wFunc := wFunc;
  Fo.pFrom := @Buffer;
  Fo.pTo := PChar(Dest + #0#0); //куда будет скопирована директория
  Fo.fFlags := fFlags;
  Result := (SHFileOperation(Fo) = 0) and (not DestIsChildSrc);
  Result := Result and (not Fo.fAnyOperationsAborted);
end;

function UC_SHCopyFiles(Handle: HWND; const Src, Dest: string;
                        SilentMode: Boolean; ShowErrors: Boolean = True): Boolean;
const SilentMode_: array[Boolean] of Word = (0, FOF_NOCONFIRMATION);
      ShowErrors_: array[Boolean] of Word = (FOF_NOERRORUI, 0);
begin
  Result := UC_SHFileOperation(Handle, Src, Dest, FO_COPY,
        FOF_NOCONFIRMMKDIR or FOF_ALLOWUNDO or
        SilentMode_[SilentMode] or ShowErrors_[ShowErrors]);
end;

function UC_SHMoveFiles(Handle: HWND; const Src, Dest: string; SilentMode: Boolean;
                        ShowErrors: Boolean = True): Boolean;
const SilentMode_: array[Boolean] of Word = (0, FOF_NOCONFIRMATION);
      ShowErrors_: array[Boolean] of Word = (FOF_NOERRORUI, 0);
begin
  Result := UC_SHFileOperation(Handle, Src, Dest, FO_MOVE,
        FOF_NOCONFIRMMKDIR or FOF_ALLOWUNDO or
        SilentMode_[SilentMode] or ShowErrors_[ShowErrors]);
end;

function UC_SHDeleteFiles(Handle: HWND; const Src: string; AllowUndo, SilentMode: Boolean;
                          ShowErrors: Boolean = True): Boolean;
const AllowUndo_: array[Boolean] of Word = (0, FOF_ALLOWUNDO);
      SilentMode_: array[Boolean] of Word = (0, FOF_NOCONFIRMATION);
      ShowErrors_: array[Boolean] of Word = (FOF_NOERRORUI, 0);
begin
  Result := UC_SHFileOperation(Handle, Src, '', FO_DELETE,
        FOF_NOCONFIRMMKDIR or AllowUndo_[AllowUndo] or
        SilentMode_[SilentMode] or ShowErrors_[ShowErrors]);
end;

procedure UC_DeleteFileByTimeout(FileName: string; TimeOut: Integer = 10000;
                                Delay: Integer = 1000);
var SaveTime: TDateTime;
begin
    SaveTime := Now;
    while (FileExists(FileName) or DirectoryExists(FileName)) and
          ((Now - SaveTime) * 24 * 60 * 60 * 1000 < TimeOut) do
      if not UC_SHFileOperation(0, FileName, '', FO_DELETE, FOF_NOCONFIRMMKDIR or
                                          FOF_NOCONFIRMATION or FOF_NOERRORUI) then
        Sleep(Delay);
end;

function CopyWinFolder(Handle: HWND; const FromFolder, ToFolder: string;
                       SilentMode: Boolean): Boolean;
begin
  Result := UC_SHCopyFiles(Handle, FromFolder, ToFolder, SilentMode);
end;

function UC_WaitWhileFileIsBusy(FileName: string; Milliseconds: DWORD =
    INFINITE): Boolean;
var tStart: TDateTime;
begin
  tStart := Now;
  Result := False;
  while not Result and FileExists(FileName) and
        ((Now - tStart) * 24 * 60 * 60 * 1000 < Milliseconds) do
  try
    Sleep(1000);
    TFileStream.Create(FileName, fmOpenReadWrite).Free;
    Result := True;
  except
  end;
end;

initialization

finalization
  ExeFileVersionInfo.Free;

end.
