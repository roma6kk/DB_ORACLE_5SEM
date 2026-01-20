set serveroutput on;
-- 1
declare
    v_name teacher.teacher_name%type;
begin
    select teacher_name
    into v_name
    from teacher
    where teacher = 'СМЛВ';
    dbms_output.put_line('Преподаватель: ' || v_name);
exception
    when no_data_found then
        dbms_output.put_line('Преподаватель не найден');
end;
/

-- 2
declare 
    v_name teacher.teacher_name%type;
begin
    select teacher_name into v_name from teacher where pulpit = 'ИСиТ';
    dbms_output.put_line(v_name);
exception 
    when others then
        dbms_output.put_line('Ошибка: ' || sqlcode || ' ' || sqlerrm );
end;
/

-- 3
declare
    v_name teacher.teacher_name%type;
begin
    select teacher_name into v_name from teacher where pulpit = 'ИСиТ';
    exception
    when too_many_rows then
        dbms_output.put_line('Ошибка: TOO_MANY_ROWS');
    when no_data_found then
        dbms_output.put_line('NO_DATA_FOUND');
end;
/

-- 4
declare 
    v_val number;
begin
    begin
        select auditorium_capacity into v_val from auditorium where auditorium = 'XXX';
    exception
        when no_data_found then
            dbms_output.put_line('NO_DATA_FOUND');
    end;
    update auditorium set auditorium_capacity = auditorium_capacity where 1 = 0;
    dbms_output.put_line('SQL%ROWCOUNT = ' || SQL%ROWCOUNT);
end;
/

-- 5
begin
    update auditorium set auditorium_capacity = auditorium_capacity + 1 where auditorium = '236-1';
    if sql%rowcount = 1 then
        commit;
        dbms_output.put_line('commit');        
    else
        rollback;
    end if;
end;
/

-- 6
begin
   update teacher
   set pulpit = 'ФЫВФЫВФЫВ'  
   where teacher = 'СМЛВ';
   commit;
exception
   when others then
        rollback;
        dbms_output.put_line('ошибка целостности: ' || sqlerrm);
end;
/

-- 7
begin
    insert into auditorium(auditorium, auditorium_name, auditorium_type, auditorium_capacity)
    values ('999-1', '999-1', 'лк', 20);
    commit;
end;
/

-- 8
begin
    insert into auditorium(auditorium, auditorium_name, auditorium_type, auditorium_capacity)
    values ('236-1', 'duplicate', 'лк', 20);

    commit;
exception
    when others then
        rollback;
        dbms_output.put_line('ошибка pk: ' || sqlerrm);
end;
/

-- 9 
begin
    delete from auditorium
    where auditorium = '999-1';

    if sql%rowcount > 0 then
        commit;
        dbms_output.put_line('удалено.');
    else
        rollback;
        dbms_output.put_line('нет строк. откат.');
    end if;
end;
/

-- 10
begin
    delete from pulpit where pulpit = 'ИСиТ';
    commit;
exception
    when others then
        rollback;
        dbms_output.put_line('fk ошибка: ' || sqlerrm);
end;
/

-- 11
declare 
    cursor c is 
        select teacher, teacher_name, pulpit from teacher;
    v_code teacher.teacher%type;
    v_name teacher.teacher_name%type;
    v_pulpit teacher.pulpit%type;
begin
    open c;
    loop
        fetch c into v_code, v_name, v_pulpit;
        exit when c%notfound;
        dbms_output.put_line(v_code || ' - ' || v_name || ' ' || v_pulpit);
    end loop;
    close c;
end;
/

-- 12
declare
    cursor c is select * from subject;
    r subject%rowtype;
begin
    open c;
    loop
        fetch c into r;
        exit when c%notfound;
        dbms_output.put_line(r.subject || ': ' || r.subject_name);
    end loop;
    close c;
end;
/

-- 13
declare 
    cursor c is select p.pulpit_name, t.teacher_name from pulpit p join teacher t on p.pulpit = t.pulpit;
begin
    for rec in c loop
        dbms_output.put_line(rec.pulpit_name || ' - ' || rec.teacher_name);
    end loop;
end;
/

-- 14
declare 
    cursor c(p_min number, p_max number) is
        select auditorium, auditorium_name, auditorium_capacity from auditorium where auditorium_capacity between p_min and p_max;
begin 
    for r in c(20,40) loop
        dbms_output.put_line(r.auditorium || ' ' || r.auditorium_capacity);
    end loop;
end;
/

-- 15
declare
    type rc is ref cursor;
    r rc;
    v subject%rowtype;
begin
    open r for 
        select * from subject where pulpit = 'ИСиТ';
    loop 
        fetch r into v;
        exit when r%notfound;
        dbms_output.put_line(v.subject || ' - ' || v.subject_name);
    end loop;
    close r;
end;
/
    
-- 16
declare 
    cursor c is select t.teacher_name,
    (select pulpit_name from pulpit p where p.pulpit = t.pulpit) as pn from teacher t;
begin 
    for r in c loop
        dbms_output.put_line(r.teacher_name || ' - ' || r.pn);
    end loop;
end;
/

-- 17
declare 
    cursor c(p1 number, p2 number) is select auditorium, auditorium_capacity from auditorium where auditorium_capacity between p1 and p2 for UPDATE;
    v_a auditorium.auditorium%type;
    v_c auditorium.auditorium_capacity;
begin
    open c(40,80);
    loop
        fetch c into v_a, v_c;
        exit when c%notfound;
        update auditorium set auditorium_capacity = trunc(v_c * 0.9) where current of c;
    end loop;
    close c;
    commit;
end;
/
    
