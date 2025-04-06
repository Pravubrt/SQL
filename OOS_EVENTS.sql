--SELECT * FROM public.events
with recursive ranked_date AS
          (
		  
		  select 
		  row_number() over(partition by master_id,marketplace_id ORDER BY oos_date),
		  master_id,marketplace_id,oos_date
		  from events),
		  
base_event as (

               select "row_number",master_id,marketplace_id,oos_date,1 as valid_flag
			   from ranked_date
			   where "row_number"=1

			   union all

			   select r."row_number",r.master_id,r.marketplace_id, case
			   when r.oos_date> b.oos_date+interval '7 days' then r.oos_date
			   else b.oos_date
			   end as oos_date,
			   
			   case
			   when r.oos_date> b.oos_date+interval '7 days' then 1
			   else 0
			   end as valid_flag
			   from ranked_date r
			   join base_event b ON
			        r.master_id=b.master_id
			   AND 
			        r.marketplace_id=b.marketplace_id
			   AND
			        r.row_number= b.row_number+1
			   
                )
		  
select *
from base_event
where valid_flag=1

