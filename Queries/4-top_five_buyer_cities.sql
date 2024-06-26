-- Create a view called top_five_buyer_cities which displays the city and total_amount_spent for the top five 
-- cities in terms buyer spending, descending order. Display the sum of spending (per city).

CREATE VIEW top_five_cities AS 
SELECT CONCAT('$',FORMAT(total_amount_spent,2,'en_US')) as total_amount_spent, city
FROM (
	SELECT SUM(order_cost) AS total_amount_spent, city
	FROM (
		-- creates a table with the total cost for each order
		SELECT (orders.order_quantity * products.product_price) AS order_cost, orders.order_id AS order_id, orders.buyer_id AS buyer_id, 
			buyers.city AS city, buyers.first_name AS first_name, buyers.last_name AS last_name
		FROM orders
		INNER JOIN buyers ON buyers.buyer_id = orders.buyer_id
		INNER JOIN products ON orders.product_id = products.product_id
		) AS order_sums
	GROUP BY city ORDER BY total_amount_spent DESC
) AS total_spent
LIMIT 5;

SELECT * FROM top_five_cities;

