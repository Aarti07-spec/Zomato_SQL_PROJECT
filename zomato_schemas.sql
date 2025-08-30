-- Zomato Data Analysis project

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
	customer_id INT PRIMARY KEY,
	customer_name VARCHAR(50) NOT NULL,
	reg_date DATE 
);


DROP TABLE IF EXISTS Restaurants;
CREATE TABLE Restaurants(
	restaurant_id INT PRIMARY KEY,
	restaurant_name VARCHAR(50),
	city VARCHAR(50),
	opening_hours VARCHAR(55)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	order_id INT PRIMARY KEY,
	customer_id INT,
	restaurant_id INT,
	order_item VARCHAR(60),
	order_date DATE,
	order_time TIME,
	order_status VARCHAR(60),
	total_amount FLOAT
);

--adding FK CONSTRAINT
ALTER TABLE orders 	--Modify the existing orders table.
ADD CONSTRAINT fk_customers		--	Add a new constraint and name it fk_customers.
FOREIGN KEY (customer_id)		-- Define the column customers_id in orders as a foreign key.
REFERENCES customers(customer_id); 		--This foreign key must match a value in the customers_id column of the customers table.

/*A foreign key is used to link two tables together. It ensures that:
A value in one table must exist in another table.
It maintains referential integrity.*/

ALTER TABLE orders
ADD CONSTRAINT fk_restaurants
FOREIGN KEY (restaurant_id)
REFERENCES restaurants(restaurant_id);


DROP TABLE IF EXISTS Riders;
CREATE TABLE Riders(
	rider_id INT PRIMARY KEY,
	rider_name VARCHAR(55),
	sign_up DATE
);


-- add constraints while creating table
DROP TABLE IF EXISTS Deliveries;

CREATE TABLE Deliveries(
	delivery_id INT ,
	order_id INT,	--REFERNECE from Orders table
	delivery_status VARCHAR(60),
	delivery_time TIME,
	rider_id INT,	--Refernce from riders table
	CONSTRAINT fk_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
	CONSTRAINT fk_riders FOREIGN KEY (rider_id) REFERENCES riders(rider_id)
);


--  CONSTRAINT FOREIGN KEY That means every value of order_id in the deliveries table must exist in the orders table.
-- End of Schemas here..

