#!/bin/bash

if [ -z $1 ]; then 
  echo "No parameter passed. Exiting."
  exit 1
fi

actual_name=$1
while read priv_user; do
  if [ "$actual_name" = "$priv_user" ]; then
    echo "true"
    exit
  fi
done < ./privileged-users.txt

echo "false"
