// Версия - 18.07.2013
unit ucFunctions;
{$include ..\delphi_ver.inc}

interface
uses Windows, Graphics, Messages, Forms, SysUtils, ExtCtrls, Controls, Classes, ActnList,
     FileCtrl, StdCtrls, RegStr, StrUtils, Math, md5, SZCRC32, Variants, DateUtils,
     ucWindows, ucTypes;

// Диалог выбора папки для объектов типа TCustomEdit
{$IFDEF DELPHI_2009_UP}
{$REGION 'Controls'}
/// <summary>Диалог выбора папки для объектов типа TCustomEdit</summary>
/// <param name="Edit">наследник от TCustomEdit</param>
/// <param name="Caption">подпись диалогового окна</param>
/// <param name="Options">опции (sdNewFolder, sdShowEdit, sdShowShares, sdNewUI, sdShowFiles, sdValidateDir)</param>
{$ENDREGION}
function UC_SelectDirectoryCEdit(Edit: TCustomEdit; const Caption: string;
                                 Options: TSelectDirExtOpts = [sdNewUI]): Boolean;
{$ENDIF}

{$IFDEF DELPHI_2009_UP}{$REGION 'Controls'}{$ENDIF}
/// <summary>
/// Для заданной группы элементов управления устанавливает заданное значение Enabled
/// </summary>
/// <param name="Value">значение Enabled</param>
/// <param name="Controls">массив наследников от TControl</param>
procedure UC_SetEnabled(Value: Boolean; Controls: array of TControl); overload;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Для заданной группы элементов управления устанавливает заданное
///	значение Enabled.Так же может управлять дочерними элементами.</summary>
///	<param name="Value">значение Enabled</param>
///	<param name="Recursive">позволяет установить значение Enabled для дочерних
///	компонент</param>
///	<param name="Controls">массив наследников от TControl</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
procedure UC_SetEnabledEx(Value, Recursive: Boolean; Controls: array of TControl); overload;

/// <summary>
/// Для заданной группы элементов управления устанавливает заданное значение Enabled
/// </summary>
/// <param name="Value">значение Enabled</param>
/// <param name="Controls">массив наследников от TAction</param>
procedure UC_SetEnabled(Value: Boolean; Controls: array of TAction); overload;

/// <summary>
/// Для заданной группы элементов управления инвертирует значение Enabled
/// </summary>
/// <param name="Controls">массив наследников от TControl</param>
procedure UC_InvertEnabled(Controls: array of TControl); overload;

/// <summary>
/// Для заданной группы элементов управления инвертирует значение Enabled
/// </summary>
/// <param name="Controls">массив наследников от TAction</param>
procedure UC_InvertEnabled(Controls: array of TAction); overload;

/// <summary>
/// Для заданной группы элементов управления устанавливает заданное значение Visible
/// </summary>
/// <param name="Value">значение Visible</param>
/// <param name="Controls">массив наследников от TControl</param>
procedure UC_SetVisible(Value: Boolean; Controls: array of TControl);

/// <summary>
/// Для заданной группы элементов управления инвертирует значение Visible
/// </summary>
/// <param name="Controls">массив наследников от TControl</param>
procedure UC_InvertVisible(Controls: array of TControl);

/// <summary>
/// Проверка TCustomEdit на ввод целого/дробного числа.
/// Вызывать нужно из обработчика OnChanged
/// </summary>
procedure UC_CheckEditScalar(Edit: TCustomEdit; Float: Boolean = False);
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}

