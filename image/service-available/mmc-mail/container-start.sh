#!/bin/bash -e

FIRST_START_DONE="/etc/docker-mmc-agent-mail-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  # mail plugin configuration
  /container/service/mmc-agent/assets/config-plugin.sh "$MMC_AGENT_MAIL_PLUGIN_CONFIG" /etc/mmc/plugins/mail.ini

  touch $FIRST_START_DONE
fi

exit 0
