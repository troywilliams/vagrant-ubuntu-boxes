#!/usr/bin/env bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1;
fi

PROJECT=$1;

# Download and Install the Latest Updates for the OS.
apt-get update && apt-get upgrade -y

# Install Apache2.
apt-get install -y apache2

# Create project directory in vagrant if doesn't exist.
if ! [ -d "/vagrant/${PROJECT}" ]
  then
    mkdir "/vagrant/${PROJECT}"
fi

# Link project directory to web directory.
if ! [ -L "/var/www/html/${PROJECT}" ]; then
  rm -rf "/var/www/html/${PROJECT}"
  ln -fs "/vagrant/${PROJECT}" "/var/www/html/${PROJECT}"
fi

# Install PHP and base required modules.
apt-get -y install php5 \
                   php5-cli \
                   php-pear \
                   php5-curl \
                   php5-xmlrpc \
                   php5-gd \
                   php5-intl \
                   php5-json \
                   php5-mcrypt \
                   php5-dev
# PHP Profiling
pecl install -f xhprof
# Setup xhprof file.
XHPROF=$(cat <<EOF
extension=xhprof.so
xhprof.output_dir="/var/tmp/xhprof"
EOF
)
echo "${XHPROF}" > /etc/php5/mods-available/xhprof.ini
php5enmod xhprof
apt-get -y install graphviz

# Setup Apache vhost file.
VHOST=$(cat <<EOF
<VirtualHost *:80>
    php_value date.timezone "Pacific/Auckland"
    php_value post_max_size 101M
    php_value upload_max_filesize 100M

    DocumentRoot "/var/www/html/${PROJECT}"
    <Directory "/var/www/html/${PROJECT}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

service apache2 restart

# Install MySQL 5.6.
echo "mysql-server-5.6 mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password root" | debconf-set-selections
apt-get install -y mysql-server-5.6 \
                   php5-mysql

# Install Git.
sudo apt-get -y install git

# Install Composer.
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Install Node.
sudo apt-get -y install nodejs
sudo apt-get -y install npm

sudo service apache2 reload

# Clean up.
apt-get autoclean && apt-get clean
# Exit success.
exit 0

