show databases;

use autoinsurance;
show tables;


select * from data_car;

-- df.shape
select count(*) as number_of_rows from data_car;
select count(*) as number_of_columns from information_schema.columns where table_name ='data_car';

--  Data Info
desc data_car;

## Data Cleaning :
# Na-Values :
select count(*) as count_f_null_values from data_car where null ;

-- removing column : X_OBSTAT_
alter table data_car drop column X_OBSTAT_;

-- creating new colums: 
alter table data_car add column severity float ;
# alter table data_car add column frequency float ;

-- updateing the new columns with the data
update data_car set severity= CASE WHEN (numclaims >0 ) THEN claimcst0/numclaims  ELSE 0 end;
# update data_car set frequency= numclaims/exposure;

-- changing data type
alter table data_car add column age_cat char ;
alter table data_car add column veh_age_cat char;

update data_car set age_cat= CAST(agecat AS char);
update data_car set veh_age_cat= CAST(veh_age AS char);

alter table data_car drop column agecat;
alter table data_car drop column veh_age;


-- numeric features stats:
select gender,avg(claimcst0)
from data_car group by gender;




select  min(veh_value),max(veh_value),avg(veh_value) from data_car ;
select  min(numclaims),max(numclaims),sum(numclaims) from data_car;
select  min(claimcst0),max(claimcst0),avg(claimcst0) from data_car ;
select  min(severity),max(severity),avg(severity) from data_car ;




