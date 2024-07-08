show databases;

# create database house_pricing;
use house_pricing;
show tables;
select * from raw_sales;

## df.shape
select count(*) as number_of_rows from raw_sales;  ## We have 29580 recored
select count(*) as number_of_columns from information_schema.columns where table_name ='raw_sales'; ## We have 29580 recored 4 columns(features)

## Data Info
desc raw_sales;

## Data Cleaning :

### Na-Values :
select count(*) as number_of_null_values from raw_sales where propertyType is null ;

### create new col with the date(datesold) 
alter table raw_sales add column date date ;
update raw_sales set date= date(datesold);

### dropping datesold col along with  postcode col
alter table raw_sales drop column datesold;
alter table raw_sales drop column postcode;

####### categorical counts
## bedrooms
select distinct bedrooms from raw_sales;
select bedrooms,count(bedrooms)as bedrooms_count  from raw_sales group by bedrooms order by bedrooms_count desc; 
# --- We have properties that have 0 to 5 bedrooms ,the max bedrooms count is 3  : 119333 counts , and the lowest is 0 bedrooms with 30 counts 

## propertyType
select distinct propertyType from raw_sales;
select propertyType,count(propertyType) as propertyType_count from raw_sales group by propertyType order by propertyType_count desc; 
# --- We have  2 properties types 1. house with 24552 counts and 2.units with 5028 counts 

#######   price analysis
select min(price) as min_price ,max(price) as max_price,sum(price) as total_price, Round(avg(price)) as average_price ,
Round(std(price)) as std 
from raw_sales;
# --- The Average Price is  609736 with 281703 std


select propertyType,min(price) as min_price ,max(price) as max_price,sum(price) as total_price, Round(avg(price)) as average_price ,
Round(std(price)) as std 
from raw_sales group by propertyType order by average_price desc;
# ---1. The Min price for unit property is higher than the house property
# ---2. The Max price for house property is higher than the unit property
# ---3. The Average price for house property is higher than the unit property
# ---4. The std price for for house property is higher than the unit property


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



#######################################################################################################

select date,
price,
propertyType,
bedrooms,
count(*) over() TotalOrders,
count(*) over(partition by propertyType) TotalOrdersBypropertyType,
count(*) over(partition by bedrooms) TotalOrdersBybedrooms
from raw_sales ;

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

################################################################################################

### Running Total : the increamental sum,avg,min... and  Rolling Total : 

select 
date,
price,
sum(price) over() TotalPrice,
sum(price) over(order by date) TotalPrice,
sum(price) over( order by date ROWS BETWEEN unbounded preceding and current row) RunningTotalDaily,
sum(price) over(order by date ROWS BETWEEN 2 preceding and current row) RollingTotalDaily,
sum(price) over(order by date ROWS BETWEEN current row and 2 following) RollingTotalDaily

from raw_sales ;



select 
date,
price,
sum(price) over(order by date) TotalPrice,
sum(price) over( order by date ROWS BETWEEN unbounded preceding and current row) RunningTotalDaily,
(sum(price) over( order by date ROWS BETWEEN unbounded preceding and current row)-price)/sum(price) over( 
order by date ROWS BETWEEN unbounded preceding and current row) RunningTotalPercnt
from raw_sales order by  RunningTotalPercnt ;



select 
date,
price,
avg(price) over() AvgPrice,
avg(price) over(order by date) MovingAvg,
avg(price) over(order by date rows between current row and 1 following) RollingAvg
from raw_sales ;


################################################################################################
# rank() over(order by price desc), to find the Top N
# percent_rank() over(order by price desc) to find the Top %, example:top 20%, or top 30% of propertyType
# row_number() over(order by price desc) to add unique ID
# dense_rank() over(order by price desc),
# cume_dist() over(order by price desc)
##############################################
select 
date,
price,
propertyType,
bedrooms,
rank() over(order by price desc),      
percent_rank() over(order by price desc),
row_number() over(order by price desc),
dense_rank() over(order by price desc),
cume_dist() over(order by price desc)
from raw_sales;




################################################################################################


select date,price,
    sum(price) over() As TotalePrices ,     
    round(cast(price AS float)/sum(price) over() *100,3) AS PercentageOfTotal
from raw_sales where year(date)=2017
order by PercentageOfTotal DESC 
limit 10;

select date,propertyType,price,
    round(avg(price) over()) As AveragePrices , 
	round(avg(price) over(partition by propertyType)) As AveragePricesBypropertyType,
    round(avg(price) over(partition by bedrooms)) As AveragePricesBybedrooms
    
from raw_sales where year(date)=2017 ;




select date,propertyType,bedrooms,
    avg(price) over() As TotalOrders , 
	avg(price) over(partition by year(date)) As TotalOrdersBypropertyType,
    avg(price) over(partition by propertyType) As TotalOrdersBypropertyType,
    avg(price) over(partition by bedrooms) As TotalOrdersByBedrooms
from raw_sales ;

select 
*
from(
   select propertyType,price,
    sum(price) over() As TotalPrice,
    min(price) over(partition by propertyType) As MinPrice,
    max(price) over(partition by propertyType) As MaxPrice,
    avg(price) over(partition by propertyType) As AveragePrice ,
    std(price) over(partition by propertyType) As stdPrice
   from raw_sales 
)t where price > AveragePrice;


select * from raw_sales;




