// „уть более сложный пример - извлечение целой и дробной части числа
// –егул€рное выражение содержит группировки и альтернативу
program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  RegExpr in 'RegExpr.pas';

var
  RegExp: TRegExpr;
  s: string;

begin
  Write('Enter a string containing numbers: ');
  Readln(s);

  RegExp := TRegExpr.Create;

  try
    RegExp.Expression := '(\d+)([.,])(\d+)';
    if RegExp.Exec(s) then
    begin
      Writeln('Whole number: ', RegExp.Match[0]);
      Writeln('Integer part: ', RegExp.Match[1]);
      Writeln('Divider : ', RegExp.Match[2]);
      Writeln('Fractional part: ', RegExp.Match[3]);
      Writeln(RegExp.Substitute('$1$2$3'));
    end
    else
      Writeln('Entered string doesn''t contain any number!');
  finally
    RegExp.Free;
  end;
  Readln;
end.
