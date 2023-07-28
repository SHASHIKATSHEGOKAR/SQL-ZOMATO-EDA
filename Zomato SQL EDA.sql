USE Zomato ;
SHOW TABLES ;

select * from zomato.product;
select * from zomato.goldusers_signup;
select * from zomato.sales;
select * from zomato.users;

/* Q1. What is the total amount each customer spends on zomato */

select a.userid, sum(b.price) as total_amount_spent 
from sales 
a inner join product b on a.product_id = b.product_id
group by a.userid;

/* Q2. How many days has each coustomer visited zomato */

select userid, count(distinct created_date) 
as distinct_days 
from sales 
group by userid;

/* Q3. What was the First product purchased by each customer */

select * from (
	select *, rank() 
	over(partition by userid order by created_date) rnk 
	from sales
) 
a where rnk = 1;

/* Q4. What is the most purchased item on the menu and how many times it has been purchased by all the customers */

select userid,count(product_id) as count
 from sales 
 where product_id =
	(
	select product_id  from sales 
	group by product_id 
	order by count(product_id) desc
	limit 1
	)
group by userid;

/* Q5. Which item was the most popular for each customer*/

select * from ( 
	select *,rank() 
	over(partition by userid order by cnt desc)
	rnk from 
		( 
		select userid, product_id, count(product_id)cnt
		from sales group by userid,product_Id)a)b 
where rnk = 1;
 