-- 18
declare 
    cursor c is select auditorium from auditorium where auditorium_capacity between 0 and 20;
    v_a auditorium.auditorium_capacity%type;
begin
    open c;
    loop
        fetch c into v_a;
        exit when c%notfound;
        delete from auditorium where current of c;
    end loop;
    close c;
    commit;
end;
/

select auditorium from auditorium;
-- 19
declare
    v_r rowid;
begin
    select rowid into v_r from auditorium where auditorium = '110-4';
    update auditorium set audiorium_capacity = auditorium_capacity + 5 where rowid = v_r;
    commit;
    dbms_output.put_line('updated rowid: ' || v_r);
end;
/

-- 20
declare
    cursor c is select teacher_name from teacher order by teacher_name;
    v teacher.teacher_name%type;
    n number := 0;
begin
    open c;
    loop
        fetch c into v;
        exit when c%notfound;
        n := n + 1;
        dbms_output.put_line(v);
        if mod(n,3) = 0 then
            dbms_output.put_line('----------------------');
        end if;
    end loop;
    close c;
end;
/

--12 14 16 17 18 

--12
declare
    cursor c_sub is select * from subject;
    v_sub_rec subject%rowtype;
begin
    open c_sub;
    fetch c_sub into v_sub_rec;
    while c_sub%found loop 
        DBMS_OUTPUT.PUT_LINE(v_sub_rec.subject || ' - ' || v_sub_rec.subject_name || ' ' || v_sub_rec.pulpit);
        fetch c_sub into v_sub_rec;
    end loop;
    close c_sub;
end;
/

-- 14
declare
    cursor c_aud(p_min number, p_max number) is select auditorium, auditorium_name, auditorium_capacity
        from auditorium where auditorium_capacity between p_min and p_max;
    v_code auditorium.auditorium%TYPE;
    v_name auditorium.auditorium_name%TYPE;
    v_cap  auditorium.auditorium_capacity%TYPE;
begin
    DBMS_OUTPUT.PUT_LINE('=== Вместимость < 20 (Basic LOOP) ===');
    
    open c_aud(0,19);
    loop
        fetch c_aud into v_code, v_name, v_cap;
        exit when c_aud%notfound;
        DBMS_OUTPUT.PUT_LINE(v_code || ' (' || v_name || '): ' || v_cap);
    end loop;
    close c_aud;
    DBMS_OUTPUT.PUT_LINE('=== Вместимость 21-30 (WHILE LOOP) ===');
    open c_aud(21,30);
    while c_aud%found loop
        DBMS_OUTPUT.PUT_LINE(v_code || ' (' || v_name || '): ' || v_cap);
        fetch c_aud into v_code, v_name, v_cap;
    end loop;
    close c_aud;
    DBMS_OUTPUT.PUT_LINE('=== Вместимость 31-60 (FOR LOOP) ===');
    for r in c_aud(31,60) loop 
        DBMS_OUTPUT.PUT_LINE(r.auditorium || ' (' || r.auditorium_name || '): ' || r.auditorium_capacity);
    end loop;
    DBMS_OUTPUT.PUT_LINE('=== Вместимость 61-80 ===');
    FOR r IN c_aud(61, 80) LOOP
        DBMS_OUTPUT.PUT_LINE(r.auditorium || ' (' || r.auditorium_name || '): ' || r.auditorium_capacity);
    END LOOP;
 DBMS_OUTPUT.PUT_LINE('=== Вместимость > 80 ===');
    FOR r IN c_aud(81, 9999) LOOP
        DBMS_OUTPUT.PUT_LINE(r.auditorium || ' (' || r.auditorium_name || '): ' || r.auditorium_capacity);
    END LOOP;
end;
/

-- 16
DECLARE
    TYPE t_teacher_cur IS REF CURSOR;
    v_worker_cur t_teacher_cur;
    v_pulpit_name pulpit.pulpit_name%TYPE;
    v_teacher_name teacher.teacher_name%TYPE;

    CURSOR c_main IS
        SELECT p.pulpit_name,
               CURSOR(
                   SELECT t.teacher_name 
                   FROM teacher t 
                   WHERE t.pulpit = p.pulpit
               ) 
        FROM pulpit p;
BEGIN
    OPEN c_main;
    LOOP
        FETCH c_main INTO v_pulpit_name, v_worker_cur;
        EXIT WHEN c_main%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('--- Кафедра: ' || v_pulpit_name || ' ---');
        LOOP
            FETCH v_worker_cur INTO v_teacher_name;
            EXIT WHEN v_worker_cur%NOTFOUND;    
            DBMS_OUTPUT.PUT_LINE('   Преподаватель: ' || v_teacher_name);
        END LOOP;
    END LOOP;
    CLOSE c_main;
END;
/
-- 17 
declare
    cursor c_aud(p_min number, p_max number) is select auditorium_capacity from auditorium where
    auditorium_capacity  between p_min and p_max for update;
begin
    for r in c_aud(40,80) loop
        update auditorium set auditorium_capacity = auditorium_capacity * 0.9 where current of c_aud;
    end loop;
    commit;
end;
/
-- 18
DECLARE 
    CURSOR c_del(p_min NUMBER, p_max NUMBER) IS 
        SELECT auditorium 
        FROM auditorium 
        WHERE auditorium_capacity BETWEEN p_min AND p_max 
        FOR UPDATE;
        
    v_a auditorium.auditorium%TYPE;
BEGIN
    OPEN c_del(0, 20);
    FETCH c_del INTO v_a;
    WHILE c_del%FOUND LOOP
        DELETE FROM auditorium WHERE CURRENT OF c_del;        
        FETCH c_del INTO v_a;
    END LOOP;
    
    CLOSE c_del;
    COMMIT;
END;
/
    