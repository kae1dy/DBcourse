SET ROLE test;

/* archeology.finds SELECT, INSERT, UPDATE */
SELECT * FROM archeology.finds LIMIT 5;

INSERT INTO archeology.finds (find_coords, find_date, museum_name, rent_begin, rent_end, report_id) VALUES
	(point(-52.423141, 87.819224), '2003-05-2003', 'Crystal Palace', '2019-09-15', '2028-08-14', 93534);
	
UPDATE archeology.finds
SET find_coords = point(-13.424155, 99.158311)
WHERE find_id = 1;

/* archeology.archs SELECT (last_name, first_name, father_name, special, country_name, royalty), UPDATE (special, royalty) */
SELECT * FROM archeology.archs LIMIT 5;
SELECT (last_name, first_name, father_name, special, country_name, royalty) FROM archeology.archs LIMIT 5;

INSERT INTO archeology.archs (last_name, first_name, father_name, special, country_name, lic_card, lic_begin, lic_end) VALUES
	('Morozov', 'Ilya', 'Fedor', '{"Field", "Marine"}', 'Russia', 'A7ZBMFJEBZ43', '2023-05-24', '2026-05-24');
	
UPDATE archeology.archs
SET royalty = 0 WHERE arch_id = 1;

/* archeology.arch_report SELECT */
SELECT * FROM archeology.arch_report;

/* archeology.arch_report SELECT */
SELECT * FROM archeology.reports;





