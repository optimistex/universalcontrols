// Версия - 29.03.2012
{
/**********************************************************\
|                                                          |
| The implementation of PHPRPC Protocol 3.0                |
|                                                          |
| XXTEA.pas                                                |
|                                                          |
| Release 3.0.1                                            |
| Copyright by Team-PHPRPC                                 |
|                                                          |
| WebSite:  http://www.phprpc.org/                         |
|           http://www.phprpc.net/                         |
|           http://www.phprpc.com/                         |
|           http://sourceforge.net/projects/php-rpc/       |
|                                                          |
| Authors:  Ma Bingyao <andot@ujn.edu.cn>                  |
|                                                          |
| This file may be distributed and/or modified under the   |
| terms of the GNU Lesser General Public License (LGPL)    |
| version 3.0 as published by the Free Software Foundation |
| and appearing in the included file LICENSE.              |
|                                                          |
\**********************************************************/

/* XXTEA encryption arithmetic library.
 *
 * Copyright: Ma Bingyao <andot@ujn.edu.cn>
 * Version: 3.1
 * LastModified: Dec 28, 2008
 * This library is free.  You can redistribute it and/or modify it.
 */
}

unit ucXXTEA;
{$include ..\delphi_ver.inc}

interface
uses Classes, SysUtils, ucTypes;

function xxtea_encrypt(const data:RawByteString; const key:RawByteString): RawByteString; overload;
function xxtea_encrypt(data: TStream; const key:RawByteString): Boolean; overload;

