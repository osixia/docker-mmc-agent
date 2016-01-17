#!/bin/bash -e

FIRST_START_DONE="/etc/docker-mmc-agent-sshlpk-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

   # sshlpk plugin configuration
   /container/service/mmc-agent/assets/config-plugin.sh "$MMC_AGENT_SSHLPK_PLUGIN_CONFIG" /etc/mmc/plugins/sshlpk.ini

  touch $FIRST_START_DONE
fi

exit 0
