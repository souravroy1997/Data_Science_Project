-- CREATE PROJECT DATABASE

create database Zamato_project;

-- USE AS A DEAFULT DATABASE
use Zamato_project;

-- CREATE TABLE AS PER DATASET

create table zomato (`Restaurant ID` int, `Restaurant Name` text, `Country Code` int, City text, Address text, Locality text,
`Locality Verbose` text, Longitude text, Latitude text, Cuisines text, `Average Cost for two` text, Currency text, `Has Table booking`
text, `Has Online delivery` text, `Is delivering now` text, `Switch to order menu` text, `Price range` int, `Aggregate rating` text,
`Rating color` text, `Rating text` text, Votes text);

create table country_code ( `Country Code` int, Country text);


-- IMPORT ZAMATO DATA.CSV FILE FOR ANALYSIS USING CMD LINE INTERFACE

-- CREATE A NEW TABLE BY JoinING Two table Country code with zomato data

CREATE TABLE zomato_new as
select z. `Restaurant ID`, z.`Restaurant Name`, z.`Country Code`, z.City,z.Address,z.Locality,
z.`Locality Verbose`, z.Longitude, z.latitude, z.Cuisines, z.`Average Cost for two`, z.Currency, z.`Has Table booking`, 
z.`Has Online delivery`, z.`Is delivering now`, z.`Switch to order menu`, z.`Price range`, z.`Aggregate rating`,
z.`Rating color`, z.`Rating text`, z.Votes, c.Country
from zomato z inner join Country_code c
using(`Country Code`);


-- Find the total number of restaurant in various country

select Country,count(`Restaurant ID`) as No_of_Restaurant
from zomato_new
group by Country;



-- In India Zomato present in how many cities

select  country,Count(distinct City)
from zomato_new
where country = "India";


-- Total Number of Restaurants in different Cities of INDIA

select Country,City,Count(`Restaurant ID`) as total_Restaurant
from zomato_new
where Country ="India"
group by City;

-- Top 5 Cities in India Based UPON Number of Restaurants

select Country,City,Count(`Restaurant ID`) as total_Restaurant
from zomato_new
where Country ="India"
group by City
order by Count(`Restaurant ID`) DESC
limit 5;


-- worldwide city count where zomato exist


select  country,Count(distinct City) total_city
from zomato_new
group by Country;


-- Average Cost of Two in different countries

-- at first convert different currency into Dollar

alter table zomato_new
add column New_Average_cost_for_two numeric; 
alter table zomato_new
drop New_Average_cost_for_two ;
-- SET Safe Updates Mode

SET sql_safe_updates =0;

update  zomato_new set New_Average_cost_for_two = case
when currency = "Botswana Pula(P)" then `Average Cost for two` * 0.09
when currency = "Brazilian Real(R$)" then `Average Cost for two` * 0.18
when currency = "Dollar($)" then `Average Cost for two` *1
when currency = "Emirati Diram(AED)" then `Average Cost for two` * 0.27
when currency = "Indian Rupees(Rs.)" then  `Average Cost for two` * 0.013
when currency = "Indonesian Rupiah(IDR)" then `Average Cost for two` * 0.000071
when currency = "NewZealand($)" then `Average Cost for two` * 0.72
when currency = "Pounds(Å’Â£)" then `Average Cost for two` * 1.38
when currency = "Qatari Rial(QR)" then `Average Cost for two`* 0.27
when currency = "Rand(R)" then  `Average Cost for two` * 0.068
when currency = "Sri Lankan Rupee(LKR)" then  `Average Cost for two` * 0.005
when currency = "Turkish Lira(TL)" then  `Average Cost for two` * 0.11
END;


 -- Average cost of two of different Country

select Country,Avg(New_Average_cost_for_two) as Average_cost
from zomato_new
group by Country
order by New_Average_cost_for_two DESC;

 -- Average cost of two in india by different Cities
 
 
select city,Avg(New_Average_cost_for_two) as Average_cost
from zomato_new
where country ="India"
group by city
order by New_Average_cost_for_two DESC;

-- Top 5 Cities in india  based on Average cost of two 

select city,Avg(New_Average_cost_for_two) as Average_cost
from zomato_new
where country ="India"
group by city
order by New_Average_cost_for_two DESC
LIMIT 5;


-- Distribution of rating in US ( Total Rating )

select `Rating text`,count(`Aggregate rating`) as total_rating,`Rating color`
from zomato_new
where country ="United States"
group by `Rating text`;

-- Distribution of rating in INDIA ( Total Rating )

select `Rating text`,count(`Aggregate rating`) as total_rating
from zomato_new
where country ="India"
group by `Rating text`;


--  Top 10 Cuisines In India

select distinct Cuisines,  count(distinct `Restaurant ID`) as total_restaurants
from zomato_new
where country ="India"
group by cuisines
order by total_restaurants DESC
limit 10;

--  Top 10 Cuisines In US


select distinct Cuisines,  count(distinct `Restaurant ID`) as total_restaurants
from zomato_new
where country ="United States"
group by cuisines
order by total_restaurants DESC
limit 10;


-- Online Delivery Distribution

select Count(`Restaurant ID`), `Has online Delivery`
from zomato_new
group by `Has online delivery`;

select Count(`Restaurant ID`), `Has online Delivery`
from zomato_new
where country="India"
group by `Has online delivery`;

-- 

select Locality,Count(`Restaurant ID`) as count
from Zomato_new
where country="India" and city="New Delhi"
group by Locality
order by  count ASC;


-- Restaurants having rating more than 4.5

select distinct city ,Country,count(`Restaurant ID`)
from zomato_new
where `Aggregate rating` > 4.5 
group by city
order by count(`Restaurant ID`) DESC;


select distinct city ,Country,count(`Restaurant ID`)
from zomato_new
where `Aggregate rating` > 4.5 and country ="India"
group by city
order by count(`Restaurant ID`) DESC;


select count(`Restaurant ID`)

from Zomato_new
where `Has Table booking`= "yes" and `Has Online delivery`= "Yes" and country = "India";

















