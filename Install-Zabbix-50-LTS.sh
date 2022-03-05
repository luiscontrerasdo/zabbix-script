#!/bin/bash -x

# Simple script for installing Zabbix 5.0 LTS
# Created by: Luis Contreras


# Let's do some dnf stuff here

dnf clean all
dnf update -y
dnf upgrade -y
dnf install -y epel-release

# Using MariaDB 10.5 so in the future you need to upgrade your Zabbix, you won't need to upgrade database as well
# Let's add MariaDB repository

cat << EOF >> /etc/yum.repos.d/MariaDB.repo
# MariaDB 10.5 CentOS repository list - created 2022-03-04 15:05 UTC
# https://mariadb.org/download/
[mariadb]
name = MariaDB
baseurl = https://ftp.osuosl.org/pub/mariadb/yum/10.5/centos8-amd64
module_hotfixes=1
gpgkey=https://ftp.osuosl.org/pub/mariadb/yum/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

# Let's install MariaDB 10.5

dnf update -y
dnf install -y MariaDB-server

# Enable and start MariaDB serivce

systemctl enable mariadb
systemctl start mariadb

# Addning Zabbix repository

rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
dnf clean all

# Let's install Zabbix components

dnf install -y zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-agent

# Let's create database and grant access to user

mysql -e 'create database zabbix character set utf8 collate utf8_bin;'
mysql -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"


# Now let's create schema

zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -pzabbix zabbix

# Remember to enable DBPassword parameter and assing yours, here I used zabbix as password

sed -i 's/# DBPassword=/DBPassword=zabbix/g'  /etc/zabbix/zabbix_server.conf

# Let's configure Timezone

sed -i 's/Europe/America/g' /etc/php-fpm.d/zabbix.conf

sed -i 's/Riga/Santo_Domingo/g' /etc/php-fpm.d/zabbix.conf

sed -i 's/; php_value\[date.timezone\]/php_value\[date.timezone\]/g' /etc/php-fpm.d/zabbix.conf

# Ending by restating and enabling services

systemctl restart zabbix-server zabbix-agent httpd php-fpm
systemctl enable zabbix-server zabbix-agent httpd php-fpm
