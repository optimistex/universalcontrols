// Версия - 26.12.2012
unit ucOSUtils;
{$include ..\delphi_ver.inc}

interface

uses Windows, Registry, SysUtils, ucWindows, Variants, ucNetFwTypeLib_TLB,
    Classes, ComObj, ComConst, ActiveX, Dialogs, StrUtils;

const
    // Windows XP ..
  NET_FW_PROFILE_DOMAIN     = 0;
  NET_FW_PROFILE_STANDARD   = 1;

  NET_FW_SCOPE_ALL          = 0;

  NET_FW_IP_VERSION_ANY     = 2;

    // Windows 7 ..
  NET_FW_PROFILE2_DOMAIN    = 1;
  NET_FW_PROFILE2_PRIVATE   = 2;
  NET_FW_PROFILE2_PUBLIC    = 4;

  NET_FW_IP_PROTOCOL_TCP    = 6;
  NET_FW_IP_PROTOCOL_UDP    = 17;
  NET_FW_IP_PROTOCOL_ICMPv4 = 1;
  NET_FW_IP_PROTOCOL_ICMPv6 = 58;
  NET_FW_ACTION_ALLOW       = 1;
  NET_FW_ACTION_BLOCK       = 0;

  NET_FW_RULE_DIR_IN        = 1;
  NET_FW_RULE_DIR_OUT       = 2;

type TPlatformType = (pt_Unknown, pt_x32, pt_x64);

  {$IFNDEF DELPHI_2009_UP}
  POSVersionInfoA = ^TOSVersionInfoA;
  POSVersionInfoW = ^TOSVersionInfoW;
  POSVersionInfo = POSVersionInfoW;
  _OSVERSIONINFOA = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of AnsiChar; { Maintenance AnsiString for PSS usage }
  end;
  {$EXTERNALSYM _OSVERSIONINFOA}
  _OSVERSIONINFOW = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of WideChar; { Maintenance UnicodeString for PSS usage }
  end;
  {$EXTERNALSYM _OSVERSIONINFOW}
  _OSVERSIONINFO = _OSVERSIONINFOW;
  TOSVersionInfoA = _OSVERSIONINFOA;
  TOSVersionInfoW = _OSVERSIONINFOW;
  TOSVersionInfo = TOSVersionInfoW;
  OSVERSIONINFOA = _OSVERSIONINFOA;
  {$EXTERNALSYM OSVERSIONINFOA}
  OSVERSIONINFOW = _OSVERSIONINFOW;
  {$EXTERNALSYM OSVERSIONINFOW}
  OSVERSIONINFO = OSVERSIONINFOW;
  {$EXTERNALSYM OSVERSIONINFO}

  POSVersionInfoExA = ^TOSVersionInfoExA;
  POSVersionInfoExW = ^TOSVersionInfoExW;
  POSVersionInfoEx = POSVersionInfoExW;
  _OSVERSIONINFOEXA = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of AnsiChar; { Maintenance AnsiString for PSS usage }
    wServicePackMajor: WORD;
    wServicePackMinor: WORD;
    wSuiteMask: WORD;
    wProductType: BYTE;
    wReserved:BYTE;
  end;
  {$EXTERNALSYM _OSVERSIONINFOEXA}
  _OSVERSIONINFOEXW = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of WideChar; { Maintenance UnicodeString for PSS usage }
    wServicePackMajor: WORD;
    wServicePackMinor: WORD;
    wSuiteMask: WORD;
    wProductType: BYTE;
    wReserved:BYTE;
  end;
  {$EXTERNALSYM _OSVERSIONINFOEXW}
  _OSVERSIONINFOEX = _OSVERSIONINFOEXW;
  TOSVersionInfoExA = _OSVERSIONINFOEXA;
  TOSVersionInfoExW = _OSVERSIONINFOEXW;
  TOSVersionInfoEx = TOSVersionInfoExW;
  OSVERSIONINFOEXA = _OSVERSIONINFOEXA;
  {$EXTERNALSYM OSVERSIONINFOEXA}
  OSVERSIONINFOEXW = _OSVERSIONINFOEXW;
  {$EXTERNALSYM OSVERSIONINFOEXW}
  OSVERSIONINFOEX = OSVERSIONINFOEXW;
  {$EXTERNALSYM OSVERSIONINFOEX}
  LPOSVERSIONINFOEXA = POSVERSIONINFOEXA;
  {$EXTERNALSYM LPOSVERSIONINFOEXA}
  LPOSVERSIONINFOEXW = POSVERSIONINFOEXW;
  {$EXTERNALSYM LPOSVERSIONINFOEXW}
  LPOSVERSIONINFOEX = LPOSVERSIONINFOEXW;
  {$EXTERNALSYM LPOSVERSIONINFOEX}
  RTL_OSVERSIONINFOEXW = _OSVERSIONINFOEXW;
  {$EXTERNALSYM RTL_OSVERSIONINFOEXW}
  PRTL_OSVERSIONINFOEXW = POSVERSIONINFOEXW;
  {$EXTERNALSYM PRTL_OSVERSIONINFOEXW}

  function GetVersionEx(var lpVersionInformation: TOSVersionInfoEx): BOOL; external kernel32 name 'GetVersionExW';
  {$ENDIF}
  
 type
    TUC_FireWall = class(TObject)
      private
        sFileName: string;
            // Windows XP
        fwCurrentProfiles : Integer;
        fwMgrXP:      INetFwMgr;
        fwPolicyXP:   INetFwPolicy;
        fwProfileXP:  INetFwProfile;
        fwRulesXP:    INetFwAuthorizedApplications;
            // Windows Vista ..
        fwPolicy2 : OleVariant;
        fwMgr, fwProfile, fwRules : OleVariant;

        function FirewallVersion: Integer;
      protected
        fwVersion: Integer;       // 1-XP/Vista 2-Win7
        fInitiated: Boolean;
        function fwEnabled: Boolean;
      public
        constructor Create(FileName: string);
        destructor Destroy; override;
        function GetFirewallInfo(var stl: TStringList; var Err: string; RuleName: string; FileName: string = ''): boolean;
        function Add(RuleName: string; FileName: string = ''): Boolean;
        function Exist(RuleName: string; FileName: string = ''): Boolean;
        function Delete(RuleName: string; FileName: string = ''): Boolean;
        property InitSuccess: Boolean read fInitiated;
        property WinFirewallEnabled: Boolean read fwEnabled;
    end;

