#!/bin/bash
set -e
packer init .
packer validate -var-file ../shared_vars.hcl .
packer build -force -var-file ../shared_vars.hcl .
