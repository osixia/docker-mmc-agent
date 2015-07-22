#!/bin/bash -e

dpkg -i /osixia/service/mmc-ppolicy/assets/package/python-mmc-ppolicy_3.1.1-3_all.deb
rm -rf /osixia/service/mmc-ppolicy/assets/package/

# change default plugin configuration
sed -i -e "s/#*\s*disable\s*=.*/disable = 0/" /etc/mmc/plugins/ppolicy.ini
sed -i -e "s/#*\s*pwdCheckQuality\s*=.*/pwdCheckQuality = 0/" /etc/mmc/plugins/ppolicy.ini
sed -i -e "s/#*\s*pwdAttribute\s*=.*/pwdAttribute = 1.3.6.1.4.1.1466.115.121.1.38/" /etc/mmc/plugins/ppolicy.ini