function UC_GetVersionEx(out lpVersionInformation: TOSVersionInfoEx): Boolean;
function UC_OSVersionInfoToString(const OSVI: TOSVersionInfoEx): string;
function UC_CheckPlatform: TPlatformType;
function UC_FirewallInfo(var stl: TStringList; var Err: string; RuleName, FileName: string): Boolean;

implementation

const
  VER_NT_WORKSTATION    :Integer = 1;
  VER_NT_SERVER         :Integer = 3;

const
  PROCESSOR_ARCHITECTURE_AMD64   = 9; // x64 (AMD or Intel)
  PROCESSOR_ARCHITECTURE_IA64    = 6; // Intel Itanium Processor Family (IPF)
  PROCESSOR_ARCHITECTURE_INTEL   = 0; // x86
  PROCESSOR_ARCHITECTURE_UNKNOWN = $ffff; // Unknown processor.

    // Microsoft BackOffice компоненты установлены.
  VER_SUITE_BACKOFFICE = $00000004;
    // Windows Server 2003 Web Edition установлен.
  VER_SUITE_BLADE = $00000400;
    // Windows Server 2003 Compute Cluster Edition установлена.
  VER_SUITE_COMPUTE_SERVER = $00004000;
    // Windows Server 2008 Datacenter, Windows Server 2003 Datacenter Edition, или Windows 2000 Datacenter Server.
  VER_SUITE_DATACENTER = $00000080;
    // Windows Server 2008 Enterprise, Windows Server 2003, Enterprise Edition, или Windows 2000 Advanced Server. См. в разделе"Замечания"для получения более подробной информации об этом флаг.
  VER_SUITE_ENTERPRISE = $00000002;
    // Windows XP Embedded установлен.
  VER_SUITE_EMBEDDEDNT = $00000040;
    // Windows Vista Home Premium, Windows Vista Home Basic, или Windows XP Home Edition установлена.
  VER_SUITE_PERSONAL = $00000200;
    // Remote Desktop поддерживается, но только один интерактивные сессии поддерживается. Это значение устанавливается, если система работает в режиме сервера приложений.
  VER_SUITE_SINGLEUSERTS = $00000100;
    // Microsoft Small Business Server после установки в системе, но может быть повышен до другое версии Windows. См. в разделе"Замечания"для получения более подробной информации об этой флаг.
  VER_SUITE_SMALLBUSINESS = $00000001;
    // Microsoft Small Business Server установлен с ограничительные клиентской лицензии в силе. Обратитесь к Примечания раздел для получения дополнительной информации об этой флаг.
  VER_SUITE_SMALLBUSINESS_RESTRICTED = $00000020;
    // Windows Storage Server 2003 R2 или Windows Storage Server 2003is установлен.
  VER_SUITE_STORAGE_SERVER = $00002000;
    // Службы Терминалов установлен. Это значение устанавливается всегда.
    // Если VER_SUITE_TERMINAL установлен, но VER_SUITE_SINGLEUSERTS не установлена, система работает в режиме сервера приложений.
  VER_SUITE_TERMINAL = $00000010;
    // Windows Home Server.
  VER_SUITE_WH_SERVER = $00008000;

