#!/bin/bash

cd ./terraform
terraform plan -no-color > ./tfplan.txt
if [ "$?" -ne "0" ]; then
  rm ./tfplan.txt
  exit 1
fi

num_changes=$(cat ./tfplan.txt | grep '# aws' | wc -l)

if [ "$num_changes" -eq "0" ]; then
  echo "Terraform found no changes to the AWS infrastructrure."
  echo "The terraform plan will be applied."
  terraform apply -auto-approve
else
  echo "Terraform plan found changes to the AWS service(s):"
fi

cat ./tfplan.txt | grep '# aws'
rm ./tfplan.txt
