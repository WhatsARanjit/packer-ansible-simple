# HCP Packer-Ansible Demo [![Build Status](https://app.travis-ci.com/WhatsARanjit/packer-ansible-simple.svg?branch=master)](https://app.travis-ci.com/WhatsARanjit/packer-ansible-simple)

#### Table of Contents

1. [Overview](#overview)
1. [Requirements](#requirements)
1. [Setup](#setup)
1. [Packer Build](#packer-build)
    * [Result](#result)
1. [Image Channel](#image-channel)
1. [Initial Terraform Deploy](#inital-terraform-deploy)
    * [Result](#result-1)
1. [New Packer Iteration](#new-packer-iteration)
1. [Test Terraform](#test-terraform)
1. [Update Channel](#update-channel)
1. [Pipeline](#pipeline)

## Overview

This an example workflow that creates a new image installing NGINX on Ubuntu Bionic 18.04.  The image is published to `us-east-1` and registered with HCP Packer.  The HCP Packer reference can then be used by Terraform to deploy.

## Requirements

* `packer`, `ansible`, and `terraform` available on CLI
* [HCP Packer Service Principle](https://learn.hashicorp.com/tutorials/packer/hcp-push-image-metadata?in=packer/hcp-get-started#configure-your-environment-with-hcp-credentials)
* AWS credentials

## Setup

You'll need an environment that you can run Packer, Ansible, and Terraform from.  Included in this repo is a [Vagrantfile](./build/Vagrantfile) which will build an Ubuntu VM with the binaries and the repo mounted at `/vagrant`.

Whatever the environment, preset the following environment variables:

```
# HCP Packer Info
export HCP_CLIENT_ID="<FROM HCP PACKER>"
export HCP_CLIENT_SECRET="<FROM HCP PACKER>"

# AWS Info
export AWS_REGION="us-east-1"
export AWS_ACCESS_KEY_ID="<FROM AWS>"
export AWS_SECRET_ACCESS_KEY="<FROM AWS>"
```

## Packer Build

Packerfiles are contained in the `build/` directory.  From that directory, run the following:

```
# Create hash for this build
export HCP_PACKER_BUILD_FINGERPRINT="$(date +%s)-$(git hash-object aws-linux.pkr.hcl | cut -c -25)"

# Run build
packer build \
  -var "owner=<YOUR NAME>" \
  -var "version=1.0.0" \
  aws-linux.pkr.hcl
```

Replace `<YOUR NAME>` with the needful and adjust the version if you'd like.  This _does not_ correspond to HCP Packer's version iteration, but it's example metadata we can provide.

### Result

You'll see the following:

  * Check in with your HCP Packer Registry
  * Loading the initial Ubuntu image
  * Running the Ansible playbook
    * Update `apt`
    * Install `nginx`
  * Clean up

The final output should look like:

```
==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.ubuntu-image: AMIs were created:
us-east-1: ami-#################

--> amazon-ebs.ubuntu-image: AMIs were created:
us-east-1: ami-#################

--> amazon-ebs.ubuntu-image: Published metadata to HCP Packer registry packer/aws-nginx/iterations/##########################
```

You can navigate the HCP Packer UI to see the new `aws-nginx` image bucket.  Inside that, there will be one iteration called `v1`.

## Image Channel

The new image is referencable by the specific iteration ID (and calling on the AMI ID directly).  But there are few things to consider:

  * If a new AMI is published, users might have to update code/variables to use the new ID.
  * If a data source is being used to lookup the latest AMI, an AMI will potentially be live as soon as it's created; this might not be favorable.
  * You may want to centrally control what teams get what image version without them having to update their own code.

The way we do this is by creating a channel in HCP Packer.  [Create a new channel named "test"](https://learn.hashicorp.com/tutorials/packer/hcp-image-channels?in=packer/hcp-get-started#add-channels-to-the-image-bucket).  Set the image iteration to the only `v1` iteration that currently exists.

## Initial Terraform Deploy

Switch over the the `terraform_files/aws/` directory.  You'll need to set a couple variables.  This can be done by creating a `terraform.tfvars` file, CLI, or supplying through TFC/E.  An example variables file:

```
owner  = "ranjit"
vpc_id = "vpc-#####"
```

Put your name again and select the VPC you'd like to build into.  The run:

```
terraform init
terraform apply
```

### Result

You're looking for something like this:

```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

hcp_ami_id = "ami-#################"
hcp_bucket_id = "XXXXXXXXXXXXXXXXXXXXXXXXXX"
public_dns = "ec2-##-##-###-#.compute-1.amazonaws.com"
```

The first 2 values are just for debugging or to show how Terraform is dynamically finding it's way to the image to use.  Grab the `public_dns` value and load it in your browser.  You should see the default NGINX page.

## New Packer Iteration

While terraform is building the machine, it might be good to kick off the 2nd Packer build because it does take time.

```
# Create hash for this build
export HCP_PACKER_BUILD_FINGERPRINT="$(date +%s)-$(git hash-object aws-linux.pkr.hcl | cut -c -25)"

# Run build
packer build \
  -var "owner=<YOUR NAME>" \
  -var "version=1.0.1" \
  aws-linux.pkr.hcl
```

You *must* create a new hash for this new build.  Increment the version value if you'd like.

## Test Terraform

After Packer completes the 2nd time, you should have 2 iterations in your image bucket.  But the `test` channel is still pinned to `v1`.  Try running a `terraform plan` and you should see that there is nothing to do.

```
No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your configuration and the remote system(s). As a result, there are no actions to
take.
```

## Update Channel

Go back to the HCP Packer UI and navigate to the `test` channel.  Update the iteration to `v2` instead.  Try Terraform again.  You can run a `plan` to see the change if you don't want to do a rebuild to save time.

```
Plan: 1 to add, 0 to change, 1 to destroy.
```

NOTE: The VM will be destroyed and re-created because that's the only way AWS can adjust this.

## Pipeline

For those customers that want to add Packer to a pipeline and not initiate it over CLI, I have a Travis-CI example:

[https://app.travis-ci.com/github/WhatsARanjit/packer-ansible-simple](https://app.travis-ci.com/github/WhatsARanjit/packer-ansible-simple/builds/245980926)