{$IFDEF DELPHI_2009_UP}{$REGION 'Работа со строками'}{$ENDIF}
{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Собирает несколько строк в одну используя разделитель</summary>
///	<param name="Separator">разделитель</param>
///	<param name="Strings">набор строк</param>
///	<param name="Result">строка с разделителями</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_Implode(Separator: string; Strings: array of string): string; overload;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Собирает несколько строк в одну используя разделитель</summary>
///	<param name="Separator">Разделитель</param>
///	<param name="Strings">Список строк</param>
///	<param name="StartPos">Стартовая позиция</param>
///	<param name="EndPos">Конечная позиция</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_Implode(Separator: string; Strings: TStrings; StartPos: Integer = -1; EndPos: Integer = -1): string; overload;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Разбивает строку на массив строк по разделителю</summary>
///	<param name="Separator">разделитель</param>
///	<param name="Strings">исходная строка</param>
///	<param name="Result">массив строк</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_Explode(Separator, Str: string; MaxItemCount: Integer = -1): TStrArray;

function UC_QuotedStr(Str: string): string;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Сравнение версий</summary>
///	<example>
///	  <para>Ver1 = Ver2 =&gt; Result = 0</para>
///	  <para>Ver1 &gt; Ver2 =&gt; Result &gt; 0</para>
///	  <para>Ver1 &lt; Ver2 =&gt; Result &lt; 0</para>
///	</example>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_CompareVersions(Ver1, Ver2: string): Integer;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Генерация пароля. Пароль генерируется из набора символов:
///	'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'</summary>
///	<param name="PassLength">Требуемая длинна пароля. Если не задано, то
///	бередся от 5 до 20</param>
///	<param name="Result">сгенерированный пароль</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_GeneratePassword(PassLength: Integer = -1): string;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>
///	  <para>Вычисляет логическое выражение составленное из 1-2
///	  аргументов.</para>
///	  <para>Поддерживаемые операторы сравнения: &gt;, &lt;, &gt;=, &lt;=, =,
///	  &lt;&gt;</para>
///	</summary>
///	<param name="Expression">Логическое выражение</param>
///	<example>
///	  <para>Примеры выражений:</para>
///	  <para>true</para>
///	  <para>False</para>
///	  <para>True = false</para>
///	  <para>24 &gt;= 23.9999</para>
///	  <para>test1 &lt;&gt; test2</para>
///	</example>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_ExecuteBoolExpression(Expression: string): TBoolExpResult;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Переводит размер в байтах в более понятное человеку строковое
///	представление</summary>
///	<param name="Size">Размер в байтах</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function UC_ByteSizeToStr(Size: Int64): string;

function UC_DateTimeToSQL(V: TDateTime): string;
function UC_VarToSQLStr(Value: Variant): string;

{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}

{$IFDEF DELPHI_2009_UP}{$REGION 'Работа с датой'}{$ENDIF}

function UC_EncodeDateTime(DT: TDateTime): string;
function UC_DecodeDateTime(DTs: string): TDateTime;
function UC_DecodeDateTimeDef(DTs: string; DefDateTime: TDateTime): TDateTime;

function UC_EncodeDateTimeISO8601(DT: TDateTime): string;
function UC_DecodeDateTimeISO8601(DTs: string): TDateTime;
function UC_DecodeDateTimeISO8601Def(DTs: string; DefDateTime: TDateTime): TDateTime;


{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}

{$IFDEF DELPHI_2009_UP}{$REGION 'TPoint & TRect'}{$ENDIF}
function UC_RectWidth(R: TRect): Integer;
function UC_RectHeight(R: TRect): Integer;
function UC_RectIsEqual(R1, R2: TRect): Boolean;
function UC_PointInRect(P: TPoint; R: TRect): Boolean; deprecated {$IFDEF DELPHI_2009_UP}'PtInRect(const lprc: TRect; pt: TPoint): BOOL;'{$ENDIF};
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}

function UC_BmpToIco(Bitmap: TBitmap): HICON;

{$IFDEF DELPHI_2009_UP}{$REGION 'Обработка пути файла/каталога'}{$ENDIF}
/// <summary>
/// Преобразует пути вида "%WinDir%\system32" к виду "C:\Windows\system32"
/// </summary>
function UC_PrepareFilePath(const Path: string): string; deprecated {$IFDEF DELPHI_2009_UP}'UC_FitEnvironmentVariables(const Str: string): string;'{$ENDIF};


///	<summary>Функция преобразования строки с подстановкой значений переменных
///	среды. Доступные переменные можно посмотреть в командной строке вызвав
///	команду set (без параметров)</summary>
///	<param name="Str">Файловый путь вида: '%temp%\test</param>
///	<returns>Новый файловый путь с подставленными значениями</returns>
///	<example>Пример: ShowMessage(UC_PrepareFilePath('%temp%\test')); Получим:
///	C:\DOCUME~1\admin\LOCALS~1\Temp\test Если переменная temp не определена, то
///	маска %temp% будет удалена из строки</example>
function UC_FitEnvironmentVariables(const Str: string): string;

///	<summary>Проверяет полученный файловый путь, Является ли он корневым
///	каталогом диска?</summary>
///	<param name="Str">Файловый путь</param>
///	<returns>True - является корневой директорией диска</returns>
function UC_IsRootPath(Str: string): Boolean;

