#!/bin/bash
set -e
terraform init
terraform validate
terraform plan -var-file ../shared_vars.hcl -input=false -out=planfile
terraform apply -auto-approve planfile
