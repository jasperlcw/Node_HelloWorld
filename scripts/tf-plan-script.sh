#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: ./tf-plan-script.sh -image_tag={docker-image-tag}"
  exit 255
fi

image_tag=${1#'-image_tag='}

cd ./terraform
terraform plan -var="IMAGE_TAG=$image_tag" -no-color > ./tfplan.txt
if [ "$?" -ne "0" ]; then
  rm ./tfplan.txt
  echo "There is a syntax error in the terraform configuration. Aborting workflow." 1>&2
  exit 255
fi

num_changes=$(cat ./tfplan.txt | grep '# aws' | wc -l)
num_changes_ecs=$(cat ./tfplan.txt | grep '# aws_ecs' | wc -l)
status=0

if [ "$num_changes" -eq "0" ]; then
  echo "Terraform found no changes to the AWS infrastructrure." > ../temp-msg.txt
  status=0
elif [ $(($num_changes-$num_changes_ecs)) == 0 ]; then
  echo "Terraform plan found changes to the AWS ECS service(s):" > ../temp-msg.txt
  cat ./tfplan.txt | grep '# aws_ecs' >> ../temp-msg.txt
  status=1
else
  echo "Terraform plan found changes to the AWS service(s):" > ../temp-msg.txt
  cat ./tfplan.txt | grep '# aws' >> ../temp-msg.txt
  status=2
fi
rm ./tfplan.txt

if [ "$status" -eq 0 ]; then
  clean_deploy='n/a'
  echo "No changes were found to the AWS infrastructure. Exiting." >> ../temp-msg.txt
elif [ "$status" -eq 1 ]; then
  clean_deploy='true'
  echo "Deployment is a clean deploy with only changes to ECS detected." >> ../temp-msg.txt
elif [ "$status" -eq 2 ]; then
  clean_deploy='false'
  echo "Deployment is not a clean deploy (changes other than to ECS were found), so changes will not be applied." >> ../temp-msg.txt
else
  clean_deploy='err'
  echo "Uncaught exit code in the terraform check script. Aborting workflow." >> ../temp-msg.txt
fi
echo $clean_deploy