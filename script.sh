#!/bin/bash

#step1 - prepare vm (install terraform ansible)
#step2 - run terraform code
#step3 - get IP and update inventory file
#step4 - run ansible

function prepare_vm() {
    sudo apt update
    sudo apt install ansible -y
    if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]
    then
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    fi
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
} 

function create_ec2() {
    cd ~/project-may-2025/terraform
    terraform init
    terraform apply -auto-approve
}

function update_ip() {
    terraform output -raw ec2 > ../ansible/hosts

}

prepare_vm
create_ec2
update_ip