#!/bin/bash -e
# this script is run during the image build

dpkg -i /container/service/mmc-agent/assets/package/python-mmc-core_3.1.1-3_all.deb
dpkg -i /container/service/mmc-agent/assets/package/python-mmc-base_3.1.1-3_all.deb
dpkg -i /container/service/mmc-agent/assets/package/python-mmc-dashboard_3.1.1-3_all.deb
dpkg -i /container/service/mmc-agent/assets/package/mmc-agent_3.1.1-3_all.deb

rm -rf /container/service/mmc-agent/assets/package

# mmc-agent config
sed -i --follow-symlinks -e "s/#*\s*host\s*=.*/host = 0.0.0.0/" /etc/mmc/agent/config.ini

mkdir -p /home/archives /var/log/mmc/
