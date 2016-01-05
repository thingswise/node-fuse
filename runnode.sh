#!/bin/bash

wd=${NODE_WORKDIR:-.}
exec=${NODE_SCRIPT:-server.js}
archive=${APP_ARCHIVE:-}

function start_node() {
  if [ -f .lock ]; then
    return
  fi
  touch .lock
  echo "(Re)starting node..."
  if [ ! -z $archive ]; then
    echo "Listing archives at ${archive}..."
    tgz=$(ls -t $archive|grep .tgz|head -1)
    if [ ! -z $tgz ]; then
      echo "Newest one is: $tgz"
      main_dir=$wd      
      echo "Unpacking in ${main_dir}..."
      ( mkdir -p $main_dir && cd $main_dir && tar zxf $archive/$tgz --strip=1 --keep-newer-files ) || exit 3
    fi
  fi
  ( cd $wd; npm install && npm prune && node $exec )
  rm -f .lock
}

rm -f .lock
start_node


