/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - product_contribution
	   - sale_per_product
       - average total sale per product  per month
===============================================================================
This is not the final code, for final code refer to product_report_output*/

-- =============================================================================

/* PART 1 AND 2*/

with product_info as(
select
 product_key,
 product_id,
 product_name,
 category,
 subcategory,
 cost
 from gold.dim_products  
 order by product_key
 ),
product_sale as (
 select
 product_key,
 coalesce (sum(price),0) as total_sales
 from gold.fact_sales
 group by product_key 
 order by product_key
 )

select 

 pi.product_key,
 pi.product_id,
 pi.product_name,
 pi.category,
 pi.subcategory,
 pi.cost,
 coalesce (ps.total_sales,0),
 case 
    when ps.total_sales > 500000 then 'High-Performers'
	when ps.total_sales between 100000 and 500000 then 'Mid-Range'
	else 'Low-Performers'
	end sale_status

 from product_info pi 
 full join product_sale ps on pi.product_key = ps.product_key
 order by pi.product_key; 

 ---------------------------------------------------------
 ---------------------------------------------------------

/* PART 3 */
 
with order_sale as(
 select
   product_key,
   sum(price) over(partition by product_key) as total_sales ,
   sum(quantity) over(partition by product_key) as total_quantity_sold ,
   order_date as recent_order,
   lead(order_date) over(partition by product_key order by order_date desc) as previous_order,
   row_number() over(partition by product_key order by order_date desc) as rn
   from gold.fact_sales
   where order_date is not null
  ),
  customer_count as(
  select 
      product_key,
      count(distinct customer_key) as total_customers
      from gold.fact_sales
       group by product_key
 )
select
 os.product_key,
 os.total_sales ,
 os.total_quantity_sold ,
 cc.total_customers ,
 os.recent_order,
 os.previous_order,
 (os.recent_order ) -  (os.previous_order) AS days_difference
 FROM order_sale os
 join customer_count cc on cc. product_key = os. product_key
 WHERE rn = 1;

------------------------------------------------------------------------------
------------------------------------------------------------------------------
/* PART4 */

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
  gdp.category,
  gdp.subcategory,
  ps.product_sale,
  pk.total_sales,
  ROUND(AVG(ms.total_monthly_sale), 2) AS avg_monthly_sales,
  concat(round((ps.product_sale/pk.total_sales)*100,2),' %') as product_contribution
  from gold.fact_sales gfs
  join gold.dim_products gdp on gfs.product_key = gdp.product_key
  join product_kpi pk on true 
  join monthly_sales ms on ms.product_key = gdp.product_key
  join product_sale ps on ps.product_key = gdp.product_key
  group by gfs.product_key, gdp.product_id,gdp.category,gdp.subcategory, pk.total_sales,ps.product_sale
  order by gfs.product_key;

  


  
  
  









