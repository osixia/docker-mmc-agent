#!/bin/bash -e

FIRST_START_DONE="/etc/docker-mmc-agent-ppolicy-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  LDAP_URL=$(/osixia/service/mmc-agent/assets/get-config.sh "$MMC_BASE_PLUGIN" "ldap ldapurl")
  LDAP_BASE_DN=$(/osixia/service/mmc-agent/assets/get-config.sh "$MMC_BASE_PLUGIN" "ldap baseDN")
  LDAP_ADMIN_DN=$(/osixia/service/mmc-agent/assets/get-config.sh "$MMC_BASE_PLUGIN" "ldap rootName")
  LDAP_ADMIN_PASSWORD=$(/osixia/service/mmc-agent/assets/get-config.sh "$MMC_BASE_PLUGIN" "ldap password")

  CONFIG_PPOLICY_DN=$(/osixia/service/mmc-agent/assets/get-config.sh "$MMC_PPOLICY_PLUGIN" "ppolicy ppolicyDN")
  CONFIG_PPOLICY_DEFAULT=$(/osixia/service/mmc-agent/assets/get-config.sh "$MMC_PPOLICY_PLUGIN" "ppolicy ppolicyDefault")

  if [ -z "$CONFIG_PPOLICY_DN" ]; then
  	CONFIG_PPOLICY_DN="ou=Password Policies,$LDAP_BASE_DN"
  fi

  if [ -z "$CONFIG_PPOLICY_DEFAULT" ]; then
  	CONFIG_PPOLICY_DEFAULT="cn=default"
  fi

  # adapt overlay config
  sed -i -e "s|olcPPolicyDefault:.*|olcPPolicyDefault: $CONFIG_PPOLICY_DEFAULT,$CONFIG_PPOLICY_DN|" /osixia/service/mmc-ppolicy/assets/config/ppolicy_overlay.ldif

  # load ppolicy module
  ldapadd -x -H $LDAP_URL -D $LDAP_ADMIN_DN -w $LDAP_ADMIN_PASSWORD -f /osixia/service/mmc-ppolicy/assets/config/ppolicy_moduleload.ldif || true

  # ppolicy overlay
  ldapadd -x -H $LDAP_URL -D $LDAP_ADMIN_DN -w $LDAP_ADMIN_PASSWORD -f /osixia/service/mmc-ppolicy/assets/config/ppolicy_overlay.ldif || true

  # ppolicy plugin configuration
  /osixia/service/mmc-agent/assets/config-plugin.sh "$MMC_PPOLICY_PLUGIN" /etc/mmc/plugins/ppolicy.ini

  touch $FIRST_START_DONE
fi

exit 0
