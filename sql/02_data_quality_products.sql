SELECT * FROM public.products
ORDER BY product_id ASC 

/*
Считаем количество нулевых значений во всех столбцах
*/
SELECT
    COUNT(*) FILTER (WHERE level_1 IS NULL) as null_level_1,
    COUNT(*) FILTER (WHERE level_2 IS NULL) as null_level_2,
    COUNT(*) FILTER (WHERE level_3 IS NULL) as null_level_3,
    COUNT(*) FILTER (WHERE level_4 IS NULL) as null_level_4,
    COUNT(*) FILTER (WHERE segment_id IS NULL) as null_segment_id,
    COUNT(*) FILTER (WHERE brand_id IS NULL) as null_brand_id,
    COUNT(*) FILTER (WHERE vendor_id IS NULL) as null_vendor_id,
    COUNT(*) FILTER (WHERE netto IS NULL) as null_netto
FROM products;


/*
Смотрим на выбросы netto
*/
SELECT product_id, level_1, level_2, level_3, netto
FROM products
WHERE netto > 20
ORDER BY netto DESC;



/*
Подготовка таблицы к анализу
*/

CREATE OR REPLACE VIEW products_clean AS
SELECT
    product_id,
    level_1, level_2, level_3, level_4,
    segment_id,
	CASE 
		WHEN brand_id IS NULL THEN 'не указан'
		ELSE brand_id
	END AS brand_id_clean,
    vendor_id,
    netto,
    is_own_trademark,
    is_alcohol
FROM products;
