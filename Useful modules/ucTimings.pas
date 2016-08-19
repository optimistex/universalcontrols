////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                            Sanders the Softwarer                           //
//                                                                            //
//             Вспомогательный модуль для замеров временных затрат            //
//                 при исполнении отдельных участков программ                 //
//                                                                            //
///////////////////////////////////////////////// Author Sanders Prostorov /////

{ ----- Официоз ----------------------------------------------------------------

Любой желающий может распространять этот модуль, дорабатывать его, использовать
в собственных программных проектах, в том числе коммерческих, без необходимости
в дополнительных разрешениях от автора. В любой версии модуля должна сохраняться
информация об авторских правах и условиях распространения модуля.

При распространении доработанных версий модуля прошу изменить имя модуля и
базового класса для предотвращения коллизий между доработками различных авторов.

Если Вы сделали интересную доработку и согласны распространять ее на этих
условиях - сообщите о ней, и мы обговорим включение Вашей доработки в авторскую
версию модуля. Также прошу сообщать о найденных ошибках, если такие будут.

Автор: Sanders Prostorov, 2:5020/1583, softwarer@mail.ru, softwarer@nm.ru

------------------------------------------------------------------------------ }

{ ----- Применение модуля ------------------------------------------------------

Модуль позволяет замерить время исполнения различных участков программы. Для
этого каждый замеряемый участок следует окружить вызовами методов Timing.Start
и Timing.Finish, например:

procedure DoSomething ;
begin
  Timing.Start ( 1, 'Обработка' ) ;
  Process ;
  Timing.Finish ( 1 ) ;
end ;

Таймеры, поддерживаемые модулем, нумеруются - в данном случае используется
таймер номер 1. В принципе можно использовать любые номера, но таймеры хранятся
в динамическом массиве и поэтому использование больших номеров вызовет напрасный
расход памяти.

С помощью разных таймеров можно параллельно замерять времена исполнения разных
участков - скажем, подпрограмма Process может использовать таймеры 2..N для
замера времени выполнения различных своих частей.

Корректно поддерживаются вложенные вызовы. В случае, если подпрограмма
DoSomething будет рекурсивной, после выхода из нее в таймере окажется время
выполнения "в целом", замеренное по внешнему вызову. Разумеется, для корректной
работы необходимо соблюдать баланс вызовов Start и Finish.

Один и тот же таймер может стартовать и останавливаться многократно, при этом
замеренные времена суммируются. Так, к концу работы программы в таймере #1
окажется просуммированное время исполнения всех вызовов подпрограммы.

Замеренные показатели могут быть получены с помощью подпрограмм GetSeconds или
GetStatictics. Последняя использует переданные в Start имена показателей для
формирования общего списка времен исполнения.

Метод Clear сбрасывает собранную информацию, позволяя начать следующую серию
измерений.

------------------------------------------------------------------------------ }

{ ----- История модуля ---------------------------------------------------------

??.??.1998 Первая версия модуля (D2)
01.08.2004 Модуль откомпилирован под D6. Массив данных сделан динамическим,
           в связи с чем убрано ограничение на номер таймера. Оформлен класс
           Timing

------------------------------------------------------------------------------ }

unit ucTimings ;
{$include ..\delphi_ver.inc}

interface

uses Classes, SysUtils ;

type
  { Исключения, фиксируемые модулем }
  ETiming = class ( Exception ) ;

  { Статический класс для таймера }
  Timing = class
  public
    class procedure Clear ;
      { Сброс собранной информации и очистка }
    class procedure Start ( Timer : integer ; AName : string = '' ) ;
      { Запуск указанного таймера }
    class procedure Finish ( Timer : integer ) ;
      { Остановка указанного таймера }
    class function GetSeconds ( Timer : integer ) : real ;
      { Считывание показаний таймера }
    class procedure GetStatistics ( S : TStrings ) ; overload ;
    class function GetStatistics : String ; overload ;
      { Сбор показаний всех таймеров }
  end ;

implementation

type
  TTimerRec = record
    Name  : string ;
    Depth : integer ;
    Start : TDateTime ;
    Time  : TDateTime ;
    Used  : boolean ;
  end ;

var
  Timers : array of TTimerRec ;

resourcestring
  STimerNotUsed = 'Таймер (%d) не используется' ;
  SCallMismatch = 'Неправильная последовательность вызовов Start/Finish ' +
                  'для таймера (%d)' ;

{ Выделение места под указанный таймер }
procedure EnsureTimer ( Timer : integer ) ;
begin
  if Length ( Timers ) <= Timer then SetLength ( Timers, Timer + 1 ) ;
end ;

{ Проверка, используется ли таймер }
procedure CheckTimerUsed ( Timer : integer ) ;
begin
  if ( Length ( Timers ) > Timer ) and Timers [ Timer ].Used then exit ;
  raise ETiming.CreateFmt ( STimerNotUsed, [ Timer ]) ;
end ;

{ Сброс собранной информации и очистка }
class procedure Timing.Clear ;
begin
  Finalize ( Timers ) ;
  EnsureTimer ( 100 ) ;
end ;

{ Запуск указанного таймера }
class procedure Timing.Start ( Timer : integer ; AName : string = '' ) ;
begin
  EnsureTimer ( Timer ) ;
  with Timers [ Timer ] do
  begin
    Used := true ;
    Name := AName ;
    if Depth = 0 then Start := Now ;
    inc ( Depth ) ;
  end ;
end ;

{ Остановка указанного таймера }
class procedure Timing.Finish ( Timer : integer ) ;
begin
  CheckTimerUsed ( Timer ) ;
  with Timers [ Timer ] do
  begin
    if Depth = 0 then raise ETiming.CreateFmt ( SCallMismatch, [ Timer ]) ;
    dec ( Depth ) ;
    if Depth = 0 then Time := Time + Now - Start ;
  end ;
end ;

{ Считывание показаний таймера }
class function Timing.GetSeconds ( Timer : integer ) : real ;
begin
  CheckTimerUsed ( Timer ) ;
  Result := Timers [ Timer ].Time * 24 * 60 * 60 ;
end ;

{ Сбор показаний всех таймеров }
class function Timing.GetStatistics : String ;
var i : integer ;
begin
  Result := '' ;
  for i := Low ( Timers ) to High ( Timers ) do
    if Timers [ i ].Used then
      Result := Result + Format ( '%s(%d) %8.3f',
                           [ Timers [ i ].Name, i, GetSeconds ( i )]) + #13 ;
  Result := Trim ( Result ) ;
end ;

class procedure Timing.GetStatistics ( S : TStrings ) ;
begin
  S.Text := GetStatistics ;
end ;

initialization
  EnsureTimer ( 100 ) ;

end.
