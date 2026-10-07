Use startersql;
# Set autocommit = 0 , do changes , if not wanted rollback; or else commit;
# Set autommit = 1 makes the changes get directly affected

Alter table users drop primary key; # can drop the primary key , may fail if it acts as foreign key elsewhere
Alter table users drop index email; # removes the index for email , so no longer uniqueness is forced
Alter table users auto_increment = 1000; # next id value starts from 1000

Create table addresses(
	id int auto_increment primary key,
    user_id int,
    street varchar(50),
    city varchar(50),
    state varchar(50),
    pincode varchar(10),
    
    foreign key (user_id) references users(id)
    on delete cascade
);

alter table addresses
add constraint fk_user
foreign key (user_id) references users(id);
# on delete cascade can be added from here too -> on delete controls what happens when parent row is deleted
# cascade -> deletes all related rows in child table
# set null -> sets the fk to null in the child table
# restrict -> prevents deletion of parent if child exists (default)


alter table addresses drop foreign key fk_user; # did not run


