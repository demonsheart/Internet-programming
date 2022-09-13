use middle_ex1;
create table banner(
   id int primary key auto_increment,
   link varchar(200) not null,
   type varchar(50) not null,
   file longblob
);