-- 1
CREATE TABLE T_RANGE (
    id NUMBER,
    info VARCHAR2(50)
)
PARTITION BY RANGE (id) (
    PARTITION p_range_1 VALUES LESS THAN (100),
    PARTITION p_range_2 VALUES LESS THAN (200),
    PARTITION p_range_3 VALUES LESS THAN (300),
    PARTITION p_max VALUES LESS THAN (MAXVALUE)
);

-- 2
CREATE TABLE T_INTERVAL (
    dt DATE,
    info VARCHAR2(50)
)
PARTITION BY RANGE (dt) 
INTERVAL (NUMTOYMINTERVAL(1, 'MONTH')) 
(
    PARTITION p_old VALUES LESS THAN (TO_DATE('01-01-2025', 'DD-MM-YYYY'))
);

-- 3 
CREATE TABLE T_HASH (
    str_key VARCHAR2(50),
    info VARCHAR2(50)
)
PARTITION BY HASH (str_key) 
(
    PARTITION p_hash_1,
    PARTITION p_hash_2,
    PARTITION p_hash_3,
    PARTITION p_hash_4
);

-- 4
CREATE TABLE T_LIST (
    cat CHAR(1),
    info VARCHAR2(50)
)
PARTITION BY LIST (cat) (
    PARTITION p_a VALUES ('A'),
    PARTITION p_b VALUES ('B'),
    PARTITION p_c VALUES ('C'),
    PARTITION p_other VALUES (DEFAULT)
);

-- 5
-- T_RANGE
INSERT INTO T_RANGE VALUES (50, 'Section 1');
INSERT INTO T_RANGE VALUES (150, 'Section 2');
INSERT INTO T_RANGE VALUES (250, 'Section 3');
INSERT INTO T_RANGE VALUES (400, 'Max Section');

-- T_INTERVAL
INSERT INTO T_INTERVAL VALUES (TO_DATE('15-12-2024', 'DD-MM-YYYY'), 'Old Data');
INSERT INTO T_INTERVAL VALUES (TO_DATE('15-01-2025', 'DD-MM-YYYY'), 'Jan 2025');
INSERT INTO T_INTERVAL VALUES (TO_DATE('15-05-2025', 'DD-MM-YYYY'), 'May 2025');

-- T_HASH
INSERT INTO T_HASH VALUES ('apple', 'Hash 1');
INSERT INTO T_HASH VALUES ('banana', 'Hash 2');
INSERT INTO T_HASH VALUES ('cherry', 'Hash 3');
INSERT INTO T_HASH VALUES ('date', 'Hash 4');
INSERT INTO T_HASH VALUES ('elderberry', 'Hash 5');

-- T_LIST
INSERT INTO T_LIST VALUES ('A', 'Category A');
INSERT INTO T_LIST VALUES ('B', 'Category B');
INSERT INTO T_LIST VALUES ('C', 'Category C');
INSERT INTO T_LIST VALUES ('Z', 'Default Category');

COMMIT;

-- T_RANGE
SELECT 'P1' as part, t.* FROM T_RANGE PARTITION (p_range_1) t UNION ALL
SELECT 'P2' as part, t.* FROM T_RANGE PARTITION (p_range_2) t UNION ALL
SELECT 'P3' as part, t.* FROM T_RANGE PARTITION (p_range_3) t UNION ALL
SELECT 'MAX' as part, t.* FROM T_RANGE PARTITION (p_max) t;

-- T_HASH
SELECT 'p_hash_1' AS part_name, COUNT(*) FROM T_HASH PARTITION (p_hash_1) UNION ALL
SELECT 'p_hash_2' AS part_name, COUNT(*) FROM T_HASH PARTITION (p_hash_2) UNION ALL
SELECT 'p_hash_3' AS part_name, COUNT(*) FROM T_HASH PARTITION (p_hash_3) UNION ALL
SELECT 'p_hash_4' AS part_name, COUNT(*) FROM T_HASH PARTITION (p_hash_4);

