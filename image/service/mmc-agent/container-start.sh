#!/bin/bash -e

FIRST_START_DONE="/etc/docker-mmc-agent-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  # mmc-agent login informations
  sed -i -e "s|#*\s*login\s*=.*|login = $MMC_AGENT_LOGIN|" /etc/mmc/agent/config.ini

  # all the passwords contained in MMC-related configuration files can be obfuscated using a base64 encoding.
  # this is not a security feature, but at least somebody won’t be able to read accidentally a password.
  PWD_BASE64=$(python -c 'print "'$MMC_AGENT_PASSWORD'".encode("base64")')
  sed -i -e "s|#*\s*password\s*=.*|password = {base64}$PWD_BASE64|" /etc/mmc/agent/config.ini

  # SSL config
  if [ "${USE_SSL,,}" == "true" ]; then

    sed -i -e "s|#*\s*enablessl\s*=.*|enablessl = 1|" /etc/mmc/agent/config.ini

    # check certificat and key or create it
    /sbin/ssl-kit "/osixia/mmc-agent/ssl/$SSL_CRT_FILENAME" "/osixia/mmc-agent/ssl/$SSL_KEY_FILENAME" --ca-crt=/osixia/mmc-agent/ssl/$SSL_CA_CRT_FILENAME

    # verify peer ?
    if [ "${SSL_VERIFY_PEER,,}" == "true" ]; then
      sed -i -e "s|#*\s*verifypeer\s*=.*|verifypeer = 1|" /etc/mmc/agent/config.ini

      # mmc agent need a pem file with the crt and the key
      cat /osixia/mmc-agent/ssl/$SSL_CRT_FILENAME /osixia/mmc-agent/ssl/$SSL_KEY_FILENAME > /osixia/mmc-agent/ssl/mmc.pem

      sed -i -e "s|#*\s*localcert\s*=.*|localcert = /osixia/mmc-agent/ssl/mmc.pem|" /etc/mmc/agent/config.ini
      sed -i -e "s|#*\s*cacert\s*=.*|cacert = /osixia/mmc-agent/ssl/$SSL_CA_CRT_FILENAME|" /etc/mmc/agent/config.ini


    else
      sed -i -e "s|#*\s*verifypeer\s*=.*|verifypeer = 0|" /etc/mmc/agent/config.ini

      sed -i -e "s|#*\s*localcert\s*=.*|localcert = /osixia/mmc-agent/ssl/$SSL_KEY_FILENAME|" /etc/mmc/agent/config.ini
      sed -i -e "s|#*\s*cacert\s*=.*|cacert = /osixia/mmc-agent/ssl/$SSL_CRT_FILENAME|" /etc/mmc/agent/config.ini
    fi

    chown mmc:mmc -R /osixia/mmc-agent/ssl

  else
    # disable ssl
    sed -i -e "s|#*\s*enablessl\s*=.*|enablessl = 0|" /etc/mmc/agent/config.ini
  fi

  # base plugin configuration
  /osixia/mmc-agent/config-plugin.sh "$MMC_BASE_PLUGIN" /etc/mmc/plugins/base.ini

  touch $FIRST_START_DONE
fi

exit 0