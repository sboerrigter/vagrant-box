#
# Package manager
#
echo "Installing packages"
sudo apt-get update

# The following is "sudo apt-get -y upgrade" without any prompts
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

sudo apt-get install -y build-essential
sudo apt-get install -y tcl
sudo apt-get install -y software-properties-common
sudo apt-get install -y python-software-properties
sudo apt-get -y install vim
sudo apt-get -y install git
sudo apt-get install -y ifupdown

#
# Apache
#
echo "Installing Apache"
sudo add-apt-repository -y ppa:ondrej/apache2
sudo apt-get update
sudo apt-get -y install apache2

# Remove "html" and add public
mv /var/www/html /var/www/public

# Clean VHOST with full permissions
MY_WEB_CONFIG='<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/public
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
    <Directory "/var/www/public">
        Options Indexes FollowSymLinks
        AllowOverride all
        Require all granted
    </Directory>
</VirtualHost>'
echo "$MY_WEB_CONFIG" | sudo tee /etc/apache2/sites-available/000-default.conf

# Squash annoying FQDN warning
echo "ServerName scotchbox" | sudo tee /etc/apache2/conf-available/servername.conf
sudo a2enconf servername

# Enabled missing h5bp modules (https://github.com/h5bp/server-configs-apache)
sudo a2enmod expires
sudo a2enmod headers
sudo a2enmod include
sudo a2enmod rewrite

sudo service apache2 restart

#
# PHP
#
echo "Installing PHP"
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php7.2
sudo apt-get -y install libapache2-mod-php

# Add index.php to readable file types
MAKE_PHP_PRIORITY='<IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>'
echo "$MAKE_PHP_PRIORITY" | sudo tee /etc/apache2/mods-enabled/dir.conf

sudo service apache2 restart

# PHP modules
sudo apt-get -y install php7.2-common
sudo apt-get -y install php7.2-dev

# Common Useful Stuff (some of these are probably already installed)
sudo apt-get -y install php7.2-bcmath
sudo apt-get -y install php7.2-bz2
sudo apt-get -y install php7.2-cgi
sudo apt-get -y install php7.2-cli
sudo apt-get -y install php7.2-fpm
sudo apt-get -y install php7.2-gd
sudo apt-get -y install php7.2-imap
sudo apt-get -y install php7.2-intl
sudo apt-get -y install php7.2-json
sudo apt-get -y install php7.2-mbstring
sudo apt-get -y install php7.2-odbc
sudo apt-get -y install php-pear
sudo apt-get -y install php7.2-pspell
sudo apt-get -y install php7.2-tidy
sudo apt-get -y install php7.2-xmlrpc
sudo apt-get -y install php7.2-zip

# Enchant
sudo apt-get -y install libenchant-dev
sudo apt-get -y install php7.2-enchant

# LDAP
sudo apt-get -y install ldap-utils
sudo apt-get -y install php7.2-ldap

# CURL
sudo apt-get -y install curl
sudo apt-get -y install php7.2-curl

# IMAGE MAGIC
sudo apt-get -y install imagemagick
sudo apt-get -y install php7.2-imagick

#
# CUSTOM PHP SETTINGS
#
PHP_USER_INI_PATH=/etc/php/7.2/apache2/conf.d/user.in

echo 'display_startup_errors = On' | sudo tee -a $PHP_USER_INI_PATH
echo 'display_errors = On' | sudo tee -a $PHP_USER_INI_PATH
echo 'error_reporting = E_ALL' | sudo tee -a $PHP_USER_INI_PATH
echo 'short_open_tag = On' | sudo tee -a $PHP_USER_INI_PATH

sudo service apache2 restart

# Disable PHP Zend OPcache
echo 'opache.enable = 0' | sudo tee -a $PHP_USER_INI_PATH

# Absolutely Force Zend OPcache off...
sudo sed -i s,\;opcache.enable=0,opcache.enable=0,g /etc/php/7.2/apache2/php.in

sudo service apache2 restart

#
# PHPUnit
#
echo "Installing PHPUnit"
sudo wget https://phar.phpunit.de/phpunit-6.1.phar
sudo chmod +x phpunit-6.1.phar
sudo mv phpunit-6.1.phar /usr/local/bin/phpunit
sudo service apache2 restart

#
# MySQL
#
echo "Installing MySQL"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server
sudo mysqladmin -uroot -proot create scotchbox
sudo apt-get -y install php7.2-mysql
sudo service apache2 restart

#
# Composer
#
echo "Installing Composer"
EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")
php composer-setup.php --quiet
rm composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod 755 /usr/local/bin/composer

#
# WP-CLI
#
echo "Installing WP-CLI"
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

#
# Node.js
#
echo "Installing Node.js"
sudo apt-get -y install nodejs
sudo apt-get -y install npm

# Use NVM though to make life easy
wget -qO- https://raw.github.com/creationix/nvm/master/install.sh | bash
source ~/.nvm/nvm.sh
nvm install 8.9.4

# Node Packages
sudo npm install -g gulp
sudo npm install -g grunt
sudo npm install -g bower
sudo npm install -g yo
sudo npm install -g browser-sync
sudo npm install -g browserify
sudo npm install -g pm2
sudo npm install -g webpack

#
# Ruby
#
echo "Installing Ruby"
sudo apt-get -y install ruby
sudo apt-get -y install ruby-dev

# Use RVM though to make life easy
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.5.0
rvm use 2.5.0

#
# Finish installation
#
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo service apache2 restart

# Disable welcome message
sudo chmod -x /etc/update-motd.d/*

echo "Installation complete"
