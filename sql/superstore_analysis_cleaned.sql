-- Preview cleaned dataset
SELECT * FROM superstores_cleared.superstore_cleaned_python;

-- Dataset overview
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT `Row ID`) AS unique_row_ids,
    MIN(`Row ID`) AS first_row_id,
    MAX(`Row ID`) AS last_row_id,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND(AVG(`Discount`), 4) AS average_discount
FROM superstores_cleared.superstore_cleaned_python;





-- 1. REGIONAL SALES PERFORMANCE
Select Region,
ROUND(SUM(sales),2) as Total_revenue,
ROUND(SUM(Profit),2) as Total_profit,
ROUND(SUM(Profit)/SUM(sales)*100,2) as Profit_margin
From superstores_cleared.superstore_cleaned_python
Group by Region
Order by Total_revenue desc;



-- 2. CATEGORY & SUB-CATEGORY PROFITABILITY LINK
SELECT Category, 
       `Sub-Category`, 
       ROUND(SUM(Sales), 2) AS Total_Sales,
       ROUND(SUM(Profit), 2) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(sales)*100,2) as Profit_margin
FROM superstores_cleared.superstore_cleaned_python
GROUP BY Category, `Sub-Category`
ORDER BY Profit_margin desc;



-- 3. CUSTOMER SEGMENT PERFORMANCE
SELECT Segment,
       ROUND(SUM(Sales), 2) AS Total_Revenue,
       ROUND(SUM(Profit), 2) AS Total_Profit,
       ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin
FROM superstores_cleared.superstore_cleaned_python
GROUP BY Segment
ORDER BY Profit_Margin DESC;



-- 4. DISCOUNT TIER IMPACT ANALYSIS
SELECT
    CASE
        WHEN Discount = 0 THEN 'NO DISCOUNT'
        WHEN Discount > 0 THEN 'HAS DISCOUNT'
    END AS Discount_Tier,
    COUNT(*) AS transaction_lines,
    ROUND(AVG(Sales), 2) AS avg_sales,
    ROUND(AVG(Profit), 2) AS avg_profit
FROM superstores_cleared.superstore_cleaned_python
GROUP BY Discount_Tier
ORDER BY avg_profit DESC;



-- 5. TOP 10 CUSTOMERS BY REVENUE
SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(AVG(Discount), 2) AS Avg_Discount,
    ROUND(SUM(Sales), 2) AS Revenue,
    ROUND(SUM(Profit), 2) AS Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin
FROM superstores_cleared.superstore_cleaned_python
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Revenue DESC
LIMIT 10;


-- 6. MONTHLY SALES TREND ANALYSIS
WITH revenue_permonth AS (
    SELECT
        DATE_FORMAT(`Order Date`, '%Y-%m') AS monthly,
        ROUND(SUM(Sales), 2) AS sales_monthly
    FROM superstores_cleared.superstore_cleaned_python
    GROUP BY monthly
)
SELECT
    monthly,
    sales_monthly,
    LAG(sales_monthly, 1) OVER (ORDER BY monthly) AS prev_sales,
    ROUND(
        sales_monthly - LAG(sales_monthly, 1) OVER (ORDER BY monthly),
        2
    ) AS mom_change
FROM revenue_permonth
ORDER BY monthly;




-- 7. SHIP MODE ANALYSIS
SELECT
    `Ship Mode`,
    COUNT(`Ship Mode`) AS shipmode_count,
    ROUND(AVG(Discount), 2) AS avg_discount,
    ROUND(SUM(Sales), 2) AS Total_revenue,
    ROUND(SUM(Profit), 2) AS Total_profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_margin
FROM superstores_cleared.superstore_cleaned_python
GROUP BY `Ship Mode`
ORDER BY shipmode_count DESC;



-- 8. LOSS-MAKING STATES
SELECT
    State,
    Region,
    ROUND(SUM(Sales), 2) AS Total_revenue,
    ROUND(SUM(Profit), 2) AS Total_profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_margin
FROM superstores_cleared.superstore_cleaned_python
GROUP BY State, Region
HAVING Profit_margin < 0
ORDER BY Total_revenue DESC;



-- 9. DATASET VALIDATION — ROW COUNT & FINANCIAL TOTALS
-- Verify total records, check for NULL values in Sales and Profit,
-- and confirm financial totals match the cleaned Python dataset.
SELECT
    COUNT(*) AS total_rows,
    COUNT(Sales) AS valid_sales,
    COUNT(Profit) AS valid_profit,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM superstores_cleared.superstore_cleaned_python;



-- 10. DISCOUNT DISTRIBUTION
SELECT
    Discount,
    COUNT(*) AS transaction_lines
FROM superstores_cleared.superstore_cleaned_python
GROUP BY Discount
ORDER BY Discount;


-- 11. INVALID DISCOUNT VALUE CHECK
SELECT
    `Row ID`,
    `Order ID`,
    `Product Name`,
    Discount,
    Sales,
    Profit
FROM superstores_cleared.superstore_cleaned_python
WHERE Discount > 1
ORDER BY Discount DESC;




-- 12. NULL & INVALID VALUE CHECK
SELECT
    COUNT(*) AS total_rows,
    SUM(Discount > 1) AS invalid_discount_rows,
    SUM(Discount < 0) AS negative_discount_rows,
    SUM(Sales <= 0) AS nonpositive_sales_rows,
    SUM(Profit IS NULL) AS null_profit_rows
FROM superstores_cleared.superstore_cleaned_python;



-- 13. VERIFY NUMERIC COLUMN DATA TYPES
SHOW COLUMNS FROM superstores_cleared.superstore_cleaned_python
WHERE Field IN ('Discount', 'Sales', 'Profit');