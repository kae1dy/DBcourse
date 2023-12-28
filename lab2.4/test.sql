
-- Тест №1. find_trigger
INSERT INTO archeology.finds (find_type, find_coords, find_date, condition, price, year_min, year_max, report_id, rent_id) VALUES
	('Coin', point(-32.032210, 53.301984), '2024-05-24', 12, 152040, -2000, -2500, 20, 8);
SELECT * FROM archeology.finds;

-- Тест №2. find_rent_trigger
SELECT * FROM archeology.finds;

BEGIN;
INSERT INTO archeology.rents (rent_id, rent_begin, rent_end, museum_id) VALUES 
	(53, CURRENT_DATE, CURRENT_DATE + interval '3 year', 1),
	(54, CURRENT_DATE, CURRENT_DATE + interval '3 year', 2),
	(55, CURRENT_DATE, CURRENT_DATE + interval '3 year', 3);

INSERT INTO archeology.reports (report_id, report_link, report_date) VALUES
	(53, 'https://www.jstor.org/stable/41004194', CURRENT_DATE),
	(54, 'https://www.jstor.org/stable/12331952', CURRENT_DATE),
	(55, 'https://www.jstor.org/stable/96432221', '2023-05-24');
	
	
INSERT INTO archeology.finds (find_type, find_coords, find_date, condition, price, year_min, year_max, report_id, rent_id) VALUES
	('Art', point(-31.425111, 53.301984), CURRENT_DATE, 7, 150000, 0, 1000, 53, 53),
	('Jewel', point(40.022210, -2.893465), CURRENT_DATE, 4, 58250, -1200, -1000, 54, 54),
	('Architecture', point(1.988223, 38.415555), CURRENT_DATE, 8, 0, -5200, -4800, 55, 55);

COMMIT;
SELECT * FROM archeology.finds;
