#! /bin/bash
# Automate ECommerce Application Deployment
# Author: Apurva Tejani 
# Amature Shell Script 


sudo yum install -y firewalld
sleep 5
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo systemctl status firewalld
STATUS=$(sudo systemctl status firewalld)
 if  echo $STATUS | grep -q "active (running)";
 then
     echo "Firewall Running"
 else
     echo "FireWall not running... exiting"
     exit 1
 fi
sudo yum install -y mariadb-server
#sudo vi /etc/my.cnf
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl status mariadb.service
STATUS=$(sudo systemctl status mariadb.service)
 if  echo $STATUS | grep -q "active (running)";
 then
     echo "DB service is Running"
 else
     echo "DB service not running.... exiting"
     exit 1
 fi
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload
PORT=$(sudo firewall-cmd --list-all)
if echo $PORT | grep -q "ports: 3306/tcp";
then
   echo "port established"
else
   echo "firewall port not added to DB server"
   exit 1
fi
cat > db-create-script.sql <<-EOF
CREATE DATABASE ecomdb;
CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
FLUSH PRIVILEGES;
EOF
sudo mysql < db-create-script.sql
sleep 2
cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");

EOF
sudo mysql < db-load-script.sql
sleep 2
sudo yum install -y httpd php php-mysqlnd
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload
PORT=$(sudo firewall-cmd --list-all)
if echo $PORT | grep -q "ports: 3306/tcp 80/tcp";
then
   echo "port established"
else
   echo "firewall port not added to httpd server"
   exit 1
fi
sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd
STATUS=$(sudo systemctl status httpd)
 if  echo $STATUS | grep -q "active (running)";
 then
     echo "httpd service is Running"
 else
     echo "httpd service not running.... exiting"
     exit 1
 fi
sudo yum install -y git
sudo git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php
curl http://localhost