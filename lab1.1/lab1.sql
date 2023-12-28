/* Запрос №1. Топ-10 самых загруженных аэропортов. */
WITH airports as (
    SELECT 	departure_airport as airport,
			departure_airport_name as airport_name,
			departure_city as city
	FROM flights_v 
	UNION ALL
	SELECT 	arrival_airport,
			arrival_airport_name, 
			arrival_city
	FROM flights_v
)
SELECT	airport,
		airport_name,
		city,
		COUNT(*) as flights, 
		rank() OVER (ORDER BY COUNT(*) DESC)
FROM airports
GROUP BY airport, airport_name, city
LIMIT 10;

/* Запрос №2. Самый дорогой/долгий рейс(с учётом всех перелётов). */
WITH tickets as (
	SELECT 	tf.ticket_no,
			SUM(tf.amount) as amount,
			SUM(f.scheduled_duration) as duration
	FROM ticket_flights as tf
		 JOIN flights_v as f ON tf.flight_id = f.flight_id
	GROUP BY tf.ticket_no
)
SELECT 	ticket_no,
		amount,
		duration
FROM tickets
ORDER BY amount DESC, duration DESC
LIMIT 1;
		
/* Запрос №3. Среднеквадратичное отклонение фактического времени полёта и планируемого (дисперсия). */		
WITH errors as (
	SELECT EXTRACT(EPOCH FROM (actual_duration - scheduled_duration)) as err
	FROM flights_v
	WHERE actual_duration IS NOT NULL
)
SELECT ROUND(AVG(err ^ 2), 3)
FROM errors;

/* Запрос №4. Распределение мест различных самолётов по классу обслуживания. */		
SELECT	s.aircraft_code,
		air.model,
		count(*) FILTER (WHERE fare_conditions = 'Economy') as economy,
		COUNT(*) FILTER (WHERE fare_conditions = 'Comfort') as comfort,
		COUNT(*) FILTER (WHERE fare_conditions = 'Business') as business,
		COUNT(*) as total
FROM seats as s
	JOIN aircrafts as air ON s.aircraft_code = air.aircraft_code 
GROUP BY (s.aircraft_code, air.model);






