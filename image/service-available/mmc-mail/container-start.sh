#!/bin/bash -e

FIRST_START_DONE="/etc/docker-mmc-agent-mail-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  # mail plugin configuration
  /osixia/service/mmc-agent/assets/config-plugin.sh "$MMC_MAIL_PLUGIN" /etc/mmc/plugins/mail.ini

  touch $FIRST_START_DONE
fi

exit 0
