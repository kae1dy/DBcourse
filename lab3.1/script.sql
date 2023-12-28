DROP SCHEMA IF EXISTS archeology CASCADE;
CREATE SCHEMA archeology;

-- DROP TYPE IF EXISTS spec;
-- CREATE TYPE spec AS ENUM (
--                         'Field', 
--                         'Anthropologist',
--                         'Ceramologist',
--                         'Archaeozoologist',
--                         'Marine'
-- );

-- Each licence number starts with a letter indicating the licence class
-- P for professional, R for applied research and A for avocational

CREATE TABLE archeology.archs
(
    arch_id bigserial PRIMARY KEY,
    last_name text NOT NULL,
    first_name text NOT NULL, 
    father_name text,
    special spec[],
    country_name text NOT NULL,
    
    lic_card varchar(12) CHECK(lic_card SIMILAR TO '(P|R|A)%') UNIQUE NOT NULL,
    lic_begin DATE NOT NULL,
    lic_end DATE NOT NULL CHECK(lic_end > lic_begin)
);

CREATE TABLE archeology.reports
(   
    report_id bigserial PRIMARY KEY,
    report_link text NOT NULL, 
    report_date DATE NOT NULL
);

-- Many-to-Many
CREATE TABLE archeology.arch_report
(   
    report_id bigint REFERENCES archeology.reports ON DELETE CASCADE,
    arch_id bigint REFERENCES archeology.archs,
    CONSTRAINT arch_report_pkey PRIMARY KEY (report_id, arch_id)
);

CREATE TABLE archeology.finds
(   
    find_id bigserial PRIMARY KEY,
    find_coords point,
    find_date DATE NOT NULL,
    find_info jsonb,
    
    museum_name text NOT NULL,
    rent_begin DATE NOT NULL,
    rent_end DATE NOT NULL CHECK(rent_end > rent_begin),
    
    report_id bigint REFERENCES archeology.reports
);