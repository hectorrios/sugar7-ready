#!/bin/bash
#
# Setup the the box. This runs as root

apt-get -y update
# You can install anything you need here.

# MySQL default username and password is "root"
echo "mysql-server-5.5 mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again password root" | debconf-set-selections

apt-get -y install python-software-properties

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/1.4/debian stable main" | tee -a /etc/apt/sources.list

#PHP 5.3.25+ libs
add-apt-repository ppa:sergey-dryabzhinsky/packages -y
add-apt-repository ppa:sergey-dryabzhinsky/php53 -y
add-apt-repository ppa:webupd8team/java -y

apt-get -y update

apt-get -y install perl curl unzip vim apache2 mysql-server php53-apache2 php53-cli php53-mod-imap php53-mod-mysql php53-mod-curl php53-mod-gd php53-mod-bcmath php53-pecl
a2enmod php53

# Load Java and Elasticsearch repos

# Auto-accept oracle license
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
#Install Java 8, elasticsearch 1.4, then run it as a service
apt-get -y install oracle-java8-installer
apt-get -y install elasticsearch
echo "Setting up Elasticsearch as a service"
update-rc.d elasticsearch defaults 95 10

# Update apache2 php.ini
sed -i 's/memory_limit = 128M/memory_limit = 512M/' /etc/php5/apache2/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/' /etc/php5/apache2/php.ini
sed -i 's/;date.timezone =/date.timezone = UTC/' /etc/php5/apache2/php.ini

# Update cli php.ini for cron
sed -i 's/;date.timezone =/date.timezone = UTC/' /etc/php5/cli/php.ini




