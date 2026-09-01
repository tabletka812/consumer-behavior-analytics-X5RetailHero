/* 
Динамика по календарным месяцам: сколько выдач карт и сколько первых активаций произошло в каждом месяце (независимо друг от друга)
*/
SELECT COUNT(*) FILTER(WHERE first_issue_date IS NOT NULL) as received_cards,
    COUNT(*) FILTER(WHERE first_redeem_date IS NOT NULL) as used_card,
    ROUND (100.0 * COUNT(*) FILTER(WHERE first_redeem_date IS NOT NULL) /
    COUNT(*) FILTER(WHERE first_issue_date IS NOT NULL),2) as percent_used_card
FROM clients_clean
