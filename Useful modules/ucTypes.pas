// Версия - 08.05.2013
unit ucTypes;
{$include ..\delphi_ver.inc}

interface
uses Windows, ShlObj, Graphics;

const CrLf = #13#10; // Возврат и перевод каретки
  // Системные команды управления окном (мышью)
  SC_SizeW_EW     = $F001;
  SC_SizeE_EW     = $F002;
  SC_SizeN_NS     = $F003;
  SC_SizeNW_NWSE  = $F004;
  SC_SizeNE_NESW  = $F005;
  SC_SizeS_NS     = $F006;
  SC_SizeSW_SWNE  = $F007;
  SC_SizeSE_SENW  = $F008;
  SC_DragMove     = $F012;


type
  { Простые типы }
{$IFNDEF DELPHI_2009_UP}
  RawByteString = type AnsiString;
{$ENDIF}
  TUcLastSQL = record
    Message: string;
    SQLCode: integer;
  end;

  TFileInfo = record
    FileAttributes: DWORD;      // faReadOnly, faHidden, faSysFile, faVolumeID, faDirectory, faArchive, faSymLink, faAnyFile
    CreationTime  : TDateTime;  // Дата создания файла
    LastAccessTime: TDateTime;  // Дата последнего доступа к файлу
    LastWriteTime : TDateTime;  // Дата изменения файла
    Size          : int64;      // Размер файла
  end;
  PFileInfo = ^TFileInfo;

  TButtonState = (btsUp, btsDisabled, btsDown, btsHot);
  TButtonStyle = (bsImaged, bsClassic);

  TWorkState = (wsBegin, wsEnd, wsStop, wsProgress, wsText);
  TWorkAction =(waBeginning, waFinalization, waWorking);

  {$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
  ///	<summary>Определяет тип загрузки данных из БД</summary>
  ///	<param name="iolmPreLoad">Частичная загрузка (для массового отображения в
  ///	спике)</param>
  ///	<param name="iolmFull">Полная загрузка данных (для работы с
  ///	объектом)</param>
  {$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
  TIDObjectLoadMode = (
    iolmPreLoad,

    iolmFull
  );

  // Состояние "жизни" оповещающего объекта
  TNotifyObjectState = (nosNormal, nosDestroing);
  // Набор типов оповещений
  TUcNotifyInfo = (niTag, // Изменился Tag
                   niMax, // Изменились значения прогресса Max
                   niPos, // Изменились значения прогресса Pos
                   niTxt, // Изменился текст оповещения
                   niErr  // Изменился флаг ошибки
                  );
  TUcNotifyInfos = set of TUcNotifyInfo;
  //**

  TStrArray = array of string;
  TBoolExpResult = (berTrue, berFalse, berError);

  TUcIMGStyle = (isStretch, isRepeat, isRepeatX, isRepeatY, isOriginal);


  { Процедурные типы }
  TBackUpFeedBack = procedure(Str: string) of object;
  TCopyFolderFeedBack = procedure(FileName: string; FileCount, NowPosition: Integer) of object;
  TGetPassword = procedure(Sender: TObject; out PassValue: String) of object;
  TNotifyDrawBackground = procedure(Sender: TObject; Canvas: TCanvas) of object;

  { Типы для ucWindows }
  SHUTDOWN_ACTION = (ShutdownNoReboot, ShutdownReboot, ShutdownPowerOff);

  { Типы для ucStdCtrls }
  TUcSkinName = type string;
  TUcPaintInfoStr = type string;
  TUcLabelStyle = (ulsLabel, ulsLink, ulsWebLink);

  { Типы для ucSkin }
  TUcSkinChangeInfo = (sciNone, sciImage, sciStyle);

  { Константы стандартных каталогов Windows }
type
  CSIDL_Rec = record
    Name: string;
    Value: Integer;
  end;

const
  {$IFDEF DELPHI_2009_UP}
  CSIDL_Consts: array[0..63] of CSIDL_Rec = (
  {$ELSE}
  CSIDL_Consts: array[0..11] of CSIDL_Rec = (
  {$ENDIF}
    (Name:'CSIDL_DESKTOP';                  Value:CSIDL_DESKTOP),                 // <desktop>
    (Name:'CSIDL_INTERNET';                 Value:CSIDL_INTERNET),                // Internet Explorer (icon on desktop)
    (Name:'CSIDL_PROGRAMS';                 Value:CSIDL_PROGRAMS),                // Start Menu\Programs
    (Name:'CSIDL_CONTROLS';                 Value:CSIDL_CONTROLS),                // My Computer\Control Panel
    (Name:'CSIDL_PRINTERS';                 Value:CSIDL_PRINTERS),                // My Computer\Printers
    (Name:'CSIDL_PERSONAL';                 Value:CSIDL_PERSONAL),                // My Documents
    (Name:'CSIDL_FAVORITES';                Value:CSIDL_FAVORITES),               // <user name>\Favorites
    (Name:'CSIDL_STARTUP';                  Value:CSIDL_STARTUP),                 // Start Menu\Programs\Startup
    (Name:'CSIDL_RECENT';                   Value:CSIDL_RECENT),                  // <user name>\Recent
    (Name:'CSIDL_SENDTO';                   Value:CSIDL_SENDTO),                  // <user name>\SendTo
    (Name:'CSIDL_BITBUCKET';                Value:CSIDL_BITBUCKET),               // <desktop>\Recycle Bin
    (Name:'CSIDL_STARTMENU';                Value:CSIDL_STARTMENU)                // <user name>\Start Menu

    {$IFDEF DELPHI_2009_UP}
    ,
    (Name:'CSIDL_MYDOCUMENTS';              Value:CSIDL_MYDOCUMENTS),             // Personal was just a silly name for My Documents
    (Name:'CSIDL_MYMUSIC';                  Value:CSIDL_MYMUSIC),                 // "My Music" folder
    (Name:'CSIDL_MYVIDEO';                  Value:CSIDL_MYVIDEO),                 // "My Videos" folder
    (Name:'CSIDL_DESKTOPDIRECTORY';         Value:CSIDL_DESKTOPDIRECTORY),        // <user name>\Desktop
    (Name:'CSIDL_DRIVES';                   Value:CSIDL_DRIVES),                  // My Computer
    (Name:'CSIDL_NETWORK';                  Value:CSIDL_NETWORK),                 // Network Neighborhood (My Network Places)
    (Name:'CSIDL_NETHOOD';                  Value:CSIDL_NETHOOD),                 // <user name>\nethood
    (Name:'CSIDL_FONTS';                    Value:CSIDL_FONTS),                   // windows\fonts
    (Name:'CSIDL_TEMPLATES';                Value:CSIDL_TEMPLATES),
    (Name:'CSIDL_COMMON_STARTMENU';         Value:CSIDL_COMMON_STARTMENU),        // All Users\Start Menu
    (Name:'CSIDL_COMMON_PROGRAMS';          Value:CSIDL_COMMON_PROGRAMS),         // All Users\Start Menu\Programs
    (Name:'CSIDL_COMMON_STARTUP';           Value:CSIDL_COMMON_STARTUP),          // All Users\Startup
    (Name:'CSIDL_COMMON_DESKTOPDIRECTORY';  Value:CSIDL_COMMON_DESKTOPDIRECTORY), // All Users\Desktop
    (Name:'CSIDL_APPDATA';                  Value:CSIDL_APPDATA),                 // <user name>\Application Data
    (Name:'CSIDL_PRINTHOOD';                Value:CSIDL_PRINTHOOD),               // <user name>\PrintHood
    (Name:'CSIDL_LOCAL_APPDATA';            Value:CSIDL_LOCAL_APPDATA),           // <user name>\Local Settings\Applicaiton Data (non roaming)
    (Name:'CSIDL_ALTSTARTUP';               Value:CSIDL_ALTSTARTUP),              // non localized startup
    (Name:'CSIDL_COMMON_ALTSTARTUP';        Value:CSIDL_COMMON_ALTSTARTUP),       // non localized common startup
    (Name:'CSIDL_COMMON_FAVORITES';         Value:CSIDL_COMMON_FAVORITES),
    (Name:'CSIDL_INTERNET_CACHE';           Value:CSIDL_INTERNET_CACHE),
    (Name:'CSIDL_COOKIES';                  Value:CSIDL_COOKIES),
    (Name:'CSIDL_HISTORY';                  Value:CSIDL_HISTORY),
    (Name:'CSIDL_COMMON_APPDATA';           Value:CSIDL_COMMON_APPDATA),          // All Users\Application Data
    (Name:'CSIDL_WINDOWS';                  Value:CSIDL_WINDOWS),                 // GetWindowsDirectory()
    (Name:'CSIDL_SYSTEM';                   Value:CSIDL_SYSTEM),                  // GetSystemDirectory()
    (Name:'CSIDL_PROGRAM_FILES';            Value:CSIDL_PROGRAM_FILES),           // C:\Program Files
    (Name:'CSIDL_MYPICTURES';               Value:CSIDL_MYPICTURES),              // C:\Program Files\My Pictures
    (Name:'CSIDL_PROFILE';                  Value:CSIDL_PROFILE),                 // USERPROFILE
    (Name:'CSIDL_SYSTEMX86';                Value:CSIDL_SYSTEMX86),               // x86 system directory on RISC
    (Name:'CSIDL_PROGRAM_FILESX86';         Value:CSIDL_PROGRAM_FILESX86),        // x86 C:\Program Files on RISC
    (Name:'CSIDL_PROGRAM_FILES_COMMON';     Value:CSIDL_PROGRAM_FILES_COMMON),    // C:\Program Files\Common
    (Name:'CSIDL_PROGRAM_FILES_COMMONX86';  Value:CSIDL_PROGRAM_FILES_COMMONX86), // x86 Program Files\Common on RISC
    (Name:'CSIDL_COMMON_TEMPLATES';         Value:CSIDL_COMMON_TEMPLATES),        // All Users\Templates
    (Name:'CSIDL_COMMON_DOCUMENTS';         Value:CSIDL_COMMON_DOCUMENTS),        // All Users\Documents
    (Name:'CSIDL_COMMON_ADMINTOOLS';        Value:CSIDL_COMMON_ADMINTOOLS),       // All Users\Start Menu\Programs\Administrative Tools
    (Name:'CSIDL_ADMINTOOLS';               Value:CSIDL_ADMINTOOLS),              // <user name>\Start Menu\Programs\Administrative Tools
    (Name:'CSIDL_CONNECTIONS';              Value:CSIDL_CONNECTIONS),             // Network and Dial-up Connections
    (Name:'CSIDL_COMMON_MUSIC';             Value:CSIDL_COMMON_MUSIC),            // All Users\My Music
    (Name:'CSIDL_COMMON_PICTURES';          Value:CSIDL_COMMON_PICTURES),         // All Users\My Pictures
    (Name:'CSIDL_COMMON_VIDEO';             Value:CSIDL_COMMON_VIDEO),            // All Users\My Video
    (Name:'CSIDL_RESOURCES';                Value:CSIDL_RESOURCES),               // Resource Direcotry
    (Name:'CSIDL_RESOURCES_LOCALIZED';      Value:CSIDL_RESOURCES_LOCALIZED),     // Localized Resource Direcotry
    (Name:'CSIDL_COMMON_OEM_LINKS';         Value:CSIDL_COMMON_OEM_LINKS),        // Links to All Users OEM specific apps
    (Name:'CSIDL_CDBURN_AREA';              Value:CSIDL_CDBURN_AREA),             // USERPROFILE\Local Settings\Application Data\Microsoft\CD Burning
                                                                                  // unused                               0x003c
    (Name:'CSIDL_COMPUTERSNEARME';          Value:CSIDL_COMPUTERSNEARME),         // Computers Near Me (computered from Workgroup membership)
    (Name:'CSIDL_FLAG_CREATE';              Value:CSIDL_FLAG_CREATE),             // combine with CSIDL_ value to force folder creation in SHGetFolderPath()
    (Name:'CSIDL_FLAG_DONT_VERIFY';         Value:CSIDL_FLAG_DONT_VERIFY),        // combine with CSIDL_ value to return an unverified folder path
    (Name:'CSIDL_FLAG_DONT_UNEXPAND';       Value:CSIDL_FLAG_DONT_UNEXPAND),      // combine with CSIDL_ value to avoid unexpanding environment variables
    (Name:'CSIDL_FLAG_NO_ALIAS';            Value:CSIDL_FLAG_NO_ALIAS),           // combine with CSIDL_ value to insure non-alias versions of the pidl
    (Name:'CSIDL_FLAG_PER_USER_INIT';       Value:CSIDL_FLAG_PER_USER_INIT),      // combine with CSIDL_ value to indicate per-user init (eg. upgrade)
    (Name:'CSIDL_FLAG_MASK';                Value:CSIDL_FLAG_MASK),               // mask for all possible flag values

    (Name:'CSIDL_PROFILES';                 Value:CSIDL_PROFILES)
    {$ENDIF}
  );


implementation

end.
