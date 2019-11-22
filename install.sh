# Package manager
export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get install -y build-essential
sudo apt-get install -y git
sudo apt-get install -y gnupg2
sudo apt-get install -y ifupdown
sudo apt-get install -y python-software-properties
sudo apt-get install -y software-properties-common
sudo apt-get install -y tcl
sudo apt-get install -y vim

# Apache
sudo add-apt-repository -y ppa:ondrej/apache2
sudo apt-get update
sudo apt-get install -y apache2
sudo a2enconf servername
sudo a2enmod expires
sudo a2enmod headers
sudo a2enmod include
sudo a2enmod rewrite

echo '<Directory "/var/www">
    AllowOverride All
</Directory>' | sudo tee /etc/apache2/conf-enabled/override.conf

echo 'ServerName vagrant' | sudo tee /etc/apache2/conf-available/servername.conf

sudo service apache2 restart

# PHP
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php7.4
sudo apt-get install -y libapache2-mod-php
sudo apt-get install -y curl
sudo apt-get install -y imagemagick
sudo apt-get install -y ldap-utils
sudo apt-get install -y libenchant-dev
sudo apt-get install -y php-pear
sudo apt-get install -y php7.4-bcmath
sudo apt-get install -y php7.4-bz2
sudo apt-get install -y php7.4-cgi
sudo apt-get install -y php7.4-cli
sudo apt-get install -y php7.4-common
sudo apt-get install -y php7.4-curl
sudo apt-get install -y php7.4-dev
sudo apt-get install -y php7.4-enchant
sudo apt-get install -y php7.4-fpm
sudo apt-get install -y php7.4-gd
sudo apt-get install -y php7.4-imagick
sudo apt-get install -y php7.4-imap
sudo apt-get install -y php7.4-intl
sudo apt-get install -y php7.4-json
sudo apt-get install -y php7.4-ldap
sudo apt-get install -y php7.4-mbstring
sudo apt-get install -y php7.4-odbc
sudo apt-get install -y php7.4-pspell
sudo apt-get install -y php7.4-tidy
sudo apt-get install -y php7.4-xmlrpc
sudo apt-get install -y php7.4-zip

echo '<IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>' | sudo tee /etc/apache2/mods-enabled/dir.conf

echo 'display_errors = On
display_startup_errors = On
error_reporting = E_ALL
post_max_size = 1024M
short_open_tag = On
upload_max_filesize = 1024M
opache.enable = 0' | sudo tee /etc/php/7.3/apache2/php.ini

sudo service apache2 restart

# MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install -y mysql-server
sudo apt-get install -y php7.4-mysql

echo '[mysql]
default-character-set = utf8mb4' | sudo tee /etc/mysql/conf.d/mysql

sudo service apache2 restart

# Composer
EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")
php composer-setup.php --quiet
rm composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod 755 /usr/local/bin/composer

# WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
sudo chmod +x /usr/local/bin/wp

# Node.js, NPM & NVM
sudo apt-get install -y nodejs
sudo apt-get install -y npm
wget -qO- https://raw.github.com/creationix/nvm/master/install.sh | bash
source ~/.nvm/nvm.sh
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g gulp

# Ruby, Bundler & RVM
sudo apt-get install -y ruby
sudo apt-get install -y ruby-dev
gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.6.5
rvm use 2.6.5
gem install bundler

# Finish installation
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo service apache2 restart
