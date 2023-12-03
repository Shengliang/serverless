create user 'test'@'localhost' identified by 'rivos';
grant all on *.* to 'test'@'localhost';
flush privileges;

create user 'ssl'@'%' identified by 'rivos';
grant all on *.* to 'ssl'@'%';
grant all on sbtest1kx1m.* to 'ssl'@'%';
flush privileges;
