#!/bin/bash -e

LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends python-mmc-mail

# change default plugin configuration
sed -i -e "s/#*\s*disable\s*=.*/disable = 0/" /etc/mmc/plugins/mail.ini
sed -i -e "s/#*\s*vDomainSupport\s*=.*/vDomainSupport = 1/" /etc/mmc/plugins/mail.ini
sed -i -e "s/#*\s*vAliasesSupport\s*=.*/vAliasesSupport = 1/" /etc/mmc/plugins/mail.ini

echo "[userdefault]" >> /etc/mmc/plugins/mail.ini
echo "mailbox = /home/vmail/%uid%/" >> /etc/mmc/plugins/mail.ini