# serverless

1. create t2.micro EC2

2. install mysqld
https://ubuntu.com/server/docs/databases-mysql
https://dev.mysql.com/doc/refman/8.2/en/linux-installation-yum-repo.html

https://medium.com/@rohan_precise/step-by-step-guide-setting-up-and-connecting-mysql-on-ec2-ubuntu-instance-72c627e6c27f
 - sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
 - change bind-address = 127.0.0.1
   to bind-address = 0.0.0.0

3. run sysbench at local
