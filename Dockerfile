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

# RUN mkdir /etc/sensu/
# RUN mkdir mkdir /etc/sensu/conf.d/

COPY sensu.sh  /sensu.sh
RUN chmod +x  /sensu.sh

# Configure sensu
COPY conf/redis.json /etc/sensu/conf.d/redis.json
COPY conf/transport.json /etc/sensu/conf.d/transport.json
COPY conf/api.json /etc/sensu/conf.d/api.json

CMD ["/sensu.sh"]