/// <summary>
/// Преобразует относительный буть в абсолютный. Расчет ведется по текущей рабочей папке
/// использует функцию UC_PrepareFilePath
/// </summary>
function UC_ExpandFileName(FileName: string): string;
//--
function UC_IsAbsolutePath(FileName: string): Boolean;
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}

{$IFDEF DELPHI_2009_UP}{$REGION 'MD5'}{$ENDIF}
function UC_MD5String(const S: RawByteString): string;
function UC_MD5File(const FileName: string): string;
function UC_MD5Stream(const Stream: TStream): string;
function UC_MD5Buffer(const Buffer; Size: Integer): string;
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}

{$IFDEF DELPHI_2009_UP}{$REGION 'CRC32'}{$ENDIF}
function UC_CRC32Stream(Stream: TStream): DWORD;
function UC_CRC32File(FileName: String): DWORD;
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}

implementation

{$IFDEF DELPHI_2009_UP}
function UC_SelectDirectoryCEdit(Edit: TCustomEdit; const Caption: string;
                                 Options: TSelectDirExtOpts = [sdNewUI]): Boolean;

  function GetExistsPath(Path: string): string;
  begin
    if (Path = '') or DirectoryExists(Path) then
      Result := Path
      else begin
        Result := ExtractFilePath(ExcludeTrailingBackslash(Path));
        if Result <> Path then
          Result := GetExistsPath(Result);
      end;
  end;

var Dir: string;
    Parent: TWinControl;
begin
  Dir := UC_ExpandFileName(GetExistsPath(Edit.Text));
  if Edit.Owner is TWinControl then
    Parent := TWinControl(Edit.Owner)
    else
    Parent := Edit.Parent;

  Result := SelectDirectory(Caption, '', Dir, Options, Parent);
  if Result then
    Edit.Text := Dir;
end;
{$ENDIF}

procedure UC_SetEnabled(Value: Boolean; Controls: array of TControl);
var i: Integer;
begin
  for i := 0 to High(Controls) do
    Controls[i].Enabled := Value;
end;

procedure UC_SetEnabled(Value: Boolean; Controls: array of TAction);
var i: Integer;
begin
  for i := 0 to High(Controls) do
    Controls[i].Enabled := Value;
end;

procedure UC_SetEnabledEx(Value, Recursive: Boolean; Controls: array of TControl);
var i, j: Integer;
begin
  for i := 0 to High(Controls) do
  begin
    Controls[i].Enabled := Value;
    if Recursive and (Controls[i] is TWinControl) then
      for j := 0 to TWinControl(Controls[i]).ControlCount - 1 do
        UC_SetEnabledEx(Value, Recursive, [TWinControl(Controls[i]).Controls[j]]);
  end;
end;

procedure UC_InvertEnabled(Controls: array of TControl);
var i: Integer;
begin
  for i := 0 to High(Controls) do
    Controls[i].Enabled := not Controls[i].Enabled;
end;

procedure UC_InvertEnabled(Controls: array of TAction);
var i: Integer;
begin
  for i := 0 to High(Controls) do
    Controls[i].Enabled := not Controls[i].Enabled;
end;

procedure UC_SetVisible(Value: Boolean; Controls: array of TControl);
var i: Integer;
begin
  for i := 0 to High(Controls) do
    Controls[i].Visible := Value;
end;

procedure UC_InvertVisible(Controls: array of TControl);
var i: Integer;
begin
  for i := 0 to High(Controls) do
    Controls[i].Visible := not Controls[i].Visible;
end;

procedure UC_CheckEditScalar(Edit: TCustomEdit; Float: Boolean = False);
var i, s1, s2, n: integer;
    s: string;
    Chars: TSysCharSet;
    FindDiv: Boolean;

  {$IFNDEF DELPHI_2009_UP}
  function  CharInSet(Chr: Char; CharSet: TSysCharSet): Boolean;
  begin
    Result := Chr in CharSet;
  end;
  {$ENDIF}

