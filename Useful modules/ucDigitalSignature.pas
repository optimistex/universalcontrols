unit ucDigitalSignature;

interface

uses   Windows, SysUtils, wintrust;

  //Если этот флаг не установлен, все время штамп подписи считаются
  //действительными, навсегда. Установка этого флага ограничивает допустимое
  //время существования подпись к жизни подписания сертификата. Это позволяет
  //отследить штамп времени подписи, срок действия. Другими словами,
  //установка флага позволяет определить, просрочен ли сертификат.
  function UC_CheckDigitalSignature(const FileName: string; CheckLifeTimeSert:
      Boolean = False): Boolean;

implementation


function UC_CheckDigitalSignature(const FileName: string; CheckLifeTimeSert:
    Boolean = False): Boolean;
var
    ActionID: TGUID ;
    WinTrustData: TWinTrustData ;
    WinTrustFileInfo: TWinTrustFileInfo ;
    WFname: WideString ;

begin
  Result := False;
  if (Win32Platform < VER_PLATFORM_WIN32_NT) or (@WinVerifyTrust = nil) or (NOT FileExists (FileName))
  then  exit;
  WinTrustFileInfo.cbStruct := SizeOf (TWinTrustFileInfo) ;
  WFname := FileName ;
  WinTrustFileInfo.pcwszFilePath := @WFname [1] ;
  WinTrustFileInfo.hFile := 0 ;
  WinTrustFileInfo.pgKnownSubject := Nil ;
  WinTrustData.cbStruct := SizeOf (TWinTrustData) ;
  WinTrustData.pPolicyCallbackData := Nil ;
  WinTrustData.pSIPClientData := Nil ;
  WinTrustData.dwUIChoice := WTD_UI_NONE ;
  WinTrustData.fdwRevocationChecks := WTD_REVOKE_NONE ;
  WinTrustData.dwUnionChoice := WTD_CHOICE_FILE ;
  WinTrustData.Info.pFile := @WinTrustFileInfo ;
  WinTrustData.dwStateAction := 0 ;
  WinTrustData.hWVTStateData := 0 ;
  WinTrustData.pwszURLReference := Nil ;
  WinTrustData.dwProvFlags := WTD_REVOCATION_CHECK_NONE ;
  if CheckLifeTimeSert then
    WinTrustData.dwProvFlags := WinTrustData.dwProvFlags OR WTD_LIFETIME_SIGNING_FLAG ;
  WinTrustData.dwUIContext := WTD_UICONTEXT_EXECUTE ;
  ActionID := WINTRUST_ACTION_GENERIC_VERIFY_V2 ;
  Result:= WinVerifyTrust (INVALID_HANDLE_VALUE, ActionID, @WinTrustData) = ERROR_SUCCESS;
end ;

end.
