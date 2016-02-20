#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x


FIRST_START_DONE="${CONTAINER_STATE_DIR}/docker-mmc-agent-ppolicy-first-start-done"
# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  LDAP_URL=$(${CONTAINER_SERVICE_DIR}/mmc-agent/assets/get-config.sh "MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap ldapurl")
  LDAP_BASE_DN=$(${CONTAINER_SERVICE_DIR}/mmc-agent/assets/get-config.sh "MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap baseDN")
  LDAP_ADMIN_DN=$(${CONTAINER_SERVICE_DIR}/mmc-agent/assets/get-config.sh "MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap rootName")
  LDAP_ADMIN_PASSWORD=$(${CONTAINER_SERVICE_DIR}/mmc-agent/assets/get-config.sh "MMC_AGENT_BASE_PLUGIN_CONFIG" "ldap password")

  CONFIG_PPOLICY_DN=$(${CONTAINER_SERVICE_DIR}/mmc-agent/assets/get-config.sh "MMC_AGENT_PPOLICY_PLUGIN_CONFIG" "ppolicy ppolicyDN")
  CONFIG_PPOLICY_DEFAULT=$(${CONTAINER_SERVICE_DIR}/mmc-agent/assets/get-config.sh "MMC_AGENT_PPOLICY_PLUGIN_CONFIG" "ppolicy ppolicyDefault")

  if [ -z "$CONFIG_PPOLICY_DN" ]; then
  	CONFIG_PPOLICY_DN="ou=Password Policies,$LDAP_BASE_DN"
  fi

  if [ -z "$CONFIG_PPOLICY_DEFAULT" ]; then
  	CONFIG_PPOLICY_DEFAULT="cn=default"
  fi

  # adapt overlay config
  sed -i --follow-symlinks -e "s|olcPPolicyDefault:.*|olcPPolicyDefault: $CONFIG_PPOLICY_DEFAULT,$CONFIG_PPOLICY_DN|" ${CONTAINER_SERVICE_DIR}/mmc-ppolicy/assets/config/ppolicy_overlay.ldif

  # load ppolicy module
  ldapadd -x -H $LDAP_URL -D $LDAP_ADMIN_DN -w $LDAP_ADMIN_PASSWORD -f ${CONTAINER_SERVICE_DIR}/mmc-ppolicy/assets/config/ppolicy_moduleload.ldif || true

  # ppolicy overlay
  ldapadd -x -H $LDAP_URL -D $LDAP_ADMIN_DN -w $LDAP_ADMIN_PASSWORD -f ${CONTAINER_SERVICE_DIR}/mmc-ppolicy/assets/config/ppolicy_overlay.ldif || true

  # ppolicy plugin configuration
  ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/config-plugin.sh "MMC_AGENT_PPOLICY_PLUGIN_CONFIG" /etc/mmc/plugins/ppolicy.ini
  cp -f /etc/mmc/plugins/ppolicy.ini ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/ppolicy.ini

  touch $FIRST_START_DONE
fi

ln -sf ${CONTAINER_SERVICE_DIR}/mmc-agent/assets/ppolicy.ini /etc/mmc/plugins/ppolicy.ini

exit 0
