#!/bin/bash
ENVIRONMENT=$1
BUILD=$2

cd Build/Terraform

terraform init \
    -backend-config="bucket=tutor-dev-tf-state-bucket" \
    -backend-config="key=terraform-state/terraform.tfstate" \
    -backend-config="region=eu-west-1"


if [ $BUILD == "true" ]; then
    terraform apply -var-file="./config/pers.tfvars" -auto-approve
elif [ $BUILD == "false" ]; then
    terraform destroy -var-file="./config/pers.tfvars" -auto-approve
fi