const
  { Константы взяты из MSDN:
    http://msdn.microsoft.com/en-us/library/windows/desktop/ms724358%28v=vs.85%29.aspx }
  PRODUCT_BUSINESS = $00000006; // Business
  PRODUCT_BUSINESS_N = $00000010; // Business N
  PRODUCT_CLUSTER_SERVER = $00000012; // HPC Edition
  PRODUCT_DATACENTER_SERVER = $00000008; // Server Datacenter (full installation)
  PRODUCT_DATACENTER_SERVER_CORE = $0000000C; // Server Datacenter (core installation)
  PRODUCT_DATACENTER_SERVER_CORE_V = $00000027; // Server Datacenter without Hyper-V (core installation)
  PRODUCT_DATACENTER_SERVER_V = $00000025; // Server Datacenter without Hyper-V (full installation)
  PRODUCT_ENTERPRISE = $00000004; // Enterprise
  PRODUCT_ENTERPRISE_E = $00000046; // Not supported
  PRODUCT_ENTERPRISE_N = $0000001B; // Enterprise N
  PRODUCT_ENTERPRISE_SERVER = $0000000A; // Server Enterprise (full installation)
  PRODUCT_ENTERPRISE_SERVER_CORE = $0000000E; // Server Enterprise (core installation)
  PRODUCT_ENTERPRISE_SERVER_CORE_V = $00000029; // Server Enterprise without Hyper-V (core installation)
  PRODUCT_ENTERPRISE_SERVER_IA64 = $0000000F; // Server Enterprise for Itanium-based Systems
  PRODUCT_ENTERPRISE_SERVER_V = $00000026; // Server Enterprise without Hyper-V (full installation)
  PRODUCT_HOME_BASIC = $00000002; // Home Basic
  PRODUCT_HOME_BASIC_E = $00000043; // Not supported
  PRODUCT_HOME_BASIC_N = $00000005; // Home Basic N
  PRODUCT_HOME_PREMIUM = $00000003; // Home Premium
  PRODUCT_HOME_PREMIUM_E = $00000044; // Not supported
  PRODUCT_HOME_PREMIUM_N = $0000001A; // Home Premium N
  PRODUCT_HYPERV = $0000002A; // Microsoft Hyper-V Server
  PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT = $0000001E; // Windows Essential Business Server Management Server
  PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING = $00000020; // Windows Essential Business Server Messaging Server
  PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY = $0000001F; // Windows Essential Business Server Security Server
  PRODUCT_PROFESSIONAL = $00000030; // Professional
  PRODUCT_PROFESSIONAL_E = $00000045; // Not supported
  PRODUCT_PROFESSIONAL_N = $00000031; // Professional N
  PRODUCT_SERVER_FOR_SMALLBUSINESS = $00000018; // Windows Server 2008 for Windows Essential Server Solutions
  PRODUCT_SERVER_FOR_SMALLBUSINESS_V = $00000023; // Windows Server 2008 without Hyper-V for Windows Essential Server Solutions
  PRODUCT_SERVER_FOUNDATION = $00000021; // Server Foundation
  PRODUCT_HOME_PREMIUM_SERVER = $00000022; // Windows Home Server 2011
  PRODUCT_SB_SOLUTION_SERVER = $00000032; // Windows Small Business Server 2011 Essentials
  PRODUCT_HOME_SERVER = $00000013; // Windows Storage Server 2008 R2 Essentials
  PRODUCT_SMALLBUSINESS_SERVER = $00000009; // Windows Small Business Server
  PRODUCT_SOLUTION_EMBEDDEDSERVER = $00000038; // Windows MultiPoint Server
  PRODUCT_STANDARD_SERVER = $00000007; // Server Standard (full installation)
  PRODUCT_STANDARD_SERVER_CORE = $0000000D; // Server Standard (core installation)
  PRODUCT_STANDARD_SERVER_CORE_V = $00000028; // Server Standard without Hyper-V (core installation)
  PRODUCT_STANDARD_SERVER_V = $00000024; // Server Standard without Hyper-V (full installation)
  PRODUCT_STARTER = $0000000B; // Starter
  PRODUCT_STARTER_E = $00000042; // Not supported
  PRODUCT_STARTER_N = $0000002F; // Starter N
  PRODUCT_STORAGE_ENTERPRISE_SERVER = $00000017; // Storage Server Enterprise
  PRODUCT_STORAGE_EXPRESS_SERVER = $00000014; // Storage Server Express
  PRODUCT_STORAGE_STANDARD_SERVER = $00000015; // Storage Server Standard
  PRODUCT_STORAGE_WORKGROUP_SERVER = $00000016; // Storage Server Workgroup
  PRODUCT_UNDEFINED = $00000000; // An unknown product
  PRODUCT_ULTIMATE = $00000001; // Ultimate
  PRODUCT_ULTIMATE_E = $00000047; // Not supported
  PRODUCT_ULTIMATE_N = $0000001C; // Ultimate N
  PRODUCT_WEB_SERVER = $00000011; // Web Server (full installation)
  PRODUCT_WEB_SERVER_CORE = $0000001D; // Web Server (core installation)
  PRODUCT_UNLICENSED = $ABCDABCD; // Product has not been activated

  {$IFNDEF DELPHI_2009_UP}
  {$EXTERNALSYM SM_SERVERR2}
  SM_SERVERR2 = 89;
  {$ENDIF}

var
  iFireWall: INetFwAuthorizedApplications;

{$EXTERNALSYM _GetProductInfo}
  _GetProductInfo: function (dwOSMajorVersion, dwOSMinorVersion,
                             dwSpMajorVersion, dwSpMinorVersion: DWORD;
                             var pdwReturnedProductType: DWORD): BOOL stdcall = nil;

{$EXTERNALSYM _IsWow64Process}
  _IsWow64Process: function (H: THandle; Value: PBOOL): BOOL stdcall = nil;

function UC_GetVersionEx(out lpVersionInformation: TOSVersionInfoEx): Boolean;
begin
  lpVersionInformation.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
  Result := GetVersionEx(lpVersionInformation);
end;

function UC_OSVersionInfoToString(const OSVI: TOSVersionInfoEx): string;
var lpSystemInfo: TSystemInfo;
    SystemMetrics: Integer;
    vPlatform, ServicePack, ProdInfo: string;
    pdwReturnedProductType: DWORD;
    OSIs64bits: Boolean;
begin
  Result := '';
  // Определяем наименование версии ОС
  case OSVI.dwMajorVersion of
    6: begin
      case OSVI.dwMinorVersion of
        1:
          if OSVI.wProductType = VER_NT_WORKSTATION then
            Result := 'Windows 7'
            else
            Result := 'Windows Server 2008 R2';
        0:
          if OSVI.wProductType = VER_NT_WORKSTATION then
            Result := 'Windows Vista'
            else
            Result := 'Windows Server 2008';
      end;
    end;

    5: begin
      GetSystemInfo(lpSystemInfo);
      SystemMetrics := GetSystemMetrics(SM_SERVERR2);
      case OSVI.dwMinorVersion of
        2:
          if SystemMetrics <> 0 then
            Result := 'Windows Server 2003 R2'
          else if OSVI.wSuiteMask and VER_SUITE_WH_SERVER <> 0 then
            Result := 'Windows Home Server'
          else if SystemMetrics = 0 then
            Result := 'Windows Server 2003'
          else if (OSVI.wProductType = VER_NT_WORKSTATION) and
                  (lpSystemInfo.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) then
            Result := 'Windows XP Professional x64 Edition';
        1: Result := 'Windows XP';
        0: Result := 'Windows 2000';
      end;
    end;
  end;
  // **
  if Result = '' then
    Result := 'Unknown OS'
  else begin
    // Определение типа сборки ОС
    ProdInfo := '';
    if Assigned(_GetProductInfo) then
    begin
      _GetProductInfo(OSVI.dwMajorVersion, OSVI.dwMinorVersion,
                    OSVI.wServicePackMajor, OSVI.wServicePackMinor,
                    pdwReturnedProductType);
      case pdwReturnedProductType of
        PRODUCT_BUSINESS:
          ProdInfo := 'Business';
        PRODUCT_BUSINESS_N:
          ProdInfo := 'Business N';
        PRODUCT_CLUSTER_SERVER:
          ProdInfo := 'HPC Edition';
        PRODUCT_DATACENTER_SERVER:
          ProdInfo := 'Server Datacenter (full installation)';
        PRODUCT_DATACENTER_SERVER_CORE:
          ProdInfo := 'Server Datacenter (core installation)';
        PRODUCT_DATACENTER_SERVER_CORE_V:
          ProdInfo := 'Server Datacenter without Hyper-V (core installation)';
        PRODUCT_DATACENTER_SERVER_V:
          ProdInfo := 'Server Datacenter without Hyper-V (full installation)';
        PRODUCT_ENTERPRISE:
          ProdInfo := 'Enterprise';
        PRODUCT_ENTERPRISE_E:
          ProdInfo := 'Not supported';
        PRODUCT_ENTERPRISE_N:
          ProdInfo := 'Enterprise N';
        PRODUCT_ENTERPRISE_SERVER:
          ProdInfo := 'Server Enterprise (full installation)';
        PRODUCT_ENTERPRISE_SERVER_CORE:
          ProdInfo := 'Server Enterprise (core installation)';
        PRODUCT_ENTERPRISE_SERVER_CORE_V:
          ProdInfo := 'Server Enterprise without Hyper-V (core installation)';
        PRODUCT_ENTERPRISE_SERVER_IA64:
          ProdInfo := 'Server Enterprise for Itanium-based Systems';
        PRODUCT_ENTERPRISE_SERVER_V:
          ProdInfo := 'Server Enterprise without Hyper-V (full installation)';
        PRODUCT_HOME_BASIC:
          ProdInfo := 'Home Basic';
        PRODUCT_HOME_BASIC_E:
          ProdInfo := 'Not supported';
        PRODUCT_HOME_BASIC_N:
          ProdInfo := 'Home Basic N';
        PRODUCT_HOME_PREMIUM:
          ProdInfo := 'Home Premium';
        PRODUCT_HOME_PREMIUM_E:
          ProdInfo := 'Not supported';
        PRODUCT_HOME_PREMIUM_N:
          ProdInfo := 'Home Premium N';
        PRODUCT_HYPERV:
          ProdInfo := 'Microsoft Hyper-V Server';
        PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT:
          ProdInfo := 'Windows Essential Business Server Management Server';
        PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING:
          ProdInfo := 'Windows Essential Business Server Messaging Server';
        PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY:
          ProdInfo := 'Windows Essential Business Server Security Server';
        PRODUCT_PROFESSIONAL:
          ProdInfo := 'Professional';
        PRODUCT_PROFESSIONAL_E:
          ProdInfo := 'Not supported';
        PRODUCT_PROFESSIONAL_N:
          ProdInfo := 'Professional N';
        PRODUCT_SERVER_FOR_SMALLBUSINESS:
          ProdInfo := 'Windows Server 2008 for Windows Essential Server Solutions';
        PRODUCT_SERVER_FOR_SMALLBUSINESS_V:
          ProdInfo := 'Windows Server 2008 without Hyper-V for Windows Essential Server Solutions';
        PRODUCT_SERVER_FOUNDATION:
          ProdInfo := 'Server Foundation';
        PRODUCT_HOME_PREMIUM_SERVER:
          ProdInfo := 'Windows Home Server 2011';
        PRODUCT_SB_SOLUTION_SERVER:
          ProdInfo := 'Windows Small Business Server 2011 Essentials';
        PRODUCT_HOME_SERVER:
          ProdInfo := 'Windows Storage Server 2008 R2 Essentials';
        PRODUCT_SMALLBUSINESS_SERVER:
          ProdInfo := 'Windows Small Business Server';
        PRODUCT_SOLUTION_EMBEDDEDSERVER:
          ProdInfo := 'Windows MultiPoint Server';
        PRODUCT_STANDARD_SERVER:
          ProdInfo := 'Server Standard (full installation)';
        PRODUCT_STANDARD_SERVER_CORE:
          ProdInfo := 'Server Standard (core installation)';
        PRODUCT_STANDARD_SERVER_CORE_V:
          ProdInfo := 'Server Standard without Hyper-V (core installation)';
        PRODUCT_STANDARD_SERVER_V:
          ProdInfo := 'Server Standard without Hyper-V (full installation)';
        PRODUCT_STARTER:
          ProdInfo := 'Starter';
        PRODUCT_STARTER_E:
          ProdInfo := 'Not supported';
        PRODUCT_STARTER_N:
          ProdInfo := 'Starter N';
        PRODUCT_STORAGE_ENTERPRISE_SERVER:
          ProdInfo := 'Storage Server Enterprise';
        PRODUCT_STORAGE_EXPRESS_SERVER:
          ProdInfo := 'Storage Server Express';
        PRODUCT_STORAGE_STANDARD_SERVER:
          ProdInfo := 'Storage Server Standard';
        PRODUCT_STORAGE_WORKGROUP_SERVER:
          ProdInfo := 'Storage Server Workgroup';
        PRODUCT_UNDEFINED:
          ProdInfo := 'An unknown product';
        PRODUCT_ULTIMATE:
          ProdInfo := 'Ultimate';
        PRODUCT_ULTIMATE_E:
          ProdInfo := 'Not supported';
        PRODUCT_ULTIMATE_N:
          ProdInfo := 'Ultimate N';
        PRODUCT_WEB_SERVER:
          ProdInfo := 'Web Server (full installation)';
        PRODUCT_WEB_SERVER_CORE:
          ProdInfo := 'Web Server (core installation)';
        PRODUCT_UNLICENSED:
          ProdInfo := 'Product has not been activated';
      end;{ pdwReturnedProductType }
    end { GetProductInfo<>NIL }
    else begin
      if OSVI.wProductType = VER_NT_WORKSTATION then
      begin
        if OSVI.wProductType = VER_NT_WORKSTATION then
        begin
          case OSVI.wSuiteMask of
            512: ProdInfo := 'Personal';
            768: ProdInfo := 'Home Premium';
          else
            ProdInfo := 'Professional';
          end;
        end
        else if OSVI.wProductType = VER_NT_SERVER then
        begin
          if OSVI.wSuiteMask = VER_SUITE_DATACENTER then
            ProdInfo := 'DataCenter Server'
          else if OSVI.wSuiteMask = VER_SUITE_ENTERPRISE then
            ProdInfo :=  'Advanced Server'
          else
            ProdInfo := 'Server';
        end;
      end{ wProductType=VER_NT_WORKSTATION }
      else begin
        with TRegistry.Create do
        try
          RootKey := HKEY_LOCAL_MACHINE;
          if OpenKeyReadOnly('SYSTEM\CurrentControlSet\Control\ProductOptions') then
          try
            ProdInfo := UpperCase(ReadString('ProductType'));
            if ProdInfo = 'WINNT' then
              ProdInfo := ProdInfo + ' Workstation';
            if ProdInfo = 'SERVERNT' then
              ProdInfo := ProdInfo + ' Server';
          finally
            CloseKey;
          end;
        finally
          Free;
        end;
      end;{ wProductType<>VER_NT_WORKSTATION }
    end;{ GetProductInfo = NIL }
    if ProdInfo <> '' then
      Result := Result + ' ' + ProdInfo;
    //** Определение типа сборки ОС
    // Определение платформы Windows - x86/x64
    if not Assigned(_IsWow64Process) then
      vPlatform := UC_GetEnvironmentVariable('PROCESSOR_ARCHITECTURE')
      else if _IsWow64Process(GetCurrentProcess, @OSIs64bits) then
      begin
        if OSIs64bits then
          vPlatform := 'x64'
          else
          vPlatform := 'x86';
      end else
        vPlatform := 'x??';
    // Определяем сервис пак
    ServicePack := PChar(string(OSVI.szCSDVersion));
    if ServicePack = '' then
      ServicePack := Format('Sp%d.%d', [OSVI.wServicePackMajor, OSVI.wServicePackMinor]);
    // Формирвание строки описания ОС
    Result := Format('%s %s %s [%d.%d.%d]',
                     [Result,
                      ServicePack,
                      vPlatform,
                      OSVI.dwMajorVersion,
                      OSVI.dwMinorVersion,
                      OSVI.dwBuildNumber
                      ]);
  end;
end;

function UC_CheckPlatform: TPlatformType;
var vPlatform: string;
    OSIs64bits: Boolean;
begin
  if not Assigned(_IsWow64Process) then
    begin
      vPlatform := UC_GetEnvironmentVariable('PROCESSOR_ARCHITECTURE');
      if UpperCase(vPlatform) = 'X32' then Result := pt_x32
      else
        if UpperCase(vPlatform) = 'AMD64' then Result := pt_x64
        else
          Result := pt_Unknown;
    end
  else if _IsWow64Process(GetCurrentProcess, @OSIs64bits) then
    begin
      if OSIs64bits then
        Result := pt_x64
      else
        Result := pt_x32;
    end else
      Result := pt_Unknown;
end;

function UC_FirewallInfo(var stl: TStringList; var Err: string; RuleName, FileName: string): Boolean;
var fw: TUC_FireWall;
begin
  fw := TUC_FireWall.Create(FileName);
  try
    Result := fw.GetFirewallInfo(stl, Err, RuleName, FileName);
  finally
    fw.Free;
  end;
end;

constructor TUC_FireWall.Create(FileName: string);
var hr: HRESULT;
    rs: Boolean;
begin
  sFileName   := FileName;
  fwVersion   := FirewallVersion;
  fwMgrXP     := nil;
  fwPolicyXP  := nil;
  fwProfileXP := nil;
  fwRulesXP   := nil;
            // Windows Vista ..
  fwMgr       := null;
  fwPolicy2   := null;
  fwProfile   := null;
  fwRules     := Null;

  rs := False;
  try
    case fwVersion of
      1:  begin
            CoInitialize(nil);
            hr := CoCreateInstance(CLASS_NetFwMgr, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, INetFwMgr, fwMgrXP);
            if (hr = S_OK) and Assigned(fwMgrXP) then
              begin
                fwPolicyXP  := fwMgrXP.LocalPolicy;
                if Assigned(fwPolicyXP) then
                  begin
                    fwProfileXP := fwPolicyXP.CurrentProfile;
                    if Assigned(fwProfileXP) then
                      begin
                        fwRulesXP := fwProfileXP.AuthorizedApplications;
                        rs := Assigned(fwRulesXP);
                      end;
                  end;
              end;
          end;
      2:  begin
            fwPolicy2 := CreateOleObject('HNetCfg.FwPolicy2');
            fwMgr     := CreateOleObject('HNetCfg.FwMgr');
            fwProfile := fwMgr.LocalPolicy.CurrentProfile;
            fwCurrentProfiles := fwPolicy2.CurrentProfileTypes;
            fwRules  := fwPolicy2.Rules;

            rs := Assigned(IDispatch(fwPolicy2)) and Assigned(IDispatch(fwProfile)) and Assigned(IDispatch(fwRules));
          end;
    else
      fInitiated := False;
    end;
    fInitiated := rs and WinFirewallEnabled;
  except
    fInitiated := False;
  end;
end;

destructor TUC_FireWall.Destroy;
begin
  if fwVersion = 1 then
    CoUninitialize;
  inherited;
end;

function TUC_FireWall.fwEnabled: Boolean;
begin
  Try
    if fwVersion = 1 then
      Result := fwProfileXP.FirewallEnabled
    else
      Result := fwProfile.FirewallEnabled;
  except
    Result := False;
  end;
end;

function TUC_FireWall.GetFirewallInfo(var stl: TStringList; var Err: string; RuleName: string; FileName: string = ''): boolean;
var fn: string;
    fwApp:  INetFwAuthorizedApplication;
    fwRuleOle: OleVariant;
    fwRule: INetFwRule;
    rs: Boolean;
    rsq: HRESULT;
begin
  Result := Assigned(stl) and InitSuccess;
  if not Result then Exit;

  fn := sFileName;
  if FileName <> '' then
    fn := FileName;

  stl.Clear;

  stl.Add('Брандмауэр ' + IfThen(fwEnabled, 'включен', 'отключен'));
  case fwVersion of
    1:  begin
          try
            fwApp := fwRulesXP.Item(fn);
            rs := Assigned(fwApp);

            stl.Add('Правило ' + RuleName + ' для ' + fn + ' - ' + IfThen(rs, 'существует', 'не существует'));
            if rs then
              begin
                stl.Add('  Информация по правилу:');
                stl.Add('  Rule Name:          ' + fwApp.Name);
                stl.Add('   ----------------------------------------------');
                stl.Add('  Scope = '+ VarToStr(fwApp.Scope));
                stl.Add('  IpVersion = '+ VarToStr(fwApp.IpVersion));
                stl.Add('  RemoteAddresses = '+ fwApp.RemoteAddresses);
                stl.Add('  Enabled = '+ BoolToStr(fwApp.Enabled, True));
              end;
          except
            on E:Exception do
              begin
                Err := E.Message;
                Result := False;
              end;
          end;
        end;
    2:  begin
          try
            fwRuleOle := fwRules.Item(RuleName);
            rs := Assigned(IDispatch(fwRuleOle));
            rsq := (IDispatch(fwRuleOle)).QueryInterface(INetFwRule, fwRule);
            if rsq = 0 then
              begin
                stl.Add('Правило ' + RuleName + ' для ' + fn + ' - ' + IfThen(rs, 'существует', 'не существует'));
                if rs then
                  begin
                    stl.Add('  Информация по правилу:');
                    stl.Add('  Rule Name:          ' + fwRule.Name);
                    stl.Add('   ----------------------------------------------');
                    stl.Add('  Description:        ' + fwRule.Description);
                    stl.Add('  Application Name:   ' + fwRule.ApplicationName);
                    stl.Add('  Service Name:       ' + fwRule.ServiceName);

                    Case fwRule.Protocol of
                      NET_FW_IP_PROTOCOL_TCP    : stl.Add('  IP Protocol:        TCP.');
                      NET_FW_IP_PROTOCOL_UDP    : stl.Add('  IP Protocol:        UDP.');
                      NET_FW_IP_PROTOCOL_ICMPv4 : stl.Add('  IP Protocol:        UDP.');
                      NET_FW_IP_PROTOCOL_ICMPv6 : stl.Add('  IP Protocol:        UDP.');
                    Else                           stl.Add('  IP Protocol:        ' + VarToStr(fwRule.Protocol));
                    End;

                    if (fwRule.Protocol = NET_FW_IP_PROTOCOL_TCP) or (fwRule.Protocol = NET_FW_IP_PROTOCOL_UDP) then
                    begin
                      stl.Add('  Local Ports:        ' + fwRule.LocalPorts);
                      stl.Add('  Remote Ports:       ' + fwRule.RemotePorts);
                      stl.Add('  LocalAddresses:     ' + fwRule.LocalAddresses);
                      stl.Add('  RemoteAddresses:    ' + fwRule.RemoteAddresses);
                    end;

                    if (fwRule.Protocol = NET_FW_IP_PROTOCOL_ICMPv4) or (fwRule.Protocol = NET_FW_IP_PROTOCOL_ICMPv6) then
                      stl.Add('  ICMP Type and Code: ' + fwRule.IcmpTypesAndCodes);

                    Case fwRule.Direction of
                      NET_FW_RULE_DIR_IN :  stl.Add('  Direction:          In');
                      NET_FW_RULE_DIR_OUT:  stl.Add('  Direction:          Out');
                    End;

                    stl.Add('  Enabled:            ' + VarToStr(fwRule.Enabled));
                    stl.Add('  Edge:               ' + VarToStr(fwRule.EdgeTraversal));

                    Case fwRule.Action of
                      NET_FW_ACTION_ALLOW : stl.Add('  Action:             Allow');
                      NET_FW_ACTION_BLOCk : stl.Add('  Action:             Block');
                    End;

                    stl.Add('  Grouping:           ' + fwRule.Grouping);
                    stl.Add('  Edge:               ' + VarToStr(fwRule.EdgeTraversal));
                    stl.Add('  Interface Types:    ' + fwRule.InterfaceTypes);
                  end;
              end;
            fwRuleOle := Unassigned;
          except
            on E:Exception do
              begin
                Err := E.Message;
                Result := False;
              end;
          end;
        end;
  end;
end;

function TUC_FireWall.FirewallVersion: Integer;
var osv: TOSVersionInfoEx;
    rs: Boolean;
begin
  Result := -1;
  rs := UC_GetVersionEx(osv);
  if rs then
    begin
      if (osv.dwMajorVersion < 6) or ((osv.dwMajorVersion = 6) and (osv.dwMinorVersion = 0)) then
        Result := 1    //    XP/Vista
      else
        Result := 2;   //    Win7
    end;
end;

function TUC_FireWall.Add(RuleName: string; FileName: string = ''): Boolean;
var Profile: Integer;
    NewRuleXP:  INetFwAuthorizedApplication;
    NewRule: OleVariant;
    fn: string;
    hr: HRESULT;
begin
  Result := False;
  if not InitSuccess then Exit;

  fn := sFileName;
  if FileName <> '' then
    fn := FileName;

  if Exist(RuleName, fn) then     // Если правило уже существует - считаем, что все нормально
    begin
      Result := True;
      Exit;
    end;

  case fwVersion of
    1:  begin
          try
            hr := CoCreateInstance(CLASS_NetFwAuthorizedApplication, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER,
                                  INetFwAuthorizedApplication, NewRuleXP);
            if (hr = S_OK) and Assigned(NewRuleXP) then
            begin
              NewRuleXP.ProcessImageFileName := fn;
              NewRuleXP.Name := RuleName;
              NewRuleXP.Scope := NET_FW_SCOPE_ALL;
              NewRuleXP.IpVersion := NET_FW_IP_VERSION_ANY;
              NewRuleXP.Enabled := True;
              fwRulesXP.Add(NewRuleXP);
              Result := True;
            end;
          except
            Result := False;
          end;
        end;
    2:  begin
          Profile := NET_FW_PROFILE2_PRIVATE OR NET_FW_PROFILE2_PUBLIC;
          try
            NewRule := CreateOleObject('HNetCfg.FWRule');
            NewRule.Name        := RuleName;
            NewRule.Description := RuleName;
            NewRule.Applicationname := fn;
            NewRule.Protocol := NET_FW_IP_PROTOCOL_TCP;
            NewRule.Enabled := True;
            NewRule.Profiles := Profile;
            NewRule.Action := NET_FW_ACTION_ALLOW;
            fwRules.Add(NewRule);
            Result := True;
          except
            Result := False;
          end;
        end;
  end;
end;

function TUC_FireWall.Exist(RuleName: string; FileName: string = ''): Boolean;
var fn: string;
    fwApp:  INetFwAuthorizedApplication;
    fwRule: OleVariant;
begin
  Result := False;
  if not InitSuccess then Exit;

  fn := sFileName;
  if FileName <> '' then
    fn := FileName;

  case fwVersion of
    1:  begin
          try
            fwApp := fwRulesXP.Item(fn);
            Result := Assigned(fwApp);
          except
            Result := False;
          end;
        end;
    2:  begin
          try
            fwRule := fwRules.Item(RuleName);
            Result := Assigned(IDispatch(fwRule));
          except
            Result := False;
          end;
        end;
  end;
end;

function TUC_FireWall.Delete(RuleName: string; FileName: string = ''): Boolean;
var fn: string;
begin
  Result := False;
  if not InitSuccess then Exit;

  fn := sFileName;
  if FileName <> '' then
    fn := FileName;

  Result := Exist(RuleName, fn);
  if Result then
    try
      case fwVersion of
        1:  fwRulesXP.Remove(fn);
        2:  fwRules.Remove(RuleName);
      end;
      Result :=  not Exist(RuleName, fn);
    except
      Result := False;
    end
  else
    Result := True;
end;

initialization
  @_GetProductInfo := GetProcAddress(GetModuleHandle(kernel32), 'GetProductInfo');
  @_IsWow64Process := GetProcAddress(GetModuleHandle(kernel32), 'IsWow64Process');

end.
