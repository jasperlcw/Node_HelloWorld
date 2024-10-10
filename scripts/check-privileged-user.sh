#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: ./check-privileged-user.sh {name-to-check} {comma-delimited-authorized-names}"
  exit 255
fi

actual_name=$1
name_list=$2

for priv_user in $(echo $name_list | tr "," " "); do
  if [ "$actual_name" = "$priv_user" ]; then
    echo "true"
    exit 0
  fi
done

echo "false"
exit 1
