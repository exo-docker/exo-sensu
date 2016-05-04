# Sensu
#
# Build:    docker build -t exoplatform/sensu .
#
# Run:      docker run -ti --rm --name=sensu-server -e SENSU_SERVICE=server exoplatform/sensu
#           docker run -d --name=sensu-server -e SENSU_SERVICE=server exoplatform/sensu
#           docker run -ti --rm --name=sensu-api -e SENSU_SERVICE=api exoplatform/sensu
#           docker run -d --name=sensu-api -e SENSU_SERVICE=api exoplatform/sensu

FROM       ubuntu:14.04
MAINTAINER eXo Platform <docker@exoplatform.com>

# Environment variables
ENV TERM xterm
# Install some useful or needed tools
ENV DEBIAN_FRONTEND noninteractive
# --force-confold: do not modify the current configuration file, the new version is installed with a .dpkg-dist suffix. With this option alone, even configuration
#   files that you have not modified are left untouched. You need to combine it with
# --force-confdef to let dpkg overwrite configuration files that you have not modified.
ENV _APT_OPTIONS -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# Install the needed packages
RUN apt-get -qq update && \
  apt-get -qq -y install ${_APT_OPTIONS} htop wget curl && \
  curl -L http://repositories.sensuapp.org/apt/pubkey.gpg | apt-key add - && \
  echo "deb http://repositories.sensuapp.org/apt sensu main" | tee /etc/apt/sources.list.d/sensu.list && \
  apt-get -qq update && \
  # apt-get -qq -y upgrade ${_APT_OPTIONS} && \
  apt-get -qq -y install ${_APT_OPTIONS} sensu && \
  apt-get -qq -y autoremove && \
  apt-get -qq -y clean && \
  rm -rf /var/lib/apt/lists/*

# Install needed plugins
RUN sensu-install -p sensu-plugins-cpu-checks:0.0.4
RUN sensu-install -p sensu-plugins-process-checks:0.0.6
RUN sensu-install -p sensu-plugins-network-checks:0.2.4
RUN sensu-install -p sensu-plugins-redis:0.1.0
# RUN sensu-install -p sensu-plugins-docker:0.0.4


COPY sensu.sh  /bin/sensu.sh
RUN chmod +x  /bin/sensu.sh

# Configure sensu
COPY conf/redis.json /etc/sensu/conf.d/redis.json
COPY conf/transport.json /etc/sensu/conf.d/transport.json
COPY conf/api.json /etc/sensu/conf.d/api.json
COPY conf/client.json /etc/sensu/conf.d/client.json
# COPY conf/check-cpu.json /etc/sensu/conf.d/check-cpu.json
# COPY conf/check-docker.json /etc/sensu/conf.d/check-cpu.json

ENTRYPOINT ["/bin/sensu.sh"]
