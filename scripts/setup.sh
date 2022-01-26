# Apt

## Common
sudo apt -yq update
sudo apt-get install -y unzip curl jq
sudo apt install -yq software-properties-common

## Ansible
sudo add-apt-repository --yes ppa:ansible/ansible
sudo apt install -y ansible

## Packer
curl -o packer.zip -L "https://releases.hashicorp.com/packer/1.7.9/packer_1.7.9_linux_amd64.zip"
unzip packer.zip
sudo install packer /usr/local/bin
