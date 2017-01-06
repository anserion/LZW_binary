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

//учебный шаблон создания архива бинарного кода по алгоритму Лемпела-Зива
program LZW_coder;
const max_D=1000; //максимальный размер словаря (шаблон учебный)
var
   D:array[1..max_D] of string; //словарь
   D_size:integer; //число слов в словаре
   D_size_bin:integer; //длина D_size в битах
   D_size_next:integer; //длина D_size при достижении которой увеличивется число бит описания D_size
   s:string; //входное сообщение
   n:integer; //размер входного сообщения
   ss:string; //анализируемое для включения в словарь слово
   ss_len:integer; //длина обрабатываемого куска входного сообщения
   archive,archive_readable:string; //архив
   s_base:integer; //указатель номера начала обрабатываемого куска входного сообщения
   max_word_len:integer; //длина самого длинного слова в словаре
   d_len:integer; //длина проверяемого слова из словаря
   flag_not_found:boolean; //истина - слово в словаре еще не найдено
   //вспомогательные переменные
   k,j:integer; //счетчики
   k_tmp:integer; //для перевода номера слова из словаря в двоичную систему счисления
   a_tmp:string; //для перевода номера слова из словаря в двоичную систему счисления
begin
   //ввод исходных данных
   writeln('LZW binary archive coder');
   writeln('s - text (binary code)');
   write('s='); readln(s);
   //определяем длину входного сообщения
   n:=length(s);
   //инициализируем архив
   archive:=''; archive_readable:='';
   D_size:=3; D_size_bin:=2; D_size_next:=4;
   D[1]:=''; D[2]:='0'; D[3]:='1';
   max_word_len:=1;
   
   //приступаем к созданию архива
   s_base:=0;
   while s_base<n do
   begin
      //уменьшаем длины искомых последовательностей от самой длинной до 1
      flag_not_found:=true;
      d_len:=max_word_len;
      while flag_not_found and (d_len>0) do
      begin
         //выделяем из s последовательность длиной d_len, но не далее конца s
         ss:=''; k:=1;
         while (k<=d_len)and(s_base+k<n) do
         begin
            ss:=ss+s[s_base+k];
            k:=k+1;
         end;
         ss_len:=length(ss);
         
         //сравниваем выделенную последовательность со всеми такой же длины из словаря
         flag_not_found:=true;
         k:=1;
         while flag_not_found and (k<=D_size) do
         begin
            if length(D[k])=ss_len then
               //если последовательность есть в словаре, то
               //1) выводим ее номер в словаре и следующий бит
               //2) расширяем словарь последовтельностью плюс следующий бит
               if D[k]=ss then
               begin
                  D_size:=D_size+1;
                  D[D_size]:=ss+s[s_base+ss_len+1];
                  //если нужно корректируем длину в битах номера найденного слова из словаря
                  if D_size=D_size_next then
                  begin
                     D_size_bin:=D_size_bin+1;
                     D_size_next:=D_size_next*2;
                  end;
                  //переводим номер слова из словаря в двоичную систему счисления
                  k_tmp:=k; a_tmp:='';
                  for j:=1 to D_size_bin do
                  begin
                     if (k_tmp mod 2)=0 then a_tmp:='0'+a_tmp else a_tmp:='1'+a_tmp;
                     k_tmp:=k_tmp div 2;
                  end;
                  //добавляем в архив номер слова из словаря плюс следующий бит
                  archive_readable:=archive_readable+a_tmp+','+s[s_base+ss_len+1]+' ';
                  archive:=archive+a_tmp+s[s_base+ss_len+1];
                  //если расширение словаря длиннее самого длинного слова
                  //в словаре, то запоминаем новую длину самого длинного слова
                  if ss_len+1>max_word_len then max_word_len:=ss_len+1;
                  flag_not_found:=false;
                  //печать добавляемой в архив информации
                  writeln('to archive: ',k,',',s[s_base+ss_len+1]);
               end;
            //анализируем следующее слово из словаря на совпадение
            k:=k+1;
         end;
         //анализируем более короткую последовательность
         d_len:=d_len-1;
      end;
      //перемещаемся по входному сообщению вправо на длину найденной
      //в словаре последовательности плюс один бит
      s_base:=s_base+ss_len+1;
   end;
   //вывод ответа
   writeln('Dictionary');
   for k:=1 to D_size do writeln(k,': ',D[k]);
   writeln('Archive readable: ');
   writeln(archive_readable);
   writeln('Archive binary:');
   writeln(archive);
end.
