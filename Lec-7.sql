# Group by -> group rows that have same values , used with aggregations
# having -> filter groups after aggregation

Select gender , avg(salary) as avg_salary 
from users
group by gender;

Select referred_by_id , COUNT(*) as total_referred
from users 
where referred_by_id is not null
group by referred_by_id;

Select gender, AVG(salary) as avg_salary
from users
group by gender 
having avg(salary) >= 75000;

# where is used before grouping
# having is used after groups are formed , to filter the aggregated values

# roll up and group summaries

Select referred_by_id, count(*) as total_referred from users
where referred_by_id is not null
group by referred_by_id 
having count(*) > 1;

# rollup : to get subtotals or grand totals use roll up
Select gender, count(*) as total_users
from users
group by gender with rollup;