begin
  s := Edit.Text;
  i := 1; n := 0;
  if Float then
    Chars := ['-', '0'..'9', ',']
    else
    Chars := ['-', '0'..'9'];
  FindDiv := false;
  while i <= Length(s) do
    if CharInSet(s[i], Chars)and
       ((s[i] <> ',') or (not FindDiv))and
       ((s[i] <> '-') or (i = 1)) then
      begin
        if s[i] = ',' then FindDiv := true;
        Inc(i);
      end else
      begin
        Delete(s, i, 1);
        Inc(n);
      end;
  if s <> Edit.Text then
  begin
    s1 := Edit.SelStart;
    s2 := Edit.SelLength;
    Edit.Text := s;
    Edit.SelStart  := s1 - n;
    Edit.SelLength := s2;
    Beep;
  end;
end;

function UC_Implode(Separator: string; Strings: array of string): string; overload;
var Cnt, i, CharLen, SepLen, Len: Integer;
    Pc: PChar;
begin
  CharLen := SizeOf(Char);
  SepLen := Length(Separator);
  // Подготовка строки результата
  Cnt := Max(High(Strings), 0) * SepLen;
  for I := 0 to High(Strings) do
    Inc(Cnt, Length(Strings[i]));
  SetLength(Result, Cnt);
  // Заполнение строки результата
  Pc := @Result[1];
  for I := 0 to High(Strings) - 1 do
  begin
    Len := Length(Strings[i]);
    Move(Pointer(Strings[i])^, Pc^, Len * CharLen);
    Inc(Pc, Len);
    Move(Pointer(Separator)^, Pc^, SepLen * CharLen);
    Inc(Pc, SepLen);
  end;
  i := High(Strings);
  Move(Pointer(Strings[i])^, Pc^, Length(Strings[i]) * CharLen);
end;

function UC_Implode(Separator: string; Strings: TStrings; StartPos: Integer = -1; EndPos: Integer = -1): string; overload;
var Cnt, i, CharLen, SepLen, Len: Integer;
    Pc: PChar;
    SepCount: Integer;
    StartPos_: Integer;
    EndPos_: Integer;
begin
  // Определить границы
  Result := '';
  if StartPos > Strings.Count - 1 then Exit;

  StartPos_ := Max(StartPos, 0);

  if (EndPos < 0) then
    EndPos_ := Strings.Count - 1
  else
    EndPos_ := EndPos;

  EndPos_ := Min(EndPos_, Strings.Count - 1);

  if StartPos_ > EndPos_ then Exit;

  CharLen := SizeOf(Char);
  SepLen := Length(Separator);
  SepCount := EndPos_ - StartPos_;

  // Подготовка строки результата
  Cnt := Max(SepCount, 0) * SepLen;
  for I := StartPos_ to EndPos_ do
    Inc(Cnt, Length(Strings[i]));
  SetLength(Result, Cnt);

  // Заполнение строки результата
  Pc := @Result[1];
  for I := StartPos_ to EndPos_ - 1 do
  begin
    Len := Length(Strings[i]);
    Move(Pointer(Strings[i])^, Pc^, Len * CharLen);
    Inc(Pc, Len);
    Move(Pointer(Separator)^, Pc^, SepLen * CharLen);
    Inc(Pc, SepLen);
  end;
  i := EndPos_;
  Move(Pointer(Strings[i])^, Pc^, Length(Strings[i]) * CharLen);
end;

function UC_Explode(Separator, Str: string; MaxItemCount: Integer = -1): TStrArray;
var Cnt, n, p, Offset, SepLen: Integer;
begin
  SepLen := Length(Separator);
  // Определение требуемого количества элементов массива
  if MaxItemCount <= 0 then
  begin
    Cnt := 0;
    Offset := 1;
    repeat
      Inc(Cnt);
      p := PosEx(Separator, Str, Offset);
      Offset := p + SepLen;
    until p = 0;
  end else
    Cnt := MaxItemCount;
  // Инициализация массива
  SetLength(Result, 0); // Инициализация нового массива
  SetLength(Result, Cnt);
  // Парсинг входящей строки
  n := 0;
  Offset := 1;
  repeat
    p := PosEx(Separator, Str, Offset);
    if (p > 0) and (n < Cnt - 1) then
    begin
      Result[n] := Copy(Str, Offset, p - Offset);
      Inc(n);
    end else
    begin
      Result[n] := Copy(Str, Offset, Length(Str));
      Break;
    end;
    Offset := p + SepLen;
  until p = 0;
end;

function UC_QuotedStr(Str: string): string;
begin
  if Str = '' then
    Result := ''
    else
    Result := '"' + Str + '"';
end;

