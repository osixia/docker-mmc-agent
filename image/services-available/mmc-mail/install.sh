#!/bin/bash -e

LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends php5-fpm

disable 0
pwdCheckQuality = 0