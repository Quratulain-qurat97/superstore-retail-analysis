# superstore-retail-analysis
SQL + Power BI analysis of Superstore retail data uncovering profitability drivers, discount impact, and loss-making states across 9,994 transactions.

Q1: Regional Performance? 

Insight 1 — Regional Performance: 

The West region leads in both revenue ($720K) and profit ($107K) with the highest margin at 14.9%. The East follows closely at 13.5% margin. 

The Central region is the biggest concern — despite being the third highest in revenue at $502K, it has the worst profit margin at just 8.0%. It generates significant sales volume but converts very little of it into profit. This strongly suggests excessive discounting in the Central region. 

South has lower revenue than Central but a better margin at 11.93% — meaning it runs a more efficient operation. 

Select Region, 

ROUND(SUM(sales),2) as Total_revenue, 

ROUND(SUM(Profit),2) as Total_profit, 

ROUND(SUM(Profit)/SUM(sales)*100,2) as Profit_margin 

From sample_superstore 

Group by Region 

Order by Total_revenue desc; 

 

 

 

Q2: Category & Sub-Category Profitability? 

Insight 2: 

Three sub-categories are running at a loss — Tables (-8.56%), Bookcases (-3.02%), and Supplies (-2.93%). Tables is the most concerning — it generates $206K in revenue but loses $17,725, meaning every Table sold destroys value. The business should urgently review pricing and discount strategy for these sub-categories. Labels, Envelopes, and Paper are the most profitable sub-categories with margins above 37%. 

 

SELECT Category,  

       `Sub-Category`,  

       ROUND(SUM(Sales), 2) AS Total_Sales, 

       ROUND(SUM(Profit), 2) AS Total_Profit, 

       ROUND(SUM(Profit)/SUM(sales)*100,2) as Profit_margin 

FROM sample_superstore 

GROUP BY Category, `Sub-Category` 

ORDER BY Profit_margin desc; 

 

 

 

Q3: Customer Segment Analysis? 

Insight 3 — Customer Segment Analysis: 

The Consumer segment drives the most revenue at $1.16M but has the weakest profit margin at 11.61% — suggesting this segment is being over-discounted to drive volume. Corporate and Home Office both achieve better margins at 13% and 13.88% respectively, despite lower revenue. Home Office in particular is the most efficient segment — smallest revenue but highest margin. The business should investigate whether Consumer segment discounting is necessary or whether margins can be improved without losing volume. Corporate represents the best balance of revenue and profitability and should be prioritized for growth. 

 

SELECT Segment, 

 ROUND(SUM(Sales), 2) AS Total_Revenue, 

 ROUND(SUM(Profit), 2) AS Total_Profit, 

 ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin 

FROM sample_superstore 

GROUP BY Segment 

ORDER BY Profit_Margin DESC; 

 

 

 

Q4: Discount Impact on Profit? 

Insight 4: 

Discounting is destroying profit. Orders with no discount average $68 profit per order. Orders with any discount average a loss of -$5.90 per order — a swing of nearly $74 per order. Despite similar average sales values ($230 vs $228), discounted orders consistently lose money. The business should critically review its discounting strategy — particularly in the Central region and for Tables and Bookcases sub-categories where we already identified margin problems. 

 

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

 

 

 

Q5: Top 10 Customers? 

Insight 5: 

The top 10 customers by revenue reveal a critical finding — Sean Miller, the highest revenue customer at $25,043, is actually unprofitable with a -$1,980 loss and -7.91% margin. The business is losing money on its biggest customer, almost certainly due to excessive discounting. Tamara Chand and Raymond Buch are the most valuable customers when combining revenue and profitability with margins above 46%. Ken Lonsdale also shows a dangerously thin 5.49% margin despite $14K in revenue. 

 

SELECT `Customer ID`, 

`Customer Name`, 

       ROUND(SUM(Sales), 2) AS Revenue, 

       ROUND(SUM(Profit), 2) AS Profit, 

       ROUND(SUM(Profit)/SUM(sales)*100,2) as Profit_Margin 

FROM sample_superstore 

GROUP BY `Customer ID`,`Customer Name` 

ORDER BY Revenue DESC LIMIT 10; 

 

 

 

Q6: Month over Month Sales Trend? 

 Insight 6: 

