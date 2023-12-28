SET ROLE test;

/* archeology.archs_non_valid_lic SELECT, UPDATE */
SELECT * FROM archeology.archs_non_valid_lic LIMIT 5;

UPDATE archeology.archs_non_valid_lic
SET lic_begin = CURRENT_DATE, lic_end = CURRENT_DATE + interval '3 year';

/* archeology.finds_non_valid_rent Non-SELECT, Non-UPDATE */
SELECT * FROM archeology.finds_non_valid_rent LIMIT 5;

UPDATE archeology.finds_non_valid_rent
SET rent_begin = CURRENT_DATE, rent_end = CURRENT_DATE + interval '5 year';
