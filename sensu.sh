#!/bin/bash
# Usage: sensu-api [options]
#     -h, --help                       Display this message
#     -V, --version                    Display version
#     -c, --config FILE                Sensu JSON config FILE
#     -d, --config_dir DIR[,DIR]       DIR or comma-delimited DIR list for Sensu JSON config files
#     -P, --print_config               Print the compiled configuration and exit
#     -e, --extension_dir DIR          DIR for Sensu extensions
#     -l, --log FILE                   Log to a given FILE. Default: STDOUT
#     -L, --log_level LEVEL            Log severity LEVEL
#     -v, --verbose                    Enable verbose logging
#     -b, --background                 Fork into the background
#     -p, --pid_file FILE              Write the PID to a given FILE
# Usage: sensu-server [options]
#     -h, --help                       Display this message
#     -V, --version                    Display version
#     -c, --config FILE                Sensu JSON config FILE
#     -d, --config_dir DIR[,DIR]       DIR or comma-delimited DIR list for Sensu JSON config files
#     -P, --print_config               Print the compiled configuration and exit
#     -e, --extension_dir DIR          DIR for Sensu extensions
#     -l, --log FILE                   Log to a given FILE. Default: STDOUT
#     -L, --log_level LEVEL            Log severity LEVEL
#     -v, --verbose                    Enable verbose logging
#     -b, --background                 Fork into the background
#     -p, --pid_file FILE              Write the PID to a given FILE

if [ -z ${SENSU_SERVICE} ]; then
  echo "ERROR: you must specify the daemon to start (SENSU_SERVICE environment variable should be 'api' or 'server')"
fi

if [ "${SENSU_SERVICE}" != "api" ] && [ "${SENSU_SERVICE}" != "server" ]; then
  echo "ERROR: SENSU_SERVICE environment variable should be 'api' or 'server' (current value is '${SENSU_SERVICE}')"
fi

SENSU_SERVICE=sensu-${SENSU_SERVICE}
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

if [ ! -d $PID_DIR ]; then
  mkdir $PID_DIR
  chown $USER $PID_DIR
fi
if [ ! -d $LOG_DIR ]; then
  mkdir $LOG_DIR
  chown $USER $LOG_DIR
fi

cd /opt/sensu
/opt/sensu/bin/$SENSU_SERVICE -c $CONFIG_FILE -d $CONFIG_DIR -e $EXTENSION_DIR -p $PID_DIR/$SENSU_SERVICE -l $LOG_DIR/$SENSU_SERVICE -L $LOG_LEVEL $OPTIONS
