drop table if exists users;
create table users (id integer not null primary key, username text, password text);
insert into users values (1, 'admin', '$2a$10$Krux7MEZWVvhI/8lZHAXeOsMdd9e/ndhOECU6CqCc/7V.6VMp5lam');

