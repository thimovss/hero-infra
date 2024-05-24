#!/bin/bash

AWS_REGION="eu-west-2"
read -p "What is your AWS region? (default: $AWS_REGION) " INPUT
AWS_REGION=${INPUT:-$AWS_REGION}

AWS_ACCESS_KEY_ID="n/a"
read -p "What is your AWS Access Key ID? (default: $AWS_ACCESS_KEY_ID) " INPUT
AWS_ACCESS_KEY_ID=${INPUT:-$AWS_ACCESS_KEY_ID}

AWS_SECRET_ACCESS_KEY="n/a"
read -p "What is your AWS Secret Access Key? (default: $AWS_SECRET_ACCESS_KEY) " INPUT
AWS_SECRET_ACCESS_KEY=${INPUT:-$AWS_SECRET_ACCESS_KEY}

export AWS_REGION
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

terraform init -var "AWS_REGION=$AWS_REGION"
#terraform plan -var "AWS_REGION=$AWS_REGION"
terraform apply -var "AWS_REGION=$AWS_REGION" --auto-approve

# Commit the boilerplate code to the repository
python3 -m venv venv
. venv/bin/activate
pip install git-remote-codecommit
git config --global user.name "Hero Infra"
git config --global user.email "contact@tbd-heroinfra.com"
git clone "codecommit::$AWS_REGION://terraform-infrastructure"
cp -r boilerplate/* terraform-infrastructure/
cd terraform-infrastructure || exit
git add .
git commit -m "Hero Infra setup Commit"
git push
deactivate