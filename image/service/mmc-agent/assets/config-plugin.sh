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

  # the value contain a not empty variable
  if [ -n "${!value}" ]; then
  	sed -i -e "s|#*\s*$key\s*=.*|$key = ${!value}|" $CONFIG_FILE

  # it's just a not empty value
  elif [ -n "$value" ]; then
  	sed -i -e "s|#*\s*$key\s*=.*|$key = $value|" $CONFIG_FILE
  fi
}

for section in "${CONFIG_SECTIONS[@]}"
do
  
  #section var contain a variable name, we access to the variable value and cast it to a table
  infos=(${!section})

  # it's a table of infos
  if [ "${#infos[@]}" -gt "1" ]; then

  	sed -i -e "s|#*\s*\[${!infos[0]}\]\s*|\[${!infos[0]}\]|" $CONFIG_FILE
    plugin_config "${infos[1]}"
  
  # it's just a section name 
  # stored in a variable
  elif [ -n "${!section}" ]; then
  	sed -i  -e "s|#*\s*\[${!section}\]\s*|\[${!section}\]|" $CONFIG_FILE 
  # directly
  else
  	sed -i -e "s|#*\s*\[${section}\]\s*|\[${section}\]|" $CONFIG_FILE
  fi
done