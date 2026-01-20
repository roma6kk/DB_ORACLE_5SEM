SET SERVEROUTPUT ON
-- 1
begin
  null;
end;
/

-- 2
begin
  dbms_output.put_line('Hello World!');
END;
/

-- 3
declare v_result number;
begin
v_result := 10/0;
exception 
    when others then
        dbms_output.put_line('Код ошибки: ' || sqlcode);
        dbms_output.put_line('Сообщение: ' || sqlerrm);
end;
/

-- 4
begin
    dbms_output.put_line('Внешний блок начат');
    begin
        dbms_output.put_line('Внутренний блрк начат');
        raise_application_error(-1, 'Ошибка во вложенном блоке');
    exception
        when others then 
            dbms_output.put_line('Обработка исключения во вложенном блоке: ' || sqlerrm);
    end;
    dbms_output.put_line('Внешний блок завершен');
end;
/

-- 5
show parameter plsql_warnings;

-- 6
select keyword from v$reserved_words 
where length = 1 and keyword != 'A';

-- 7
select keyword from v$reserved_words 
where length > 1 order by keyword;

-- 8
select name, value, description from v$parameter
where name like '%plsql%';

-- 9-17
declare
-- 10
n1 number := 10;
n2 number := 3;

-- 12
n_fixed number(5,2) := 123.45;

-- 13
n_round number(5,-2) := 12345;

-- 14
bf binary_float := 1.23E5;

-- 15
bd binary_double := 9.87654321E10;

-- 16
n_sci number := 1.5E3;

-- 17
flag boolean := true;

-- 11
v_sum number;
v_diff number;
v_mult number;
v_div number;
v_mod number;
begin
v_sum := n1 + n2;
v_diff := n1 - n2;
v_mult := n1 * n2;
v_div := n1 / n2;
v_mod := mod(n1,n2);

dbms_output.put_line('n1 = ' || n1);
dbms_output.put_line('n2 = ' || n2);
dbms_output.put_line('Сумма: ' || v_sum);
dbms_output.put_line('Разность: ' || v_diff);
dbms_output.put_line('Произведение: ' || v_mult);
dbms_output.put_line('Деление: ' || v_div);
dbms_output.put_line('Остаток от деления: ' || v_mod);

dbms_output.put_line('Фиксированная точка: ' || n_fixed);
dbms_output.put_line('Округление (масштаб -2): ' || n_round);
dbms_output.put_line('BINARY_FLOAT: ' || bf);
dbms_output.put_line('BINARY_DOUBLE: ' || bd);
dbms_output.put_line('Научная нотация: ' || n_sci);

if flag then
    dbms_output.put_line('Флаг True');
else
    dbms_output.put_line('Флаг False');
end if;
end;
/

declare
    c_name constant varchar2(20) := 'Роман';
    c_initial constant char(1) := 'Р';
    c_pi constant number := 3.14159;
begin
    dbms_output.put_line('Имя: ' || c_name);
    dbms_output.put_line('Инициал: ' || c_initial);
    dbms_output.put_line('Число Пи' || c_pi);
end;
/

-- 19 
declare
    v_subject subject.subject%type;
    v_pulpit pulpit.pulpit%type;
    v_faculty_rec faculty%rowtype;
begin
    v_subject := 'ПИC';
    v_pulpit := 'ИСиТ';
    v_faculty_rec.faculty := 'ИДиП';
    v_faculty_rec.faculty_name := 'факультет издательского дела и полиграфии' ;
    dbms_output.put_line (v_subject) ;
    dbms_output.put_line (v_pulpit);
    dbms_output.put_line (rtrim(v_faculty_rec.faculty) || ': '|| v_faculty_rec.faculty_name);
exception
when others
then dbms_output.put_line ('error = '|| sqlerrm) ;
end;
/

-- 21-22
declare x number := 10;
begin
    if x > 5 then
        dbms_output.put_line('x > 5');
    end if;
    
    if x > 15 then 
        dbms_output.put_line('x > 15');
    else
        dbms_output.put_line('x <= 15');
    end if;
    
    if x = 5 then
        dbms_output.put_line('x = 5');
    elsif x = 10 then
        dbms_output.put_line('x = 10');
    else 
        dbms_output.put_line('x !=  5 and x != 10');
    end if;
end;
/

-- 23

declare
    grade number := 7;
    result varchar2(20);
begin
    case
    when grade < 3 then result := 'Неуд';
    when grade < 6 then result := 'Уд';
    when grade >= 6 then result := 'Отлично';
    else result := 'error';
    end case;
    dbms_output.put_line(grade || ': ' || result);
end;
/

-- 24
declare i number := 1;
begin 
 loop
    dbms_output.put_line('LOOP: ' || i);
    i := i + 1;
    exit when i > 3;
    end loop;
end;
/

-- 25
declare i number := 1;
begin
    while i <= 3 loop
    dbms_output.put_line('while: ' || i);
    i := i + 1;
    end loop;
end;
/

-- 26
begin 
    for i in 1..3 loop
    dbms_output.put_line('FOR: ' || i);
    end loop;
end;
/