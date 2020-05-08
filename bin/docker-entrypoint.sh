#!/bin/bash

node_modules_path=/app/node_modules

if [ "$1" = "" ]; then
  COMMAND="bundle exec rails s -b 0.0.0.0"
else
  COMMAND="$@"
fi

sudo mkdir -p                  $NODE_PATH
sudo chown developer:developer $NODE_PATH
sudo chmod 775                 $NODE_PATH
sudo chmod g+s                 $NODE_PATH

sudo mkdir -p                  $BUNDLE_PATH
sudo chown developer:developer $BUNDLE_PATH
sudo chmod 775                 $BUNDLE_PATH
sudo chmod g+s                 $BUNDLE_PATH

exec ${COMMAND}
