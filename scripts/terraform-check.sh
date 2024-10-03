#!/bin/bash

cd ./terraform
terraform plan -no-color > ./tf.plan
num_changes=$(cat ./tf.plan | grep '# aws' | wc -l)

if [ "$num_changes" -eq "0" ]; then
  echo "Terraform plan found no changes to the AWS infrastructrure."
elif [ "$num_changes" -eq "1" ]; then
  echo "Terraform plan found the following change to the AWS infrastructure:"
else
  echo "Terraform plan found the following $num_changes changes to the AWS infrastructure:"
fi

cat ./tf.plan | grep '# aws'
rm ./tf.plan
