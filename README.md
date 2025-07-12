# 🍽️ Zomato Food Delivery Data Analysis Using SQL.
This project showcases an end-to-end SQL-based data analysis of a Zomato-style food delivery dataset. The goal is to extract actionable insights on customer behavior, restaurant performance, delivery efficiency, and more using structured queries.


## 🎯 Objectives

- Analyze customer registration trends and loyalty
- Find top-performing restaurants and cities
- Understand order volume, revenue, and peak hours
- Track delivery success rates and rider performance


## 🧰 Tools Used
SQL (PostgreSQL)

CSV as data source

PgAdmin / MySQL Workbench (optional IDEs)

## 📁 Project Structure
zomato_data.csv – Raw dataset file

zomato_schema.sql – Table definitions and constraints

zomato_analysis.sql – SQL queries for cleaning and analysis

README.md – Project overview, insights & documentation


### 🗃️ Data Sources
Note: All data is fictional and created for learning purposes.

customers.csv = https://github.com/Aarti07-spec/Zomato_SQL_PROJECT/blob/main/customer_data_P2.csv

restaurants.csv

orders.csv

deliveries.csv

riders.csv

## 🛠️ Schema Design
The database consists of 5 main tables:

Customers – Basic customer info

Restaurants – Restaurant details including city & hours

Orders – Food orders placed by customers

Riders – Delivery personnel information

Deliveries – Links orders with riders, includes delivery times and status

Foreign key constraints ensure referential integrity between tables.

## 🧹 Data Cleaning
Handled missing values using SELECT ... WHERE IS NULL filters

Removed incomplete or NULL records (e.g. in Riders and Deliveries)

Ensured foreign key dependencies were properly mapped

## 📊 Key SQL Analyses & Use Cases
### 1. Customer Behavior
🥇 Top Ordered Dishes by Customer: Found most frequent dish by Arjun Mehta over the past year.

⏰ Popular Time Slots: Identified peak ordering hours in 2-hour intervals.

📈 Order Frequency by Day: Ranked days of the week by volume for each restaurant.

🧾 Customer Lifetime Value (CLV): Calculated revenue generated per customer.

💸 Customer Segmentation: Classified customers as Gold or Silver based on AOV.

### 2. Restaurant Insights
💰 Revenue Rankings: Ranked restaurants by revenue within each city.

🌆 City-wise Revenue Rank: Ranked cities based on total sales for 2023.

🍲 Most Popular Dish per City: Determined best-selling item in each city.

📊 Monthly Growth Ratio: Analyzed growth in order volume month-over-month.

### 3. Delivery Analysis
🚫 Undelivered Orders: Tracked placed orders with no matching delivery.

🕓 Average Delivery Time: Measured time taken by riders for each delivery.

🧠 Rider Efficiency: Identified riders with fastest and slowest average delivery times.

🌟 Rider Ratings: Simulated rider ratings based on delivery speed (5⭐ for <15 mins).

### 4. Spending Patterns
🏆 High-Value Customers: Customers who spent over ₹1500.

📉 Customer Churn: Found users who ordered in 2024 but not in 2025.

💵 Average Order Value (AOV): Calculated for customers with >5 orders.

📆 Monthly Sales Trends: Compared sales month-to-month to identify spikes/dips.

### 5. Product Trends
🔥 Seasonal Dish Popularity: Tracked order items across seasons for demand spikes.


## 📘 Entity-Relationship Diagram (ERD) Explanation
This ERD models a food delivery ecosystem with 5 main entities:

📌 *See full ERD in [`erd/zomato_erd.png`](./erd/zomato_erd.png)*


#### 1. Customers Table
Primary Key: customer_id

Attributes:

customer_name: Name of the customer

reg_date: Date the customer registered

#### 🧩 Relationship:

One customer can place many orders.

Connected to orders via foreign key customer_id.

#### 2. Restaurants Table
Primary Key: restaurant_id

Attributes:

restaurant_name

city: Location of the restaurant

opening_hours: Operating hours

#### 🧩 Relationship:

One restaurant can receive many orders.

Linked to orders via foreign key restaurant_id.

#### 3. Orders Table
Primary Key: order_id

Foreign Keys:

customer_id → references customers

restaurant_id → references restaurants

Attributes:

order_item: Dish or item ordered

order_date: When the order was placed

order_time: Time of day order was placed

order_status: e.g., Completed, Cancelled

total_amount: Value of the order

#### 🧩 Relationships:

Acts as a bridge between customers and restaurants

One order may have one delivery (linked via order_id to deliveries)

#### 4. Deliveries Table
Primary Key: delivery_id

Foreign Keys:

order_id → references orders

rider_id → references riders

Attributes:

delivery_status: e.g., Delivered, Failed

delivery_time: When it was delivered

#### 🧩 Relationships:

Links orders to riders

Each delivery is fulfilled by one rider

Some orders may not have a delivery (e.g., cancelled)

#### 5. Riders Table
Primary Key: rider_id

Attributes:

rider_name

sign_up_date: When rider joined

##### 🧩 Relationship:

One rider can complete many deliveries

Connected to deliveries via rider_id

##### 🔗 Summary of Relationships
Entity	Related Entity	Relationship Type
Customers	Orders	1-to-Many (1 customer → many orders)
Restaurants	Orders	1-to-Many (1 restaurant → many orders)
Orders	Deliveries	1-to-1 or 1-to-None (not all orders delivered)
Deliveries	Riders	Many-to-1 (many deliveries → 1 rider)

### 🔍 Use Cases Enabled by This Schema
Track total revenue and top dishes by restaurant or city

Analyze rider delivery times and performance

Segment customers based on order frequency or value

Identify undelivered or failed orders

Compare delivery efficiency across time windows


## 📈 Sample Insights
Here are a few insights uncovered from the analysis:

North Indian and Chinese dishes are top performers across most cities.

Riders delivering under 15 minutes earned more consistent high (5-star) ratings.

Some restaurants showed consistent month-over-month order growth, while others had seasonal spikes.

Customers in metros had higher AOV and CLV than in tier-2 cities.

## ✅ Learning Outcomes
Advanced SQL querying: window functions, CTEs, date/time functions

Data cleaning & integrity using constraints and null handling

Business insights via analytical queries

Schema design and normalization

