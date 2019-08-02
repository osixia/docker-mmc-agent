# Use osixia/light-baseimage
# sources: https://github.com/osixia/docker-light-baseimage
FROM osixia/light-baseimage:release-1.2.0-dev

# Add service-available directory to /container/service-available
ADD service-available /container/service-available/

# Required for python-ldap 2.4
RUN echo "deb http://ftp.debian.org/debian stretch main" >> /etc/apt/sources.list

# Install mmc-agent
RUN apt-get -y update \
    && /container/tool/add-service-available mmc-mail mmc-ppolicy mmc-sshlpk :ssl-tools \
    && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ldap-utils \
    libnss-ldap \
    python \
    python-gobject \
    python-memory-profiler \
    python-mysqldb \
    python-openssl \
    python-psutil \
    python-sqlalchemy \
    python-twisted-web \
    python-xlwt \
    && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -t stretch install -y --no-install-recommends python-ldap \
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