function UC_CompareVersions(Ver1, Ver2: string): Integer;
var V1, V2: TStrArray;
    Cnt, n: Integer;
begin
  Result := 0;
  V1 := UC_Explode('.', Ver1);
  V2 := UC_Explode('.', Ver2);

  Cnt := Min(High(V1), High(V2));
  if Cnt > 0 then
  begin
    n := 0;
    while (n <= Cnt) and (Result = 0) do
    begin
      Result := StrToIntDef(V1[n], 0) - StrToIntDef(V2[n], 0);
      Inc(n);
    end;
  end else
  begin
    Result := CompareText(Ver1, Ver2);
  end;
end;

function UC_GeneratePassword(PassLength: Integer = -1): string;
              // Символы, которые будут использоваться в пароле.
const Chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
var Size, i: Integer;
begin
  // Если длинна пароля не задана, то выберем длинну в диапазоне [5, 20]
  if PassLength < 0 then PassLength := 5 + Random(16);

  // Определяем количество символов в $chars
  Size := Length(Chars);

  SetLength(Result, PassLength);
  // Создаём пароль.
  for i := 1 to PassLength do
    Result[i] := Chars[1 + Random(Size)];
end;

function UC_ExecuteBoolExpression(Expression: string): TBoolExpResult;

  function CompareFloats(V1, V2: Extended): Integer;
  begin
    if V1 = V2 then
      Result := 0
    else if V1 > V2 then
      Result := 1
      else
      Result := -1;
  end;

var Args: TStrArray;
    BoolOp:  string;
    i, CompRes: Integer;
    NeedBreak, BoolRes: Boolean;
    fV1, fV2: Extended;
    bV1, bV2: Boolean;
begin
  Result := berFalse;
  // Определяем булеву операцию
  BoolOp := '';
  NeedBreak := False;
  i := 1;
  while i <= Length(Expression) do
  begin
    while Pos(Expression[i], '><=') > 0 do
    begin
      BoolOp := BoolOp + Expression[i];
      NeedBreak := True;
      inc(i);
    end;

    if NeedBreak then Break;
    Inc(i);
  end;
  // Получаем части выражения
  Args := UC_Explode(BoolOp, Expression);
  case Length(Args) of
    // Обработка логического выражения из 1-го элемента
    1: begin
      Args[0] := Trim(Args[0]);
      if not TryStrToBool(Args[0], BoolRes) then
        Result := berError;
    end;

    // Обработка логического выражения из 2-х элементов
    2: begin
      Args[0] := Trim(Args[0]);
      Args[1] := Trim(Args[1]);

      if TryStrToFloat(Args[0], fV1) and TryStrToFloat(Args[1], fV2) then
        CompRes := CompareFloats(fV1, fV2)
      else if TryStrToBool(Args[0], bV1) and TryStrToBool(Args[1], bV2) then
        CompRes := Integer(bV1) - Integer(bV2)
      else
        CompRes := CompareText(Args[0], Args[1]);

      //----------
      if BoolOp = '>='      then BoolRes := CompRes >= 0
      else if BoolOp = '<=' then BoolRes := CompRes <= 0
      else if BoolOp = '<>' then BoolRes := CompRes <> 0
      else if BoolOp = '>'  then BoolRes := CompRes > 0
      else if BoolOp = '<'  then BoolRes := CompRes < 0
      else if BoolOp = '='  then BoolRes := CompRes = 0
      else Result := berError;
    end;

    // Выводим ошибку если нет аргументов выражения или их более 2-х
    else Result := berError;
  end;

  if Result <> berError then
    if BoolRes then
      Result := berTrue
      else
      Result := berFalse;
end;

function UC_ByteSizeToStr(Size: Int64): string;
begin
  if (Size <= 900) then
    Result := Format('%d B', [Size])
  else if (Size > 900) and (Size <= 946176) then
    Result := FormatFloat('0.00 KB', Size/1024)
  else if (Size > 946176) and (Size <= 968884224) then
    Result := FormatFloat('0.00 MB', Size/1048576)
  else if (Size > 968884224) then
    Result := FormatFloat('0.00 GB', Size/1073741824);
end;

function UC_DateTimeToSQL(V: TDateTime): string;
var s: string;
begin
  s:= FormatDateTime('mm/dd/yyyy hh:mm:ss',V);
  s[3]:= '/'; s[6]:= '/';
  Result:= s;
