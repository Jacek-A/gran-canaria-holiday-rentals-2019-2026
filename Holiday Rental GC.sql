

CREATE TABLE public.vv_indicators (
    measure TEXT NOT NULL,
    area TEXT NOT NULL,
    period TEXT NOT NULL,
    month_start DATE NOT NULL,
    value NUMERIC
);

CREATE TABLE public.vv_daily_rates (
    area TEXT NOT NULL,
    capacity_band TEXT NOT NULL,
    period TEXT NOT NULL,
    month_start DATE NOT NULL,
    daily_rate NUMERIC
);

SELECT COUNT(*) FROM public.vv_indicators;

SELECT * 
FROM public.vv_indicators
LIMIT 10;

SELECT COUNT(*), COUNT(measure), COUNT(area), COUNT(period), COUNT(month_start), COUNT(value)
FROM public.vv_indicators;

SELECT
    measure,
    COUNT(*) AS total_rows,
    COUNT(value) AS non_missing_values,
    COUNT(*) - COUNT(value) AS missing_values
FROM public.vv_indicators
GROUP BY measure
ORDER BY measure;

SELECT measure
FROM public.vv_indicators
GROUP BY measure;

SELECT 
	month_start, measure, value 
FROM public.vv_indicators
WHERE area='Mogán'
ORDER BY month_start, measure;

SELECT
    month_start,
    MAX(value) FILTER (WHERE measure = 'Ingresos totales') AS total_income,
    MAX(value) FILTER (WHERE measure = 'Viviendas vacacionales disponibles') AS available_homes,
    MAX(value) FILTER (WHERE measure = 'Viviendas vacacionales reservadas') AS reserved_homes,
    MAX(value) FILTER (WHERE measure = 'Plazas disponibles') AS available_places,
    MAX(value) FILTER (WHERE measure = 'Estancia media en la vivienda vacacional') AS average_stay_days,
    MAX(value) FILTER (WHERE measure = 'Tasa de vivienda reservada') AS reservation_rate
FROM public.vv_indicators
WHERE area = 'Mogán'
GROUP BY month_start
ORDER BY month_start;

WITH available_homes AS(
	SELECT to_char(month_start, 'MM') AS month_num,
	measure,
	area,
	value
FROM public.vv_indicators
)
SELECT
	month_num,
	AVG(value) AS avg_available_homes
FROM available_homes
WHERE measure = 'Viviendas vacacionales disponibles'
AND area = 'Gran Canaria'
GROUP BY month_num;

SELECT
	area,
	EXTRACT(YEAR FROM month_start)::int AS year,
	AVG(value) AS avg_available_homes
FROM public.vv_indicators
WHERE EXTRACT(YEAR FROM month_start) IN ('2019', '2025') AND measure = 'Viviendas vacacionales disponibles'
	AND area IN ('Agaete', 'Agüimes', 'Artenara', 'Arucas', 'Firgas', 'Gáldar', 'Ingenio', 'La Aldea de San Nicolás', 'Las Palmas de Gran Canaria', 'Mogán', 'Moya', 'San Bartolomé de Tirajana', 'Santa Brígida', 'Santa Lucía de Tirajana', 'Santa María de Guía de Gran Canaria', 'Tejeda', 'Telde', 'Teror', 'Valleseco', 'Valsequillo de Gran Canaria', 'Vega de San Mateo')
GROUP BY area, EXTRACT(YEAR FROM month_start);

SELECT
	area,
	ROUND (AVG(value) FILTER(WHERE EXTRACT(YEAR FROM month_start) = '2019'), 1) AS avg_available_homes_2019,
	ROUND (AVG(value) FILTER(WHERE EXTRACT(YEAR FROM month_start) = '2025'), 1) AS avg_available_homes_2025
