// Версия - 30.06.2011
unit ucMasks;
{$include ..\delphi_ver.inc}

interface

uses Masks, ucFunctions, ucTypes;

type
  TUcMask = class
  private
    fMasks: array of TMask;
    fDivider: Char;
    fMask: string;
    procedure FreeMasks;
  public
    destructor Destroy; override;

    /// <summary>
    /// Класс проверки текста по маске с использованием символов *?
    /// <param name="MaskValue">Строка маски</param>
    /// <param name="DividerValue">Разделитель маски (для масок типа '*.jpeg;*.jpg')</param>
    /// </summary>
    procedure SetMask(MaskValue: string; DividerValue: Char = #0);
    /// <summary>
    /// Сравнение текста с маской
    /// <param name="TextForCheck">текст для сравнения с маской</param>
    /// <returns>True - если проверка прошла успешно</returns>
    /// </summary>
    function Matches(const TextForCheck: string): Boolean;
    property Mask: string read fMask;
    property DividerMask: Char read fDivider;
  end;

  function UC_MatchesMask(const Filename, Mask: string; DividerValue: Char = #0): Boolean;

implementation

{ TUcMask }

procedure TUcMask.FreeMasks;
var i: Integer;
begin
  for i := 0 to High(fMasks) do fMasks[i].Free;
  SetLength(fMasks, 0);
end;

destructor TUcMask.Destroy;
begin
  FreeMasks;
  inherited;
end;

function TUcMask.Matches(const TextForCheck: string): Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to High(fMasks) do
    if fMasks[i].Matches(TextForCheck) then
    begin
      Result := True;
      Break;
    end;
end;

procedure TUcMask.SetMask(MaskValue: string; DividerValue: Char);
var sa: TStrArray;
    i: Integer;
begin
  if (fMask <> MaskValue) or (fDivider <> DividerValue) then
  begin
    fDivider := DividerValue;
    fMask    := MaskValue;

    SetLength(sa, 0); // Уходим от Warning -а
    sa := UC_Explode(fDivider, fMask);
    FreeMasks;
    SetLength(fMasks, High(sa) + 1);
    for i := 0 to High(sa) do
      fMasks[i] := TMask.Create(sa[i]);
  end;
end;

function UC_MatchesMask(const Filename, Mask: string; DividerValue: Char = #0): Boolean;
var
  CMask: TUcMask;
begin
  CMask := TUcMask.Create;
  try
    CMask.SetMask(Mask, DividerValue);
    Result := CMask.Matches(Filename);
  finally
    CMask.Free;
  end;
end;

end.
