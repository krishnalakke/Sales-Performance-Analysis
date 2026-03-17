select * from sales_data
limit 10;
select count(*) from sales_data;
use sales_project
--Total Revenue

select sum(revenue) as total_revenue
from sales_data ;

--Total orders 
select sum(orders) as total_orders
from sales_data 

--Revenue by Region
select region,sum(revenue) as revenue
from sales_data 
group by region
order by revenue desc;

--Top five products

select product , sum(revenue) as revenue
from sales_data
group by product 
order by revenue desc;

--Top sales rep

select sales_rep,sum(revenue) as revenue
from sales_data 
group by sales_rep 
order by revenue desc
limit 5;

---Monthly Revenue

SELECT 
DATE_FORMAT(order_date,'%Y-%m') AS month,
SUM(revenue) AS revenue
FROM sales_data
GROUP BY month
ORDER BY month;

--Revenue by category
select category ,sum(revenue) as revenue 
from sales_data
group by category 
order by revenue desc;

---Monthly Revenue trend

SELECT 
DATE_FORMAT(order_date,'%Y-%m') AS month,
SUM(revenue) AS revenue
FROM sales_data
GROUP BY month
ORDER BY month;

--Average order value
select 
avg(revenue/orders) as avg_order_value
from sales_data;

--Best Performing Region per Product
select product,
region,
sum(revenue) as total_revenue
from sales_data
group by  product, region
order by total_revenue desc;

--Top 10 sales transactions

select * from sales_data
order by revenue desc 
limit 10;
use sales_project
--Calculate Revenue per Product per Region

select product , region ,
sum(revenue) as revenue
from sales_data 
group by product , region;

--Use RANK() Window Function

select region ,product , 
sum(revenue) as total_revenue,
rank()over(
partition by region 
order by sum(revenue) desc
) as rank_position 
from sales_data 
group by region , product;

--Select Only Rank 1 (Top Product)
select * from(
select region ,product , 
sum(revenue) as total_revenue,
rank()over(
partition by region 
order by sum(revenue) desc
) as rank_position 
from sales_data 
group by region , product
)ranked_data
where rank_position = 1;

--Top 3 Products in Each Region

select * from(
select region ,product , 
sum(revenue) as total_revenue,
rank()over(
partition by region 
order by sum(revenue) desc
) as rank_position 
from sales_data 
group by region , product
)ranked_data
where rank_position <= 3;

--Calculate Monthly Revenue

SELECT 
DATE_FORMAT(order_date,'%Y-%m') AS month,
SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY month
ORDER BY month;

---How to Get Previous Month Revenue

SELECT 
month,
total_revenue,
LAG(total_revenue) OVER(ORDER BY month) AS previous_month_revenue
FROM (
    SELECT 
    DATE_FORMAT(order_date,'%Y-%m') AS month,
    SUM(revenue) AS total_revenue
    FROM sales_data
    GROUP BY month
) monthly_sales;

--Calculate MoM Growth %

SELECT 
month,
total_revenue,
previous_month_revenue,
ROUND(
((total_revenue - previous_month_revenue) / previous_month_revenue) * 100,
2
) AS mom_growth_percent
FROM (
    SELECT 
    month,
    total_revenue,
    LAG(total_revenue) OVER(ORDER BY month) AS previous_month_revenue
    FROM (
        SELECT 
        DATE_FORMAT(order_date,'%Y-%m') AS month,
        SUM(revenue) AS total_revenue
        FROM sales_data
        GROUP BY month
    ) monthly_sales
) growth_table;