#!/bin/bash -e

FIRST_START_DONE="/etc/docker-mmc-agent-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  # SSL config
  if [ "${MMC_AGENT_HTTPS,,}" == "true" ]; then

    echo "Use ssl"
    sed -i -e "s|#*\s*enablessl\s*=.*|enablessl = 1|" /etc/mmc/agent/config.ini

    # check certificat and key or create it
    /sbin/ssl-helper "/container/service/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_CRT_FILENAME" "/container/service/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_KEY_FILENAME" --ca-crt=/container/service/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_CA_CRT_FILENAME

    # verify peer ?
    if [ "${MMC_AGENT_HTTPS_VERIFY_PEER,,}" == "true" ]; then

      echo "Verify peer"
      sed -i -e "s|#*\s*verifypeer\s*=.*|verifypeer = 1|" /etc/mmc/agent/config.ini

      # mmc agent need a pem file with the crt and the key
      cat /container/service/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_CRT_FILENAME /container/service/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_KEY_FILENAME > /container/service/mmc-agent/assets/certs/mmc.pem

      sed -i -e "s|#*\s*localcert\s*=.*|localcert = /container/service/mmc-agent/assets/certs/mmc.pem|" /etc/mmc/agent/config.ini
      sed -i -e "s|#*\s*cacert\s*=.*|cacert = /container/service/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_CA_CRT_FILENAME|" /etc/mmc/agent/config.ini

    else

      echo "Don't verify peer"
      sed -i -e "s|#*\s*verifypeer\s*=.*|verifypeer = 0|" /etc/mmc/agent/config.ini

      sed -i -e "s|#*\s*localcert\s*=.*|localcert = /container/service/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_KEY_FILENAME|" /etc/mmc/agent/config.ini
      sed -i -e "s|#*\s*cacert\s*=.*|cacert = /container/service/mmc-agent/assets/certs/$MMC_AGENT_HTTPS_CRT_FILENAME|" /etc/mmc/agent/config.ini

    fi

  else
    # disable ssl
    sed -i -e "s|#*\s*enablessl\s*=.*|enablessl = 0|" /etc/mmc/agent/config.ini
  fi

  # ldap tls config
  LDAP_VERIFY_PEER=$(/container/service/mmc-agent/assets/get-config.sh "$MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap ldapverifypeer")
  LDAP_CA_CERT=$(/container/service/mmc-agent/assets/get-config.sh "$MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap cacert")
  LDAP_CLIENT_CERT=$(/container/service/mmc-agent/assets/get-config.sh "$MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap localcert")
  LDAP_CLIENT_KEY=$(/container/service/mmc-agent/assets/get-config.sh "$MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap localkey")

  if [ ! -z "$LDAP_CA_CERT" ] && [ ! -z "$LDAP_CLIENT_CERT" ] && [ ! -z "$LDAP_CLIENT_KEY" ]; then
    # check certificat and key or create it
    /sbin/ssl-helper "$LDAP_CLIENT_CERT" "$LDAP_CLIENT_KEY" --ca-crt=$LDAP_CA_CERT --gnutls

    # ldap client config
    sed -i "s,TLS_CACERT.*,TLS_CACERT ${LDAP_CA_CERT},g" /etc/ldap/ldap.conf

    if [ ! -z "$LDAP_VERIFY_PEER" ]; then
      echo "TLS_REQCERT $LDAP_VERIFY_PEER" >> /etc/ldap/ldap.conf
    fi

    [[ -f "$HOME/.ldaprc" ]] && rm -f $HOME/.ldaprc
    touch $HOME/.ldaprc

    echo "TLS_CERT ${LDAP_CLIENT_CERT}" >> $HOME/.ldaprc
    echo "TLS_KEY ${LDAP_CLIENT_KEY}" >> $HOME/.ldaprc

  fi

  # mmc agent config
  /container/service/mmc-agent/assets/config-plugin.sh "$MMC_AGENT_CONFIG" /etc/mmc/agent/config.ini

  # base plugin configuration
  /container/service/mmc-agent/assets/config-plugin.sh "$MMC_AGENT_BASE_PLUGIN_CONFIG" /etc/mmc/plugins/base.ini

  touch $FIRST_START_DONE
fi

exit 0
