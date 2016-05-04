#!/bin/bash
#

SENSU_SERVICE=${SENSU_SERVICE-$1}

CONFIG_FILE=/etc/sensu/config.json
CONFIG_DIR=/etc/sensu/conf.d
EXTENSION_DIR=/etc/sensu/extensions
PLUGINS_DIR=/etc/sensu/plugins
HANDLERS_DIR=/etc/sensu/handlers
LOG_DIR=/var/log/sensu
LOG_LEVEL=info
PID_DIR=/var/run/sensu
USER=sensu

export PATH=/opt/sensu/embedded/bin:$PATH:$PLUGINS_DIR:$HANDLERS_DIR
export GEM_PATH=/opt/sensu/embedded/lib/ruby/gems/2.3.0:$GEM_PATH

case "$SENSU_SERVICE" in
  api)
    ;;&
  client)
    ;;&
  server)
    ;;&
  api|server|client)
    /opt/sensu/bin/sensu-$SENSU_SERVICE -c $CONFIG_FILE -d $CONFIG_DIR -e $EXTENSION_DIR -L $LOG_LEVEL $OPTIONS
    ;;
  bash)
      bash
    ;;
  *)
    echo "You must specify the daemon to start 'api' or 'server' or 'client'"
    exit 1
    ;;
esac
