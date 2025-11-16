alter session set container = orclpdb;
ALTER PLUGGABLE DATABASE orclpdb OPEN;
show con_name;
--  1
create tablespace TS_ARV
datafile 'TS_ARV.dbf'
size 7M
autoextend on next 5M
maxsize 20M;

-- 2
create temporary tablespace TS_ARV_TEMP
tempfile 'TS_ARV_TEMP'
size 5M
autoextend on next 3M
maxsize 30M

-- 3
select TABLESPACE_NAME from SYS.DBA_TABLESPACES;
select FILE_NAME from DBA_DATA_FILES;

-- 4
create role RL_ARVCORE container = current;
grant create session,
create table, 
create view, 
create procedure to RL_ARVCORE;

-- 5
select * from DBA_ROLES where role like 'RL%';
select * from DBA_SYS_PRIVS where grantee like 'RL%';

--6
create profile PF_ARVCORE limit
PASSWORD_LIFE_TIME 180
SESSIONS_PER_USER 3
FAILED_LOGIN_ATTEMPTS 7
PASSWORD_LOCK_TIME 1
PASSWORD_REUSE_TIME 10
PASSWORD_GRACE_TIME DEFAULT
CONNECT_TIME 180
IDLE_TIME 30

-- 7
select profile from dba_profiles where profile like 'PF%';
select * from dba_profiles where profile like 'PF%';
select * from dba_profiles where profile = 'DEFAULT';

-- 8
create user ARVCORE IDENTIFIED by 12345
default tablespace TS_ARV quota unlimited on TS_ARV
temporary tablespace TS_ARV_TEMP
profile PF_ARVCORE
account unlock
password expire;

grant RL_ARVCORE to ARVCORE;

-- 11 as SYS
create TABLESPACE ARV_QDATA
datafile 'ARV_QDATA.dbf'
size 10M
autoextend on next 1M maxsize 50M
offline;

alter tablespace ARV_QDATA online;
alter user ARVCORE quota 2M on ARV_QDATA;
select * from DBA_TS_QUOTAS where username = 'ARVCORE'

-- as ARVCORE
connect ARVCORE/123456@localhost:1521/orclpdb
create table ARV_T1(
    id number primary key,
    x varchar2(20),
    y varchar2(30)
) tablespace ARV_QDATA

insert into ARV_T1 values(1 ,'x', 'y');
insert into ARV_T1 values(2 ,'xx', 'yy');
insert into ARV_T1 values(3 ,'xxx', 'yy');
commit;
