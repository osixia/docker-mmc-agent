#!/bin/bash -e

# Handle mmc plugin config files
# usage : config-plugin.sh plugin_variable /path/to/config/file

CONFIG_SECTIONS=($1)
CONFIG_FILE=$2

plugin_config() { 

  local infos=(${!1})

  for info in "${infos[@]}"
  do
    plugin_config_value "$info"
  done
}

plugin_config_value() {

  local info_key_value=(${!1})

  local key=${!info_key_value[0]}
  local value=${!info_key_value[1]}

  local v;
  # the value contain a not empty variable
  if [ -n "${!value}" ]; then
    local v=${!value}

  # it's just a not empty value
  elif [ -n "$value" ]; then
    local v=$value
  fi

  # all the passwords contained in MMC-related configuration files can be obfuscated using a base64 encoding.
  # this is not a security feature, but at least somebody won’t be able to read accidentally a password.
  if [ "$key" == "password" ]; then
    PWD_BASE64=$(python -c 'print "'$v'".encode("base64")')
    v="{base64}$PWD_BASE64"
  fi

  sed -i -e "s|#*\s*$key\s*=.*|$key = $v|" $CONFIG_FILE
}

for section in "${CONFIG_SECTIONS[@]}"
do
  
  #section var contain a variable name, we access to the variable value and cast it to a table
  infos=(${!section})

  # it's a table of infos
  if [ "${#infos[@]}" -gt "1" ]; then
  	sed -i -e "s|#*\s*\[${!infos[0]}\]\s*|\[${!infos[0]}\]|" $CONFIG_FILE
    plugin_config "${infos[1]}"
  fi

done