-- Create a stored procedure called buyer_for_date which accepts a first name, last name, and order date and returns the order_id, 
-- order_quantity, product_name and order_date for orders made by buyers with that name on that date.
-- Given a name and date, return the order details for that name and date

DELIMITER :
CREATE PROCEDURE buyer_for_date(IN first_name VARCHAR(255), IN last_name VARCHAR(255), IN order_date DATE)
BEGIN
	DECLARE orderID INT;
        DECLARE orderQuantity INT;
        DECLARE productName VARCHAR(255);
        DECLARE orderDate DATE;
        DECLARE firstName VARCHAR(255);
        DECLARE lastName VARCHAR(255);
        DECLARE finished_reading BOOL DEFAULT false;
        DECLARE dataCursor CURSOR FOR 
		SELECT order_id, order_quantity, product_name, order_date, first_name, last_name
		FROM buyers
		INNER JOIN orders ON buyers.buyer_id = orders.buyer_id
		INNER JOIN products ON products.product_id = orders.product_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished_reading = true;
		
	CREATE TABLE buyer_for_date (
		first_name VARCHAR(255),
            	order_id INT, 
            	order_quantity INT, 
            	product_name VARCHAR(255), 
            	order_date DATE
	);
        
        OPEN dataCursor;
        FETCH FROM dataCursor INTO orderID, orderQuantity, productName, orderDate, firstName, lastName;
        
        WHILE finished_reading = false DO
		IF firstName = first_name AND lastName = last_name AND orderDate = order_date THEN
			INSERT INTO buyer_for_date VALUES (firstName, orderID, orderQuantity, productName, orderDate);
		END IF;
		FETCH FROM dataCursor INTO orderID, orderQuantity, productName, orderDate, firstName, lastName;
	END WHILE;
        CLOSE dataCursor;

END:

CALL buyer_for_date('John', 'Doe', '2019-12-26');
SELECT * FROM buyer_for_date;


