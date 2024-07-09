show databases;

# create database house_pricing;
use house_pricing;
show tables;
select * from raw_sales;

----------------------------------------------------------------------------------------------------------

## df.shape
/* How many rows the data set has? */
select count(*) as number_of_rows from raw_sales; 
/* How many columns the data set has? */
select count(*) as number_of_columns from information_schema.columns where table_name ='raw_sales';

----------------------------------------------------------------------------------------------------------

## Data Info
/* what are the schemas names and data types? */
desc raw_sales;

----------------------------------------------------------------------------------------------------------

## Na-Values :
/* Any Null Values? */
select count(*) as number_of_null_values from raw_sales where propertyType is null ;

----------------------------------------------------------------------------------------------------------

## create new col with the date(datesold) 
alter table raw_sales add column date date ;
update raw_sales set date= date(datesold);

----------------------------------------------------------------------------------------------------------

## dropping datesold col along with  postcode col
alter table raw_sales drop column datesold;
alter table raw_sales drop column postcode;

----------------------------------------------------------------------------------------------------------
--                                        --categorical Features--
-- 1. bedrooms :
select distinct bedrooms from raw_sales;
select bedrooms,count(bedrooms)as bedrooms_count  from raw_sales group by bedrooms order by bedrooms_count desc; 
-- We have properties that have 0 to 5 bedrooms ,the max bedrooms count is 3  : 119333 counts , and the lowest is 0 bedrooms with 30 counts 

----------------------------------------------------------------------------------------------------------

-- 2. propertyType :
select distinct propertyType from raw_sales;
select propertyType,count(propertyType) as propertyType_count from raw_sales group by propertyType order by propertyType_count desc; 
-- We have  2 properties types 1. house with 24552 counts and 2.units with 5028 counts 

----------------------------------------------------------------------------------------------------------
--                                        --Numerical Features--

-- Only One Numeric Feature -Price- :
select min(price) as min_price ,max(price) as max_price,sum(price) as total_price, Round(avg(price)) as average_price ,
Round(std(price)) as std 
from raw_sales;
-- The Average Price is  609736 with 281703 std

----------------------------------------------------------------------------------------------------------
--                                        --Price By propertyType --

select propertyType,min(price) as min_price ,max(price) as max_price,sum(price) as total_price, Round(avg(price)) as average_price ,
Round(std(price)) as std 
from raw_sales group by propertyType order by average_price desc;
# ---1. The Min price for unit property is higher than the house property
# ---2. The Max price for house property is higher than the unit property
# ---3. The Average price for house property is higher than the unit property
# ---4. The std price for for house property is higher than the unit property

----------------------------------------------------------------------------------------------------------
--                                        --Price By bedrooms --

select bedrooms,min(price) as min_price ,max(price) as max_price,sum(price) as total_price, Round(avg(price)) as average_price ,
Round(std(price)) as std ,
rank() over(order by min(price) desc) as min_priceRank,
rank() over(order by max(price) desc) as max_priceRank,
rank() over(order by sum(price) desc) as total_priceRank,
rank() over(order by Round(avg(price)) desc) as average_priceRank
from raw_sales group by bedrooms order by bedrooms asc;
# ---1. The 5 bedrooms has the rank 1(highest Min) and the 4 bedrooms rank 6(lowest Min).
# ---2. The 4 bedrooms has the rank 1(highest Max) and the 0 bedrooms rank 6(lowest Max).
# ---3. The 4 bedrooms has the rank 1(highest total) and the 0 bedrooms rank 6(lowest total).
# ---4. The 5 bedrooms has the rank 1(highest average) and the 1 bedrooms rank 6(lowest average).

----------------------------------------------------------------------------------------------------------
--                                        --Price By date --

select*
from(
select date,min(price) as min_price ,max(price) as max_price,sum(price) as total_price, Round(avg(price)) as average_price ,
Round(std(price)) as std ,
rank() over(order by min(price) desc) as min_priceRank,
rank() over(order by max(price) desc) as max_priceRank,
rank() over(order by sum(price) desc) as total_priceRank,
rank() over(order by Round(avg(price)) desc) as average_priceRank
from raw_sales group by date order by date asc
)t where min_priceRank=1 or max_priceRank=1 or total_priceRank=1 or average_priceRank=1;
# ---1. The rank 1(highest Min price) date was on date 2016-11-20
# ---2. The rank 1(highest max price) date was on date 2015-11-02.
# ---3. The rank 1(highest total price) date was on date 2017-10-28.
# ---4. The rank 1(highest average price) date was on date 2016-11-20
# -----> 2016-11-20 has the highest Min and Average

----------------------------------------------------------------------------------------------------------
--                                        --Price By year --

