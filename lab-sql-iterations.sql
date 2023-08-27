# Lab | SQL Iterations

# In this lab, we will continue working on the Sakila database of movie rentals.

USE sakila;

# Instructions

# Write queries to answer the following questions:

# Write a query to find what is the total business done by each store.

SELECT s.store_id AS Store, SUM(p.amount) AS Total_Amount 
FROM store s
JOIN customer c ON s.store_id = c.store_id
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY s.store_id;


SELECT * FROM store;

# Convert the previous query into a stored procedure.

DROP PROCEDURE IF EXISTS Total_Amount_By_Store;

DELIMITER //

CREATE PROCEDURE Total_Amount_By_Store()
BEGIN
    SELECT s.store_id AS Store, SUM(p.amount) AS Total_Amount 
    FROM store s
    JOIN customer c ON s.store_id = c.store_id
    JOIN payment p ON p.customer_id = c.customer_id
    GROUP BY s.store_id;
END;
//

DELIMITER ;


CALL Total_Amount_By_Store(); 


# Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DROP PROCEDURE IF EXISTS Total_Amount_By_Store2;

DELIMITER //

CREATE PROCEDURE Total_Amount_By_Store2(IN param1 INT)
BEGIN
    SELECT s.store_id AS Store, SUM(p.amount) AS Total_Amount 
    FROM store s
    JOIN customer c ON s.store_id = c.store_id
    JOIN payment p ON p.customer_id = c.customer_id
    WHERE s.store_id = param1
    GROUP BY s.store_id;
END;
//

DELIMITER ;

CALL Total_Amount_By_Store2(1);

# Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.

DROP PROCEDURE IF EXISTS Total_Amount_By_Store3;

DELIMITER //

CREATE PROCEDURE Total_Amount_By_Store3(IN param1 INT)
BEGIN
    DECLARE total_sales_value FLOAT;

    SELECT SUM(p.amount)
    INTO total_sales_value
    FROM store s
    JOIN customer c ON s.store_id = c.store_id
    JOIN payment p ON p.customer_id = c.customer_id
    WHERE s.store_id = param1;

    SELECT param1 AS Store, total_sales_value AS Total_Amount;
END;
//

DELIMITER ;

CALL Total_Amount_By_Store3(1);


# In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.


DROP PROCEDURE IF EXISTS Store_Sales_With_Flag;

DELIMITER //

CREATE PROCEDURE Store_Sales_With_Flag(IN param_store_id INT)
BEGIN
    DECLARE total_sales_value FLOAT;
    DECLARE flag VARCHAR(10);

    SELECT SUM(p.amount)
    INTO total_sales_value
    FROM store s
    JOIN customer c ON s.store_id = c.store_id
    JOIN payment p ON p.customer_id = c.customer_id
    WHERE s.store_id = param_store_id;

    IF total_sales_value > 30000 THEN
        SET flag = 'green_flag';
    ELSE
        SET flag = 'red_flag';
    END IF;

    SELECT total_sales_value AS Total_Sales_Value, flag AS Flag;
END;
//

DELIMITER ;

CALL Store_Sales_With_Flag(1); 
