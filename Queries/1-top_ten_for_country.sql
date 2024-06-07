-- Create a stored procedure called top_ten_for_country which accepts the name of a country and returns the buyer_id, first_name,
-- last_name, and total_amount_spent for the top ten buyers (in terms of total amount of money spent) for that country. 
-- Create a stored procedure called top_ten_for_country which accepts the name of a country and returns the buyer_id, first_name,
-- last_name, and total_amount_spent for the top ten buyers (in terms of total amount of money spent) for that country. 
-- Make sure to do an unnecessary join to another table

DELIMITER :
CREATE PROCEDURE top_ten_for_country(IN countryTest VARCHAR(255))
BEGIN
	DECLARE counter INT DEFAULT 0;
	DECLARE buyerID VARCHAR(255);
	DECLARE firstName VARCHAR(255);
	DECLARE lastName VARCHAR(255);
    	DECLARE cursorCountry VARCHAR(255);
    	DECLARE totalAmountSpent VARCHAR(255);	
	DECLARE buyerCursor CURSOR FOR 
		SELECT  buyer_id, first_name, last_name, SUM(order_cost) AS total_amount_spent, country
		FROM (
			SELECT (orders.order_quantity * products.product_price) AS order_cost, orders.order_id AS order_id, orders.buyer_id AS buyer_id, buyers.country AS country,
				buyers.first_name AS first_name, buyers.last_name AS last_name
			FROM orders
			INNER JOIN buyers ON buyers.buyer_id = orders.buyer_id
			INNER JOIN products ON orders.product_id = products.product_id
		) AS order_costs
		GROUP BY buyer_id;
        
	CREATE TABLE top_ten_for_country (
		buyer_id VARCHAR(255), 
		first_name VARCHAR(255), 
	        last_name VARCHAR(255),
	        total_amount_spent VARCHAR(255)
	);
    
	OPEN buyerCursor;
	FETCH FROM buyerCursor INTO buyerID, firstName, lastName, totalAmountSpent, cursorCountry;

	WHILE counter < 10 DO
		IF cursorCountry = countryTest THEN
			INSERT INTO top_ten_for_country VALUES (buyerID, firstName, lastName, totalAmountSpent);
			SET counter = counter + 1;
		END IF;
		FETCH FROM buyerCursor INTO buyerID, firstName, lastName, totalAmountSpent, cursorCountry;
	END WHILE;
	CLOSE buyerCursor;    
END:

CALL top_ten_for_country('United States'); 
SELECT buyer_id, first_name, last_name, CONCAT('$',FORMAT(total_amount_spent,2,'en_US')) AS total_amount_spent FROM top_ten_for_country;








