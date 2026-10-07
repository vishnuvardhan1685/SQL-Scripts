Use startersql;

Alter table users add column salary int;

Select * from users;

Select count(*) from users;
Select count(*) from users where gender = 'female';
Select MIN(salary) as min_salary , MAX(salary) as max_salary from users; # did not run
Select SUM(salary) as total_salary from users;
Select AVG(salary) as avg_salary from users;
Select name, LENGTH(name) as name_length from users;
Select name, LOWER(name) as lowercase_name from users;
Select name, UPPER(name) as uppercase_name from users;
Select CONCAT(name,'<',email,'>') as user_contact from users;
Select now(); # returns date and time
Select name, YEAR(date_of_birth) as birth_year from users;
Select name, DATEDIFF(curdate(), date_of_birth) as days_lived from users;
Select name, TIMESTAMPDIFF(YEAR, date_of_birth, curdate()) as age from users;
Select name, round(salary) as rounded, floor(salary) as floored, ceil(salary) as ceiled from users;
Select id,MOD(id,2) as remainder from users;


# Conditional functions

Select name, gender, if(gender = 'female', 'YES', 'NO') as is_female from users; # kindaa ternary



