# Vagrant box

Custom Vagrant box to host multiple websites locally. Based on [Scotch Box build Scripts](https://github.com/scotch-io/scotch-box-build-scripts) and optimised for WordPress development.

### What's in the box?

- Ubuntu 16.4
- Apache 2
- MySQL 5.7
- PHP 7.3
- Composer
- WP CLI
- Node.js, NPM & NVM
- Ruby, Bundler & RVM

## Installation

1. Install the latest version of [Vagrant](https://www.vagrantup.com/downloads.html).
2. Install the latest version [VirualBox](https://www.virtualbox.org/wiki/Downloads).
3. Navigate to your websites folder. For example: `cd ~/Sites`.
4. Run the following commands:

```bash
git clone https://github.com/sboerrigter/vagrant-box
cd vagrant-box
vagrant up
```
5. Sit back and wait while the install script runs.

## Usage

Next time you want to start Vagrant you can use the following commands:

```bash
cd ~/Sites/vagrant-box
ssh-add
vagrant up
```

You can SSH into your box using:

```
vagrant ssh
```

**Pro tip**: Add the following to your `~/.bash_profile` file so you can use `vu` to start vagrant and SSH into it:

```
alias vu="cd ~/sites/vagrant-box && ssh-add && vagrant up && vagrant ssh"
```

## Add a website

To add a new website to the Vagrant box you need to follow the following steps:

1. Add the website files to your websites folder (for example in: `~/sites/project`).
2. Open your host file (via `sudo nano /etc/hosts`) and add the following line:

`192.168.33.10 www.project.test project.test`

3. Copy `~/Sites/vagrant-box/sites-enabled/example.conf` to `~/sites/vagrant-box/sites-enabled/project.conf` and set the correct DocumentRoot, ServerName and ServerAlias.
4. SSH into your Vagrant box and run `sudo service apache2 restart`.
5. Go to http://www.project.test to view your website.

## MySQL databases

You can use an application like Sequel Pro to connect to the MySQL databases with the following credentials:

```
MySQL host: 192.168.33.10
MySQL user: root
MySQL pass: root

SSH host: 192.168.33.10
SSH user: vagrant
SSH pass: vagrant
```