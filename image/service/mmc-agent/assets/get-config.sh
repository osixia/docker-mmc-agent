#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

# get mmc plugin config
# usage : get-config.sh plugin_variable config

CONFIG_SECTIONS=$1
CONFIG=$2

IFS=', ' read -a search_for <<< "$CONFIG"

section_to_search=${search_for[0]}
config_to_search=${search_for[1]}

plugin_config() {

  local infos=$1

  for info in $(complex-bash-env iterate "$infos")
  do
    if [ $(complex-bash-env isRow "${!info}") = true ]; then
      local key=$(complex-bash-env getRowKey "${!info}")

      if [ "$key" == "$config_to_search" ]; then
        local value=$(complex-bash-env getRowValue "${!info}")
        echo "$value"
      fi

    fi
  done
}

for section in $(complex-bash-env iterate $CONFIG_SECTIONS)
do

  if [ $(complex-bash-env isRow "${!section}") = true ]; then

    section_name=$(complex-bash-env getRowKey "${!section}")

    if [ "${section_name}" == "$section_to_search" ]; then
      info=$(complex-bash-env getRowValueVarName "${!section}")
      plugin_config "${info}"
    fi
  fi
done
