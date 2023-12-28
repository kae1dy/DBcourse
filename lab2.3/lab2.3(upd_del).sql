/* Запрос №1. Удаление недействительных лицензий/рент. */
DELETE FROM archeology.licences
WHERE (lic_end <= CURRENT_DATE);

DELETE FROM archeology.rents
WHERE (rent_end <= CURRENT_DATE);

/* Запрос №2. Продление лицензий археологов/ренты археологических находок для музеев на 3 и 5 лет, соответственно. */
UPDATE archeology.licences
SET lic_end = lic_end + interval '3 year'
WHERE lic_card = 'ASNXBRTY7A3Q';

UPDATE archeology.rents
SET rent_end = rent_end + interval '5 year'
WHERE museum_id = 
(SELECT museum_id FROM archeology.museums WHERE museum_name = 'Dam Site Museum' AND city = 'Mylavaram');

/* Запрос №3. Повышение в квалификации по номеру лицензионной карты. */
UPDATE archeology.archs
SET qualif = 'Researcher'
WHERE lic_id = 
(SELECT lic_id FROM archeology.licences WHERE lic_card = 'ASNXBRTY7A3Q');

/* Запрос №4. Некорректное продление лицензии. */
UPDATE archeology.licences
SET lic_begin = '2023-05-24',
	lic_end = '2022-05-24'
WHERE lic_card = 'ASNXBRTY7A3Q';
