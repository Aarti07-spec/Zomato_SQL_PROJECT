# 🍽️ Zomato Food Delivery Data Analysis Using SQL.
This project showcases an end-to-end SQL-based data analysis of a Zomato-style food delivery dataset. The goal is to extract actionable insights on customer behavior, restaurant performance, delivery efficiency, and more using structured queries.


## 🎯 Objectives

- Analyze customer registration trends and loyalty
- Find top-performing restaurants and cities
- Understand order volume, revenue, and peak hours
- Track delivery success rates and rider performance


## 🧰 Tools Used
SQL (PostgreSQL) <br>
CSV as data source<br>
PgAdmin / MySQL Workbench (optional IDEs)<br>

## 📁 Project Structure <br>
zomato_data.csv – Raw dataset file<br>
zomato_schema.sql – Table definitions and constraints<br>
zomato_analysis.sql – SQL queries for cleaning and analysis<br>
README.md – Project overview, insights & documentation<br>


## 🗃️ Data Sources <br>
Note: All data is fictional and created for learning purposes.
<br>
customers_data.csv = https://github.com/Aarti07-spec/Zomato_SQL_PROJECT/blob/main/customer_data_P2.csv

restaurants_data.csv = https://github.com/Aarti07-spec/Zomato_SQL_PROJECT/blob/main/restaurant_data_P2.csv

orders_data.csv = https://github.com/Aarti07-spec/Zomato_SQL_PROJECT/blob/main/order_data_P2.csv

deliveries.csv = https://github.com/Aarti07-spec/Zomato_SQL_PROJECT/blob/main/delivery_data2_P2.csv

riders.csv = https://github.com/Aarti07-spec/Zomato_SQL_PROJECT/blob/main/Riders_data_P2.csv

## 🛠️ Schema Design<br>
The database consists of 5 main tables:<br>
Customers – Basic customer info<br>
Restaurants – Restaurant details including city & hours<br>
Orders – Food orders placed by customers<br>
Riders – Delivery personnel information<br>
Deliveries – Links orders with riders, includes delivery times and status<br>
Foreign key constraints ensure referential integrity between tables.<br>

## 🧹 Data Cleaning
Handled missing values using SELECT ... WHERE IS NULL filters<br>
Removed incomplete or NULL records (e.g. in Riders and Deliveries)<br>
Ensured foreign key dependencies were properly mapped

## 📊 Key SQL Analyses & Use Cases <br>
Check Out SQL File: https://github.com/Aarti07-spec/Zomato_SQL_PROJECT/blob/main/zomato_SQL_Project.sql

### 1. Customer Behavior
🥇 Top Ordered Dishes by Customer: Found most frequent dish by Arjun Mehta over the past year.<br>
⏰ Popular Time Slots: Identified peak ordering hours in 2-hour intervals.<br>
📈 Order Frequency by Day: Ranked days of the week by volume for each restaurant.<br>
🧾 Customer Lifetime Value (CLV): Calculated revenue generated per customer.<br>
💸 Customer Segmentation: Classified customers as Gold or Silver based on AOV.
<br>
### 2. Restaurant Insights
💰 Revenue Rankings: Ranked restaurants by revenue within each city.<br>
🌆 City-wise Revenue Rank: Ranked cities based on total sales for 2023.<br>
🍲 Most Popular Dish per City: Determined best-selling item in each city.<br>
📊 Monthly Growth Ratio: Analyzed growth in order volume month-over-month.
<br>
### 3. Delivery Analysis
🚫 Undelivered Orders: Tracked placed orders with no matching delivery.<br>
🕓 Average Delivery Time: Measured time taken by riders for each delivery.<br>
🧠 Rider Efficiency: Identified riders with fastest and slowest average delivery times.<br>
🌟 Rider Ratings: Simulated rider ratings based on delivery speed (5⭐ for <15 mins).
<br>
### 4. Spending Patterns
🏆 High-Value Customers: Customers who spent over ₹1500.<br>
📉 Customer Churn: Found users who ordered in 2024 but not in 2025.<br>
💵 Average Order Value (AOV): Calculated for customers with >5 orders.<br>
📆 Monthly Sales Trends: Compared sales month-to-month to identify spikes/dips.

### 5. Product Trends
🔥 Seasonal Dish Popularity: Tracked order items across seasons for demand spikes.
<br>

