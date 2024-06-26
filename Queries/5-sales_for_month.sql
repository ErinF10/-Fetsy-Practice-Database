-- Create a stored procedure called sales_for_month which accepts a specific month (i.e. month and year) and returns the month_and_year 
-- (in one column) and sum of all sales in that month (under the column total_sales).

DELIMITER :
CREATE PROCEDURE sales_for_month(IN month_input DATE)
BEGIN
    DECLARE orderDate DATE;
    DECLARE totalAmountSpentOrder INT DEFAULT 0;
    DECLARE total_amount_spent_month INT DEFAULT 0;
    DECLARE finished_reading BOOL DEFAULT false;
    
    DECLARE data_cursor CURSOR FOR SELECT order_date, total_amount_spent_order
    FROM (
    SELECT order_date, total_amount_spent_order FROM (
    SELECT order_date, SUM(order_cost)/100 AS total_amount_spent_order
	FROM (
		SELECT (orders.order_quantity * products.product_price) AS order_cost, orders.order_id AS order_id,  
			orders.order_date AS order_date
		FROM orders
		INNER JOIN products ON orders.product_id = products.product_id
	) AS order_sums
	GROUP BY order_date 
        ORDER BY total_amount_spent_order DESC
        ) as temper_table
	) as temp_table;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished_reading = true;
	-- SET month_input = STR_TO_DATE(month_input_string, "%Y-%m-%d");

    OPEN data_cursor;
    FETCH FROM data_cursor INTO orderDate, totalAmountSpentOrder;

    WHILE finished_reading = false DO
	IF MONTH(month_input) = MONTH(orderDate) AND YEAR(month_input) = YEAR(orderDate) THEN
            SET total_amount_spent_month = total_amount_spent_month + totalAmountSpentOrder;
	END IF;
	FETCH FROM data_cursor INTO orderDate, totalAmountSpentOrder;
	END WHILE;

    CREATE TABLE sales_for_month (
	order_date VARCHAR(255),
        total_amount_spent int
	);
    
    INSERT INTO sales_for_month 
    VALUES (CONCAT(YEAR(month_input), "-", MONTH(month_input)), total_amount_spent_month);
END:

-- For input add any day of the month to return the whole value for the entire month
CALL sales_for_month('2024-01-09');
SELECT order_date, CONCAT('$',FORMAT(total_amount_spent,2,'en_US')) AS total_amount_spent FROM sales_for_month;
