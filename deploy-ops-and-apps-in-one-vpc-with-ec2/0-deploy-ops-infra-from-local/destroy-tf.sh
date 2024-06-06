#!/bin/bash

source .env

# aws credentials
echo $AWS_ACCESS_KEY_ID
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

# deploy with terraform
cd terraform
terraform init
terraform destroy -auto-approve

