#!/bin/bash

clean_deploy=$1
priv_user=$2
image_tag=$3

if [ "$clean_deploy" = "true" ]; then
  echo 'Running terraform apply as it is a clean deploy.'
  cd ./terraform
  terraform apply -var="IMAGE_TAG=$image_tag" -auto-approve
elif [ "$priv_user" = 'true' ]; then 
  echo 'Running terraform apply as the workflow was initiated by a privileged user.'
  cd ./terraform
  terraform apply -var="IMAGE_TAG=$image_tag" -auto-approve
else 
  echo 'Failing the workflow as it was neither initiated by a privileged user nor was it a clean deploy.'
  echo 'If you are not a privileged user but would like to deploy changes to ECS, please run the workflow from the terraform plan stage.'
  exit 1
fi
