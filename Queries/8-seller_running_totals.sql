-- Create a stored procedure called seller_running_totals which accepts a seller name and returns the seller_id, order_id, order_date, 
-- order_total. Also show a running sales total (in terms of money) for that seller over all time (hint: windowing functions) under 
-- the column running_total. The running total should increase with each sale made.

DELIMITER :
CREATE PROCEDURE seller_running_totals(IN sellerName VARCHAR(255))
BEGIN
	SELECT seller_id, order_id, order_date, CONCAT('$', FORMAT(order_total, 2, 'en_US')) AS order_total, 
		CONCAT('$', FORMAT(sales_total, 2, 'en_US')) AS sales_total
	FROM (
		SELECT seller_id, order_id, order_date, order_total, SUM(order_total) OVER (ORDER BY order_date ROWS UNBOUNDED PRECEDING) AS sales_total
		FROM (
			SELECT (orders.order_quantity * products.product_price)/100 AS order_total, sellers.seller_id AS seller_id, 
				seller_name, orders.order_id AS order_id, order_date
			FROM sellers
            INNER JOIN products ON sellers.seller_id = products.seller_id
            INNER JOIN orders ON orders.product_id = products.product_id
            ORDER BY order_date
		) AS order_totals
        WHERE seller_name = sellerName
	) AS formatted_order_totals;
END:

CALL seller_running_totals('Smitham, Mraz and Schulist');
	
