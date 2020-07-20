#!/bin/bash
wget https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip
unzip terraform_0.12.28_linux_amd64.zip
chmod +x terraform
sudo cp terraform /usr/local/bin
rm terraform
rm terraform_0.12.28_linux_amd64.zip