// Версия - 20.01.2012
unit ucZibProcs;
{$include ..\delphi_ver.inc}

interface

Uses Classes, ZLib, SysUtils;

{
Compress = true  //надо сжать
Compress = false //надо распаковать
}
{$IFDEF DELPHI_2009_UP}
function UC_ZIP(Stream: TStream; Compress: boolean): Boolean;
{$ELSE}
function UC_ZIP(Stream: TStream; Compress: boolean): Boolean;
{$ENDIF}
function ZIP(Stream: TStream; Compress: boolean): Boolean; deprecated {$IFDEF DELPHI_2009_UP}'use UC_ZIP'{$ENDIF};

implementation

{$IFDEF DELPHI_2009_UP}
function UC_ZIP(Stream: TStream; Compress: boolean): Boolean;
  function StreamCompressed(Strm: TStream): Boolean;
  { zlib header
    Он содержит 2 байта: 0x78, 0x01 [5, ch 2.2]
    0х78 означает, что для компрессии данных используется DEFLATE с окном до 32 КБайт.
    0х01 содержит проверочный бит для первого байта и определяет уровень сжатия "без сжатия" ;)}
  const IsCompressed    = $78; // 1-й байт - признак компрессии
        CompressLvlNone = 1;   //
        CompressLvlDef  = $9C; //  2-й байт
        CompressLvlFast = 1;   //  пределяет уровень сжатия
        CompressLvlMax  = $DA; //
  var H: record
        Byte1, Byte2: Byte;
      end;
  begin
    Strm.Position := 0;
    Strm.Read(H, SizeOf(Byte) * 2);
    Strm.Position := 0;
    Result := (H.Byte1 = IsCompressed)
                and
              (H.Byte2 in [CompressLvlNone, CompressLvlDef,
                           CompressLvlFast, CompressLvlMax]);
  end;

var MyStream : TMemoryStream;
    Compressed: Boolean;
begin
  Result := False;
  MyStream := TMemoryStream.Create;
  try
    try
      Compressed := StreamCompressed(Stream);

      if Compress and (not Compressed) then
        ZCompressStream(Stream, MyStream, zcMax);

      if (not Compress) and Compressed then
        ZDecompressStream(Stream, MyStream);

      Result := (Compress and (not Compressed))or((not Compress) and Compressed);
    except
    end;

//    if MyStream.Size > 0 then
    if Result then
    begin
      MyStream.position := 0;
      Stream.Size := 0;
      MyStream.SaveToStream(Stream);
      Stream.position := 0;
    end;
  finally
    MyStream.Free;
  end;
end;

{$ELSE}

function UC_ZIP(Stream: TStream; Compress: boolean): Boolean;
var
  MyStream: tmemorystream;

  function decompressstream(inpstream, outstream: tstream): Boolean;
  var
    inpbuf, outbuf: pointer;
    outbytes, sz: integer;
  begin
    inpbuf := nil;
    outbuf := nil;
    inpstream.position := 0; // !!!
    sz := inpstream.size - inpstream.position;
    Result := sz > 0;
    if Result then
    try
      try
        getmem(inpbuf, sz);
        inpstream.read(inpbuf^, sz);
        decompressbuf(inpbuf, sz, 0, outbuf, outbytes); //fehler ?!
        outstream.write(outbuf^, outbytes);
      finally
        if inpbuf <> nil then
          freemem(inpbuf);
        if outbuf <> nil then
          freemem(outbuf);
      end;
    except
      Result := false;
    end;
    outstream.position := 0;
  end;

  function compressstream(inpstream, outstream: tstream): Boolean;
  var
    inpbuf, outbuf: pointer;
    inpbytes, outbytes: integer;
  begin
    Result := true;
    inpbuf := nil;
    outbuf := nil;
    try
      try
        getmem(inpbuf, inpstream.size);
        inpstream.position := 0;
        inpbytes := inpstream.read(inpbuf^, inpstream.size);
        compressbuf(inpbuf, inpbytes, outbuf, outbytes); //fehler ?!
        outstream.write(outbuf^, outbytes);
      finally
        if inpbuf <> nil then
          freemem(inpbuf);
        if outbuf <> nil then
          freemem(outbuf);
      end;
    except
      Result := false;
    end;
  end;

begin
  MyStream := tmemorystream.create;
  try
    if Compress then
      Result := compressstream(stream, MyStream)
    else
      Result := decompressstream(stream, MyStream);

    if Result then
    begin
      MyStream.position := 0;
      Stream.Size := 0;
      MyStream.SaveToStream(Stream);
      Stream.position := 0;
    end;
  finally
    MyStream.Free;
  end;
end;
{$ENDIF}

function ZIP(Stream: TStream; Compress: boolean): Boolean;
begin
  Result := UC_ZIP(Stream, Compress);
end;

end.
