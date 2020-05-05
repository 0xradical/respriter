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

if [[ ! -f "$node_modules_path" && ! -d "$node_modules_path" ]]; then
  ln -s $NODE_PATH $node_modules_path
  echo -e "\033[0;32mJust symlinked to $NODE_PATH\033[0m"
else
  if [[ -d "$node_modules_path" && ! -L "$node_modules_path" ]]; then
    mv $node_modules_path /app/tmp/node_modules
    echo -e "\033[0;31mThere was a node_modules here... it was moved to tmp/node_modules\033[0m"
    ln -s $NODE_PATH $node_modules_path
    echo -e "\033[0;32mJust symlinked to $NODE_PATH\033[0m"
  fi;
fi;

exec ${COMMAND}
