-- Lost update

BEGIN;
UPDATE archeology.finds SET price = price + 1000 WHERE find_id = 5;
-- DELAY '00:00:10'
                        BEGIN;
                        UPDATE archeology.finds SET price = price + 2000 
                        WHERE find_id = 5;

                        ROLLBACK;
COMMIT;

/* ----------------------------------------------- */

BEGIN; 
DECLARE tmp1 numeric; 

SELECT tmp1 := price FROM archeology.finds
WHERE find_id = 5;

                        BEGIN; 
                        DECLARE tmp2 numeric; 

                        SELECT tmp2 := price FROM archeology.finds 
                        WHERE find_id = 5;
                        -- DELAY '00:00:01'

UPDATE archeology.finds 
SET price = tmp1 + 1000 WHERE find_id = 5;
-- DELAY '00:00:10'
                        UPDATE archeology.finds 
                        SET price = tmp2 + 2000 WHERE find_id = 5;

                        ROLLBACK;
-- смотрим, но изменений транзакции №1 не видно
SELECT price FROM archeology.finds
WHERE find_type = 'Weapon';
COMMIT; 
