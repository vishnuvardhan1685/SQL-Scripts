Use startersql;

Select users.name , addresses.city
from users inner join addresses
on users.id = addresses.user_id;

Select users.name , addresses.city
from users left join addresses
on users.id = addresses.user_id;

Select users.name , addresses.city 
from users right join addresses
on users.id = addresses.user_id;

# union and union all
# union -> removes duplicates , union all -> includes all

Create table admin_users (
	id int primary key,
    name varchar(100),
    email varchar(100),
    gender enum('male','female','other'),
    date_of_birth date,
    salary int
);

INSERT INTO admin_users
(id, name, email, gender, date_of_birth, salary)
VALUES
(101, 'Anil Kumar', 'anil@example.com',
'Male', '1985-04-12', 60000),
(102, 'Pooja Sharma', 'pooja@example.com',
'Female', '1992-09-20', 58000),
(103, 'Rakesh Yadav', 'rakesh@example.com',
'Male', '1989-11-05', 54000),
(104, 'Fatima Begum', 'fatima@example.com',
'Female', '1990-06-30', 62000);

Select name from users 
union
Select name from admin_users;

Select name from users 
union all
Select name from admin_users;

Select name, "User" as role from users
union all
Select name, "Admin" as role from admin_users;

SELECT name FROM users
UNION
SELECT name FROM admin_users
ORDER BY name;

# Self Join

Alter table users 
add column referred_by_id int;

Update users
Set referred_by_id = 1 where id in (2,3); # 2,3 are list of values

Update users
Set referred_by_id = 2 where id = 4;

Select a.id, a.name as user_name, b.name as referred_by
from users a left join users b
on a.referred_by_id = b.id;







