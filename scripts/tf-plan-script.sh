#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: ./tf-plan-script.sh image_tag={docker-image-tag}"
  exit 255
fi

image_tag=${1#'image_tag='}

status=0
./terraform-check.sh $image_tag > temp-msg.txt
status="$?"
if [ "$status" -eq 0 ]; then
  clean_deploy='n/a'
  echo "No changes were found to the AWS infrastructure. Exiting." >> temp-msg.txt
elif [ "$status" -eq 1 ]; then
  clean_deploy='true'
  echo "Deployment is a clean deploy with only changes to ECS detected." >> temp-msg.txt
elif [ "$status" -eq 2 ]; then
  clean_deploy='false'
  echo "Deployment is not a clean deploy (changes other than to ECS were found), so changes will not be applied." >> temp-msg.txt
elif [ "$status" -eq 255 ]; then
  clean_deploy='err'
  echo "There is a syntax error in the terraform configuration. Aborting workflow." >> temp-msg.txt
else
  clean_deploy='err'
  echo "Uncaught exit code in the terraform check script. Aborting workflow." >> temp-msg.txt
fi
echo $clean_deploy