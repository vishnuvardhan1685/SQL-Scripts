# Window functions - All
# Basic Syntax
-- <window_function>() OVER (
--     PARTITION BY <column>   -- optional: splits data into groups (like GROUP BY, but no collapsing)
--     ORDER BY <column>       -- optional: defines order within each partition
--     ROWS/RANGE BETWEEN ...  -- optional: defines the frame (subset of the partition)
-- )

# SQL Execution Order
-- FROM
-- ↓
-- WHERE
-- ↓
-- GROUP BY
-- ↓
-- HAVING
-- ↓
-- Window Functions (ROW_NUMBER())
-- ↓
-- SELECT
-- ↓
-- ORDER BY

Use startersql;
show tables;
CREATE TABLE employees (
    emp_id      INT PRIMARY KEY,
    emp_name    VARCHAR(50),
    department  VARCHAR(30),
    salary      INT,
    hire_date   DATE,
    city        VARCHAR(30)
);

CREATE TABLE monthly_sales (
    sales_id     INT PRIMARY KEY AUTO_INCREMENT,
    emp_id       INT,
    sales_month  DATE,
    sales_amount INT
);

# Both tables values are put at the EOF.

# ROW_NUMBER()
Select emp_name,department,salary,
	row_number() over(
		partition by department
        order by salary desc
    ) as rn
from employees;

# Write a query to fetch the highest-paid employee in each department, 
# using ROW_NUMBER() inside a subquery/CTE with WHERE rn = 1.
with rankedemployees as (
	Select emp_name,department,salary,
		row_number() over(
			partition by department
			order by salary desc
		) as rn
	from employees
)
Select emp_name, department, salary from rankedemployees 
where rn = 1;

# RANK()
SELECT emp_name, department, salary,
       RANK() OVER(
			PARTITION BY department 
            ORDER BY salary DESC
	   ) AS rnk
FROM employees; # 1 , 2 , 2 , 2 , 5

# DENSE_RANK()
SELECT emp_name, department, salary,
       DENSE_RANK() OVER(
			PARTITION BY department 
            ORDER BY salary DESC
	   ) AS drnk
FROM employees; # 1 , 2 , 2 , 2 , 3

# ROW_NUMBER vs RANK vs DENSE_RANK
SELECT emp_name, department, salary,
       ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num,
       RANK()       OVER (PARTITION BY department ORDER BY salary DESC) AS rnk,
       DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rnk
FROM employees
ORDER BY department, salary DESC;

# LAG()
# Syntax -> LAG(<column>, <offset default 1>, <default value>) OVER (PARTITION BY <col> ORDER BY <col>)

Select emp_id,sales_month,sales_amount,
		LAG(sales_amount,1,0) over(
			partition by emp_id
            order by sales_month
        ) as prev_month_sales,
        sales_amount - LAG(sales_amount,1,0) over(
			partition by emp_id
            order by sales_month
		) as mom_change
from monthly_sales;

# LEAD() - Same as lag but looks forward
# Syntax -> LEAD(<column>, <offset default 1>, <default value>) OVER (PARTITION BY <col> ORDER BY <col>)
Select emp_id,sales_month,sales_amount,
		LEAD(sales_amount,1,0) over(
			partition by emp_id
            order by sales_month
        ) as next_month_sales
from monthly_sales;

# use LEAD() on sales_amount to flag if the next month's sales will be higher
SELECT emp_id,sales_month,sales_amount,
    LEAD(sales_amount,1,0) OVER (
        PARTITION BY emp_id
        ORDER BY sales_month
    ) AS next_month_sales,
    CASE
        WHEN LEAD(sales_amount,1,0) OVER (
                PARTITION BY emp_id
                ORDER BY sales_month
             ) > sales_amount
        THEN 'Yes'
        ELSE 'No'
    END AS sales_will_improve
FROM monthly_sales;

# better version -> don't compute lead twice
WITH sales_cte AS (
    SELECT emp_id,sales_month,sales_amount,
        LEAD(sales_amount,1,0) OVER (
            PARTITION BY emp_id
            ORDER BY sales_month
        ) AS next_month_sales
    FROM monthly_sales
)
SELECT emp_id,sales_month,sales_amount,next_month_sales,
    CASE
        WHEN next_month_sales > sales_amount
        THEN 'Yes'
        ELSE 'No'
    END AS sales_will_improve
FROM sales_cte;

# FIRST_VALUE() -> Returns the first value in the ordered window/frame
# Syntax -> FIRST_VALUE(<column>) OVER (PARTITION BY <col> 
# ORDER BY <col> ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

Select emp_name,department,salary,
		FIRST_VALUE(emp_name) over(
			partition by department
            order by salary desc
        ) as top_earner_in_dept
from employees;

# For each department, show every employee alongside the department's highest salary value (not name) using FIRST_VALUE(). 
# Then compute salary - that_value as a "gap from top" column.

Select emp_name,department,salary,
		FIRST_VALUE(salary) over(
			partition by department
            order by salary desc
        ) as highest_salary_in_department,
        FIRST_VALUE(salary) over(
			partition by department
            order by salary desc
        ) - salary as salary_gap
from employees;

# cte version - optimal
WITH employee_salary AS (
    SELECT emp_name,department,salary,
        FIRST_VALUE(salary) OVER (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS highest_salary_in_department
    FROM employees
)
SELECT emp_name,department,salary,highest_salary_in_department,
    highest_salary_in_department  - salary AS salary_gap
FROM employee_salary;

# LAST_VALUE()
# This is the #1 window function gotcha. If you just write LAST_VALUE(col) OVER (PARTITION BY x ORDER BY y) without an explicit frame,
# MySQL uses the default frame RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW — meaning "last value so far", 
# which just returns the current row's own value. You MUST specify ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING 
# to actually get the true last row of the partition.

# Syntax -> LAST_VALUE(<column>) OVER ( PARTITION BY <col> ORDER BY <col> ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
# Unbound preceding -> from first values in the frame / window
# current row -> till the current row -> default
# Unbounded following -> till the last value of the window
-- WRONG (common mistake) — this just echoes the current row's salary back
SELECT emp_name, department, salary,
       LAST_VALUE(emp_name) OVER (PARTITION BY department ORDER BY salary DESC) AS wrong_lowest_earner
FROM employees;
# run this and know what it exactly does

-- CORRECT — explicit full-partition frame
SELECT emp_name, department, salary,
       LAST_VALUE(emp_name) OVER (
           PARTITION BY department ORDER BY salary DESC
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS lowest_earner_in_dept
FROM employees;

# NTILE() -> Splits the partition into N roughly-equal buckets, numbered 1..N.
# If rows don't divide evenly, earlier buckets get the extra rows.
# Syntax -> NTILE(<number_of_buckets>) OVER (PARTITION BY <col> ORDER BY <col>)

SELECT emp_name, department, salary,
       NTILE(3) OVER (ORDER BY salary DESC) AS salary_tier
FROM employees;

# wrong approach -> can't use one window function inside another window function
SELECT NTILE(4) OVER (ORDER BY salary DESC) AS bucket, 
		COUNT(*) OVER (PARTITION BY NTILE(4) OVER (ORDER BY salary DESC))
FROM employees;

# correct approach 
WITH salary_bucket AS (
    SELECT *,
           NTILE(4) OVER (
               ORDER BY salary DESC
           ) AS bucket
    FROM employees
)
SELECT bucket,
    COUNT(*) OVER (
        PARTITION BY bucket
    ) AS employees_in_bucket
FROM salary_bucket;

# IMPORTANT NOTE : WIndow Functions can't be filtered in the same query's WHERE clause; you need a subquery or CTE


