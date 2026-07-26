Use startersql;

Create view high_salary_users as
Select id , name , salary from users
where salary > 70000;

Select * from high_salary_users;

Update users set salary = 72000 where id = 1;

Select * from high_salary_users; # views are updated as the updates happen to the actual database

# views act like saved select queries , aren't duplicate data , simplifies complex queries 

Drop view high_salary_users; # deletes the view 

# SQL Indexes
# speed up the data retreival 

show indexes from users;
create index idx_email on users(email);

Select * from users where email = 'bob@example.com';

create index idx_gender_salary on users(gender,salary); # multi column index
# index order matters -> quering gender first then salary is efficient , and using both is efficient
Select * from users where gender = 'Female' and salary > 70000;

drop index idx_email on users; # did not run



