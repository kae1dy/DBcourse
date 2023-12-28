/* Запрос №1. Роялти для каждого из археологов. */
SELECT  arch_id,
        last_name,
        first_name,
        father_name,
        ROUND(SUM(COALESCE(price, 0)) * 1 / 100, 2) as royalty
        
FROM archeology.archs
LEFT OUTER JOIN archeology.arch_report USING (arch_id)
LEFT OUTER JOIN archeology.finds USING (report_id)
GROUP BY (arch_id, last_name, first_name, father_name)
ORDER BY royalty DESC;

/* Запрос №2. Средний возраст находок, распределённых по различным музеям. */
SELECT  museum_id,
        museum_name,
        ROUND(AVG(date_part('year', CURRENT_DATE) - (year_max + year_min) / 2)) as age_finds
        
FROM archeology.museums
LEFT OUTER JOIN archeology.rents USING(museum_id)
LEFT OUTER JOIN archeology.finds USING(rent_id)
GROUP BY (museum_id, museum_name)
ORDER BY (age_finds) DESC;

/* Запрос №3. Коэффициент корреляции между стоимостью находки и её состоянием.
              (Взаимосвязь двух характеристик между собой). */
WITH find_corr as (
    SELECT  find_type,
            CORR(price, condition) as corr_coef
    FROM archeology.finds
    GROUP BY find_type
)
SELECT  find_type,
        COALESCE(ROUND(corr_coef::numeric, 2), 0) as corr_coef
FROM find_corr
ORDER BY corr_coef DESC;


/* Запрос №4. Распределение количества находок в зависимости от квалификации археолога. */
SELECT  qualif,
        COUNT(*) as num_finds
FROM archeology.archs
LEFT OUTER JOIN archeology.arch_report USING (arch_id)
LEFT OUTER JOIN archeology.finds USING (report_id)
GROUP BY qualif
ORDER BY num_finds DESC;