-- T_LIST
SELECT * FROM T_LIST PARTITION (p_a);
SELECT * FROM T_LIST PARTITION (p_other);

SELECT partition_name, high_value FROM user_tab_partitions WHERE table_name = 'T_INTERVAL';

-- 6
ALTER TABLE T_RANGE ENABLE ROW MOVEMENT;
ALTER TABLE T_INTERVAL ENABLE ROW MOVEMENT;
ALTER TABLE T_LIST ENABLE ROW MOVEMENT;
ALTER TABLE T_HASH ENABLE ROW MOVEMENT;
-- T_RANGE
SELECT id, info, 
       (SELECT subobject_name FROM user_objects WHERE data_object_id = DBMS_ROWID.ROWID_OBJECT(t.rowid)) as partition_name 
FROM T_RANGE t WHERE id = 50;

UPDATE T_RANGE SET id = 250 WHERE id = 50;
COMMIT;

SELECT id, info, 
       (SELECT subobject_name FROM user_objects WHERE data_object_id = DBMS_ROWID.ROWID_OBJECT(t.rowid)) as partition_name 
FROM T_RANGE t WHERE id = 250;

-- T_INTERVAL
SELECT dt, info, 
       (SELECT subobject_name FROM user_objects WHERE data_object_id = DBMS_ROWID.ROWID_OBJECT(t.rowid)) as partition_name 
FROM T_INTERVAL t WHERE info = 'Old Data';

UPDATE T_INTERVAL SET dt = TO_DATE('15-05-2025', 'DD-MM-YYYY') WHERE info = 'Old Data';
COMMIT;

SELECT dt, info, 
       (SELECT subobject_name FROM user_objects WHERE data_object_id = DBMS_ROWID.ROWID_OBJECT(t.rowid)) as partition_name 
FROM T_INTERVAL t WHERE info = 'Old Data';

-- T_LIST
SELECT cat, info, 
       (SELECT subobject_name FROM user_objects WHERE data_object_id = DBMS_ROWID.ROWID_OBJECT(t.rowid)) as partition_name 
FROM T_LIST t WHERE cat = 'A';

UPDATE T_LIST SET cat = 'B' WHERE cat = 'A';
COMMIT;

SELECT cat, info, 
       (SELECT subobject_name FROM user_objects WHERE data_object_id = DBMS_ROWID.ROWID_OBJECT(t.rowid)) as partition_name 
FROM T_LIST t WHERE info = 'Category A';

-- T_HASH
SELECT str_key, info, 
       (SELECT subobject_name FROM user_objects WHERE data_object_id = DBMS_ROWID.ROWID_OBJECT(t.rowid)) as partition_name 
FROM T_HASH t WHERE str_key = 'apple';

UPDATE T_HASH SET str_key = 'zucchini' WHERE str_key = 'apple';
COMMIT;

SELECT str_key, info, 
       (SELECT subobject_name FROM user_objects WHERE data_object_id = DBMS_ROWID.ROWID_OBJECT(t.rowid)) as partition_name 
FROM T_HASH t WHERE str_key = 'zucchini';

-- 7
ALTER TABLE T_LIST 
MERGE PARTITIONS p_a, p_b INTO PARTITION p_ab;

SELECT partition_name FROM user_tab_partitions WHERE table_name = 'T_LIST';

-- 8
ALTER TABLE T_RANGE 
SPLIT PARTITION p_max AT (400) 
INTO (PARTITION p_range_4, PARTITION p_new_max);

SELECT partition_name, high_value FROM user_tab_partitions WHERE table_name = 'T_RANGE';
-- 9
CREATE TABLE T_RANGE_TEMP (
    id NUMBER,
    info VARCHAR2(50)
);

INSERT INTO T_RANGE_TEMP VALUES (155, 'From Temp Table');
COMMIT;

ALTER TABLE T_RANGE 
EXCHANGE PARTITION p_range_2 
WITH TABLE T_RANGE_TEMP 
WITHOUT VALIDATION;

SELECT * FROM T_RANGE PARTITION (p_range_2);
SELECT * FROM T_RANGE_TEMP;