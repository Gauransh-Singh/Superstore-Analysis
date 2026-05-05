Use sales;
CREATE TABLE IF NOT EXISTS superstore (
Row_ID INT,
Order_ID VARCHAR(20),
Order_Date DATE,
Ship_Date DATE,
Ship_Mode VARCHAR(50),
Customer_ID VARCHAR(20),
Customer_Name VARCHAR(100),
Segment VARCHAR(50),
Country_Region VARCHAR(50),
City VARCHAR(50),
State_Province VARCHAR(50),
Postal_Code VARCHAR(20),
Region VARCHAR(20),
Product_ID VARCHAR(50),
Category VARCHAR(50),
Sub_Category VARCHAR(50),
Product_Name TEXT,
Sales DECIMAL(10,2),
Quantity INT,
Discount DECIMAL(5,2),
Profit DECIMAL(10,2)
);

-- SET GLOBAL LOCAL_INFILE = ON;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/samplesuperstore.csv'
INTO TABLE superstore
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Understand the Data 
select count(*) from superstore;

Select * FROM superstore;

DESCRIBE superstore;

Select count(*) FROM(
	SELECT DISTINCT * FROM superstore
) as Temp;

-- Data Cleaning
-- Null Values 
Select * From superstore
Where sales is NULL 
OR
Profit is NULL;

-- Duplicate Values 
SELECT *, COUNT(*) 
FROM superstore
GROUP BY 
Row_ID, Order_ID, Order_Date, Ship_Date, Ship_Mode,
Customer_ID, Customer_Name, Segment, Country_Region,
City, State_Province, Postal_Code, Region,
Product_ID, Category, Sub_Category, Product_Name,
Sales, Quantity, Discount, Profit
HAVING COUNT(*) > 1;

SELECT Order_ID, COUNT(*) AS count_orders
FROM superstore
GROUP BY Order_ID
HAVING COUNT(*) > 1;

SELECT Order_ID, Product_ID, COUNT(*) AS count_dup
FROM superstore
GROUP BY Order_ID, Product_ID
HAVING COUNT(*) > 1;

Select * FROM superstore 
where Order_ID = 'CA-2023-153623';

-- Handle Duplicates 
CREATE TABLE superstore_clean AS
SELECT MIN(Row_ID) AS Row_ID, Order_ID, Order_Date, Ship_Date, Ship_Mode,
       Customer_ID, Customer_Name, Segment, Country_Region, City,
       State_Province, Postal_Code, Region, Product_ID, Category,
       Sub_Category, Product_Name, Sales, Quantity, Discount, Profit
FROM superstore
GROUP BY Order_ID, Order_Date, Ship_Date, Ship_Mode,
         Customer_ID, Customer_Name, Segment, Country_Region, City,
         State_Province, Postal_Code, Region, Product_ID, Category,
         Sub_Category, Product_Name, Sales, Quantity, Discount, Profit;
         
SELECT COUNT(*) FROM superstore_clean;  
DROP TABLE superstore;
RENAME TABLE superstore_clean TO superstore;       


-- Date Format
SELECT DATE_FORMAT(Order_Date, '%d-%m-%Y') AS Order_Date,
 DATE_FORMAT(Ship_Date, '%d-%m-%Y') AS Ship_Date
 , datediff(Ship_Date, Order_Date)
FROM superstore;

-- Basic Metrics
SELECT count(DISTINCT Order_ID) as 'Total Order',
 sum(Sales) as 'Total Sales', sum(Profit) as 'Profit'
FROM superstore;

-- Region Analysis
CREATE VIEW vw_region_performance AS
SELECT Country_Region, Region, count(DISTINCT Order_ID) as 'Total Order',
 sum(Sales) as 'Total Sales', sum(Profit) as 'Profit'
FROM superstore 
GROUP BY Country_Region, Region
WITH ROLLUP;

SELECT * FROM vw_region_performance;

-- Sales Analysis 
SELECT Category, count(DISTINCT Order_ID) as 'Total Order',
 sum(Sales) as 'Total Sales', sum(Profit) as 'Profit',
 round(sum(Profit)/sum(Sales)*100) as Margin
FROM superstore 
GROUP BY Category
ORDER BY sum(Profit) DESC;

-- Time Series 
CREATE VIEW vw_monthly_sales_trend AS
SELECT date_format(order_date,'%y-%m') as Month,
	SUM(Sales) as Total_Sales, 
    sum(Profit) as Total_Profit,
    round(sum(Profit)/sum(Sales)*100,2)as Margin_pct
FROM superstore
GROUP BY Month
ORDER BY Month;

SELECT YEAR(Order_Date) AS Year,
       SUM(Sales) AS Total_Sales,
       LAG(SUM(Sales)) OVER (ORDER BY YEAR(Order_Date)) AS Prev_Year_Sales,
       ROUND((SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY YEAR(Order_Date))) 
             / LAG(SUM(Sales)) OVER (ORDER BY YEAR(Order_Date)) * 100, 2) AS YoY_Growth_Pct
FROM superstore
GROUP BY YEAR(Order_Date);

-- Customer segmentation
CREATE VIEW vw_customer_rfm AS
SELECT Customer_Id, Customer_Name,
	datediff(max(Order_Date), min(Order_Date)) AS Recency_day,
    COUNT(DISTINCT order_id) AS Total_orders,
    round(sum(Sales),2) as Sales
FROM superstore
GROUP BY Customer_Id, Customer_Name
ORDER BY Sales DESC;

-- Shipping Performance
CREATE VIEW vw_shipping_analysis AS
SELECT Ship_Mode,
	AVG(datediff(ship_date,order_date)) AS Avg_Shipping_Days,
    COUNT(DISTINCT Order_id) AS Orders,
    SUM(Sales) AS Sales
FROM superstore
GROUP BY Ship_Mode 
ORDER BY Sales;


-- Product in loss 
SELECT Product_Name, SUM(Profit)
FROM superstore
GROUP BY Product_Name
HAVING SUM(Profit) < 0;

-- Category Analysis
CREATE VIEW vw_category_analysis AS
SELECT Category, 
	SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    round(SUM(Profit)/SUM(Sales)*100) AS Margin
FROM superstore
GROUP BY Category
ORDER BY Total_Profit;


-- Sub-Category Deep Dive
CREATE VIEW vw_subcategory_analysis AS
SELECT Category, Sub_Category,
       SUM(Sales) AS Total_Sales,
       SUM(Profit) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Margin_Pct,
       AVG(Discount) AS Avg_Discount
FROM superstore
GROUP BY Category, Sub_Category
ORDER BY Total_Profit DESC;

-- Top 10 by profit
SELECT Product_Name, SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Product_Name
ORDER BY Total_Profit DESC LIMIT 10;

-- Top 10 by LOSS
CREATE VIEW vw_loss_making_products AS
SELECT Product_Name, SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Product_Name
ORDER BY Total_Profit ASC LIMIT 10;


-- Discount Analysis
SELECT Discount, AVG(Profit)
FROM superstore
GROUP BY Discount
ORDER BY Discount;

CREATE VIEW vw_discount_impact AS
SELECT 
	CASE
		WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.2 THEN 'Low (0-2)'
        WHEN Discount <= 0.4 THEN 'Medium (0-4)'
        ELSE 'High(>40%)'
	END as Discount_Band,
    COUNT(*) AS Orders,
    round(avg(Profit)) AS Avg_Profit,
    round(sum(Profit)) AS Total_Profit
FROM superstore
GROUP BY Discount_Band
ORDER BY Avg_Profit;
