#!/bin/bash -e
# this script is run during the image build

# mmc-agent config
sed -i -e "s/#*\s*host\s*=.*/host = 0.0.0.0/" /etc/mmc/agent/config.ini

# Error adding ldap user with mmc user and group :'( 
#sed -i -e "s/#*\s*user\s*=.*/user = mmc/" /etc/mmc/agent/config.ini
#sed -i -e "s/#*\s*group\s*=.*/group = mmc/" /etc/mmc/agent/config.ini
#sed -i -e "s/#*\s*umask\s*=.*/umask = 0007/" /etc/mmc/agent/config.ini

#mkdir -p /home/archives /var/log/mmc/
#chown mmc:mmc -R /home/archives /var/log/mmc/