/*
Считаем гортную воронку активации карты 
*/
SELECT EXTRACT(YEAR FROM first_issue_date) AS year, EXTRACT(MONTH FROM first_issue_date) AS month,
    COUNT(*) as clients_get_card,
    COUNT(*) FILTER (WHERE first_redeem_date IS NOT NULL) AS used_card,
    ROUND(100.0 * COUNT(*) FILTER (WHERE first_redeem_date IS NOT NULL) / COUNT(*), 2) AS activation_rate_pct
FROM clients_clean
WHERE is_valid_redeem_sequence IS DISTINCT FROM FALSE
GROUP BY EXTRACT(YEAR FROM first_issue_date), EXTRACT(MONTH FROM first_issue_date)
ORDER BY year, month
