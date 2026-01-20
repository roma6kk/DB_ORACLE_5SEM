SET SERVEROUTPUT ON;
-- 1
DECLARE
    PROCEDURE GET_TEACHERS(PCODE IN TEACHER.PULPIT%TYPE) IS
        CURSOR c_teachers IS
            SELECT teacher, teacher_name 
            FROM teacher 
            WHERE pulpit = PCODE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Список преподавателей кафедры ' || PCODE || ':');
        DBMS_OUTPUT.PUT_LINE('-----------------------------------');
        
        FOR r IN c_teachers LOOP
            DBMS_OUTPUT.PUT_LINE(r.teacher || ' - ' || r.teacher_name);
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    END GET_TEACHERS;

BEGIN
    GET_TEACHERS('ИСиТ'); 
END;
/

-- 2-3
SET SERVEROUTPUT ON;

DECLARE
    v_res NUMBER;
    v_pulpit_code TEACHER.PULPIT%TYPE := 'ИСиТ';

    FUNCTION GET_NUM_TEACHERS(PCODE IN TEACHER.PULPIT%TYPE) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) 
        INTO v_count 
        FROM teacher 
        WHERE pulpit = PCODE;
        
        RETURN v_count;
    END GET_NUM_TEACHERS;

BEGIN
    v_res := GET_NUM_TEACHERS(v_pulpit_code);
    
    DBMS_OUTPUT.PUT_LINE('На кафедре ' || v_pulpit_code || ' работает ' || v_res || ' преподавателей.');
END;
/

-- 4
DECLARE
    PROCEDURE GET_TEACHERS(FCODE IN FACULTY.FACULTY%TYPE) IS
        CURSOR c_teachers IS
            SELECT t.teacher_name, p.pulpit
            FROM teacher t
            JOIN pulpit p ON t.pulpit = p.pulpit
            WHERE p.faculty = FCODE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Преподаватели факультета ' || FCODE || ' ---');
        FOR r IN c_teachers LOOP
            DBMS_OUTPUT.PUT_LINE(r.teacher_name || ' (Кафедра: ' || r.pulpit || ')');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END GET_TEACHERS;

    PROCEDURE GET_SUBJECTS(PCODE IN SUBJECT.PULPIT%TYPE) IS
        CURSOR c_subjects IS
            SELECT subject, subject_name
            FROM subject
            WHERE pulpit = PCODE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Дисциплины кафедры ' || PCODE || ' ---');
        FOR r IN c_subjects LOOP
            DBMS_OUTPUT.PUT_LINE(r.subject || ': ' || r.subject_name);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END GET_SUBJECTS;

BEGIN
    GET_TEACHERS('ХТиТ');
    GET_SUBJECTS('ИСиТ');
END;
/
-- 5
DECLARE
    v_count NUMBER;
    v_faculty_code FACULTY.FACULTY%TYPE := 'ХТиТ';
    v_pulpit_code SUBJECT.PULPIT%TYPE := 'ИСиТ';

    FUNCTION GET_NUM_TEACHERS(FCODE IN FACULTY.FACULTY%TYPE) RETURN NUMBER IS
        v_res NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_res
        FROM teacher t
        JOIN pulpit p ON t.pulpit = p.pulpit
        WHERE p.faculty = FCODE;
        
        RETURN v_res;
    END GET_NUM_TEACHERS;

    FUNCTION GET_NUM_SUBJECTS(PCODE IN SUBJECT.PULPIT%TYPE) RETURN NUMBER IS
        v_res NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_res
        FROM subject
        WHERE pulpit = PCODE;
        
        RETURN v_res;
    END GET_NUM_SUBJECTS;

BEGIN
    v_count := GET_NUM_TEACHERS(v_faculty_code);
    DBMS_OUTPUT.PUT_LINE('Всего преподавателей на факультете ' || v_faculty_code || ': ' || v_count);

    v_count := GET_NUM_SUBJECTS(v_pulpit_code);
    DBMS_OUTPUT.PUT_LINE('Всего дисциплин на кафедре ' || v_pulpit_code || ': ' || v_count);
END;
/

-- 6 
CREATE OR REPLACE PACKAGE TEACHERS IS
    PROCEDURE GET_TEACHERS (FCODE IN FACULTY.FACULTY%TYPE);
    PROCEDURE GET_SUBJECTS (PCODE IN SUBJECT.PULPIT%TYPE);
    
    FUNCTION GET_NUM_TEACHERS (FCODE IN FACULTY.FACULTY%TYPE) RETURN NUMBER;
    FUNCTION GET_NUM_SUBJECTS (PCODE IN SUBJECT.PULPIT%TYPE) RETURN NUMBER;
END TEACHERS;
/

CREATE OR REPLACE PACKAGE BODY TEACHERS IS

    PROCEDURE GET_TEACHERS (FCODE IN FACULTY.FACULTY%TYPE) IS
        CURSOR c_teachers IS
            SELECT t.teacher_name, p.pulpit
            FROM teacher t
            JOIN pulpit p ON t.pulpit = p.pulpit
            WHERE p.faculty = FCODE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('>>> Список преподавателей (Факультет ' || FCODE || '):');
        FOR r IN c_teachers LOOP
            DBMS_OUTPUT.PUT_LINE(r.teacher_name || ' (' || r.pulpit || ')');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    END GET_TEACHERS;

    PROCEDURE GET_SUBJECTS (PCODE IN SUBJECT.PULPIT%TYPE) IS
        CURSOR c_subjects IS
            SELECT subject_name
            FROM subject
            WHERE pulpit = PCODE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('>>> Дисциплины кафедры ' || PCODE || ':');
        FOR r IN c_subjects LOOP
            DBMS_OUTPUT.PUT_LINE(r.subject_name);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    END GET_SUBJECTS;

    FUNCTION GET_NUM_TEACHERS (FCODE IN FACULTY.FACULTY%TYPE) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM teacher t
        JOIN pulpit p ON t.pulpit = p.pulpit
        WHERE p.faculty = FCODE;
        
        RETURN v_count;
    END GET_NUM_TEACHERS;

    FUNCTION GET_NUM_SUBJECTS (PCODE IN SUBJECT.PULPIT%TYPE) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM subject
        WHERE pulpit = PCODE;
        
        RETURN v_count;
    END GET_NUM_SUBJECTS;

END TEACHERS;
/

-- 7
DECLARE
    v_faculty_code FACULTY.FACULTY%TYPE := 'ХТиТ';
    v_pulpit_code SUBJECT.PULPIT%TYPE := 'ИСиТ';
    v_res_num NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- ТЕСТИРОВАНИЕ ПАКЕТА TEACHERS ---');
    TEACHERS.GET_TEACHERS(v_faculty_code);
    TEACHERS.GET_SUBJECTS(v_pulpit_code);
    v_res_num := TEACHERS.GET_NUM_TEACHERS(v_faculty_code);
    DBMS_OUTPUT.PUT_LINE('Функция вернула кол-во преподавателей на ф-те ' || v_faculty_code || ': ' || v_res_num);
    
    v_res_num := TEACHERS.GET_NUM_SUBJECTS(v_pulpit_code);
    DBMS_OUTPUT.PUT_LINE('Функция вернула кол-во дисциплин на кафедре ' || v_pulpit_code || ': ' || v_res_num);
    
END;
/
