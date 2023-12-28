CREATE VIEW archeology.arch_all_finds AS
	SELECT 	arch_id,
			last_name,
			first_name,
			father_name,
			special,
			find_id,
			find_coords,
			find_info
		FROM archeology.archs
		JOIN archeology.arch_report USING (arch_id)
		JOIN archeology.finds USING (report_id);
		
CREATE materialized VIEW archeology.arch_all_finds_materialized AS
	SELECT 	arch_id,
			last_name,
			first_name,
			father_name,
			special,
			find_id,
			find_coords,
			find_info
		FROM archeology.archs
		JOIN archeology.arch_report USING (arch_id)
		JOIN archeology.finds USING (report_id);
		
/* Замеры скорости выполнения запроса с view/materialized_view. 7s. vs 4s. */
EXPLAIN ANALYZE SELECT * FROM archeology.arch_all_finds LIMIT 10000;

EXPLAIN ANALYZE SELECT * FROM archeology.arch_all_finds_materialized LIMIT 10000;
