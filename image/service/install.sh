#!/bin/bash -e
# this script is run during the image build

# mmc-agent config

sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/mmc/agent/config.ini

sed -i -e "s/login = mmc/login = $MMC_AGENT_LOGIN/" /etc/mmc/agent/config.ini
sed -i -e "s/password = s3cr3t/password = $MMC_AGENT_PASSWORD/" /etc/mmc/agent/config.ini

user mmc
group	mmc
umask 0007


# We have a custom config file 
if [ -e /osixia/mariadb/my.cnf ]; then

  rm /etc/mysql/my.cnf
  ln -s /osixia/mariadb/my.cnf /etc/mysql/my.cnf

else
  # Modify the default config file

  # Allow remote connection
  sed -ri 's/^(bind-address|skip-networking)/;\1/' /etc/mysql/my.cnf

  # Disable local files loading
  sed -i '/\[mysqld\]/a\local-infile=0' /etc/mysql/my.cnf

fi