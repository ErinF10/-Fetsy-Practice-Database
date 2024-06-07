-- Create a view called seller_sales_tiers which displays the seller_id, seller_name, total_sales sum. Also display 
-- the sales_tier based on the total sales for a seller. Apply the corresponding label:
-- $100,000.00 <= High
-- $10,000.00 <= Medium < $100,000.00
-- $10,000.00 > Low

CREATE VIEW seller_sales_tiers AS
SELECT seller_id, seller_name, total_sales
FROM (
	SELECT SUM(order_cost) AS total_sales, seller_id, seller_name
	FROM (
		-- creates a table with the total cost for each order
		SELECT (orders.order_quantity * products.product_price) AS order_cost, products.seller_id AS seller_id , seller_name
		FROM sellers
		INNER JOIN products ON sellers.seller_id = products.seller_id
		INNER JOIN orders ON orders.product_id = products.product_id
	) AS order_sums
    GROUP BY seller_id
) as total_sales;

SELECT * FROM seller_sales_tiers;