select*
from(
select year(date),min(price) as min_price ,max(price) as max_price,sum(price) as total_price, Round(avg(price)) as average_price ,
Round(std(price)) as std ,
rank() over(order by min(price) desc) as min_priceRank,
rank() over(order by max(price) desc) as max_priceRank,
rank() over(order by sum(price) desc) as total_priceRank,
rank() over(order by Round(avg(price)) desc) as average_priceRank
from raw_sales group by year(date) order by year(date) asc
)t where min_priceRank=1 or max_priceRank=1 or total_priceRank=1 or average_priceRank=1;
# ---1. The rank 1(highest Min price) date was on year 2011
# ---2. The rank 1(highest max price) date was on year 2015.
# ---3. The rank 1(highest total price) date was on year 2017
# ---4. The rank 1(highest average price) date was on year 2017 as well.

----------------------------------------------------------------------------------------------------------
--                                        --Price By Month --

select*
from(
select month(date),min(price) as min_price ,max(price) as max_price,sum(price) as total_price, Round(avg(price)) as average_price ,
Round(std(price)) as std ,
rank() over(order by min(price) desc) as min_priceRank,
rank() over(order by max(price) desc) as max_priceRank,
rank() over(order by sum(price) desc) as total_priceRank,
rank() over(order by Round(avg(price)) desc) as average_priceRank
from raw_sales group by month(date) order by month(date) asc
)t where min_priceRank=1 or max_priceRank=1 or total_priceRank=1 or average_priceRank=1;
# ---1. The rank 1(highest Min price) month was on  1 (Jan)
# ---2. The rank 1(highest max price)  and rank 1(highest total price)  and rank 1(highest average price) month was on  11 (Octuber).

----------------------------------------------------------------------------------------------------------
--                                        --Price By Day --

select*
from(
select day(date),min(price) as min_price ,max(price) as max_price,sum(price) as total_price, Round(avg(price)) as average_price ,
Round(std(price)) as std ,
rank() over(order by min(price) desc) as min_priceRank,
rank() over(order by max(price) desc) as max_priceRank,
rank() over(order by sum(price) desc) as total_priceRank,
rank() over(order by Round(avg(price)) desc) as average_priceRank
from raw_sales group by day(date) order by day(date) asc
)t where min_priceRank=1 or max_priceRank=1 or total_priceRank=1 or average_priceRank=1;
# ---1. The rank 1(highest Min price) was on day 23 of  month.
# ---2. The rank 1(highest max price) was on day 2 of  month..
# ---3. The rank 1(highest total price) was on day 7 of  month.
# ---4. The rank 1(highest average price) was on day 14 of  month.

----------------------------------------------------------------------------------------------------------
--                                        --propertyType & bedrooms Count and CountPercent--


select 
propertyType,
bedrooms,
count(*) over() TotalOrders,
count(*) over(partition by propertyType) TotalOrdersBypropertyType,
count(*) over(partition by bedrooms) TotalOrdersBybedrooms

from raw_sales ;

----------------------------------------------------------------------------------------------------------
--                                        --propertyType & bedrooms Count and CountPercent--

select 
date,
price,
bedrooms,
sum(price) over() TotalPrice,
round(cast(price as float)/sum(price) over() *100,3) PercentOfTotal,

sum(price) over(partition by propertyType) TotalPriceBypropertyType,
round(cast(price as float)/sum(price) over(partition by propertyType) *100,3) PercentOfTotalBypropertyType,

sum(price) over(partition by bedrooms) TotalPriceBybedrooms,
round(cast(price as float)/sum(price) over(partition by bedrooms) *100,3) PercentOfTotalBybedrooms
from raw_sales order by bedrooms desc,PercentOfTotalBybedrooms desc ;

----------------------------------------------------------------------------------------------------------
--                                        --Running Total--

--  ROWS BETWEEN unbounded preceding and current row : is the default for Running Total

select 
date,
price,
sum(price) over() TotalPrice,
sum(price) over(order by date) TotalPrice,
sum(price) over( order by date ROWS BETWEEN unbounded preceding and current row) RunningTotalDaily
from raw_sales ;

----------------------------------------------------------------------------------------------------------
--                                        --Rolling Total--

-- ROWS BETWEEN 2 preceding and current row (or other formats but not the Running Total format): is the default for Rolling Total


select 
date,
price,
sum(price) over(order by date) TotalPrice,
sum(price) over(order by date ROWS BETWEEN 2 preceding and current row) RollingTotalBetweenCurrentAndPrevious_2,
sum(price) over(order by date ROWS BETWEEN current row and 2 following) RollingTotalBetweenCurrentAndFlowing_2
from raw_sales  ;


----------------------------------------------------------------------------------------------------------
--                                        --Rolling Average--

select 
date,
price,
round(avg(price) over(order by date)) AvgPrice,
round(avg(price) over(order by date ROWS BETWEEN 2 preceding and current row)) RollingAverageBetweenCurrentAndPrevious_2,
round(avg(price) over(order by date ROWS BETWEEN current row and 2 following)) RollingAverageBetweenCurrentAndFlowing_2
from raw_sales  ;


----------------------------------------------------------------------------------------------------------