FROM public.vv_indicators
WHERE measure = 'Viviendas vacacionales disponibles' AND area IN
	('Agaete', 'Agüimes', 'Artenara', 'Arucas', 'Firgas', 'Gáldar', 'Ingenio', 'La Aldea de San Nicolás', 'Las Palmas de Gran Canaria', 'Mogán', 'Moya', 'San Bartolomé de Tirajana', 'Santa Brígida', 'Santa Lucía de Tirajana', 'Santa María de Guía de Gran Canaria', 'Tejeda', 'Telde', 'Teror', 'Valleseco', 'Valsequillo de Gran Canaria', 'Vega de San Mateo')
GROUP BY area;

WITH avg_homes_each_yr AS(
	SELECT
	area,
	AVG(value) FILTER(WHERE EXTRACT(YEAR FROM month_start) = 2019) AS avg_available_homes_2019,
	AVG(value) FILTER(WHERE EXTRACT(YEAR FROM month_start) = 2020) AS avg_available_homes_2020,
	AVG(value) FILTER(WHERE EXTRACT(YEAR FROM month_start) = 2021) AS avg_available_homes_2021,
	AVG(value) FILTER(WHERE EXTRACT(YEAR FROM month_start) = 2022) AS avg_available_homes_2022,
	AVG(value) FILTER(WHERE EXTRACT(YEAR FROM month_start) = 2023) AS avg_available_homes_2023,
	AVG(value) FILTER(WHERE EXTRACT(YEAR FROM month_start) = 2024) AS avg_available_homes_2024,
	AVG(value) FILTER(WHERE EXTRACT(YEAR FROM month_start) = 2025) AS avg_available_homes_2025,
FROM public.vv_indicators
WHERE measure = 'Viviendas vacacionales disponibles' AND area IN
	('Agaete', 'Agüimes', 'Artenara', 'Arucas', 'Firgas', 'Gáldar', 'Ingenio', 'La Aldea de San Nicolás', 'Las Palmas de Gran Canaria', 'Mogán', 'Moya', 'San Bartolomé de Tirajana', 'Santa Brígida', 'Santa Lucía de Tirajana', 'Santa María de Guía de Gran Canaria', 'Tejeda', 'Telde', 'Teror', 'Valleseco', 'Valsequillo de Gran Canaria', 'Vega de San Mateo')
GROUP BY area
)
SELECT *,
	ROUND(avg_available_homes_2020 - avg_available_homes_2019, 1) AS abs_change_19_20,
	ROUND(avg_available_homes_2021 - avg_available_homes_2020, 1) AS abs_change_20_21,
	ROUND(avg_available_homes_2022 - avg_available_homes_2021, 1) AS abs_change_21_22,
	ROUND(avg_available_homes_2023 - avg_available_homes_2022, 1) AS abs_change_22_23,
	ROUND(avg_available_homes_2024 - avg_available_homes_2023, 1) AS abs_change_23_24,
	ROUND(avg_available_homes_2025 - avg_available_homes_2024, 1) AS abs_change_24_25,
	ROUND(100*(avg_available_homes_2020 - avg_available_homes_2019)/avg_available_homes_2019, 1) AS perc_change_19_20,
	ROUND(100*(avg_available_homes_2021 - avg_available_homes_2020)/avg_available_homes_2020, 1) AS perc_change_20_21,
	ROUND(100*(avg_available_homes_2022 - avg_available_homes_2021)/avg_available_homes_2021, 1) AS perc_change_21_22,
	ROUND(100*(avg_available_homes_2023 - avg_available_homes_2022)/avg_available_homes_2022, 1) AS perc_change_22_23,
	ROUND(100*(avg_available_homes_2024 - avg_available_homes_2023)/avg_available_homes_2023, 1) AS perc_change_23_24,
	ROUND(100*(avg_available_homes_2025 - avg_available_homes_2024)/avg_available_homes_2024, 1) AS perc_change_24_25,
	ROUND(100*(avg_available_homes_2025 - avg_available_homes_2019)/avg_available_homes_2019, 1) AS perc_change_19_25,
	area
