-- Функция №1.
INSERT INTO archeology.finds (find_coords, find_date, find_info, museum_name, rent_begin, rent_end, report_id) VALUES
(point(0.234111, 50.985222), '2003-01-15', NULL, 'Hermitage', '2022-11-22', '2024-09-26', 166785);
SELECT * FROM archeology.finds ORDER BY find_id DESC LIMIT 1;
SELECT archeology.normalize_finds_info();
SELECT * FROM archeology.finds ORDER BY find_id DESC LIMIT 1;

-- Функция №2.
SELECT * FROM archeology.needed_archs('Field','Anthropologist','Marine','Archaeozoologist');
SELECT * FROM archeology.needed_archs('Field','Anthropologist');

-- Функция №3.
SELECT archeology.valid_licence(10);
