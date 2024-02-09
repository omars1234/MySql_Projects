show databases;
create database house_pricing;
use house_pricing;
show tables;
select * from raw_sales;

## df.shape
select count(*) as number_of_rows from raw_sales;
select count(*) as number_of_columns from information_schema.columns where table_name ='raw_sales';

## Data Info
desc raw_sales;

## Data Cleaning :
# Na-Values :
select count(*) as number_of_null_values from raw_sales where propertyType is null ;

####### categorical counts
## bedrooms
select distinct bedrooms from raw_sales;
select bedrooms,count(bedrooms)as bedrooms_count  from raw_sales group by bedrooms order by bedrooms_count desc; 

## propertyType
select distinct propertyType from raw_sales;
select propertyType,count(propertyType) as propertyType_count from raw_sales group by propertyType order by propertyType_count desc; 

#######   price analysis
select min(price) as min_price ,max(price) as max_price,sum(price) as total_price, avg(price) as average_price ,
std(price) as std 
from raw_sales;

select datesold,min(price) as min_price ,max(price) as max_price,sum(price) as total_price, avg(price) as average_price,
std(price) as std  
from raw_sales group by datesold order by average_price desc;

select propertyType,min(price) as min_price ,max(price) as max_price,sum(price) as total_price, avg(price) as average_price,
std(price) as std 
from raw_sales group by propertyType order by average_price desc;

select bedrooms,min(price) as min_price ,max(price) as max_price,sum(price) as total_price, avg(price) as average_price ,
std(price) as std 
from raw_sales group by bedrooms order by average_price desc;






