#!/bin/bash -e

dpkg -i /container/service-available/mmc-ppolicy/assets/package/python-mmc-ppolicy_3.1.1-3_all.deb
rm -rf /container/service-available/mmc-ppolicy/assets/package/

# change default plugin configuration
sed -i --follow-symlinks -e "s/#*\s*disable\s*=.*/disable = 0/" /etc/mmc/plugins/ppolicy.ini
sed -i --follow-symlinks -e "s/#*\s*pwdCheckQuality\s*=.*/pwdCheckQuality = 0/" /etc/mmc/plugins/ppolicy.ini
sed -i --follow-symlinks -e "s/#*\s*pwdAttribute\s*=.*/pwdAttribute = 1.3.6.1.4.1.1466.115.121.1.38/" /etc/mmc/plugins/ppolicy.ini
