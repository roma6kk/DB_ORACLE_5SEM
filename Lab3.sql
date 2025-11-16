-- VARIANT 3 ANANYEV ROMAN
--1 
select distinct view_name from dba_views
--2
SELECT * FROM dba_tablespaces
--3
select username from dba_users
--4
select distinct segment_name from user_segments
--5
select name from v$pdbs;
--6
select * from v$log
--7

--8
select * from v$sgastat where name='table_name'

--9
select * from v$session
--10
select * from v$bgprocess where paddr != '00'
