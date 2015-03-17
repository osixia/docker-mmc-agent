FROM osixia/baseimage:0.10.4
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN groupadd -r mmc && useradd -r -g mmc mmc

# Add MDS repository
RUN echo "deb http://mds.mandriva.org/pub/mds/debian wheezy main" > /etc/apt/sources.list.d/mds.list

# Install mmc-agent
RUN apt-get -y update && /sbin/enable-service ssl-kit \
    && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
    libnss-ldap \
    mmc-agent \
    python-mmc-base \
    python-mmc-dashboard

# Add install script and mmc-agent assets
ADD service/install.sh /tmp/install.sh
ADD service/mmc-agent/assets /osixia/mmc-agent

# Run install script and clean all
RUN ./tmp/install.sh \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add default env variables
ADD env.yml /etc/env.yml

# Add mmc-agent container start config & daemon
ADD service/mmc-agent/container-start.sh /etc/my_init.d/mmc-agent
ADD service/mmc-agent/daemon.sh /etc/service/mmc-agent/run

# Expose mmc-agent default port
EXPOSE 7080