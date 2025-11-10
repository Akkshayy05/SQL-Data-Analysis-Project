/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - customer_contribution
		- average order value
		
===============================================================================
THIS IS NOT THE FINAL CODE, FOR COMPLETE CODE REFER TO PROJECT_CUSTOMER_REPORT FILE*/
-------------------------------------------------------------------------
/* PART 1 AND 2*/

WITH customer_details as(
SELECT 
 customer_key,
 customer_id,
 country,
 coalesce(customer_number,'') AS customer_contact,
 CONCAT(coalesce(first_name,''),' ',coalesce(last_name,'')) as customer_name,
 EXTRACT(YEAR FROM create_date) - EXTRACT(YEAR FROM birthdate) as ages
 
 
FROM gold.dim_customers
),

TRANSACTIONS AS (
SELECT
   customer_key,
   sum(price) as total_sales,
     case when sum(price) between 0 and 1000 then 'NEW'
	      when sum(price) between 1001 and 5000 then 'Regular'
		  else 'VIP'
		  END customer_type
   from gold.fact_sales
   group by customer_key
   order by customer_key

)
SELECT 
  tr.customer_key,
  cd.customer_id,
  cd.customer_contact,
  cd.customer_name,
  cd.ages,
      case when cd.ages < 18 then 'KIDS'
	       when cd.ages between 18 and 30 then 'Adults'
		   when cd.ages between 31 and 59 then 'Mid_aged'
		   Else 'Senior_Citizen'
		   end Age_category,
  tr.total_sales,
  tr.customer_type
 from customer_details cd
 join TRANSACTIONS tr on cd.customer_key = tr.customer_key;
------------------------------------------------------------------------------

/*PART 3*/

select 
customer_key,
count(Distinct order_number) as total_orders,
sum(quantity) as total_quantity,
sum(price) as total_sales_Rs,
count(distinct product_key) as total_products,
max(order_date) as recent_order,
min(order_date) as oldest_order,
abs ((extract(year from max(order_date)) - extract(year from min(order_date)))*12 +
(extract(month from max(order_date)) - extract(month from min(order_date))) ) as time_period,

    case
	when (abs ((extract(year from max(order_date)) - extract(year from min(order_date)))*12 +
(extract(month from max(order_date)) - extract(month from min(order_date))) ) ) <= 5 then 'new customer'
	     when (abs ((extract(year from max(order_date)) - extract(year from min(order_date)))*12 +
(extract(month from max(order_date)) - extract(month from min(order_date))) ) ) between 6 and 20 then 'regular customer'
		 else 'old customer'
    end customer_type
	     
from gold.fact_sales
group by customer_key
order by customer_key;

-----------------------------------------------------------------------------
/* PART 4 */

with customer_calculations as(
select
Distinct customer_key,
round (avg(price),2) as avg_of_customer,
 (select
Round(avg(price),2)  as avg_of_total_sales
from gold.fact_sales
), 
round (sum(price),2) as sale_of_customer,
(select
Round(sum(price),2)  as sum_of_total_sales
from gold.fact_sales
)
from gold.fact_sales
group by customer_key
order by customer_key
)
select 
cc.customer_key,
avg_of_customer,
avg_of_total_sales,
cc.sale_of_customer,
concat(Round(cc.sale_of_customer/ cc.sum_of_total_sales *100,2),' %') as customer_contribution
from 
customer_calculations cc;

------------------


 






   



 
   
  
		   













 

 
 







