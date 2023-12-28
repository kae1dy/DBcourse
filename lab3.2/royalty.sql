-- SELECT * FROM archeology.archs LIMIT 5;

  
-- UPDATE archeology.archs 
-- SET royalty = (
-- 	WITH royalties as (
-- 		SELECT  arch_id,
-- 				ROUND(SUM(COALESCE((find_info->'price')::numeric, 0)) * 1 / 100, 2) as royalty
-- 		FROM archeology.archs
-- 		JOIN archeology.arch_report USING (arch_id)
-- 		JOIN archeology.finds USING (report_id)
-- 		GROUP BY (arch_id)
-- 	)
-- 	SELECT royalties.royalty FROM royalties
-- 	WHERE archs.arch_id = royalties.arch_id
-- );

UPDATE archeology.archs 
SET royalty = royalties.royalty 
FROM (
		SELECT  arch_id,
				ROUND(SUM(COALESCE((find_info->'price')::numeric, 0)) * 0.005, 2) as royalty
		FROM archeology.archs
		JOIN archeology.arch_report USING (arch_id)
		JOIN archeology.finds USING (report_id)
		GROUP BY (arch_id)
	) AS royalties
WHERE archs.arch_id = royalties.arch_id;