FROM avg_homes_each_yr
ORDER BY 100*(avg_available_homes_2025 - avg_available_homes_2019)/avg_available_homes_2019 DESC;

WITH available_homes_compared AS (
SELECT
	area, 
	month_start,
	value AS available_homes,
	LAG(value, 12) OVER (PARTITION BY area ORDER BY month_start) AS homes_same_month_last_year
FROM vv_indicators
WHERE measure = 'Viviendas vacacionales disponibles' AND area IN
	('Agaete', 'Agüimes', 'Artenara', 'Arucas', 'Firgas', 'Gáldar', 'Ingenio', 'La Aldea de San Nicolás', 'Las Palmas de Gran Canaria', 'Mogán', 'Moya', 'San Bartolomé de Tirajana', 'Santa Brígida', 'Santa Lucía de Tirajana', 'Santa María de Guía de Gran Canaria', 'Tejeda', 'Telde', 'Teror', 'Valleseco', 'Valsequillo de Gran Canaria', 'Vega de San Mateo')
)
SELECT 
	area,
	month_start,
	available_homes,
	homes_same_month_last_year,
	available_homes - homes_same_month_last_year AS change,
	100.0 * (available_homes - homes_same_month_last_year)/NULLIF(homes_same_month_last_year, 0) AS change_pct
FROM available_homes_compared;

SELECT *
FROM vv_daily_rates
LIMIT 10;

SELECT *
FROM vv_indicators
LIMIT 10;

WITH monthly_indicators AS (
    SELECT
        i.area,
        i.month_start,
        MAX(i.value) FILTER (
            WHERE i.measure = 'Viviendas vacacionales disponibles'
        ) AS available_homes,
        MAX(i.value) FILTER (
            WHERE i.measure = 'Viviendas vacacionales reservadas'
        ) AS reserved_homes,
        MAX(i.value) FILTER (
            WHERE i.measure = 'Tasa de vivienda reservada'
        ) AS reservation_rate
    FROM public.vv_indicators AS i
    WHERE i.measure IN (
        'Viviendas vacacionales disponibles',
        'Viviendas vacacionales reservadas',
        'Tasa de vivienda reservada')
		AND area IN
	('Agaete', 'Agüimes', 'Artenara', 'Arucas', 'Firgas', 'Gáldar', 'Ingenio', 'La Aldea de San Nicolás', 'Las Palmas de Gran Canaria', 'Mogán', 'Moya', 'San Bartolomé de Tirajana', 'Santa Brígida', 'Santa Lucía de Tirajana', 'Santa María de Guía de Gran Canaria', 'Tejeda', 'Telde', 'Teror', 'Valleseco', 'Valsequillo de Gran Canaria', 'Vega de San Mateo')
    GROUP BY i.area, i.month_start
),
monthly_rates AS (
    SELECT area, month_start, daily_rate
    FROM public.vv_daily_rates
    WHERE capacity_band = 'Total'
	AND area IN
	('Agaete', 'Agüimes', 'Artenara', 'Arucas', 'Firgas', 'Gáldar', 'Ingenio', 'La Aldea de San Nicolás', 'Las Palmas de Gran Canaria', 'Mogán', 'Moya', 'San Bartolomé de Tirajana', 'Santa Brígida', 'Santa Lucía de Tirajana', 'Santa María de Guía de Gran Canaria', 'Tejeda', 'Telde', 'Teror', 'Valleseco', 'Valsequillo de Gran Canaria', 'Vega de San Mateo')
    )
SELECT
    i.area,
    i.month_start,
    i.available_homes,
    i.reserved_homes,
    i.reservation_rate,
    r.daily_rate
FROM monthly_indicators AS i
LEFT JOIN monthly_rates AS r
    ON i.area = r.area
   AND i.month_start = r.month_start;


SELECT
    area,
    MIN(value) AS min_available_homes,
    MAX(value) AS max_available_homes
FROM vv_indicators
WHERE area = 'Artenara'
  AND measure = 'Viviendas vacacionales disponibles'
GROUP BY area;