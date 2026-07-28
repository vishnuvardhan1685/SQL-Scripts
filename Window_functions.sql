# Window Functions
# performs calculations across the set of rows related to the current row without collapsing the orginal rows
# Self joins , correlated queries , multiple CTEs , temporary tables which are slower and hard to read

# Find employees earning more than the department average.

Select * from (
	Select *,avg(salary) over(partition by dept) avg_salary
    from employees
) t 
where salary > avg_salary;

-- Major Difference
-- GROUP BY	                                        Window Function
-- Collapses rows	                                Keeps rows
-- Returns one row per group	                    Returns every row
-- Cannot access original row after grouping	    Original row remains
-- Used for aggregation	                            Used for analytics

# group by makes the changes to the original table by aggregating the values

# Over() clause -> a function becomes window function only after using over()
# partition by -> creates virtual groups

Select *,sum(amount) over(partition by customer) from sales;

Select salary , sum(salary) over(order by salary) from employees;
# Result
-- | Salary | Running Total |
-- | ------ | ------------- |
-- | 50000  | 50000         |
-- | 60000  | 110000        |
-- | 70000  | 180000        |
-- | 80000  | 260000        |
-- | 90000  | 350000        |

-- ROW_NUMBER, RANK , DENSE RANK 
# Example
Select s.student_id,s.name,s.branch,sum(score) as total_score,
ROW_NUMBER() over (
	partition by s.branch
    order by sum(e.score) desc
) as row_num,
RANK() over (
	partition by s.branch
    order by sum(e.score) desc
) as rank_num,
DENSE_RANK() over (
	partition by s.branch
    order by sum(e.score) desc
) as dense_rank_num
from exam_scores as e
inner join students s on s.student_id = e.student_id
group by e.student_id,s.name,s.name;

# Row number -> remove duplicates , pagination
# Rank -> competition ranking
# Dense Rank -> top n distinct values






