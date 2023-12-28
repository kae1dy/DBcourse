-- Функция №1. Нормализация данных в формате jsonb поля "find_info" таблицы "finds".
CREATE OR REPLACE FUNCTION archeology.normalize_finds_info(
    type text DEFAULT 'Other',
    price numeric DEFAULT 0,
    year_min int DEFAULT NULL,
    year_max int DEFAULT NULL,
    condition int DEFAULT 0
)
RETURNS void AS $$
DECLARE
    cur_finds CURSOR FOR SELECT coalesce(find_info, '{}'::jsonb) as find_info FROM archeology.finds ORDER BY find_id DESC LIMIT 1; -- FOR TESTING
    tmp int;
BEGIN
    -- auto OPEN in FOR
    FOR record IN cur_finds LOOP
    
        IF NOT(record.find_info ? 'type') THEN
            record.find_info = record.find_info || jsonb_build_object('type', type);
        END IF;

        IF (NOT(record.find_info ? 'price')) or ((record.find_info->'price')::numeric < 0) THEN
            record.find_info = record.find_info || jsonb_build_object('price', price);
        END IF;

        IF NOT(record.find_info ? 'year_min') THEN
            record.find_info = record.find_info || jsonb_build_object('year_min', year_min);
        END IF;

        IF NOT(record.find_info ? 'year_max') THEN
            record.find_info = record.find_info || jsonb_build_object('year_max', year_max);
        END IF;

        IF (NOT(record.find_info ? 'condition')) OR ((record.find_info->'condition')::int NOT BETWEEN 0 and 10) THEN
            record.find_info = record.find_info || jsonb_build_object('condition', condition);
        END IF;
        
        IF (record.find_info->'year_min' > record.find_info->'year_max') THEN
            tmp := record.find_info->'year_min';
            record.find_info = record.find_info || jsonb_build_object('year_min', record.find_info->'year_max');
            record.find_info = record.find_info || jsonb_build_object('year_max', tmp);
        END IF;
        
        UPDATE archeology.finds 
        SET find_info = record.find_info
        WHERE CURRENT OF cur_finds;
        
    END LOOP;
EXCEPTION WHEN OTHERS THEN
    RAISE EXCEPTION 'Error when normalizing table "finds": %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Функция №2. Выборка археологов с необходимыми навыками(специализацией).
CREATE OR REPLACE FUNCTION archeology.needed_archs(
    VARIADIC special_ spec[]
)
RETURNS SETOF archeology.archs AS $$
BEGIN
    RETURN QUERY SELECT * FROM archeology.archs WHERE special @> special_;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'An archaeologists with the these specializations was not found: %.', special_;
    END IF;
    RETURN;
END;
$$ LANGUAGE plpgsql;

    
-- Функция №3. Проверка корректности лицензии указанного археолога.
CREATE OR REPLACE FUNCTION archeology.valid_licence(
    arch_id_ bigint
) 
RETURNS BOOLEAN AS $$
DECLARE
    lic_card_ archeology.archs.lic_card%TYPE;
    lic_end_ archeology.archs.lic_end%TYPE;
BEGIN 
    SELECT lic_card, lic_end INTO lic_card_, lic_end_ FROM archeology.archs WHERE arch_id = arch_id_;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'An archaeologist with this id was not found: %.', arch_id_;
    END IF;
    
    IF lic_card_ NOT SIMILAR TO '(P|R|A)%' THEN
        RETURN FALSE;
    END IF;
    IF lic_end_ <= CURRENT_DATE THEN
        RETURN FALSE;
    END IF;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;