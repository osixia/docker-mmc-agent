FROM osixia/light-baseimage:0.1.3
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

# Use baseimage's init system.
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/run
CMD ["/container/tool/run"]

# Install mmc-agent
RUN apt-get -y update \
    && /container/tool/install-service-available \
       ssl-helper-gnutls \
       ssl-helper-openssl \
    && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
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

ADD service-available /container/service-available/
ADD service /container/service

# Use baseimage install-service script, image specific service-available and clean all
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-service
RUN /container/tool/install-service \
    && /container/tool/install-service-available \
       mmc-mail \
       mmc-ppolicy \
       mmc-sshlpk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add default env variables
ADD env.yaml /container/environment/env.yaml

# Expose mmc-agent default port
EXPOSE 7080
