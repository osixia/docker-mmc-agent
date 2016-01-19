#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x


FIRST_START_DONE="${CONTAINER_STATE_DIR}/docker-mmc-agent-sshlpk-first-start-done"
# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

   # sshlpk plugin configuration
   ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/config-plugin.sh "$MMC_AGENT_SSHLPK_PLUGIN_CONFIG" /etc/mmc/plugins/sshlpk.ini
   cp -f /etc/mmc/plugins/sshlpk.ini ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/sshlpk.ini

  touch $FIRST_START_DONE
fi

ln -sf ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/sshlpk.ini /etc/mmc/plugins/sshlpk.ini

exit 0
