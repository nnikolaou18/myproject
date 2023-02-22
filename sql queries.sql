SELECT 
  city, 
  SUM(CASE WHEN cuisine = 'Breakfast' THEN ammount ELSE 0 END) / count(distinct case when cuisine = 'Breakfast' then order_id else 0 end) AS breakfast_basket,
  SUM(ammount) / count(order_id) AS total_basket,
  count(distinct case when cuisine = 'Breakfast' then order_id else 0 end) / COUNT(distinct case when cuisine = 'Breakfast' then user_id else 0 end) AS breakfast_frequency,
  count(order_id) / COUNT(DISTINCT user_id) AS total_frequency,
    count(distinct case when cuisine = 'Breakfast' then order_id else 0 end) / COUNT(distinct case when cuisine = 'Breakfast' then user_id else 0 end)/cOUNT(distinct case when cuisine = 'Breakfast' then user_id else 0 end) *100 AS breakfast_percentage_users_over_3_orders,
    sum(CASE WHEN rank <= 10 THEN order_id ELSE 0 END) / sum(order_id) AS top_10_users_contribution,
  (SUM(CASE WHEN rank <= 10 THEN order_id ELSE 0 END) / SUM(order_id)) * 100 AS top_10_users_contribution_percentage
FROM (
  SELECT 
    city,
    order_id,
    user_id,
    ammount,
    cuisine,
    ROW_NUMBER() OVER (PARTITION BY city ORDER BY order_id DESC) AS rank
  FROM `efood2022-378222.main_assessment.orders`
)
GROUP BY city
HAVING SUM(CASE WHEN cuisine = 'Breakfast' THEN order_id ELSE 0 END) > 1000
ORDER BY SUM(CASE WHEN cuisine = 'Breakfast' THEN order_id ELSE 0 END) DESC
LIMIT 5
