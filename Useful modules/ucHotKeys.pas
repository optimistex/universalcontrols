// Версия - 31.10.2011
unit ucHotKeys;
{$include ..\delphi_ver.inc}

interface

uses Windows, Classes, Menus, SysUtils, ucFunctions;

type
  TUcGlobalHotkey = class
  private
    FHotkey: TShortCut;
    FHandle: HWND;
    FHotkeyID: Word;
    procedure SetHandle(const Value: HWND);
    procedure SetHotkey(const Value: TShortCut);
    procedure SetHotkeyStr(Value: string);
    function  GetHotkeyStr: string;
    function GetIsRegistered: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function RegisterHotkey: Boolean;
    procedure UnRegisterHotkey;

    property Handle: HWND read FHandle write SetHandle;
    property Hotkey: TShortCut read FHotkey write SetHotkey;
    property HotkeyStr: string read GetHotkeyStr write SetHotkeyStr;
    property HotkeyID: Word read FHotkeyID;
    property IsRegistered: Boolean read GetIsRegistered;
  end;

procedure UC_ShortCutToHotKey(HotKey: TShortCut; var Key : Word; var Modifiers: Uint);

implementation

procedure UC_ShortCutToHotKey(HotKey: TShortCut; var Key : Word; var Modifiers: Uint);
var
  Shift: TShiftState;
begin
  ShortCutToKey(HotKey, Key, Shift);
  Modifiers := 0;
  if (ssShift in Shift) then
    Modifiers := Modifiers or MOD_SHIFT;
  if (ssAlt in Shift) then
    Modifiers := Modifiers or MOD_ALT;
  if (ssCtrl in Shift) then
    Modifiers := Modifiers or MOD_CONTROL;
end;

{ TUcHotkey }

constructor TUcGlobalHotkey.Create;
begin
  inherited;

  FHotkey   := 0;
  FHandle   := 0;
  FHotkeyID := 0;
end;

destructor TUcGlobalHotkey.Destroy;
begin
  UnRegisterHotkey;
  inherited;
end;

function TUcGlobalHotkey.GetHotkeyStr: string;
begin
  Result := ShortCutToText(Hotkey);
end;

function TUcGlobalHotkey.GetIsRegistered: Boolean;
begin
  Result := HotkeyID > 0;
end;

procedure TUcGlobalHotkey.SetHotkeyStr(Value: string);
begin
  Hotkey := TextToShortCut(Value);
end;

function TUcGlobalHotkey.RegisterHotkey: Boolean;
var
  Key : Word;
  Modifiers: UINT;
begin
  UC_ShortCutToHotKey(FHotkey, Key, Modifiers);
  // Проверка корректности
  Result := (Key <> 0) and (Modifiers <> 0);
  if Result then
  begin
    // получение уникального идентификатора для комбинации клавиш
    FHotkeyID := GlobalAddAtom(PChar(UC_GeneratePassword));

    // регистрация комбинации горячих клавиш
    Result := (FHotkeyID > 0) and
              Windows.RegisterHotKey(FHandle, FHotKeyID, Modifiers, Key);

    if not Result then UnRegisterHotkey;
  end;
end;

procedure TUcGlobalHotkey.SetHandle(const Value: HWND);
begin
  if FHandle <> Value then
  begin
    FHandle := Value;
    if FHotkeyID > 0 then
    begin
      UnRegisterHotkey;
      RegisterHotkey;
    end;
  end;
end;

procedure TUcGlobalHotkey.SetHotkey(const Value: TShortCut);
begin
  if FHotkey <> Value then
  begin
    FHotkey := Value;
    if FHotkeyID > 0 then
    begin
      UnRegisterHotkey;
      RegisterHotkey;
    end;
  end;
end;

procedure TUcGlobalHotkey.UnRegisterHotkey;
begin
  if FHotkeyID > 0 then
  begin
    Windows.UnRegisterHotKey(Handle, FHotkeyID); // удаляем комбинацию
    GlobalDeleteAtom(FHotkeyID); // удаляем атом
    FHotkeyID := 0;
  end;
end;

end.
