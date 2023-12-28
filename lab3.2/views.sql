CREATE VIEW archeology.archs_non_valid_lic AS
	SELECT 	arch_id,
			last_name,
			first_name,
			father_name,
			country_name,
			lic_card,
			lic_begin,
			lic_end
	FROM archeology.archs
	WHERE lic_end <= CURRENT_DATE
	WITH LOCAL CHECK OPTION;
	
CREATE VIEW archeology.finds_non_valid_rent AS
	SELECT 	find_id,
			find_info,
			museum_name,
			rent_begin,
			rent_end
	FROM archeology.finds
	WHERE rent_end <= CURRENT_DATE
	WITH LOCAL CHECK OPTION;
	
GRANT SELECT ON archeology.archs_non_valid_lic TO test;

CREATE ROLE test_group;
GRANT UPDATE(lic_end) ON archeology.archs_non_valid_lic TO test_group;
GRANT test_group TO test;
