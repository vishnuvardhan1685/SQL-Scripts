# Stored Procedures

DELIMITER $$ # temporarily changes the statement delimiter
Create procedure adduser (
	In p_name varchar(100),
    In p_email varchar(100),
    In p_gender enum('Male','Female','Other'),
    In p_dob Date,
    In p_salary int
)
 BEGIN 
	insert into users(name, email , gender, date_of_birth, salary)
    values(p_name, p_email, p_gender, p_dob, p_salary);
END $$
DELIMITER ;

call adduser('Kiran Sharma', 'kiran@example.com','Female','1994-06-15', 72000);
# view stored procedures
show procedure status where db = 'startersql';

drop procedure if exists adduser; # did not run

# Triggers
# special type of stored program which is automatically executed when specific event occurs in a table
# trigger can be fired : before or after an event

# Example
Create table user_log (
	id int auto_increment primary key,
    user_id int,
    name varchar(100),
    created_at timestamp default current_timestamp
);

DELIMITER $$
Create Trigger after_user_insert
After insert on users # trigger is fired after insert happens into user
for each row 
begin
	Insert into user_log(user_id,name)
    values (NEW.id,NEW.name); # new refers to the new row being added to the users table
end$$
DELIMITER ;

call adduser('Rithish Jain', 'rithish@example.com','Male', '1996-03-12', 74000);

Select * from user_log;

drop trigger if exists after_user_insert;

# add column
alter table user
add column city varchar(100); # did not run

# like - second letter a -> '_a%'
# distincr
Select distinct gender from users;

truncate table users; # deletes all rows from table keeping table alive

# change -> rename and change datatype
alter table users
change column city location varchar(150);

# modify -> only change datatype
alter table users
modify column salary bigint;
