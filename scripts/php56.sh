#!/bin/bash
#
# Setup the the box. This runs as root

apt-get -y update
# You can install anything you need here.

# MySQL default username and password is "root"
echo "mysql-server-5.6 mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password root" | debconf-set-selections

apt-get -y install perl curl zip vim

# Load PHP5.6 repo
add-apt-repository ppa:ondrej/php -y

apt-get -y update

# Install Apache+php54 stack
apt-get -y install mysql-server-5.6 php5.6-mysql php5.6-curl php5.6-gd php5.6-imap php5.6-mbstring php5.6-bcmath php5.6-zip php5.6-xml libphp-pclzip php-pear php5.6 apache2 php5.6-curl php5.6-dev php5.6-xdebug php5.6-mcrypt

apt-get -y remove php7.0-cli

# Install and enable JSMIN extension
pecl install jsmin-1.1.0
echo "extension=jsmin.so" > /etc/php/5.6/mods-available/jsmin.ini
ln -s /etc/php/5.6/mods-available/jsmin.ini /etc/php/5.6/apache2/conf.d/20-jsmin.ini
ln -s /etc/php/5.6/mods-available/jsmin.ini /etc/php/5.6/cli/conf.d/20-jsmin.ini

# Update apache2 php.ini with appropriate Sugar values
sed -i 's/memory_limit =.*/memory_limit = 512M/' /etc/php/5.6//apache2/php.ini
sed -i 's/upload_max_filesize =.*/upload_max_filesize = 20M/' /etc/php/5.6/apache2/php.ini
sed -i 's/max_execution_time =.*/max_execution_time = 300/' /etc/php/5.6/apache2/php.ini
sed -i 's/;date.timezone =/date.timezone = UTC/' /etc/php/5.6/apache2/php.ini


# Suggested OPcache settings for Sugar
cat >> /etc/php/5.6/mods-available/opcache.ini <<DELIM
opcache.max_accelerated_files = 10000
opcache.memory_consumption = 256
opcache.fast_shutdown = 1
opcache.interned_strings_buffer = 16
DELIM


# Update cli php.ini for cron
sed -i 's/;date.timezone =/date.timezone = UTC/' /etc/php5/cli/php.ini

