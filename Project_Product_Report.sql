/* PRODUCT REPORT */
/* THIS QUERY WILL PROVIDE A TABLE OF PRODUCT AND THEIR SALE AND CAN BE USED 
   TO MAKE DASHBOARD */

with monthly_sales as(
 select
 product_key,
 sum(price) as total_monthly_sale,
 extract ( year from order_date),
 extract ( month from order_date)
 from gold.fact_sales
 group by  extract (year from order_date),extract (month from order_date),product_key
),
product_kpi as (
  select
  sum(price):: numeric as total_sales
  from gold.fact_sales 
),
product_sale as (
select
product_key,
sum(price) as product_sale
from gold.fact_sales 
group by product_key
order by product_key
 )
select
  gfs.product_key,
  gdp.product_id,
  gdp.product_name,
  gdp.category,
  gdp.subcategory,
  ps.product_sale,
    case 
    when ps.product_sale > 500000 then 'High-Performers'
	when ps.product_sale between 100000 and 500000 then 'Mid-Range'
	else 'Low-Performers'
	end sale_status,
  
  ROUND(AVG(ms.total_monthly_sale), 2) AS avg_monthly_sales,
  concat(round((ps.product_sale/pk.total_sales)*100,2),' %') as product_contribution
  from gold.fact_sales gfs
  join gold.dim_products gdp on gfs.product_key = gdp.product_key
  join product_kpi pk on true 
  join monthly_sales ms on ms.product_key = gdp.product_key
  join product_sale ps on ps.product_key = gdp.product_key
  group by gfs.product_key, gdp.product_id,gdp.category,gdp.subcategory, 
           ps.product_sale,gdp.product_name,pk.total_sales
  order by gfs.product_key;

 

 