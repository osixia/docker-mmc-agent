#!/bin/bash -e

FIRST_START_DONE="/etc/docker-ldap-client-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  # ldap tls config
  LDAP_VERIFY_PEER=$(/container/service/mmc-agent/assets/get-config.sh "$MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap ldapverifypeer")
  LDAP_CA_CERT=$(/container/service/mmc-agent/assets/get-config.sh "$MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap cacert")
  LDAP_CLIENT_CERT=$(/container/service/mmc-agent/assets/get-config.sh "$MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap localcert")
  LDAP_CLIENT_KEY=$(/container/service/mmc-agent/assets/get-config.sh "$MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap localkey")

  if [ ! -z "$LDAP_CA_CERT" ] && [ ! -z "$LDAP_CLIENT_CERT" ] && [ ! -z "$LDAP_CLIENT_KEY" ]; then
    # check certificat and key or create it
    cfssl-helper ldap "$LDAP_CLIENT_CERT" "$LDAP_CLIENT_KEY" "$LDAP_CA_CERT"

    # ldap client config
    sed -i --follow-symlinks "s,TLS_CACERT.*,TLS_CACERT ${LDAP_CA_CERT},g" /etc/ldap/ldap.conf

    if [ ! -z "$LDAP_VERIFY_PEER" ]; then
      echo "TLS_REQCERT $LDAP_VERIFY_PEER" >> /etc/ldap/ldap.conf
    fi

    [[ -f "$HOME/.ldaprc" ]] && rm -f $HOME/.ldaprc
    touch $HOME/.ldaprc

    echo "TLS_CERT ${LDAP_CLIENT_CERT}" >> $HOME/.ldaprc
    echo "TLS_KEY ${LDAP_CLIENT_KEY}" >> $HOME/.ldaprc

  fi

  touch $FIRST_START_DONE
fi

exit 0
