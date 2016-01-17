# Use osixia/light-baseimage
# sources: https://github.com/osixia/docker-light-baseimage
FROM osixia/light-baseimage:0.2.1
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

# Add service-available directory to /container/service-available
ADD service-available /container/service-available/

# Install mmc-agent
RUN apt-get -y update \
    && /container/tool/add-service-available mmc-mail mmc-sshlpk :cfssl \
    && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
       ldap-utils \
       libnss-ldap \
       python \
       python-gobject \
       python-ldap \
       python-mysqldb \
       python-openssl \
       python-psutil \
       python-sqlalchemy \
       python-support \
       python-twisted-web

# Add service directory to /container/service
ADD service /container/service

# Use baseimage install-service script, image specific service-available and clean all
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-service
RUN /container/tool/install-service \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add default env variables
ADD environment /container/environment/99-default

# Expose mmc-agent default port
EXPOSE 7080
