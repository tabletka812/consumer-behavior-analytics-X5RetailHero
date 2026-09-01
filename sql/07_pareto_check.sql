WITH client_checks AS (
    SELECT DISTINCT transaction_id, client_id, purchase_sum
    FROM purchases
),

client_revenue AS (
    SELECT client_id, SUM(purchase_sum) AS clients_sum_checks
    FROM client_checks
    GROUP BY client_id
),

client_rank AS (
    SELECT
        client_id,
        clients_sum_checks,
        ROW_NUMBER() OVER (ORDER BY clients_sum_checks DESC) AS client_rank,
        COUNT(*) OVER () AS total_clients,
        SUM(clients_sum_checks) OVER (
            ORDER BY clients_sum_checks DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cum_revenue,
        SUM(clients_sum_checks) OVER () AS total_revenue
    FROM client_revenue
),

client_pareto AS (
    SELECT
        client_id,
        clients_sum_checks,
        client_rank,
        ROUND(100.0 * client_rank / total_clients, 2) AS clients_pct_cum,
        ROUND(100.0 * cum_revenue / total_revenue, 2) AS revenue_pct_cum
    FROM client_rank
)

SELECT *
FROM client_pareto
ORDER BY client_rank;
