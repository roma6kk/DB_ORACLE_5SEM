-- 1
select sum(value) from v$sga;

-- 2 ??
select pool, sum(bytes) from v$sgastat group by pool;

-- 3
select component, granule_size from v$sga_dynamic_components;

-- 4
select pool, sum(bytes) from v$sgastat where pool is null group by pool;

-- 5
select name, value from v$parameter where name='sga_max_size' or name='sga_target';

-- 6
select name, block_size, buffers from v$buffer_pool;

-- 7 
-- alter system set db_keep_cache_size = 50M;

create table keep_table(
    id number,
    name varchar2(50)
) storage (buffer_pool keep);

select segment_name, buffer_pool from user_segments where segment_name = 'KEEP_TABLE';
drop table keep_table;
-- 8
create table default_table(
id number,
data varchar2(100))
cache;

select segment_name, buffer_pool from user_segments where segment_name = 'DEFAULT_TABLE';
drop table default_table;
-- 9
select * from v$sgastat where name = 'log_buffer';

-- 10
select name, bytes from v$sgastat where pool = 'large pool' and name = 'free memory';

-- 11
select server, count(*) from v$session group by server;

-- 12
select name, description from v$bgprocess where paddr != hextoraw('00');

-- 13
select program, pname from v$process where pname is not null;

-- 14
select count(*) from v$bgprocess where name like 'DBW%' and paddr != hextoraw('00');

-- 15
select name, network_name from v$services;

-- 16
show parameter dispatcher;
