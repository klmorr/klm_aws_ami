#!/bin/bash

if [[ $(command -v "yum" ) ]];then
    sudo yum update -y
    sudo amazon-linux-extras enable ansible2
    sudo yum install python3 zip unzip ansible jq python3-pip -y
    sudo pip install --upgrade pip
    sudo yum install -y ansible
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    if ! [[ $( sudo systemctl status amazon-ssm-agent ) ]];then
        sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    fi
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
    if ! [[ $( sudo systemctl snap.amazon-ssm-agent.service) ]];then
        sudo snap list amazon-ssm-agent
        sudo snap start amazon-ssm-agent
    fi

else
    echo "package manager not in script"
fi