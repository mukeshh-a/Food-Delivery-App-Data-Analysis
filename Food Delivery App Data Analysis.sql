-- Top 5 most voted hotels in the delivery category.

select top 5
	 name
	,votes
from zomatocleaned
where type = 'delivery'
order by votes desc;


-- Top 5 highly rated hotels in the delivery category for a particular location called Banashankari.

select top 5
	 name
	,rating
from zomatocleaned
where location = 'Banashankari' and type = 'delivery'
order by votes desc;


-- Comparison between the ratings of the cheapest and most expensive hotels in Indiranagar.

with cheap as (
select top 1 name, rating, approx_cost
from zomatocleaned
where approx_cost > 0 -- Exclude records with zero cost
		and location = 'indiranagar'
order by approx_cost asc
),
expensive as (
select top 1 name, rating, approx_cost
from zomatocleaned
where approx_cost > 0 -- Exclude records with zero cost
		and location = 'indiranagar'
order by approx_cost desc
)
select cheap.name as cheapest_hotel, cheap.rating as cheapest_rating,
expensive.name as expensive_hotel, expensive.rating as expensive_rating
from cheap, expensive
where cheap.rating is not null and expensive.rating is not null;


-- Comparison between the total votes of restaurants that provide online ordering services and those that don’t provide online ordering services.

select
	case 
		when online_order = 1 
		then 'Online Ordering' else 'No Online Ordering' 
		end as [Ordering Type],
	sum(votes) as [Total Votes]
from zomatocleaned
group by 
	case 
	when online_order = 1 
	then 'Online Ordering' else 'No Online Ordering' end;


-- The number of restaurants, total votes, and average rating for each Restaurant type.

select 
	 type as [Restaurant Type]
	,count(distinct name) as [Total Restaurants]
	,sum(votes) as [Total Votes]
	,avg(rating) as [Average Rating]
from zomatocleaned
where type <> 'NA'
group by type
order by [Total Votes] desc;


-- The most liked dish of the most-voted restaurant on Zomato.

with most_voted_restaurant as (
    select top 1
        name as [Restaurant Name],
        sum(votes) as [Total Votes]
    from zomatocleaned
    where online_order = 1 -- Restaurant provides online ordering
        and type = 'delivery' -- Restaurant provides delivery
    group by name
    order by [Total Votes] desc
),
most_liked_dish as (
    select top 1
        dish_liked
    from zomatocleaned
    where name in (select [Restaurant Name] from most_voted_restaurant)
    order by votes desc
)
select dish_liked as [Most Liked Dish]
from most_liked_dish;


-- The top 15 restaurants which have min 150 votes, have a rating greater than 3, and is currently not providing online ordering.

select top 15 
	 name
	,votes
	,rating
from zomatocleaned
where votes >= 150 and rating > 3 and online_order = 0
order by votes desc;
