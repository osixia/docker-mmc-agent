#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

ARG="-s" # Do not daemonize and not log debug
log-helper level gt info && ARG="-d" # Do not daemonize

exec /usr/sbin/mmc-agent ${ARG}
