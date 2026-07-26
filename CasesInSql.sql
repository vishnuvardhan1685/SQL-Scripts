# 1. CASE Expression 
-- Why CASE exists when we already have IF()
-- Simple CASE
-- Searched CASE
-- CASE in SELECT
-- CASE in ORDER BY
-- CASE in GROUP BY
-- CASE inside aggregate functions
-- Real interview problems-- 

Use startersql;
# IF
Select if(salary > 50000 , 'High', 'Low') as salary_level from users;
# Case helps in building if else if else logic logic in sql , order of cases in query matters
# common mistakes -> missing end , forgetting else case
# Example of Searched case -> checks multiple conditions -> like if else if
Select name, salary , 
	Case
		when salary > 100000 then 'Excellent'
        when salary > 70000 then 'Good'
        when salary > 40000 then 'Average'
        else 'Poor'
	end
    as salary_level
from users;

Select id,name,timestampdiff(year, created_at,curdate()) as experience,
	case 
		WHEN TIMESTAMPDIFF(YEAR, created_at, CURDATE()) < 2 THEN 'Junior'
        WHEN TIMESTAMPDIFF(YEAR, created_at, CURDATE()) BETWEEN 2 AND 5 THEN 'Mid-Level'
        ELSE 'Senior'
    END AS employee_level
FROM users;

# Example of Simple case -> compares on expression -> like switch
Select name,
	case department
		when 'IT' then 'Technology'
        when 'HR' then 'Human Resources'
        when 'FIN' then 'Finance'
        else 'Unknown'
	end
    as department_type
from employees;

# Simple case can't replace Searched case

# Case in Select
SELECT
    name,
    salary,
    CASE
        WHEN salary >= 100000 THEN 'Excellent'
        WHEN salary >= 70000 THEN 'Good'
        WHEN salary >= 40000 THEN 'Average'
        ELSE 'Poor'
    END AS salary_category
FROM users;

# Case in order by
Select * from users
order by 
case 
	when status = 'Active' then 1
    when status = 'Pending' then 2
    when status = 'Inactive' then 3
end; # Internally sorts 1 2 3

# Case in group by
Select
Case when salary < 50000 then 'Low'
	 when salary < 70000 then 'Average'
     else 'Excellent'
end as salary_level,
Count(*) from users
group by case when salary < 50000 then 'Low'
			  when salary < 70000 then 'Average'
			  else 'Excellent'
		 end; # can directly use alias of salary_level as well

# Conditional Count
# Count male and female in one query
Select 
	Count(Case when gender = 'Male' then 1 End) as Males,
    Count(Case when gender = 'Female' then 1 End) as Females
from users;

Select gender , count(*) from users group by gender; # this results in row wise result

# Conditional Sum
# Count male and female salary in one query
Select 
	Sum(
		case when gender = 'Male' then salary 
			 else 0
		end
	) as male_salary,
    Sum(
		case when gender = 'Female' then salary
			 else 0
		end
	) as female_salary
from users;

Select gender,sum(salary) as total_salary from users group by gender; # this gives row wise result

# Conditional Average
# Count male and female average salaries in one query
Select 
	Avg(
		case
			when gender = 'Male' then salary
		end
    ) as male_avg_salary,
    Avg(
		case 
			when gender = 'Female' then salary
		end
    ) as female_avg_salary
from users; # using else 0 increase the values count 

# Question : Display the gender-wise employee count for every department
Select department ,
	count(case when gender = 'Male' then 1 end) as males,
    count(case when gender = 'Female' then 1 end) as females
from employees
group by department;

    





