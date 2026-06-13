-- Preview dataset
Select *  from  sample_superstore;


-- 1. REGIONAL SALES PERFORMANCE
Select Region,
ROUND(SUM(sales),2) as Total_revenue,
ROUND(SUM(Profit),2) as Total_profit,
ROUND(SUM(Profit)/SUM(sales)*100,2) as Profit_margin
From sample_superstore
Group by Region
Order by Total_revenue desc;


-- 2. CATEGORY & SUB-CATEGORY PROFITABILITY LINK
SELECT Category, 
       `Sub-Category`, 
       ROUND(SUM(Sales), 2) AS Total_Sales,
       ROUND(SUM(Profit), 2) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(sales)*100,2) as Profit_margin
FROM sample_superstore
GROUP BY Category, `Sub-Category`
ORDER BY Profit_margin desc;

-- 3. CUSTOMER SEGMENT PERFORMANCE
SELECT Segment,
       ROUND(SUM(Sales), 2) AS Total_Revenue,
       ROUND(SUM(Profit), 2) AS Total_Profit,
       ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin
FROM sample_superstore
GROUP BY Segment
ORDER BY Profit_Margin DESC;

-- 4. DISCOUNT TIER IMPACT ANALYSIS (Aggregated Case Statement)
Select 
CASE
WHEN Discount =0 THEN 'NO DISCOUNT' 
WHEN DISCOUNT>0 THEN 'HAS DISCOUNT'
END AS Discount_Tier,
COUNT(*) AS num_orders,
ROUND(AVG(sales),2) AS avg_sales,
ROUND(AVG(Profit),2) AS avg_profit
 FROM sample_superstore
 GROUP BY Discount_Tier
 ORDER BY avg_profit DESC;
 
-- 5. TOP 10 CUSTOMERS  BY PROFIT MARGIN
 SELECT `Customer ID`,`Customer Name`,
 Round(avg(Discount),2) as Avg_Discount,
 ROUND(SUM(Sales), 2) AS Revenue,
       ROUND(SUM(Profit), 2) AS Profit,
       ROUND(SUM(Profit)/SUM(sales)*100,2) as Profit_Margin
 FROM sample_superstore
 GROUP BY `Customer ID`,`Customer Name`
 ORDER BY Revenue DESC LIMIT 10;
 
 -- 6. MONTHLY SALES TREND ANALYSIS (Fixes text-date formatting issue)
 WITH revenue_permonth AS (
    SELECT DATE_FORMAT(STR_TO_DATE(`Order Date`, '%m/%d/%Y'), '%Y-%m') AS monthly,
    ROUND(SUM(sales), 2) AS sales_monthly
    FROM sample_superstore
    GROUP BY monthly
    ORDER BY monthly ASC
)
SELECT monthly, sales_monthly,
LAG(sales_monthly, 1) OVER(ORDER BY monthly) AS prev_sales,
ROUND(sales_monthly - LAG(sales_monthly, 1) OVER(ORDER BY monthly), 2) AS mom_change
FROM revenue_permonth;
 
 -- 7.SHIP MODE ANALYSIS
 
 SELECT `Ship Mode`,
 COUNT(`Ship Mode`) AS shipmode_count,
 ROUND(AVG(Discount),2) AS avg_discount,
 ROUND(SUM(sales),2) AS Total_revenue,
 ROUND(SUM(Profit),2) AS Total_profit,
 ROUND(SUM(Profit)/SUM(sales)*100,2) AS Profit_margin
 FROM sample_superstore
 GROUP BY `Ship Mode`
 ORDER BY shipmode_count DESC;
 
 
 -- 8. LOSS-MAKING STATES
 SELECT State,Region,
 ROUND(SUM(sales),2) AS Total_revenue,
 ROUND(SUM(Profit),2) AS Total_profit,
 ROUND(SUM(Profit)/ SUM(sales)*100,2) AS Profit_margin
 FROM sample_superstore
 GROUP BY State,Region
 HAVING Profit_margin<0
 ORDER BY  Total_revenue DESC;
 
 
 
 
 


