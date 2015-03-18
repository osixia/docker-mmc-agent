#!/bin/bash -e

# get mmc plugin config
# usage : get-config.sh plugin_variable config

CONFIG_SECTIONS=($1)
CONFIG=$2

IFS=', ' read -a search_for <<< "$CONFIG"

section_to_search=${search_for[0]}
config_to_search=${search_for[1]}

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

  if [ "$key" == "$config_to_search" ]; then
    echo "$value"
  fi

}

for section in "${CONFIG_SECTIONS[@]}"
do
  
  #section var contain a variable name, we access to the variable value and cast it to a table
  infos=(${!section})

  # it's a table of infos
  if [ "${#infos[@]}" -gt "1" ]; then

  	if [ "${!infos[0]}" == "$section_to_search" ]; then
		plugin_config "${infos[1]}"
  	fi
  fi

done