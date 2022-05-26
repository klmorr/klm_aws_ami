#!/bin/bash

if [[ $(command -v "yum" ) ]];then
    sudo yum update -y
    sudo amazon-linux-extras enable ansible2
    sudo yum install python3 unzip ansible jq python-pip -y
    sudo pip install --upgrade pip
    sudo yum install -y ansible
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    exit $?
elif [[ $(command -v "apt") ]];then
    sudo apt update && upgrade && apt dist-upgrade -y
    sudo apt-get install software-properties-common -y
    sudo apt-get install python3 -y
    sudo apt-get install python3-pip -y
    sudo apt-get install awscli -y
    sudo apt-get install jq -y
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get update -y
    sudo apt-get install ansible -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    exit $?
else
    echo "package manager not in script"
    exit 1
fi