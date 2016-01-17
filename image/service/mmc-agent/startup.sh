#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x


FIRST_START_DONE="${CONTAINER_STATE_DIR}/docker-mmc-agent-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  # SSL config
  if [ "${MMC_AGENT_HTTPS,,}" == "true" ]; then

    echo "Use ssl"
    sed -i --follow-symlinks -e "s|#*\s*enablessl\s*=.*|enablessl = 1|" /etc/mmc/agent/config.ini

    # check certificat and key or create it
    cfssl-helper mmcagent "${CONTAINER_SERVICE_DIR}/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_CRT_FILENAME" "${CONTAINER_SERVICE_DIR}/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_KEY_FILENAME" "${CONTAINER_SERVICE_DIR}/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_CA_CRT_FILENAME"

    # verify peer ?
    if [ "${MMC_AGENT_HTTPS_VERIFY_PEER,,}" == "true" ]; then

      echo "Verify peer"
      sed -i --follow-symlinks -e "s|#*\s*verifypeer\s*=.*|verifypeer = 1|" /etc/mmc/agent/config.ini

      # mmc agent need a pem file with the crt and the key
      cat ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_CRT_FILENAME ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_KEY_FILENAME > ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/certs/mmc.pem

      sed -i --follow-symlinks -e "s|#*\s*localcert\s*=.*|localcert = ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/certs/mmc.pem|" /etc/mmc/agent/config.ini
      sed -i --follow-symlinks -e "s|#*\s*cacert\s*=.*|cacert = ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_CA_CRT_FILENAME|" /etc/mmc/agent/config.ini

    else

      echo "Don't verify peer"
      sed -i --follow-symlinks -e "s|#*\s*verifypeer\s*=.*|verifypeer = 0|" /etc/mmc/agent/config.ini

      sed -i --follow-symlinks -e "s|#*\s*localcert\s*=.*|localcert = ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_KEY_FILENAME|" /etc/mmc/agent/config.ini
      sed -i --follow-symlinks -e "s|#*\s*cacert\s*=.*|cacert = ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_CRT_FILENAME|" /etc/mmc/agent/config.ini

    fi

  else
    # disable ssl
    sed -i --follow-symlinks -e "s|#*\s*enablessl\s*=.*|enablessl = 0|" /etc/mmc/agent/config.ini
  fi

  # mmc agent config
  ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/config-plugin.sh "$MMC_AGENT_CONFIG" /etc/mmc/agent/config.ini

  # base plugin configuration
  ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/config-plugin.sh "$MMC_AGENT_BASE_PLUGIN_CONFIG" /etc/mmc/plugins/base.ini

  touch $FIRST_START_DONE
fi

exit 0
