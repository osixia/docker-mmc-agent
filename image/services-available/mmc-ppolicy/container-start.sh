#!/bin/bash -e

LDAP_URL=$(/osixia/mmc-agent/get-config.sh "$MMC_BASE_PLUGIN" "ldap ldapurl")
LDAP_BASE_DN=$(/osixia/mmc-agent/get-config.sh "$MMC_BASE_PLUGIN" "ldap baseDN")
LDAP_ADMIN_DN=$(/osixia/mmc-agent/get-config.sh "$MMC_BASE_PLUGIN" "ldap rootName")
LDAP_ADMIN_PASSWORD=$(/osixia/mmc-agent/get-config.sh "$MMC_BASE_PLUGIN" "ldap password")

CONFIG_PPOLICY_DN=$(/osixia/mmc-agent/get-config.sh "$MMC_PPOLICY_PLUGIN" "ppolicy ppolicyDN")
CONFIG_PPOLICY_DEFAULT=$(/osixia/mmc-agent/get-config.sh "$MMC_PPOLICY_PLUGIN" "ppolicy ppolicyDefault")

if [ -z "$CONFIG_PPOLICY_DN" ]; then
	CONFIG_PPOLICY_DN="ou=Password Policies,$LDAP_BASE_DN"
fi

if [ -z "CONFIG_PPOLICY_DEFAULT" ]; then
	CONFIG_PPOLICY_DEFAULT="cn=default"
fi

# adapt overlay config
sed -i -e "s|olcPPolicyDefault:.*|olcPPolicyDefault: $CONFIG_PPOLICY_DEFAULT,$CONFIG_PPOLICY_DN|" /etc/services-available/mmc-ppolicy/config/ppolicy_overlay.ldif


# add ppolicy schema
echo "ldapadd -H $LDAP_URL -D $LDAP_ADMIN_DN -w $LDAP_ADMIN_PASSWORD -Y EXTERNAL -f /etc/services-available/mmc-ppolicy/config/ppolicy.ldif"
ldapadd -H $LDAP_URL -D $LDAP_ADMIN_DN -w $LDAP_ADMIN_PASSWORD -Y EXTERNAL -f /etc/services-available/mmc-ppolicy/config/ppolicy.ldif

# load ppolicy module
ldapadd -H $LDAP_URL -D $LDAP_ADMIN_DN -w $LDAP_ADMIN_PASSWORD -Y EXTERNAL -f /etc/services-available/mmc-ppolicy/config/ppolicy_moduleload.ldif

# ppolicy overlay
ldapadd -H $LDAP_URL -D $LDAP_ADMIN_DN -w $LDAP_ADMIN_PASSWORD -Y EXTERNAL -f /etc/services-available/mmc-ppolicy/config/ppolicy_overlay.ldif


# ppolicy plugin configuration
/osixia/mmc-agent/config-plugin.sh "$MMC_PPOLICY_PLUGIN" /etc/mmc/plugins/ppolicy.ini