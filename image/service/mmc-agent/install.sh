#!/bin/bash -e
# this script is run during the image build

dpkg -i /osixia/service/mmc-agent/assets/package/python-mmc-core_3.1.1-3_all.deb
dpkg -i /osixia/service/mmc-agent/assets/package/python-mmc-base_3.1.1-3_all.deb
dpkg -i /osixia/service/mmc-agent/assets/package/python-mmc-dashboard_3.1.1-3_all.deb
dpkg -i /osixia/service/mmc-agent/assets/package/mmc-agent_3.1.1-3_all.deb

rm -rf /osixia/service/mmc-agent/assets/package

# mmc-agent config
sed -i -e "s/#*\s*host\s*=.*/host = 0.0.0.0/" /etc/mmc/agent/config.ini

# Error adding ldap user with mmc user and group :'(
#sed -i -e "s/#*\s*user\s*=.*/user = mmc/" /etc/mmc/agent/config.ini
#sed -i -e "s/#*\s*group\s*=.*/group = mmc/" /etc/mmc/agent/config.ini
#sed -i -e "s/#*\s*umask\s*=.*/umask = 0007/" /etc/mmc/agent/config.ini

mkdir -p /home/archives /var/log/mmc/
#chown mmc:mmc -R /home/archives /var/log/mmc/
