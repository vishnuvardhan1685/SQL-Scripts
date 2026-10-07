Create Database startersql;
Use startersql;

Create Table users (
	id INT auto_increment primary key,
    name varchar(100),
    email varchar(100) unique not null,
    gender enum("Male","Female","Other"),
    date_of_birth date,
    created_at timestamp default current_timestamp
    
);

Select * from users;
Select name,email from users;

Rename table users to customers;
Rename table customers to users;

alter table users add column is_active boolean default true;
alter table users drop column is_active;

alter table users modify column email varchar(150) first; 
# first denotes the column place in table
# can also after name

alter table users 
add column phone varchar(15),
add column city varchar(100);

alter table users rename column phone to mobile_number;

INSERT INTO users
(name, email, gender, date_of_birth)
VALUES
('Bob', 'bob@example.com',
'Male', '1990-11-23'),
('Charlie', 'charlie@example.com',
'Other', '1988-02-17');

INSERT INTO users
(name, email, gender, date_of_birth)
VALUES
('David', 'david@example.com',
'Male', '2000-08-09'),
('Eva', 'eva@example.com',
'Female', '1993-12-30');

Select * from users where gender="Male";
Select * from users where gender <> "Female";
Select * from users where date_of_birth < '1995-01-01';
Select * from users where date_of_birth is null; # is / is not
Select * from users where date_of_birth between '1990-01-01' and '2000-12-31';
Select * from users where gender in ('Male','Other');
Select * from users where name like 'A%'; # '%A' or '%AA%'
Select * from users where gender = 'Female' AND date_of_birth > '1990-01-01'; # and / or
Select * from users LIMIT 5; # top 5
Select * from users LIMIT 10 offset 5; # skip first 5 rows
Select * from users LIMIT 5,10; # 10 rows from 6th row

Select * from users Order By name DESC; # ASC for ascending

Select * from users order by created_at DESC LIMIT 10;

Update users set name = 'Alice' where id = 1; # without where can update all the rows

# Delete from table_name where condition;
# Delete from users; deletes all rows
# Drop table users; deletes the entire table

# Unique constraint
Alter table users add constraint unique_name unique(name); # did not run
# Not NUll constraint
Alter table users modify column name varchar(100) not null; 
# Check constraint
Alter table users add constraint chk_dob check ( date_of_birth > '2001-01-01'); # did not run
# Default constraint
Alter table users alter column is_active set default true; # did not run
# Primary key constraint
Alter table users add primary key (id);










