DROP SCHEMA IF EXISTS archeology CASCADE;
CREATE SCHEMA archeology;

DROP TYPE IF EXISTS spec;
CREATE TYPE spec AS ENUM (
						'Field', 
						'Anthropologist',
						'Ceramologist',
						'Archaeozoologist',
						'Marine'
);

DROP TYPE IF EXISTS qual;
CREATE TYPE qual AS ENUM (
						'Assistant',
						'Senior Assistant',
						'Researcher',
						'Junior Researcher',
						'Senior Researcher',
						'Leading Researcher'
);

DROP TYPE IF EXISTS find_type;
CREATE TYPE find_type AS ENUM (
						'Jewel',
						'Art',
						'Houseware',
						'Architecture',
						'Mechanism',
						'Mummy',
						'Coin',
						'Weapon',
						'Artifact',
						'Sculpture',
						'Other'
);

CREATE TABLE archeology.licenses
(
	lic_id SERIAL PRIMARY KEY,
	lic_card varchar(12) CHECK(lic_card SIMILAR TO '(P|R|A)%') UNIQUE NOT NULL,
	lic_begin DATE NOT NULL,
	lic_end DATE NOT NULL CHECK(lic_end > lic_begin)
);

-- 1-to-1
-- Each licence number starts with a letter indicating the licence class
-- P for professional, R for applied research and A for avocational

CREATE TABLE archeology.archs
(
	arch_id SERIAL PRIMARY KEY,
	last_name text NOT NULL,
	first_name text NOT NULL, 
	father_name text,
	special spec,
	qualif qual,
	lic_id int DEFAULT NULL UNIQUE REFERENCES archeology.licenses ON DELETE SET NULL
);

-- ALTER TABLE archeology.archs
-- ADD FOREIGN KEY(arch_id) REFERENCES archeology.licenses(lic_id) ON DELETE SET NULL
-- DEFERRABLE INITIALLY DEFERRED;

-- ALTER TABLE archeology.licenses
-- ADD FOREIGN KEY(lic_id) REFERENCES archeology.archs(arch_id)
-- DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE archeology.reports
(	
	report_id SERIAL PRIMARY KEY,
	report_link text NOT NULL, 
	report_date DATE NOT NULL
);

-- Many-to-Many
CREATE TABLE archeology.arch_report
(	
	report_id int REFERENCES archeology.reports ON DELETE CASCADE,
	arch_id int REFERENCES archeology.archs,
	CONSTRAINT arch_report_pkey PRIMARY KEY (report_id, arch_id)
);

CREATE TABLE archeology.museums
(
	museum_id SERIAL PRIMARY KEY,
	museum_name text NOT NULL,
	museum_loc text,
	phone_number varchar(10)
);

CREATE TABLE archeology.rents 
(	
	rent_id SERIAL PRIMARY KEY,
	rent_begin DATE NOT NULL,
	rent_end DATE NOT NULL,
 	museum_id int REFERENCES archeology.museums ON DELETE CASCADE
);

CREATE TABLE archeology.finds
(	
	find_id SERIAL PRIMARY KEY,
	find_type find_type,
	find_loc text,
	find_date DATE NOT NULL,
	contidition smallint CHECK(contidition BETWEEN 0 AND 10),
	price decimal DEFAULT 0 CHECK(price >= 0),
	age int DEFAUlT NULL CHECK(age > 0),

	report_id int REFERENCES archeology.reports,
	rent_id int DEFAUlT NULL REFERENCES archeology.rents ON DELETE SET NULL
);

-- ALTER TABLE archeology.finds
-- ADD FOREIGN KEY(find_id) REFERENCES archeology.rents(rent_id)
-- DEFERRABLE INITIALLY DEFERRED;

-- ALTER TABLE archeology.rents
-- ADD FOREIGN KEY(rent_id) REFERENCES archeology.finds(find_id)
-- DEFERRABLE INITIALLY DEFERRED;