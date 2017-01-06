//Copyright 2017 Andrey S. Ionisyan (anserion@gmail.com)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

//учебный шаблон распаковки архива бинарного кода по алгоритму Лемпела-Зива
program LZW_decoder;
const max_D=1000; //максимальный размер словаря (шаблон учебный)
var
   D:array[1..max_D] of string; //словарь
   D_size:integer; //число слов в словаре
   D_size_bin:integer; //длина D_size в битах
   D_size_next:integer; //длина D_size при достижении которой увеличивется число бит описания D_size
   s:string; //входное сообщение
   ss:string; //текущий кусок сообщения, извлеченный из архива
   n:integer; //размер входного сообщения
   archive:string; //архив
   a_base:integer; //указатель номера начала обрабатываемого куска архива
   k,j:integer; //вспомогательные переменные
begin
   //ввод исходных данных
   writeln('LZW binary archive decoder');
   writeln('archive - text (binary code)');
   write('archive='); readln(archive);
   //определяем длину архива
   n:=length(archive);
   //инициализируем словарь
   D_size:=3; D_size_bin:=2; D_size_next:=4;
   D[1]:=''; D[2]:='0'; D[3]:='1';
   //инициализируем распаковку архива
   s:='';
   
   //приступаем к распаковке архива
   a_base:=0;
   while a_base<n do
   begin
      //при необходимости корректируем размер в битах номера слова из словаря
      D_size:=D_size+1;
      if D_size=D_size_next then
      begin
         D_size_bin:=D_size_bin+1;
         D_size_next:=D_size_next*2;
      end;
      //извлекаем из архива номер слова из словаря, которое нужно
      //расширить следующим за этим номером битом
      k:=0;
      for j:=1 to D_size_bin do
      begin
         k:=k*2;
         if archive[a_base+j]='1' then k:=k+1;
      end;
      //формируем очередное слово для словаря (оно же кусок исходного сообщения)
      ss:=D[k]+archive[a_base+D_size_bin+1];
      D[D_size]:=ss;
      //наращиваем исходное сообщение
      S:=S+ss;
      //печать содержимого архива
      writeln('from archive: ',k,',',archive[a_base+D_size_bin+1]);
      //перемещаемся внутри архива вправо к следующему номеру слова из словаря
      a_base:=a_base+D_size_bin+1;
   end;
   //вывод ответа
   writeln('Dictionary');
   for k:=1 to D_size do writeln(k,': ',D[k]);
   writeln('Unpacked message:');
   writeln(s);
end.
