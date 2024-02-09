SELECT * FROM insurance_data.data_car;

use insurance_data;
use data_car;
--  Data Info
desc data_car;

-- df.shape
select count(*) as number_of_rows from data_car;
select count(*) as number_of_columns from information_schema.columns where table_name ='data_car';

## Data Cleaning :
# Na-Values :
select count(*) as count_f_null_values from data_car where null ;

-- removing column : X_OBSTAT_
alter table data_car drop column X_OBSTAT_;

-- creatinh new colums: 
alter table data_car add column severity float ;
alter table data_car add column frequency float ;

-- updateing the new columns with the data

update data_car set severity= CASE WHEN (numclaims >0 ) THEN claimcst0/numclaims  ELSE 0 end;
update data_car set frequency= numclaims/31800.81861719781;  -- 31800.81861719781 is the sum(exposure)

-- numeric features stats:
select  min(veh_value),max(veh_value),avg(veh_value) from data_car ;
select  min(numclaims),max(numclaims) from data_car;
select  min(claimcst0),max(claimcst0),avg(claimcst0) from data_car ;
select  min(severity),max(severity),avg(severity) from data_car ;

-- categorical features stats:
select  veh_body,count(veh_body) as veh_body_count from data_car group by veh_body order by veh_body_count desc;
select  veh_age,count(veh_age) as veh_age_count from data_car group by veh_age order by veh_age_count desc;
select  gender,count(gender) as gender_count from data_car group by gender order by gender_count desc;
select  area,count(area) as area_count from data_car group by area order by area_count desc;
select  agecat,count(agecat) as agecat_count from data_car group by agecat order by agecat_count desc;

-- number of claims
select count(*) as number_of_claims from data_car where clm=1;
select numclaims,count(*) as number_of_claims_by_numclaims from data_car where clm=1 group by numclaims order by number_of_claims_by_numclaims desc;
select veh_body,count(*) as number_of_claims_by_veh_body from data_car where clm=1 group by veh_body order by number_of_claims_by_veh_body desc;
select veh_age,count(*) as number_of_claims_by_veh_age from data_car where clm=1 group by veh_age order by number_of_claims_by_veh_age desc;
select gender,count(*) as number_of_claims_by_gender from data_car where clm=1 group by gender order by number_of_claims_by_gender desc;
select area,count(*) as number_of_claims_by_area from data_car where clm=1 group by area order by number_of_claims_by_area desc;
select agecat,count(*) as number_of_claims_by_agecat from data_car where clm=1 group by agecat order by number_of_claims_by_agecat desc;


-- Average/sum severity & frequency 
select numclaims, round(avg(severity)) , round(sum(severity)), round(avg(frequency),2),round(sum(frequency),2)
from data_car group by numclaims  ;
 
select veh_body, round(avg(severity)) , round(sum(severity)), round(avg(frequency),2),round(sum(frequency),2)
from data_car group by veh_body  ;
 
select veh_age, round(avg(severity)) , round(sum(severity)), round(avg(frequency),2),round(sum(frequency),2)
from data_car group by veh_age  ;
 
select gender, round(avg(severity)) , round(sum(severity)), round(avg(frequency),2),round(sum(frequency),2)
from data_car group by gender  ;
 
select area, round(avg(severity)) , round(sum(severity)), round(avg(frequency),2),round(sum(frequency),2)
from data_car group by area  ;
 
select agecat, round(avg(severity)) , round(sum(severity)), round(avg(frequency),2),round(sum(frequency),2)
from data_car group by agecat  ;
 


















