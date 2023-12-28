-- Аномалии:
-- 1. потерянные изменения;
-- 2. грязные чтения;
-- 3. неповторяющиеся чтения;
-- 4. фантомы

-- READ (UN)COMMITTED. В PostgresPro READ UNCOMMITTED == READ COMMITTED.
-- +неповторяющиеся чтения, -грязные чтения 
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
							BEGIN;
							SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE archeology.finds SET price = 1000  WHERE find_type = 'Weapon';
							SELECT * FROM archeology.finds WHERE find_type = 'Weapon';
ROLLBACK;
							SELECT * FROM archeology.finds WHERE find_type = 'Weapon';


-- - потерянное изменение (в Postgres - невозможно)
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE archeology.finds SET price = price + 1000  WHERE find_type = 'Weapon';

                            BEGIN;
                            SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
                            UPDATE archeology.finds SET price = price + 2000 WHERE find_type = 'Weapon';
COMMIT;
                            COMMIT;



-- REPEATABLE READ. В PostgresPro на уровне REPEATABLE READ есть защита от фантомных чтений.
-- -неповторяющиеся чтения, -фантомы
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
                                                        BEGIN;
                                                        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE archeology.finds SET price = 1000  WHERE find_type = 'Weapon';
INSERT INTO archeology.finds (find_type, find_coords, find_date, condition, report_id, rent_id) VALUES ('Weapon', point(-59.123004, -22.412344), '2003-05-28', 5, 19, 5);
                                                        SELECT * from schedule.groups WHERE find_type = 'Weapon';
COMMIT;
                                                        SELECT * from schedule.groups WHERE find_type = 'Weapon';
														
-- SERIALIZABLE.
-- -фантомы
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
                                                        BEGIN;
                                                        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE archeology.finds SET price = 1000  WHERE find_type = 'Weapon';
INSERT INTO archeology.finds (find_type, find_coords, find_date, condition, report_id, rent_id) VALUES ('Weapon', point(-59.123004, -22.412344), '2003-05-28', 5, 19, 5);
                                                        SELECT * from schedule.groups WHERE find_type = 'Weapon';
COMMIT;
                                                        SELECT * from schedule.groups WHERE find_type = 'Weapon';