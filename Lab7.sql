alter session set container = orclpdb;
ALTER USER ARV_USER IDENTIFIED BY 12345;
ALTER USER ARV_USER ACCOUNT UNLOCK;

grant create session to ARV_USER;
grant create table to ARV_USER;
grant create sequence to ARV_USER;
grant create cluster to ARV_USER;
grant create synonym to ARV_USER;
grant create public synonym to ARV_USER;
grant create view to ARV_USER;
grant create materialized view to ARV_USER;
grant unlimited tablespace to ARV_USER;

-- connect ARV_USER/12345@localhost/orclpdb;

-- 2
create sequence S1 start with 1000 increment by 10
nominvalue nomaxvalue nocycle nocache noorder;

select S1.nextval from dual;
select S1.nextval from dual;
select S1.nextval from dual;

-- 3-4
create sequence S2 start with 10 increment by 10
maxvalue 100 nocycle;
select S2.nextval from dual;

-- 5 
create sequence S3 start with 10 increment by -10 
minvalue -100 maxvalue 100 nocycle order;
select S3.nextval from dual connect by level <= 12;

-- 6
create sequence S4 start with 1 increment by 1
minvalue 1 maxvalue 6 cycle cache 5 noorder;
select S4.nextval from dual connect by level <= 7;

-- 7 
select * from user_sequences;

-- 8
create table T1(
N1 number,
N2 number,
N3 number,
N4 number
)
cache storage (BUFFER_POOL KEEP);
drop sequence S2;
drop sequence S3;
begin 
    for i in 1..7 loop
        insert into T1 values (S1.nextval, S2.nextval, S3.nextval, S4.nextval);
    end loop;
    commit;
end;
/

-- 9
create cluster ABC (
X number(10),
V varchar2(12)
)
size 200 hashkeys 100;

-- 10
create table A(
XA number(10),
VA varchar(12),
EXTRA_A varchar(20)) cluster ABC (XA, VA);

-- 11
create table B(
XB number(10), 
VB varchar(12),
EXTRA_B date
) cluster ABC (XB, VB);

-- 12
create table C (
XC number(10),
VC varchar(12),
EXTRA_C number
) cluster ABC (XC, VC);

-- 13
select * from user_clusters;
select table_name, cluster_name from user_tables;

-- 14
create synonym C_SYNONYM for C;
insert into C_SYNONYM(XC, VC, EXTRA_C) values(100, 'test', 1);
select * from C_SYNONYM;

-- 15
create public synonym B_PUBLIC for B;
select * from B_PUBLIC;

-- 16
create table A_TAB (
ID number primary key,
NAME varchar2(50)
);
create table B_TAB(
ID number primary key,
A_ID number references A_TAB(ID),
VALUE varchar2(50)
);

insert into A_TAB values (1, 'A');
insert into A_TAB values (2, 'B');
insert into B_TAB values (10,1,'X');
insert into B_TAB values (20,2,'Y');

create view V1 as
select A.ID as A_ID, A.NAME, B.ID as B_ID, B.VALUE
from A_TAB A
inner join B_TAB B on A.ID = B.A_ID;

select * from V1;

-- 17
alter system set job_queue_processes = 10;

create materialized view MV REFRESH complete
start with SYSDATE next SYSDATE + INTERVAL '2' minute as
select A.ID as A_ID, A.NAME, B.ID as B_ID, B.VALUE from A_TAB A 
inner join B_TAB B on A.ID = B.A_ID;

select * from MV;
insert into A_TAB values (3, 'C');
insert into B_TAB values (30,3,'Z');


---
drop materialized view MV;
drop view V1;
drop table B_TAB;
drop table A_TAB;
drop public synonym B_PUBLIC;
drop synonym C_SYNONYM;
DROP TABLE A;
DROP TABLE B;
DROP TABLE C;
DROP CLUSTER ABC;
DROP TABLE T1;
DROP SEQUENCE S1;
DROP SEQUENCE S2;
DROP SEQUENCE S3;
DROP SEQUENCE S4;