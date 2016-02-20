#!/bin/bash -ex

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x


FIRST_START_DONE="${CONTAINER_STATE_DIR}/docker-ldap-client-first-start-done"
# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  # ldap tls config
  LDAP_CA_CERT=$(${CONTAINER_SERVICE_DIR}/mmc-agent/assets/get-config.sh "MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap cacert")
  LDAP_CLIENT_CERT=$(${CONTAINER_SERVICE_DIR}/mmc-agent/assets/get-config.sh "MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap localcert")
  LDAP_CLIENT_KEY=$(${CONTAINER_SERVICE_DIR}/mmc-agent/assets/get-config.sh "MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap localkey")

  if [ ! -z "$LDAP_CA_CERT" ] && [ ! -z "$LDAP_CLIENT_CERT" ] && [ ! -z "$LDAP_CLIENT_KEY" ]; then

    # generate a certificate and key if files don't exists
    # https://github.com/osixia/docker-light-baseimage/blob/stable/image/service-available/:cfssl/assets/tool/cfssl-helper
    cfssl-helper ${LDAP_CLIENT_CFSSL_PREFIX} "$LDAP_CLIENT_CERT" "$LDAP_CLIENT_KEY" "$LDAP_CA_CERT"

    # ldap client config
    sed -i --follow-symlinks "s,TLS_CACERT.*,TLS_CACERT ${LDAP_CA_CERT},g" /etc/ldap/ldap.conf
    cp -f /etc/ldap/ldap.conf ${CONTAINER_SERVICE_DIR}/ldap-client/assets/ldap.conf

    [[ -f "$HOME/.ldaprc" ]] && rm -f $HOME/.ldaprc
    echo "TLS_CERT ${LDAP_CLIENT_CERT}" > $HOME/.ldaprc
    echo "TLS_KEY ${LDAP_CLIENT_KEY}" >> $HOME/.ldaprc
    cp -f $HOME/.ldaprc ${CONTAINER_SERVICE_DIR}/ldap-client/assets/.ldaprc

  fi

  touch $FIRST_START_DONE
fi

ln -sf ${CONTAINER_SERVICE_DIR}/ldap-client/assets/.ldaprc $HOME/.ldaprc
ln -sf ${CONTAINER_SERVICE_DIR}/ldap-client/assets/ldap.conf /etc/ldap/ldap.conf

exit 0
