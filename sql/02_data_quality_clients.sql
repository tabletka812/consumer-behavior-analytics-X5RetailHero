SELECT * FROM public.clients
ORDER BY client_id ASC 



/*
Считаем количество нулевых значений во всех столбцах
*/
SELECT
    COUNT(*) FILTER (WHERE client_id IS NULL) as null_client_id,
    COUNT(*) FILTER (WHERE first_issue_date IS NULL) as null_first_issue_date,
    COUNT(*) FILTER (WHERE first_redeem_date IS NULL) as null_first_redeem_date,
    COUNT(*) FILTER (WHERE age IS NULL) as null_age,
    COUNT(*) FILTER (WHERE gender IS NULL) as null_gender
FROM clients;


/*
Некорректно указан возраст
*/
SELECT
    COUNT(*) as total_clients,
    COUNT(CASE WHEN age NOT BETWEEN 14 and 95 THEN 1 END) as incorrect_age,
    ROUND(100.0 * COUNT(CASE WHEN age NOT BETWEEN 14 and 95 THEN 1 END) / COUNT(*), 2) as incorrect_age_rate
FROM clients;


/*
Списание баллов раньше получения карты 
*/
SELECT COUNT(*) as invalid_sequence
FROM clients
WHERE first_redeem_date < first_issue_date;


/*
Карта выдана, но баллы не списывались ни разу
*/
SELECT
    COUNT(CASE WHEN first_redeem_date IS NULL THEN client_id END) as card_never_used,
    ROUND(100.0 * COUNT(CASE WHEN first_redeem_date IS NULL THEN client_id END) / COUNT(*), 2) as card_never_used_rate
FROM clients;


/*
Проверяем насколько часто встречается гендер "U" и можно ли его использовать подсчете метрик
*/
SELECT
    COUNT(*) FILTER (WHERE gender = 'F') as gender_f,
    COUNT(*) FILTER (WHERE gender = 'M') as gender_m,
    COUNT(*) FILTER (WHERE gender = 'U') as gender_u,
    ROUND(100.0 * COUNT(*) FILTER (WHERE gender = 'U') / COUNT(*), 2) as gender_u_percent
FROM clients;



/*
Подготовка таблицы к анализу
*/

CREATE OR REPLACE VIEW clients_clean AS
SELECT
    client_id,
    first_issue_date,
    first_redeem_date,
    CASE 
		WHEN age BETWEEN 14 AND 95 THEN age 
		ELSE NULL 
		END AS age_clean,
    gender,
    (first_redeem_date >= first_issue_date) AS valid_sequence
FROM clients;


 
