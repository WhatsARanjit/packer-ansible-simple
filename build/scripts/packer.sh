#!/bin/bash

cd packer_files/

export HCP_PACKER_BUILD_FINGERPRINT="$(date +%s)-$(git hash-object aws-linux.pkr.hcl | cut -c -25)"
packer build \
  -var "owner=$OWNER" \
  -var "version=$VERSION" \
  aws-linux.pkr.hcl
