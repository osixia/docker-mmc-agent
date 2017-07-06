# Use osixia/light-baseimage
# sources: https://github.com/osixia/docker-light-baseimage
FROM osixia/light-baseimage:1.1.0
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

# Add service-available directory to /container/service-available
ADD service-available /container/service-available/

# Install mmc-agent
RUN apt-get -y update \
    && /container/tool/add-service-available mmc-mail mmc-sshlpk :ssl-tools \
    && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       ldap-utils \
       libnss-ldap \
       python \
       python-gobject \
       python-ldap \
       python-mysqldb \
       python-openssl \
       python-psutil \
       python-sqlalchemy \
       python-twisted-web \
    && curl -o python-support.deb -SL http://launchpadlibrarian.net/109052632/python-support_1.0.15_all.deb \
    && dpkg -i python-support.deb && rm python-support.deb \
    && apt-get remove -y --purge --auto-remove curl ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add service directory to /container/service
ADD service /container/service

# Use baseimage install-service script, image specific service-available
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-service
RUN /container/tool/install-service

# Add default env variables
ADD environment /container/environment/99-default

# Expose mmc-agent default port
EXPOSE 7080
