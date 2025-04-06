--Q1 What is the total amount each customer spent at the restaurant?
select C.customer_id,sum(B.price) as "Amt_spent"
from dbo.sales C
left join dbo.menu B on 
B.product_id= C.product_id
group by C.customer_id
order by 2 desc


--Q2 How many days has each customer visited the restaurant?
select C.customer_id,COUNT(c.customer_id) as "Days Visit"
from dbo.sales C
group by (C.customer_id)
order by 2 desc 
--Q3 What was the first item from the menu purchased by each customer?
select t.customer_id,t.product_name as "First_selection" from
(
select row_number() over(partition by customer_id order by order_date) "Rank",
C.*,B.product_name
from dbo.sales C
left join dbo.menu B on
C.product_id=B.product_id) t
where t.rank=1
--Q4 What is the most purchased item on the menu and how many times was it purchased by all customers?
select top 1 B.product_name,COUNT(B.product_name) as "Item_bought" 
from dbo.sales A left join dbo.menu B on
A.product_id=B.product_id
group by B.product_name
order by 2 desc
--q5  Which item was the most popular for each customer?
select top 3 C.customer_id,B.product_name,COUNT(B.product_name) as count_prod
from dbo.sales C join dbo.menu B on B.product_id=C.product_id
group by C.customer_id,B.product_name
order by 3 desc
--q6 Which item was purchased first by the customer after they became a member?
select t.join_date,t.order_date,t.customer_id,B.product_name from
(select 
row_number() over(partition by A.customer_id order by A.customer_id) as rank_m
,C.product_id,A.customer_id,A.join_date,C.order_date
from dbo.members A inner join dbo.sales C on
A.customer_id=C.customer_id
where DAY(order_date)>=DAY(join_date)) t
join dbo.menu B on B.product_id=t.product_id
where t.rank_m=1
-- q7 Which item was purchased just before the customer became a member?
select t.customer_id,t.join_date,t.order_date,t.product_name from
(select 
ROW_NUMBER() over(partition by C.customer_id order by A.join_date) as "row"
,C.customer_id,A.join_date,C.order_date,B.product_name
from dbo.sales C left join dbo.menu B on
C.product_id=B.product_id
left join dbo.members A on A.customer_id=C.customer_id
where order_date<join_date) t
where t.row=1
--q8 What is the total items and amount spent for each member before they became a member?
select t.customer_id,sum(t.price) as "Amtspent before join" from
(select C.customer_id,C.order_date,isnull(A.join_date,cast ('2021-01-01' as date)) as Join_date,B.product_name,B.price
from dbo.sales C left join dbo.members A on C.customer_id=A.customer_id 
left join dbo.menu B on B.product_id=C.product_id) t
where t.order_date<=t.join_date
group by t.customer_id

--Q9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select t1.customer_id,sum(t1.[Loyalty points]) as "Points" from
(select t.customer_id,t.product_name,case
        when t.product_name='Curry' then t.price*2
        else t.price*1 end as 'Loyalty points'
from
(select C.customer_id,B.product_name,sum(B.price) as "Price"
from dbo.sales C left join dbo.menu B on C.product_id=B.product_id
group by C.customer_id,B.product_name
) t
) t1
group by t1.customer_id

--Q10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
select A.customer_id, sum(B.price*2) as "Loyaltpoints"
from dbo.sales C left join dbo.members A on C.customer_id=A.customer_id
left join dbo.menu B on B.product_id=C.product_id
where order_date>=join_date
group by A.customer_id