{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Проверяет зашифрован ли поток. Корректно работает только после
///	шифрования потока функцией: xxtea_encrypt_ex</summary>
///	<param name="data">Проверяемый поток</param>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function xxtea_stream_encrypted(data: TStream): Boolean;
{$IFDEF DELPHI_2009_UP}{$REGION 'Documentation'}{$ENDIF}
///	<summary>Шифрование потока с добавлением заголовка - признака
///	шифрования</summary>
{$IFDEF DELPHI_2009_UP}{$ENDREGION}{$ENDIF}
function xxtea_encrypt_ex(data: TStream; const key:RawByteString): Boolean; overload;

function xxtea_decrypt(const data:RawByteString; const key:RawByteString): RawByteString; overload;
function xxtea_decrypt(data: TStream; const key:RawByteString): Boolean; overload;

{$IFDEF DELPHI_2009_UP}
function xxtea_encrypt(const data, key: string): string; overload;
function xxtea_decrypt(const data, key: string): string; overload;
{$ENDIF}



implementation

type
  TLongWordDynArray = array of LongWord;
  TEncryptHeader = record
    Byte1, Byte2: Byte;
  end;

const
  delta:LongWord = $9e3779b9;
  EncryptHeader: TEncryptHeader = (Byte1: $63; Byte2: $03);

function StrToArray(const data:RawByteString; includeLength:Boolean):TLongWordDynArray;
var
  n, i:LongWord;
begin
  n := Length(data);
  if ((n and 3) = 0) then n := n shr 2 else n := (n shr 2) + 1;
  if (includeLength) then begin
    setLength(result, n + 1);
    result[n] := Length(data);
  end else begin
    setLength(result, n);
  end;
  n := Length(data);
  for i := 0 to n - 1 do begin
    result[i shr 2] := result[i shr 2] or (($000000ff and ord(data[i + 1])) shl ((i and 3) shl 3));
  end;
end;

function ArrayToStr(const data:TLongWordDynArray; includeLength:Boolean):RawByteString;
var
  n, m, i:LongWord;
begin
  n := Length(data) shl 2;
  if (includeLength) then begin
    m := data[Length(data) - 1];
    if (m > n) then begin
      result := '';
      exit;
    end else begin
      n := m;
    end;
  end;
  SetLength(result, n);
  for i := 0 to n - 1 do begin
    result[i + 1] := AnsiChar((data[i shr 2] shr ((i and 3) shl 3)) and $ff);
  end;
end;

function XXTeaEncrypt(var v:TLongWordDynArray; var k:TLongWordDynArray):TLongWordDynArray;
var
  n, z, y, sum, e, p, q:LongWord;
  function mx : LongWord;
  begin
    result := (((z shr 5) xor (y shl 2)) + ((y shr 3) xor (z shl 4))) xor ((sum xor y) + (k[p and 3 xor e] xor z));
  end;
begin
  n := Length(v) - 1;
  if (n < 1) then begin
    result := v;
    exit;
  end;
  if Length(k) < 4 then setLength(k, 4);
  z := v[n];
  y := v[0];
  sum := 0;
  q := 6 + 52 div (n + 1);
  repeat
    inc(sum, delta);
    e := (sum shr 2) and 3;
    for p := 0 to n - 1 do begin
      y := v[p + 1];
      inc(v[p], mx());
      z := v[p];
    end;
    p := n;
    y := v[0];
    inc(v[p], mx());
    z := v[p];
    dec(q);
  until q = 0;
  result := v;
end;

function XXTeaDecrypt(var v:TLongWordDynArray; var k:TLongWordDynArray):TLongWordDynArray;
var
  n, z, y, sum, e, p, q:LongWord;
  function mx : LongWord;
  begin
    result := (((z shr 5) xor (y shl 2)) + ((y shr 3) xor (z shl 4))) xor ((sum xor y) + (k[p and 3 xor e] xor z));
  end;
begin
  n := Length(v) - 1;
  if (n < 1) then begin
    result := v;
    exit;
  end;
  if Length(k) < 4 then setLength(k, 4);
  z := v[n];
  y := v[0];
  q := 6 + 52 div (n + 1);
  sum := q * delta;
  while (sum <> 0) do begin
    e := (sum shr 2) and 3;
    for p := n downto 1 do begin
      z := v[p - 1];
      dec(v[p], mx());
      y := v[p];
    end;
    p := 0;
    z := v[n];
    dec(v[0], mx());
    y := v[0];
    dec(sum, delta);
  end;
  result := v;
end;

function xxtea_encrypt(const data:RawByteString; const key:RawByteString):RawByteString;
var
  v, k:TLongWordDynArray;
begin
  if (Length(data) = 0) then exit;
  v := StrToArray(data, true);
  k := StrToArray(key, false);
  result := ArrayToStr(XXTeaEncrypt(v, k), false);
end;



{$IFDEF DELPHI_2009_UP}
function xxtea_encrypt(const data, key: string): string; overload;
begin
  Result := string(xxtea_encrypt(RawByteString(data), RawByteString(key)));
end;

function xxtea_decrypt(const data, key:String): String; overload;
begin
  Result := string(xxtea_decrypt(RawByteString(data), RawByteString(key)));
end;
{$ENDIF}

function xxtea_encrypt(data: TStream; const key:RawByteString): Boolean;
var v: RawByteString;
begin
  Result := data.Size > 0;
  if Result then
  begin
    try
      SetLength(v, data.Size);
      data.Position := 0;
      data.Read(Pointer(v)^, data.Size);
      v := xxtea_encrypt(v, key);
      data.Size := 0;
      data.Write(Pointer(v)^, Length(v));
    except
      Result := False;
    end;
  end;
end;

function xxtea_stream_encrypted(data: TStream): Boolean;
var H: TEncryptHeader;
begin
  data.Position := 0;
  data.Read(H, SizeOf(H));
  Result := CompareMem(@H, @EncryptHeader, SizeOf(EncryptHeader));
end;

function xxtea_encrypt_ex(data: TStream; const key:RawByteString): Boolean; overload;
var v: RawByteString;
begin
  Result := data.Size > 0;
  if Result then
  begin
    try
      // Проверка заголовка
      Result := not xxtea_stream_encrypted(data);

      if Result then
      begin
        // Шифрование
        SetLength(v, data.Size);
        data.Position := 0;
        data.Read(Pointer(v)^, data.Size);
        v := xxtea_encrypt(v, key);
        data.Size := 0;
        // Вставка заголовка
        data.Write(EncryptHeader, SizeOf(EncryptHeader));
        //**
        data.Write(Pointer(v)^, Length(v));
      end;
    except
      Result := False;
    end;
  end;
end;

function xxtea_decrypt(const data:RawByteString; const key:RawByteString):RawByteString;
var
  v, k:TLongWordDynArray;
begin
  if (Length(data) = 0) then exit;
  v := StrToArray(data, false);
  k := StrToArray(key, false);
  result := ArrayToStr(XXTeaDecrypt(v, k), true);
end;

function xxtea_decrypt(data: TStream; const key:RawByteString): Boolean;
var v: RawByteString;
begin
  Result := data.Size > 0;
  if Result then
  begin
    try
      // Дешифровка
      if xxtea_stream_encrypted(data) then
      begin
        SetLength(v, data.Size - SizeOf(TEncryptHeader))
      end else
      begin
        SetLength(v, data.Size);
        data.Position := 0;
      end;

      data.Read(Pointer(v)^, Length(v));
      v := xxtea_decrypt(v, key);
      data.Size := 0;
      data.Write(Pointer(v)^, Length(v));
    except
      Result := False;
    end;
  end;
end;

end.
