use customer_behavior

select top 15 * from customer ;

-- Revenue genrated by gender (male/female)

select gender, SUM(purchase_amount) as revenue 
from customer
group by gender;

-- customer used a discount but still spent more than the avg purchase amount 
 
 select count(customer_id),purchase_amount
 from customer
 where discount_applied = 'yes' and purchase_amount >= (select AVG(purchase_amount) from customer);

 -- top 5 product(item_purchased) with the highest avg review rating

 select top 5 item_purchased,ROUND(avg(review_rating),2) as avg_rating  
 from customer
 group by item_purchased
 order by avg_rating desc

 -- compare the avg purchase amount (standard and express)

 select shipping_type, ROUND(avg(purchase_amount),2)
 from customer
 where shipping_type in ('Standard','Express')
 group by shipping_type


 -- do subcribed customer spend more?

 select subscription_status,
 count(customer_id) as total_customer,
 round(avg(purchase_amount),2) as avg_spend,
 round(SUM(purchase_amount),2) as total_revenue 
 from customer
 group by subscription_status
 order by total_revenue,avg_spend desc;

 -- wich 5 product have the highest percentage of purchases with discount applied?

 select top 5
 item_purchased,
 ROUND(100 * sum(case when discount_applied = 'yes' then 1 else 0 end)/COUNT(*),2) as discount_rate
 from customer
 group by item_purchased
 order by discount_rate desc;

 -- segment customer itno new, returning, and loyal based on their total number

 with customer_type as (
 select customer_id, previous_purchases,
 case
     when previous_purchases = 1 then 'new'
     when previous_purchases  between 2 and 10 then 'returning'
     else 'loyal'
     end as customer_segment
from customer
)

select customer_segment,COUNT(*) as 'number od customer'
from customer_type
group by customer_segment;


-- what are the top 3 most pruchased product within each category?

with item_counts as (
select category, item_purchased, count(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <=3;


 -- are customer who are repeat buyers ( more than 5 previous purchases)

 select subscription_status,
 count(customer_id) as repeat_buyers
 from customer
 where previous_purchases > 5
 group by subscription_status;

 -- what is revenue contribution of each age group

 select age_group,sum(purchase_amount) as total_revenue 
 from customer
 group by age_group
 order by total_revenue desc;
