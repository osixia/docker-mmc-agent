#!/bin/bash -e

include /path/to/openldap/schema/ppolicy.schema

# Load the ppolicy module
moduleload  ppolicy

# Add the overlay ppolicy to your OpenLDAP database
database  bdb
suffix    "dc=mandriva,dc=com"

overlay ppolicy
ppolicy_default "cn=default,ou=Password Policies,dc=mandriva,dc=com"



CONFIG_PPOLICY_DN=$(/osixia/mmc-agent/get-config "$MMC_BASE_PLUGIN" "ppolicy ppolicyDN")
CONFIG_PPOLICY_DEFAULT=$(/osixia/mmc-agent/get-config "$MMC_PPOLICY_PLUGIN" "ppolicy ppolicyDefault")

if [ -n "$CONFIG_PPOLICY_DN" ]; then



fi

BASE_DN=$(/osixia/mmc-agent/get-config "$MMC_BASE_PLUGIN" "ldap baseDN")



ppolicyDN

#ppolicy plugin configuration
/osixia/mmc-agent/config-plugin.sh "$MMC_PPOLICY_PLUGIN" /etc/mmc/plugins/ppolicy.ini