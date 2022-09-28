--select * from rideshare_kaggle$

-- Counting no.of rides by cab type (uber/lyft) and its precentage
with per as (
select cab_type,count(id) as no_of_rides 
from rideshare_kaggle$
group by cab_type)
select cab_type,no_of_rides,round(cast(no_of_rides as float)/(select sum(no_of_rides) as total_rides
from per)*100,2) as percentage_of_rides
from per

-- Relationship between rides on weekdays
select cab_type, weekdays, round((cast(max(no_of_rides) as float)/16383)*100,2) as total_rides, month
from(
select cab_type, weekdays, count(id) as no_of_rides, month
from rideshare_kaggle$ 
group by cab_type,weekdays,month) weeks
group by cab_type,weekdays,month
order by month,cab_type

--Most travelled station for both cab-types
select source,count(destination) as pickup ,cab_type,weekdays
from rideshare_kaggle$
group by source,cab_type,weekdays
order by pickup desc

--Most feasible temprature or weather to book a cab
-- Since this data i sfor nov and dec so the temprature is less than 10 degerss.
select short_summary,cab_type, count(id) as rides
from rideshare_kaggle$
group by short_summary, cab_type
order by cab_type

--Number of rides booked at what time of the day
with ride_hour as (
	select hour , cab_type, count(id) as total_no_of_rides,
	CASE when hour between 3 and 7 then 'Early Morning (03:00-07:00)AM'
	when hour >= 22 then 'Midnight (22:00 PM -02:00 AM)'
	when hour <= 2 then 'Midnight (22:00 PM -02:00 AM)'
	when hour between 8 and 12 then 'Morning (08:00 -12:00)AM'
	when hour between 13 and 17 then 'Afternoon (13:00 -17:00)PM'
	when hour between 18 and 21 then 'Evening (18:00 -21:00)PM'
		 end as ride_time
	from rideshare_kaggle$
	group by hour,cab_type)
select cab_type,ride_time,sum(total_no_of_rides) as total_no_of_rides
from ride_hour
group by cab_type,ride_time
order by total_no_of_rides desc

--Most Famous Cab type (i.e model of cab)
Select cab_type, name ,count(id) count_of_rides,
round(avg(price),2) as price, round(avg(distance),2) as distance
from rideshare_kaggle$
where price IS  NOT NULL 
group by cab_type,name
order by cab_type desc	