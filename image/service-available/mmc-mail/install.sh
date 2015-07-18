#!/bin/bash -e

dpkg -i /osixia/service-available/mmc-mail/package/python-mmc-mail_2.5.1-1_all.deb
rm -rf /osixia/service-available/mmc-mail/package/

# change default plugin configuration
sed -i -e "s/#*\s*disable\s*=.*/disable = 0/" /etc/mmc/plugins/mail.ini
sed -i -e "s/#*\s*vDomainSupport\s*=.*/vDomainSupport = 1/" /etc/mmc/plugins/mail.ini
sed -i -e "s/#*\s*vAliasesSupport\s*=.*/vAliasesSupport = 1/" /etc/mmc/plugins/mail.ini

echo "[userdefault]" >> /etc/mmc/plugins/mail.ini
echo "mailbox = /home/vmail/%uid%/" >> /etc/mmc/plugins/mail.ini
