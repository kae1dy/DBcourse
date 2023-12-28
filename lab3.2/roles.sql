CREATE USER test PASSWORD 'test';

/* Для обращения к объектам в схеме archeology. */
GRANT USAGE ON SCHEMA archeology TO test;

GRANT SELECT, INSERT, UPDATE ON archeology.finds TO test;
GRANT SELECT (last_name, first_name, father_name, special, country_name, royalty), UPDATE (special, royalty) ON archeology.archs TO test;

GRANT SELECT ON archeology.arch_report TO test;
GRANT SELECT ON archeology.reports TO test;

