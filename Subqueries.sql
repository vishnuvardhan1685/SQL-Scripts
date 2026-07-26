# A subquery is a query nested inside another query. Breakdown complex problems into smaller parts
Use startersql;

# Scalar subquery -> a sub query which returns a single value
# who earns more than average salary
Select id, name, salary from users
where salary >= (
	Select AVG(salary) from users
);

# Subqueries with IN
# find users who have been referred by someone who earns more than 75000
Select id, name, referred_by_id from users 
where referred_by_id in (
	Select id from users where salary > 75000
);

# subquery in select -> shows related calculated value
# subquery in from -> acts as virtual table
Select name, salary , 
	( Select AVG(salary) from users) as avg_salary
from users;

# example of subquery in from -> do not run 
SELECT c.name,
       t.total_amount
FROM customers c
JOIN (
    SELECT customer_id,
           SUM(amount) AS total_amount
    FROM orders
    GROUP BY customer_id
) AS t
ON c.customer_id = t.customer_id
WHERE t.total_amount > 1000;

