DROP VIEW find_dates;

-- Триггер №1. Поддержание целостности таблицы archeology.finds;
CREATE OR REPLACE FUNCTION find_trigger() RETURNS trigger AS $find_trigger$
	DECLARE tmp integer;
	BEGIN
-- 		IF NEW.find_type is NULL or NEW.find_type not in (SELECT enum_range(null::find_type)) THEN
-- 			NEW.find_type := 'Other';
-- 		END IF;
		IF NEW.condition > 10 THEN
			NEW.condition := 10;
		END IF;
		IF NEW.find_date is NULL or NEW.find_date > CURRENT_DATE THEN
			NEW.find_date := CURRENT_DATE;
		END IF;
		IF NEW.year_min > NEW.year_max THEN
			tmp := NEW.year_max;
			NEW.year_max := NEW.year_min;
			NEW.year_min := tmp;
		END IF;
		
		RETURN NEW;
	END;
$find_trigger$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER find_trigger BEFORE INSERT OR UPDATE ON archeology.finds
    FOR EACH ROW EXECUTE PROCEDURE find_trigger();
	
-- Триггер №2. Проверка, что дата находки <= даты написания отчета и даты сдачи в аренду)
CREATE VIEW find_dates AS
    SELECT 	find_id,
			find_date,
			report_date,
			rent_begin as rent_date
	FROM archeology.finds
	LEFT OUTER JOIN archeology.rents USING (rent_id)
	LEFT OUTER JOIN archeology.reports USING (report_id);
	
CREATE OR REPLACE FUNCTION find_rent_trigger() RETURNS trigger AS $find_rent_trigger$
    BEGIN
		PERFORM count(*)
		FROM find_dates WHERE (find_id = NEW.find_id and (find_date > report_date or find_date > rent_date));
		
        IF (SELECT count(*) FROM find_dates WHERE (find_dates.find_id = NEW.find_id and (find_date > report_date or find_date > rent_date))) > 0 THEN
			RAISE 'Datetime Error: find_date > report_date or find_date > rent_end';
		END IF;
        RETURN NULL;
    END;
$find_rent_trigger$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER find_rent_trigger AFTER INSERT OR UPDATE ON archeology.finds
    FOR EACH ROW EXECUTE PROCEDURE find_rent_trigger();
	