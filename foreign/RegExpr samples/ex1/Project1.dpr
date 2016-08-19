// ќчень простой пример - извлечение чисел из введЄнной строки.
program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  // добавл€ем нужный модуль
  RegExpr in 'RegExpr.pas';

var
  // нам необходим экземпл€р класса TRegExpr
  RegExp: TRegExpr;
  s: string;
  
begin
  // выводим запрос и считываем строку
  Write('Enter a string containing numbers: ');
  Readln(s);

  // создаЄм объект
  RegExp := TRegExpr.Create;

  // гарантирует освобождение зан€той объектом пам€ти
  try
    // регул€рное выражение находитс€ в свойстве Expression
    RegExp.Expression := '-?\d+';
    // ищем первое совпадение с помощью функции
    // Exec(const AInputString : string) : boolean, котора€ вернет true,
    // если в строке AInputString будет найдено совпадение c
    // регул€рным выражением, хран€щимс€ в свойтве Expression
    if RegExp.Exec(s) then
    // если находим
    begin
      Writeln('Entered string contains numbers: ');
      repeat
      // выводим найденное выражение, которое хранитс€ в Match[0]
        Writeln(RegExp.Match[0]);
      // и продолжаем поиск
      until not RegExp.ExecNext;
    end
    else
    // иначе - сообщаем, что ничего не нашли
      Writeln('Entered string contains no numbers!');
  finally
    RegExp.Free;
  end;
  Readln;
end.
