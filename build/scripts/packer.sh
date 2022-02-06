#!/bin/bash

cd packer_files/

packer build \
  -var "owner=$OWNER" \
  -var "version=$VERSION" \
  aws-linux.pkr.hcl
