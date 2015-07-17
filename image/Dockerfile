FROM osixia/light-baseimage:0.1.0
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

# Use baseimage-docker's init system.
CMD ["/osixia/tool/run"]

# Add mmc user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mmc && useradd -r -g mmc mmc

# Add MDS repository
RUN echo "deb http://repo.pulse2.fr/pub/pulse2/server/debian wheezy 3.0" > /etc/apt/sources.list.d/mds.list

ADD service-available /osixia/service-available/

# Install mmc-agent
RUN apt-get -y update && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
    libnss-ldap \
    mmc-agent \
    python-mmc-base \
    python-mmc-dashboard \
    && /sbin/install-service-available ssl-helper-openssl mmc-mail mmc-ppolicy mmc-sshlpk

# Add service directory to /osixia/service
ADD service /osixia/service

# Use baseimage install-service script and clean all
RUN ./sbin/install-service && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add default env variables
ADD env.yaml /etc/env.yaml

# Expose mmc-agent default port
EXPOSE 7080
