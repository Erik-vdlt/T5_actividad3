#Before Update Trigger:
create table customer (acc_no integer primary key, 
                                 cust_name varchar(20), 
                                  avail_balance decimal);
create table mini_statement (acc_no integer, 
                              avail_balance decimal, 
                     foreign key(acc_no) references customer(acc_no) on delete cascade); 

insert into customer values (1000, "Fanny", 7000);
insert into customer values (1001, "Peter", 12000);
delimiter $$
create trigger update_cus
      before update on customer
      for each row
      begin
      insert into mini_statement values (old.acc_no, old.avail_balance);
      end $$
delimiter ;
update customer set avail_balance = avail_balance + 3000 where acc_no = 1001;
update customer set avail_balance = avail_balance + 3000 where acc_no = 1000; 

select *from mini_statement;

#2. After Update Trigger:
create table micro_statement (acc_no integer, 
                                  avail_balance decimal, 
            foreign key(acc_no) references customer(acc_no) on delete cascade); 
insert into customer values (1002, "Janitor", 4500);

delimiter //
create trigger update_after
        after update on customer
        for each row
       begin
       insert into micro_statement values(new.acc_no, new.avail_balance);
       end // 

delimiter ;

update customer set avail_balance = avail_balance + 1500 where acc_no = 1002; 
select *from micro_statement;

#3. Before Insert Trigger:
create table contacts (contact_id INT (11) NOT NULL AUTO_INCREMENT, 
                              last_name VARCHAR (30) NOT NULL, first_name VARCHAR (25),
                              birthday DATE, created_date DATE, 
                            created_by VARCHAR(30), 
                            CONSTRAINT contacts_pk PRIMARY KEY (contact_id));
delimiter //
create trigger contacts_before_insert
            before insert
            on contacts for each row
            begin
                DECLARE vUser varchar(50);
            select USER() into vUser;
                SET NEW.created_date = SYSDATE();
                SET NEW.created_by = vUser;
            end // 
delimiter ;
insert into contacts values (1, "Newton", "Enigma", 
                             str_to_date ("19-08-1999", "%d-%m-%Y"), 
                             str_to_date ("17-03-2018", "%d-%m-%Y"), "xyz"); 
select *from contacts;

#4. After Insert Trigger:
create table contacts (contact_id int (11) NOT NULL AUTO_INCREMENT, 
                              last_name VARCHAR(30) NOT NULL, 
                              first_name VARCHAR(25), birthday DATE,
                              CONSTRAINT contacts_pk PRIMARY KEY (contact_id));
create table contacts_audit (contact_id integer, 
                             created_date date, 
                             created_by varchar (30));
delimiter //
create trigger contacts_after_insert
			after insert
			 on contacts for each row
			  begin
			   DECLARE vUser varchar(50);
               SELECT USER() into vUser;
               INSERT into contacts_audit( contact_id,created_date,created_by) VALUES(NEW.contact_id, curdate(),vUser );
            END //                             
delimiter ;
insert into contacts values (1, "Kumar", "Rupesh", 
                         str_to_date("20-06-1999", "%d-%m-%Y")); 
select *from contacts_audit;
#5. Before Delete Trigger:
create table contacts (contact_id int (11) NOT NULL AUTO_INCREMENT, 
                             last_name VARCHAR (30) NOT NULL, first_name VARCHAR (25), 
                             birthday DATE, created_date DATE, created_by VARCHAR(30), 
                             CONSTRAINT contacts_pk PRIMARY KEY (contact_id));
create table contacts_audit (contact_id integer, deleted_date date, deleted_by varchar(20)); 

delimiter //
create trigger contacts_before_delete
            before delete
			on contacts for each row
			begin
			DECLARE vUser varchar(50);
			SELECT USER() into vUser;
			INSERT into contacts_audit
			( contact_id,
				deleted_date,
				deleted_by)
			VALUES
			( OLD.contact_id,
				SYSDATE(),
			vUser );
            end // 
delimiter ;
insert into contacts values (1, "Bond", "Ruskin", 
                             str_to_date ("19-08-1995", "%d-%m-%Y"), 
                             str_to_date ("27-04-2018", "%d-%m-%Y"), "xyz");
delete from contacts where last_name="Bond"; 

select *from contacts_audit;

#6. After Delete Trigger:
create table contacts (contact_id int (11) NOT NULL AUTO_INCREMENT, 
                            last_name VARCHAR (30) NOT NULL, first_name VARCHAR (25), 
                            birthday DATE, created_date DATE, created_by VARCHAR (30), 
                            CONSTRAINT contacts_pk PRIMARY KEY (contact_id));
create table contacts_audit (contact_id integer, deleted_date date, deleted_by varchar(20));

delimiter //
create trigger contacts_after_delete
		after delete
		on contacts for each row
		begin
			DECLARE vUser varchar(50);
			SELECT USER() into vUser;
			INSERT into contacts_audit
			( contact_id,
				deleted_date,
				deleted_by)
			VALUES
			( OLD.contact_id,
				SYSDATE(),
				vUser );
		end // 
delimiter ;
insert into contacts values (1, "Newton", "Isaac", 
                             str_to_date ("19-08-1985", "%d-%m-%Y"), 
                             str_to_date ("23-07-2018", "%d-%m-%Y"), "xyz");
delete from contacts where first_name="Isaac"; 

select *from contacts_audit;
