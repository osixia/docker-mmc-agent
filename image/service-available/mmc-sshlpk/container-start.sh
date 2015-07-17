#!/bin/bash -e

FIRST_START_DONE="/etc/docker-mmc-agent-sshlpk-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

   # sshlpk plugin configuration
  /osixia/mmc-agent/config-plugin.sh "$MMC_SSHLPK_PLUGIN" /etc/mmc/plugins/sshlpk.ini

  touch $FIRST_START_DONE
fi

exit 0