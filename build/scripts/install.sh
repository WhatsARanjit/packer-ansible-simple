# Defaults
PACKER_VERSION=${PACKER_VERSION:-"1.7.10"}
ANSIBLE_VERSION=${ANSIBLE_VERSION:-"2.9.27-1ppa~bionic"}
TERRAFORM_VERSION=${TERRAFORM_VERSION:-"1.1.5"}

# Apt
## Common
export DEBIAN_FRONTEND=noninteractive
apt-get -y -qq update > /dev/null
apt-get install -y -qq unzip curl jq > /dev/null
apt-get install -y -qq software-properties-common > /dev/null

## Packer
curl -sk -o packer.zip -L "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
unzip packer.zip
install packer /usr/local/bin

## Ansible
add-apt-repository -y ppa:ansible/ansible > /dev/null
apt-get install -y -qq ansible=$ANSIBLE_VERSION > /dev/null

## Terraform
curl -sk -o terraform.zip -L "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip terraform.zip
install terraform /usr/local/bin
