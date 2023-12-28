SELECT * FROM archeology.finds LIMIT 5;
  
WITH royalties as (
	SELECT  arch_id,
			ROUND(SUM(COALESCE(price, 0)) * 1 / 100, 2) as royalty
	FROM archeology.archs
	JOIN archeology.arch_report USING (arch_id)
	JOIN archeology.finds USING (report_id)
	GROUP BY (arch_id)
)
UPDATE archeology.archs 
SET archs.royalty = royalties.royalty
WHERE archs.arch_id = royalties.arch_id;
