--QN14 
select t.* from
(select f.title,c.name as category,sum(p.amount)
from payment p inner join rental r ON
p.rental_id=r.rental_id 
INNER JOIN inventory i ON
i.inventory_id= r.inventory_id 
INNER JOIN film f ON
f.film_id= i.film_id
INNER JOIN film_category fc ON
fc.film_id=f.film_id 
INNER JOIN category c ON
c.category_id= fc.category_id

group by title,"name") t

where t.category='Animation'

order by 3 desc limit 2


--QN13 not completed
select c.name, sum(p.amount)
from payment p inner join rental r ON
p.rental_id=r.rental_id 
INNER JOIN inventory i ON
i.inventory_id= r.inventory_id 
INNER JOIN film f ON
f.film_id= i.film_id
INNER JOIN film_category fc ON
fc.film_id=f.film_id 
INNER JOIN category c ON
c.category_id= fc.category_id
group by c.name
having "name"='Action'
-- Action 4375.85$

--what is the lowest payment_id in Action category
select c.name,p.payment_id, sum(p.amount)
from payment p inner join rental r ON
p.rental_id=r.rental_id 
INNER JOIN inventory i ON
i.inventory_id= r.inventory_id 
INNER JOIN film f ON
f.film_id= i.film_id
INNER JOIN film_category fc ON
fc.film_id=f.film_id 
INNER JOIN category c ON
c.category_id= fc.category_id
group by c.name,payment_id
having "name"='Action'

order by 2 limit 2
---lowest payment_id in Action category is 16055 wwith $2.99

--QN12 average customer lifetime amount$ grouped by districts
select t.district,round(avg(total),2)
from
(select p.customer_id,district,sum(amount) as total
from
payment p inner join customer c ON
p.customer_id= c.customer_id 

inner join address a ON
a.address_id= c.address_id

group by p.customer_id,district
) t

group by t.district
order by 2 desc limit 2



--QN11 list of movies where length is more than average length. 
select A.title,A.length,B.avg
from
(select title,"length",replacement_cost
from film) A 

left join

(select replacement_cost, avg("length")
from film
group by replacement_cost) B
ON
A.replacement_cost=B.replacement_cost

where

"length">"avg"

order by 2 limit 2


--QN10
select round(avg(t.SundaySum),2) from
(select date(payment_date) date,sum(amount) SundaySum
from payment

where date_part('dow',payment_date)=0
group by date) as t

---QN9 
select t.staff_id,round(avg(total),2) as Average
from

(select  staff_id,customer_id, sum(amount) total
from payment p 
group by customer_id,staff_id) t

group by t.staff_id


--QN8 which country,city has least sales
select (D.city||','||E.country) Place,sum(A.amount)
from payment A left join customer B ON
A.customer_id=B.customer_id
left join Address C on 
C.address_id=B.address_id
left join city D ON
D.city_id=C.city_id left join country E ON
E.country_id=D.country_id
group by Place
order by 2 limit 2

--QN7 max sales with city wise(where customer lives)
select D.city,sum(A.amount)
from payment A left join customer B ON
A.customer_id=B.customer_id
left join Address C on 
C.address_id=B.address_id
left join city D ON
D.city_id=C.city_id
group by D.city
order by 2 desc limit 2 

--QN6 address that are not associated with any customer
select count(*) from
(select A.address_id,B.first_name,B.last_name,A.address
from address A left join customer B ON
A.address_id=B.address_id) t
where t.first_name is null or t.last_name is null


--QN5
select C.first_name,C.last_name,count(A.title) 
from film A left join film_actor B ON
A.film_id=B.film_id
left join actor C ON
C.actor_id=B.actor_id
group by C.first_name,C.last_name
order by 3 desc
limit 2


--QN4----
select t.name,count(*)
from
(select title,C.name
from film A 
left join 
film_category B 
ON A.film_id= B.film_id
left join 
category C ON
C.category_id=B.category_id
order by "length" desc) t
group by t.name
order by 2 desc
limit 2
-------------------
--QN3
SELECT max(t.length),t.name
FROM 
(select title,"length",C.name
from film A 
left join 
film_category B 
ON A.film_id= B.film_id
left join 
category C ON
C.category_id=B.category_id
order by "length" desc) t
where "name"='Drama' or "name"='Sports'
group by t.name