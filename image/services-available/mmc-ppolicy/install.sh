#!/bin/bash -e

# install php
LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python-mmc-ppolicy

sed -i -e "s/#*\s*disable\s*=.*/disable = 0/" /etc/mmc/plugins/ppolicy.ini
sed -i -e "s/#*\s*pwdCheckQuality\s*=.*/pwdCheckQuality = 0/" /etc/mmc/plugins/ppolicy.ini