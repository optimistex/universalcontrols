// Версия - 26.10.2011
unit ucUACUtils;
//---------------------------------------------------------------------------//
//                Определение состояния доступа (есть ли права Админа)       //
//    Содержит данные и функции, необходимые для определения состояния       //
//  доступа (Админ/Не Админ и тип "токена" (для висты и семерки).            //
//---------------------------------------------------------------------------//

interface
{$include ..\delphi_ver.inc}

uses
  SysUtils, Windows;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Test if current process has admin privileges. Will always return
///	True on os older than Windows 2000.</summary>
///	<returns>Boolean - Returns True if process has administrator privileges,
///	False if not.</returns>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_IsUserAnAdmin: Boolean;

type
  //Enumeration is mirroring TOKEN_ELEVATION_TYPE in Windows Vista SDK (except first value).
  TTokenElevationType = (TokenElevationNotAvailable, TokenElevationTypeDefault,
                         TokenElevationTypeFull, TokenElevationTypeLimited);

  //  Состояние доступа
  TAccessState = record
     IsAdmin            : Boolean;
     TokenElevationType : TTokenElevationType;
     Error              : string;
  end;

function UC_GetTokenElevationType: TTokenElevationType;
function UC_GetAccessState: TAccessState;
function UC_AccessStateToStr(aAccessState: TAccessState): string;

implementation

resourcestring
  SErrorElevationRequired = 'Access Denied. Administrator permissions are needed to use the selected options. Use an administrator command prompt to complete these tasks.';
  SElevationAccessGranted = 'Access Granted. Administrator permissions are available.';

const
  ERROR_ELEVATION_REQUIRED = 740;
  ModName = 'shell32.dll';

var
  hShell32: HMODULE = 0;
  _IsUserAnAdmin: function(): BOOL; stdcall;

function UC_IsUserAnAdmin: Boolean;
begin
  if Assigned(_IsUserAnAdmin) then
    Result := _IsUserAnAdmin()
  else
  begin
    Result := True;
    if hShell32 = 0 then
      hShell32 := LoadLibrary(ModName);
    if hShell32 <> 0 then
    begin
      _IsUserAnAdmin := GetProcAddress(hShell32, 'IsUserAnAdmin'); // Do not localize
      if Assigned(_IsUserAnAdmin) then
        Result := _IsUserAnAdmin();
    end;
  end;
end;

type
  //Extend existing enumeration in Windows.pas with new Vista constants
  TTokenInformationClass = (TokenUser = 1, TokenGroups, TokenPrivileges,
    TokenOwner, TokenPrimaryGroup, TokenDefaultDacl, TokenSource, TokenType,
    TokenImpersonationLevel, TokenStatistics, TokenRestrictedSids, TokenSessionId,
    TokenGroupsAndPrivileges, TokenSessionReference, TokenSandBoxInert, TokenAuditPolicy,
    TokenOrigin, TokenElevationType, TokenLinkedToken, TokenElevation, TokenHasRestrictions,
    TokenAccessInformation, TokenVirtualizationAllowed, TokenVirtualizationEnabled,
    TokenIntegrityLevel, TokenUIAccess, TokenMandatoryPolicy, TokenLogonSid);

function UC_GetTokenElevationType: TTokenElevationType;
var
  hToken: THandle;
  elevationType: Integer;
  dwSize: DWORD;
begin
  Result := TokenElevationNotAvailable;
  hToken := 0;
  Win32Check(OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, hToken));
  if GetTokenInformation(hToken, Windows.TTokenInformationClass(TokenElevationType),
     @elevationType, sizeof(elevationType), dwSize) then
    Result := TTokenElevationType(elevationType);
  if hToken<>0 then
    CloseHandle(hToken);
end;

function UC_GetAccessState: TAccessState;
begin
  Result.IsAdmin := False;
  try
    Result.IsAdmin := UC_IsUserAnAdmin;
    Result.TokenElevationType := UC_GetTokenElevationType;
  except
    //  Сюда бы очень хорошо написать обработчик возвращения исключения
    //  (для этого где-нибуть надо создать поле или что-то подобное),
    //  например, такой:
    on E:Exception do
      Result.Error := E.Classname + ': ' + E.Message;
  end;
end;

function UC_AccessStateToStr(aAccessState: TAccessState): string;
begin
  if aAccessState.Error = '' then
  begin
    case aAccessState.TokenElevationType of
      TokenElevationNotAvailable:
        Result := 'No information about elevation is available.';
      TokenElevationTypeDefault:
        Result := 'TokenElevationTypeDefault - User is not using a split token.';
      TokenElevationTypeFull:
        Result := 'TokenElevationTypeFull - User has a split token, and the process is running elevated.';
      TokenElevationTypeLimited:
        Result := 'TokenElevationTypeLimited - User has a split token, but the process is not running elevated.';
    end;

    if not aAccessState.IsAdmin then
    begin
      Result := Result + #13#10 + SErrorElevationRequired;
      //Halt(ERROR_ELEVATION_REQUIRED);
    end
    else
      Result := Result + #13#10 + SElevationAccessGranted;
  end
  else
    Result := aAccessState.Error;
end;

initialization

finalization
  if hShell32 <> 0 then
    FreeLibrary(hShell32);

end.
