#!/bin/bash -e

# Handle mmc plugin config files
# usage : config-plugin.sh plugin_variable /path/to/config/file

CONFIG_SECTIONS=($1)
CONFIG_FILE=$2

plugin_config() { 

  local sect=$1
  local infos=(${!2})

  for info in "${infos[@]}"
  do
    plugin_config_value "$sect" "$info"
  done
}

plugin_config_value() {

  local sect=$1
  local info_key_value=(${!2})

  local key=${!info_key_value[0]}
  local value=${!info_key_value[1]}

  # all the passwords contained in MMC-related configuration files can be obfuscated using a base64 encoding.
  # this is not a security feature, but at least somebody won’t be able to read accidentally a password.
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

  # a bit tricky: uncomment $key and set is value between [section] and [
  # sed -i --follow-symlinks '/\['$sect'\]/,/\[/{/\['$sect'\]/n;/\[/!{s|#*\s*'$key'\s*=.*|'$key' = '$value'|g}}' $CONFIG_FILE

}

for section in "${CONFIG_SECTIONS[@]}"
do
  
  #section var contain a variable name, we access to the variable value and cast it to a table
  infos=(${!section})

  # it's a table of infos
  if [ "${#infos[@]}" -gt "1" ]; then
    # uncomment section title if needed
  	sed -i --follow-symlinks -e "s|#*\s*\[${!infos[0]}\]\s*|\[${!infos[0]}\]|" $CONFIG_FILE
    plugin_config "${!infos[0]}" "${infos[1]}"
  fi

done