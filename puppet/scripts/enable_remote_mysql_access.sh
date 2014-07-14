#!/bin/bash

mysql -uroot < "/vagrant/puppet/scripts/enable_remote_mysql_access.sql"
sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf
sudo service mysql restart
sudo -i
echo 'Defaults secure_path = "/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/node/node-default/bin"' >> /etc/sudoers