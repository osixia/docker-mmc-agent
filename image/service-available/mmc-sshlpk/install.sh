#!/bin/bash -e

dpkg -i /osixia/service-available/mmc-sshlpk/package/python-mmc-sshlpk_2.5.1-1_all.deb
rm -rf /osixia/service-available/mmc-sshlpk/package/

# change default plugin configuration
sed -i -e "s/#*\s*disable\s*=.*/disable = 0/" /etc/mmc/plugins/sshlpk.ini