end;

function UC_VarToSQLStr(Value: Variant): string;
begin
  case VarType(Value) of
    varNull, varEmpty                 : Result:='null';
    varSmallint, varInteger, varInt64,
      varShortInt, varByte, varWord,
      varLongWord                     : Result:=IntToStr(Value);
    varSingle, varDouble, varCurrency : Result:=StringReplace(FloatToStr(Value),',','.',[]);
    varDate                           : Result:=''''+UC_DateTimeToSQL(TDateTime(Value))+'''';
    varOleStr, varStrArg,
  {$IFDEF DELPHI_2009_UP}
      varUString,
  {$ENDIF}
      varString                       : Result:=IfThen(Value='null',Value,QuotedStr(Value));
    varBoolean                        : Result:=IfThen(Value, '1', '0');
    else begin
      Result:='null';
      raise Exception.Create('Не поддерживаемый тип данных!!!');
    end;
  end;
end;

function UC_EncodeDateTime(DT: TDateTime): string;
begin
  Result := FormatDateTime('dd.mm.yyyy hh:nn:ss', DT);
end;

function UC_TryDecodeDateTime(DTs: string; out DT: TDateTime): Boolean;
var DTarr, DTarrD, DTarrT: TStrArray;
begin
  DTarr  := UC_Explode(' ', DTs, 2);
  DTarrD := UC_Explode('.', DTarr[0], 3);
  DTarrT := UC_Explode(':', DTarr[1], 3);

  Result := TryEncodeDateTime(
    StrToIntDef(DTarrD[2], 0), StrToIntDef(DTarrD[1], 0), StrToIntDef(DTarrD[0], 0),
    StrToIntDef(DTarrT[0], 0), StrToIntDef(DTarrT[1], 0), StrToIntDef(DTarrT[2], 0),
    0, DT
  );
end;

function UC_DecodeDateTime(DTs: string): TDateTime;
begin
  if not UC_TryDecodeDateTime(DTs, Result) then
    raise Exception.CreateFmt('Invalid date/time: %s.', [DTs]);
end;

function UC_DecodeDateTimeDef(DTs: string; DefDateTime: TDateTime): TDateTime;
begin
  if not UC_TryDecodeDateTime(DTs, Result) then
    Result := DefDateTime;
end;

function UC_EncodeDateTimeISO8601(DT: TDateTime): string;
begin
  Result := FormatDateTime('yyyymmdd"T"hh:nn:ss', DT);
end;

function UC_TryDecodeDateTimeISO8601(DTs: string; out DT: TDateTime): Boolean;
begin
  Result := (Copy(DTs, 9, 1) = 'T') and
      (TryEncodeDateTime(
        StrToIntDef(Copy(DTs, 1, 4), 0), StrToIntDef(Copy(DTs, 5, 2), 0), StrToIntDef(Copy(DTs, 7, 2), 0),
        StrToIntDef(Copy(DTs, 10, 2), 0), StrToIntDef(Copy(DTs, 13, 2), 0), StrToIntDef(Copy(DTs, 16, 2), 0),
        0, DT
       ));
end;

function UC_DecodeDateTimeISO8601(DTs: string): TDateTime;
begin
  if not UC_TryDecodeDateTimeISO8601(DTs, Result) then
    raise Exception.CreateFmt('Invalid ISO-8601 date/time: %s.', [DTs]);
end;

function UC_DecodeDateTimeISO8601Def(DTs: string; DefDateTime: TDateTime): TDateTime;
begin
  if not UC_TryDecodeDateTimeISO8601(DTs, Result) then
    Result := DefDateTime;
end;

function UC_RectIsEqual(R1, R2: TRect): Boolean;
begin
  Result := (R1.Left = R2.Left) and (R1.Right = R2.Right) and
            (R1.Top = R2.Top) and (R1.Bottom = R2.Bottom);
end;

function UC_PointInRect(P: TPoint; R: TRect): Boolean;
begin
//  Result := (R.Left <= P.X)and(P.X <= R.Right)and
//            (R.Top <= P.Y)and(P.Y <= R.Bottom);
  Result := PtInRect(R, P);
end;

function UC_BmpToIco(Bitmap: TBitmap): HICON;
var IconInfo: TIconInfo;
    bmask: TBitmap;
