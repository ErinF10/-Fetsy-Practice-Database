-- Create a stored procedure called top_products_for_seller which accepts a seller name and returns the seller_id,
--  product_id, product_name, and total_sales for all the products sold by that seller, sorted by most total sales (in terms of money) in descending order.

DELIMITER :
CREATE PROCEDURE top_products_for_seller (IN seller_name_given VARCHAR(255))
BEGIN
    DECLARE sellerID INT;
    DECLARE productID INT;
    DECLARE productName VARCHAR(255);
    DECLARE totalSales INT;
    DECLARE sellerName VARCHAR(255);
    DECLARE finished_reading BOOL DEFAULT false;
    
    DECLARE data_cursor CURSOR FOR SELECT seller_name, seller_id, product_id, product_name, total_sales
    FROM (
		 SELECT seller_name, seller_id, product_id, product_name, SUM(order_cost) AS total_sales
		FROM (
			SELECT (orders.order_quantity * products.product_price)/100 AS order_cost, products.seller_id AS seller_id , seller_name, products.product_id, product_name
			FROM sellers
			INNER JOIN products ON sellers.seller_id = products.seller_id
			INNER JOIN orders ON orders.product_id = products.product_id
		) AS order_sums
		GROUP BY product_id
		ORDER BY total_sales DESC
	) as temp_table;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished_reading = true;
    
    OPEN data_cursor;
    FETCH FROM data_cursor INTO sellerName, sellerID, productID, productName, totalSales;
    
    CREATE TABLE top_products_for_seller (
		seller_id INT, 
        product_id INT, 
        product_name VARCHAR(255), 
        total_sales VARCHAR(255)
	);
    WHILE finished_reading = false DO
		IF seller_name_given = sellerName THEN
			INSERT INTO top_products_for_seller VALUES (sellerID, productID, productName, CONCAT('$',FORMAT(totalSales,2,'en_US')));
		END IF;
        FETCH FROM data_cursor INTO sellerName, sellerID, productID, productName, totalSales;
	END WHILE;
END:

CALL top_products_for_seller('Smitham, Mraz and Schulist');
SELECT * FROM top_products_for_seller;




