#!/bin/bash -e

LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends python-mmc-sshlpk

# change default plugin configuration
sed -i -e "s/#*\s*disable\s*=.*/disable = 0/" /etc/mmc/plugins/sshlpk.ini