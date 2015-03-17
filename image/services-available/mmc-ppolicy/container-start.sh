#!/bin/bash -e





CONFIG_PPOLICY_DN=$(/osixia/mmc-agent/get-config "$MMC_BASE_PLUGIN" "ppolicy ppolicyDN")
CONFIG_PPOLICY_DEFAULT=$(/osixia/mmc-agent/get-config "$MMC_PPOLICY_PLUGIN" "ppolicy ppolicyDefault")

if [ -n "$CONFIG_PPOLICY_DN" ]; then



fi

BASE_DN=$(/osixia/mmc-agent/get-config "$MMC_BASE_PLUGIN" "ldap baseDN")



ppolicyDN

#ppolicy plugin configuration
/osixia/mmc-agent/config-plugin.sh "$MMC_PPOLICY_PLUGIN" /etc/mmc/plugins/ppolicy.ini