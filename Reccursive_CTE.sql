# Recursive CTE
# A CTE that references itself
# executes itself until no more rows are produced
# Syntax

-- WITH RECURSIVE cte_name AS
-- (
--     -- Anchor Member

--     SELECT ...

--     UNION ALL

--     -- Recursive Member

--     SELECT ...
--     FROM table
--     JOIN cte_name
-- )
-- SELECT *
-- FROM cte_name;

Use startersql;

with recursive numbers as
(
	select 1 as num
    union all
    select num + 1
    from numbers 
    where num < 10
)
select * from numbers; # generate number 

WITH RECURSIVE Table5 AS
(
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM Table5
    WHERE n < 10
)

SELECT
n,
5*n AS result
FROM Table5;

with recursive dates as 
(
	Select '2025-01-01' as dt
    union all
    Select date_add(dt,Interval 1 day)
    from dates 
    where dt < '2025-01-10'
)
Select * from dates;

# Employee heirarchy
with recursive EmployeeTree as
( 
	Select id,name,manager_id from employee
    where manager_id is Null
    union all
    Select e.id,e.name,e.manager_id from employee e
    join EmployeeTree et
    on e.manager_id = et.id
)
Select * from EmployeeTree;

# Employee level 
with recursive EmployeeLevel as
(
	Select id,name,manager_id,1 as level from employee where manager_id is null
    union all
    Select e.id,e.name,e.manager_id,et.level + 1 from employee e
    join EmployeeLevel el
    on e.manager_id = el.id
)
Select * from EmployeeLevel;

# Folder structure
with recursive Foldertree as
(
	Select id,folder_name,parent_id from folder
    where parent_id is null
    union all
    Select f.id,f.folder_name,f.parent_id from folder f
    join Foldertree ft
    on ft.id = f.parent_id
)
Select * from FolderTree;

-- CEO
-- CEO → Alice
-- CEO → Alice → Charlie
-- CEO → Alice → Charlie → Eva
with recursive EmployeeTree as
(
	Select id,name,manager_id,name as path from employee
    where manager_id is null
    union all
    Select e.id,e.name,e.manager_id,
		concat(et.path,' --> ',e.name)
	from employee e join EmployeeTree et
    on e.manager_id = et.id
)
Select * from EmployeeTree;

# Always use union all
# Always define stopping condition
# Cyclic data could be there
# Define recursion depth limits
# Performace expensive on deep heirarchies






















