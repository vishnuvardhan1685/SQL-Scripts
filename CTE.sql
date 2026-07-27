# CTE - Common Table Expressions (CTEs)
# A temporary named result that only exists for the current query

# Without CTE
Select * from users u
join (
	Select department, AVG(salary) as avg_salary
    from users
    group by department ) d
on u.department = d.department
where u.salary > d.avg_salary;

# Examples with CTE
# Basic
with high_salary as (
	Select * from users
    where salary > 70000
)
Select * from high_salary;

# Group By
with dept_avg as (
	Select department,avg(salary) as avg_salary
    from users group by department
)
Select * from dept_avg;

# Join with CTE
with dept_avg as (
	Select department,avg(salary) as avg_salary
    from users group by department
)
Select * from users u
join dept_avg  d on u.department = d.department
where u.salary > d.avg_salary;

# Multiple CTE
with dept_avg as (
	Select department.avg(salary) as avg_salary
    from users group by department
),
high_paid as (
	Select u.* from users u
    join dept_avg d on 
    u.department = d.department 
    where u.salary > d.avg_salary
)
Select * from high_paid;

# Using CTE Multiple times
with dept_avg as (
	Select department,avg(salary) as avg_salary
    from users
    group by department
)
Select * from dept_avg
where avg_salary > 60000
Union all
Select * from dept_avg
where avg_salary <= 60000;

# Interview Level
with dept_avg as (
	Select department, avg(salary) as avg_salary
    from users group by department
)
Select * from dept_avg
where avg_salary > (
	Select avg(salary) from users
)






