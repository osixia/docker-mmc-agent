#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x


FIRST_START_DONE="${CONTAINER_STATE_DIR}/docker-mmc-agent-mail-first-start-done"
# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  # mail plugin configuration
  ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/config-plugin.sh "MMC_AGENT_MAIL_PLUGIN_CONFIG" /etc/mmc/plugins/mail.ini
  cp -f /etc/mmc/plugins/mail.ini ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/mail.ini

  touch $FIRST_START_DONE
fi

ln -sf ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/mail.ini /etc/mmc/plugins/mail.ini

exit 0
