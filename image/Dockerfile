FROM osixia/light-baseimage:0.1.0
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

# Use baseimage-docker's init system.
CMD ["/osixia/tool/run"]

# Add mmc user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mmc && useradd -r -g mmc mmc

# Install mmc-agent
RUN apt-get -y update && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
    libnss-ldap \
    ldap-utils \
    python \
    python-support \
    python-twisted-web \
    python-ldap \
    python-sqlalchemy \
    python-mysqldb \
    python-openssl \
    python-psutil \
    python-gobject

ADD service-available /osixia/service-available/
ADD service /osixia/service

RUN /sbin/install-service \
    && /sbin/install-service-available ssl-helper-gnutls ssl-helper-openssl mmc-mail mmc-ppolicy mmc-sshlpk \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add default env variables
ADD env.yaml /etc/env.yaml

# Expose mmc-agent default port
EXPOSE 7080
