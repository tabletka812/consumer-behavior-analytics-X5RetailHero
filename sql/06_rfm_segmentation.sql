WITH client_checks AS (
    SELECT DISTINCT transaction_id, client_id, purchase_sum, transaction_datetime
    FROM purchases
),
client_stats AS (
    SELECT
        client_id,
        COUNT(*) AS number_transaction,
        SUM(purchase_sum) AS total_amount,
        MIN(transaction_datetime) AS first_transaction,
        MAX(transaction_datetime) AS last_transaction
    FROM client_checks
    GROUP BY client_id
),
max_data_date AS (
    SELECT MAX(transaction_datetime)::date AS max_date
    FROM purchases
),
client_scored AS (
    SELECT
        cs.client_id,
        cs.number_transaction,
        cs.total_amount,
        cs.first_transaction,
        cs.last_transaction,
        (md.max_date - cs.last_transaction::date) AS recency,
        NTILE(3) OVER (ORDER BY (md.max_date - cs.last_transaction::date) ASC) AS r_score,
        NTILE(3) OVER (ORDER BY cs.number_transaction DESC) AS f_score,
        NTILE(3) OVER (ORDER BY cs.total_amount DESC) AS m_score
    FROM client_stats cs
    CROSS JOIN max_data_date md
),
rfm_result AS (
    SELECT
        *,
        r_score + f_score + m_score AS rfm_total,
        CASE
            WHEN r_score + f_score + m_score <= 4 THEN 'Лучшие клиенты'
            WHEN r_score + f_score + m_score <= 7 THEN 'Средние клиенты'
            ELSE 'Слабые клиенты'
        END AS rfm_segment
    FROM client_scored
)
SELECT
    rfm_segment,
    COUNT(*),
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM rfm_result
GROUP BY rfm_segment
ORDER BY COUNT(*) DESC;
