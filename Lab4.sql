 alter session set container = orclpdb;
 select * from dba_users where username = 'ARVCORE'; 
 alter database open;
 show con_name;



-- 1
select * from dba_data_files;
select * from dba_temp_files;
 
 -- 2
 create tablespace ARV_QDATA02
 datafile 'ARV_QDATA02.dbf'
 size 10M
 offline;
 alter tablespace ARV_QDATA02 online;
 alter user ARVCORE quota 2M on ARV_QDATA02;
 
  -- connect ARVCORE/1234567@localhost:1521/orclpdb;
 
 create table ARV_T1 (
 id number primary key,
 name varchar2(20)
 ) tablespace ARV_QDATA02;
 
 insert into ARV_T1 values (1, 'x');
 insert into ARV_T1 values (2 ,'y');
 insert into ARV_T1 values (3, 'z');
 commit; 

 -- 3
 select segment_name from user_segments where tablespace_name = 'ARV_QDATA02';
 
 -- 4
 drop table ARV_T1;
 
 select segment_name from user_segments where tablespace_name = 'ARV_QDATA02';
 
 select * from recyclebin;
 
 -- 5
 flashback table ARV_T1 to before drop;
 
 -- 6
BEGIN
  FOR i IN 4..10003 LOOP
    INSERT INTO ARV_T1 (id, name) VALUES (i, 'Row' || i);
  END LOOP;
  COMMIT;
END;
/

 -- 7
 select * from user_extents where segment_name = 'ARV_T1';
 
 -- 8
 -- as sysdba
 drop tablespace ARV_QDATA02 including contents and datafiles;
 
 -- 9
 select * from v$log;
 
 -- 10
 select * from v$logfile;
 
 -- 11
 -- cdb
 alter session set container = CDB$ROOT
 show con_name
select to_char(sysdate, 'DD.MM.RR, HH24.MI') as start_time from dual; -- 16.10.25, 11.32
select group#, status from v$log;
alter system switch logfile;
SELECT GROUP#, STATUS FROM v$log;

--12
select group#, members, bytes, status from v$log;
select group#, member from v$logfile;
alter database add logfile group 4 (
    'D:\POMAN\PROG\ORACLEDB\ORADATA\ORCL\REDO04A.LOG',
    'D:\POMAN\PROG\ORACLEDB\ORADATA\ORCL\REDO04B.LOG',
    'D:\POMAN\PROG\ORACLEDB\ORADATA\ORCL\REDO04C.LOG'
) size 50M
select group#, status, bytes from v$log where group# = 4;
select * from v$logfile where group# = 4;
alter system switch logfile;
select group#, status, first_change# from v$log; -- scn(first_change#) = 9687085

-- 13
alter database drop logfile group 4;
select group# from v$log where group# = 4;
select * from v$logfile where group# = 4;

-- 14
select log_mode from v$database; -- NOARCHIVELOG

-- 15
select max(sequence#) from v$archived_log 
where archived = 'YES' and deleted = 'NO';

-- 16
-- sqlplus
shutdown immediate;
startup mount;
alter database archivelog;
alter database open;
--sqldeveloper
select log_mode from v$database;

-- 17
alter system switch logfile;
select max(sequence#) from v$archived_log;
show parameter db_recovery_file_dest;
select destination from v$archive_dest where status = 'VALID';

select sequence#, first_change#, next_change#, archived from v$log;
select sequence#, first_change#, next_change# from v$archived_log;

-- 18 
-- sqlplus
shutdown immediate;
startup mount;
alter database noarchivelog;
alter database open;
-- sqldeveloper
select log_mode from v$database;

-- 19
select name from v$controlfile;

-- 20
select type, record_size, records_total from v$controlfile_record_section;

-- 21
show parameter spfile;

-- 22
create pfile='D:\Poman\prog\ORACLEDB\ARV_PFILE.ORA' from spfile;

-- 23 
-- D:\Poman\prog\WINDOWS.X64_193000_db_home\database

-- 24
select * from v$diag_info;

--25
-- D:\Poman\prog\ORACLEDB\diag\rdbms\orcl\orcl\alert