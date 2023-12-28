-- Lost update 

BEGIN;
UPDATE archeology.finds SET price = price + 1000 
                        WHERE find_type = 'Weapon';
COMMIT;

/* ----------------------------------------------- */

BEGIN; 
DECLARE tmp2 numeric; 

SELECT tmp2 := price FROM archeology.finds 
WHERE find_type = 'Weapon';


UPDATE archeology.finds 
SET price = tmp2 + 1000 WHERE find_type = 'Weapon';

COMMIT;
