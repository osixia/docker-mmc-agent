#!/bin/bash -e

dpkg -i /container/service-available/mmc-mail/assets/package/python-mmc-mail_2.5.1-1_all.deb
rm -rf /container/service-available/mmc-mail/assets/package/

# change default plugin configuration
sed -i -e "s/#*\s*disable\s*=.*/disable = 0/" /etc/mmc/plugins/mail.ini
sed -i -e "s/#*\s*vDomainSupport\s*=.*/vDomainSupport = 1/" /etc/mmc/plugins/mail.ini
sed -i -e "s/#*\s*vAliasesSupport\s*=.*/vAliasesSupport = 1/" /etc/mmc/plugins/mail.ini