## 📘 Entity-Relationship Diagram (ERD) Explanation
<br>This ERD models a food delivery ecosystem with 5 main entities:

📌 *See full ERD in [ https://github.com/Aarti07-spec/Zomato_SQL_PROJECT/blob/main/Zomato_ERD.png ]

#### 1. Customers Table
Primary Key: customer_id<br>
Attributes:<br>
customer_name: Name of the customer<br>
reg_date: Date the customer registered<br>
#### 🧩 Relationship:
One customer can place many orders.<br>
Connected to orders via foreign key customer_id.

#### 2. Restaurants Table
Primary Key: restaurant_id<br>
Attributes:<br>
restaurant_name<br>
city: Location of the restaurant<br>
opening_hours: Operating hours<br>

#### 🧩 Relationship:<br>
One restaurant can receive many orders.<br>
Linked to orders via foreign key restaurant_id.

#### 3. Orders Table
Primary Key: order_id<br>
Foreign Keys:<br>
customer_id → references customers<br>
restaurant_id → references restaurants<br>

Attributes:<br>
order_item: Dish or item ordered<br>
order_date: When the order was placed<br>
order_time: Time of day order was placed<br>
order_status: e.g., Completed, Cancelled<br>
total_amount: Value of the order

#### 🧩 Relationships:
<br>Acts as a bridge between customers and restaurants<br>
One order may have one delivery (linked via order_id to deliveries)
<br>

#### 4. Deliveries Table
Primary Key: delivery_id<br>
Foreign Keys:<br>
order_id → references orders<br>
rider_id → references riders<br>
Attributes:<br>
delivery_status: e.g., Delivered, Failed<br>
delivery_time: When it was delivered

#### 🧩 Relationships:
Links orders to riders<br>
Each delivery is fulfilled by one rider<br>
Some orders may not have a delivery (e.g., cancelled)
<br>

#### 5. Riders Table
Primary Key: rider_id<br>
Attributes:<br>
rider_name<br>
sign_up_date: When rider joined
<br>
##### 🧩 Relationship:
<br>
One rider can complete many deliveries<br>
Connected to deliveries via rider_id <br>

##### 🔗 Summary of Relationships
Entity	Related Entity	Relationship Type<br>
Customers	Orders	1-to-Many (1 customer → many orders)<br>
Restaurants	Orders	1-to-Many (1 restaurant → many orders)<br>
Orders	Deliveries	1-to-1 or 1-to-None (not all orders delivered)<br>
Deliveries	Riders	Many-to-1 (many deliveries → 1 rider)<br>

### 🔍 Use Cases Enabled by This Schema
Track total revenue and top dishes by restaurant or city<br>
Analyze rider delivery times and performance<br>
Segment customers based on order frequency or value<br>
Identify undelivered or failed orders<br>
Compare delivery efficiency across time windows


## 📈 Sample Insights
Here are a few insights uncovered from the analysis:<br>
North Indian and Chinese dishes are top performers across most cities.<br>
Riders delivering under 15 minutes earned more consistent high (5-star) ratings.<br>
Some restaurants showed consistent month-over-month order growth, while others had seasonal spikes.<br>
Customers in metros had higher AOV and CLV than in tier-2 cities.

## ✅ Learning Outcomes
Advanced SQL querying: window functions, CTEs, date/time functions<br>
Data cleaning & integrity using constraints and null handling<br>
Business insights via analytical queries<br>
Schema design and normalization

## 🔚 Conclusion
This project provided a comprehensive understanding of how a food delivery ecosystem operates from a data perspective. By working with relational databases, crafting optimized SQL queries, and analyzing real-world-like delivery metrics, I learned how to derive actionable insights that can support both business decisions and operational improvements.

#### Key takeaways include:
<br>
The importance of clean and connected data across multiple entities<br>
How customer behavior can directly influence delivery logistics<br>
The power of SQL in uncovering business intelligence
<br>

## 🔄 Next Steps / Future Work
Integrate customer reviews and sentiment analysis<br>
Build a machine learning model to predict late deliveries<br>
Add real-time dashboarding using Power BI or Streamlit
<br>
Optimize queries for performance on larger datasets
<br>
### 💡 Reflections 
This project helped bridge my SQL and data visualization skills, pushing me to think not just technically, but also from a business perspective. It simulated a real-world scenario where multiple stakeholders (customers, restaurants, delivery riders) depend on data-driven decisions.

## 🙏 THANK YOU ..
