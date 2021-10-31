FROM phusion/baseimage:focal-1.1.0
MAINTAINER Donn Lee <docker@pluza.com>

RUN apt-get update -y \
    && apt-get install -y \
      curl unzip python3-pip \
    && pip install envtpl

# Install InfluxDB
ENV INFLUXDB_VERSION 0.12.2-1
RUN curl -s -o /tmp/influxdb_latest_amd64.deb https://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
  dpkg -i /tmp/influxdb_latest_amd64.deb && \
  rm /tmp/influxdb_latest_amd64.deb && \
  rm -rf /var/lib/apt/lists/*

ADD types.db /usr/share/collectd/types.db
#ADD config.toml /config/config.toml
ADD influxdb.conf.tpl /config/influxdb.conf.tpl
ADD run.sh /run.sh
RUN chmod +x /*.sh

ENV PRE_CREATE_DB **None**
ENV SSL_SUPPORT **False**
ENV SSL_CERT **None**

# Admin server WebUI
EXPOSE 8083
# HTTP API
EXPOSE 8086
# Collectd port (udp)
EXPOSE 25826/udp

#EXPOSE 8090

# Protobuf port (for clustering, don't expose publicly!)
#EXPOSE 8099

# Donn: Removed volume mount because this container's storage will be mounted by Rancher's convoy-gluster.
# Just make sure the persistent storage is mounted at /data within the container (per config.toml settings).
#VOLUME ["/data"]

CMD ["/run.sh"]
