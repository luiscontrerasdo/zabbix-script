# Zabbix Scripts

Here you have 3 Zabbix installation scripts for: 5.0 LTS, 5.4 and 6.0 LTS

These scripts have tested on Rocky Linux Rocky Linux release 8.5 (Green Obsidian), so it should work on:

* CentOS 8 Stream
* Red Hat Linux 8
* Alma Linux 8
* and Oracle Linux 8

Important to know, these scripts have been created in order to install and use MariaDB 10.7. 
You will need to run mariadb-secure-installation after the installation in order to secure your root user on MariaDB.
For the **zabbix_server.conf** file, we are using *zabbix* as default password at **DBPassword** parameter, please use strong paswords.




