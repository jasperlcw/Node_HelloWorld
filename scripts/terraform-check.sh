#!/bin/bash

cd ./terraform
terraform plan -no-color > ./tfplan.txt
if [ "$?" -ne "0" ]; then
  rm ./tfplan.txt
  exit 255
fi

num_changes=$(cat ./tfplan.txt | grep '# aws' | wc -l)
num_changes_ecs=$(cat ./tfplan.txt | grep '# aws_ecs' | wc -l)

if [ "$num_changes" -eq "0" ]; then
  echo "Terraform found no changes to the AWS infrastructrure."
  rm ./tfplan.txt
  exit 0
elif [ $(($num_changes-$num_changes_ecs)) == 0 ]; then
  echo "Terraform plan found changes to the AWS ECS service(s):"
  cat ./tfplan.txt | grep '# aws_ecs'
  rm ./tfplan.txt
  exit 1
else
  echo "Terraform plan found changes to the AWS service(s):"
  cat ./tfplan.txt | grep '# aws'
  rm ./tfplan.txt
  exit 2
fi