begin
    bmask := TBitmap.Create;
    try
      bmask.Monochrome := True;
      bmask.HandleType := bmDIB;
      bmask.Width := Bitmap.Width;
      bmask.Height := Bitmap.Height;
      bmask.Canvas.Brush.Color := Bitmap.TransparentColor;
      bmask.Canvas.FillRect(RECT(0,0,bmask.Width,bmask.Height));

      IconInfo.fIcon := False;
      IconInfo.hbmColor := Bitmap.Handle;
      IconInfo.hbmMask := bmask.Handle;
      IconInfo.xHotspot := 0;
      IconInfo.yHotspot := 0;
      Result := CreateIconIndirect(IconInfo);
    finally
      bmask.Free;
    end;
end;

function UC_RectWidth(R: TRect): Integer;
begin
  Result := R.Right - R.Left;
end;

function UC_RectHeight(R: TRect): Integer;
begin
  Result := R.Bottom - R.Top;
end;

function UC_PrepareFilePath(const Path: string): string;
begin
  Result := UC_FitEnvironmentVariables(Path);
end;

function UC_FitEnvironmentVariables(const Str: string): string;

  function GetCSIDLString(CSIDL_Name: string; var CSIDL_Value: string): Boolean;
  var i: Integer;
  begin
    Result := False;
    CSIDL_Name := UpperCase(CSIDL_Name);
    for i := 0 to High(CSIDL_Consts) do
      if CSIDL_Consts[i].Name = CSIDL_Name then
      begin
        CSIDL_Value := UC_ShGetSpecialFolderLocation(CSIDL_Consts[i].Value);
        Result := True;
        Break;
      end;
  end;

var VarName, VarVal: string;
    Div1, Div2, Start: Integer;
begin
  Result := Str;
  Start  := 1;
  repeat
    Div1 := PosEx('%', Result, Start);
    if Div1 > 0 then
    begin
      Div2 := PosEx('%', Result, Div1 + 1);
      if Div2 > Div1 then
      begin
        VarName := Copy(Result, Div1 + 1, Div2 - 1 - Div1);

        if not GetCSIDLString(VarName, VarVal) then
          VarVal := UC_GetEnvironmentVariable(VarName);
        Result := StringReplace(Result, '%' + VarName + '%', VarVal,
          [rfIgnoreCase]);

        Start := Div2 + Length(VarVal) - Length(VarName) - 2;
      end
      else
        Start := 1;
    end;
  until (Div1 = 0) or (Start = 1);
end;

function UC_IsRootPath(Str: string): Boolean;
begin
  Str := StringReplace(IncludeTrailingBackslash(Str), PathDelim + PathDelim,
                       PathDelim, [rfReplaceAll]);
  Result := Length(Str) = Length(IncludeTrailingBackslash(ExtractFileDrive(Str)));
end;

function UC_ExpandFileName(FileName: string): string;
begin
  if (FileName <> '')and(FileName[1] = '%') then
    Result := UC_FitEnvironmentVariables(FileName)
    else
    Result := ExpandFileName(FileName);
end;

function UC_IsAbsolutePath(FileName: string): Boolean;
begin
  Result := (FileName <> '') and (
              (FileName[1] = '%') or
              (ExtractFileDrive(FileName) <> '')
            );
end;


{ MD5 }
// вычисление хеш-суммы для строки
function UC_MD5String(const S: RawByteString): string;
begin
  Result := string(MD5DigestToStr(MD5String(S)));
end;

// вычисление хеш-суммы для файла
function UC_MD5File(const FileName: string): string;
begin
  Result := string(MD5DigestToStr(MD5File(FileName)));
end;

// вычисление хеш-суммы для содержиого потока Stream
function UC_MD5Stream(const Stream: TStream): string;
begin
  Result := string(MD5DigestToStr(MD5Stream(Stream)));
end;

// вычисление хеш-суммы для произвольного буфера
function UC_MD5Buffer(const Buffer; Size: Integer): string;
begin
  Result := string(MD5DigestToStr(MD5Buffer(Buffer, Size)));
end;

{ CRC32 }
function UC_CRC32Stream(Stream: TStream): DWORD;
begin
  Result := SZCRC32FullStream(Stream);
end;

function UC_CRC32File(FileName: String): DWORD;
begin
  if FileExists(FileName) then
  begin
    try
      Result := SZCRC32File(FileName);
    except
      Result := 0;
    end;
  end else
    Result := 0;
end;
//**


end.