Sales show strong seasonality with significant spikes in March and September each year, and notable drops in February and October. The month over month analysis reveals sales are highly inconsistent — swings of $50,000+ between consecutive months suggest either seasonal demand patterns or irregular bulk ordering behavior. The business should investigate whether these spikes correlate with promotions or specific customer orders. 

 

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

 

 

Q7: Ship Mode Analysis? 

Insight 7: 

The profit margin of each ship mode is not that different it is actually what it should be standard class is most used having 5968 numbers because people prefer standard ship mode to avoid extra charges, so the profit margin 12.11% is little different from other ship mode but it is not dramatically different. First Class having 1538 numbers is the most profitable shipping mode margin of  13.8% because it attracts less price sensitive customers who receive fewer discounts the average discount a First class ship mode gets  is 0.25 .  

Same day and Second class gets the same average discount for Same day average discount 0.46 and for Second class 0.45 and their profit margin is not that different either for Same day profit margin is 12.63% and for Second class is 12.43%. 

Since ship mode has minimal impact on profit margins, the business should redirect its focus toward higher-impact areas such as reducing discounting in loss-making sub-categories and the Central region. 

 

SELECT `Ship Mode`, 

COUNT(`Ship Mode`) AS shipmode_count, 

ROUND(AVG(Discount),2) AS avg_discount, 

ROUND(SUM(sales),2) AS Total_revenue, 

ROUND(SUM(Profit),2) AS Total_profit, 

ROUND(SUM(Profit)/SUM(sales)*100,2) AS Profit_margin 

FROM sample_superstore 

GROUP BY `Ship Mode` 

ORDER BY shipmode_count DESC; 

 

 

Q8: Loss-Making States? 

Insight 8: 

As  we checked in insight 1 central in our least profit generating region but what interesting insight we  get from this loss-making state insight is even if they are the least profit making region they have only 2 states that is giving us negative profit Illinois revenue is $79.5K but losses -$12K of profit margin of profit is -15.11% and Texas revenue is $172K but losses –$25K of profit margin of profit is -14.83% compare to other Regions having 3 states where we are losing profit that mean even if they are giving us the least profit they are not the only one affecting our profit. 

The business should conduct an urgent state-level discount audit, prioritizing Texas and Ohio which represent the largest absolute losses. Simply reducing discounting in these states could potentially recover tens of thousands in lost profit. 

 

SELECT State,Region, 

ROUND(SUM(sales),2) AS Total_revenue, 

ROUND(SUM(Profit),2) AS Total_profit, 

ROUND(SUM(Profit)/ SUM(sales)*100,2) AS Profit_margin 

FROM sample_superstore 

GROUP BY State,Region 

HAVING Profit_margin<0 

ORDER BY  Total_revenue DESC; 

# Superstore Retail Analysis

## Project Overview
End-to-end retail analysis of 9,994 transactions from the Sample Superstore dataset using MySQL for data analysis and Power BI for visualization. The project uncovers profitability drivers, discount impact, and loss-making states across 4 regions and 3 product categories.

## Tools Used
- MySQL — data extraction and analysis
- Power BI — dashboard and visualization
- Dataset: Sample Superstore (2014-2017)

## Business Questions Answered
1. Which region generates the highest revenue and profit?
2. Which product category and sub-category is most and least profitable?
3. Which customer segment drives the most sales?
4. How does discounting affect profit?
5. Who are the top 10 customers by revenue?
6. What is the month over month sales trend?
7. Which ship mode is most profitable?
8. Which states are loss-making?

## Key Findings
- **West region** leads in both revenue ($720K) and profit margin (14.9%)
- **Central region** has the worst profit margin (8%) despite being 3rd in revenue — likely due to excessive discounting
- **Tables sub-category** generates $206K revenue but loses $17,725 — a critical margin problem
- **Discounting destroys profit** — orders with no discount average $68 profit vs -$6 for discounted orders
- **Sean Miller** is the top revenue customer at $25K but is unprofitable at -$1,980 loss
- **10 states** are loss-making, with Texas losing the most in absolute dollars (-$25K)

## Files
- `superstore_analysis.sql` — 8 SQL queries with business analysis
- `Sample - Superstore.csv` — raw dataset
- `superstore_dashboard.pdf` — Power BI dashboard export
