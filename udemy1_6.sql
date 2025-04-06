--QN 3
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
group by "name"

-----------------
--QN2
select distinct replacement_cost
from film
order by replacement_cost

---Write a query that gives an overview of how many films have replacements costs in the following cost ranges
select count(*),
case
when replacement_cost between 9.99 AND 19.99 then 'low'
when replacement_cost between 20.00 AND 24.99 then 'medium'
when replacement_cost between 25.00 AND 29.99 then 'high'
end as Type_rep
from film
group by type_rep