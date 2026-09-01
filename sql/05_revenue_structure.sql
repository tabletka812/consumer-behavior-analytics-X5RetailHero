with revenue_for_category AS(
	SELECT pro.level_2, SUM(pur.trn_sum_from_iss) as revenue, COUNT(*) as number_of_purchases
	FROM products_clean pro
	JOIN purchases pur 
	ON pro.product_id = pur.product_id
	GROUP BY level_2
)

SELECT r.level_2, r.revenue, r.number_of_purchases,
	RANK() OVER(ORDER BY r.revenue DESC)
FROM revenue_for_category r
ORDER BY revenue DESC

