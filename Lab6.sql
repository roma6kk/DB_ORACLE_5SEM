--sqlplus
-- 1
-- tnsnames.ora — содержит алиасы для подключения к БД.
-- sqlnet.ora — содержит параметры сетевой конфигурации (например, NAMES.DEFAULT_DOMAIN, SQLNET.AUTHENTICATION_SERVICES).

-- 2
-- sqlplus system/SYSpasswd1@localhost:1521/orcl
-- show parameter

-- 3
-- sqlplus system/SYSpasswd1@localhost:1521.orclpdb
-- select * from dba_tablespaces
-- select * from dba_data_files
-- selec * from dba_roles
-- select * from dba_users

-- 4
-- regedit -> HKEY_LOCAL_MACHINE\SOFTWARE\ORACLE
-- Там можно увидеть ключи, связанные с установленными Oracle-домашними каталогами, ORACLE_HOME, TNS_ADMIN, ORACLE_SID и т.п.

-- 5
alter session set container = orclpdb;
create profile PF_ARV limit
PASSWORD_LIFE_TIME 180
SESSIONS_PER_USER 3
FAILED_LOGIN_ATTEMPTS 7
PASSWORD_LOCK_TIME 1
PASSWORD_REUSE_TIME 10
PASSWORD_GRACE_TIME DEFAULT
CONNECT_TIME 180
IDLE_TIME 30

create role RL_ARV;
grant create session, create table to RL_ARV;


create user ARV_USER IDENTIFIED by 12345
default tablespace TS_ARV quota unlimited on TS_ARV
temporary tablespace temp
profile PF_ARV
grant create view to ARV_USER
grant RL_ARV to ARV_USER
grant SELECT_CATALOG_ROLE to ARV_USER

-- 6
-- sqlplus ARV_USER/12345@ARV_USER_orclpdb

-- 7
create table ARV_table(
id number primary key,
name varchar2(20)
)

insert into ARV_table values(1, 'xxxx');
insert into ARV_table values(2, 'yyyyyy');
commit;
-- select * from ARV_TABLE;

-- 8 
-- help timing
-- SET TIMING ON
-- SELECT * FROM my_table;

-- 9 
-- describe ARV_table;

-- 10
-- select * from user_segments;

-- 11
CREATE OR REPLACE VIEW user_segment_summary AS
SELECT
  COUNT(*) AS total_segments,
  SUM(extents) AS total_extents,
  SUM(blocks) AS total_blocks,
  SUM(bytes) / 1024 AS total_size_kb
FROM user_segments;
SELECT * FROM user_segment_summary;