with active_week_clients AS(
	SELECT client_id, DATE_TRUNC('week', transaction_datetime) AS activity_week
	FROM purchases
),

start_week_client AS(
	SELECT client_id, activity_week, MIN(activity_week) OVER(PARTITION BY client_id) as start_week
	FROM active_week_clients
),

cohort_activity AS(
	SELECT client_id, start_week,
		(activity_week::date - start_week::date) / 7 AS week_number
    FROM start_week_client

),

cohort_size AS (
    SELECT start_week, COUNT(DISTINCT client_id) AS cohort_clients
    FROM cohort_activity
    WHERE week_number = 0
    GROUP BY start_week
),
 
max_data_date AS (
    SELECT MAX(transaction_datetime)::date AS last_date 
	FROM purchases
)

SELECT act.start_week, cs.cohort_clients, act.week_number,
    COUNT(DISTINCT act.client_id) AS active_clients,
    ROUND(100.0 * COUNT(DISTINCT act.client_id) / cs.cohort_clients, 1) AS retention_pct,
    (act.start_week::date + (act.week_number + 1) * 7 <= (
	SELECT last_date FROM max_data_date) 
	+ 1) AS is_complete_period
FROM cohort_activity act
JOIN cohort_size cs 
ON cs.start_week = act.start_week
GROUP BY act.start_week, cs.cohort_clients, act.week_number
ORDER BY act.start_week, act.week_number;
