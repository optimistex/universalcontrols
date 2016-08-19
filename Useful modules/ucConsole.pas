// Версия - 30.06.2011
unit ucConsole;

interface

uses Windows, Classes, ucClasses, ucTypes;

type
  TUcConsole = class(TUcNotifyObject)
  private
    FLines : TStrings;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Lines : TStrings read FLines;
    procedure Execute(const CmdLine: string);
  end;


implementation

{ TUcConsole }

constructor TUcConsole.Create;
begin
  inherited;
  FLines := TStringList.Create;
end;

destructor TUcConsole.Destroy;
begin
  FLines.Free;
  inherited;
end;

procedure TUcConsole.Execute(const CmdLine: string);
const
  ReadBuffer = 2400;
var
  Security: TSecurityAttributes;
  ReadPipe, WritePipe: THandle;
  start: TStartUpInfo;
  ProcessInfo: TProcessInformation;
  Buf: RawByteString;
  BytesRead: DWord;
  Apprunning: Boolean;
  sMyBat : string;
begin
  FLines.Clear;
  with Security do
  begin
    nlength := SizeOf(TSecurityAttributes);
    binherithandle := true;
    lpsecuritydescriptor := nil;
  end;
  if Createpipe(ReadPipe, WritePipe,
    @Security, ReadBuffer) then
  begin
    FillChar(Start, Sizeof(Start), #0);
    start.cb := SizeOf(start);
    start.hStdOutput := WritePipe;
    start.hStdInput := ReadPipe;
    start.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
    start.wShowWindow := SW_HIDE;
    sMyBat := CmdLine;
    UniqueString(sMyBat);
    if CreateProcess(nil,
      PChar(sMyBat),
      @Security,
      @Security,
      true,
      NORMAL_PRIORITY_CLASS,
      nil,
      nil,
      start,
      ProcessInfo) then
    try
      SetLength(Buf, ReadBuffer);
//      while (WaitForSingleObject(ProcessInfo.hProcess, 1000) = WAIT_TIMEOUT) do
//      begin
      repeat
        Apprunning := WaitForSingleObject(ProcessInfo.hProcess, 1000) = WAIT_TIMEOUT;

        ReadFile(ReadPipe, Pointer(Buf)^, ReadBuffer - 1, BytesRead, nil);

        Buf[BytesRead + 1] := #0;

        OemToAnsi(PAnsiChar(Buf), PAnsiChar(Buf));
        FLines.Text := string(Buf);
        Notify;
      until not Apprunning;
//      end;
      FLines.Text := 'Проверка завершена.';
      Notify;
      SetLength(Buf, 0);
    finally
      CloseHandle(ProcessInfo.hProcess);
      CloseHandle(ProcessInfo.hThread);
    end;

    CloseHandle(ReadPipe);
    CloseHandle(WritePipe);
  end;
end;

end.
