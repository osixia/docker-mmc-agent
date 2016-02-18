#!/bin/bash -e

# Handle mmc plugin config files
# usage : config-plugin.sh plugin_variable /path/to/config/file

CONFIG_SECTIONS=$1
CONFIG_FILE=$2

plugin_config() {

  local sect=$1
  local infos=$2

  for info in $(complex-bash-env iterate "$infos")
  do
    if [ $(complex-bash-env isRow "${!info}") = true ]; then
      local key=$(complex-bash-env getRowKey "${!info}")
      local value=$(complex-bash-env getRowValue "${!info}")

      if [ "$key" == "password" ]; then
        PWD_BASE64=$(python -c 'print "'$value'".encode("base64")')
        value="{base64}$PWD_BASE64"
      fi

      if [ "$key" == "ldapverifypeer" ]; then
        echo "TLS_REQCERT $value" >> /etc/ldap/ldap.conf
      fi

      # delete key in the section
      sed -i --follow-symlinks '/\['$sect'\]/,/\[/{/\['$sect'\]/n;/\[/!{/#*\s*'$key'\s*=.*/d}}' $CONFIG_FILE

      # append new key value in section
      sed -i --follow-symlinks '/\['$sect'\]/a '$key' = '$value $CONFIG_FILE
    fi
  done
}

for section in $(complex-bash-env iterate $CONFIG_SECTIONS)
do

  if [ $(complex-bash-env isRow "${!section}") = true ]; then

    section_name=$(complex-bash-env getRowKey "${!section}")
    info=$(complex-bash-env getRowValueVarName "${!section}")

    # uncomment section title if needed
  	sed -i --follow-symlinks -e "s|#*\s*\[${section_name}\]\s*|\[${section_name}\]|" $CONFIG_FILE
    plugin_config "${section_name}" "${info}"
  fi

done
