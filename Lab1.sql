create table ARV_t(x number(3), s varchar2(50));

insert into ARV_t values(123, 'name1');
insert into ARV_t values(234, 'namee2');
insert into ARV_t values(345, 'name3');
commit;

update ARV_t set x = x + 1 where x = 123;
update ARV_t set s = 'YourName' where s = 'name1';
commit;

select * from ARV_t where x < 300;
select avg(x) from  ARV_t;

delete from ARV_t where x = 124;
commit;

alter table ARV_t add constraint x_pk primary key(x);
create table ARV_t1(y number(3), s varchar2(40), 
    constraint y_fk foreign key(y) references ARV_t(x));
insert into ARV_t1 values(234, 'some name2');
insert into ARV_t1 values(345, 'some name3');

select * from ARV_t t inner join ARV_t1 t1 on t.x = t1.y;
select * from ARV_t t left join ARV_t1 t1 on t.x = t1.y;
select * from ARV_t t right join ARV_t1 t1 on t.x = t1.y;

drop table ARV_t;
drop table ARV_t1;
