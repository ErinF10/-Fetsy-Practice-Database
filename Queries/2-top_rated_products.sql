-- Create a view called top_rated_products which displays the product_id, product_name, product_price, avg_rating and rating_count for 
-- the top ten products according to their average rating (minimum of 20 ratings).

CREATE VIEW top_rated_products AS 
	SELECT products.product_id, product_name, CONCAT('$',FORMAT(product_price,2,'en_US')) AS product_price, AVG(rating) AS avg_rating, COUNT(rating) AS rating_count 
	FROM products, orders
    	WHERE orders.product_id = products.product_id
    	GROUP BY products.product_id
	HAVING rating_count > 20
	ORDER BY avg_rating DESC
    	LIMIT 10;

SELECT * FROM top_rated_products;

