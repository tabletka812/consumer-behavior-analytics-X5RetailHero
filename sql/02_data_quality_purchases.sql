SELECT * FROM public.purchases
LIMIT 100

/*
Считаем количество нулевых значений во всех столбцах
*/
SELECT
    COUNT(*) FILTER (WHERE client_id IS NULL) as null_client_id,
    COUNT(*) FILTER (WHERE transaction_id IS NULL) as null_transaction_id,
    COUNT(*) FILTER (WHERE transaction_datetime IS NULL) as null_transaction_datetime,
    COUNT(*) FILTER (WHERE regular_points_received IS NULL) as null_regular_points_received,
    COUNT(*) FILTER (WHERE express_points_received IS NULL) as null_express_points_received,
    COUNT(*) FILTER (WHERE regular_points_spent IS NULL) as null_regular_points_spent,
    COUNT(*) FILTER (WHERE express_points_spent IS NULL) as null_express_points_spent,
    COUNT(*) FILTER (WHERE purchase_sum IS NULL) as null_purchase_sum,
    COUNT(*) FILTER (WHERE store_id IS NULL) as null_store_id,
    COUNT(*) FILTER (WHERE product_id IS NULL) as null_product_id,
    COUNT(*) FILTER (WHERE product_quantity IS NULL) as null_product_quantity,
    COUNT(*) FILTER (WHERE trn_sum_from_iss IS NULL) as null_trn_sum_from_iss,
    COUNT(*) FILTER (WHERE trn_sum_from_red IS NULL) as null_trn_sum_from_red
FROM purchases;


/*
Считаем отрицательные суммы покупок
*/

SELECT
    COUNT(*) FILTER (WHERE purchase_sum <= 0) AS nonpositive_sum,
    ROUND(100.0 * COUNT(*) FILTER (WHERE purchase_sum <= 0) / COUNT(*), 4) AS percent_nonpositive_sum
FROM purchases;


/*
Диапазон дат транзацкий
*/

SELECT MIN(transaction_datetime), MAX(transaction_datetime)
FROM purchases;


/*
Проверяем логическую связь между таблицой purchases и таблицами clients и products
*/
SELECT
    COUNT(*) FILTER (WHERE c.client_id IS NULL) AS o_client_id,
    COUNT(*) FILTER (WHERE p.product_id IS NULL) AS orphan_product_id
FROM purchases pu
LEFT JOIN clients c ON c.client_id = pu.client_id
LEFT JOIN products p ON p.product_id = pu.product_id;


