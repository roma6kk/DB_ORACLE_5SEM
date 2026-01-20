-- 1
alter table teacher add (
    birthday date,
    salary number(10,2)
);
update teacher set birthday = date '1985-01-01' + mod(rownum*17, 365), salary = 1100 + mod(rownum*123, 900);
update teacher set birthday = date '1980-01-15', salary = 1500 where teacher = 'СМЛВ';
update teacher set birthday = date '1975-11-02', salary = 1800 where teacher = 'АКНВЧ';
update teacher set birthday = date '1990-05-27', salary = 1350 where teacher = 'КЛСНВ';
commit;

-- 2
SELECT 
       REGEXP_SUBSTR(teacher_name, '\S+', 1, 1) || ' ' || 
       SUBSTR(REGEXP_SUBSTR(teacher_name, '\S+', 1, 2), 1, 1) || '.' ||
       SUBSTR(REGEXP_SUBSTR(teacher_name, '\S+', 1, 3), 1, 1) || '.'
       AS short_name
FROM teacher;
    
-- 3
select teacher, teacher_name, birthday from teacher where to_char(birthday, 'DAY') like 'ПОНЕД%';

-- 4
create or replace view v_next_month_teachers as 
    select teacher, teacher_name, birthday from teacher where extract(month from birthday) = extract(month from add_months(sysdate, 1));
select * from v_next_month_teachers;

-- 5
create or replace view v_bd_cnt_by_month as
    select to_char(birthday, 'MONTH') as month_name, count(*) as cnt from teacher group by to_char(birthday, 'MONTH');
select * from v_bd_cnt_by_month;

-- 6
DECLARE
    v_next_year NUMBER := extract(year from sysdate) + 1; 
    v_age_next_year NUMBER;
    
    CURSOR c IS 
        SELECT teacher_name, birthday 
        FROM teacher;
BEGIN

    FOR r IN c LOOP
        v_age_next_year := v_next_year - extract(year from r.birthday);
        
        IF MOD(v_age_next_year, 5) = 0 THEN
            DBMS_OUTPUT.PUT_LINE(r.teacher_name || 
                                 ' (г.р. ' || to_char(r.birthday, 'YY') || ')' ||
                                 ' - будет ' || v_age_next_year);
        END IF;
    END LOOP;
END;
/

describe faculty
-- 7
declare
    cursor c_pulpit is select p.pulpit_name, floor(avg(t.salary)) as avg_sal from teacher t join pulpit p on p.pulpit = t.pulpit group by p.pulpit_name;
    cursor c_faculty is select f.faculty_name, floor(avg(t.salary)) as avg_sal from teacher t join pulpit p on p.pulpit = t.pulpit join faculty f on f.faculty = p.faculty group by f.faculty_name;
    v_total number;
begin
    dbms_output.put_line('Ср зарплата по кафедрам: ');
    for r in c_pulpit loop
        dbms_output.put_line(r.pulpit_name || ': ' || r.avg_sal);
    end loop;
    dbms_output.put_line(chr(10) || 'Ср зарплата по факультетам: ');
    for r in c_faculty loop
        dbms_output.put_line(r.faculty_name || ': ' || r.avg_sal);
    end loop;
    select floor(avg(salary)) into v_total from teacher;
    DBMS_OUTPUT.PUT_LINE(chr(10) || 'Итоговая средняя зарплата по всем: ' || v_total);
end;
/

-- 8
declare
    type rec_info is record(
        birth date,
        salary number
    );
    type rec_teacher is record (
        code teacher.teacher%type,
        name teacher.teacher_name%type,
        info rec_info
    );
    r1 rec_teacher;
    r2 rec_teacher;
begin
    r1.code := 'СМЛВ';
    r1.name := 'Смелов Владимир Владиславович';
    r1.info.birth := DATE '1980-01-15';
    r1.info.salary := 1500;
    r2 := r1;
    DBMS_OUTPUT.PUT_LINE('r2.code = ' || r2.code);
    DBMS_OUTPUT.PUT_LINE('r2.name = ' || r2.name);
    DBMS_OUTPUT.PUT_LINE('r2.birth = ' || r2.info.birth);
    DBMS_OUTPUT.PUT_LINE('r2.salary = ' || r2.info.salary);
end;
/
